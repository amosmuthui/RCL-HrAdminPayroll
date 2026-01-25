table 51525464 "Staff Posting Group"
{
    DataCaptionFields = "Code", Description;
    DrillDownPageID = "Staff Posting Group";
    LookupPageID = "Staff Posting Group";

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Salary Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Income Tax Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(5; "SSF Employer Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(6; "SSF Employee Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Net Salary Payable"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Operating Overtime"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Tax Relief"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(10; "Employee Provident Fund Acc."; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(11; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll Period";
        }
        field(12; "Pension Employer Acc"; Code[10])
        {
        }
        field(13; "Pension Employee Acc"; Code[10])
        {
        }
        field(14; "Earnings and deductions"; Code[10])
        {
        }
        field(15; "Daily Salary"; Decimal)
        {
            FieldClass = Normal;
        }
        field(16; "Normal Overtime"; Decimal)
        {
            FieldClass = Normal;
        }
        field(17; "Weekend Overtime"; Decimal)
        {
            FieldClass = Normal;
        }
        field(18; "Enterprise Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(19; "Activity Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(20; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(21; Seasonals; Boolean)
        {
        }
        field(22; "Fringe benefits"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(23; "Is Temporary"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Is Permanent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Is Intern"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Is Contract"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Seconded Employees"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Tax Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Earnings and deductions")
        {
        }
    }

    fieldgroups
    {
    }
}