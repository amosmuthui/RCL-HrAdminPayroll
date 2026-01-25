page 52211546 "Requisition Fees Request card"
{
    ApplicationArea = All;
    Caption = 'Requisition Fees Request card';
    PageType = Card;
    SourceTable = "Requisition Fees Requests";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.', Comment = '%';
                }
                field("Emp Name"; Rec."Emp Name")
                {
                    ToolTip = 'Specifies the value of the Emp Name field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("PV No."; Rec."PV No.")
                {
                    ToolTip = 'Specifies the value of the PV No. field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                Image = Approve;

                trigger OnAction()
                begin
                    Rec.TestField(Amount);
                    Rec.TestField("Emp No.");
                    Rec.TestField(Purpose);

                    VarVariant := Rec;

                    if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
                        Error('Document Status has to be open');
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;

                trigger OnAction()
                begin
                    if Rec."Approval Status" <> Rec."Approval Status"::Released then begin
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                    // ApprovalsMgmt.OnCancelPVApprovalRequest(Rec);
                end;
            }
            action("Approval Entries")
            {
                Image = Approvals;
                RunPageMode = View;

                trigger OnAction()
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
                end;
            }
        }


        area(Promoted)
        {
            /*group(Home)
            {
            }*/
            group(Approval)
            {
                actionref("Send Approval Request Promoted"; "Send Approval Request") { }
                actionref("Cancel Approval Request Promoted"; "Cancel Approval Request") { }
                actionref("Approval Entries Promoted"; "Approval Entries") { }
            }
        }
    }
    var
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";

    trigger OnOpenPage()
    begin
        if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
            CurrPage.Editable(false);
    end;

}
