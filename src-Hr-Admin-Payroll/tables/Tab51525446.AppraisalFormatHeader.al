table 51525446 "Appraisal Format Header"
{
    //DrillDownPageID = "Procurement Plan List";
    //LookupPageID = "Procurement Plan List";

    fields
    {
        field(1; Header; Text[50])
        {
        }
        field(2; Priority; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Header)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}