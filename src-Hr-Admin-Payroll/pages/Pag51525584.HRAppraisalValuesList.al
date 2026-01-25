page 51525584 "HR Appraisal Values - List"
{
    ApplicationArea = All;
    Caption = 'HR Appraisal Values & Competences';
    CardPageID = "HR Appraisal Values - Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "HR Appraisal Values and Compt.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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