table 51525501 "Sent Payslips"
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
        field(3; Sent; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Date Sent"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}