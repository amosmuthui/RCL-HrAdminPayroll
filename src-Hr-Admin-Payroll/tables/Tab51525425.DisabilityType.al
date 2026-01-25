table 51525425 "Disability Type"
{
    DrillDownPageID = "Disability Type Lists";
    LookupPageID = "Disability Type Lists";

    fields
    {
        field(1; "Disability Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Disability Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Disability Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}