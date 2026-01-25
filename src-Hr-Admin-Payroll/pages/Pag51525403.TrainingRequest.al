page 51525403 "Training Request"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Training Request";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = EnableEditing;
                field("Request No."; Rec."Request No.")
                {
                    Editable = false;
                }
                field("Request Date"; Rec."Request Date")
                {
                    Editable = false;
                }
                field(Directorate; Rec.Directorate)
                {
                    Visible = false;
                }
                field("Directorate Name"; Rec."Directorate Name")
                {
                    Visible = false;
                }
                field("Department Code"; Rec."Department Code")
                {
                    Editable = false;
                }
                field("Department Name"; Rec."Department Name")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Caption = 'Requested By';
                    Enabled = false;
                }
                field("Tuition Fee"; Rec."Tuition Fee")
                {
                    Editable = false;
                }
                field("Perdiem Per Day"; Rec."Perdiem Per Day")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Per Diem"; Rec."Per Diem")
                {
                    Caption = 'Total Per Diem';
                    Editable = false;
                }
                field("Air Ticket"; Rec."Air Ticket")
                {
                    Editable = false;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Enabled = false;
                }
                field("No. of Approvals"; Rec."No. of Approvals")
                {
                    Editable = false;
                    Visible = false;
                }
            }
            part(Control46; "Training Participants")
            {
                SubPageLink = "Training Request" = FIELD("Request No.");
                Editable = EnableEditing;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Send Approval Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*GLSetup.RESET;
                    GLSetup.GET;
                    HRSetup.RESET;
                    HRSetup.GET;
                    HRSetup.TESTFIELD("FY Deadline-Training Proposals");
                    IF GLSetup."Current Budget"<>"Budget Name" THEN BEGIN
                      // ERROR('You can only Request Trainings For FY '+GLSetup."Current Budget"+'.Your Training is For FY '+"Budget Name");
                    END;
                    IF "Request Date">HRSetup."FY Deadline-Training Proposals" THEN BEGIN
                        //ERROR('You are requesting training after the Deadline!');
                    END;
                    
                    TESTFIELD("Request Date");
                    TESTFIELD("Tuition Fee");
                    TESTFIELD("Local Destination");
                    //TESTFIELD("Per Diem");
                    TESTFIELD("Planned Start Date");
                    TESTFIELD("Planned End Date");
                    IF "International Travel" THEN BEGIN
                         TESTFIELD("International Destination");
                         TESTFIELD("Exchange Rate");
                    END;
                    */
                    /*
                    //enable
                    IF ApprovalsMgmt.CheckTrainingApprovalPossible(Rec) THEN
                       ApprovalsMgmt.OnSendTrainingDocForApproval(Rec);
                    */
                    Rec.Status := Rec.Status::Released;
                    Message(('Approved successfully!'));
                    Rec.Modify;

                end;
            }
            action("Cancel Approval Request.")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = OpenApprovalEntriesExistForCurrUser2;

                trigger OnAction()
                begin

                    //IF Status<>Status::Released THEN
                    //approvalsmgmt.GetApprovalCommentERC(Rec,0,"Request No.");
                end;
            }
            action(Revise)
            {
                Image = RefreshText;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = seerevise;

                trigger OnAction()
                begin
                    ans := Confirm('Revising will Send an E-mail to the Training Need Requestor For Changes to the Training Need.\You will be required to Put Comments on the Document.\Are you sure you want to Revise?');
                    if Format(ans) = 'Yes' then begin
                        // approvalsmgmt.GetApprovalCommentERC(Rec,3,"Request No.");
                    end;
                end;
            }
            action("DMS Link")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin

                    /*GLSetup.Get;
                    link := GLSetup."DMS Imprest Link" + "Request No.";
                    HyperLink(link);*/
                end;
            }
            action(Attachments)
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Document Attachment Details";
                RunPageLink = "Table ID" = CONST(Database::"Training Request"), "No." = FIELD("Request No.");
                Visible = true;
            }
            action("Approval Entries")
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
            action("Create Tuition Invoice")
            {
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = seeInvoice;

                trigger OnAction()
                begin
                    if Rec."Tuition Invoice Created" = true then begin
                        Error('Purchase Invoice Already Created For This Training!');
                    end;

                    purchaseHdr.Reset;
                    //purchaseHdr.SetFilter("Training Code", "Request No.");
                    if purchaseHdr.FindSet then begin
                        Error('This Training has already been used in Creating Purchase Invoice No: ' + purchaseHdr."No.");
                    end;

                    //GLSetup.Reset;

                    purchaseHdr.Reset;
                    purchaseHdr."No." := '';
                    purchaseHdr."Document Type" := purchaseHdr."Document Type"::Invoice;
                    purchaseHdr."Buy-from Vendor No." := Rec."Training Institution Code";
                    purchaseHdr.Validate("Buy-from Vendor No.");
                    purchaseHdr."Document Date" := Today;
                    purchaseHdr."Posting Date" := Today;
                    purchaseHdr.Validate("Document Date");
                    purchaseHdr."Prices Including VAT" := true;
                    //purchaseHdr."From Training Tuition" := true;
                    //purchaseHdr."Training Code" := "Request No.";
                    purchaseHdr.Insert;

                    purchaseline.Reset;
                    purchaseline.Init;
                    purchaseline."Document Type" := purchaseline."Document Type"::Invoice;
                    purchaseline."Document No." := purchaseHdr."No.";
                    purchaseline.Validate("Document No.");
                    purchaseline.Type := purchaseline.Type::"G/L Account";
                    purchaseline."No." := Rec."GL Account";
                    purchaseline.Validate("No.");
                    purchaseline.Quantity := 1;
                    purchaseline.Validate(Quantity);
                    purchaseline."Direct Unit Cost" := Rec."Tuition Fee";
                    purchaseline.Validate("Direct Unit Cost");
                    purchaseline.Insert;

                    Rec."Tuition Invoice Created" := true;
                    Rec.Modify;
                    PAGE.Run(51, purchaseHdr);
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
                Image = Alerts;
                Enabled = EnableEditing;
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Close;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                        //ApprovalsMgmt.GetApprovalCommentERC(Rec,1,"Request No.");
                        //CurrPage.CLOSE;
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                        //CurrPage.CLOSE;
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    Visible = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        //ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin

        /*
        IF Status=Status::Released THEN BEGIN
                     Usersetup.RESET;
                      Usersetup.SETFILTER("User ID",USERID);
                      IF Usersetup.FINDSET THEN BEGIN
                         emprec.RESET;
                         IF emprec.GET(Usersetup."Employee No.") THEN BEGIN
                            GLSetup.RESET;
                            GLSetup.GET;
                            GLSetup.TESTFIELD("HR Department");//MESSAGE('%1\%2\%3',emprec."Global Dimension 1 Code",emprec."No.",Usersetup."User ID");
                            IF GLSetup."HR Department"<>emprec."Global Dimension 1 Code" THEN BEGIN
                               ERROR('You cannot Modify an Approved Training Need!');
                            END;
                         END;
                      END;
        END;
        */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Currency := 'USD';
    end;

    trigger OnOpenPage()
    var
        TrainingMasterRec: Record "Training Master Plan Header";
    begin
        //CurrPage.Editable(true);
        EnableEditing := true;
        if TrainingMasterRec.IsAReadOnlyUser() then
            EnableEditing := false;//CurrPage.Editable(false);
        /*approvalentry.RESET;
        approvalentry.SETFILTER(approvalentry.Status,'%1',approvalentry.Status::Open);
        approvalentry.SETFILTER(approvalentry."Document Type",'%1',approvalentry."Document Type"::Training);
        approvalentry.SETFILTER(approvalentry."Approver ID",'%1',USERID);
        approvalentry.SETFILTER(approvalentry."Document No.","Request No.");
        IF approvalentry.FINDSET THEN BEGIN
           OpenApprovalEntriesExistForCurrUser:=TRUE;
          //MESSAGE('Approver...');
        END;
        IF NOT approvalentry.FINDSET THEN BEGIN
           OpenApprovalEntriesExistForCurrUser2:=TRUE;
          // MESSAGE('Not an Approver...');
        END;
        IF OpenApprovalEntriesExistForCurrUser=TRUE THEN BEGIN
           OpenApprovalEntriesExistForCurrUser2:=FALSE;
        END;
        */
        seerevise := false;


        /*Usersetup.Reset;
        Usersetup.SetFilter("User ID", UserId);
        if Usersetup.FindSet then begin
            emprec.Reset;
            if emprec.Get(Usersetup."Employee No.") then begin
                GLSetup.Reset;
                GLSetup.Get;
                //GLSetup.TestField("HR Department");//MESSAGE('%1\%2\%3',emprec."Global Dimension 1 Code",emprec."No.",Usersetup."User ID");
                if GLSetup."HR Department" = emprec."Global Dimension 1 Code" then begin
                    HRSee := true;
                end;
            end;
        end;*/

        editablebd := true;
        if Rec.Status = Rec.Status::Released then begin //The Document is Released, now just visible to HR Guys info
            editablebd := false;
            /*Usersetup.Reset;
            Usersetup.SetFilter("User ID", UserId);
            if Usersetup.FindSet then begin
                emprec.Reset;
                if emprec.Get(Usersetup."Employee No.") then begin
                    GLSetup.Reset;
                    GLSetup.Get;
                    //GLSetup.TestField("HR Department");//MESSAGE('%1\%2\%3',emprec."Global Dimension 1 Code",emprec."No.",Usersetup."User ID");
                    if GLSetup."HR Department" = emprec."Global Dimension 1 Code" then begin
                        OpenApprovalEntriesExistForCurrUser2 := false;
                        seerevise := true;
                    end;
                end;
            end;*/
        end;
        if Rec.Status = Rec.Status::Released then begin
            if Rec."Ready For Imprest" = true then begin
                seerevise := false;
                seeInvoice := true;
            end;
        end;

    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        approvalentry: Record "Approval Entry";
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record "Approval Entry";
        CUST: Record Customer;
        Internationalsee: Boolean;
        Localsee: Boolean;
        //dotnetvalue: DotNet Interaction;
        commentmsg: Text;
        commentline: Record "Approval Comment Line";
        //GLSetup: Record "Cash Management Setup";
        link: Text;
        HRSee: Boolean;
        Usersetup: Record "User Setup";
        emprec: Record Employee;
        editablebd: Boolean;
        ans: Boolean;
        seerevise: Boolean;
        purchaseHdr: Record "Purchase Header";
        purchaseline: Record "Purchase Line";
        seeInvoice: Boolean;
        HRSetup: Record "Human Resources Setup";
        EnableEditing: Boolean;
}