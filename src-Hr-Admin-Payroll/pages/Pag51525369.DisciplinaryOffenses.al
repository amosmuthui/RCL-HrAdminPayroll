page 51525369 "Disciplinary Offenses"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Disciplinary Offenses";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Rating; Rec.Rating)
                {
                }
                field(Comments; Rec.Comments)
                {
                }
            }
        }
    }

    actions
    {
    }
}