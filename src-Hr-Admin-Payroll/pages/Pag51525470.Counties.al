page 51525470 Counties
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = County;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
            }
        }
    }

    actions
    {
    }
}