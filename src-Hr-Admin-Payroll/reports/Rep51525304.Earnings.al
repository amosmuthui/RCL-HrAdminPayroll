report 51525304 Earnings
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/Earnings.rdlc';

    dataset
    {
        dataitem("Assignment Matrix"; "Assignment Matrix")
        {
            DataItemTableView = SORTING("Employee No", Type, Code, "Payroll Period", "Reference No") WHERE(Type = CONST(Payment)/*, Taxable = FILTER(true)*/);
            RequestFilterFields = /*"Payroll Period", */"Transaction Title", Country;
            //RequestFilterHeading = 'NHIF';
            //DataItemLink = "Code" = field("Code");

            column(TransactionTitle; "Assignment Matrix".Description + ' (' + "Assignment Matrix".Country + ')')
            { }
            column(Tel; Tel)
            {
            }
            column(CompPINNo; CompPINNo)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(CurrReport_PAGENO_Control42; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(COMPANYNAME_Control1000000006; CompanyName)
            {
            }
            column(EmployerNHIFNo_Control1000000007; EmployerNHIFNo)
            {
            }
            column(UPPERCASE_FORMAT_DateSpecified_0___Month_Text___year4_____Control1000000009; UpperCase(Format(DateSpecified, 0, '<Month Text> <year4>')))
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(UPPERCASE_FORMAT_DateSpecified_0___Month_Text___year4____; UpperCase(Format(DateSpecified, 0, '<Month Text> <year4>')))
            {
            }
            column(EmployerNHIFNo; EmployerNHIFNo)
            {
            }
            column(Address; Address)
            {
            }
            column(SelectedCountry; "Assignment Matrix".Country)
            {
            }
            column(DesiredCurrency; DesiredCurrency)
            { }
            column(Description_AssignmentMatrix; "Assignment Matrix".Description)
            {
            }
            column(Assignment_Matrix_X1__Assignment_Matrix_X1__Amount; TransAmount/*"Assignment Matrix".Amount*/)
            {
            }
            column(LastName; LastName)
            {
            }
            column(Assignment_Matrix_X1__Assignment_Matrix_X1___Employee_No_; "Assignment Matrix"."Employee No")
            {
            }
            column(FirstName; FirstName)
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(Counter; Counter)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(MONTHLY_EARNINGS_REPORTCaption; MONTHLY_EARNINGS_REPORTCaptionLbl)
            {
            }
            column(Name_of_EmployeeCaption; Name_of_EmployeeCaptionLbl)
            {
            }
            column(EMPLOYER_NOCaption; EMPLOYER_NOCaptionLbl)
            {
            }
            column(Payroll_No_Caption; Payroll_No_CaptionLbl)
            {
            }
            column(PERIODCaption; PERIODCaptionLbl)
            {
            }
            column(EMPLOYERCaption; EMPLOYERCaptionLbl)
            {
            }
            column(ADDRESSCaption; ADDRESSCaptionLbl)
            {
            }
            column(EMPLOYER_PIN_NOCaption; EMPLOYER_PIN_NOCaptionLbl)
            {
            }
            column(TEL_NOCaption; TEL_NOCaptionLbl)
            {
            }
            column(PageCaption_Control44; PageCaption_Control44Lbl)
            {
            }
            column(UserCaption; UserCaptionLbl)
            {
            }
            column(MONTHLY_EARNINGS_REPORTCaption_Control49; MONTHLY_EARNINGS_REPORTCaption_Control49Lbl)
            {
            }
            column(EMPLOYER_NOCaption_Control1000000008; EMPLOYER_NOCaption_Control1000000008Lbl)
            {
            }
            column(PERIODCaption_Control1000000010; PERIODCaption_Control1000000010Lbl)
            {
            }
            column(AmountCaption_Control1000000005; AmountCaption_Control1000000005Lbl)
            {
            }
            column(Name_of_EmployeeCaption_Control1000000055; Name_of_EmployeeCaption_Control1000000055Lbl)
            {
            }
            column(Payroll_No_Caption_Control1000000056; Payroll_No_Caption_Control1000000056Lbl)
            {
            }
            column(Total_AmountCaption; Total_AmountCaptionLbl)
            {
            }
            column(Assignment_Matrix_X1_Type; Type)
            {
            }
            column(Assignment_Matrix_X1_Code; Code)
            {
            }
            column(Assignment_Matrix_X1_Payroll_Period; "Payroll Period")
            {
            }
            column(Assignment_Matrix_X1_Reference_No; "Reference No")
            {
            }
            column(Assignment_MatrixX1_Description; "Assignment Matrix".Description)
            {
            }

            column(MiddleName; MiddleName)
            {
            }
            column(CompName; Compinf.Name)
            {
            }
            column(CompAddress; Compinf.Address)
            {
            }
            column(CompCity; Compinf.City)
            {
            }
            column(CompPicture; Compinf.Picture)
            {
            }
            column(CompGOKPic; Compinf."GOK Picture")
            {
            }
            column(Period; UpperCase(Format(MonthStartDate, 0, '<month text> <year4>')))
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemLink = "No." = FIELD("Employee No");
                DataItemTableView = WHERE(Status = FILTER(Active), Board = CONST(false));
            }

            trigger OnAfterGetRecord()
            begin

                /*if ("Assignment Matrix".getfilter(Country) = '') then
                    Error('You must select the country!');*/
                TransAmount := Round(GetInDesiredCurrency("Assignment Matrix"."Country Currency", "Assignment Matrix".Country, ABS("Assignment Matrix".Amount)));

                // Deductions.SETRANGE(Deductions."Employee No","Assignment Matrix"."Employee No");
                // Deductions.SETRANGE(Deductions."Normal Earnings",TRUE);
                // IF Deductions.FIND('-') THEN
                //  BEGIN
                if Emp.Get("Assignment Matrix"."Employee No") then begin
                    NhifNo := Emp.Test;
                    FirstName := Emp."First Name";
                    LastName := Emp."Last Name";
                    MiddleName := Emp."Middle Name";
                    //TotalAmount := TotalAmount + "Assignment Matrix".Amount;
                    TotalAmount := TotalAmount + TransAmount;//Round(GetInDesiredCurrency("Assignment Matrix"."Country Currency", "Assignment Matrix".Country, ABS("Assignment Matrix".Amount)));
                end;
                //  END;
            end;

            trigger OnPreDataItem()
            begin
                "Assignment Matrix".SetFilter("Payroll Period", '%1', MonthStartDate);
                DateSpecified := MonthStartDate;
            end;
        }

        //EarningRec triggers
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Month Begin Date"; MonthStartDate)
                {
                    Caption = 'Payroll Period';
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
        DesiredCurrency := localCurrencyCode;
    end;

    trigger OnPreReport()
    begin

        Compinf.Get;
        Compinf.CalcFields(Picture);
        Compinf.CalcFields("GOK Picture");
    end;

    var
        DateSpecified: Date;
        NhifNo: Code[20];
        Emp: Record Employee;
        Id: Code[20];
        FirstName: Text[250];
        LastName: Text[250];
        TotalAmount: Decimal;
        "Count": Integer;
        Deductions: Record "Assignment Matrix";
        EmployerNHIFNo: Code[20];
        DOB: Date;
        CompInfoSetup: Record "Loans transactions";
        "HR Details": Record Employee;
        CompPINNo: Code[20];
        YEAR: Integer;
        Address: Text[90];
        Tel: Text[250];
        Counter: Integer;
        AmountCaptionLbl: Label 'Amount';
        PageCaptionLbl: Label 'Page';
        MONTHLY_EARNINGS_REPORTCaptionLbl: Label 'MONTHLY EARNINGS REPORT';
        Name_of_EmployeeCaptionLbl: Label 'Name of Employee';
        EMPLOYER_NOCaptionLbl: Label 'EMPLOYER NO';
        Payroll_No_CaptionLbl: Label 'Payroll No.';
        PERIODCaptionLbl: Label 'PERIOD';
        EMPLOYERCaptionLbl: Label 'EMPLOYER';
        ADDRESSCaptionLbl: Label 'ADDRESS';
        EMPLOYER_PIN_NOCaptionLbl: Label 'EMPLOYER PIN NO';
        TEL_NOCaptionLbl: Label 'TEL NO';
        PageCaption_Control44Lbl: Label 'Page';
        UserCaptionLbl: Label 'User';
        MONTHLY_EARNINGS_REPORTCaption_Control49Lbl: Label 'MONTHLY EARNINGS REPORT';
        EMPLOYER_NOCaption_Control1000000008Lbl: Label 'EMPLOYER NO';
        PERIODCaption_Control1000000010Lbl: Label 'PERIOD';
        AmountCaption_Control1000000005Lbl: Label 'Amount';
        Name_of_EmployeeCaption_Control1000000055Lbl: Label 'Name of Employee';
        Payroll_No_Caption_Control1000000056Lbl: Label 'Payroll No.';
        Total_AmountCaptionLbl: Label 'Total Amount';
        MonthStartDate: Date;
        MiddleName: Text;
        Compinf: Record "Company Information";
        SelectedCountry: Code[50];


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

    procedure PayrollRounding(var Amount: Decimal) PayrollRounding: Decimal
    var
        HRsetup: Record "Human Resources Setup";
    begin

        HRsetup.Get;
        if HRsetup."Payroll Rounding Precision" = 0 then
            Error('You must specify the rounding precision under HR setup');

        if HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Nearest then
            PayrollRounding := Round(Amount, HRsetup."Payroll Rounding Precision", '=');

        if HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Up then
            PayrollRounding := Round(Amount, HRsetup."Payroll Rounding Precision", '>');

        if HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Down then
            PayrollRounding := Round(Amount, HRsetup."Payroll Rounding Precision", '<');
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
            if MonthStartDate = 0D then
                Error('You must select the payroll period before proceeding!');
            CurrExchangeRateDate := CalcDate('1M', MonthStartDate);
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