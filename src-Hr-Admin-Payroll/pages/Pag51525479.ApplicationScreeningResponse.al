page 51525479 "Application Screening Response"
{
    ApplicationArea = All;
    Caption = 'Application Screening Responses';
    PageType = ListPart;
    SourceTable = "Application Screening Response";
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting("Display Order No.") order(ascending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No."; Rec."Application No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Application No. field.', Comment = '%';
                }
                field("Applicant Email"; Rec."Applicant Email")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Applicant Email field.', Comment = '%';
                }
                field("Recruitment Need No."; Rec."Recruitment Need No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Recruitment Need No. field.', Comment = '%';
                }
                field("Question No."; Rec."Question No.")
                {
                    ToolTip = 'Specifies the value of the Question No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Response Type"; Rec."Response Type")
                {
                    ToolTip = 'Specifies the value of the Response Type field.', Comment = '%';
                }
                field("Numeric Answer Filters"; Rec."Numeric Answer Filters")
                {
                    ToolTip = 'Specifies the value of the Numeric Answer Filters field.', Comment = '%';
                }
                field("Expected Answer"; Rec."Expected Answer")
                {
                    ToolTip = 'Specifies the value of the Expected Answer field.', Comment = '%';
                }
                field("Provided Answer"; Rec."Provided Answer")
                {
                    ToolTip = 'Specifies the value of the Provided Answer field.', Comment = '%';
                }
                field("Multiple Choice Answers"; Rec.CountAnswers())
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Answers: Record "Application Multichoice Answer";
                    begin
                        Answers.Reset();
                        Answers.SetRange("Application No.", Rec."Application No.");
                        Answers.SetRange("Question Entry No.", Rec."Question No.");
                        Page.Run(Page::"Application Multichoice Answer", Answers);
                    end;
                }
                field(Score; Rec.Score)
                {
                    ToolTip = 'Specifies the value of the Score field.', Comment = '%';
                }
            }
        }
    }
}