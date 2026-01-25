page 52211542 "Letter Template"
{
    ApplicationArea = All;
    Caption = 'Letter Template';
    PageType = Card;
    SourceTable = "Letter Templates";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Letter Template"; 'View Layout')
                {
                    Editable = false;
                    trigger OnDrillDown()
                    begin
                        Rec.OpenTemplateLayout();
                    end;
                }
            }
        }
    }
}
