table 51525394 County
{
    DrillDownPageID = Counties;
    LookupPageID = Counties;

    fields
    {
        field(1; "Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[80])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}