table 51525470 "Market Intrest Rates"
{
    fields
    {
        field(1; "Loan Code"; Code[20])
        {
        }
        field(2; "Start Date"; Date)
        {
        }
        field(3; "End Date"; Date)
        {
        }
        field(4; Intrest; Decimal)
        {
        }
        field(5; "Tax Percentage"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan Code", "Start Date", "End Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}