table 51525379 "Job Responsibility Category"
{
    DrillDownPageID = "Job Responisbility Category";
    LookupPageID = "Job Responisbility Category";

    fields
    {
        field(1; "Job Responsibility Category"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job Responsibility Category")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}