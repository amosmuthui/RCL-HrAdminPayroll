table 51525412 "Applicant Comments/Views"
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
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Applicant No", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}