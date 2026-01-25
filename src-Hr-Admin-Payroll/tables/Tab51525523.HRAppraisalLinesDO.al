table 51525523 "HR Appraisal Lines - DO"
{
    DrillDownPageID = "HR Appraisal Lines - DO";
    LookupPageID = "HR Appraisal Lines - DO";

    fields
    {
        field(1; "Appraisal No."; Code[10])
        {
            Editable = false;
            TableRelation = "HR Appraisal Header"."No.";
        }
        field(2; "Objective Code"; Code[20])
        {
            TableRelation = "HR Appraisal Dept. Obj. Setup"."Objective Code" WHERE("Department Code" = FIELD("Department Code"));
        }
        field(3; "Objective Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin
            end;
        }
        field(5; "Perspective Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Pespectives".Code WHERE("Department Code" = FIELD("Department Code"));
        }
        field(6; "Perspective Description"; Text[240])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Perspective Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Stewardship,Customer,"Internal Process","Learning & Growth";
        }
        field(8; "CWP Line"; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Activity; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Performance Measure/Indicator"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Staff No"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Period; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Directorate Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Success Measure"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Output,Outcome';
            OptionMembers = " ",Output,Outcome;
        }
    }

    keys
    {
        key(Key1; "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Objective Code", "Objective Description", "Department Code", "Perspective Code", "Perspective Description")
        {
        }
    }
}