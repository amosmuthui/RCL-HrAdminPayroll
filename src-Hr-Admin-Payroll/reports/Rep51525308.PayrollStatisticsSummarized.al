report 51525308 "Payroll-Statistics Summarized"
{
    Caption = 'Payroll Statistics - Summarized';
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/PayrollStatisticsSummarized.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = WHERE(Board = CONST(false));//, Status = CONST(Active));
            RequestFilterFields = "No.";//, "Pay Period Filter", "Payroll Country";
            column(No_Employee; Employee."No.")
            {
            }
            column(Initials_Employee; Employee.Initials)
            {
            }
            column(Department_Employee; Employee."Responsibility Center Name")
            {
            }
            column(FullName_Employee; Employee.FullName())
            {
            }
            column(Names; Employee."Last Name" + ' ' + Employee."Middle Name" + ' ' + Employee."First Name")
            {
            }
            column(JobTitle_Employee; Employee."Job Title")
            {
            }
            column(Section_Employee; Employee."Sub Responsibility Center"/*."Contract Type"*/)
            {
            }
            column(SelectedCountry; Employee."Payroll Country")
            {

            }
            column(Payroll_Currency; "Payroll Currency")
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
            column(PayrollProcessed; PayrollProcessed)
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
            dataitem(PayrollTrans; "Assignment Matrix")
            {
                DataItemLink = "Employee No" = FIELD("No.");//, "Payroll Period" = FIELD("Pay Period Filter");
                DataItemTableView = sorting("Code") Order(Ascending) WHERE("Do Not Deduct" = CONST(false), "Tax Relief" = CONST(false), "Exclude from Payroll" = const(false));
                column(Employee_PayrollTrans; PayrollTrans."Employee No")
                {
                }
                column(PayType_PayrollTrans; PayrollTrans.Type)
                {
                }
                column(Code_PayrollTrans; PayrollTrans.Code)
                {
                }
                column(Amount_PayrollTrans; /*NewPayslipReport.ChckRound(Format(*/Round(TransAmount, RoundValue))/*, RoundValue))*/
                {
                }
                column(DateEntered_PayrollTrans; PayrollTrans."Payroll Period")
                {
                }
                column(Period_PayrollTrans; PayrollTrans."Payroll Period")
                {
                }
                column(Description_PayrollTrans; PayrollTrans.Description)
                {
                }
                column(BasicSalaryCode_PayrollTrans; PayrollTrans."Basic Salary Code")
                {
                }
                column(NonCashBenefit_PayrollTrans; PayrollTrans."Non-Cash Benefit")
                {
                }
                column(GrossAmount; /*NewPayslipReport.ChckRound(Format(*/Round(GrossAmount, RoundValue))/*, RoundValue))*/
                {
                }
                column(BasicPay; /*NewPayslipReport.ChckRound(Format(*/Round(BasicPay, RoundValue))/*, RoundValue))*/
                {
                }
                column(NetPay; /*NewPayslipReport.ChckRound(Format(*/Round(NetPay, RoundValue))/*, RoundValue))*/
                {
                }
                column(Paye_PayrollTrans; PayrollTrans.Paye)
                {
                }
                column(Deductions; /*NewPayslipReport.ChckRound(Format(*/Round(Abs(Deductions), RoundValue))/*, RoundValue))*/
                {
                }
                column(DeductionsThatReduceGross; Round(Abs(DeductionsThatReduceGross), RoundValue))
                { }
                column(IsNHIF; IsNHIF)
                {
                }
                column(IsHELB; IsHELB)
                {
                }
                column(IsNSSF; IsNSSF)
                {
                }
                column(IsOther; IsOther)
                {
                }
                column(ShowOnMasterRoll; ShowOnMasterRoll)
                {

                }
                column(IsStatutoryDeduction; IsStatutoryDeduction)
                { }
                column(OtherAllowances; Round(OtherAllowances, RoundValue))
                { }
                column(OtherDeductions; Round(OtherDeductions, RoundValue))
                { }
                column(Yname; Yname)
                {
                }
                column(ReportTitle; ReportTitle)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //PayrollTrans
                    GrossAmount := 0;
                    Allowances := 0;
                    BasicPay := 0;
                    Deductions := 0;
                    NetPay := 0;
                    NonCashAmount := 0;
                    OtherAllowances := 0;
                    //VoluntaryIns:=0;
                    OtherDeductions := 0;
                    RoundValue := 1;

                    IsNSSF := false;
                    IsNHIF := false;
                    IsHELB := false;
                    IsOther := false;
                    ShowOnMasterRoll := false;
                    IsStatutoryDeduction := false;
                    DeductionsThatReduceGross := 0;

                    if not TitleCaptured then begin
                        PayrollTitle := SelectedPayrollCountry + ' PAYROLL';
                        if SelectedPayrollCountry = 'CABIN' then
                            PayrollTitle := 'CABIN MARSHALLS ALLOWANCES';
                        ReportTitle := /*PayrollTrans.Country*/PayrollTitle + ' SUMMARY FOR ' + UPPERCASE(FORMAT(PayrollTrans."Payroll Period", 0, ' <Month Text>, <Year4>'));
                        PayrollCountry.Reset();
                        PayrollCountry.SetRange(Code, PayrollTrans.Country);
                        PayrollCountry.SetFilter("Country Currency", '<>%1', '');
                        if PayrollCountry.FindFirst() then begin
                            PayrollCountryCurrency := PayrollCountry."Country Currency";
                            if PayrollCountryCurrency = '' then
                                Error('You must set the country currency for %1', PayrollTrans.Country);
                            if DesiredCurrency = '' then
                                DesiredCurrency := PayrollCountryCurrency;
                            ReportTitle := ReportTitle + ' | CURRENCY: ' + DesiredCurrency;
                        end;
                        TitleCaptured := true;
                    end;
                    RoundValue := 1;
                    if DesiredCurrency = 'USD' then
                        RoundValue := 0.01;

                    //Yname := Date2DMY(PayrollTrans."Payroll Period", 3);
                    TransAmount := ABS(GetInDesiredCurrency(PayrollTrans."Country Currency", DesiredCurrency/*PayrollCountryCurrency*/, PayrollTrans.Amount, PayrollTrans."Payroll Period"));


                    if PayrollTrans."Basic Salary Code" = true then begin
                        BasicPay += TransAmount;//GetInDesiredCurrency(PayrollTrans."Country Currency", PayrollCountryCurrency, PayrollTrans.Amount, PayrollTrans."Payroll Period");
                        BasicTotal += BasicTotal;

                    end;

                    if PayrollTrans.Type = PayrollTrans.Type::Deduction then begin
                        Deductions += TransAmount;//ABS(GetInDesiredCurrency(PayrollTrans."Country Currency", PayrollCountryCurrency, PayrollTrans.Amount, PayrollTrans."Payroll Period"));
                        TotalDeductions += Deductions;
                    end;


                    if PayrollTrans.Type = PayrollTrans.Type::Deduction then begin
                        DedZ.Reset();
                        DedZ.SetRange(Code, PayrollTrans.Code);
                        DedZ.SetRange(Country, PayrollTrans.Country);
                        if DedZ.FindFirst() then begin
                            if DedZ."Show on Master Roll"/*."Is Statutory"*/ = true then begin
                                IsStatutoryDeduction := true;
                            end else begin
                                OtherDeductions := TransAmount; //PayrollTrans.Amount;
                                IsOther := true;
                            end;

                            if DedZ."Reduces Gross" then begin
                                AssignmentMatrix.RESET;
                                AssignmentMatrix.SETRANGE("Employee No", Employee."No.");
                                AssignmentMatrix.SETRANGE(Code, DedZ.Code);
                                AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                                AssignmentMatrix.setrange(Country, PayrollTrans.Country);
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
                                AssignmentMatrix.SetRange("Do Not Deduct", false);
                                AssignmentMatrix.SetRange("Tax Relief", false);
                                IF AssignmentMatrix.FINDFIRST then
                                    DeductionsThatReduceGross += TransAmount;
                            end;
                        end;
                    end;


                    if ((PayrollTrans.Type = PayrollTrans.Type::Payment) and (PayrollTrans."Basic Salary Code" = false) and (PayrollTrans."Non-Cash Benefit" = false) and (PayrollTrans."Tax Relief" = false))
                        then begin
                        Allowances += TransAmount;//GetInDesiredCurrency(PayrollTrans."Country Currency", PayrollCountryCurrency, PayrollTrans.Amount, PayrollTrans."Payroll Period");
                        AllowancesTotal += Allowances;
                    end;

                    if (PayrollTrans.Type = PayrollTrans.Type::Payment) and
                     (PayrollTrans."Non-Cash Benefit" = true)
                     then begin
                        NonCashAmount += TransAmount;//GetInDesiredCurrency(PayrollTrans."Country Currency", PayrollCountryCurrency, PayrollTrans.Amount, PayrollTrans."Payroll Period");
                        NonCashAmountTotal += NonCashAmount;
                        //AllowancesTotal+=Allowances;
                    end;

                    if (PayrollTrans.Type = PayrollTrans.Type::Payment) then begin
                        if PayrollTrans."Basic Salary Code" = true then
                            ShowOnMasterRoll := true
                        else begin
                            Earn.Reset();
                            Earn.SetRange(Code, PayrollTrans.Code);
                            Earn.SetRange(Country, PayrollTrans.Country);
                            //Earn.SetRange("Show on Master Roll", true);//
                            //Earn.SetFilter("Calculation Method", '<>%1', Earn."Calculation Method"::"Flat Amount");//"Show on Master Roll"
                            if Earn.FindFirst() then begin
                                if Earn."Show on Master Roll" then
                                    ShowOnMasterRoll := true
                                else begin
                                    OtherAllowances := TransAmount;//PayrollTrans.Amount;
                                    IsOther := true;
                                end;
                            end;
                        end;
                    end;

                    //Deductions:=Deductions-VoluntaryIns;

                    GrossAmount := BasicPay + Allowances - DeductionsThatReduceGross;
                    GrossTotal := GrossTotal + GrossAmount;
                    NetPay := GrossAmount + Deductions + DeductionsThatReduceGross;
                    //NetPay:=NetPay-NonCashAmount;
                    //MESSAGE('GrossAmount %1,Amount %2,Allowances %3,Description %4 BasicPay %5 NonCashAmount %6',GrossAmount,PayrollTrans.Amount,
                    //AllowancesTotal,PayrollTrans.Description,BasicPay,NonCashAmount);

                end;

                trigger OnPostDataItem()
                begin
                    //MESSAGE('VOlPension %1 Deductions%2 NetPay%3',VoluntaryIns,Deductions,NetPay);
                    //MESSAGE(' Noncash %1 NoncashTotal%2 Net%3',NonCashAmount,NonCashAmountTotal,NetPay);
                end;

                trigger OnPreDataItem()
                begin
                    PayrollTrans.SetRange(Country, SelectedPayrollCountry);
                    PayrollTrans.SetRange("Payroll Period", PayrollPeriod);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //If no transactions for that period, skip
                transactionsT.Reset();
                transactionsT.SetRange(Country, SelectedPayrollCountry);
                transactionsT.SetRange("Employee No", Employee."No.");
                transactionsT.SetRange("Payroll Period", PayrollPeriod);
                if not transactionsT.FindFirst() then
                    CurrReport.Skip();

                Employee.CalcFields(Basic, "Total Earnings Calc");
                if Employee."Total Earnings Calc" > 0 then begin
                    PayrollProcessed := true;
                end else
                    PayrollProcessed := false;

                VoluntaryIns := 0;
                /*if Employee.GetFilter("Payroll Country") = '' then
                    Error('You must select country!');*/

                //FRED 22/2/23 Pick company info only once - repeating the logo on every line overloads memory
                if not CompanyDataCaptured then
                    CompanyDataCaptured := true
                else
                    Clear(CompInf.Picture);

                //Approvers
                if not ApprovalEntriesCaptured then begin
                    ApprovalEntriesCaptured := true;
                    PayProcessHeader.Reset();
                    PayProcessHeader.SetRange("Payroll Period", PayrollPeriod);
                    if PayProcessHeader.FindFirst() then begin
                        ApprovalEntries.Reset();
                        ApprovalEntries.SetRange("Document No.", PayProcessHeader."Payroll Processing No");
                        ApprovalEntries.SetRange(Status, ApprovalEntries.Status::Approved);
                        if ApprovalEntries.FindSet() then
                            repeat
                                EmpRec.Reset();
                                EmpRec.SetRange("User ID", ApprovalEntries."Approver ID");
                                if EmpRec.FindFirst() then begin
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
            end;

            trigger OnPreDataItem()
            begin
                /*if SelectedCountry <> '' then
                    Employee.SETRANGE("Payroll Country", SelectedCountry);
                Employee.SETFILTER("Pay Period Filter", FORMAT(PayrollPeriod, 0, '<Day,2>-<Month,2>-<Year4>'));
                */
                if SelectedPayrollCountry = '' then
                    Error('You must select payroll country!');
                if PayrollPeriod = 0D then
                    Error('You must select payroll period!');

                if (not CanEditPaymentInfo) and (PayrollPeriod = CurrentPeriod) then
                    Error('Payroll for this period is still being processed. Kindly try again later!');

                AllowancesTotal := 0;
                BasicTotal := 0;
                GrossTotal := 0;
                TotalDeductions := 0;
                OtherAllowances := 0;
                OtherDeductions := 0;
                NonCashAmountTotal := 0;


                PayrollProcessed := false;
                CompInf.Get();
                CompInf.CalcFields(CompInf.Picture);
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
        RoundValue := 1;

        CanEditPaymentInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
    end;

    var
        CompInf: Record "Company Information";
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
        transactionsXX: Record "Assignment Matrix";
        transactionsXXX: Record "Assignment Matrix";
        Payes: Decimal;
        ThirdBasic: Decimal;
        Periods: Record "Payroll Period";
        Yname: Integer;
        BankName: Text[250];
        BankAccountNo: Code[60];
        EmpRec: Record Employee;
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
        OtherAllowances: Decimal;
        OtherDeductions: Decimal;
        transactionsXXXX: Record "Assignment Matrix";
        GrossDeductions: Decimal;
        transactionsXXXXX: Record "Assignment Matrix";
        IsNHIF: Boolean;
        IsNSSF: Boolean;
        IsHELB: Boolean;
        DedZ: Record Deductions;
        Earnings: Record Earnings;
        IsOther: Boolean;
        IsStatutoryDeduction: Boolean;
        ShowOnMasterRoll: Boolean;
        PayrollProcessed: Boolean;
        VoluntaryIns: Decimal;
        NonCashAmount: Decimal;
        NonCashAmountTotal: Decimal;
        CompanyDataCaptured: Boolean;
        SelectedCountry: Code[50];
        PayrollPeriod: Date;
        ReportTitle: Text[250];
        PayrollTitle: Text[100];
        TitleCaptured: Boolean;
        PayrollCountry: Record "Country/Region";
        Earn: Record "Earnings";
        localCurrencyCode: Code[50];
        GenLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        ExchangeRate: Decimal;
        RoundValue: Decimal;
        PayrollCountryCurrency: Code[100];
        TransAmount: Decimal;
        DesiredCurrency: Code[100];
        SelectedPayrollCountry: Code[100];
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
        NewPayslipReport: Report "New Payslip";
        CanEditPaymentInfo: Boolean;
        CurrentPeriod: Date;
        AssignmentMatrix: Record "Assignment Matrix";
        DeductionsThatReduceGross: Decimal;


    procedure SetReportFilter(NewPayrollPeriod: Date; InitialCountry: Code[50])
    begin
        PayrollPeriod := NewPayrollPeriod;
        SelectedCountry := InitialCountry;
        SelectedPayrollCountry := InitialCountry;
    end;

    Procedure GetInDesiredCurrency(EarningCountryCurrency: Code[50]; SelectedCountryCurrency: Code[50]; AmountToConvert: Decimal; PayDate: Date) ConvertedAmount: Decimal
    begin
        if DesiredCurrency = '' then
            DesiredCurrency := SelectedCountryCurrency;
        if EarningCountryCurrency = '' then
            EarningCountryCurrency := SelectedCountryCurrency;

        ConvertedAmount := AmountToConvert;
        if DesiredCurrency = EarningCountryCurrency then
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