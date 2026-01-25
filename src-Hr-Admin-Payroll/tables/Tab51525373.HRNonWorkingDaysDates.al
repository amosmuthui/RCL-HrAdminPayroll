table 51525373 "HR Non Working Days & Dates"
{
    fields
    {
        field(1; Date; Date)
        {
        }
        field(2; Reason; Text[100])
        {
        }
        field(3; Recurring; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}