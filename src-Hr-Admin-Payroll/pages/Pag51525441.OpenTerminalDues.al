page 51525441 "Open Terminal Dues"
{
    ApplicationArea = All;
    Caption = 'Open Terminal Dues';
    PageType = List;
    SourceTable = "Terminal Dues Header";
    UsageCategory = Lists;
    CardPageId = "Terminal Dues Card";
    SourceTableView = sorting("No.") WHERE(Type = const("Final Dues"), "Approval Status" = filter(Open | Rejected));

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
                field("WB No."; Rec."WB No.")
                {
                    ToolTip = 'Specifies the value of the WB No. field.', Comment = '%';
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field(Position; Rec.Position)
                {
                    ToolTip = 'Specifies the value of the Position field.', Comment = '%';
                }
                field("Separation Reason"; Rec."Separation Reason")
                {
                    ToolTip = 'Specifies the value of the Separation Reason field.', Comment = '%';
                }
                field("Join Date"; Rec."Join Date")
                {
                    ToolTip = 'Specifies the value of the Join Date field.', Comment = '%';
                }
                field("Exit Date"; Rec."Exit Date")
                {
                    ToolTip = 'Specifies the value of the Exit Date field.', Comment = '%';
                }
                field("Period Processed"; Rec."Period Processed")
                {
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.', Comment = '%';
                }
            }
        }
    }
}