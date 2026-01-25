page 51525543 "Medical Claim Header"
{
    ApplicationArea = All;
    Editable = true;
    PageType = Card;
    SourceTable = "Medical Claim Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Claim No"; Rec."Claim No")
                {
                }
                field("Claim Date"; Rec."Claim Date")
                {
                    NotBlank = true;
                }
                field("Claimant No."; Rec."Claimant No.")
                {

                }
                field("Claimant Name"; Rec."Claimant Name")
                {

                }
                field("Service Provider"; Rec."Service Provider")
                {
                    NotBlank = true;
                }
                field("Service Provider Name"; Rec."Service Provider Name")
                {
                    NotBlank = true;
                }
                field(Amount; Rec.Amount)
                {
                    NotBlank = true;
                }
                field(Settled; Rec.Settled)
                {
                    Visible = false;
                }
                field("Cheque No"; Rec."Cheque No")
                {
                    Visible = false;
                }
                field(Claimant; Rec.Claimant)
                {
                    Visible = false;
                }
                field("Fiscal Year"; Rec."Fiscal Year")
                {
                    Editable = false;
                }
                field(Status; Rec."Approval Status")
                {
                }
                field("No. of Approvals"; Rec."No. of Approvals")
                {
                }
            }
            part(Control1000000010; "Claim Lines")
            {
                SubPageLink = "Claim No" = FIELD("Claim No");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            // 1️⃣ Your real actions (logic)
            action(MyAttachment)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;

                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);

                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
            action(MySendApproval)
            {
                Caption = 'Send Approval Request';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    VarVariant := Rec;
                    if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
                        Error('Document Status has to be open');
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);
                    Message('Approval request has been sent successfully.');

                end;
            }
            action(MyCancelApproval)
            {
                Caption = 'Cancel Approval Request';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec."Approval Status" <> Rec."Approval Status"::Released then begin
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                        Message('Approval request has been Canceled');
                    end;
                end;
            }
            action(MyApproval)
            {
                Caption = 'Approval';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
                end;
            }
            action(Reopen)
            {
                Caption = 'Reopen';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
                end;
            }


            action("Post Doc")
            {
                Caption = 'Post';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.posted := true;
                end;
            }
            action(PrintClaimReport)
            {
                ApplicationArea = All;
                Caption = 'Print Claim Report';
                Image = Print;

                trigger OnAction()
                var
                    RecRef: RecordRef;
                    MemoHeader: Record "Medical Claim Header";
                begin
                    RecRef.GetTable(Rec);
                    Report.RunModal(Report::"Claims Report", true, true, MemoHeader);
                end;
            }

        }
        area(Promoted)
        {
            // 2️⃣ Group that uses actionref
            group(AttachDocument)
            {
                Caption = 'Attach Document';

                actionref(Attachment; MyAttachment) { }

            }
            group(Approvall)
            {
                Caption = 'Approval';

                actionref(MySendApprovalRef; MySendApproval) { }
                actionref(MyCanceRef; MyCancelApproval) { }
                actionref(MyApprovalRef; MyApproval) { }
                actionref(ReopenRef; Reopen) { }

            }
            group(Post)
            {
                Caption = 'Post';

                actionref(MyPostRef; "Post Doc") { }

            }
            group(Report)
            {
                Caption = 'Report';

                actionref(MyReportRef; PrintClaimReport) { }

            }

        }


    }


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Claimant := Rec.Claimant::"Service Provider";
    end;

    var
        HRSetup: Record "Human Resources Setup";
        Link: Text[250];
        ApprovalMgt: Codeunit "Approvals Mgmt.";

        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
}