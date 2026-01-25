table 51525565 "Memo Attenders"
{
    Caption = 'Memo Attenders';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Doc No"; Code[100])
        {
            Caption = 'Doc No';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(3; "Employee No"; Code[100])
        {
            Caption = 'Employee No';
            TableRelation = Employee."No." where(Status = const(Active));
        }
        field(4; "Employee Name"; Text[200])
        {
            Caption = 'Employee Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Employee No")));

        }
    }
    keys
    {
        key(PK; "Doc No", "Line No")
        {
            Clustered = true;
        }
    }
}
