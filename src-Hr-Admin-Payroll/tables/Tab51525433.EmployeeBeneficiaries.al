table 51525433 "Employee Beneficiaries"
{
    Caption = 'Employee Relative';

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee."No.";
        }
        field(2; Relationship; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Relative";
        }
        field(3; SurName; Text[50])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                MedicalHeader.Reset;
                MedicalHeader.SetRange(MedicalHeader."Employee No", "Employee Code");
                if MedicalHeader.Find('+') then
                    MedicalHeader."Employee No" := "Employee Code";
                MedicalHeader.Validate(MedicalHeader."Employee No");
            end;
        }
        field(4; "Other Names"; Text[100])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                Validate(SurName);
            end;
        }
        field(5; "ID No/Passport No"; Text[50])
        {
        }
        field(6; "Date Of Birth"; Date)
        {

            trigger OnValidate()
            begin
                Validate(SurName);
            end;
        }
        field(7; Occupation; Text[100])
        {
        }
        field(8; Address; Text[250])
        {
        }
        field(9; "Office Tel No"; Text[100])
        {
        }
        field(10; "Home Tel No"; Text[50])
        {
        }
        field(11; Remarks; Text[250])
        {
        }
        field(12; "Distribution %"; Decimal)
        {
        }
        field(13; Gender; Option)
        {
            OptionMembers = " "," MALE"," FEMALE";
        }
    }

    keys
    {
        key(Key1; "Employee Code", Relationship, SurName, "Other Names")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        HRCommentLine: Record "Human Resource Comment Line";
    begin
        HRCommentLine.SetRange("Table Name", HRCommentLine."Table Name"::"Employee Relative");
        HRCommentLine.SetRange("No.", "Employee Code");
        HRCommentLine.DeleteAll;
    end;

    var
        MedicalHeader: Record "Medical Scheme Header";
}