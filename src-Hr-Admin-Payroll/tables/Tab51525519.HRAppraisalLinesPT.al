table 51525519 "HR Appraisal Lines - PT"
{
    Caption = 'HR Appraisal Lines - Performance Targets';
    DrillDownPageID = "HR Appraisal Lines - PT";
    LookupPageID = "HR Appraisal Lines - PT";

    fields
    {
        field(1; "Appraisal No."; Code[10])
        {
            Editable = false;
            TableRelation = "HR Appraisal Header"."No.";
        }
        field(2; "Agreed Performance Targets"; Text[250])
        {
            Description = 'to be completed by the appraisee as agreed with the supervisor at the beginning of the appraisal period)';
        }
        field(3; "Appraisee Comments"; Text[100])
        {

            trigger OnValidate()
            begin

                Validate("Key Performance Indicator");
            end;
        }
        field(4; "Key Performance Indicator"; Text[200])
        {
            Description = 'To be completed by the Appraisee in consultation with the supervisor at the beginning at the beginning of the appraisal period';
        }
        field(6; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(7; "Supervisor Comments"; Text[100])
        {

            trigger OnValidate()
            begin

                Validate("Key Performance Indicator");
            end;
        }
        field(8; "Key Result Areas (Output)"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Self Assesment"; Decimal)
        {
            BlankZero = true;
            Caption = 'Self-Assessment (Results Achieved)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                fnCheckParameters("Self Assesment");
                Clear("Self-Score");
                if "Self Assesment" <> 0 then begin
                    "Self-Score" := fn_AppraisalRatingScale("Self Assesment");
                end;
            end;
        }
        field(10; "Self-Score"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use Rating Scale';
            Editable = false;
        }
        field(11; "Supervisor-Assesment"; Decimal)
        {
            BlankZero = true;
            Caption = 'Supervisor''s Assessment (Results Achieved)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                fnCheckParameters("Supervisor-Assesment");
                Clear("Supervisors Score");
                if "Supervisor-Assesment" <> 0 then begin
                    "Supervisors Score" := fn_AppraisalRatingScale("Supervisor-Assesment");
                end;
                TestField("Appraisee Comments");
            end;
        }
        field(12; "Supervisors Score"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use Rating Scale';
            Editable = false;
        }
        field(13; "Agreed-Assesment Results"; Decimal)
        {
            BlankZero = true;
            Caption = 'Agreed Assessment (Results Achieved)';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //fnCheckParameters("Agreed-Assesment Results");
                Clear("Agreed Score");
                if "Agreed-Assesment Results" <> 0 then begin
                    "Agreed Score" := fn_AppraisalRatingScale("Agreed-Assesment Results");
                end;
            end;
        }
        field(14; "Agreed Score"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use Rating Scale';
        }
        field(15; "Comments After Review"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "End Year Assessment"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                fnCheckParameters("End Year Assessment");
            end;
        }
        field(21; "End Year Score"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "End Year Evaluation Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(23; Perspective; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code;
        }
        field(24; "Project Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(25; Objective; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(26; Outcome; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Staff No"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(28; Activity; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Appraisal Period"; Code[200])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Exclude Target"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Exclusion Comment"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Target Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Weight Total"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "End Year Self Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "End Year Supervisor Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "EndYear Self Comments"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "EndYear Supervisor Comments"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('Targets cant be deleted.Kindly use the exclude target function.');
    end;

    local procedure fn_AppraisalRatingScale(PARAM_Score: Decimal): Text
    var
    //HRAppraisalRatingScale: Record "HR Appraisal Rating Scale";
    begin


        if (PARAM_Score > 4) then
            exit('Excellent')
        else
            if (PARAM_Score > 3) and (PARAM_Score < 5) then
                exit('Very Good')
            else
                if (PARAM_Score > 2) and (PARAM_Score < 4) then
                    exit('Good')
                else
                    if (PARAM_Score > 1) and (PARAM_Score < 3) then
                        exit('Average')
                    else
                        if (PARAM_Score = 1) then exit('Poor');
    end;

    local procedure fnCheckParameters(Score: Integer)
    var
        PerformanceSetup: Record "Perfomance Management Setup";
        Text1: Label 'The rating is below the minimum accepted value of %1.';
        Text2: Label 'The rating is beyond the maximum accepted value of %1.';
    begin
        PerformanceSetup.Get();
        if Score < PerformanceSetup."Minimum Value Core Performance" then
            Error(Text1, PerformanceSetup."Minimum Value Core Performance");
        if Score > PerformanceSetup."Maximun value Core Performance" then
            Error(Text2, PerformanceSetup."Maximun value Core Performance");
    end;
}