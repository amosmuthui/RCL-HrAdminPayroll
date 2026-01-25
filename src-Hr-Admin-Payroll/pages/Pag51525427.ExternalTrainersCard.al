page 51525427 "External Trainers Card"
{
    ApplicationArea = All;
    Caption = 'External Trainers Card';
    PageType = Card;
    SourceTable = "External Trainers";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = EnableEditing;

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Signature; Rec.Signature)
                {
                    ToolTip = 'Specifies the value of the Signature field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        TrainingMasterRec: Record "Training Master Plan Header";
    begin
        //CurrPage.Editable(true);
        EnableEditing := true;
        if TrainingMasterRec.IsAReadOnlyUser() then
            EnableEditing := false;//CurrPage.Editable(false);
    end;

    var
        EnableEditing: Boolean;
}