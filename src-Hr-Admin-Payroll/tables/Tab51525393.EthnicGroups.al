table 51525393 "Ethnic Groups"
{
    DrillDownPageID = "Ethnic Groups List";
    LookupPageID = "Ethnic Groups List";

    fields
    {
        field(1; "Code"; Code[30])
        {
        }
        field(2; Description; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}