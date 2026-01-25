page 51525576 "Peer Problem Solving"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Peer Appraisal Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    Visible = ShowPeerFields;
                }
                field("Peer Level"; Rec."Peer Level")
                {
                    Visible = ShowPeerFields;
                }
                field(Appraiser; Rec.Appraiser)
                {
                    Visible = ShowPeerFields;
                }
                field(Remarks; Rec.Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Appraiser := AppraisorNo;
        Rec."Doc No" := HeaderNumber;
        Rec.Type := Rec.Type::"Problem Solving";
    end;

    trigger OnOpenPage()
    begin
        ShowPeerFields := true;
        if not CurrUserIsSupervisor then begin
            Rec.SetRange(Appraiser, AppraisorNo);
            ShowPeerFields := false;
        end;
    end;

    var
        AppraisorNo: Code[30];
        HeaderNumber: Code[30];
        CurrUserIsSupervisor: Boolean;
        ShowPeerFields: Boolean;

    procedure SetFilters(HeaderNo: Code[30]; AppraiserNum: Code[30]; IsSupervisor: Boolean)
    begin
        HeaderNumber := HeaderNo;
        AppraisorNo := AppraiserNum;
        CurrUserIsSupervisor := IsSupervisor;
    end;
}