page 51525585 "HR Appraisal Values - Card"
{
    ApplicationArea = All;
    Caption = 'HR Appraisal Values & Competences';
    PageType = Card;
    SourceTable = "HR Appraisal Values and Compt.";

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                }
                field(Category; Rec.Category)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000004; Notes)
            {
            }
        }
    }

    actions
    {
    }
}