report 51525371 "Final Dues Report"
{
    ApplicationArea = All;
    Caption = 'FD/RB Report'; //Final Dues 
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/FinalDuesReport.rdlc';
    dataset
    {
        dataitem(TerminalDuesHeader; "Terminal Dues Header")
        {
            RequestFilterFields = "No.";//, "WB No.", "Join Date", "Exit Date";

            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyPIN; CompanyInformation."P.I.N")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyAddress2; CompanyInformation."Address 2")
            {
            }
            column(ComapnyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(TransactionType; TransactionType)
            { }

            column(No; "No.")
            {
            }
            column(WBNo; "WB No.")
            {
            }
            column(FullName; "Full Name")
            {
            }
            column(Position; Position)
            {
            }
            column(RSSBNo; "RSSB No.")
            {
            }
            column(Bank; Bank)
            {
            }
            column(Period; Period)
            {
            }
            column(JoinDate; Format("Join Date", 0, '<Day,2>-<Month Text,3>-<Year4>'))
            {
            }
            column(ExitDate; Format("Exit Date", 0, '<Day,2>-<Month Text,3>-<Year4>'))
            {
            }
            column(SeparationReason; "Separation Reason")
            {
            }
            column(UnpaidWorkedDays; "Unpaid Worked Days")
            {
            }
            column(UntakenLeaveDays; "Untaken Leave Days")
            {
            }
            column(UntakenLeaveDescription; Format("Untaken Leave Days") + ' days'' of untaken leave')
            { }
            column(UnpaidDaysDescription; Format("Unpaid Worked Days") + ' days'' salary worked in ' + "Final Month of Service")
            { }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(CreatedOn; "Created On")
            {
            }
            column(BankAccountNo; "Bank Account No.")
            {
            }
            column(ContractualAmountType; "Contractual Amount Type")
            {
            }
            column(ContractualAmountCurrency; "Contractual Amount Currency")
            {
            }
            column(ContractualAmount; "Contractual Amount")
            {
            }
            column(PayrollCountry; "Payroll Country")
            {
            }
            column(PayrollCurrency; "Payroll Currency")
            {
            }
            column(AdditionalEntitledDays; "Additional Entitled Days")
            {
            }
            column(FinalMonthofService; "Final Month of Service")
            {
            }
            column(GrossSalary; GrossSalary)
            {
            }
            column(TotalFinalDues; TotalFinalDues)
            {
            }
            column(TaxableFinalDues; TaxableFinalDues)
            {
            }

            column(TotalDeductions; TotalDeduction)
            { }
            column(Balance; BalanceAmt)
            {
            }
            column("TotalSocialSecurity"; TotalSecurityEmployer)
            {
            }
            column(SwiftCode; "Swift Code")
            {
            }
            column(NoticePeriod; "Notice Period")
            {
            }
            column(NoticeGiven; NoticeGiven)
            {
            }
            column(Amount_paid; DesiredCurrency + ' ' + Format(BalanceAmt))
            { }
            column(Period_Processed; Format("Date Processed", 0, '<Month Text> <Day,2>, <Year4>'))//"Period Processed"
            { }
            column(ExchangeRateText; ExchangeRateText)
            {
            }
            column(ExchangeRateValue; ExchangeRateValue)
            {
            }
            column(FinalDuesInUSD; FinalDuesInUSD)
            {
            }
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

            dataitem(AdditionalEntitledTo; "Additional Entitled To")
            {
                DataItemLink = "Header No." = field("No.");

                column(EntryNo_Entitled; "Entry No.")
                { }
                column(LineDescription_Entitled; LineDescription)
                { }
                trigger OnAfterGetRecord()
                begin
                    LineDescription := Format(Action) + ': ' + Format(Abs("No. of Days")) + ' days'' ' + Description;
                end;
            }

            dataitem("Terminal Dues Salary Structure"; "Terminal Dues Salary Structure")
            {
                DataItemLink = "Header No." = field("No.");
                column(LineNo_Structure; "Line No.")
                { }
                column(Description_Structure; Description)
                { }
                column(Amount_Structure; TransAmount)
                { }

                trigger OnAfterGetRecord()
                begin
                    if ExchangeRateValue = 0 then
                        ExchangeRateValue := 1;
                    if ("Payroll Currency" <> 'USD') and (DesiredCurrency = 'USD') then
                        ExchangeRate := (1 / ExchangeRateValue)
                    else if ("Payroll Currency" = 'USD') and (DesiredCurrency <> 'USD') then
                        ExchangeRate := ExchangeRateValue
                    else
                        ExchangeRate := GetInDesiredCurrency("Payroll Currency", DesiredCurrency, 0, DateProcessed);
                    TransAmount := Round(Abs(Amount) * ExchangeRate, RoundValue);
                end;

            }

            dataitem("Terminal Dues Lines"; "Terminal Dues Lines")
            {
                DataItemLink = "Header No." = field("No.");

                column(LineNo_Lines; "Line No.")
                { }
                column(Description_Lines; Description)
                { }
                column(TransType_Lines; Format("Trans Type"))
                { }
                column(Amount_Lines; TransAmount)
                { }
                column(Taxable; Taxable)
                { }

                trigger OnAfterGetRecord()
                begin
                    if ExchangeRateValue = 0 then
                        ExchangeRateValue := 1;
                    if ("Payroll Currency" <> 'USD') and (DesiredCurrency = 'USD') then
                        ExchangeRate := (1 / ExchangeRateValue)
                    else if ("Payroll Currency" = 'USD') and (DesiredCurrency <> 'USD') then
                        ExchangeRate := ExchangeRateValue
                    else
                        ExchangeRate := GetInDesiredCurrency("Payroll Currency", DesiredCurrency, 0, DateProcessed);
                    TransAmount := Round(Amount * ExchangeRate, RoundValue);
                end;

            }


            trigger OnAfterGetRecord()
            begin
                if DesiredCurrency = '' then
                    DesiredCurrency := "Payroll Currency";

                if not ComapnyInfoCaptured then begin
                    CompanyInformation.CalcFields(Picture);
                    TransactionType := Format(Type);
                    ReportTitle := UpperCase(Format(Type)) + ' FOR ' + UpperCase("Full Name") + ' IN ' + DesiredCurrency;

                end else
                    ComapnyInfoCaptured := true;
                if "Notice Days Given" <> 0 then
                    NoticeGiven := format("Notice Given") + ' (' + format("Notice Days Given") + ' Day(s))'
                else
                    NoticeGiven := format("Notice Given");

                ExchangeRateValue := "Exchange Rate";
                if ExchangeRateValue = 0 then
                    ExchangeRateValue := 1;
                if ("Payroll Currency" <> 'USD') and (DesiredCurrency = 'USD') then
                    ExchangeRate := (1 / ExchangeRateValue)
                else if ("Payroll Currency" = 'USD') and (DesiredCurrency <> 'USD') then
                    ExchangeRate := ExchangeRateValue
                else
                    ExchangeRate := GetInDesiredCurrency("Payroll Currency", DesiredCurrency, 0, "Date Processed");
                CalcFields("Total Final Dues", "Taxable Final Dues", Balance, "Gross Salary", "Total Deductions");
                TotalFinalDues := Round(("Total Final Dues" * ExchangeRate), RoundValue);
                TaxableFinalDues := Round(("Taxable Final Dues" * ExchangeRate), RoundValue);
                BalanceAmt := Round((Balance * ExchangeRate), RoundValue);
                GrossSalary := Round(("Gross Salary" * ExchangeRate), RoundValue);
                TotalDeduction := Round(("Total Deductions" * ExchangeRate), RoundValue);
                TotalSecurityEmployer := Round(("Total Social Security" * ExchangeRate), RoundValue);
                if "Date Processed" = 0D then
                    "Date Processed" := "Period Processed";
                DateProcessed := "Date Processed";

                ExchangeRateText := 'Exchange Rate: 1 USD = ' + "Payroll Currency";
                if "Exchange Rate" = 0 then
                    "Exchange Rate" := 1;
                //USDExchangeRate := GetInDesiredCurrency("Payroll Currency", 'USD', 0, "Date Processed");
                //ExchangeRateValue := (1 / USDExchangeRate);
                //FinalDuesInUSD := Round((Balance * USDExchangeRate), RoundValue);
                if "Payroll Country" <> 'RWANDA' then begin //Only compute if expat
                    ExchangeRateValue := "Exchange Rate";
                    USDExchangeRate := (1 / "Exchange Rate");
                    FinalDuesInUSD := Round((Balance * USDExchangeRate), RoundValue);
                end;

                //Approvers
                if not ApprovalEntriesCaptured then begin
                    ApprovalEntriesCaptured := true;
                    ApprovalEntries.Reset();
                    ApprovalEntries.SetRange("Document No.", "No.");
                    ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                    if ApprovalEntries.FindSet() then
                        repeat
                            EmpRec.Reset();
                            EmpRec.SetRange("User ID", ApprovalEntries."Approver ID");
                            if EmpRec.FindFirst() then begin
                                EmpRec.Validate(Position);
                                if ApprovalEntries."Sequence No." = 1 then begin
                                    Emp.Reset();
                                    Emp.SetRange("User ID", ApprovalEntries."Sender ID");
                                    if Emp.FindFirst() then begin
                                        App1Name := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name" + '(' + EmpRec."Job Title" + ')';
                                        App1Date := Format(ApprovalEntries."Date-Time Sent for Approval", 0, '<Day,2>/<Month,2>/<Year4>');

                                        App1Signature.Reset();
                                        App1Signature.SetRange("User ID", ApprovalEntries."Sender ID");
                                        if App1Signature.FindFirst() then
                                            App1Signature.CalcFields(Signature);
                                    end;

                                    App2Name := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name" + '(' + EmpRec."Job Title" + ')';
                                    App2Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                    App2Signature.Reset();
                                    App2Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                    if App2Signature.FindFirst() then
                                        App2Signature.CalcFields(Signature);
                                end;
                                if ApprovalEntries."Sequence No." = 2 then begin
                                    App3Name := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name" + '(' + EmpRec."Job Title" + ')';
                                    App3Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                    App3Signature.Reset();
                                    App3Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                    if App3Signature.FindFirst() then
                                        App3Signature.CalcFields(Signature);
                                end;
                                if ApprovalEntries."Sequence No." = 3 then begin
                                    App4Name := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name" + '(' + EmpRec."Job Title" + ')';
                                    App4Date := Format(ApprovalEntries."Last Date-Time Modified", 0, '<Day,2>/<Month,2>/<Year4>');
                                    App4Signature.Reset();
                                    App4Signature.SetRange("User ID", ApprovalEntries."Approver ID");
                                    if App4Signature.FindFirst() then
                                        App4Signature.CalcFields(Signature);
                                end;
                                if ApprovalEntries."Sequence No." = 4 then begin
                                    App5Name := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name" + '(' + EmpRec."Job Title" + ')';
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


            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;

                RoundValue := 1;
                if DesiredCurrency = 'USD' then
                    RoundValue := 0.01;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Select Currency"; DesiredCurrency)
                {
                    Tablerelation = Currency;
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
        trigger OnOpenPage()
        begin
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                PayrollPeriod := Periods."Starting Date";
            RoundValue := 1;
        end;
    }

    trigger OnInitReport()
    begin
        GenLedgerSetup.Get();
        localCurrencyCode := GenLedgerSetup."LCY Code";
        ExchangeRate := 1;
        RoundValue := 1;
        //DesiredCurrency := localCurrencyCode;
        if localCurrencyCode = '' then
            Error('The local currency code has not been specified in the General Ledger Setup!');
    end;

    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        Movement: Record "Internal Employement History";
        PayrollPeriod: Date;
        Periods: Record "Payroll Period";
        localCurrencyCode: Code[50];
        GenLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        ExchangeRate: Decimal;
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
        EmpRec: Record Employee;
        Emp: Record Employee;
        ReportTitle: Text;
        TransactionType: Text;
        LineDescription: Text;
        TotalFinalDues: Decimal;
        TaxableFinalDues: Decimal;
        BalanceAmt: Decimal;
        GrossSalary: Decimal;
        TotalDeduction: Decimal;
        TotalSecurityEmployer: Decimal;
        ExchangeRateText: Text;
        ExchangeRateValue: Decimal;
        USDExchangeRate: Decimal;
        FinalDuesInUSD: Decimal;
        DateProcessed: Date;
        NoticeGiven: Text;


    Procedure GetInDesiredCurrency(EarningCountryCurrency: Code[50]; SelectedCountryCurrency: Code[50]; AmountToConvert: Decimal; ExchangeRateDateVar: Date) /*ConvertedAmount*/ExchRate: Decimal
    begin
        /*if DesiredCurrency = '' then
            DesiredCurrency := SelectedCountryCurrency;*/
        if EarningCountryCurrency = '' then
            EarningCountryCurrency := SelectedCountryCurrency;

        //ConvertedAmount := AmountToConvert;
        ExchRate := 1;
        if SelectedCountryCurrency = EarningCountryCurrency then
            ExchRate := 1//ConvertedAmount := AmountToConvert
        else begin
            CurrExchangeRateDate := CalcDate('CM', ExchangeRateDateVar);
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
            CurrencyExchangeRate.GetLastestExchangeRateCustom(SelectedCountryCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, SelectedCountryCurrency);

            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
            if LcyToFcy2Rate <> 0 then
                ExchRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
        end;
        exit(/*ConvertedAmount*/ExchRate);
    end;

}