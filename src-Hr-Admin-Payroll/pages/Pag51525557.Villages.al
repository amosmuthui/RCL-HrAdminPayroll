page 51525557 Villages
{
    ApplicationArea = All;
    Caption = 'Villages';
    PageType = List;
    SourceTable = Villages;
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
                field(Cell; Rec.Cell)
                {
                    ToolTip = 'Specifies the value of the Cell field.';
                }
            }
        }
    }
}