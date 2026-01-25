report 51525351 "Detailed Monthly Payroll Stat"
{
    ProcessingOnly = true;
    Caption = 'Detailed MP Report';

    dataset
    {
        dataitem(Comp; "Company Information")
        {
            RequestFilterHeading = 'Detailed MP Report';

            trigger OnAfterGetRecord()
            var
                TransactionTitles: Record "Payroll Universal Trans Codes";
                PayrollCountries: Record "Country/Region";
                EmpTotal: Decimal;
                DeductionsTotal: Decimal;
                GrossAmount: Decimal;
                NetAmount: Decimal;
                EmpCountry: Code[50];
            begin
                RoundValue := 1;
                if DesiredCurrency = 'USD' then
                    RoundValue := 0.01;
                ExcelBuffer.AddColumn(UpperCase('Detailed Monthly Payroll Summary for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn('#', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('WB', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Names', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Payroll Country', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Department', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Cost Center', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Grade', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Position', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Section', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Contract Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                Window.OPEN('Preparing data for ##############################1 \ Progress: #2###', EmployeeName, PercentProcessed);
                TransactionTitles.Reset();
                TransactionTitles.SetCurrentKey("Display Order");
                TransactionTitles.SetAscending("Display Order", TRUE);
                TransactionTitles.SetRange("Transaction Type", TransactionTitles."Transaction Type"::Earning);
                TransactionTitles.SetFilter(Title, '<>%1', 'GROSS PAY');
                if TransactionTitles.FindSet() then
                    repeat
                        ExcelBuffer.AddColumn(TransactionTitles.Description, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    until TransactionTitles.Next() = 0;
                if ShowNet then begin
                    //Not asked but let me just add
                    ExcelBuffer.AddColumn('Gross Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Total Deductions', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Net Pay', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                end;

                ExcelBuffer.AddColumn('Employer Pension', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Employer Maternity Leave', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn('Employer Medical', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                //Loop through staff now
                serialNo := 0;
                Employee.Reset();
                if Employee.FindSet() then
                    repeat
                        EmpTotal := 0;
                        GrossAmount := 0;
                        DeductionsTotal := 0;
                        NetAmount := 0;
                        ProcessedEmployeesCount += 1;
                        Window.UPDATE(1, Employee."First Name" + ' ' + Employee."Last Name");
                        Window.UPDATE(2, Format(ROUND(ProcessedEmployeesCount / AllEmployeesCount * 100, 1)) + '%');

                        transactionsT.Reset();
                        transactionsT.SetRange("Employee No", Employee."No.");
                        transactionsT.SetRange("Payroll Period", PayrollPeriod);
                        if transactionsT.FindFirst() then begin
                            EmpCountry := '';
                            DeptCode := '';
                            Grade := '';
                            PeriodMovements.Reset();
                            PeriodMovements.SetRange("Payroll Period", PayrollPeriod);
                            PeriodMovements.SetRange("Emp No.", Employee."No.");
                            if PeriodMovements.FindFirst() then begin
                                EmpCountry := PeriodMovements."Payroll Country";
                                DeptCode := PeriodMovements."Dept Code";
                                Grade := PeriodMovements."Salary Scale";
                            end;
                            if DeptCode = '' then
                                DeptCode := Employee."Responsibility Center";
                            if Grade = '' then
                                Grade := Employee."Salary Scale";
                            if EmpCountry = '' then
                                EmpCountry := Employee."Payroll Country";

                            ExcelBuffer.NewRow;
                            serialNo += 1;
                            ExcelBuffer.AddColumn(serialNo, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);
                            ExcelBuffer.AddColumn(Employee."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Employee."Last Name" + ' ' + Employee."First Name" + ' ' + Employee."Middle Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(EmpCountry, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(DeptCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(DeptCode, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Grade, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            Employee.Validate(Position);
                            ExcelBuffer.AddColumn(Employee."Job Title", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Employee."Sub Responsibility Center", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            ExcelBuffer.AddColumn(Employee."Contract Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            TransactionTitles.Reset();
                            TransactionTitles.SetCurrentKey("Display Order");
                            TransactionTitles.SetAscending("Display Order", TRUE);
                            TransactionTitles.SetRange("Transaction Type", TransactionTitles."Transaction Type"::Earning);
                            TransactionTitles.SetFilter(Title, '<>%1', 'GROSS PAY');
                            if TransactionTitles.FindSet() then
                                repeat
                                    TransAmount := 0;
                                    Earnings.Reset();
                                    Earnings.setrange(Country, EmpCountry);
                                    Earnings.SetRange("Universal Title", TransactionTitles.Title);
                                    if Earnings.FindFirst() then begin
                                        AssignmentMatrix.RESET;
                                        AssignmentMatrix.SETRANGE("Employee No", Employee."No.");
                                        AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                        AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                        AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                        AssignmentMatrix.SetRange("Tax Relief", false);
                                        AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                        AssignmentMatrix.setrange(Country, EmpCountry);
                                        IF AssignmentMatrix.FINDFIRST then
                                            TransAmount := abs(AssignmentMatrix.Amount) * GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, PayrollPeriod);
                                    end;
                                    EmpTotal += TransAmount;
                                    GrossAmount += TransAmount;
                                    ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                                until TransactionTitles.Next() = 0;

                            //Get deductions for displaying net
                            if ShowNet then begin
                                ExcelBuffer.AddColumn(ABS(Round(GrossAmount, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);

                                TransAmount := 0;
                                AssignmentMatrix.RESET;
                                AssignmentMatrix.SETRANGE("Employee No", Employee."No.");
                                AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                AssignmentMatrix.setrange(Country, EmpCountry);
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                if AssignmentMatrix.FindSet() then
                                    repeat
                                        TransAmount := abs(AssignmentMatrix.Amount) * GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, PayrollPeriod);
                                        DeductionsTotal += TransAmount;
                                    until AssignmentMatrix.Next() = 0;
                                NetAmount := GrossAmount - DeductionsTotal;
                                ExcelBuffer.AddColumn(ABS(Round(DeductionsTotal, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                                ExcelBuffer.AddColumn(ABS(Round(NetAmount, RoundValue)), FALSE, '', TRUE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                            end;


                            //Employer deductions
                            TransAmount := 0;
                            DeductionsRec.Reset();
                            DeductionsRec.SetRange(country, EmpCountry);
                            DeductionsRec.SetRange("Pension Scheme", true);
                            if DeductionsRec.FindFirst() then begin
                                AssignmentMatrix.RESET;
                                AssignmentMatrix.SETRANGE("Employee No", Employee."No.");
                                AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                AssignmentMatrix.setrange(Country, EmpCountry);
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                if AssignmentMatrix.FindFirst() then
                                    TransAmount := abs(AssignmentMatrix."Employer Amount") * GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, PayrollPeriod);

                                EmpTotal += TransAmount;
                            end;
                            ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);

                            TransAmount := 0;
                            DeductionsRec.Reset();
                            DeductionsRec.SetRange(country, EmpCountry);
                            DeductionsRec.SetRange("Universal Title", 'MATERNITY LEAVE DEDUCTION');
                            if DeductionsRec.FindFirst() then begin
                                AssignmentMatrix.RESET;
                                AssignmentMatrix.SETRANGE("Employee No", Employee."No.");
                                AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                AssignmentMatrix.setrange(Country, EmpCountry);
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                if AssignmentMatrix.FindFirst() then
                                    TransAmount := abs(AssignmentMatrix."Employer Amount") * GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, PayrollPeriod);

                                EmpTotal += TransAmount;
                            end;
                            ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);

                            TransAmount := 0;
                            DeductionsRec.Reset();
                            DeductionsRec.SetRange(country, EmpCountry);
                            DeductionsRec.SetRange("Medical Insurance", true);
                            if DeductionsRec.FindFirst() then begin
                                TransAmount := 0;
                                AssignmentMatrix.RESET;
                                AssignmentMatrix.SETRANGE("Employee No", Employee."No.");
                                AssignmentMatrix.SETRANGE(Code, DeductionsRec.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                AssignmentMatrix.setrange(Country, EmpCountry);
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                if AssignmentMatrix.FindFirst() then
                                    TransAmount := abs(AssignmentMatrix."Employer Amount") * GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, PayrollPeriod);

                                EmpTotal += TransAmount;
                            end;
                            ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '0.00', ExcelBuffer."Cell Type"::Number);
                            //ExcelBuffer.AddColumn(ABS(Round(EmpTotal, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Number);

                        end;
                    until Employee.next() = 0;

            end;


            trigger OnPostDataItem()
            var
                ThisTransTotal: Decimal;
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                //Before closing window - capture the totals for each column                
                //ExcelBuffer.NewRow;
                //ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                //ExcelBuffer.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                //ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                //We could do the vertical totals but that'll force through another round of conversions which will slow the process
                Window.CLOSE;
                ExcelBuffer.SetFriendlyFilename('Detailed Monthly Payroll Summary for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency + ' as at ' + FORMAT(CurrentDateTime, 0, '<Month Text> <Day,2> <Year4>  <Hours24,2>-<Minutes,2> Hrs'));
                HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, 'Detailed Monthly Payroll for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency, '');
            end;

            trigger OnPreDataItem()
            begin
                if DesiredCurrency = '' then
                    Error('You must select output currency!');
                if PayrollPeriod = 0D then
                    Error('You must select payroll period!');
                PayrollProcessed := false;

                if (not CanEditPaymentInfo) and (PayrollPeriod = CurrentPeriod) then
                    Error('Payroll for this period is still being processed. Kindly try again later!');

                ExcelBuffer.DELETEALL;
                Employee.Reset();
                //Employee.SETRANGE(Status, Employee.Status::Active);
                AllEmployeesCount := Employee.Count;
                ProcessedEmployeesCount := 0;
                serialNo := 0;
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
                field("Select Currency"; DesiredCurrency)
                {
                    Tablerelation = Currency;
                }
                field("Show Net Amount"; ShowNet)
                {
                }

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
            DesiredCurrency := 'RWF';

            RoundValue := 1;
            ShowDeptGrade := false;
            HideDeductions := false;
            HideNet := false;
            ShowCSRMedEmp := false;
            ShowNet := false;

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
        ShowNet: Boolean;

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
        ExchangeRate := 0;
        ExchRate := 1;
        if SelectedCountryCurrency/*DesiredCurrency*/ = EarningCountryCurrency then
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