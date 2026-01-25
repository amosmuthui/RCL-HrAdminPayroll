page 51525401 "Training Master Plan Lines"
{
    ApplicationArea = All;
    //Caption = 'Training Master Plan Lines';
    Caption = 'Applicable Job Positions';
    PageType = ListPart;
    SourceTable = "Training Master Plan Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                /*field(Position; Rec.Position)
                {
                    ToolTip = 'Specifies the value of the Position ID field.';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Position Title field.';
                }*/
                field("Dept Code"; Rec."Dept Code")
                { }
                field("Department Name"; Rec."Department Name")
                { }
            }
        }
    }
}