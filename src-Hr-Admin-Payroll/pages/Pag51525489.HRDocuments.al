page 51525489 "HR Documents"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "HR Documents";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
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