page 51525477 "Job Screening Questions"
{
    ApplicationArea = All;
    Caption = 'Job Screening Questions';
    PageType = ListPart;
    SourceTable = "Job Screening Questions";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Question Entry No."; Rec."Question Entry No.")
                {
                    ToolTip = 'Specifies the value of the Question Entry No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Display Order No."; Rec."Display Order No.")
                { }
                field("Response Type"; Rec."Response Type")
                {
                    ToolTip = 'Specifies the value of the Response Type field.', Comment = '%';
                }
                field("YesNo Answer"; Rec."YesNo Answer")
                {
                    ToolTip = 'Specifies the value of the YesNo Answer field.', Comment = '%';
                }
                field("Numeric Answer Filter"; Rec."Numeric Answer Filter")
                {
                    ToolTip = 'Specifies the value of the Numeric Answer Filter field.', Comment = '%';
                }
                field("Numeric Answer"; Rec."Numeric Answer")
                {
                    ToolTip = 'Specifies the value of the Numeric Answer field.', Comment = '%';
                }
                field("Range Answer Start"; Rec."Range Answer Start")
                {
                    ToolTip = 'Specifies the value of the Range Answer Start field.', Comment = '%';
                }
                field("Range Answer End"; Rec."Range Answer End")
                {
                    ToolTip = 'Specifies the value of the Range Answer End field.', Comment = '%';
                }
                field("Text Answer"; Rec."Text Answer")
                {
                    ToolTip = 'Specifies the value of the Text Answer field.', Comment = '%';
                }
                field("Multiple Choice Answers"; Rec.CountAnswers())
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Answers: Record "Job Screening Answers";
                    begin
                        Answers.Reset();
                        Answers.SetRange("Job No.", Rec."Job No.");
                        Answers.SetRange("Question Entry No.", Rec."Question Entry No.");
                        Page.Run(Page::"Job Screening Answers", Answers);
                    end;
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field.', Comment = '%';
                }
            }
        }
    }
}