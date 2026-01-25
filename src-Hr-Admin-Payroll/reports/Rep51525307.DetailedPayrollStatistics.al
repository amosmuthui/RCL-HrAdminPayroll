report 51525307 "Detailed Payroll Statistics"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Empl; Employee)
        {
            //Indentation := 1;
            RequestFilterFields = "No.";//, "Responsibility Center", "Sub Responsibility Center";

            trigger OnAfterGetRecord()
            begin
                //Create the first row - just capture the pay period on the first column
                Window.UPDATE(1, Empl."First Name" + ' ' + Empl."Last Name"/*PayProcessHeader."Payroll Period"*/);//' + Empl."Middle Name" + ' 
                Window.UPDATE(2, Format(ROUND(ProcessedEmployeesCount / AllEmployeesCount * 100, 1)) + '%');
                ProcessedEmployeesCount += 1;
                if ProcessedEmployeesCount <= 20 then //If more than 20 then probably a whole country was selected
                begin
                    if EmpFilterText = '' then
                        EmpFilterText := Empl."No."
                    else
                        EmpFilterText := EmpFilterText + '|' + Empl."No.";
                end else
                    EmpFilterText := '';

                if not HeadingsCaptured then begin
                    PayrollCountry.Reset();
                    PayrollCountry.SetRange(Code, SelectedPayrollCountry);
                    PayrollCountry.SetFilter("Country Currency", '<>%1', '');
                    if PayrollCountry.FindFirst() then begin
                        PayrollCountryCurrency := PayrollCountry."Country Currency";
                        if PayrollCountryCurrency = '' then
                            Error('You must set the country currency for %1', SelectedPayrollCountry);
                        if DesiredCurrency = '' then
                            DesiredCurrency := PayrollCountryCurrency;
                        //ReportTitle := ReportTitle + ' | CURRENCY: ' + DesiredCurrency;
                    end else
                        Error('You must set the country currency for %1', SelectedPayrollCountry);

                    ExchangeRate := GetInDesiredCurrency(PayrollCountryCurrency, DesiredCurrency, 0, PayrollPeriod);

                    ReportTitle := 'Payroll';
                    if SelectedPayrollCountry = 'CABIN' then
                        ReportTitle := 'Allowances';
                    ExcelBuffer.AddColumn(UpperCase(SelectedPayrollCountry + ' ' + ReportTitle + ' Summary for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    //2nd row has headings. Use loop to capture earnings and deductions
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn('#', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('WB', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Names', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if ShowDoB then
                        ExcelBuffer.AddColumn('D.o.B', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    //If we are showing department and grade
                    if ShowDeptGrade then begin
                        ExcelBuffer.AddColumn('Department', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Cost Center', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Grade', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    end;

                    //List earnings
                    Earnings.RESET;
                    Earnings.SETCURRENTKEY("Display Order");
                    Earnings.SETASCENDING("Display Order", TRUE);
                    Earnings.setrange(Country, SelectedPayrollCountry);
                    Earnings.SetRange("Exclude from Payroll", false);
                    IF Earnings.FINDSET THEN BEGIN
                        REPEAT
                            if (Earnings."Is Contractual Amount" and Earnings."Goes to Matrix") or (not Earnings."Is Contractual Amount") then
                                ExcelBuffer.AddColumn(Earnings.Description, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        UNTIL Earnings.NEXT = 0;
                    END;

                    //Add deductions that reduce gross
                    if not HideDeductions then begin
                        DeductionsRec.RESET;
                        DeductionsRec.SETCURRENTKEY("Display Order");
                        DeductionsRec.SETASCENDING("Display Order", TRUE);
                        DeductionsRec.setrange(Country, SelectedPayrollCountry);
                        DeductionsRec.SetRange("Reduces Gross", true);
                        IF DeductionsRec.FINDSET THEN BEGIN
                            REPEAT
                                ExcelBuffer.AddColumn(DeductionsRec.Description/* + '(Reduces Gross)'*/, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            UNTIL DeductionsRec.NEXT = 0;
                        END;
                    end;
                    //Add gross amount                    
                    ExcelBuffer.AddColumn('Gross Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    //if BURUNDI, ZIMBABWE also display Taxable amount
                    if SelectedPayrollCountry in ['BURUNDI', 'ZIMBABWE'] then
                        ExcelBuffer.AddColumn('Taxable Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);


                    //List deductions
                    if not HideDeductions then begin
                        DeductionsRec.RESET;
                        DeductionsRec.SETCURRENTKEY("Display Order");
                        DeductionsRec.SETASCENDING("Display Order", TRUE);
                        DeductionsRec.setrange(Country, SelectedPayrollCountry);
                        DeductionsRec.SetRange("Reduces Gross", false);
                        IF DeductionsRec.FINDSET THEN BEGIN
                            REPEAT
                                ExcelBuffer.AddColumn(DeductionsRec.Description, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            UNTIL DeductionsRec.NEXT = 0;
                        END;
                        //Add total ded and net pay                  
                        ExcelBuffer.AddColumn('Total Deductions', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    end;
                    if not HideNet then
                        ExcelBuffer.AddColumn('Net Pay', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if ShowCSRMedEmp then begin
                        ExcelBuffer.AddColumn('CSR Employer Deduction', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Employer Medical Contribution', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    end;


                    HeadingsCaptured := true;
                end;
                //Headings done

                RoundValue := 1;
                if DesiredCurrency = 'USD' then
                    RoundValue := 0.01;

                //=============================================================================

                //If no transactions for that period, skip
                //FRD 26/07/24 - Optimization, this is not necessary, use the below
                transactionsT.Reset();
                transactionsT.SetRange(Country, SelectedPayrollCountry);
                transactionsT.SetRange("Employee No", Empl."No.");
                transactionsT.SetRange("Payroll Period", PayrollPeriod);
                if transactionsT.FindFirst() then begin
                    ExcelBuffer.NewRow;
                    serialNo += 1;
                    ExcelBuffer.AddColumn(serialNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                    ExcelBuffer.AddColumn(Empl."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Empl."Last Name" + ' ' + Empl."First Name" + ' ' + Empl."Middle Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    if ShowDoB then
                        ExcelBuffer.AddColumn(Format(Empl."Date Of Birth", 0, '<Day,2>/<Month,2>/<Year4>'), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    //If we are showing department and grade
                    if ShowDeptGrade then begin
                        DeptCode := '';
                        Grade := '';
                        PeriodMovements.Reset();
                        PeriodMovements.SetRange("Payroll Period", PayrollPeriod);
                        PeriodMovements.SetRange("Emp No.", Empl."No.");
                        if PeriodMovements.FindFirst() then begin
                            DeptCode := PeriodMovements."Dept Code";
                            Grade := PeriodMovements."Salary Scale";
                        end;
                        if DeptCode = '' then
                            DeptCode := Empl."Responsibility Center";
                        if Grade = '' then
                            Grade := Empl."Salary Scale";

                        ExcelBuffer.AddColumn(DeptCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(DeptCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(Grade, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    end;

                    //Capture the earnings for this employee and period
                    Allowances := 0;
                    BasicPay := 0;
                    Deductions := 0;
                    NetPay := 0;
                    NonCashAmount := 0;
                    DeductionsThatReduceGross := 0;
                    RoundValue := 1;

                    Earnings.RESET;
                    Earnings.SETCURRENTKEY("Display Order");
                    Earnings.SETASCENDING("Display Order", TRUE);
                    Earnings.setrange(Country, SelectedPayrollCountry);
                    Earnings.SetRange("Exclude from Payroll", false);
                    IF Earnings.FINDSET THEN BEGIN
                        REPEAT
                            if (Earnings."Is Contractual Amount" and Earnings."Goes to Matrix") or (not Earnings."Is Contractual Amount") then begin
                                TransAmount := 0;
                                //The matrices now                                
                                AssignmentMatrix.RESET;
                                AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                                AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                                AssignmentMatrix.SetRange("Do Not Deduct", false);
                                AssignmentMatrix.SetRange("Tax Relief", false);
                                IF AssignmentMatrix.FINDFIRST then begin
                                    TransAmount := abs(AssignmentMatrix.Amount) * ExchangeRate;
                                    if ((AssignmentMatrix.Type = AssignmentMatrix.Type::Payment) and (AssignmentMatrix."Basic Salary Code" = false) and (AssignmentMatrix."Non-Cash Benefit" = false) and (AssignmentMatrix."Tax Relief" = false) and (AssignmentMatrix."Reduces Gross" = false)) then begin
                                        Allowances += TransAmount;
                                        AllowancesTotal += Allowances;
                                    end;

                                    if AssignmentMatrix."Basic Salary Code" = true then begin
                                        BasicPay += TransAmount;
                                    end;
                                end;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                            end;
                        until Earnings.Next() = 0;
                    end;

                    //Deductions that reduce gross
                    if not (HideDeductions and HideNet) then begin
                        DeductionsRec.Reset();
                        DeductionsRec.SETCURRENTKEY("Display Order");
                        DeductionsRec.SETASCENDING("Display Order", TRUE);
                        DeductionsRec.setrange(Country, SelectedPayrollCountry);
                        DeductionsRec.SetRange("Reduces Gross", true);
                        IF DeductionsRec.FINDSET THEN BEGIN
                            REPEAT
                                TransAmount := 0;
                                //The matrices now
                                AssignmentMatrix.RESET;
                                AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                                AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange("Do Not Deduct", false);
                                AssignmentMatrix.SetRange("Tax Relief", false);
                                IF AssignmentMatrix.FINDFIRST then begin
                                    TransAmount := abs(AssignmentMatrix.Amount) * ExchangeRate;
                                    DeductionsThatReduceGross += TransAmount;
                                end;
                                if not HideDeductions then
                                    ExcelBuffer.AddColumn(-ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                            until DeductionsRec.Next() = 0;
                        end;
                    end;

                    //Gross amount
                    GrossAmount := BasicPay + Allowances - DeductionsThatReduceGross;
                    ExcelBuffer.AddColumn(ABS(Round(GrossAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);

                    //if BURUNDI,ZIMBABWE also display Taxable amount
                    TaxableAmount := 0;
                    if SelectedPayrollCountry in ['BURUNDI', 'ZIMBABWE'] then begin
                        DeductionsRec.Reset();
                        DeductionsRec.setrange(Country, SelectedPayrollCountry);
                        DeductionsRec.SetRange("PAYE Code", true);
                        if DeductionsRec.FindFirst() then begin
                            AssignmentMatrix.RESET;
                            AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                            AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                            AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                            AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                            IF AssignmentMatrix.FINDFIRST then
                                TaxableAmount := abs(AssignmentMatrix."Taxable amount") * ExchangeRate;
                        end;
                        ExcelBuffer.AddColumn(ABS(Round(TaxableAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                    end;

                    //Normal Deductions
                    if not (HideDeductions and HideNet) then begin
                        DeductionsRec.Reset();
                        DeductionsRec.SETCURRENTKEY("Display Order");
                        DeductionsRec.SETASCENDING("Display Order", TRUE);
                        DeductionsRec.setrange(Country, SelectedPayrollCountry);
                        DeductionsRec.SetRange("Reduces Gross", false);
                        if DeductionsRec.FindSet() then begin
                            repeat
                                TransAmount := 0;
                                AssignmentMatrix.RESET;
                                AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                                AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange("Do Not Deduct", false);
                                AssignmentMatrix.SetRange("Tax Relief", false);
                                IF AssignmentMatrix.FINDFIRST then begin
                                    TransAmount := abs(AssignmentMatrix.Amount) * ExchangeRate;
                                    if (AssignmentMatrix.Type = AssignmentMatrix.Type::Deduction) and (AssignmentMatrix."Reduces Gross" = false) then begin
                                        Deductions += TransAmount;
                                    end;
                                end;
                                if not HideDeductions then
                                    ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                            until DeductionsRec.Next() = 0;
                        end;
                    end;

                    NetPay := GrossAmount - ABS(Deductions);
                    ExcelBuffer.AddColumn(ABS(Round(Deductions, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                    if not HideNet then
                        ExcelBuffer.AddColumn(ABS(Round(NetPay, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                    if ShowCSRMedEmp then begin
                        AssignmentMatrix.RESET;
                        AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                        AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                        AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                        AssignmentMatrix.SetRange(Retirement, true);
                        IF AssignmentMatrix.FINDFIRST then begin
                            TransAmount := abs(AssignmentMatrix."Employer Amount") * ExchangeRate;
                            ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                        end;

                        AssignmentMatrix.RESET;
                        AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                        AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                        AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                        AssignmentMatrix.SetRange("Medical Insurance Deduction", true);
                        IF AssignmentMatrix.FINDFIRST then begin
                            TransAmount := abs(AssignmentMatrix."Employer Amount") * ExchangeRate;
                            ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                        end;
                    end;
                END;

            end;


            trigger OnPostDataItem()
            var
                ThisTransTotal: Decimal;
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                //Before closing window - capture the totals for each column                
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                if ShowDoB then
                    ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                //If we are showing department and grade
                if ShowDeptGrade then begin
                    ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                end;

                AllowancesTotal := 0;
                BasicTotal := 0;
                GrossTotal := 0;
                TotalDeductions := 0;
                NonCashAmountTotal := 0;
                TotalDeductionsThatReduceGross := 0;

                RoundValue := 1;
                if DesiredCurrency = 'USD' then
                    RoundValue := 0.01;

                Earnings.RESET;
                Earnings.SETCURRENTKEY("Display Order");
                Earnings.SETASCENDING("Display Order", TRUE);
                Earnings.setrange(Country, SelectedPayrollCountry);
                Earnings.SetRange("Exclude from Payroll", false);
                IF Earnings.FINDSET THEN BEGIN
                    REPEAT
                        if (Earnings."Is Contractual Amount" and Earnings."Goes to Matrix") or (not Earnings."Is Contractual Amount") then begin
                            TransAmount := 0;
                            ThisTransTotal := 0;
                            //The matrices now                                
                            AssignmentMatrix.RESET;
                            AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                            AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                            AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                            if EmpFilterText <> '' then
                                AssignmentMatrix.SetFilter("Employee No", EmpFilterText);
                            AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                            AssignmentMatrix.SetRange("Do Not Deduct", false);
                            AssignmentMatrix.SetRange("Tax Relief", false);
                            IF AssignmentMatrix.findset() then begin
                                repeat
                                    TransAmount := abs(AssignmentMatrix.Amount) * ExchangeRate;
                                    ThisTransTotal += TransAmount;
                                    if ((AssignmentMatrix.Type = AssignmentMatrix.Type::Payment) and (AssignmentMatrix."Basic Salary Code" = false) and (AssignmentMatrix."Non-Cash Benefit" = false) and (AssignmentMatrix."Tax Relief" = false) and (AssignmentMatrix."Reduces Gross" = false)) then begin
                                        AllowancesTotal += TransAmount;
                                    end;

                                    if AssignmentMatrix."Basic Salary Code" = true then begin
                                        BasicTotal += TransAmount;
                                    end;
                                until AssignmentMatrix.Next() = 0;
                            end;
                            ExcelBuffer.AddColumn(ABS(Round(ThisTransTotal, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                        end;
                    until Earnings.Next() = 0;
                end;

                //Deductions that reduce gross
                if not (HideDeductions and HideNet) then begin
                    DeductionsRec.Reset();
                    DeductionsRec.SETCURRENTKEY("Display Order");
                    DeductionsRec.SETASCENDING("Display Order", TRUE);
                    DeductionsRec.setrange(Country, SelectedPayrollCountry);
                    DeductionsRec.SetRange("Reduces Gross", true);
                    IF DeductionsRec.FINDSET THEN BEGIN
                        REPEAT
                            TransAmount := 0;
                            ThisTransTotal := 0;
                            //The matrices now
                            AssignmentMatrix.RESET;
                            AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                            AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                            AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                            AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                            if EmpFilterText <> '' then
                                AssignmentMatrix.SetFilter("Employee No", EmpFilterText);
                            AssignmentMatrix.SetRange("Do Not Deduct", false);
                            AssignmentMatrix.SetRange("Tax Relief", false);
                            IF AssignmentMatrix.findset() then begin
                                repeat
                                    TransAmount := abs(AssignmentMatrix.Amount) * ExchangeRate;
                                    ThisTransTotal += TransAmount;
                                    TotalDeductionsThatReduceGross += TransAmount;
                                until AssignmentMatrix.Next() = 0;
                            end;
                            if not HideDeductions then
                                ExcelBuffer.AddColumn(-ABS(Round(ThisTransTotal, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                        until DeductionsRec.Next() = 0;
                    end;
                end;

                //Gross amount
                GrossTotal := BasicTotal + AllowancesTotal - TotalDeductionsThatReduceGross;
                ExcelBuffer.AddColumn(ABS(Round(GrossTotal, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);

                //if BURUNDI, ZIMBABWE also display Taxable amount
                TaxableTotal := 0;
                if SelectedPayrollCountry in ['BURUNDI', 'ZIMBABWE'] then begin
                    DeductionsRec.Reset();
                    DeductionsRec.setrange(Country, SelectedPayrollCountry);
                    DeductionsRec.SetRange("PAYE Code", true);
                    if DeductionsRec.FindFirst() then begin
                        AssignmentMatrix.RESET;
                        AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                        AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                        AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                        if EmpFilterText <> '' then
                            AssignmentMatrix.SetFilter("Employee No", EmpFilterText);
                        IF AssignmentMatrix.FindSet() then
                            repeat
                                TaxableTotal += abs(AssignmentMatrix."Taxable amount") * ExchangeRate;
                            until AssignmentMatrix.Next() = 0;
                    end;
                    ExcelBuffer.AddColumn(ABS(Round(TaxableTotal, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                end;

                //Normal Deductions
                if not (HideDeductions and HideNet) then begin
                    DeductionsRec.Reset();
                    DeductionsRec.SETCURRENTKEY("Display Order");
                    DeductionsRec.SETASCENDING("Display Order", TRUE);
                    DeductionsRec.setrange(Country, SelectedPayrollCountry);
                    DeductionsRec.SetRange("Reduces Gross", false);
                    if DeductionsRec.FindSet() then begin
                        repeat
                            TransAmount := 0;
                            ThisTransTotal := 0;
                            AssignmentMatrix.RESET;
                            AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                            AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                            AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                            AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                            if EmpFilterText <> '' then
                                AssignmentMatrix.SetFilter("Employee No", EmpFilterText);
                            AssignmentMatrix.SetRange("Do Not Deduct", false);
                            AssignmentMatrix.SetRange("Tax Relief", false);
                            IF AssignmentMatrix.FINDFIRST then begin
                                repeat
                                    TransAmount := abs(AssignmentMatrix.Amount) * ExchangeRate;
                                    ThisTransTotal += TransAmount;
                                    if (AssignmentMatrix.Type = AssignmentMatrix.Type::Deduction) and (AssignmentMatrix."Reduces Gross" = false) then begin
                                        TotalDeductions += TransAmount;
                                    end;
                                until AssignmentMatrix.Next() = 0;
                            end;
                            if not HideDeductions then
                                ExcelBuffer.AddColumn(ABS(Round(ThisTransTotal, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                        until DeductionsRec.Next() = 0;
                    end;
                end;
                if not HideDeductions then
                    ExcelBuffer.AddColumn(ABS(Round(TotalDeductions, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);

                NetPay := GrossTotal - ABS(TotalDeductions);
                if not HideNet then
                    ExcelBuffer.AddColumn(ABS(Round(NetPay, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);

                if ShowCSRMedEmp then begin
                    TransAmount := 0;
                    AssignmentMatrix.RESET;
                    AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                    AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                    AssignmentMatrix.SetRange(Retirement, true);
                    AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                    if EmpFilterText <> '' then
                        AssignmentMatrix.SetFilter("Employee No", EmpFilterText);
                    IF AssignmentMatrix.FindSet() then
                        repeat
                            TransAmount += (abs(AssignmentMatrix."Employer Amount") * ExchangeRate);
                        until AssignmentMatrix.Next() = 0;
                    ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);

                    TransAmount := 0;
                    AssignmentMatrix.RESET;
                    AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                    AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                    AssignmentMatrix.SetRange("Medical Insurance Deduction", true);
                    AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                    if EmpFilterText <> '' then
                        AssignmentMatrix.SetFilter("Employee No", EmpFilterText);
                    IF AssignmentMatrix.FINDFIRST then
                        repeat
                            TransAmount += (abs(AssignmentMatrix."Employer Amount") * ExchangeRate);
                        until AssignmentMatrix.Next() = 0;
                    ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                end;

                Window.CLOSE;
                ExcelBuffer.SetFriendlyFilename(SelectedPayrollCountry + ' Payroll Summary for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency + ' as at ' + FORMAT(CurrentDateTime, 0, '<Month Text> <Day,2> <Year4>  <Hours24,2>-<Minutes,2> Hrs'));
                HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, SelectedPayrollCountry + ' Payroll for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency, '');
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN('Preparing payroll data for ##############################1 \ Progress: #2###', EmployeeName, PercentProcessed);
                if SelectedPayrollCountry = '' then
                    Error('You must select payroll country!');
                if PayrollPeriod = 0D then
                    Error('You must select payroll period!');
                PayrollProcessed := false;

                if (not CanEditPaymentInfo) and (PayrollPeriod = CurrentPeriod) then
                    Error('Payroll for this period is still being processed. Kindly try again later!');

                ExcelBuffer.DELETEALL;
                HeadingsCaptured := false;
                Empl.SETRANGE(Board, false);
                AllEmployeesCount := Empl.Count;
                ProcessedEmployeesCount := 0;
                serialNo := 0;
                EmpFilterText := '';
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Payroll Period"; PayrollPeriod)
                {
                    TableRelation = "Payroll Period";
                }
                field("Payroll Country"; SelectedPayrollCountry)
                {
                    Tablerelation = "Country/Region";
                }
                field("Select Currency"; DesiredCurrency)
                {
                    Tablerelation = Currency;
                }
                field("Show Department and Grade"; ShowDeptGrade)
                {
                }
                field("Show Employer Deductions"; ShowCSRMedEmp)
                {
                }
                field("Hide Deductions"; HideDeductions)
                {
                }
                field("Hide Net Salary"; HideNet)
                {
                }
                field("Show Date of Birth"; ShowDoB)
                { }

            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                PayrollPeriod := Periods."Starting Date";

            CurrentPeriod := PayrollPeriod;

            RoundValue := 1;
            ShowDeptGrade := false;
            HideDeductions := false;
            HideNet := false;
            ShowCSRMedEmp := false;

            //Provide just one button call "Is MP Report"
            //Also totals for the employer deductions
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GenLedgerSetup.Get();
        localCurrencyCode := GenLedgerSetup."LCY Code";
        ExchangeRate := 1;
        if localCurrencyCode = '' then
            Error('The local currency code has not been specified in the General Ledger Setup!');

        CanEditPaymentInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Earnings: Record "Earnings";
        Employee: Record "Employee";
        DeductionsRec: Record "Deductions";
        EmployeeName: Text[230];
        PercentProcessed: Decimal;
        AllEmployeesCount: integer;
        ProcessedEmployeesCount: Integer;
        EmployeeRec: Record "Employee";
        AssignmentMatrix: Record "Assignment Matrix";
        Amount: Decimal;
        Window: Dialog;
        AccessibleCompanies: Text;
        LineNo: Integer;
        HeadingsCaptured: Boolean;
        PayrollPeriod: Date;
        CurrentPeriod: Date;
        CompInf: Record "Company Information";
        Counter: Integer;
        hremployee: Record Employee;
        transactions: Record "Assignment Matrix";
        twotthirds: Decimal;
        totalpay: Decimal;
        totalductions: Decimal;
        transactionsX: Record "Assignment Matrix";
        GrossAmount: Decimal;
        TaxableAmount: Decimal;
        BasicPay: Decimal;
        Allowances: Decimal;
        Deductions: Decimal;
        NetPay: Decimal;
        transactionsXX: Record "Assignment Matrix";
        transactionsXXX: Record "Assignment Matrix";
        Payes: Decimal;
        ThirdBasic: Decimal;
        Periods: Record "Payroll Period";
        Yname: Integer;
        BankName: Text[250];
        BankAccountNo: Code[60];
        Payroll: Record Employee;
        //Bank: Record "KBA Bank Names";
        Branch: Text[100];
        InsuranceRelief: Decimal;
        TaxRelief: Decimal;
        InsuranceTotal: Decimal;
        PayeTotal: Decimal;
        TaxTotal: Decimal;
        GrossTotal: Decimal;
        TaxableTotal: Decimal;
        BasicPays: Decimal;
        Payrolls: Record Employee;
        transactionsT: Record "Assignment Matrix";
        BasicTotal: Decimal;
        AllowancesTotal: Decimal;
        TotalRelief: Decimal;
        EmpName: Text[120];
        Serial: Integer;
        TotalGross: Decimal;
        transactionsTT: Record "Assignment Matrix";
        TotalDeductions: Decimal;
        transactionsXXXX: Record "Assignment Matrix";
        GrossDeductions: Decimal;
        transactionsXXXXX: Record "Assignment Matrix";
        IsNHIF: Boolean;
        IsNSSF: Boolean;
        IsHELB: Boolean;
        DedZ: Record Deductions;
        IsOther: Boolean;
        PayrollProcessed: Boolean;
        VoluntaryIns: Decimal;
        NonCashAmount: Decimal;
        NonCashAmountTotal: Decimal;
        CompanyDataCaptured: Boolean;
        ReportTitle: Text[250];
        TitleCaptured: Boolean;
        PayrollCountry: Record "Country/Region";
        CompanyInfo: Record "Company Information";
        localCurrencyCode: Code[50];
        GenLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        ExchangeRate: Decimal;
        PayrollCountryCurrency: Code[100];
        TransAmount: Decimal;
        DesiredCurrency: Code[100];
        RoundValue: Decimal;
        ApprovalEntriesCaptured: Boolean;
        ApprovalEntries: Record "Approval Entry";
        UserSetup: Record "User Setup";
        App1Name: Text[250];
        App1Date: Text[30];
        App1Signature: Record "User Setup";
        App2Name: Text[250];
        App2Date: Text[30];
        App2Signature: Record "User Setup";
        App3Name: Text[250];
        App3Date: Text[30];
        App3Signature: Record "User Setup";
        App4Name: Text[250];
        App4Date: Text[30];
        App4Signature: Record "User Setup";
        App5Name: Text[250];
        App5Date: Text[30];
        App5Signature: Record "User Setup";
        PayProcessHeader: Record "Payroll Processing Header";
        Emp: Record Employee;
        SelectedPayrollCountry: Code[100];
        DeductionsThatReduceGross: Decimal;
        TotalDeductionsThatReduceGross: Decimal;
        NewPayslipReport: Report "New Payslip";
        serialNo: Integer;
        CanEditPaymentInfo: Boolean;
        ShowDeptGrade: Boolean;
        ShowCSRMedEmp: Boolean;
        HideDeductions: Boolean;
        HideNet: Boolean;
        PeriodMovements: Record "Period Prevailing Movement";
        DeptCode: Code[240];
        Grade: Code[50];
        EmpFilterText: Text;
        ShowDoB: Boolean;
        HelperFunctions: Codeunit "Custom Helper Functions Base";

    procedure SetReportFilter(NewPayrollPeriod: Date; InitialCountry: Code[50])
    begin
        PayrollPeriod := NewPayrollPeriod;
        SelectedPayrollCountry := InitialCountry;
    end;


    Procedure GetInDesiredCurrency(EarningCountryCurrency: Code[50]; SelectedCountryCurrency: Code[50]; AmountToConvert: Decimal; PayDate: Date) /*ConvertedAmount*/ExchRate: Decimal
    begin
        if DesiredCurrency = '' then
            DesiredCurrency := SelectedCountryCurrency;
        if EarningCountryCurrency = '' then
            EarningCountryCurrency := SelectedCountryCurrency;

        //ConvertedAmount := AmountToConvert;
        ExchRate := 1;
        if DesiredCurrency = EarningCountryCurrency then
            ExchRate := 1//ConvertedAmount := AmountToConvert
        else begin
            CurrExchangeRateDate := CalcDate('1M', PayDate);
            Fcy1ToLcyRate := 0;
            LcyToFcy2Rate := 0;

            //We want to convert the currency from the earning currency to the desired currency
            //1. Get the FCY1 to LCY rate
            /*if "Earning Currency" = localCurrencyCode then
                Fcy1ToLcyRate := 1
            else begin*/
            CurrencyExchangeRate.GetLastestExchangeRateCustom(EarningCountryCurrency, CurrExchangeRateDate, Fcy1ToLcyRate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', EarningCountryCurrency, localCurrencyCode);
            //end;

            //2. Get the LCY to FCY2 rate
            CurrencyExchangeRate.GetLastestExchangeRateCustom(DesiredCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, DesiredCurrency);

            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
            if LcyToFcy2Rate <> 0 then
                ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
            //ConvertedAmount := AmountToConvert * ExchangeRate;
        end;
        if ExchangeRate = 0 then
            ExchangeRate := ExchRate
        else
            ExchRate := ExchangeRate;
        exit(/*ConvertedAmount*/ExchRate);
    end;
}