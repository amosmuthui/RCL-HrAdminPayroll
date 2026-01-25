page 52211561 "Claim List"
{
    ApplicationArea = All;
    Caption = 'Claim List';
    PageType = List;
    SourceTable = "Medical Claim Header";
    CardPageId = "Medical Claim Header";
    SourceTableView = where(Posted = const(false));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Claim No"; Rec."Claim No")
                {
                    ToolTip = 'Specifies the value of the Claim No field.', Comment = '%';
                }
                field("Claim Date"; Rec."Claim Date")
                {
                    ToolTip = 'Specifies the value of the Claim Date field.', Comment = '%';
                }
                field(Claimant; Rec.Claimant)
                {
                    ToolTip = 'Specifies the value of the Claimant field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    ToolTip = 'Specifies the value of the Cheque No field.', Comment = '%';
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    ToolTip = 'Specifies the value of the Fiscal Year field.', Comment = '%';
                }
                field(Status; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
