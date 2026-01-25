page 51525460 "Education Levels"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Academic Education Level";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EducationLevelID; Rec.EducationLevelID)
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