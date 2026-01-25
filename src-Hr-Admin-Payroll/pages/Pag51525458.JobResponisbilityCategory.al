page 51525458 "Job Responisbility Category"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Responsibility Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Responsibility Category"; Rec."Job Responsibility Category")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}