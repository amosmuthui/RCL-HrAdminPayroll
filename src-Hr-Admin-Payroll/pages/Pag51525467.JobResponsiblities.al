page 51525467 "Job Responsiblities"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Job Responsiblities";

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
                field(Responsibility; Rec.Responsibility)
                {
                    Caption = 'Responsibilities';
                }
            }
        }
    }

    actions
    {
    }
}