page 52211537 "Room Card"
{
    ApplicationArea = All;
    Caption = 'Room Card';
    PageType = Card;
    SourceTable = Rooms;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Name/Tag"; Rec."Name/Tag")
                {
                    ToolTip = 'Specifies the value of the Name/Tag field.', Comment = '%';
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.', Comment = '%';
                }
                field(Capacity; Rec.Capacity)
                {
                    ToolTip = 'Specifies the value of the Capacity field.', Comment = '%';
                }
                field(Equipment; Rec.Equipment)
                {
                    ToolTip = 'Specifies the value of the Equipment field.', Comment = '%';
                    MultiLine = true;
                }
                field("Current Status"; Rec.CurrentRoomStatus())
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                { }
            }
            part("Room Bookings"; "Room Bookings ListPart")
            {
                SubPageLink = "Room No." = field("No.");
                Editable = false;
            }
        }
    }
}
