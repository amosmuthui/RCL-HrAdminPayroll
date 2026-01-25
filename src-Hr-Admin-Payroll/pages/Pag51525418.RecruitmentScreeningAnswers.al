page 51525418 "Recruitment Screening Answers"
{
    ApplicationArea = All;
    Caption = 'Screening Answers';
    PageType = List;
    SourceTable = "Recruitment Screening Answers";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Question Entry No."; Rec."Question Entry No.")
                {
                    ToolTip = 'Specifies the value of the Question No. field.', Comment = '%';
                    Editable = false;
                }
                field(Answer; Rec.Answer)
                {
                    ToolTip = 'Specifies the value of the Answer field.', Comment = '%';
                }
                field("Is Correct"; Rec."Is Correct")
                {
                    ToolTip = 'Specifies the value of the Is Correct field.', Comment = '%';
                }

                field(Question; Rec.Question)
                {
                    ToolTip = 'Specifies the value of the Question field.', Comment = '%';
                }
            }
        }
    }
}