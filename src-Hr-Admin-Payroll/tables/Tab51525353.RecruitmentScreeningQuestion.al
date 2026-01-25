table 51525353 "Recruitment Screening Question"
{
    Caption = 'Screening Questions';
    DataClassification = ToBeClassified;
    LookupPageId = "Recruitment Screening Question";
    DrillDownPageId = "Recruitment Screening Question";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(3; "Response Type"; Option)
        {
            Caption = 'Response Type';
            OptionMembers = Text,Numeric,Range,"Yes/No","Multiple Choice";
        }
        field(4; "YesNo Answer"; Option)
        {
            Caption = 'YesNo Answer';
            OptionMembers = Yes,No;
        }
        field(5; "Numeric Answer"; Integer)
        {
            Caption = 'Numeric Answer';
        }
        field(6; "Numeric Answer Filter"; Option)
        {
            Caption = 'Numeric Answer Filter';
            OptionCaption = 'Equal To,Less Than,Less Than or Equal To,Greater Than,Greater Than or Equal To,Not Equal To';
            OptionMembers = "==","<","<=",">",">=","<>";
        }
        field(7; "Range Answer Start"; Decimal)
        {
            Caption = 'Range Answer Start';
        }
        field(8; "Range Answer End"; Decimal)
        {
            Caption = 'Range Answer End';
        }
        field(9; "Text Answer"; Text[250])
        {
            Caption = 'Text Answer';
        }
        field(10; Weight; Decimal)
        {
            Caption = 'Weight';
        }
        field(11; "Applicable Positions"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Applicable Positions" where("Question No." = field("Entry No.")));
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure CountAnswers() ResultsCount: Integer
    var
        Answers: Record "Recruitment Screening Answers";
    begin
        ResultsCount := 0;
        Answers.Reset();
        Answers.SetRange("Question Entry No.", "Entry No.");
        if Answers.Find('-') then
            ResultsCount := Answers.Count();
    end;
}