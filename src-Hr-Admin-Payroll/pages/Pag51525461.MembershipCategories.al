page 51525461 "Membership Categories"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Membership Categories";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(MembershipCategoryID; Rec.MembershipCategoryID)
                {
                    Visible = false;
                }
                field(MembershipCategoryName; Rec.MembershipCategoryName)
                {
                }
                field(MembershipBodyID; Rec.MembershipBodyID)
                {
                }
                field("Membership Body Name"; Rec."Membership Body Name")
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