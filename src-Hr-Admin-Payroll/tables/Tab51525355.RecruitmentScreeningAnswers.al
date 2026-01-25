table 51525355 "Recruitment Screening Answers"
{
    Caption = 'Recruitment Screening Answers';
    DataClassification = ToBeClassified;
    LookupPageId = "Recruitment Screening Answers";
    DrillDownPageId = "Recruitment Screening Answers";

    fields
    {
        field(1; "Question Entry No."; Integer)
        {
            Caption = 'Question No.';
            TableRelation = "Recruitment Screening Question";
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(3; Answer; Text[250])
        {
            Caption = 'Answer';
        }
        field(4; "Is Correct"; Boolean)
        {
            Caption = 'Is Correct';
        }
        field(5; "Question"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Recruitment Screening Question".Description where("Entry No." = field("Question Entry No.")));
        }
    }
    keys
    {
        key(PK; "Question Entry No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}