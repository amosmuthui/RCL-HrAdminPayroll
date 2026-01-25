table 51525384 "Membership Categories"
{
    DrillDownPageID = "Membership Categories";
    LookupPageID = "Membership Categories";

    fields
    {
        field(1; MembershipCategoryID; Integer)
        {
            Caption = 'Category Id';
        }
        field(2; MembershipCategoryName; Text[250])
        {
            Caption = 'Category';
        }
        field(3; MembershipBodyID; Integer)
        {
            Caption = 'Body Id';
            TableRelation = "Membership Bodies";
        }
        field(4; "Membership Body Name"; Text[250])
        {
            Caption = 'Body Name';
            CalcFormula = Lookup("Membership Bodies".MembershipBodyName WHERE(MembershipBodyID = FIELD(MembershipBodyID)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; MembershipCategoryID, MembershipBodyID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}