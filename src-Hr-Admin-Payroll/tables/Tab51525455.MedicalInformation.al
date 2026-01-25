table 51525455 "Medical Information"
{
    DrillDownPageID = "Medical Claim Header";
    LookupPageID = "Medical Claim Header";

    fields
    {
        field(1; Description; Code[50])
        {
        }
        field(2; Remarks; Text[200])
        {
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