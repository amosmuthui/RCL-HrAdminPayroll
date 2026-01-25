table 51525406 "Applicant Work Experience"
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
            AutoIncrement = true;
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
        }
        field(5; "Position Description"; Text[200])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
        }
        field(10; "Gross Salary"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Applicant Email Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Local File URL"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Attached; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; Address; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Address 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Skills Earned"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Employee ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Recruitment Need Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code WHERE(Type = FILTER("Professional Body"));

            trigger OnValidate()
            begin
                Needs.Reset;
                Needs.SetRange(Needs."No.", "Recruitment Need Code");
                if Needs.Find('-') then begin
                    "Position Description" := Needs.Description;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Applicant No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Needs: Record "Recruitment Needs";
}