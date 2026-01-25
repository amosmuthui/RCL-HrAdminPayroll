table 51525421 "Employee Beneficiaries Changes"
{
    Caption = 'Employee Beneficiaries Changes';

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
        field(14; "Employee Change Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Change Request"."No.";
        }
    }

    keys
    {
        key(Key1; "Employee Change Code", Relationship, SurName, "Other Names")
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
        EmpChanges: Record "Change Request";
    begin
        EmpChanges.CheckDelete("Employee Change Code");
    end;

    var
    //MedicalHeader: Record "Medical Scheme Header";
}