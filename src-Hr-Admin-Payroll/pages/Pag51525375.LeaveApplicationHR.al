page 51525375 "Leave Application HR"
{
    ApplicationArea = All;
    Editable = true;
    PageType = Card;
    PromotedActionCategories = 'New,Manage,Process,Report,Attachments,Approval';
    SourceTable = "Employee Leave Application";
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            group("Leave Application")
            {
                Caption = 'Leave Application';
                group(Application)
                {
                    Caption = 'Application';
                    Editable = true;
                    field("Application No"; Rec."Application No")
                    {
                        Editable = false;
                    }
                    field("Employee No"; Rec."Employee No")
                    {
                        Editable = FieldsEditable;
                        Visible = true;
                    }
                    field("Application Date"; Rec."Application Date")
                    {
                        Caption = 'Date of Application';
                        Editable = false;
                    }
                    field("Employee Name"; Rec."Employee Name")
                    {
                        Editable = false;
                        Visible = true;
                    }
                    field("Mobile No"; Rec."Mobile No")
                    {
                        Editable = FieldsEditable;
                    }
                    field("Department Code"; Rec."Department Code")
                    {
                        Caption = 'Department Code';
                        Editable = false;
                    }
                    field("Department Name"; Rec."Department Name")
                    {
                        Caption = 'Department Name';
                        Editable = false;
                    }
                    field("Leave Type"; Rec."Leave Type")
                    {
                        Caption = 'Leave Type';
                        Editable = FieldsEditable;
                        NotBlank = true;
                    }
                }
                group(Balances)
                {
                    Caption = 'Balances';
                    field("Balance brought forward"; Rec."Balance brought forward")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("Acrued Days"; Rec."Acrued Days")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("Leave Earned to Date"; Rec."Leave Earned to Date")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("Total Leave Days Taken"; Rec.CheckDaysAppliedToDate())
                    {
                        Caption = 'No of Days Taken To Date';
                        Editable = false;
                    }
                    field("Leave Entitlment"; Rec."Leave Entitlment")
                    {
                        Caption = 'Leave Entitlment';
                        Editable = false;
                        Visible = false;
                    }
                    field("Recalled Days"; Rec."Recalled Days")
                    {
                        Caption = 'Recalled Days';
                        Editable = false;
                    }
                    field("Days Absent"; Rec."Days Absent")
                    {
                        Caption = 'Days Absent';
                        Visible = false;
                    }
                    field("Leave balance"; Rec.CheckLeaveBalanceToDate())
                    {
                        Caption = 'Leave Balance To Date';
                        Editable = false;
                    }
                }
                group("Current Application Details")
                {
                    Caption = 'Current Application Details';
                    Editable = true;
                    field("Days Applied"; Rec."Days Applied")
                    {
                        Editable = FieldsEditable;
                        NotBlank = true;

                        trigger OnValidate()
                        var
                            LeaveSetup: Record "Leave Types";
                        begin
                            if LeaveSetup.Get(Rec."Leave Type") then begin
                                if LeaveSetup."Annual Leave" = true then
                                    if Rec."Days Applied" > Rec."Leave balance" then
                                        Error('The days applied for are more than your leave balance');
                            end;
                        end;
                    }
                    group("Approved Days")
                    {
                        Caption = 'Approved Days';
                        Visible = ApprVDaysVisi;
                        field(Control11; Rec."Approved Days")
                        {
                        }
                    }
                    field("Start Date"; Rec."Start Date")
                    {
                        Editable = FieldsEditable;
                    }
                    field("End Date"; Rec."End Date")
                    {
                        Editable = false;
                    }
                    field("Resumption Date"; Rec."Resumption Date")
                    {
                        Editable = false;
                        NotBlank = true;
                    }
                    field("Annual Leave Entitlement Bal"; Rec."Annual Leave Entitlement Bal")
                    {
                        Caption = 'Leave Balance';
                        Editable = false;
                    }
                    field("Include Leave Allowance"; Rec."Include Leave Allowance")
                    {
                        Visible = false;
                    }
                    field("Duties Taken Over By"; Rec."Duties Taken Over By")
                    {
                        Editable = FieldsEditable;
                    }
                    field(Name; Rec.Name)
                    {
                        Editable = FieldsEditable;
                    }
                    field(Status; Rec.Status)
                    {
                        Editable = false;
                    }
                    field("No. of Approvals"; Rec."No. of Approvals")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("Pending Approver"; Rec."Pending Approver")
                    {
                        Editable = false;
                        Visible = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request")
            {
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category6;
                Visible = IsSendForApprovalVisible;

                trigger OnAction()
                begin
                    Rec.TestField("Days Applied");
                    Rec.TestField("Leave Type");

                    HrMgmtCU.FnCheckSupervisor(Rec."Employee No");

                    days := Rec."Days Applied";
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);
                    HrMgmtCU.FnSendEmails(Rec."Duties Taken Over By", Rec."Application No", Rec."Days Applied", Rec.Name, Rec."Employee Name", Rec."Start Date", Rec."End Date");

                    HrMgmtCU.SendLeaveApprovalEmail(ApprovalEntry, ApprovalEntry."Document No.");

                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE(ApprovalEntry."Document No.", Rec."Application No");
                    ApprovalEntry.SETRANGE(ApprovalEntry.Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN begin
                        //  PortalApprovalsCU.SendLeaveApprovalEmail(ApprovalEntry, ApprovalEntry."Document No.");
                        //   HrMgmtCU.UpdatePortalApprovalRecords(ApprovalEntry."Document No.", ApprovalEntry."Sender Employee No");
                    end;
                end;
            }
            action("Cancel Approval Re&quest")
            {
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category6;
                Visible = IsCancelVisible;

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::"Pending Approval" then
                        Error('Status must be Pending Approval!');
                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                end;
            }
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter("Application No", Rec."Application No");
                    REPORT.Run(51525192, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action(Approvals)
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category6;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
            action("Post Leave")
            {
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Process;
                Visible = IsPostVisible;

                trigger OnAction()
                var
                    HRLeaveApplication: Record "Employee Leave Application";
                    journal: Record "HR Leave Journal Line";
                    HRLeavePeriods: Record "HR Leave Periods";
                begin

                    if Rec.Status <> Rec.Status::Released then
                        Error(ERROR1);
                    FnPostLeavePg(Rec."Application No");
                    /*IF CONFIRM('Are you sure you want to post this leave?.',TRUE,FALSE)=TRUE THEN
                    BEGIN
                    IF HRSetup.GET() THEN
                    journal.RESET;
                    journal.SETRANGE("Journal Batch Name",HRSetup."Default Leave Posting Template");
                    journal.SETRANGE("Journal Template Name",HRSetup."Positive Leave Posting Batch");
                    IF journal.FIND('-') THEN
                    journal.DELETEALL;
                    
                    HRLeavePeriods.RESET;
                    HRLeavePeriods.SETRANGE(HRLeavePeriods.Closed,FALSE);
                    IF HRLeavePeriods.FINDLAST THEN BEGIN
                    
                    journal.INIT;
                    journal."Line No.":=journal."Line No."+1000;
                    journal."Journal Batch Name":=HRSetup."Default Leave Posting Template";
                    journal."Document No.":="Application No";
                    journal."Journal Template Name":=HRSetup."Positive Leave Posting Batch";
                    journal."Staff No.":="Employee No";
                    journal.VALIDATE("Staff No.");
                    journal."No. of Days":="Days Applied";
                    journal."Leave Period":=HRLeavePeriods."Period Code";
                    journal."Leave Entry Type":=journal."Leave Entry Type"::Negative;
                    journal.VALIDATE("Leave Entry Type");
                    journal.Description:=FORMAT("Leave Type")+' '+"Employee No"+' '+"Application No";
                    journal."Leave Type":="Leave Type";
                    journal."Posting Date":="Application Date";
                    journal.VALIDATE("Leave Type");
                    journal.IsMonthlyAccrued:=FALSE;
                    journal.INSERT;
                    
                    journal.RESET;
                    journal.SETRANGE("Journal Batch Name",HRSetup."Default Leave Posting Template");
                    journal.SETRANGE("Journal Template Name",HRSetup."Positive Leave Posting Batch");
                    IF journal.FIND('-') THEN BEGIN
                    CODEUNIT.RUN(CODEUNIT::"HR Leave Jnl.-Post",journal);
                    END;
                    IF "Leave Type"=HRSetup."Annual Leave Code" THEN BEGIN
                    IF "Include Leave Allowance"=TRUE THEN BEGIN
                    FnPostLeaveAllowance("Employee No","Days Applied");
                    END;
                    END;
                    Posted:=TRUE;
                    "Posted By":=USERID;
                    "Date Posted":=TODAY;
                    "Time Posted":=TIME;
                    MODIFY;
                    END;
                    MESSAGE('Leave application has been posted');
                    END;
                    */

                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
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
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Close;
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
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                        CurrPage.Close;
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
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
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControls();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateControls();
    end;

    trigger OnOpenPage()
    begin
        /*
        IF NOT approvalentry.FINDSET THEN
          BEGIN
           OpenApprovalEntriesExistForCurrUser2:=TRUE;
          END;
        
        IF OpenApprovalEntriesExistForCurrUser=TRUE THEN
          BEGIN
           OpenApprovalEntriesExistForCurrUser2:=FALSE;
         END;
        IF Status=Status::Released THEN
         BEGIN
          OpenApprovalEntriesExistForCurrUser:=FALSE;
          OpenApprovalEntriesExistForCurrUser2:=FALSE;
        END;
        */
        CurrPage.Editable(true);
        if Rec.Status = Rec.Status::Released then
            CurrPage.Editable(false);

        UpdateControls();
        //Approve,reject button visibility
        approvalentry.Reset;
        approvalentry.SetFilter(approvalentry.Status, '%1', approvalentry.Status::Open);
        //approvalentry.SetFilter(approvalentry."Document Type", '%1', approvalentry."Document Type"::None);
        approvalentry.SetFilter(approvalentry."Approver ID", '%1', UserId);
        approvalentry.SetFilter(approvalentry."Document No.", Rec."Application No");
        if approvalentry.FindSet then
            OpenApprovalEntriesExistForCurrUser := true
        else
            OpenApprovalEntriesExistForCurrUser := false;

    end;

    var
        d: Date;
        Mail: Codeunit Mail;
        Body: Text[250];
        days: Decimal;
        LeaveAllowancePaid: Boolean;
        FiscalStart: Date;
        FiscalEnd: Date;
        AccPeriod: Record "Payroll Period";
        HRSetup: Record "Human Resources Setup";
        Text19051012: Label 'No. Of days to Apply';
        PendingApprover: Code[30];
        OpenApprovalEntriesExistForCurrUser: Boolean;
        approvalentry: Record "Approval Entry";
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record "Approval Entry";
        IsCancelVisible: Boolean;
        IsSendForApprovalVisible: Boolean;
        IsPostVisible: Boolean;
        ERROR1: Label 'Leave status must be open';
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Text1: Label 'LEAVE APPLICATION';
        FieldsEditable: Boolean;
        BasicSalary: Decimal;
        ApprVDaysVisi: Boolean;
        HrMgmtCU: Codeunit "Custom Helper Functions HR";
        PortalApprovalsCU: Codeunit "Custom Helper Functions HR";

    procedure FnSendEmails(StaffNo: Code[40]; DocumentNo: Code[40]; NumberOfDaysApplied: Integer; RelieversName: Text[100]; ApplicantsName: Text[100]; FromDate: Date; ToDate: Date)
    var
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        UserSetup: Record "User Setup";
        EmpRec: Record Employee;
    begin
        EmpRec.Reset;
        EmpRec.SetRange("No.", StaffNo);
        if EmpRec.FindFirst then begin
            EmailMessage.Create(EmpRec."Company E-Mail", Text1,
        'Dear ' + RelieversName + '. You have been selected as a reliever for ' + ApplicantsName + 'on leave application:' +
        Format(DocumentNo) + ', from ' + Format(FromDate) + ' to ' + Format(FromDate) + '.', false);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
            //MESSAGE('Mail Sent');
        end;
    end;

    local procedure FnPostLeaveAllowance(var EmployeeNo: Code[10]; var DaysApplieds: Decimal)
    var
        EmployeeX: Record Employee;
        AssignmentMatrix: Record "Assignment Matrix";
        HRSetup: Record "Human Resources Setup";
    begin
        HRSetup.Get();
        if EmployeeX.Get(EmployeeNo) then begin
            if DaysApplieds >= HRSetup."Leave Allowance Days" then begin
                FnGetBasicPay(EmployeeX."Salary Scale", EmployeeX.Present);
                if AssignmentMatrix.FindLast then begin
                    AssignmentMatrix.Init;
                    AssignmentMatrix."Employee No" := EmployeeNo;
                    AssignmentMatrix.Type := AssignmentMatrix.Type::Payment;
                    AssignmentMatrix.Code := HRSetup."Leave Allowance Code";
                    AssignmentMatrix.Validate(Code);
                    AssignmentMatrix.Amount := BasicSalary;
                    if AssignmentMatrix.Amount > 0 then
                        AssignmentMatrix.Insert;
                end;
                EmployeeX."Allowance Collected" := true;
                EmployeeX.Modify;
            end;
        end;
    end;

    local procedure FnGetBasicPay(var Grade: Code[10]; var Present: Code[10])
    var
        Benefits: Record "Scale Benefits";
        HRSetups: Record "Human Resources Setup";
    begin
        BasicSalary := 0;
        HRSetups.Get();
        Benefits.Reset;
        Benefits.SetRange(Benefits."Salary Scale", Grade);
        Benefits.SetRange(Benefits."Salary Pointer", Present);
        Benefits.SetRange(Benefits."ED Code", '01');
        if Benefits.Find('-') then begin
            BasicSalary := Round((1 / 3 * Benefits.Amount), 0.01, '>');
            if BasicSalary > HRSetups."Leave Allowance Limit" then
                BasicSalary := HRSetups."Leave Allowance Limit"
            else
                BasicSalary := BasicSalary;
        end;
    end;

    procedure FnPostLeavePg(LeaveNo: Code[10])
    var
        LRegister: Record "Employee Leave Application";
        HRLeaveApplication: Record "Employee Leave Application";
        HRLeavePeriods: Record "HR Leave Periods";
        journal: Record "HR Leave Journal Line";
    begin
        LRegister.Reset;
        LRegister.SetRange(LRegister."Application No", LeaveNo);
        if LRegister.FindFirst then begin
            if LRegister.Status = LRegister.Status::Released then
                //IF CONFIRM('Are you sure you want to post this leave?.',TRUE,FALSE)=TRUE THEN
                //BEGIN
                HRSetup.Get();
            journal.Reset;
            journal.SetRange("Journal Batch Name", HRSetup."Default Leave Posting Template");
            journal.SetRange("Journal Template Name", HRSetup."Positive Leave Posting Batch");
            if journal.Find('-') then
                journal.DeleteAll;

            HRLeavePeriods.Reset;
            HRLeavePeriods.SetRange(HRLeavePeriods.Closed, false);
            if HRLeavePeriods.FindLast then begin

                journal.Init;
                journal."Line No." := journal."Line No." + 1000;
                journal."Document No." := LRegister."Application No";
                journal."Journal Template Name" := HRSetup."Default Leave Posting Template"; //HRSetup."Positive Leave Posting Batch";
                journal."Journal Batch Name" := HRSetup."Positive Leave Posting Batch"; //HRSetup."Default Leave Posting Template";
                journal."Staff No." := LRegister."Employee No";
                journal.Validate("Staff No.");
                LRegister.TestField(LRegister."Approved Days");
                if LRegister."Approved Days" = 0 then
                    Error('Please open record and type in approved leave days before approving');
                journal."No. of Days" := LRegister."Approved Days";
                journal."Leave Period" := HRLeavePeriods."Period Code";
                journal."Leave Entry Type" := journal."Leave Entry Type"::Negative;
                journal.Validate("Leave Entry Type");
                journal.Description := Format(Rec."Leave Type") + ' ' + LRegister."Employee No" + ' ' + LRegister."Application No";
                journal."Leave Type" := LRegister."Leave Type";
                journal."Posting Date" := LRegister."Application Date";
                journal.Validate("Leave Type");
                journal.IsMonthlyAccrued := false;
                journal.Insert;

                journal.Reset;
                journal.SetRange("Journal Batch Name", HRSetup."Positive Leave Posting Batch"/*HRSetup."Default Leave Posting Template"*/);
                journal.SetRange("Journal Template Name", HRSetup."Default Leave Posting Template"/*HRSetup."Positive Leave Posting Batch"*/);
                if journal.Find('-') then begin
                    CODEUNIT.Run(CODEUNIT::"HR Leave Jnl.-Post", journal);
                end;
                if Rec."Leave Type" = HRSetup."Annual Leave Code" then begin
                    if LRegister."Include Leave Allowance" = true then begin
                        FnPostLeaveAllowance(LRegister."Employee No", LRegister."Days Applied");
                    end;
                end;
                LRegister.Posted := true;
                LRegister."Posted By" := UserId;
                LRegister."Date Posted" := Today;
                LRegister."Time Posted" := Time;
                LRegister.Modify;
            end;
        end;
        //END;
    end;

    local procedure UpdateControls()
    begin

        if Rec.Status = Rec.Status::Open then
            IsSendForApprovalVisible := true
        else
            IsSendForApprovalVisible := false;

        if Rec.Status = Rec.Status::"Pending Approval" then
            IsCancelVisible := true
        else
            IsCancelVisible := false;

        if (Rec.Status = Rec.Status::"Pending Approval")
           or (Rec.Status = Rec.Status::Released) then
            ApprVDaysVisi := true
        else
            ApprVDaysVisi := false;

        if Rec.Status = Rec.Status::Released then
            IsPostVisible := true
        else
            IsPostVisible := false;

        FieldsEditable := false;
        if ((Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::Rejected)) = true then
            FieldsEditable := true;
    end;
}