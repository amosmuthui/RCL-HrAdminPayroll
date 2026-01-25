report 51525334 P10
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/P10.rdlc';

    dataset
    {
        dataitem("Payroll Period"; "Payroll Period")
        {
            DataItemTableView = SORTING("Starting Date");
            column(EmptyString; '......................................................................')
            {
            }
            column(DataItem22; 'We/I forward herewith ...........Tax Deduction Cards(P9A/P9B) showing the total tax deducted(as listed on P.10A) amounting to Kshs.................................................')
            {
            }
            column(This_total_tax_has_been_paid_as_follows___; 'This total tax has been paid as follows:-')
            {
            }
            column(Company__Company_P_I_N_; Company."Company P.I.N")
            {
            }
            column(FORMAT__Starting_Date__0___year4___; Format("Starting Date", 0, '<year4>'))
            {
            }
            column(Payroll_PeriodX1_Name; Name)
            {
            }
            column(EmptyString_Control16; '......................................................................')
            {
            }
            column(ABS_paye_; Abs(paye))
            {
            }
            column(STRSUBSTNO__NAME_OF_EMPLOYER_____1__COMPANYNAME_; StrSubstNo('NAME OF EMPLOYER:   %1', CompanyName))
            {
            }
            column(ABS__P_A_Y_E__; Abs("P.A.Y.E"))
            {
            }
            column(We_I_certify_that_the_particulars_entered_above_are_correct_; 'We/I certify that the particulars entered above are correct')
            {
            }
            column(OFFICIAL_USE_; 'OFFICIAL USE')
            {
            }
            column(BATCH_No_________________________________________________________________; 'BATCH No................................................................')
            {
            }
            column(SIGNATURE____________________________________________________________; 'SIGNATURE...........................................................')
            {
            }
            column(DATE______________________________________________________________________; 'DATE.....................................................................')
            {
            }
            column(SIGNATURE_______________________________________________________________; 'SIGNATURE..............................................................')
            {
            }
            column(DATE___________________________________________________________________________; 'DATE..........................................................................')
            {
            }
            column(Payroll_PeriodX1__P_A_Y_E_; "P.A.Y.E")
            {
            }
            column(P10Caption; P10CaptionLbl)
            {
            }
            column(KENYA_REVENUE_AUTHORITYCaption; KENYA_REVENUE_AUTHORITYCaptionLbl)
            {
            }
            column(INCOME_TAX_DEPARTMENTCaption; INCOME_TAX_DEPARTMENTCaptionLbl)
            {
            }
            column(P_A_Y_E_EMPLOYER_S_CERTIFICATECaption; P_A_Y_E_EMPLOYER_S_CERTIFICATECaptionLbl)
            {
            }
            column(To_Senior_Assistant_Assistant_Commisioner_Caption; To_Senior_Assistant_Assistant_Commisioner_CaptionLbl)
            {
            }
            column(EMPLOYER_S_P_I_NCaption; EMPLOYER_S_P_I_NCaptionLbl)
            {
            }
            column(YEARCaption; YEARCaptionLbl)
            {
            }
            column(MonthCaption; MonthCaptionLbl)
            {
            }
            column(P_A_Y_E_TAXCaption; P_A_Y_E_TAXCaptionLbl)
            {
            }
            column(DATE_PAID_PER_RECEIVING_BANK_STAMP_Caption; DATE_PAID_PER_RECEIVING_BANK_STAMP_CaptionLbl)
            {
            }
            column(TOTAL_TAX_SHS_Caption; TOTAL_TAX_SHS_CaptionLbl)
            {
            }
            column(ADDRESS__________________________________________________________________Caption; ADDRESS__________________________________________________________________CaptionLbl)
            {
            }
            column(Payroll_PeriodX1_Starting_Date; "Starting Date")
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Payroll Period".CalcFields("Payroll Period"."P.A.Y.E");
                paye := "Payroll Period"."P.A.Y.E";
                Totpaye := Totpaye + paye;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(MonthStartDate; MonthStartDate)
                {
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

    trigger OnPreReport()
    begin
        Company.Get;

        "Payroll Period".SetFilter("Starting Date", '%1', MonthStartDate);
        // Period:="Payroll Period".GETFILTER("Payroll Period"."Starting Date");

        //  Employee.SETFILTER("Pay Period Filter",'%1',MonthStartDate);
    end;

    var
        Company: Record "Company Information";
        paye: Decimal;
        Totpaye: Decimal;
        Period: Text[30];
        //GetGroup: Codeunit "Payment- Post";
        GroupCode: Code[20];
        CUser: Code[20];
        P10CaptionLbl: Label 'P10';
        KENYA_REVENUE_AUTHORITYCaptionLbl: Label 'KENYA REVENUE AUTHORITY';
        INCOME_TAX_DEPARTMENTCaptionLbl: Label 'INCOME TAX DEPARTMENT';
        P_A_Y_E_EMPLOYER_S_CERTIFICATECaptionLbl: Label 'P.A.Y.E-EMPLOYER''S CERTIFICATE';
        To_Senior_Assistant_Assistant_Commisioner_CaptionLbl: Label 'To Senior Assistant/Assistant Commisioner ';
        EMPLOYER_S_P_I_NCaptionLbl: Label 'EMPLOYER''S P.I.N';
        YEARCaptionLbl: Label 'YEAR';
        MonthCaptionLbl: Label 'Month';
        P_A_Y_E_TAXCaptionLbl: Label 'P.A.Y.E TAX';
        DATE_PAID_PER_RECEIVING_BANK_STAMP_CaptionLbl: Label 'DATE PAID PER(RECEIVING BANK STAMP)';
        TOTAL_TAX_SHS_CaptionLbl: Label 'TOTAL TAX SHS.';
        ADDRESS__________________________________________________________________CaptionLbl: Label 'ADDRESS .................................................................';
        MonthStartDate: Date;

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
}