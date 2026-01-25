table 51525407 "Former Positions"
{
    DrillDownPageID = "Former Positions List";
    LookupPageID = "Former Positions List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[250])
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