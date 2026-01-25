page 51525589 "HR Appraisal Perspectives"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "HR Appraisal Pespectives";

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
                field("Perspective Type"; Rec."Perspective Type")
                {
                }
                field("Perspective Description"; Rec."Perspective Description")
                {
                }
                field("Department Code"; Rec."Department Code")
                {
                }
                field("Department Name"; Rec."Department Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}