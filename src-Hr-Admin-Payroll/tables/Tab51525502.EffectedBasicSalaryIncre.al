table 51525502 "Effected Basic Salary Incre"
{
    fields
    {
        field(1; Period; Date)
        {
        }
        field(2; "Initial Basic Salary"; Decimal)
        {
        }
        field(3; "Increased by Amount"; Decimal)
        {
        }
        field(4; "New Basic Salary"; Decimal)
        {
        }
        field(5; Date; Date)
        {
        }
        field(6; Time; Time)
        {
        }
    }

    keys
    {
        key(Key1; Period)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}