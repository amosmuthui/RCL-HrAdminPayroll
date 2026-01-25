page 51525376 "Leave Recalls List"
{
    ApplicationArea = All;
    CardPageID = "Leave Recall";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Leave Recall";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Recall Date"; Rec."Recall Date")
                {
                }
                field("Recalled By"; Rec."Recalled By")
                {
                }
                field("Reason for Recall"; Rec."Reason for Recall")
                {
                }
                field("Recalled From"; Rec."Recalled From")
                {
                }
                field("Recalled To"; Rec."Recalled To")
                {
                }
                field(Posted; Rec.Posted)
                {
                }
                field("Posting DateTime"; Rec."Posting DateTime")
                {
                }
            }
        }
    }

    actions
    {
    }
}