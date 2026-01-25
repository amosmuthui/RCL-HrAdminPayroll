table 51525443 "Appraisal Development Needs"
{
    fields
    {
        field(1; "Need No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal No"; Code[20])
        {
        }
        field(3; "Appraisal Period"; Code[20])
        {
        }
        field(4; "Employee No."; Code[20])
        {
        }
        field(5; "Development Need"; Text[200])
        {
        }
        field(6; "Development Action"; Text[200])
        {
        }
        field(7; Resposibility; Code[20])
        {
        }
        field(8; "By When"; Date)
        {
        }
        field(9; Comments; Text[250])
        {
        }
        field(10; Select; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Need No.", "Appraisal No", "Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Employee No.", "Development Need", "Development Action", Select)
        {
        }
    }
}