page 51525371 "Levels of Discipline List"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Levels of Discipline";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Level; Rec.Level)
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