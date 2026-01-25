report 51525314 "Payroll Summary Report"
{
    ApplicationArea = All;
    Caption = 'Countries Payroll Summary Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/reports/layouts/CountriesPayrollSummaryReport.rdlc';
    dataset
    {
        dataitem(CountryRegion; "Country/Region")
        {
            DataItemTableView = SORTING(Code) WHERE("Is Payroll Country" = CONST(true));
            RequestFilterFields = Code;

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
            column(Code; "Code")
            {
            }
            column(Country_Currency; "Country Currency")
            { }
            column(Name; Name)
            {
            }
            column(StaffCount; StaffCount)
            {
            }
            column(GrossSalary; GrossSalary)
            {
            }
            column(NetSalary; NetSalary)
            {
            }
            column(RWFGross; RWFGross)
            {
            }
            column(RWFNetSalary; RWFNetSalary)
            {
            }
            column(USDGross; USDGross)
            {
            }
            column(USDNetSalary; USDNetSalary)
            {
            }
            column(PayPeriod; FORMAT(PayrollPeriod, 0, '<month text> <year4>'))
            {
            }
            column(MonthTitle; 'Month of ' + FORMAT(PayrollPeriod, 0, '<month text> <year4>'))
            {
            }
            column(MonthTitleCaps; 'MONTH OF ' + uppercase(FORMAT(PayrollPeriod, 0, '<month text> <year4>')))
            {
            }


            trigger OnAfterGetRecord()
            var
                Proceed: Boolean;
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;
                if Name = '' then
                    Name := Code;

                Clear(NoRepeatEmpList);

                StaffCount := 0;
                HasPayrollTrans := false;
                GrossSalary := 0;
                RWFGross := 0;
                USDGross := 0;
                NetSalary := 0;
                RWFNetSalary := 0;
                USDNetSalary := 0;

                //=>EmployeeRec.Reset();
                //EmployeeRec.SetRange("Workstation Country", Code);
                //=>EmployeeRec.SetRange("Payroll Country", Code);
                //EmployeeRec.SetRange(Status,EmployeeRec.Status::Active);                
                EmpPeriodBankDetails.Reset();
                EmpPeriodBankDetails.SetRange("Payroll Period", PayrollPeriod);
                EmpPeriodBankDetails.SetRange("Payroll Country", Code);
                if /*EmployeeRec*/EmpPeriodBankDetails.FindSet() then
                    repeat
                        if not NoRepeatEmpList.Contains(EmpPeriodBankDetails."Emp No.") then begin
                            NoRepeatEmpList.Add(EmpPeriodBankDetails."Emp No.");
                            EmpPeriodBankDetails.CalcFields("Period Movement Last Date", "Current Movement Last Date", "Period Movement Terminal Dues");
                            if (EmpPeriodBankDetails."Period Movement Last Date" >= PayrollPeriod) and (EmpPeriodBankDetails."Current Movement Last Date" >= PayrollPeriod) and (not EmpPeriodBankDetails."Period Movement Terminal Dues") then begin
                                if EmpPeriodBankDetails."Payroll Country" = 'RISHWORTH' then
                                    StaffCount += 1
                                else begin
                                    AssignmentMatrix.Reset();
                                    AssignmentMatrix.SetRange("Employee No", /*EmployeeRec."No."*/EmpPeriodBankDetails."Emp No.");
                                    AssignmentMatrix.SetRange("Payroll Period", PayrollPeriod);
                                    AssignmentMatrix.SetRange("Exclude from Payroll", false);
                                    AssignmentMatrix.SetFilter(Country, Code); //Only for that country
                                    if AssignmentMatrix.FindSet() then begin
                                        StaffCount += 1; //Means they were active
                                                         //HasPayrollTrans := true;
                                        repeat
                                            TransAmount := Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", "Country Currency", AssignmentMatrix.Country, ABS(AssignmentMatrix.Amount)));
                                            RWFTransAmount := Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", 'RWF', AssignmentMatrix.Country, ABS(AssignmentMatrix.Amount)));
                                            USDTransAmount := Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", 'USD', AssignmentMatrix.Country, ABS(AssignmentMatrix.Amount)));
                                            if (AssignmentMatrix.Type = AssignmentMatrix.Type::Payment) and (not AssignmentMatrix."Non-Cash Benefit") then //Gross
                                                begin
                                                GrossSalary += TransAmount;
                                                RWFGross += RWFTransAmount;
                                                USDGross += USDTransAmount;

                                                NetSalary += TransAmount;
                                                RWFNetSalary += RWFTransAmount;
                                                USDNetSalary += USDTransAmount;
                                            end;
                                            if AssignmentMatrix.Type = AssignmentMatrix.Type::Deduction then begin
                                                NetSalary -= TransAmount;
                                                RWFNetSalary -= RWFTransAmount;
                                                USDNetSalary -= USDTransAmount;
                                            end;
                                            TransAmount := 0;
                                            RWFTransAmount := 0;
                                            USDTransAmount := 0;
                                        until AssignmentMatrix.Next() = 0;
                                    end;
                                end;

                                /*if not HasPayrollTrans then begin
                                    //Check if they had period bank records - like Rishworth
                                    EmpPeriodBankDetails.Reset();
                                    EmpPeriodBankDetails.SetRange("Payroll Period", PayrollPeriod);
                                    EmpPeriodBankDetails.SetRange("Emp No.", EmployeeRec."No.");
                                    if EmpPeriodBankDetails.FindFirst() then
                                        StaffCount += 1;
                                end;*/
                            end;
                        end;
                    until /*EmployeeRec*/EmpPeriodBankDetails.Next() = 0;

                //If some staff appeared in multiple countries - so they did not appear above
                Proceed := false;
                EmpMovement.SetFilter(Status, '<>%1', EmpMovement.Status::Pending);
                EmpMovement.SetFilter("First Date", '<=%1', CalcDate('<CM>', PayrollPeriod));//As long as first date is earlier than the end of this month
                EmpMovement.SetFilter("Last Date", '>=%1', PayrollPeriod);//Last date must be greater than or equal to start date of this period
                EmpMovement.SetRange("Terminal Dues", false);
                EmpMovement.SetRange("Payroll Country", Code);
                if EmpMovement.FindSet() then
                    repeat
                        EmpPeriodBankDetails.Reset();
                        EmpPeriodBankDetails.SetRange("Payroll Period", PayrollPeriod);
                        EmpPeriodBankDetails.SetRange("Payroll Country", Code);
                        EmpPeriodBankDetails.SetRange("Emp No.", EmpMovement."Emp No.");
                        if not EmpPeriodBankDetails.FindFirst() then
                            Proceed := true
                        else begin
                            if not NoRepeatEmpList.Contains(EmpMovement."Emp No.") then
                                Proceed := true;
                        end;

                        if Proceed then begin
                            AssignmentMatrix.Reset();
                            AssignmentMatrix.SetRange("Employee No", EmpMovement."Emp No.");
                            AssignmentMatrix.SetRange("Payroll Period", PayrollPeriod);
                            AssignmentMatrix.SetRange("Exclude from Payroll", false);
                            AssignmentMatrix.SetFilter(Country, Code); //Only for that country
                            if AssignmentMatrix.FindSet() then begin
                                if not NoRepeatEmpList.Contains(EmpMovement."Emp No.") then begin
                                    NoRepeatEmpList.Add(EmpMovement."Emp No.");
                                    StaffCount += 1;
                                    repeat
                                        TransAmount := Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", "Country Currency", AssignmentMatrix.Country, ABS(AssignmentMatrix.Amount)));
                                        RWFTransAmount := Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", 'RWF', AssignmentMatrix.Country, ABS(AssignmentMatrix.Amount)));
                                        USDTransAmount := Round(GetInDesiredCurrency(AssignmentMatrix."Country Currency", 'USD', AssignmentMatrix.Country, ABS(AssignmentMatrix.Amount)));
                                        if (AssignmentMatrix.Type = AssignmentMatrix.Type::Payment) and (not AssignmentMatrix."Non-Cash Benefit") then //Gross
                                            begin
                                            GrossSalary += TransAmount;
                                            RWFGross += RWFTransAmount;
                                            USDGross += USDTransAmount;

                                            NetSalary += TransAmount;
                                            RWFNetSalary += RWFTransAmount;
                                            USDNetSalary += USDTransAmount;
                                        end;
                                        if AssignmentMatrix.Type = AssignmentMatrix.Type::Deduction then begin
                                            NetSalary -= TransAmount;
                                            RWFNetSalary -= RWFTransAmount;
                                            USDNetSalary -= USDTransAmount;
                                        end;
                                        TransAmount := 0;
                                        RWFTransAmount := 0;
                                        USDTransAmount := 0;
                                    until AssignmentMatrix.Next() = 0;
                                end;
                            end;
                        end;
                    until EmpMovement.Next() = 0;

            end;

            trigger OnPreDataItem()
            begin
                //Clear(NoRepeatEmpList);
                //NoRepeatEmpList := NoRepeatEmpList.List;
                CompanyInformation.Get;

                //Just to ensure last date is updated in movement card
                EmpMovement.Reset();
                EmpMovement.SetRange(Status, EmpMovement.Status::Current);
                EmpMovement.SetFilter("First Date", '<>%1', 0D);
                EmpMovement.SetRange("Last Date", 0D);
                if EmpMovement.FindSet() then
                    repeat
                        EmpMovement.Validate("First Date");
                        EmpMovement.Modify();
                    until EmpMovement.Next() = 0;

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
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        StaffCount: Integer;
        HasPayrollTrans: Boolean;
        EmpPeriodBankDetails: Record "Employee Period Bank Details";
        NoRepeatEmpList: List of [Text];
        GrossSalary: Decimal;
        NetSalary: Decimal;
        EmployeeRec: Record Employee;
        AssignmentMatrix: Record "Assignment Matrix";
        PayrollPeriod: Date;
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
        RWFGross: Decimal;
        USDGross: Decimal;
        RWFTransAmount: Decimal;
        USDTransAmount: Decimal;
        RWFNetSalary: Decimal;
        USDNetSalary: Decimal;
        EmpMovement: Record "Internal Employement History";
    //EmpPeriodBanks: "Employee Period Bank Details";

    trigger OnInitReport()
    begin
        GenLedgerSetup.Get();
        localCurrencyCode := GenLedgerSetup."LCY Code";
        ExchangeRate := 1;
        if localCurrencyCode = '' then
            Error('The local currency code has not been specified in the General Ledger Setup!');
        DesiredCurrency := localCurrencyCode;
    end;

    Procedure GetInDesiredCurrency(CountryCurrency: Code[50]; VarDesiredCurrency: Code[50]; CountryChosen: Code[50]; AmountToConvert: Decimal) ConvertedAmount: Decimal
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

        if VarDesiredCurrency = CountryCurrency then
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
            CurrencyExchangeRate.GetLastestExchangeRateCustom(VarDesiredCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, VarDesiredCurrency);

            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
            if LcyToFcy2Rate <> 0 then
                ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
            ConvertedAmount := AmountToConvert * ExchangeRate;
        end;
        exit(ConvertedAmount);
    end;
}