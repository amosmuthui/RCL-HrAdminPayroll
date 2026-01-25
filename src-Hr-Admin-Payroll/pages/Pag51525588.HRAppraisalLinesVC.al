page 51525588 "HR Appraisal Lines - VC"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "HR Appraisal Lines - Values";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal No."; Rec."Appraisal No.")
                {
                    Editable = false;
                }
                field("Code"; Rec.Code)
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Category; Rec.Category)
                {
                    Editable = false;
                }
                label("*")
                {
                    Editable = false;
                    ShowCaption = true;
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field(Score; Rec.Score)
                {
                }
                field("Appraisee Comments"; Rec."Appraisee Comments")
                {
                }
                field("Supervisor Score"; Rec."Supervisor Score")
                {
                }
                field("Agreed Score"; Rec."Agreed Score")
                {
                }
                field("Score Descriptors"; Rec."Score Descriptors")
                {
                }
            }
        }
    }

    actions
    {
    }
}