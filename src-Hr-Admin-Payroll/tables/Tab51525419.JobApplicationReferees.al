table 51525419 "Job Application Referees"
{
    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Names; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Designation; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Company; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Address; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Telephone No"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "E-Mail"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(9; Notes; Text[250])
        {
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
        key(Key1; "Job App ID", No, "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}