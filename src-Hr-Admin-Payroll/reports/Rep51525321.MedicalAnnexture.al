report 51525321 "Medical Annexture"
{
    ApplicationArea = All;
    Caption = 'Medical Annexture';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/reports/layouts/MedicalAnnexture.rdlc';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";//, "Payroll Country";
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
            column(MedicalNo; "NHIF No.")//RAMA
            {
            }
            column(PensionNo; "NSSF No.")//CSR
            { }
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
            column(TotalRemuneration; TotalRemuneration)
            { }
            column(TotalContribution; TotalContribution)
            { }
            column(DaysWorked; DaysWorked)
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
                DaysWorked := 0;
                TotalRemuneration := 0;
                TotalContribution := 0;

                AssignmentMatrix.Reset();
                AssignmentMatrix.SetRange("Employee No", Employee."No.");
                AssignmentMatrix.SetRange("Payroll Period", PayrollPeriod);
                if SelectedPayrollCountry <> '' then
                    AssignmentMatrix.SetFilter(Country, SelectedPayrollCountry);
                //AssignmentMatrix.SetRange(Code, 'D03'); //Medical
                //AssignmentMatrix.SetFilter(Country, 'RWANDA|CABIN|EXPATRIATE');
                if AssignmentMatrix.FindSet() then
                    repeat
                        TransAmount += Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", AssignmentMatrix.Country, ABS(AssignmentMatrix.Amount)));
                        if AssignmentMatrix."Medical Insurance Deduction" /*.Code = 'D03'*/ then //Medical
                            begin
                            TotalContribution += TransAmount;
                            if TransAmount > 0 then
                                SkipEmployee := false;
                        end;
                        if (AssignmentMatrix.Type = AssignmentMatrix.Type::Payment) and (not AssignmentMatrix."Non-Cash Benefit") and (AssignmentMatrix."Basic Salary Code") then //Basic
                            TotalRemuneration += TransAmount;
                        //Less transport allowance - hard-code for now
                        /*if AssignmentMatrix."Transport Allowance" //.Code IN ['R4', 'E04']// then //Transport
                            TotalRemuneration := (TotalRemuneration - TransAmount);*/
                        TransAmount := 0;
                    until AssignmentMatrix.Next() = 0;
                if SkipEmployee then
                    CurrReport.SKIP()
                else
                    DaysWorked := getDaysWorked(Employee."No.");
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
        DaysWorked: Integer;
        TotalRemuneration: Decimal;
        TotalContribution: Decimal;
        SelectedPayrollCountry: Code[100];
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

    procedure getDaysWorked(EmpNo: Code[100]) TotDaysWorked: Integer
    var
        StartDt: Date;
        EndDt: Date;
        EmpMovement: Record "Internal Employement History";//Staff Movement
    begin
        TotDaysWorked := 0;
        StartDt := PayrollPeriod;
        EndDt := CalcDate('<CM>', PayrollPeriod);
        EmpMovement.Reset();
        EmpMovement.SetRange("Emp No.", EmpNo);
        EmpMovement.SetFilter(Status, '<>%1', EmpMovement.Status::Pending);
        EmpMovement.SetFilter("First Date", '<=%1', StartDt);//As long as first date is earlier than the end of this month
        EmpMovement.SetFilter("Last Date", '>=%1', EndDt);//Last date must be greater than or equal to start date of this period
        EmpMovement.SetFilter(Type, '%1|%2', EmpMovement.Type::"August 2023", EmpMovement.Type::Initial);
        if EmpMovement.FindSet() then
            repeat
                if EmpMovement."First Date" > StartDt then
                    StartDt := EmpMovement."First Date";
                if EmpMovement."Last Date" < EndDt then
                    EndDt := EmpMovement."Last Date";
            until EmpMovement.Next = 0;
        if (StartDt <> 0D) and (EndDt <> 0D) then
            TotDaysWorked := (EndDt - StartDt) + 1;
        exit(TotDaysWorked);
    end;

}