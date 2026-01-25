page 51525554 Districts
{
    ApplicationArea = All;
    Caption = 'Districts';
    PageType = List;
    SourceTable = Districts;
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
                field(Province; Rec.Province)
                {
                    ToolTip = 'Specifies the value of the Province field.';
                }
            }
        }
    }
}