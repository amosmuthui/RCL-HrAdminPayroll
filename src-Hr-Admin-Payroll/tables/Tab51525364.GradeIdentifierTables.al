table 51525364 "Grade Identifier Tables"
{
    fields
    {
        field(1; "Identifier Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; "Identifier Description"; Text[80])
        {
        }
        field(3; "Effective Starting Date"; Date)
        {
        }
        field(4; "Effective End Date"; Date)
        {
        }
        field(5; Annual; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Identifier Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}