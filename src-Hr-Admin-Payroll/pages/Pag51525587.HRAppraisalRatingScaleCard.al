page 51525587 "HR Appraisal Rating Scale Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "HR Appraisal Rating Scale";

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
                field("Rating Scale"; Rec."Rating Scale")
                {
                }
                field(Score; Rec.Score)
                {
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000007; Notes)
            {
            }
        }
    }

    actions
    {
    }
}