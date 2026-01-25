report 51525337 P10B
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/P10B.rdlc';

    dataset
    {
        dataitem("Loans transactions"; "Loans transactions")
        {
            RequestFilterFields = "Code";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Year; Year)
            {
            }
            column(Loans_transactionsX1_Code; Code)
            {
            }
            column(Loans_transactionsX1_Name; Name)
            {
            }
            column(Loans_transactionsX1_Employee; Employee)
            {
            }
            column(Loans_transactionsX1__Loan_Amount_; "Loan Amount")
            {
            }
            column(Loans_transactionsX1__Interest_Rate_; "Interest Rate")
            {
            }
            column(FRINGE_BENEFIT_TAX_REPORT_P10BCaption; FRINGE_BENEFIT_TAX_REPORT_P10BCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(PERIODCaption; PERIODCaptionLbl)
            {
            }
            column(UserCaption; UserCaptionLbl)
            {
            }
            column(Loans_transactionsX1_EmployeeCaption; FieldCaption(Employee))
            {
            }
            column(Loans_transactionsX1__Loan_Amount_Caption; FieldCaption("Loan Amount"))
            {
            }
            column(Interest_Rate__Caption; Interest_Rate__CaptionLbl)
            {
            }
            column(Tax_PayableCaption; Tax_PayableCaptionLbl)
            {
            }
            column(Loan_BalanceCaption; Loan_BalanceCaptionLbl)
            {
            }
            column(Loans_transactionsX1_CodeCaption; FieldCaption(Code))
            {
            }
            column(Loans_transactionsX1_NameCaption; FieldCaption(Name))
            {
            }
            column(Market_Interest_Rate__Caption; Market_Interest_Rate__CaptionLbl)
            {
            }
            dataitem("Payroll Period"; "Payroll Period")
            {
                column(Payroll_PeriodX1_Name; Name)
                {
                }
                column(Payroll_PeriodX1__Market_Interest_Rate___; "Market Interest Rate %")
                {
                }
                column(Loans_transactionsX1___Interest_Rate_; "Loans transactions"."Interest Rate")
                {
                }
                column(TaxPayable; TaxPayable)
                {
                }
                column(Outstanding; Outstanding)
                {
                }
                column(TotTaxpayable; TotTaxpayable)
                {
                }
                column(Payroll_PeriodX1_Starting_Date; "Starting Date")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "Loans transactions".SetRange("Loans transactions"."Date Filter", 0D, "Payroll Period"."Starting Date");
                    "Loans transactions".CalcFields("Loans transactions"."Amount Paid");
                    Outstanding := "Loans transactions"."Loan Amount" + "Loans transactions"."Amount Paid";
                    TaxPayable := Outstanding * (("Payroll Period"."Market Interest Rate %" - "Loans transactions"."Interest Rate") *
                    HRSetup."Corporation Tax" / 12000);
                    TaxPayable := PayrollRounding(TaxPayable);
                    TotTaxpayable := TotTaxpayable + TaxPayable;
                end;

                trigger OnPreDataItem()
                begin
                    "Payroll Period".SetRange("Payroll Period"."Close Pay", true);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotTaxpayable := 0;
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
        // Employee.SETFILTER("Pay Period Filter",'%1',MonthStartDate);
        "Payroll Period".SetFilter("Starting Date", '%1', MonthStartDate);

        //BeginDate:="Payroll Period".GETRANGEMIN("Payroll Period"."Starting Date");
        BeginDate := MonthStartDate;
        Year := Date2DMY(BeginDate, 3);
        HRSetup.Get;
    end;

    var
        TaxPayable: Decimal;
        Outstanding: Decimal;
        HRSetup: Record "Human Resources Setup";
        TotTaxpayable: Decimal;
        BeginDate: Date;
        Year: Integer;
        FRINGE_BENEFIT_TAX_REPORT_P10BCaptionLbl: Label 'FRINGE BENEFIT TAX REPORT P10B';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        PERIODCaptionLbl: Label 'PERIOD';
        UserCaptionLbl: Label 'User';
        Interest_Rate__CaptionLbl: Label 'Interest Rate %';
        Tax_PayableCaptionLbl: Label 'Tax Payable';
        Loan_BalanceCaptionLbl: Label 'Loan Balance';
        Market_Interest_Rate__CaptionLbl: Label 'Market Interest Rate %';
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