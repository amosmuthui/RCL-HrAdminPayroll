page 51525478 "Application Multichoice Answer"
{
    ApplicationArea = All;
    Caption = 'Application Multichoice Answer';
    PageType = List;
    SourceTable = "Application Multichoice Answer";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Application No. field.', Comment = '%';
                    Visible = false;
                }
                field("Question Entry No."; Rec."Question Entry No.")
                {
                    ToolTip = 'Specifies the value of the Question Entry No. field.', Comment = '%';
                    Visible = false;
                }
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
                field("Candidate Selected"; Rec."Candidate Selected")
                {
                    ToolTip = 'Specifies the value of the Candidate Selected field.', Comment = '%';
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Application No." = '' then
            Rec."Application No." := xRec."Application No."; // fallback from filtered view

        if Rec."Question Entry No." = 0 then
            Rec."Question Entry No." := xRec."Question Entry No.";
    end;
}