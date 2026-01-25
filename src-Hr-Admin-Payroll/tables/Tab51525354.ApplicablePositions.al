table 51525354 "Applicable Positions"
{
    Caption = 'Applicable Positions';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Applicable Positions";
    LookupPageId = "Applicable Positions";

    fields
    {
        field(1; "Question No."; Integer)
        {
            Caption = 'Question No.';
            TableRelation = "Recruitment Screening Question";
            Editable = true;
        }
        field(2; "Position No."; Code[50])
        {
            Caption = 'Position No.';
            TableRelation = "Company Jobs";
        }
        field(3; Title; Text[250])
        {
            Caption = 'Title';
            FieldClass = FlowField;
            CalcFormula = lookup("Company Jobs"."Job Description" where("Job ID" = field("Position No.")));
        }
        field(4; "Question"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Recruitment Screening Question".Description where("Entry No." = field("Question No.")));
        }
    }
    keys
    {
        key(PK; "Question No.", "Position No.")
        {
            Clustered = true;
        }
    }
}