page 51525336 "Employee Change Requests"
{
    ApplicationArea = All;
    Caption = 'Employee Change Requests';
    PageType = List;
    SourceTable = "Change Request";
    UsageCategory = Lists;
    CardPageId = "Employee Change Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Emp No."; Rec."Emp No.")
                {
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.', Comment = '%';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the value of the Middle Name field.', Comment = '%';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Surname/Family Name field.', Comment = '%';
                }
                field("USER ID"; Rec."USER ID")
                { }
                field("Change Approval Status"; Rec."Change Approval Status")
                {
                    ToolTip = 'Specifies the value of the Change Approval Status field.', Comment = '%';
                }
            }
        }
    }
}