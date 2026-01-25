page 52211552 "Memo Card"
{
    PageType = Card;
    SourceTable = "Memo Header";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    // Editable = false;
                }
                field("Requestor User ID"; Rec."Requestor User ID")
                {
                    Caption = 'Requestor';
                }
                field("Requestor Name"; Rec."Requestor Name")
                {

                }
                field("Created Date"; Rec."Created Date")
                {
                    Editable = false;
                    Caption = 'Document Date';
                }
                field("Department Code"; Rec."Department Code")
                {

                }
                field("Purpose"; Rec.Purpose)
                {

                }
                field("Activity Date"; Rec."Activity Date")
                {

                }
                field("End Date"; Rec."End Date")
                {

                }

                field(Status; Rec."Approval Status")
                {
                    Editable = false;
                }
            }

            part("Memo Lines"; "Memo Lines")
            {
                Caption = 'Memo Lines';
                SubPageLink = "Doc No" = field("No.");
            }
            part("Memo attendees"; "Memo Attenders")
            {
                Caption = 'Attendees';
                SubPageLink = "Doc No" = field("No.");
                // Visible = false;
            }
            part(DocAttach; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                SubPageLink =
                    "Table ID" = const(Database::"Memo Header"),
                    "No." = field("No.");
                Visible = false;
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
            action(MyAttachment2)
            {
                ApplicationArea = All;
                Caption = 'View Attachments';
                Image = Attach;
                Visible = false;

                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                    DocAttachRec: Record "Document Attachment";
                begin
                    DocAttachRec.SetRange("Table ID", DATABASE::"Memo Header");
                    DocAttachRec.SetRange("No.", Rec."No.");

                    DocumentAttachmentDetails.SetTableView(DocAttachRec);
                    DocumentAttachmentDetails.RunModal();
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
            action(PrintMemoReport)
            {
                ApplicationArea = All;
                Caption = 'Print Memo Report';
                Image = Print;

                trigger OnAction()
                var
                    RecRef: RecordRef;
                    MemoHeader: Record "Memo Header";
                begin
                    RecRef.GetTable(Rec);
                    Report.RunModal(Report::"Memo Report", true, true, MemoHeader);
                end;
            }


        }
        area(Promoted)
        {
            // 2️⃣ Group that uses actionref
            group(AttachDocument)
            {
                Caption = 'Attachments';

                actionref(Attachment; MyAttachment) { }
                actionref(Attachment2; MyAttachment2) { }

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

                actionref(MyReportRef; PrintMemoReport) { }

            }

        }


    }
    var
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";

        RecRef: RecordRef;

}















/*  area(Navigation)
 {
     group(Attachments)
     {
         Caption = 'Attachments';

         action(DocAttachments)
         {
             Caption = 'Attachments';
             Image = Attach;

             trigger OnAction()
             var
                 DocumentAttachmentDetails: Page "Document Attachment Details";
                 RecRef: RecordRef;
             begin
                 RecRef.GetTable(Rec);
                 DocumentAttachmentDetails.OpenForRecRef(RecRef);
             end;
         }
     }
 } */




