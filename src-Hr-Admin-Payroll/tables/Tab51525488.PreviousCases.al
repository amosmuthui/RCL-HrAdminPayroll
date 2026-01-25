table 51525488 "Previous Cases"
{
    fields
    {
        field(1; "Case No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Employee Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Case Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Action Taken"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Appeal Descision"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Case No", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}