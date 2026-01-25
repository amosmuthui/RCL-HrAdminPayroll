page 51525414 "Sub Sections"
{
    ApplicationArea = All;
    Caption = 'Sub Sections';
    PageType = List;
    SourceTable = "Sub Sections";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Section Code"; Rec."Section Code")
                {
                    ToolTip = 'Specifies the value of the Section Code field.', Comment = '%';
                }
            }
        }
    }
}