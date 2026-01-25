report 51525350 "Monthly Payroll Summary"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Empl; Employee)
        {
            //Indentation := 1;
            //RequestFilterFields = "No.";//, "Responsibility Center", "Sub Responsibility Center";

            trigger OnAfterGetRecord()
            begin
            end;


            trigger OnPostDataItem()
            var
                ThisTransTotal: Decimal;
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                //Before closing window - capture the totals for each column 
                //Window.CLOSE;
                ExcelBuffer.SetFriendlyFilename('Monthly Payroll Summary from ' + FORMAT(StartPayrollPeriod, 0, '<Month Text> <Year4>') + ' to ' + FORMAT(EndPayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency + ' as at ' + FORMAT(CurrentDateTime, 0, '<Month Text> <Day,2> <Year4>  <Hours24,2>-<Minutes,2> Hrs'));
                HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, 'Monthly Payroll Summary from ' + FORMAT(StartPayrollPeriod, 0, '<Month Text> <Year4>') + ' to ' + FORMAT(EndPayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency, '');
            end;

            trigger OnPreDataItem()
            begin
                //Window.OPEN('Preparing payroll data for ##############################1 \ Progress: #2###', EmployeeName, PercentProcessed);
                if DesiredCurrency = '' then
                    Error('You must select the desired output currency!');
                if StartPayrollPeriod = 0D then
                    Error('You must select the start payroll period/month!');
                if EndPayrollPeriod = 0D then
                    Error('You must select the end payroll period/month!');
                PayrollProcessed := false;

                SelectedCountry_Currency := '';
                PayCountries.Reset();
                PayCountries.SetRange(Code, SelectedPayrollCountry);
                if PayCountries.FindFirst() then
                    SelectedCountry_Currency := PayCountries."Country Currency";

                if (not CanEditPaymentInfo) and (StartPayrollPeriod = CurrentPeriod) then
                    Error('Payroll for this period is still being processed. Kindly try again later!');

                ExcelBuffer.DELETEALL;
                HeadingsCaptured := false;
                Empl.SETRANGE("No.", 'NOTHINGXXYY');
                //AllEmployeesCount := Empl.Count;
                ProcessedEmployeesCount := 0;
                serialNo := 0;

                RoundValue := 1;
                if DesiredCurrency = 'USD' then
                    RoundValue := 0.01;

                //We'll loop through two levels of iterations
                ExcelBuffer.AddColumn(UpperCase('Monthly Payroll Summary from ' + FORMAT(StartPayrollPeriod, 0, '<Month Text> <Year4>') + ' to ' + FORMAT(EndPayrollPeriod, 0, '<Month Text> <Year4>') + ' in ' + DesiredCurrency), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                RowNumber := 1;
                while RowNumber < 18 do begin
                    //this goes through the rows
                    totalpay := 0;
                    ExcelBuffer.NewRow;
                    if RowNumber = 1 then
                        ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 2 then
                        ExcelBuffer.AddColumn('Crew Cost', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 3 then
                        ExcelBuffer.AddColumn('Pilot salaries', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 4 then
                        ExcelBuffer.AddColumn('cabin crew salaries', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 5 then
                        ExcelBuffer.AddColumn('Air marshals salaries', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 6 then
                        ExcelBuffer.AddColumn('Pilot allowances(not on payroll)', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 7 then
                        ExcelBuffer.AddColumn('Cabin crew flight allowances', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 8 then
                        ExcelBuffer.AddColumn('Air marshals flight allowances', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 10 then
                        ExcelBuffer.AddColumn('OTHER STAFF COSTS', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 11 then
                        ExcelBuffer.AddColumn('Expatriate Salaries', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 12 then
                        ExcelBuffer.AddColumn('Staff Salaries - Rwanda payroll', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 13 then
                        ExcelBuffer.AddColumn('Outstation Salaries', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 14 then
                        ExcelBuffer.AddColumn('CSR Employer Contribution', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 15 then
                        ExcelBuffer.AddColumn('Employer Medical Contribution', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 16 then
                        ExcelBuffer.AddColumn('Terminal Benefits', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    if RowNumber = 17 then
                        ExcelBuffer.AddColumn('Other staff costs', FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    CurrMonth := StartPayrollPeriod;
                    while ((CurrMonth <= CalcDate('1M', EndPayrollPeriod)) and (RowNumber in [1, 3, 4, 5, 11, 12, 13, 14, 15])) do begin
                        //Looping through the columns now
                        TransAmount := 0;
                        ExchangeRate := GetInDesiredCurrency(/*AssignmentMatrix."Country Currency"*/SelectedCountry_Currency, DesiredCurrency, 0, CurrMonth);
                        if CurrMonth <= EndPayrollPeriod then begin
                            if RowNumber = 1 then begin
                                ExcelBuffer.AddColumn(Format(CurrMonth, 0, '<Month Text,3>-<Year4>'), FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;

                            if RowNumber = 3 then begin //Pilot salaries
                                PeriodMovements.Reset();
                                PeriodMovements.SetRange("Payroll Period", CurrMonth);
                                PeriodMovements.SetRange("Section Code", 'PILOTS');
                                if PeriodMovements.FindSet() then
                                    repeat
                                        AssignmentMatrix.RESET;
                                        AssignmentMatrix.SETRANGE("Employee No", PeriodMovements."Emp No.");
                                        //AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                        AssignmentMatrix.SETRANGE("Payroll Period", CurrMonth);
                                        //AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                                        AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                                        AssignmentMatrix.SetRange("Do Not Deduct", false);
                                        AssignmentMatrix.SetRange("Tax Relief", false);
                                        AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                        AssignmentMatrix.SetRange("Reduces Gross", false);
                                        AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                        if AssignmentMatrix.FindSet then
                                            repeat
                                                //ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, CurrMonth);
                                                TransAmount += abs(AssignmentMatrix.Amount) * ExchangeRate;
                                            until AssignmentMatrix.Next() = 0;
                                    until PeriodMovements.Next() = 0;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;

                            if RowNumber = 4 then begin //Cabin crew
                                PeriodMovements.Reset();
                                PeriodMovements.SetRange("Payroll Period", CurrMonth);
                                PeriodMovements.SetRange("Section Code", 'CABIN CREW');
                                if PeriodMovements.FindSet() then
                                    repeat
                                        AssignmentMatrix.RESET;
                                        AssignmentMatrix.SETRANGE("Employee No", PeriodMovements."Emp No.");
                                        //AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                        AssignmentMatrix.SETRANGE("Payroll Period", CurrMonth);
                                        //AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                                        AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                                        AssignmentMatrix.SetRange("Do Not Deduct", false);
                                        AssignmentMatrix.SetRange("Tax Relief", false);
                                        AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                        AssignmentMatrix.SetRange("Reduces Gross", false);
                                        AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                        if AssignmentMatrix.FindSet then
                                            repeat
                                                //ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, CurrMonth);
                                                TransAmount += abs(AssignmentMatrix.Amount) * ExchangeRate;
                                            until AssignmentMatrix.Next() = 0;
                                    until PeriodMovements.Next() = 0;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;

                            if RowNumber = 5 then begin //Air Marshals
                                /*PeriodMovements.Reset();
                                PeriodMovements.SetRange("Payroll Period", CurrMonth);
                                PeriodMovements.SetFilter("Section Code", 'MARSHALL');
                                if PeriodMovements.FindSet() then
                                    repeat*/
                                AssignmentMatrix.RESET;
                                //AssignmentMatrix.SETRANGE("Employee No", PeriodMovements."Emp No.");
                                //AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", CurrMonth);
                                AssignmentMatrix.setrange(Country, 'CABIN');
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                                AssignmentMatrix.SetRange("Do Not Deduct", false);
                                AssignmentMatrix.SetRange("Tax Relief", false);
                                AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                AssignmentMatrix.SetRange("Reduces Gross", false);
                                AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                if AssignmentMatrix.FindSet then
                                    repeat
                                        //ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, CurrMonth);
                                        TransAmount += abs(AssignmentMatrix.Amount) * ExchangeRate;
                                    until AssignmentMatrix.Next() = 0;
                                //until PeriodMovements.Next() = 0;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;

                            if RowNumber = 11 then begin //Expat - but remove cabin
                                PeriodMovements.Reset();
                                PeriodMovements.SetRange("Payroll Period", CurrMonth);
                                PeriodMovements.SetFilter("Section Code", '<>%1&<>%2', 'PILOTS', 'CABIN CREW');
                                if PeriodMovements.FindSet() then
                                    repeat
                                        AssignmentMatrix.RESET;
                                        //AssignmentMatrix.SETRANGE("Employee No", PeriodMovements."Emp No.");
                                        //AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                        AssignmentMatrix.SETRANGE("Payroll Period", CurrMonth);
                                        AssignmentMatrix.setrange(Country, 'EXPATRIATE');
                                        AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                                        AssignmentMatrix.SetRange("Do Not Deduct", false);
                                        AssignmentMatrix.SetRange("Tax Relief", false);
                                        AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                        AssignmentMatrix.SetRange("Reduces Gross", false);
                                        AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                        if AssignmentMatrix.FindSet then
                                            repeat
                                                //ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, CurrMonth);
                                                TransAmount += abs(AssignmentMatrix.Amount) * ExchangeRate;
                                            until AssignmentMatrix.Next() = 0;
                                    until PeriodMovements.Next() = 0;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;

                            if RowNumber = 12 then begin //Local
                                PeriodMovements.Reset();
                                PeriodMovements.SetRange("Payroll Period", CurrMonth);
                                PeriodMovements.SetFilter("Section Code", '<>%1&<>%2', 'PILOTS', 'CABIN CREW');
                                if PeriodMovements.FindSet() then
                                    repeat
                                        AssignmentMatrix.RESET;
                                        //AssignmentMatrix.SETRANGE("Employee No", PeriodMovements."Emp No.");
                                        //AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                        AssignmentMatrix.SETRANGE("Payroll Period", CurrMonth);
                                        AssignmentMatrix.setrange(Country, 'RWANDA');
                                        AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                                        AssignmentMatrix.SetRange("Do Not Deduct", false);
                                        AssignmentMatrix.SetRange("Tax Relief", false);
                                        AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                        AssignmentMatrix.SetRange("Reduces Gross", false);
                                        AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                        if AssignmentMatrix.FindSet then
                                            repeat
                                                //ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, CurrMonth);
                                                TransAmount += abs(AssignmentMatrix.Amount) * ExchangeRate;
                                            until AssignmentMatrix.Next() = 0;
                                    until PeriodMovements.Next() = 0;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;

                            if RowNumber = 13 then begin //Outstation
                                /*PeriodMovements.Reset();
                                PeriodMovements.SetRange("Payroll Period", CurrMonth);
                                PeriodMovements.SetFilter("Section Code", 'MARSHALL');
                                if PeriodMovements.FindSet() then
                                    repeat*/
                                AssignmentMatrix.RESET;
                                //AssignmentMatrix.SETRANGE("Employee No", PeriodMovements."Emp No.");
                                //AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", CurrMonth);
                                AssignmentMatrix.setfilter(Country, '<>%1&<>%2&<>%3', 'RWANDA', 'CABIN', 'EXPATRIATE');
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                                AssignmentMatrix.SetRange("Do Not Deduct", false);
                                AssignmentMatrix.SetRange("Tax Relief", false);
                                AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                AssignmentMatrix.SetRange("Reduces Gross", false);
                                AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                if AssignmentMatrix.FindSet then
                                    repeat
                                        //ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, CurrMonth);
                                        TransAmount += abs(AssignmentMatrix.Amount) * ExchangeRate;
                                    until AssignmentMatrix.Next() = 0;
                                //until PeriodMovements.Next() = 0;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;

                            if RowNumber = 14 then begin //CSR Employer
                                /*PeriodMovements.Reset();
                                PeriodMovements.SetRange("Payroll Period", CurrMonth);
                                PeriodMovements.SetFilter("Section Code", 'MARSHALL');
                                if PeriodMovements.FindSet() then
                                    repeat*/
                                AssignmentMatrix.RESET;
                                //AssignmentMatrix.SETRANGE("Employee No", PeriodMovements."Emp No.");
                                //AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", CurrMonth);
                                //AssignmentMatrix.setrange(Country, 'EXPATRIATE');
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange(Retirement, true);
                                AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                /*AssignmentMatrix.SetRange("Tax Relief", false);
                                AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                AssignmentMatrix.SetRange("Reduces Gross", false);*/
                                if AssignmentMatrix.FindSet then
                                    repeat
                                        //ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, CurrMonth);
                                        TransAmount += abs(AssignmentMatrix."Employer Amount") * ExchangeRate;
                                    until AssignmentMatrix.Next() = 0;
                                //until PeriodMovements.Next() = 0;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;

                            if RowNumber = 15 then begin //Employer medical
                                /*PeriodMovements.Reset();
                                PeriodMovements.SetRange("Payroll Period", CurrMonth);
                                PeriodMovements.SetFilter("Section Code", 'MARSHALL');
                                if PeriodMovements.FindSet() then
                                    repeat*/
                                AssignmentMatrix.RESET;
                                //AssignmentMatrix.SETRANGE("Employee No", PeriodMovements."Emp No.");
                                //AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", CurrMonth);
                                //AssignmentMatrix.setrange(Country, 'EXPATRIATE');
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange("Medical Insurance Deduction", true);
                                /*AssignmentMatrix.SetRange("Tax Relief", false);
                                AssignmentMatrix.SetRange("Non-Cash Benefit", false);
                                AssignmentMatrix.SetRange("Reduces Gross", false);*/
                                AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                if AssignmentMatrix.FindSet then
                                    repeat
                                        //ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, CurrMonth);
                                        TransAmount += abs(AssignmentMatrix."Employer Amount") * ExchangeRate;
                                    until AssignmentMatrix.Next() = 0;
                                //until PeriodMovements.Next() = 0;
                                ExcelBuffer.AddColumn(ABS(Round(TransAmount, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                            end;
                            totalpay += TransAmount;

                        end else begin //Totals
                            if RowNumber = 1 then
                                ExcelBuffer.AddColumn('Total', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text)
                            else
                                ExcelBuffer.AddColumn(ABS(Round(totalpay, RoundValue)), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        end;

                        CurrMonth := CalcDate('1M', CurrMonth);
                    end;
                    RowNumber += 1;
                end;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Month"; StartPayrollPeriod)
                {
                    TableRelation = "Payroll Period";
                }
                field("End Month"; EndPayrollPeriod)
                {
                    TableRelation = "Payroll Period";
                }
                field("Select Currency"; DesiredCurrency)
                {
                    Tablerelation = Currency;
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
                EndPayrollPeriod := Periods."Starting Date";

            StartPayrollPeriod := CalcDate('-1M', EndPayrollPeriod);
            CurrentPeriod := StartPayrollPeriod;
            DesiredCurrency := 'RWF';

            RoundValue := 1;
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
        StartPayrollPeriod: Date;
        EndPayrollPeriod: Date;
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
        RowNumber: Integer;
        CurrMonth: Date;
        PeriodMovements: Record "Period Prevailing Movement";
        PayCountries: Record "Country/Region";
        SelectedCountry_Currency: Code[50];

    procedure SetReportFilter(NewPayrollPeriod: Date; InitialCountry: Code[50])
    begin
        StartPayrollPeriod := NewPayrollPeriod;
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