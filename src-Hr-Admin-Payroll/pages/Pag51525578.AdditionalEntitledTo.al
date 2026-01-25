page 51525578 "Additional Entitled To"
{
    ApplicationArea = All;
    Caption = 'Additional Entitled To';
    PageType = ListPart;
    SourceTable = "Additional Entitled To";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Action"; Rec."Action")
                {
                    ToolTip = 'Specifies the value of the Action field.', Comment = '%';
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    ToolTip = 'Specifies the value of the No. of Days field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Divide By"; Rec."Divide By")
                { }
            }
        }
    }
}