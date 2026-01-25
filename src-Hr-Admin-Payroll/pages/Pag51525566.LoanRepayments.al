page 51525566 "Loan Repayments"
{
    ApplicationArea = All;
    Caption = 'Loan Repayments';
    PageType = List;
    SourceTable = "Loan Repayments";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Loan No."; Rec."Loan No.")
                {
                    ToolTip = 'Specifies the value of the Loan No. field.';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field("Amount Deducted"; Rec."Amount Deducted")
                {
                    ToolTip = 'Specifies the value of the Amount Deducted field.';
                }
                field("Oustanding Balance"; Rec."Oustanding Balance")
                {
                    ToolTip = 'Specifies the value of the Oustanding Balance field.';
                }
            }
        }
    }
}