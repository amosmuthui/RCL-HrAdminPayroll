page 51525555 Sectors
{
    ApplicationArea = All;
    Caption = 'Sectors';
    PageType = List;
    SourceTable = Sectors;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(District; Rec.District)
                {
                    ToolTip = 'Specifies the value of the District field.';
                }
            }
        }
    }
}