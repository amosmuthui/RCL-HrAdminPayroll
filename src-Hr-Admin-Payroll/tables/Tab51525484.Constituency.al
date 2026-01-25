table 51525484 Constituency
{
    DrillDownPageID = Constituencies;
    LookupPageID = Constituencies;

    fields
    {
        field(1; "Sub County Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Constituency Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Contituency Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Constituency Description")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Contituency Code", "Constituency Description")
        {
        }
    }
}