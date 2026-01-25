report 51525309 "Payroll Bank Advice - Simp"
{
    Caption = 'Payroll Bank Advice';
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/PayrollBankAdviceSimplified.rdlc';

    dataset
    {
        dataitem("Employee PayrollL"; /*Employee*/"Employee Period Bank Details")
        {
            //DataItemTableView = WHERE(/*Status = FILTER(Active), */Board = CONST(false));
            RequestFilterFields = "Emp No.";//"No.";//, "Payment/Bank Country";
            column(Serial_EmployeePayrollL; "Employee PayrollL"."Emp No."/*"No."*/)
            {
            }
            column(No; Serial)
            {
            }
            column(EmpNo; "Employee PayrollL"."Emp No."/*"No."*/)
            { }
            column(Names; "Employee PayrollL"."Last Name" + ' ' + "Employee PayrollL"."Middle Name" + ' ' + "Employee PayrollL"."First Name")
            {
            }
            column(BankName_EmployeePayrollL; "Employee PayrollL"."Bank Name")
            {
            }
            column(BankBrachName_EmployeePayrollL; "Employee PayrollL"."Branch Name"/*"Bank Brach Name"()*/)
            {
            }
            column(BankAccountNo_EmployeePayrollL; BankAccountNo)
            {
            }
            column(IBAN; "Employee PayrollL".IBAN)
            {
            }
            column(Payroll_Country; "Employee PayrollL"."Payroll Country")
            {
            }
            column(Bank_Country; SelectedPaymentBankCountry/*"Employee PayrollL"."Payment/Bank Country"*/)
            {
            }
            column(SWIFT_Code; "Employee PayrollL"."SWIFT Code")
            { }
            column(Sort_Code; "Sort Code")
            { }
            column(Indicatif; Indicatif)
            { }
            column(Code_B_I_C_; "Code B.I.C.")
            { }
            column(CompName; CompInf.Name)
            {
            }
            column(CompAddress; CompInf.Address)
            {
            }
            column(CompCity; CompInf.City)
            {
            }
            column(CompPicture; CompInf.Picture)
            {
            }
            column(ReportTitle; ReportTitle)
            {

            }
            column(PayrollCountryTitle; PayrollCountryTitle)
            { }
            column(BankName; BankName)
            {
            }
            column(NetPay; /*NewPayslipReport.ChckRound(Format(*/NetPay/*Round(NetPay, RoundValue)*/)//, RoundValue))
            { }
            column(OutputCurrency; OutputCurrency)
            { }
            column(ShowBranchDetails; ShowBranchDetails)
            { }
            column(ShowIndicatiffBic; ShowIndicatiffBic)
            { }

            trigger OnAfterGetRecord()
            begin
                /*if "Employee PayrollL".getfilter("Payment/Bank Country") = '' then
                    Error('You must select the payment/bank country!');*/
                Serial := Serial + 1;
                RoundValue := 1;
                if OutputCurrency = 'USD' then
                    RoundValue := 0.01;

                BankAccountNo := "Employee PayrollL"."Bank Account No."/*"Bank Account No"*/;
                /*if BankAccountNo = '' then
                    BankAccountNo := "Employee PayrollL"."Bank Account No.";*/
                if "Employee PayrollL"."Payroll Country" = '' then begin
                    if EmpRec.Get("Employee PayrollL"."Emp No.") then
                        "Employee PayrollL"."Payroll Country" := EmpRec."Payroll Country";
                end;

                NetPay := 0;
                SpecificBankNetPay := 0;
                Allowances := 0;
                Deductions := 0;
                TransAmount := 0;
                CurrExchangeRateDate := CalcDate('1M', PayPeriod);

                //Currency Conversions
                if OutputCurrency = '' then
                /*OutputCurrency := "Employee PayrollL"."Payment/Bank Currency";
            if OutputCurrency = '' then //If still blank*/
                begin
                    Countries.Reset();
                    Countries.SetRange(Code, SelectedPaymentBankCountry/*"Employee PayrollL"."Payment/Bank Country"*/);
                    if countries.FindFirst() then begin
                        if countries."Country Currency" = '' then
                            Error('You must specify the currency for country ' + SelectedPaymentBankCountry/*"Employee PayrollL"."Payment/Bank Country"*/);
                        OutputCurrency := countries."Country Currency";
                    end;
                end;

                transactions.Reset();
                transactions.SetRange("Payroll Period", PayPeriod);
                transactions.SetFilter("Employee No", "Employee PayrollL"."Emp No."/*."No."*/);
                transactions.SetRange("Tax Relief", false);//Ignore personal relief
                transactions.SetRange("Do Not Deduct", false);
                transactions.SetRange("Non-Cash Benefit", false);
                transactions.SetRange("Exclude from Payroll", false);
                if transactions.FindSet() then
                    repeat
                        TransAmount := Abs(transactions.Amount);
                        if transactions."Country Currency" = '' then begin
                            //transactions."Country Currency" := "Employee PayrollL"."Payroll Currency";                                
                            Countries.Reset();
                            Countries.SetRange(Code, transactions.Country/*"Employee PayrollL"."Payment/Bank Country"*/);
                            if countries.FindFirst() then begin
                                if countries."Country Currency" = '' then
                                    Error('You must specify the currency for country ' + transactions.Country/*"Employee PayrollL"."Payment/Bank Country"*/);
                                transactions."Country Currency" := countries."Country Currency";
                            end;
                        end;
                        if transactions."Country Currency" = '' then
                            Error('You must populate the Payroll Currency for Employee %1!', "Employee PayrollL"."Emp No."/*."No."*/);

                        //Currency conversions
                        if ((OutputCurrency <> '') and (OutputCurrency <> transactions."Country Currency")) then begin
                            Fcy1ToLcyRate := 0;
                            LcyToFcy2Rate := 0;
                            ExchangeRate := 1;

                            //1. Get the FCY1 to LCY rate
                            CurrencyExchangeRate.GetLastestExchangeRateCustom(transactions."Country Currency", CurrExchangeRateDate, Fcy1ToLcyRate);
                            if (CurrExchangeRateDate = 0D) then
                                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', transactions."Country Currency", localCurrencyCode);

                            //2. Get the LCY to FCY2 rate
                            CurrencyExchangeRate.GetLastestExchangeRateCustom(OutputCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
                            if (CurrExchangeRateDate = 0D) then
                                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, OutputCurrency);

                            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
                            if LcyToFcy2Rate <> 0 then
                                ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
                            TransAmount := TransAmount * ExchangeRate;
                        end;

                        TransAmount := ROUND(TransAmount, RoundValue);
                        if transactions.Type = transactions.Type::Deduction then
                            Deductions := Deductions + TransAmount;

                        if transactions.Type = transactions.Type::Payment then begin
                            if transactions."Non-Cash Benefit" = false then
                                Allowances := Allowances + TransAmount;
                        end;
                    until transactions.Next() = 0;

                NetPay := Allowances - Deductions;
                TotalBankNets := 0;
                SpecificBankNetPay := 0;
                EmpPeriodBankDetails.Reset();
                EmpPeriodBankDetails.SetRange("Emp No.", "Employee PayrollL"."Emp No.");
                EmpPeriodBankDetails.SetRange("Payroll Period", PayPeriod);
                if EmpPeriodBankDetails.FindSet() then
                    repeat
                        TotalBankNets += ABS(GetInDesiredCurrency(EmpPeriodBankDetails."Bank Currency", OutputCurrency, EmpPeriodBankDetails.Amount, PayPeriod));
                    until EmpPeriodBankDetails.Next() = 0;
                if (TotalBankNets > 0) and (TotalBankNets > NetPay) then
                    Error('The amounts specified in the Extra Payroll Banks for %1 exceed their total net pay for %2', "Employee PayrollL"."Emp No.", Format(PayPeriod, 0, '<Month Text> <Year4>'));
                if "Employee PayrollL".Amount <> 0 then
                    NetPay := "Employee PayrollL".Amount
                else
                    NetPay := NetPay - TotalBankNets;

                //NetPay := ROUND(NetPay, RoundValue);

                //Capture title details
                if not TitleCaptured then begin
                    PayrollCountryTitle := 'Payroll Country';
                    PayrollTitle := 'Payroll BankPay for ' + /*"Employee PayrollL"."Payment/Bank Country"*/SelectedPaymentBankCountry;
                    if SelectedPaymentBankCountry = 'CABIN' then begin
                        PayrollTitle := 'Allowances BankPay for Cabin Marshalls';
                        PayrollCountryTitle := 'Country';
                    end;
                    ReportTitle := PayrollTitle + ' for ' + UpperCase(FORMAT(PayPeriod, 0, ' <Month Text> <Year4>') + ' | Currency: ' + OutputCurrency);
                    TitleCaptured := true;
                end;

                if NetPay = 0 then
                    CurrReport.Skip();
            end;


            trigger OnPreDataItem()
            begin
                Serial := 0;
                if SelectedPaymentBankCountry = '' then
                    Error('You must select the payment/bank country!');
                "Employee PayrollL".SetRange("Bank Country", SelectedPaymentBankCountry);
                "Employee PayrollL".SetRange("Payroll Period", PayPeriod);

                if (not CanEditPaymentInfo) and (PayPeriod = CurrentPeriod) then
                    Error('Payroll for this period is still being processed. Kindly try again later!');
                /*NetPay := 0;
                Allowances := 0;
                Deductions := 0;*/
                //"Employee PayrollL".SETRANGE(Status, "Employee PayrollL".Status::Active);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Payroll period"; PayPeriod)
                {
                    Caption = 'Select Period';
                    TableRelation = "Payroll Period";
                }
                field("Bank Country"; SelectedPaymentBankCountry)
                {
                    Tablerelation = "Country/Region";
                }
                field("Display Currency"; OutputCurrency)
                {
                    Tablerelation = Currency;
                }
                field(ShowBranchDetails; ShowBranchDetails)
                {
                    Caption = 'Show Bank Branch Details';
                }
                field(ShowIndicatiffBic; ShowIndicatiffBic)
                {
                    Caption = 'Show Indicatif and Code B.I.C.';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ShowBranchDetails := false;
            ShowIndicatiffBic := false;
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                PayPeriod := Periods."Starting Date";

            CurrentPeriod := PayPeriod;
            RoundValue := 1;

            if OutputCurrency = '' then begin
                Countries.Reset();
                Countries.SetRange(Code, SelectedPaymentBankCountry/*"Employee PayrollL"."Payment/Bank Country"*/);
                if countries.FindFirst() then begin
                    if countries."Country Currency" = '' then
                        Error('You must specify the currency for country ' + SelectedPaymentBankCountry/*"Employee PayrollL"."Payment/Bank Country"*/);
                    OutputCurrency := countries."Country Currency";
                end;
            end;
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

    trigger OnPreReport()
    begin
        CompInf.Get();
        CompInf.CalcFields(Picture);
    end;

    procedure SetReportFilter(NewPayrollPeriod: Date; InitialCountry: Code[50])
    begin

        PayPeriod := NewPayrollPeriod;
        if PayPeriod = 0D then begin
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                PayPeriod := Periods."Starting Date";
        end;

        SelectedPaymentBankCountry := InitialCountry;
        if OutputCurrency = '' then begin
            Countries.Reset();
            Countries.SetRange(Code, SelectedPaymentBankCountry/*"Employee PayrollL"."Payment/Bank Country"*/);
            if countries.FindFirst() then begin
                if countries."Country Currency" = '' then
                    Error('You must specify the currency for country ' + SelectedPaymentBankCountry/*"Employee PayrollL"."Payment/Bank Country"*/);
                OutputCurrency := countries."Country Currency";
            end;
        end;
    end;

    var
        Counter: Integer;
        hremployee: Record Employee;
        transactions: Record "Assignment Matrix";
        twotthirds: Decimal;
        totalpay: Decimal;
        totalductions: Decimal;
        transactionsX: Record "Assignment Matrix";
        GrossAmount: Decimal;
        BasicPay: Decimal;
        Allowances: Decimal;
        Deductions: Decimal;
        NetPay: Decimal;
        SpecificBankNetPay: Decimal;
        TotalBankNets: Decimal;
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
        CompInf: Record "Company Information";
        ReportTitle: Code[100];
        PayrollTitle: Code[100];
        PayrollCountryTitle: Code[100];
        TitleCaptured: Boolean;
        PayPeriod: Date;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        ExchangeRate: Decimal;
        OutputCurrency: Code[50];
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        GenLedgerSetup: Record "General Ledger Setup";
        localCurrencyCode: Code[50];
        ShowBranchDetails: Boolean;
        ShowIndicatiffBic: Boolean;
        Countries: Record "Country/Region";
        TransAmount: Decimal;
        RoundValue: Decimal;
        NewPayslipReport: Report "New Payslip";
        ExtraPayrollBank: Record "Extra Payroll Banks";
        EmpPeriodBankDetails: Record "Employee Period Bank Details";
        EmpPeriodBankDetailsInit: Record "Employee Period Bank Details";
        SelectedPaymentBankCountry: Code[100];
        EmpRec: Record Employee;
        UserSetup: Record "User Setup";
        CanEditPaymentInfo: Boolean;
        CurrentPeriod: Date;


    Procedure GetInDesiredCurrency(EarningCountryCurrency: Code[50]; SelectedCountryCurrency: Code[50]; AmountToConvert: Decimal; PayDate: Date) ConvertedAmount: Decimal
    begin
        if OutputCurrency = '' then
            OutputCurrency := SelectedCountryCurrency;
        if EarningCountryCurrency = '' then
            EarningCountryCurrency := SelectedCountryCurrency;

        ConvertedAmount := AmountToConvert;
        if OutputCurrency = EarningCountryCurrency then
            ConvertedAmount := AmountToConvert
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
            CurrencyExchangeRate.GetLastestExchangeRateCustom(OutputCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, OutputCurrency);

            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
            if LcyToFcy2Rate <> 0 then
                ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
            ConvertedAmount := AmountToConvert * ExchangeRate;
        end;
        exit(ConvertedAmount);
    end;
}