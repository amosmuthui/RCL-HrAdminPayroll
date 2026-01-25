table 51525472 "Period Department Sections"
{
    Caption = 'Period Department Sections';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
            TableRelation = "Payroll Period";
        }
        field(2; "Section Code"; Code[240])
        {
            Caption = 'Section Code';
            TableRelation = "Sub Responsibility Center";
        }
        field(3; "Section Name"; Text[240])
        {
            Caption = 'Section Name';
        }
        field(4; "Department Code"; Code[240])
        {
            Caption = 'Department Code';
            TableRelation = "Responsibility Center";
        }
        field(5; "Department Name"; Text[240])
        {
            Caption = 'Department Name';
        }
    }
    keys
    {
        key(PK; "Payroll Period", "Section Code", "Department Code")
        {
            Clustered = true;
        }
    }
}