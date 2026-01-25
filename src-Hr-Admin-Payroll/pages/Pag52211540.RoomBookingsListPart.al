page 52211540 "Room Bookings ListPart"
{
    ApplicationArea = All;
    Caption = 'Room Bookings';
    PageType = ListPart;
    SourceTable = "Room Booking Requests";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Requested By Emp No."; Rec."Requested By Emp No.")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp No. field.', Comment = '%';
                }
                field("Requested By Emp Name"; Rec."Requested By Emp Name")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp Name field.', Comment = '%';
                }
                field("From DateTime"; Rec."From DateTime")
                {
                    ToolTip = 'Specifies the value of the From DateTime field.', Comment = '%';
                }
                field("To DateTime"; Rec."To DateTime")
                {
                    ToolTip = 'Specifies the value of the To DateTime field.', Comment = '%';
                }
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
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
        }
    }
}
