table 51525504 "Payroll Approval Transactions"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Payroll Period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Earning,Deduction';
            OptionMembers = ,Earning,Deduction;
        }
        field(4; "ED Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Non Cash"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Employer Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Available Budget"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code", Type, "ED Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}