table 51525512 "Job App Documents"
{
    fields
    {
        field(1; "Applicant No"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; "Document Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3; "Document Link"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Attached; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Line No."; Integer)
        {
            AutoIncrement = false;
            DataClassification = ToBeClassified;
        }
        field(12; "Job App ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Applications";
        }
    }

    keys
    {
        key(Key1; "Line No.", "Job App ID", "Applicant No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}