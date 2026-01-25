page 51525595 "Professional Levels"
{
    ApplicationArea = All;
    Caption = 'Professional Levels';
    PageType = List;
    SourceTable = "Professional Levels";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ProfessionalLevelID; Rec.ProfessionalLevelID)
                {
                }
                field(ProfessionalLevelName; Rec.ProfessionalLevelName)
                {
                }
                field(ProfessionalBodyID; Rec.ProfessionalBodyID)
                {
                }
                field("Body Name"; Rec."Body Name")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}