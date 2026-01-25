page 51525417 "Applicable Positions"
{
    ApplicationArea = All;
    Caption = 'Applicable Positions';
    PageType = List;
    SourceTable = "Applicable Positions";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Position No."; Rec."Position No.")
                {
                    ToolTip = 'Specifies the value of the Position No. field.', Comment = '%';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.', Comment = '%';
                }
            }
        }
    }
}