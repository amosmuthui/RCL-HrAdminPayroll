page 51525416 "Recruitment Screening Question"
{
    ApplicationArea = All;
    Caption = 'Screening Questions';
    PageType = List;
    SourceTable = "Recruitment Screening Question";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
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
                        Answers: Record "Recruitment Screening Answers";
                    begin
                        Answers.Reset();
                        Answers.SetRange("Question Entry No.", Rec."Entry No.");
                        Page.Run(Page::"Recruitment Screening Answers", Answers);
                    end;
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field.', Comment = '%';
                }
                field("Applicable Positions"; Rec."Applicable Positions")
                { }
            }
        }
    }
}