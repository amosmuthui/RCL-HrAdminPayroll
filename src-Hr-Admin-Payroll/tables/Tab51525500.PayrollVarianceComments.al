table 51525500 "Payroll Variance Comments"
{
    Caption = 'Payroll Variance Comments';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Emp No."; Code[100])
        {
            Caption = 'Emp No.';
        }
        field(2; "Employee Name"; Text[240])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(3; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
            TableRelation = "Payroll Period";
            Editable = false;
        }
        field(4; Comment; Text[400])
        {
            Caption = 'Comment';
        }
        field(5; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
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