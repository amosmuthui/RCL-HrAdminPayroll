page 51525463 "Job Requirement Lines"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Job Requirement";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Qualification Type"; Rec."Qualification Type")
                {
                }
                field(Level; Rec.Level)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                }
                field(Qualification; Rec.Qualification)
                {
                }
            }
        }
    }

    actions
    {
    }
}