table 51525513 "Job App Comments/Views"
{
    fields
    {
        field(1; "Applicant No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Views/Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No."; Integer)
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
        /*key(Key2;'')
        {
            Enabled = false;
        }*/
    }

    fieldgroups
    {
    }
}