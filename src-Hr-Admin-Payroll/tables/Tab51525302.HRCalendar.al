table 51525302 "HR Calendar"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; "Created By"; Text[100])
        {
        }
        field(3; "Start Date"; Date)
        {
        }
        field(4; "End Date"; Date)
        {
        }
        field(5; Current; Boolean)
        {
        }
        field(6; Description; Text[100])
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
    }
}