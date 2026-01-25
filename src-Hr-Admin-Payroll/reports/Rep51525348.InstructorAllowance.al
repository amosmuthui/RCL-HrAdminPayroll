report 51525348 "Instructor Allowance"
{
    ApplicationArea = All;
    Caption = 'In-house Instructor Allowance Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/InhouseInstructorAllowance.rdlc';
    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");// WHERE(Status = CONST(Active));
            RequestFilterFields = "No.";//, "Payroll Country";

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
            column(No; "No.")
            {
            }
            column(Names; Names)
            {
            }
            column(Overtime_AC; "Overtime AC")
            {
            }
            column(PayrollPeriod; Format(PayrollPeriod, 0, '<Month Text,3>-<Year4>'))//OvertimePeriod
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(Sectors; Sectors)
            {
            }
            column(GrossAmount; GrossAmount)
            {
            }
            column(Paye; Paye)
            {
            }
            column(TaxableAmount; TaxableAmount)
            {
            }
            column(RSSBPension; RSSBPension)
            {
            }
            column(MaternityLeave; MaternityLeave)
            {
            }
            column(CBHI; Cbhi)
            {
            }
            column(NetAmount; NetAmount)
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
            column(GenerateByPeriodProcessed; GenerateByPeriodProcessed)
            { }

            trigger OnAfterGetRecord()
            begin
                Names := Employee.FullName();

                if not ComapnyInfoCaptured then begin
                    CompanyInformation.CalcFields(Picture);
                    ReportTitle := 'TRAINING ALLOWANCES IN-HOUSE INSTRUCTORS - ' + UpperCase(Format(CalcDate('-1M', PayrollPeriod), 0, '<Month Text> <Year4>')) + ' IN ' + DesiredCurrency;
                    //if GenerateByPeriodProcessed then
                    //ReportTitle := 'IN-HOUSE INSTRUCTOR ALLOWANCES PROCESSED IN ' + UpperCase(Format(PayrollPeriod, 0, '<Month Text> <Year4>')) + ' IN ' + DesiredCurrency;
                    if SelectedPayrollCountry <> '' then
                        ReportTitle := ReportTitle + ' /' + SelectedPayrollCountry;
                end else
                    ComapnyInfoCaptured := true;

                Paye := 0;
                GrossAmount := 0;
                TaxableAmount := 0;
                Sectors := 0;
                RSSBPension := 0;
                MaternityLeave := 0;
                Cbhi := 0;
                NetAmount := 0;

                /*PeriodMovement.Reset();
                PeriodMovement.SetRange("Emp No.", Employee."No.");
                PeriodMovement.SetRange("Payroll Period", PayrollPeriod);
                if SelectedPayrollCountry <> '' then
                    PeriodMovement.SetRange("Payroll Country", SelectedPayrollCountry);
                if PeriodMovement.FindFirst() then begin
                    ExchangeRate := GetInDesiredCurrency(PeriodMovement."Payroll Currency", DesiredCurrency, 0, PayrollPeriod);*/

                if ReportStage = ReportStage::"After Payroll Processing" then begin
                    AssignmentMatrix.Reset();
                    AssignmentMatrix.SetRange("Employee No", Employee."No.");
                    AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                    AssignmentMatrix.SetRange("Inhouse instructor Allowance", true);
                    if SelectedPayrollCountry <> '' then
                        AssignmentMatrix.setrange(Country, SelectedPayrollCountry);
                    if AssignmentMatrix.FindSet() then //Though I only expect 1
                        repeat
                            ExchangeRate := GetInDesiredCurrency(AssignmentMatrix."Country Currency", DesiredCurrency, 0, AssignmentMatrix."Payroll Period"); //Will use exchange rate of period processed

                            if (AssignmentMatrix."Overtime Net" = 0) and (AssignmentMatrix."Net Amount" <> 0) then begin
                                AssignmentMatrix."Overtime Net" := AssignmentMatrix."Net Amount";
                                AssignmentMatrix.Modify();
                            end else begin
                                if AssignmentMatrix."Taxable amount" > AssignmentMatrix.Amount then begin
                                    AssignmentMatrix.Amount := AssignmentMatrix."Taxable amount";
                                    AssignmentMatrix.Modify();
                                end;
                            end;
                            //Sectors := AssignmentMatrix."Overtime Hours (Sectors)";
                            GrossAmount := abs(AssignmentMatrix.Amount) * ExchangeRate;
                            Paye := abs(AssignmentMatrix."Overtime PAYE") * ExchangeRate;
                            TaxableAmount := abs(AssignmentMatrix."Taxable Amount") * ExchangeRate;
                            RSSBPension := abs(AssignmentMatrix."Overtime RSSB Pension") * ExchangeRate;
                            MaternityLeave := abs(AssignmentMatrix."Overtime Maternity Leave") * ExchangeRate;
                            Cbhi := abs(AssignmentMatrix."Overtime CBHI") * ExchangeRate;
                            NetAmount := abs(AssignmentMatrix."Overtime Net") * ExchangeRate;
                        until AssignmentMatrix.Next() = 0;
                end;

                if ReportStage = ReportStage::"Before Payroll Processing" then begin
                    BatchEntries.Reset();
                    BatchEntries.SetRange("Payroll Period", PayrollPeriod);
                    BatchEntries.SetRange("Instructor No.", Employee."No.");
                    if BatchEntries.FindSet() then
                        repeat
                            NetAmount += BatchEntries.Allowance;
                        until BatchEntries.Next() = 0;
                end;
                //end;

                if NetAmount = 0 then
                    CurrReport.Skip();

                //Approvers
                if not ApprovalEntriesCaptured then begin
                    ApprovalEntriesCaptured := true;
                    /*if not GenerateByPeriodProcessed then
                        PayrollPeriod := OvertimePeriod;*/
                    Batch.Reset();
                    Batch.SetRange("Payroll Period", PayrollPeriod);
                    if Batch.FindFirst() then begin
                        ApprovalEntries.Reset();
                        ApprovalEntries.SetRange("Document No.", Batch."Batch Name");
                        ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                        if ApprovalEntries.FindSet() then
                            repeat
                                if (ApprovalEntries."Approver ID" = ApprovalEntries."Last Modified By User ID") then begin
                                    EmpRec.Reset();
                                    EmpRec.SetRange("User ID", ApprovalEntries."Approver ID");
                                    if EmpRec.FindFirst() then begin
                                        EmpRec.Validate(Position);
                                        if ApprovalEntries."Sequence No." = 1 then begin
                                            TrainingAllowanceBatches.Reset();
                                            TrainingAllowanceBatches.SetRange("Payroll Period", PayrollPeriod);
                                            TrainingAllowanceBatches.SetFilter("Submitted By", '<>%1', '');
                                            if TrainingAllowanceBatches.FindFirst() then begin
                                                Emp.Reset();
                                                Emp.SetRange("User ID", TrainingAllowanceBatches."Submitted By");
                                                if Emp.FindFirst() then begin
                                                    App1Name := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name" + '(' + Emp."Job Title" + ')';
                                                    App1Date := Format(TrainingAllowanceBatches."Submitted On", 0, '<Day,2>/<Month,2>/<Year4>');

                                                    App1Signature.Reset();
                                                    App1Signature.SetRange("User ID", TrainingAllowanceBatches."Submitted By");
                                                    if App1Signature.FindFirst() then
                                                        App1Signature.CalcFields(Signature);
                                                end;
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
                                end;
                            until ApprovalEntries.Next() = 0;
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //if GenerateByPeriodProcessed then begin
                if PayrollPeriod = 0D then
                    Error('You must select the period processed!');
                /*end else begin
                    if OvertimePeriod = 0D then
                        Error('You must select the overtime period!');*/
                //end;
                if DesiredCurrency = '' then
                    Error('You must select the desired display currency!');
                CompanyInformation.Get;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                /*field("Overtime Period"; OvertimePeriod)
                {
                    TableRelation = "Payroll Period";
                }
                field("Filter by Period Processed"; GenerateByPeriodProcessed)
                {

                }*/
                field("Period Processsed"; PayrollPeriod)
                {
                    TableRelation = "Payroll Period";
                    Visible = true;
                }
                field("Payroll Country"; SelectedPayrollCountry)
                {
                    Tablerelation = "Country/Region";
                }
                field("Select Currency"; DesiredCurrency)
                {
                    Tablerelation = Currency;
                }

                field(Stage; ReportStage)
                { }
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
            if PayrollPeriod = 0D then begin
                Periods.Reset();
                Periods.SetRange(Closed, false);
                if Periods.FindFirst() then
                    PayrollPeriod := Periods."Starting Date";
            end;

            DesiredCurrency := localCurrencyCode;
        end;
    }

    trigger OnInitReport()
    begin
        GenLedgerSetup.Get();
        localCurrencyCode := GenLedgerSetup."LCY Code";
        ExchangeRate := 1;
        GenerateByPeriodProcessed := false;
        DesiredCurrency := localCurrencyCode;
        if localCurrencyCode = '' then
            Error('The local currency code has not been specified in the General Ledger Setup!');
    end;

    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        Movement: Record "Internal Employement History";
        PayrollPeriod: Date;
        OvertimePeriod: Date;
        Periods: Record "Payroll Period";
        AssignmentMatrix: Record "Assignment Matrix";
        AssignmentMatrix2: Record "Assignment Matrix";
        Names: Text;
        ReportTitle: Text;
        Paye: Decimal;
        GrossAmount: Decimal;
        LumpsumAllowance: Decimal;
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
        SelectedPayrollCountry: Code[100];
        PeriodMovement: Record "Period Prevailing Movement";
        DeductionsRec: Record "Deductions";
        PayProcessHeader: Record "Payroll Processing Header";
        Batch: Record "Training Allowance Batches";
        Emp: Record Employee;
        EmpRec: Record Employee;
        NetAmount: Decimal;
        Sectors: Decimal;
        TaxableAmount: Decimal;
        RSSBPension: Decimal;
        MaternityLeave: Decimal;
        Cbhi: Decimal;
        GenerateByPeriodProcessed: Boolean;
        TrainingAllowanceBatches: Record "Training Allowance Batches";
        ReportStage: Option "After Payroll Processing","Before Payroll Processing";
        BatchEntries: Record "Training Allowance Entries";


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

    procedure SetParameters(Period: Date; Currency: Code[10]; RptStage: Integer)
    begin
        PayrollPeriod := Period;
        DesiredCurrency := Currency;
        ReportStage := RptStage;
    end;
}