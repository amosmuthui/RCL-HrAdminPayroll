table 51525403 "Job Screening Questions"
{
    Caption = 'Advert Screening Questions';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Job Screening Questions";
    LookupPageId = "Job Screening Questions";

    fields
    {
        field(1; "Job No."; Code[100])
        {
            Caption = 'Job No.';
            Editable = false;
            TableRelation = "Recruitment Needs";
        }
        field(2; "Job Description"; Text[250])
        {
            Caption = 'Job Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Recruitment Needs".Description where("No." = field("Job No.")));
        }
        field(3; "Question Entry No."; Integer)
        {
            Caption = 'Question Entry No.';
            TableRelation = "Recruitment Screening Question";

            trigger OnValidate()
            var
                ScreeningQuestions: Record "Recruitment Screening Question";
                ScreeningAnswers: Record "Recruitment Screening Answers";
                JobScreeningAnswers: Record "Job Screening Answers";
                EntryNo: Integer;
            begin
                JobScreeningAnswers.Reset();
                JobScreeningAnswers.SetRange("Job No.", "Job No.");
                JobScreeningAnswers.SetRange("Question Entry No.", "Question Entry No.");
                if JobScreeningAnswers.Find('-') then
                    JobScreeningAnswers.DeleteAll();

                Description := '';
                "Numeric Answer" := 0;
                "Range Answer Start" := 0;
                "Range Answer End" := 0;
                "Text Answer" := '';
                Weight := 0;

                if "Question Entry No." <> 0 then begin
                    ScreeningQuestions.Reset();
                    ScreeningQuestions.SetRange("Entry No.", "Question Entry No.");
                    if ScreeningQuestions.FindFirst() then begin
                        Description := ScreeningQuestions.Description;
                        "Response Type" := ScreeningQuestions."Response Type";
                        "YesNo Answer" := ScreeningQuestions."YesNo Answer";
                        "Numeric Answer" := ScreeningQuestions."Numeric Answer";
                        "Numeric Answer Filter" := ScreeningQuestions."Numeric Answer Filter";
                        "Range Answer Start" := ScreeningQuestions."Range Answer Start";
                        "Range Answer End" := ScreeningQuestions."Range Answer End";
                        "Text Answer" := ScreeningQuestions."Text Answer";
                        Weight := ScreeningQuestions.Weight;

                        EntryNo := 0;
                        JobScreeningAnswers.Reset();
                        JobScreeningAnswers.SetCurrentKey("Entry No.");
                        JobScreeningAnswers.SetAscending("Entry No.", true);
                        if JobScreeningAnswers.FindLast() then
                            EntryNo := JobScreeningAnswers."Entry No.";

                        ScreeningAnswers.Reset();
                        ScreeningAnswers.SetRange("Question Entry No.", "Question Entry No.");
                        if ScreeningAnswers.FindSet() then
                            repeat
                                EntryNo += 1;
                                JobScreeningAnswers.Init();
                                JobScreeningAnswers."Entry No." := EntryNo;
                                JobScreeningAnswers."Question Entry No." := "Question Entry No.";
                                JobScreeningAnswers.Answer := ScreeningAnswers.Answer;
                                JobScreeningAnswers."Job No." := "Job No.";
                                JobScreeningAnswers."Is Correct" := ScreeningAnswers."Is Correct";
                                JobScreeningAnswers.Insert();
                            until ScreeningAnswers.Next() = 0;
                    end;
                end;
            end;
        }
        field(4; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(5; "Response Type"; Option)
        {
            Caption = 'Response Type';
            OptionMembers = Text,Numeric,Range,"Yes/No","Multiple Choice";
        }
        field(6; "YesNo Answer"; Option)
        {
            Caption = 'YesNo Answer';
            OptionMembers = Yes,No;
        }
        field(7; "Numeric Answer"; Integer)
        {
            Caption = 'Numeric Answer';
        }
        field(8; "Numeric Answer Filter"; Option)
        {
            Caption = 'Numeric Answer Filter';
            OptionCaption = 'Equal To,Less Than,Less Than or Equal To,Greater Than,Greater Than or Equal To,Not Equal To';
            OptionMembers = "==","<","<=",">",">=","<>";
        }
        field(9; "Range Answer Start"; Decimal)
        {
            Caption = 'Range Answer Start';
        }
        field(10; "Range Answer End"; Decimal)
        {
            Caption = 'Range Answer End';
        }
        field(11; "Text Answer"; Text[250])
        {
            Caption = 'Text Answer';
        }
        field(12; Weight; Decimal)
        {
            Caption = 'Weight';
        }
        field(13; "Display Order No."; Integer)
        { }
    }
    keys
    {
        key(PK; "Job No.", "Question Entry No.")
        {
            Clustered = true;
        }
    }
    procedure CountAnswers() ResultsCount: Integer
    var
        Answers: Record "Job Screening Answers";
    begin
        ResultsCount := 0;
        Answers.Reset();
        Answers.SetRange("Job No.", "Job No.");
        Answers.SetRange("Question Entry No.", "Question Entry No.");
        if Answers.Find('-') then
            ResultsCount := Answers.Count();
    end;
}