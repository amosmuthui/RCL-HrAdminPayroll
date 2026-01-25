page 52211536 Rooms
{
    ApplicationArea = All;
    Caption = 'Rooms';
    PageType = List;
    SourceTable = Rooms;
    UsageCategory = Lists;
    CardPageId = "Room Card";

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
                }
                field(Blocked; Rec.Blocked)
                { }
            }
        }
    }
}
