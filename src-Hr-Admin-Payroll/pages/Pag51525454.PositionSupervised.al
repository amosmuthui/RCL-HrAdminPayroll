page 51525454 "Position Supervised"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Position Supervised";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Job ID"; Rec."Job ID")
                {
                    Visible = false;
                }
                field("Position Supervised"; Rec."Position Supervised")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }
}