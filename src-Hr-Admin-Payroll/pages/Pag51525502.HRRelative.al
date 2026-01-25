page 51525502 "HR Relative"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "HR Relative";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Relationship; Rec.Relationship)
                {
                }
            }
        }
    }

    actions
    {
    }
}