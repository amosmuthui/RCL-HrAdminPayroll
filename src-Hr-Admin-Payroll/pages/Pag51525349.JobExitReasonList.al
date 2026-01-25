page 51525349 "Job Exit Reason List"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Exit Reason";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Reason; Rec.Reason)
                {
                }
            }
        }
    }

    actions
    {
    }
}