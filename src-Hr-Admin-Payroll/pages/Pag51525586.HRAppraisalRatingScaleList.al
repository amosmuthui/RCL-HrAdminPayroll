page 51525586 "HR Appraisal Rating Scale List"
{
    ApplicationArea = All;
    CardPageID = "HR Appraisal Rating Scale Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "HR Appraisal Rating Scale";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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