page 52211533 "Refreshment Request"
{
    ApplicationArea = All;
    Caption = 'Refreshment Request';
    PageType = Card;
    SourceTable = "Refreshment Requests";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Request Details';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Requested By Emp No."; Rec."Requested By Emp No.")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp. No. field.', Comment = '%';
                }
                field("Requested By Emp Name"; Rec."Requested By Emp Name")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp Name field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                    MultiLine = true;
                }
                field("Date Required"; Rec."Date Required")
                {
                    ToolTip = 'Specifies the value of the Date Required field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }
            part("Refreshment Details"; "Refreshment Details")
            {
                SubPageLink = "Request No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshmentVoucher)
            {
                Caption = 'Refreshment Voucher';
                Image = DepositSlip;

                trigger OnAction()
                var
                    RefreshmentRequest: Record "Refreshment Requests";
                begin
                    RefreshmentRequest.Reset;
                    RefreshmentRequest.SetRange("No.", Rec."No.");
                    if RefreshmentRequest.Find('-') then begin
                        REPORT.Run(Report::"Refreshment Voucher", true, true, RefreshmentRequest);
                    end;
                end;
            }
            action("Send Approval Request")
            {
                Image = Approve;

                trigger OnAction()
                begin
                    Rec.TestField("Date Required");
                    Rec.TestField(Purpose);
                    if Rec."No. of Refreshments" = 0 then
                        Error('There must be at least one refreshment defined on the lines!');

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
            group(Home)
            {
                actionref("RefreshmentVoucherPromoted"; RefreshmentVoucher) { }
            }
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
