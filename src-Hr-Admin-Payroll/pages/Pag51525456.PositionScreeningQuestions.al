page 51525456 "Position Screening Questions"
{
    ApplicationArea = All;
    Caption = 'Screening Questions';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Applicable Positions";

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Question No."; Rec."Question No.")
                {
                    ToolTip = 'Specifies the value of the Question No. field.', Comment = '%';
                }
                field(Question; Rec.Question)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies the value of the Question field.', Comment = '%';
                }
            }
        }
    }
}