table 51525454 "Medical History"
{
    fields
    {
        field(1; "Employee No"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[220])
        {
            NotBlank = true;
            TableRelation = "Medical Information".Description;
        }
        field(3; Results; Text[250])
        {
        }
        field(4; Date; Date)
        {
        }
        field(5; Remarks; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No", Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}