page 51525453 "J. Position Supervised"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Company Jobs";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Job Description"; Rec."Job Description")
                {
                }
            }
            label(Control1000000006)
            {
                CaptionClass = Text19055674;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            part(KPA; "Position Supervised")
            {
                SubPageLink = "Job ID" = FIELD("Job ID");
            }
        }
    }

    actions
    {
    }

    var
        Text19055674: Label 'Positions Supervised';
}