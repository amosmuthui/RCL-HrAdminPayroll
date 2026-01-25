table 51525426 "Period Causes of Inactivity"
{
    Caption = 'Period Causes of Inactivity';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Emp No."; Code[100])
        {
            Caption = 'Emp No.';
        }
        field(2; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
            TableRelation = "Payroll Period";
        }
        field(3; "Cause of Inactivity"; Text[240])
        {
            Caption = 'Cause of Inactivity';
        }
    }
    keys
    {
        key(PK; "Emp No.", "Payroll Period")
        {
            Clustered = true;
        }
    }
}