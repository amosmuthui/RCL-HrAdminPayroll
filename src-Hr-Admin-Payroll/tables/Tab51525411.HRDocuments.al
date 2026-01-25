table 51525411 "HR Documents"
{
    DrillDownPageID = "HR Documents";
    LookupPageID = "HR Documents";

    fields
    {
        field(1; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Global; Boolean)
        {
            DataClassification = ToBeClassified;
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