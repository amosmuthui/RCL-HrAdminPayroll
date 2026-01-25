table 51525365 "Medical Cover Category"
{
    fields
    {
        field(1; Category; Code[10])
        {
        }
        field(2; Inpatient; Decimal)
        {
        }
        field(3; Outpatient; Decimal)
        {
        }
        field(4; Dental; Decimal)
        {
        }
        field(5; Optical; Decimal)
        {
        }
        field(6; "Maternity CS"; Decimal)
        {
        }
        field(7; "Maternity Normal"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Category)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}