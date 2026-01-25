page 52211554 "Shift Card"
{
    PageType = Card;
    SourceTable = "Shift Header";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Shift';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    // Editable = false;
                }
                field("Shift Date"; Rec."Shift Start Date")
                {
                    ApplicationArea = All;
                }
                field("Shift End Date"; Rec."Shift End Date")
                {

                }
                field("Shift Type"; Rec."Shift Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shift Department"; Rec."Shift Department")
                {

                }
                field("Created by"; Rec."Created by")
                {

                }
                field(Department; Rec.Department)
                {
                    Visible = false;
                }
                field(Status; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }

            part(ShiftLines; "Shift Lines Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Shift No." = field("No.");
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

                Image = Approvals;
                RunPageMode = View;

                trigger OnAction()
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
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
            action(PrintShiftReport)
            {
                ApplicationArea = All;
                Caption = 'Print Shift Report';
                Image = Print;

                trigger OnAction()
                var
                    RecRef: RecordRef;
                    MemoHeader: Record "Shift Header";
                begin
                    RecRef.GetTable(Rec);
                    Report.RunModal(Report::"Shift Report", true, true, MemoHeader);
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
                actionref(MyApprovalRef; MyCancelApproval) { }
                actionref(MyApprovalsRef; MyApproval) { }
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

                actionref(MyReportRef; PrintShiftReport) { }

            }

        }


    }

    var
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
}

