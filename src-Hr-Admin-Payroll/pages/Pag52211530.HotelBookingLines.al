page 52211530 "Hotel Booking Lines"
{
    ApplicationArea = All;
    Caption = 'Hotel Booking Lines';
    PageType = ListPart;
    SourceTable = "Hotel Booking Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Traveler Category"; Rec."Traveler Category")
                {
                    ToolTip = 'Specifies the value of the Traveler Category field.', Comment = '%';
                }
                field("Traveler No."; Rec."Traveler No.")
                {
                    ToolTip = 'Specifies the value of the Traveler No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.', Comment = '%';
                }
                field("Special Requirements"; Rec."Special Requirements")
                {
                    ToolTip = 'Specifies the value of the Special Requirements field.', Comment = '%';
                    MultiLine = true;
                }
            }
        }
    }
}
