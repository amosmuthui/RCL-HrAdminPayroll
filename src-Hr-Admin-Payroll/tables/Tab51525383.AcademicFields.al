table 51525383 "Academic Fields"
{
    fields
    {
        field(1; "Code"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Academic Field"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Category; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", Category)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}