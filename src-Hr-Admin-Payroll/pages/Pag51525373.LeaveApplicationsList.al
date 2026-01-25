page 51525373 "Leave Applications List"
{
    ApplicationArea = All;
    CardPageID = "Leave Application HR";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Employee Leave Application";
    SourceTableView = SORTING("Application No") ORDER(descending);
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Application No"; Rec."Application No")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Leave Type"; Rec."Leave Type")
                {
                }
                field("Days Applied"; Rec."Days Applied")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Application Date"; Rec."Application Date")
                {
                }
                field("Resumption Date"; Rec."Resumption Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Balance brought forward"; Rec."Balance brought forward")
                {
                    Visible = false;
                }
                field("Leave Entitlment"; Rec."Leave Entitlment")
                {
                }
                field("Total Leave Days Taken"; Rec."Total Leave Days Taken")
                {
                    Visible = false;
                }
                field("Leave balance"; Rec.CheckLeaveBalanceToDate())
                {
                }
                field("Duties Taken Over By"; Rec."Duties Taken Over By")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Mobile No"; Rec."Mobile No")
                {
                }
                field("Leave Earned to Date"; Rec."Leave Earned to Date")
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Date of Joining Company"; Rec."Date of Joining Company")
                {
                }
                field("Department Code"; Rec."Department Code")
                {
                }
                field("Department Name"; Rec."Department Name")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Attachments)
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Document Attachment Details";
                RunPageLink = "No." = FIELD("Application No");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        /*ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE(ApprovalEntry.Status,ApprovalEntry.Status::Approved);
        ApprovalEntry.SETRANGE(ApprovalEntry."Document No.","Application No");
        IF ApprovalEntry.FIND('-') THEN
        BEGIN
          FirstApprover:=;
          FirstApproverDate:=;
          SecondApprover:=;
          SecondApproverDate:=;

        END;
          */

        if Rec.Status = Rec.Status::Released then begin
            ApprovalEntries.Reset;
            ApprovalEntries.SetRange(ApprovalEntries."Document No.", Rec."Application No");
            ApprovalEntries.SetRange(ApprovalEntries.Status, ApprovalEntries.Status::Approved);
            if ApprovalEntries.Find('-') then begin
                i := 0;
                repeat
                    i := i + 1;
                    if i = 1 then begin
                        FirstApprover := ApprovalEntries."Approver ID";
                        FirstApproverDate := DT2Date(ApprovalEntries."Last Date-Time Modified");
                    end;

                    if i = 2 then begin
                        SecondApprover := ApprovalEntries."Approver ID";
                        SecondApproverDate := DT2Date(ApprovalEntries."Last Date-Time Modified");
                    end;

                    if i = 3 then begin
                        ThirdApprover := ApprovalEntries."Approver ID";
                        ThirdApproverDate := DT2Date(ApprovalEntries."Last Date-Time Modified");
                    end;

                until ApprovalEntries.Next = 0;
            end;
        end;

    end;

    var
        FirstApprover: Code[30];
        FirstApproverDate: Date;
        SecondApprover: Code[30];
        SecondApproverDate: Date;
        ApprovalEntries: Record "Approval Entry";
        i: Integer;
        ThirdApprover: Code[30];
        ThirdApproverDate: Date;
}