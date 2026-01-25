table 51525418 "Job App Work Experience"
{
    fields
    {
        field(1; "Applicant No."; Code[20])
        {
            Caption = 'Applicant No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = false;
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = ToBeClassified;
        }
        field(4; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("From Date");
                if "To Date" < "From Date" then
                    Error('To Date Cannot Be Greater Than From Date.');
                "Experience Period" := "To Date" - "From Date";
                "Experience Period" := Round((("Experience Period" / 30) / 12), 0.1, '=');
            end;
        }
        field(5; "Position Description"; Text[250])
        {
            CalcFormula = Lookup("Former Positions".Description WHERE(Code = FIELD("Position Code")));
            Caption = 'Description';
            FieldClass = FlowField;
        }
        field(6; Responsibility; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Institution/Company"; Text[200])
        {
            Caption = 'Institution/Company';
            DataClassification = ToBeClassified;
        }
        field(8; "Position Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Former Positions";
        }
        field(9; "Experience No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(10; Salary; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Job App ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Applications";
        }
        field(13; "Experience Period"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Job Title"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job App ID", "Applicant No.", "Line No.", "Experience No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}