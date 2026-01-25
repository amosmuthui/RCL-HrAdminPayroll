table 51525326 "Levels of Discipline"
{

    fields
    {
        field(1; Level; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Level)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}