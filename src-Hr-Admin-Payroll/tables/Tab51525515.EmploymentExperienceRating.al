table 51525515 "Employment Experience Rating"
{
    fields
    {
        field(1; Description; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Supervisor Rating"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Work Experienc Rating"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}