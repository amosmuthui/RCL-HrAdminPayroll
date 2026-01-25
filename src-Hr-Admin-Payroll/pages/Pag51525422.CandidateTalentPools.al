page 51525422 "Candidate Talent Pools"
{
    ApplicationArea = All;
    Caption = 'Candidate Talent Pools';
    PageType = List;
    SourceTable = "Candidate Talent Pools";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Pool Code"; Rec."Pool Code")
                {
                    ToolTip = 'Specifies the value of the Pool Code field.', Comment = '%';
                }
                field("Pool Description"; Rec."Pool Description")
                {
                    ToolTip = 'Specifies the value of the Pool Description field.', Comment = '%';
                }
                field("Candidate Email"; Rec."Candidate Email")
                {
                    ToolTip = 'Specifies the value of the Candidate Email field.', Comment = '%';
                }
                field("Candidate Name"; Rec."Candidate Name")
                {
                    ToolTip = 'Specifies the value of the Candidate Name field.', Comment = '%';
                }
                field("Application No."; Rec."Application No.")
                {
                    ToolTip = 'Specifies the value of the Application No. field.', Comment = '%';
                }
            }
        }
    }
}