table 51525410 "Applicant Documents"
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
            ExtendedDatatype = URL;
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
        field(6; DocumentNo; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Documents".Code;
        }
        field(7; "Email Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Document Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Applicant No", "Document Description", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        HRDocuments: Record "HR Documents";
}