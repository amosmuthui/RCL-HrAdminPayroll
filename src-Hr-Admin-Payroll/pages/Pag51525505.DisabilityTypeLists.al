page 51525505 "Disability Type Lists"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Disability Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Disability Code"; Rec."Disability Code")
                {
                }
                field("Disability Description"; Rec."Disability Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}