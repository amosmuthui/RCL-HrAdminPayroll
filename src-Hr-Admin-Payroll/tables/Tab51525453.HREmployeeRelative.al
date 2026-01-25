table 51525453 "HR Employee Relative"
{
    DataCaptionFields = "Employee No.", Relationship, "First Name", "Last Name", "Day Phone Number", "Evening Phone Number", "Postal Address", "Residential Address", "Type Of Contact";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            FieldClass = Normal;
            NotBlank = true;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                OK := Employee.Get("Employee No.");
                if OK then begin
                    "Employee First Name" := Employee."Known As";
                    "Employee Last Name" := Employee."Last Name";
                end;
            end;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Relationship; Code[10])
        {
            NotBlank = true;
            TableRelation = "HR Relative".Code;
        }
        field(4; "First Name"; Text[30])
        {
            FieldClass = Normal;
            NotBlank = true;
        }
        field(6; "Last Name"; Text[30])
        {
            FieldClass = Normal;
        }
        field(8; "Day Phone Number"; Text[30])
        {
        }
        field(9; "Evening Phone Number"; Text[30])
        {
        }
        field(10; "Relative's Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(11; Comment; Boolean)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(12; "Postal Address"; Text[30])
        {
        }
        field(13; "Residential Address"; Text[30])
        {
        }
        field(14; "Type Of Contact"; Option)
        {
            OptionMembers = "Next of Kin","Other Contact";
        }
        field(15; "Employee First Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Known As" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(16; "Employee Last Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Last Name" WHERE("No." = FIELD("Employee No.")));
            FieldClass = FlowField;
        }
        field(17; "Postal Address2"; Text[30])
        {
        }
        field(18; "Postal Address3"; Text[20])
        {
        }
        field(19; "Residential Address2"; Text[30])
        {
        }
        field(20; "Residential Address3"; Text[20])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", Relationship, "First Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        OK := Employee.Get("Employee No.");
        if OK then begin
            "Employee First Name" := Employee."Known As";
            "Employee Last Name" := Employee."Last Name";
        end;
    end;

    var
        Employee: Record Employee;
        OK: Boolean;
}