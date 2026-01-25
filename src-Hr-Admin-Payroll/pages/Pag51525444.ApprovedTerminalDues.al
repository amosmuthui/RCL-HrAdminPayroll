page 51525444 "Approved Terminal Dues"
{
    ApplicationArea = All;
    Caption = 'Approved Terminal Dues';
    PageType = List;
    SourceTable = "Terminal Dues Header";
    CardPageId = "Terminal Dues Card";
    UsageCategory = Lists;
    SourceTableView = sorting("No.") order(descending) WHERE(Type = const("Final Dues"), "Approval Status" = filter(Released));

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
                field(Position; Rec.Position)
                {
                    ToolTip = 'Specifies the value of the Position field.', Comment = '%';
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.', Comment = '%';
                }
                field("Join Date"; Rec."Join Date")
                {
                    ToolTip = 'Specifies the value of the Join Date field.', Comment = '%';
                }
                field("Exit Date"; Rec."Exit Date")
                {
                    ToolTip = 'Specifies the value of the Exit Date field.', Comment = '%';
                }
                field("Separation Reason"; Rec."Separation Reason")
                {
                    ToolTip = 'Specifies the value of the Separation Reason field.', Comment = '%';
                }
                field("Period Processed"; Rec."Period Processed")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
        }
    }
}