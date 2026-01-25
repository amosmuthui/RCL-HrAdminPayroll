table 51525520 "HR Appraisal Lines - Values"
{
    Caption = 'HR Appraisal Lines - Values and Competences ';
    DrillDownPageID = "HR Appraisal Lines - VC";
    LookupPageID = "HR Appraisal Lines - VC";

    fields
    {
        field(1; "Appraisal No."; Code[10])
        {
            Editable = false;
            TableRelation = "HR Appraisal Header"."No.";
        }
        field(2; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Staff Values & Core Competence","Managerial and Supervisory Competence";
        }
        field(3; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Values and Compt.".Code;

            trigger OnValidate()
            begin
                Clear(Description);

                HRAppraisalValuesandCompt.Reset();
                HRAppraisalValuesandCompt.SetRange(Code, Code);
                if HRAppraisalValuesandCompt.FindFirst() then begin
                    Description := HRAppraisalValuesandCompt.Description;
                    Category := HRAppraisalValuesandCompt.Category
                end;
            end;
        }
        field(4; Description; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Appraisal Assesment"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Score; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Clear("Score Descriptors");
                fnCheckParameters(Score);
            end;
        }
        field(7; "Score Descriptors"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Appraisal Period"; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Target Score"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                fnCheckParameters("Target Score");
            end;
        }
        field(10; "Agreed Score"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                fnCheckParameters("Agreed Score");
            end;
        }
        field(11; "Supervisor Score"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                fnCheckParameters("Supervisor Score");
            end;
        }
        field(12; "Performance Outcome"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Activity; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Perspective; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "CWP Line"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Department; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Appraisee Comments"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Include Target"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Appraisal No.", Activity, Description)
        {
            Clustered = true;
        }
        /*key(Key2;'')
        {
            Enabled = false;
        }*/
    }

    fieldgroups
    {
    }

    var
        HRAppraisalValuesandCompt: Record "HR Appraisal Values and Compt.";
        HRAppraisalRatingScale: Record "HR Appraisal Rating Scale";

    local procedure fnCheckParameters(Score: Integer)
    var
        PerformanceSetup: Record "Perfomance Management Setup";
        Text1: Label 'The rating is below the minimum accepted value of %1.';
        Text2: Label 'The rating is beyond the maximum accepted value of %1.';
    begin
        PerformanceSetup.Get();
        if Score < PerformanceSetup."Values Minimum Score" then
            Error(Text1, PerformanceSetup."Values Minimum Score");
        if Score > PerformanceSetup."Values Maximum Score" then
            Error(Text2, PerformanceSetup."Values Maximum Score");
    end;
}