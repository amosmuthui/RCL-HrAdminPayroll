page 52211532 "Refreshment Requests"
{
    ApplicationArea = All;
    Caption = 'Refreshment Requests';
    PageType = List;
    SourceTable = "Refreshment Requests";
    UsageCategory = Lists;
    CardPageId = "Refreshment Request";

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
                field("Requested By Emp No."; Rec."Requested By Emp No.")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp. No. field.', Comment = '%';
                }
                field("Requested By Emp Name"; Rec."Requested By Emp Name")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp Name field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                }
                field("Date Required"; Rec."Date Required")
                {
                    ToolTip = 'Specifies the value of the Date Required field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
        }
    }
}
