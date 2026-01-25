table 51525401 "Application Screening Response"
{
    Caption = 'Application Screening Response';
    DataClassification = ToBeClassified;
    LookupPageId = "Application Screening Response";
    DrillDownPageId = "Application Screening Response";

    fields
    {
        field(1; "Application No."; Code[50])
        {
            Caption = 'Application No.';
            Editable = false;
        }
        field(2; "Applicant Email"; Text[250])
        {
            Caption = 'Applicant Email';
            Editable = false;
        }
        field(3; "Recruitment Need No."; Code[50])
        {
            Caption = 'Recruitment Need No.';
            Editable = false;
            TableRelation = "Recruitment Needs";
        }
        field(4; "Question No."; Integer)
        {
            Caption = 'Question No.';
            Editable = false;
            TableRelation = "Job Screening Questions";
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(6; "Response Type"; Option)
        {
            Caption = 'Response Type';
            OptionMembers = Text,Numeric,Range,"Yes/No","Multiple Choice";
            Editable = false;
        }
        field(7; "Numeric Answer Filters"; Option)
        {
            Caption = 'Numeric Answer Filters';
            OptionCaption = 'Equal To,Less Than,Less Than or Equal To,Greater Than,Greater Than or Equal To,Not Equal To';
            OptionMembers = "==","<","<=",">",">=","<>";
            Editable = false;
        }
        field(8; "Expected Answer"; Text[250])
        {
            Caption = 'Expected Answer';
            Editable = false;
        }
        field(9; "Provided Answer"; Text[250])
        {
            Caption = 'Provided Answer';
        }
        field(10; Weight; Decimal)
        {
            Caption = 'Weight';
            Editable = false;
        }
        field(11; "Display Order No."; Integer)
        { }
        field(12; Score; Decimal)
        {
            Caption = 'Score';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Application No.", "Question No.")
        {
            Clustered = true;
        }

        key(Key1; "Display Order No.")
        { }
    }
    procedure CountAnswers() ResultsCount: Integer
    var
        Answers: Record "Application Multichoice Answer";
    begin
        ResultsCount := 0;
        Answers.Reset();
        Answers.SetRange("Application No.", "Application No.");
        Answers.SetRange("Question Entry No.", "Question No.");
        if Answers.Find('-') then
            ResultsCount := Answers.Count();
    end;
}