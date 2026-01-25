table 51525312 "Job Exit Reason"
{
    DrillDownPageID = "Job Exit Reason List";
    LookupPageID = "Job Exit Reason List";

    fields
    {
        field(1; Reason; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Reason)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}