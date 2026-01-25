page 51525563 "Payroll Universal Trans Codes"
{
    ApplicationArea = All;
    Caption = 'Payroll Universal Trans Codes';
    PageType = List;
    SourceTable = "Payroll Universal Trans Codes";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Display Order"; Rec."Display Order")
                { }
            }
        }
    }
}