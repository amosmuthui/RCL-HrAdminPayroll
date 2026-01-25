page 51525462 "Membership Bodies"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Membership Bodies";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(MembershipBodyID; Rec.MembershipBodyID)
                {
                }
                field(MembershipBodyName; Rec.MembershipBodyName)
                {
                }
            }
        }
    }

    actions
    {
    }
}