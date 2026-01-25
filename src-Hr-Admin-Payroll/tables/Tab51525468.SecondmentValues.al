table 51525468 "Secondment Values"
{
    fields
    {
        field(1; "Employee No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Payroll Period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Secondment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Secondment Basic"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No", "Payroll Period")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}