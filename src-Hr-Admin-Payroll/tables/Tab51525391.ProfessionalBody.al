table 51525391 "Professional Body"
{
    DrillDownPageID = "Professional Bodies";
    LookupPageID = "Professional Bodies";

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "No Of Members"; Integer)
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