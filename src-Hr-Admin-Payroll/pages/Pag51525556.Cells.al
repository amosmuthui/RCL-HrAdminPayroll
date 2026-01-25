page 51525556 Cells
{
    ApplicationArea = All;
    Caption = 'Cells';
    PageType = List;
    SourceTable = Cells;
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
                field(Sector; Rec.Sector)
                {
                    ToolTip = 'Specifies the value of the Sector field.';
                }
            }
        }
    }
}