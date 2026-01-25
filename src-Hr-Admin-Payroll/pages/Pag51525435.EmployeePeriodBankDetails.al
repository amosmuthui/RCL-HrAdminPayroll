page 51525435 "Employee Period Bank Details"
{
    ApplicationArea = All;
    Caption = 'Employee Period Bank Details';
    PageType = List;
    SourceTable = "Employee Period Bank Details";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the value of the Middle Name field.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.';
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    ToolTip = 'Specifies the value of the Branch Name field.';
                }
                field(IBAN; Rec.IBAN)
                {
                    ToolTip = 'Specifies the value of the IBAN field.';
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ToolTip = 'Specifies the value of the SWIFT Code field.';
                }
                field("Sort Code"; Rec."Sort Code")
                { }
                field(Indicatif; Rec.Indicatif)
                { }
                field("Code B.I.C."; Rec."Code B.I.C.")
                { }
                field("Bank Country"; Rec."Bank Country")
                {
                    ToolTip = 'Specifies the value of the Bank Country field.';
                }
                field("Bank Currency"; Rec."Bank Currency")
                {
                    ToolTip = 'Specifies the value of the Bank Currency field.';
                }
                field(Amount; Rec.Amount)
                { }
            }
        }
    }
}