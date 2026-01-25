page 52211534 "Refreshment Details"
{
    ApplicationArea = All;
    Caption = 'Refreshment Details';
    PageType = ListPart;
    SourceTable = "Refreshment Details";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Type Code"; Rec."Type Code")
                {
                    ToolTip = 'Specifies the value of the Type Code field.', Comment = '%';
                }
                field("Type Description"; Rec."Type Description")
                {
                    ToolTip = 'Specifies the value of the Type Description field.', Comment = '%';
                }
                field("Additional Info"; Rec."Additional Info")
                {
                    ToolTip = 'Specifies the value of the Additional Info field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
            }
        }
    }
}
