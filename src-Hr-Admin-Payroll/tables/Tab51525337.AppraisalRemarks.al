table 51525337 "Appraisal Remarks"
{
    DrillDownPageID = "Appraisal Remarks";
    LookupPageID = "Appraisal Remarks";

    fields
    {
        field(1; "Entry No"; Integer)
        {
            //AutoIncrement = true;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Entry No" > 5 then
                    Error('The value should not exceed 5.');
            end;
        }
        field(2; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
        key(Key2; Remarks)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Remarks; Remarks)
        {
        }
    }
}