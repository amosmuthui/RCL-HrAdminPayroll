table 51525385 "Membership Bodies"
{
    DrillDownPageID = "Membership Bodies";
    LookupPageID = "Membership Bodies";

    fields
    {
        field(1; MembershipBodyID; Integer)
        {
        }
        field(2; MembershipBodyName; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; MembershipBodyID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; MembershipBodyID, MembershipBodyName)
        {
        }
    }
}