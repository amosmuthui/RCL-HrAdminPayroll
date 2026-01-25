table 51525429 "Employment History"
{
    //LookupPageID = "Probation Appraisal Criteria S";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee."No.";
        }
        field(2; FromDate; Date)
        {
            NotBlank = true;
        }
        field(3; ToDate; Date)
        {
            NotBlank = true;
        }
        field(4; "Company Name"; Text[150])
        {
            NotBlank = true;
        }
        field(5; "Postal Address"; Text[80])
        {
        }
        field(6; "Address 2"; Text[80])
        {
        }
        field(7; "Job Title"; Text[250])
        {
        }
        field(8; "Key Experience"; Text[250])
        {
        }
        field(9; "Salary On Leaving"; Decimal)
        {
        }
        field(10; "Reason For Leaving"; Text[250])
        {
        }
        field(11; "Code"; Code[20])
        {
            TableRelation = "Former Positions";

            trigger OnValidate()
            begin
                EmploymentHistory.Reset;
                EmploymentHistory.SetRange(EmploymentHistory.Code, Code);
                if EmploymentHistory.Find('-') then
                    "Job Title" := EmploymentHistory.Description;
            end;
        }
        field(16; Comment; Text[250])
        {
            Editable = false;
        }
        field(17; Grade; Code[10])
        {
            TableRelation = "Salary Scales".Scale;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Company Name", "Job Title")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record Employee;
        OK: Boolean;
        EmploymentHistory: Record "Former Positions";
}