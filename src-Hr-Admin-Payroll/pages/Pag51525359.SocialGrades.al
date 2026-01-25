page 51525359 "Social Grades"
{
    ApplicationArea = All;
    Caption = 'Social Grades';
    SourceTable = "Social Grades";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Band No."; Rec."Band No.")
                {
                    ToolTip = 'Specifies the value of the Band No. field.';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field("No. of Children"; Rec."No. of Children")
                {
                    ToolTip = 'Specifies the value of the No. of Children field.';
                }
                field("Married Grade"; Rec."Married Grade")
                {
                    ToolTip = 'Specifies the value of the Married Grade field.';
                }
                field("Single Grade"; Rec."Single Grade")
                {
                    ToolTip = 'Specifies the value of the Single Grade field.';
                }
            }
        }
    }
}