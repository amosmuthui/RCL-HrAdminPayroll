report 51525355 "TransAllowance Bank Advice"
{
    Caption = 'Transport Allowance Bank Advice';
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/TransportAllowanceBankAdvice.rdlc';

    dataset
    {
        dataitem("Employee PayrollL"; /*Employee*/"Employee Period Bank Details")
        {
            //DataItemTableView = WHERE(/*Status = FILTER(Active), */Board = CONST(false));
            RequestFilterFields = "Emp No.", "Bank Country";
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
            column(Designation; Designation)
            { }
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
            column(App1Name; App1Name)
            {
            }
            column(App1Date; App1Date)
            {
            }
            column(App1Signature; App1Signature.Signature)
            {
            }
            column(App2Name; App2Name)
            {
            }
            column(App2Date; App2Date)
            {
            }
            column(App2Signature; App2Signature.Signature)
            {
            }
            column(App3Name; App3Name)
            {
            }
            column(App3Date; App3Date)
            {
            }
            column(App3Signature; App3Signature.Signature)
            {
            }
            column(App4Name; App4Name)
            {
            }
            column(App4Date; App4Date)
            {
            }
            column(App4Signature; App4Signature.Signature)
            {
            }
            column(App5Name; App5Name)
            {
            }
            column(App5Date; App5Date)
            {
            }
            column(App5Signature; App5Signature.Signature)
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*if "Employee PayrollL".getfilter("Payment/Bank Country") = '' then
                    Error('You must select the payment/bank country!');*/
                if NoRepeatEmpList.Contains("Employee PayrollL"."Emp No.") then
                    CurrReport.Skip()
                else
                    NoRepeatEmpList.Add("Employee PayrollL"."Emp No.");

                Serial := Serial + 1;
                RoundValue := 1;
                if OutputCurrency = 'USD' then
                    RoundValue := 0.01;

                Designation := '';
                PeriodPrevailingMovements.Reset();
                PeriodPrevailingMovements.SetRange("Payroll Period", PayPeriod);
                PeriodPrevailingMovements.SetRange("Emp No.", "Employee PayrollL"."Emp No.");
                if PeriodPrevailingMovements.FindFirst() then
                    Designation := PeriodPrevailingMovements."Job Title";

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
                    OutputCurrency := "Employee PayrollL"."Bank Currency";
                if OutputCurrency = '' then //If still blank
                    begin
                    Countries.Reset();
                    Countries.SetRange(Code, /*SelectedPaymentBankCountry*/"Employee PayrollL"."Bank Country");
                    if countries.FindFirst() then begin
                        if countries."Country Currency" = '' then
                            Error('You must specify the currency for country ' + /*SelectedPaymentBankCountry*/"Employee PayrollL"."Bank Country");
                        OutputCurrency := countries."Country Currency";
                    end;
                end;

                transactions.Reset();
                transactions.SetRange("Payroll Period", PayPeriod);
                transactions.SetFilter("Employee No", "Employee PayrollL"."Emp No."/*."No."*/);
                /*transactions.SetRange("Tax Relief", false);//Ignore personal relief
                transactions.SetRange("Do Not Deduct", false);
                transactions.SetRange("Non-Cash Benefit", false);
                transactions.SetRange("Exclude from Payroll", false);*/
                transactions.SetRange("Special Transport Allowance", true);
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
                        NetPay += TransAmount;
                    /*if transactions.Type = transactions.Type::Deduction then
                        Deductions := Deductions + TransAmount;

                    if transactions.Type = transactions.Type::Payment then begin
                        if transactions."Non-Cash Benefit" = false then
                            Allowances := Allowances + TransAmount;
                    end;*/
                    until transactions.Next() = 0;

                //NetPay := Allowances - Deductions;
                TotalBankNets := 0;
                SpecificBankNetPay := 0;
                /*EmpPeriodBankDetails.Reset();
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
                    NetPay := NetPay - TotalBankNets;*/

                //NetPay := ROUND(NetPay, RoundValue);

                TransportAllowanceBanks.Reset();
                TransportAllowanceBanks.SetRange("Emp No.", "Employee PayrollL"."Emp No.");
                TransportAllowanceBanks.SetRange("Payroll Period", PayPeriod);
                if TransportAllowanceBanks.FindFirst() then begin
                    "Employee PayrollL"."Bank Name" := TransportAllowanceBanks."Bank Name";
                    "Employee PayrollL"."Branch Name" := TransportAllowanceBanks."Branch Name";
                    BankAccountNo := TransportAllowanceBanks."Bank Account No";
                end;
                BankName := "Employee PayrollL"."Bank Name";

                //Capture title details
                if not TitleCaptured then begin
                    ReportTitle := 'Transport Facility for ' /*+ "Employee PayrollL"."Payment/Bank Country"SelectedPaymentBankCountry + ' for '*/ + UpperCase(FORMAT(PayPeriod, 0, ' <Month Text> <Year4>') + ' | Currency: ' + OutputCurrency);
                    TitleCaptured := true;
                end;

                if NetPay = 0 then
                    CurrReport.Skip();


                //Approvers
                if not ApprovalEntriesCaptured then begin
                    ApprovalEntriesCaptured := true;
                    PayProcessHeader.Reset();
                    PayProcessHeader.SetRange("Payroll Period", PayPeriod);
                    if PayProcessHeader.FindFirst() then begin
                        ApprovalEntries.Reset();
                        ApprovalEntries.SetRange("Document No.", PayProcessHeader."Payroll Processing No");
                        ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                        if ApprovalEntries.FindSet() then
                            repeat
                                Payroll.Reset();
                                Payroll.SetRange("User ID", ApprovalEntries."Approver ID");
                                if Payroll.FindFirst() then begin
                                    Payroll.Validate(Position);
                                    if ApprovalEntries."Sequence No." = 1 then begin
                                        Emp.Reset();
                                        Emp.SetRange("User ID", ApprovalEntries."Sender ID");
                                        if Emp.FindFirst() then begin
                                            App1Name := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name" + '(' + Emp."Job Title" + ')';
                                            App1Date := Format(ApprovalEntries."Date-Time Sent for Approval", 0, '<Day,2>/<Month,2>/<Year4>');

                                            App1Signature.Reset();
                                            App1Signature.SetRange("User ID", ApprovalEntries."Sender ID");
                                            if App1Signature.FindFirst() then
                                                App1Signature.CalcFields(Signature);
                                        end;

                                        App2Name := Payroll."First Name" + ' ' + Payroll."Middle Name" + ' ' + Payroll."Last Name" + '(' + Payroll."Job Title" + ')';
                                        App2Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                        App2Signature.Reset();
                                        App2Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                        if App2Signature.FindFirst() then
                                            App2Signature.CalcFields(Signature);
                                    end;
                                    if ApprovalEntries."Sequence No." = 2 then begin
                                        App3Name := Payroll."First Name" + ' ' + Payroll."Middle Name" + ' ' + Payroll."Last Name" + '(' + Payroll."Job Title" + ')';
                                        App3Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                        App3Signature.Reset();
                                        App3Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                        if App3Signature.FindFirst() then
                                            App3Signature.CalcFields(Signature);
                                    end;
                                    if ApprovalEntries."Sequence No." = 3 then begin
                                        App4Name := Payroll."First Name" + ' ' + Payroll."Middle Name" + ' ' + Payroll."Last Name" + '(' + Payroll."Job Title" + ')';
                                        App4Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                        App4Signature.Reset();
                                        App4Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                        if App4Signature.FindFirst() then
                                            App4Signature.CalcFields(Signature);
                                    end;
                                    if ApprovalEntries."Sequence No." = 4 then begin
                                        App5Name := Payroll."First Name" + ' ' + Payroll."Middle Name" + ' ' + Payroll."Last Name" + '(' + Payroll."Job Title" + ')';
                                        App5Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                        App5Signature.Reset();
                                        App5Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                        if App5Signature.FindFirst() then
                                            App5Signature.CalcFields(Signature);
                                    end;
                                end;
                            until ApprovalEntries.Next() = 0;
                    end;
                end;
            end;


            trigger OnPreDataItem()
            begin
                Clear(NoRepeatEmpList);
                Serial := 0;
                /*if SelectedPaymentBankCountry = '' then
                    Error('You must select the payment/bank country!');
                "Employee PayrollL".SetRange("Bank Country", SelectedPaymentBankCountry);*/
                "Employee PayrollL".SetRange("Payroll Period", PayPeriod);
                //"Employee PayrollL".SetFilter("Bank Code", '<>%1', '');
                "Employee PayrollL".SetFilter("Bank Country", '<>%1', '');

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
                /*field("Bank Country"; SelectedPaymentBankCountry)
                {
                    Tablerelation = "Country/Region";
                }*/
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

            /*if OutputCurrency = '' then begin
                Countries.Reset();
                Countries.SetRange(Code, SelectedPaymentBankCountry/"Employee PayrollL"."Payment/Bank Country"/);
                if countries.FindFirst() then begin
                    if countries."Country Currency" = '' then
                        Error('You must specify the currency for country ' + SelectedPaymentBankCountry/*"Employee PayrollL"."Payment/Bank Country"/);
                    OutputCurrency := countries."Country Currency";
                end;
            end;*/
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
        TransportAllowanceBanks: Record "Transport Allowance Banks";
        SelectedPaymentBankCountry: Code[100];
        EmpRec: Record Employee;
        CanEditPaymentInfo: Boolean;
        CurrentPeriod: Date;
        Designation: Text;
        PeriodPrevailingMovements: Record "Period Prevailing Movement";
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
        NoRepeatEmpList: List of [Text];

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