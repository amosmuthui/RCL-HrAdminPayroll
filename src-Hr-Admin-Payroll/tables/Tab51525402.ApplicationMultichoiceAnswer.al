table 51525402 "Application Multichoice Answer"
{
    Caption = 'Application Multichoice Answer';
    DataClassification = ToBeClassified;
    LookupPageId = "Application Multichoice Answer";
    DrillDownPageId = "Application Multichoice Answer";

    fields
    {
        field(1; "Application No."; Code[50])
        {
            Caption = 'Application No.';
            Editable = false;
        }
        field(2; "Question Entry No."; Integer)
        {
            Caption = 'Question Entry No.';
            Editable = false;
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(4; Question; Text[250])
        {
            Caption = 'Question';
            FieldClass = FlowField;
            CalcFormula = lookup("Job Screening Questions".Description where("Question Entry No." = field("Question Entry No.")));
        }
        field(5; Answer; Text[250])
        {
            Caption = 'Answer';
            Editable = false;
        }
        field(6; "Is Correct"; Boolean)
        {
            Caption = 'Is Correct';
            Editable = false;
        }
        field(7; "Candidate Selected"; Boolean)
        {
            Caption = 'Candidate Selected';
        }
    }
    keys
    {
        key(PK; "Application No.", "Question Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}