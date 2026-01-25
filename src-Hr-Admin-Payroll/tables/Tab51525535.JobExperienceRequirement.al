table 51525535 "Job Experience Requirement"
{
    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Years; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Mandatory; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Chapter6Requirement: Record "Chapter 6 Requirement";
}