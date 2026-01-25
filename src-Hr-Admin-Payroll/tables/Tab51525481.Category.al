table 51525481 Category
{
    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Code", Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}