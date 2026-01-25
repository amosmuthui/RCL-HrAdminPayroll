table 51525445 "Scale Rating"
{
    //DrillDownPageID = "Business Directors Relationshi";
    //LookupPageID = "Business Directors Relationshi";

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Descritption; Text[100])
        {
        }
        field(3; Rate; Decimal)
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