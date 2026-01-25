page 51525476 "Job Screening Answers"
{
    ApplicationArea = All;
    Caption = 'Job Screening Answers';
    PageType = List;
    SourceTable = "Job Screening Answers";
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
                field(Question; Rec.Question)
                {
                    ToolTip = 'Specifies the value of the Question field.', Comment = '%';
                }
                field(Answer; Rec.Answer)
                {
                    ToolTip = 'Specifies the value of the Answer field.', Comment = '%';
                }
                field("Is Correct"; Rec."Is Correct")
                {
                    ToolTip = 'Specifies the value of the Is Correct field.', Comment = '%';
                }
            }
        }
    }
}