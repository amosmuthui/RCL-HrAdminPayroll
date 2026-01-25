page 52211543 "Recommendation Letters"
{
    ApplicationArea = All;
    Caption = 'Recommendation Letters';
    PageType = List;
    SourceTable = "Recommendation Letters";
    UsageCategory = Lists;
    CardPageId = "Recommendation Letter Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.', Comment = '%';
                }
                field("Emp Name"; Rec."Emp Name")
                {
                    ToolTip = 'Specifies the value of the Emp Name field.', Comment = '%';
                }
                field("Position Code"; Rec."Position Code")
                {
                    ToolTip = 'Specifies the value of the Position Code field.', Comment = '%';
                }
                field("Position Title"; Rec."Position Title")
                {
                    ToolTip = 'Specifies the value of the Position Title field.', Comment = '%';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.', Comment = '%';
                }
                field(Nationality; Rec.Nationality)
                {
                    ToolTip = 'Specifies the value of the Nationality field.', Comment = '%';
                }
                field("Travel Details"; Rec."Travel Details")
                {
                    ToolTip = 'Specifies the value of the Travel Details field.', Comment = '%';
                }
                field("Template No"; Rec."Template No")
                {
                    ToolTip = 'Specifies the value of the Template No field.', Comment = '%';
                }
            }
        }
    }
}
