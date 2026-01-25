table 51525431 "Appointment Checklist"
{
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                OK := Employee.Get("Employee No.");
                if OK then begin
                    "Employee First Name" := Employee."Known As";
                    "Employee Last Name" := Employee."Last Name";
                end;
            end;
        }
        field(3; Item; Text[100])
        {
        }
        field(4; Date; Date)
        {
        }
        field(5; Signed; Boolean)
        {
        }
        field(6; "Employee First Name"; Text[30])
        {
        }
        field(7; "Employee Last Name"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", Item)
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