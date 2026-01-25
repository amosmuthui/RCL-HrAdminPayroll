page 51525564 "Training Locations"
{
    ApplicationArea = All;
    Caption = 'Training Locations';
    PageType = List;
    SourceTable = "Training Locations";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.';
                }
            }
        }
    }
}