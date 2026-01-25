page 51525381 "Performance Management Themes"
{
    ApplicationArea = All;
    Caption = 'Performance Management Themes';
    PageType = List;
    SourceTable = "Performance Management Themes";
    UsageCategory = Lists;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}