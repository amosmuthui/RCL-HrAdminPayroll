table 51525462 "Repayment Schedule"
{
    fields
    {
        field(1; "Loan No"; Code[20])
        {
        }
        field(2; "Employee No"; Code[20])
        {
        }
        field(3; "Repayment Date"; Date)
        {
        }
        field(4; "Loan Amount"; Decimal)
        {
        }
        field(5; "Interest Rate"; Decimal)
        {
        }
        field(6; "Loan Category"; Code[20])
        {
        }
        field(7; "Monthly Repayment"; Decimal)
        {
        }
        field(8; "Employee Name"; Text[100])
        {
        }
        field(9; "Monthly Interest"; Decimal)
        {
        }
        field(10; "Principal Repayment"; Decimal)
        {
        }
        field(11; "Instalment No"; Integer)
        {
        }
        field(12; "Remaining Debt"; Decimal)
        {
        }
        field(13; "Payroll Group"; Code[20])
        {
        }
        field(14; Paid; Boolean)
        {
        }
        field(50000; "Top up"; Boolean)
        {
        }
        field(50001; "Top up Amount 1"; Decimal)
        {
        }
        field(50002; "Repayment Amount"; Decimal)
        {
        }
        field(50003; "Top Up 2"; Boolean)
        {
        }
        field(50004; "Top Up 3"; Boolean)
        {
        }
        field(50005; "Top Up 4"; Boolean)
        {
        }
        field(50006; "Top Up 5"; Boolean)
        {
        }
        field(50007; "Top Up 6"; Boolean)
        {
        }
        field(50008; "Top Up 7"; Boolean)
        {
        }
        field(50009; "Top Up 2 Amount"; Decimal)
        {
        }
        field(50010; "Top Up 3 Amount"; Decimal)
        {
        }
        field(50011; "Top Up 4 Amount"; Decimal)
        {
        }
        field(50012; "Top Up 5 Amount"; Decimal)
        {
        }
        field(50013; "Top Up 6 Amount"; Decimal)
        {
        }
        field(50014; "Top Up 7 Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No", "Employee No", "Repayment Date")
        {
            Clustered = true;
        }
        key(Key2; "Loan Category", "Repayment Date")
        {
            SumIndexFields = "Loan Amount";
        }
        key(Key3; "Loan No", "Repayment Date")
        {
        }
        key(Key4; "Loan Category", "Employee No", "Repayment Date")
        {
        }
    }

    fieldgroups
    {
    }
}