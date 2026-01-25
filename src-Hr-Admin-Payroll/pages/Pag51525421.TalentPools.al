page 51525421 "Talent Pools"
{
    ApplicationArea = All;
    Caption = 'Talent Pools';
    PageType = List;
    SourceTable = "Talent Pools";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("No. of Candidates"; Rec."No. of Candidates")
                {
                    ToolTip = 'Specifies the value of the No. of Candidates field.', Comment = '%';
                }
                field("No. of Applications"; Rec."No. of Applications")
                {
                    ToolTip = 'Specifies the value of the No. of Applications field.', Comment = '%';
                }
            }
        }
    }
}