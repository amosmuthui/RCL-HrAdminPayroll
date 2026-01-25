table 51525532 "Employee Leave Type"
{
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employees.Get("Employee No.") then begin
                    "Employee Name" := Employees."First Name" + ' ' + Employees."Middle Name" + ' ' + Employees."Last Name";
                end;
            end;
        }
        field(2; "Leave Type"; Code[50])
        {
            Caption = 'Leave Type';
            TableRelation = "Leave Types".Code;

            trigger OnValidate()
            begin
                Description := '';
                if HRLeaveType.Get("Leave Type") then
                    Description := HRLeaveType.Description;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(4; "Allocation Days"; Decimal)
        {
            Caption = 'Allocation Days';
            Editable = false;
        }
        field(5; "Leave Balance"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("Employee No."),
                                                                             "Leave Period" = FIELD("Current Period"),
                                                                             "Leave Type" = FIELD("Leave Type")));
            Caption = 'Leave Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Days Taken"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("Employee No."),
                                                                             "Leave Period" = FIELD("Current Period"),
                                                                             "Leave Type" = FIELD("Leave Type"),
                                                                             "No. of days" = FILTER(< 0)));
            FieldClass = FlowField;
        }
        field(10; "Current Period"; Code[20])
        {
            Caption = 'Current Period';
            DataClassification = ToBeClassified;
            TableRelation = "HR Leave Periods"."Period Code";
        }
        field(11; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Basic Pay"; Decimal)
        {
            CalcFormula = Lookup("Assignment Matrix".Amount WHERE("Basic Salary Code" = CONST(true),
                                                                   "Employee No" = FIELD("Employee No.")));
            Caption = 'Basic Pay';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Leave Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        HRLeaveType: Record "Leave Types";
        Employees: Record Employee;
}