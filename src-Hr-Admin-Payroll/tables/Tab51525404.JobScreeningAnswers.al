table 51525404 "Job Screening Answers"
{
    Caption = 'Job Screening Answers';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Job Screening Answers";
    LookupPageId = "Job Screening Answers";

    fields
    {
        field(1; "Job No."; Code[50])
        {
            Caption = 'Job No.';
            Editable = false;
            TableRelation = "Recruitment Needs";
        }
        field(2; "Question Entry No."; Integer)
        {
            Caption = 'Question Entry No.';
            TableRelation = "Job Screening Questions";
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(4; Answer; Text[250])
        {
            Caption = 'Answer';
        }
        field(5; "Is Correct"; Boolean)
        {
            Caption = 'Is Correct';
        }
        field(6; "Question"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Job Screening Questions".Description where("Question Entry No." = field("Question Entry No.")));
        }
    }
    keys
    {
        key(PK; "Job No.", "Question Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}