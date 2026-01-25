page 52211545 "Requisition Fees Requests"
{
    ApplicationArea = All;
    Caption = 'Requisition Fees Requests';
    PageType = List;
    SourceTable = "Requisition Fees Requests";
    UsageCategory = Lists;
    CardPageId = "Requisition Fees Request Card";

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
                    ToolTip = 'Specifies the value of the Emp No. field.', Comment = '%';
                }
                field("Emp Name"; Rec."Emp Name")
                {
                    ToolTip = 'Specifies the value of the Emp Name field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("PV No."; Rec."PV No.")
                {
                    ToolTip = 'Specifies the value of the PV No. field.', Comment = '%';
                }
            }
        }
    }
}
