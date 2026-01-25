page 51525449 "Leave Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Leave Ledger Entries';
    PageType = List;
    SourceTable = "HR Leave Ledger Entries";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Staff No."; Rec."Staff No.")
                {
                    ToolTip = 'Specifies the value of the Staff No. field.';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ToolTip = 'Specifies the value of the Staff Name field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Leave Entry Type"; Rec."Leave Entry Type")
                {
                    ToolTip = 'Specifies the value of the Leave Entry Type field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("No. of days"; Rec."No. of days")
                {
                    ToolTip = 'Specifies the value of the No. of days field.';
                }
                field("Leave Posting Description"; Rec."Leave Posting Description")
                {
                    ToolTip = 'Specifies the value of the Leave Posting Description field.';
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type field.';
                }
                field("Leave Start Date"; Rec."Leave Start Date")
                {
                    ToolTip = 'Specifies the value of the Leave Start Date field.';
                }
                field("Leave End Date"; Rec."Leave End Date")
                {
                    ToolTip = 'Specifies the value of the Leave End Date field.';
                }
                field("Leave Return Date"; Rec."Leave Return Date")
                {
                    ToolTip = 'Specifies the value of the Leave Return Date field.';
                }
                field("Leave Period"; Rec."Leave Period")
                { }
            }
        }
    }
}