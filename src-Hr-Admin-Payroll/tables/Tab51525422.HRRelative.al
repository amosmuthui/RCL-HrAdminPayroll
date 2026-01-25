table 51525422 "HR Relative"
{
    LookupPageID = "HR Relative";

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Relationship; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Relationship)
        {
        }
    }
}