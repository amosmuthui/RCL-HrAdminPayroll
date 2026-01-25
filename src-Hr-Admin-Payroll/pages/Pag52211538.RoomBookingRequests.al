page 52211538 "Room Booking Requests"
{
    ApplicationArea = All;
    Caption = 'Room Booking Requests';
    PageType = List;
    SourceTable = "Room Booking Requests";
    UsageCategory = Lists;
    CardPageId = "Room Booking Card";

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
                    ToolTip = 'Specifies the value of the Requested By Emp No. field.', Comment = '%';
                }
                field("Requested By Emp Name"; Rec."Requested By Emp Name")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp Name field.', Comment = '%';
                }
                field("Room No."; Rec."Room No.")
                {
                    ToolTip = 'Specifies the value of the Room No. field.', Comment = '%';
                }
                field("Name/Tag"; Rec."Name/Tag")
                {
                    ToolTip = 'Specifies the value of the Name/Tag field.', Comment = '%';
                }
                field("From DateTime"; Rec."From DateTime")
                { }
                field("To DateTime"; Rec."To DateTime")
                { }
                field("Intended Users Description"; Rec."Intended Users Description")
                {
                    ToolTip = 'Specifies the value of the Intended Users Description field.', Comment = '%';
                }
                field("No. of Users"; Rec."No. of Users")
                {
                    ToolTip = 'Specifies the value of the No. of Users field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                }
            }
        }
    }
}
