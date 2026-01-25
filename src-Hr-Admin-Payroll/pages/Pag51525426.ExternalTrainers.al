page 51525426 "External Trainers"
{
    ApplicationArea = All;
    CardPageId = "External Trainers Card";
    Caption = 'External Trainers';
    PageType = List;
    SourceTable = "External Trainers";
    UsageCategory = Lists;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Signature; Rec.Signature)
                { }
            }
        }
    }
}