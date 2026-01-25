report 51525320 "CBHI Annexture"
{
    ApplicationArea = All;
    Caption = 'CBHI Annexture';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/reports/layouts/CBHIAnnexture.rdlc';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Payroll Country";
            column(No; "No.")
            { }
            column(FirstName; "First Name")
            {
            }
            column(MiddleName; "Middle Name")
            {
            }
            column(LastName; "Last Name")
            {
            }
            column(NSSFNo; "NSSF No.")
            {
            }
            column(NationalID; "National ID")
            {
            }
            column(CashAllowanceTransport; CashAllowanceTransport)
            {
            }
            column(CashAllowanceHouse; CashAllowanceHouse)
            {
            }
            column(OtherCashAllowance; OtherCashAllowance)
            {
            }
            column(TerminalBenefits; TerminalBenefits)
            {
            }
            column(PAYETaxableBase; PAYETaxableBase)
            {
            }
            column(PAYEDeductable; PAYEDeductable)
            {
            }
            column(BasicSalary; BasicSalary)
            {
            }
            column(PayPeriod; FORMAT(PayrollPeriod, 0, '<month text> <year4>'))
            {
            }
            column(EmployeeCBHISubsidies; EmployeeCBHISubsidies)
            {
            }
            column(DesiredCurrency; DesiredCurrency)
            { }
            column(RAMA; RAMA)
            { }

            trigger OnAfterGetRecord()
            begin
                BasicSalary := 0;
                CashAllowanceTransport := 0;
                CashAllowanceHouse := 0;
                OtherCashAllowance := 0;
                TerminalBenefits := 0;
                PAYETaxableBase := 0;
                PAYEDeductable := 0;
                EmployeeCBHISubsidies := 0;
                TransAmount := 0;
                SkipEmployee := true;
                RAMA := 'Y';
                if (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI) then
                    RAMA := 'N';

                AssignmentMatrix.Reset();
                //AssignmentMatrix.SetRange(Code,'D05');//CBHI
                AssignmentMatrix.SetRange("Employee No", Employee."No.");
                AssignmentMatrix.SetRange("Payroll Period", PayrollPeriod);
                if SelectedPayrollCountry <> '' then
                    AssignmentMatrix.SetFilter(Country, SelectedPayrollCountry);
                //AssignmentMatrix.SetFilter(Country, 'RWANDA|CABIN|EXPATRIATE');
                if AssignmentMatrix.FindSet() then
                    repeat
                        if AssignmentMatrix.Country = 'CABIN' then
                            RAMA := 'N';
                        TransAmount := Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", AssignmentMatrix.Country, ABS(AssignmentMatrix.Amount)));
                        if TransAmount > 0 then
                            SkipEmployee := false;
                        if AssignmentMatrix."Basic Salary Code" /*AssignmentMatrix.Code IN ['R2', 'E01', 'E1']*/ then //Basic
                            BasicSalary += TransAmount; //Round(ABS(AssignmentMatrix.Amount));
                        if AssignmentMatrix."Transport Allowance" /*.Code IN ['R4', 'E04']*/ then //Transport
                            CashAllowanceTransport += TransAmount; //Round(ABS(AssignmentMatrix.Amount));
                        if AssignmentMatrix."Housing Allowance" /*.Code IN ['R3', 'E02', 'E2']*/ then //House allowance
                            CashAllowanceHouse += TransAmount; //Round(ABS(AssignmentMatrix.Amount));
                        if (not AssignmentMatrix."Basic Salary Code" and not AssignmentMatrix."Transport Allowance" and not AssignmentMatrix."Housing Allowance"  /*NOT (AssignmentMatrix.Code IN ['R3', 'E02', 'E2', 'R2', 'E01', 'E1', 'R4', 'E04'])*/) and (AssignmentMatrix.Type = AssignmentMatrix.Type::Payment) and AssignmentMatrix."Is Flat Amount" = true then //Other cash allowance - any other flat entry
                            OtherCashAllowance += TransAmount; //Round(ABS(AssignmentMatrix.Amount));

                        //if AssignmentMatrix/*."Transaction Title" = 'CHBI'*/.Code = 'D05' then //CBHI
                        if (AssignmentMatrix."Is CBHI" /*CBHIDeductionsCode.Contains(AssignmentMatrix.Country + '=>'+AssignmentMatrix.Code)*/) and (AssignmentMatrix.Type = AssignmentMatrix.Type::Deduction) then
                            EmployeeCBHISubsidies += TransAmount; //Round(ABS(AssignmentMatrix.Amount));

                        if AssignmentMatrix.Paye = true then begin
                            PAYETaxableBase += Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", AssignmentMatrix.Country, ABS(AssignmentMatrix."Taxable amount")));//Taxable
                            PAYEDeductable += TransAmount; //Round(ABS(AssignmentMatrix.Amount));//PAYE
                        end;
                        TransAmount := 0;
                    until AssignmentMatrix.Next() = 0;

                if EmployeeCBHISubsidies = 0 then
                    SkipEmployee := true;

                if SkipEmployee then
                    CurrReport.SKIP();
            end;

            trigger OnPreDataItem()
            begin
                if (not CanEditPaymentInfo) and (PayrollPeriod = CurrentPeriod) then
                    Error('Payroll for this period is still being processed. Kindly try again later!');
                //Employee.SetFilter("Payroll Country", 'RWANDA|CABIN|EXPATRIATE'); //Country may change
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
            }
        }
        actions
        {
            area(processing)
            {
            }
        }

        trigger OnOpenPage()
        begin
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                PayrollPeriod := Periods."Starting Date";

            CurrentPeriod := PayrollPeriod;
        end;
    }

    var
        AssignmentMatrix: Record "Assignment Matrix";
        PayrollPeriod: Date;
        BasicSalary: Decimal;
        CashAllowanceTransport: Decimal;
        CashAllowanceHouse: Decimal;
        OtherCashAllowance: Decimal;
        TerminalBenefits: Decimal;
        PAYETaxableBase: Decimal;
        PAYEDeductable: Decimal;
        EmployeeCBHISubsidies: Decimal;

        localCurrencyCode: Code[50];
        GenLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        ExchangeRate: Decimal;
        PayrollCountryCurrency: Code[100];
        DesiredCurrency: Code[100];
        PayrollCountry: Record "Country/Region";
        TransAmount: Decimal;
        SkipEmployee: Boolean;
        CBHIDeductionsCode: List of [Text];
        TransportEarningsCode: List of [Text];
        DeductionCodes: Record Deductions;
        EarningCodes: Record Earnings;
        SelectedPayrollCountry: Code[100];
        RAMA: Code[10];
        UserSetup: Record "User Setup";
        CanEditPaymentInfo: Boolean;
        CurrentPeriod: Date;
        Periods: Record "Payroll Period";

    trigger OnInitReport()
    begin
        GenLedgerSetup.Get();
        localCurrencyCode := GenLedgerSetup."LCY Code";
        ExchangeRate := 1;
        if localCurrencyCode = '' then
            Error('The local currency code has not been specified in the General Ledger Setup!');
        DesiredCurrency := localCurrencyCode;

        CanEditPaymentInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";

        //Initialize the transaction codes for all countries here - hard-code where necessary for efficiency
        /*Clear(CBHIDeductionsCode);
        CBHIDeductionsCode := CBHIDeductionsCode.List;
        DeductionCodes.Reset();
        DeductionCodes.SetRange("Universal Title",'CBHI');
        if DeductionCodes.Findset() then
            repeat
                if not CBHIDeductionsCode.Contains(DeductionCodes.Country + '=>'+DeductionCodes.Code) then
                    CBHIDeductionsCode.Add(DeductionCodes.Country + '=>'+DeductionCodes.Code);
            until DeductionCodes.Next() = 0;*/
    end;


    Procedure GetInDesiredCurrency(CountryCurrency: Code[50]; CountryChosen: Code[50]; AmountToConvert: Decimal) ConvertedAmount: Decimal
    begin
        if CountryCurrency = '' then begin
            PayrollCountry.Reset();
            PayrollCountry.SetRange(Code, CountryChosen);
            if PayrollCountry.FindFirst() then begin
                CountryCurrency := PayrollCountry."Country Currency";
                if CountryCurrency = '' then
                    Error('You must set the country currency for %1', CountryChosen);
            end;
        end;

        if DesiredCurrency = CountryCurrency then
            ConvertedAmount := AmountToConvert
        else begin
            if PayrollPeriod = 0D then
                Error('You must select the payroll period before proceeding!');
            CurrExchangeRateDate := CalcDate('1M', PayrollPeriod);
            Fcy1ToLcyRate := 0;
            LcyToFcy2Rate := 0;

            //We want to convert the currency from the earning currency to the desired currency
            //1. Get the FCY1 to LCY rate
            /*if "Earning Currency" = localCurrencyCode then
                Fcy1ToLcyRate := 1
            else begin*/
            CurrencyExchangeRate.GetLastestExchangeRateCustom(CountryCurrency, CurrExchangeRateDate, Fcy1ToLcyRate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', CountryCurrency, localCurrencyCode);
            //end;

            //2. Get the LCY to FCY2 rate
            CurrencyExchangeRate.GetLastestExchangeRateCustom(DesiredCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, DesiredCurrency);

            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
            if LcyToFcy2Rate <> 0 then
                ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
            ConvertedAmount := AmountToConvert * ExchangeRate;
        end;
        exit(ConvertedAmount);
    end;

}