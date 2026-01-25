page 52211551 "Accident / Incident Logs Lines"
{
    ApplicationArea = All;
    Caption = 'Accident / Incident Logs Kines';
    PageType = ListPart;
    SourceTable = "Accident / Incident Logs Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Doc. No."; Rec."Doc. No.")
                {
                    ToolTip = 'Specifies the value of the Doc. No. field.', Comment = '%';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Visible = false;
                }
                field("Person Involved"; Rec."Person Involved")
                {
                    ToolTip = 'Specifies the value of the Person Involved field.', Comment = '%';
                }
                field(Department; Rec.Department)
                {

                }
            }
        }
    }
}
