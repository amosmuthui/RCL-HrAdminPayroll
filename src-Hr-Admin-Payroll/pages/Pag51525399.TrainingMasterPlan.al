page 51525399 "Training Master Plan"
{
    ApplicationArea = All;
    Caption = 'Courses';
    PageType = List;
    SourceTable = "Training Master Plan Header";
    UsageCategory = Lists;
    CardPageId = "Training Master Plan Card";
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Recurrence; Rec.Recurrence)
                {
                    ToolTip = 'Specifies the value of the Recurrence field.';
                }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.';
                }
                field("Approximate Duration"; Rec."Approximate Duration")
                {
                    ToolTip = 'Specifies the value of the Approximate Duration field.';
                }
                field("Mandatory/Optional"; Rec."Mandatory/Optional")
                {
                    ToolTip = 'Specifies the value of the Mandatory/Optional field.';
                }
                field("Notification Period Notice"; Rec."Notification Period Notice")
                {
                    ToolTip = 'Specifies the value of the Notification Period Notice field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }
}