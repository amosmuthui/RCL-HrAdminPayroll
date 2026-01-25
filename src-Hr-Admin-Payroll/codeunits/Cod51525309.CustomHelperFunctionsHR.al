codeunit 51525309 "Custom Helper Functions HR"
{
    procedure FnCheckSupervisor(EmpNo: Code[40])
    var
        EmployeeRec: Record Employee;
    begin
        IF EmpNo <> '' THEN BEGIN
            EmployeeRec.RESET;
            EmployeeRec.SETRANGE("No.", EmpNo);
            IF EmployeeRec.FINDFIRST THEN BEGIN
                IF EmployeeRec."Manager No." = '' THEN
                    ERROR('Kindly request the HR Department to set for you (%1) a supervisor in the Employee Card! %1', EmpNo);
            END;
        end;
    end;

    var
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        Text1: Label 'LEAVE APPLICATION';

    procedure FnSendEmails(StaffNo: Code[40]; DocumentNo: Code[40]; NumberOfDaysApplied: Integer; RelieversName: Text[100]; ApplicantsName: Text[100]; FromDate: Date; ToDate: Date)
    var
        UserSetup: Record "User Setup";
        EmpRec: Record Employee;
    begin
        EmpRec.Reset;
        EmpRec.SetRange("No.", StaffNo);
        if EmpRec.FindFirst then begin
            if EmpRec."Company E-Mail" <> '' then begin
                EmailMessage.Create(EmpRec."Company E-Mail", Text1,
                'Dear ' + RelieversName + '. You have been selected as a reliever for ' + ApplicantsName + 'on leave application:' +
                Format(DocumentNo) + ', from ' + Format(FromDate) + ' to ' + Format(ToDate) + '.', false);
                Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                //MESSAGE('Mail Sent');
            end;
        end;
    end;

    var
        ApprovalEntry: Record "Approval Entry";
        Employee: Record Employee;

    procedure UpdatePortalApprovalRecords(ApprovalDocNo: Code[40]; EmpNo: Code[40])
    var
        EmployeeRec: Record Employee;
        ManagerNo: Code[20];
        LeaveApplicationRec: Record "Employee Leave Application";
    begin
        IF ApprovalDocNo <> '' THEN BEGIN
            ApprovalEntry.RESET;
            ApprovalEntry.SETRANGE("Document No.", ApprovalDocNo);
            ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
            IF ApprovalEntry.FINDFIRST THEN BEGIN
                ApprovalEntry."Web Portal Approval" := TRUE;
                EmployeeRec.RESET;
                EmployeeRec.SETRANGE("No.", EmpNo);
                IF EmployeeRec.FINDFIRST THEN BEGIN
                    IF EmployeeRec."Manager No." = '' THEN
                        ERROR('You must set the supervisor for Employee No. %1', EmpNo);
                    ApprovalEntry."Sender Employee No" := EmpNo;
                    ApprovalEntry."Sender Name" := EmployeeRec."First Name" + ' ' + EmployeeRec."Middle Name" + ' ' + EmployeeRec."Last Name";

                    ManagerNo := EmployeeRec."Manager No.";
                    //If supervisor is on leave and has a reliever, pass it to the reliever
                    LeaveApplicationRec.Reset();
                    LeaveApplicationRec.SetRange("Employee No", ManagerNo);
                    LeaveApplicationRec.SetRange(Status, LeaveApplicationRec.Status::Released);
                    LeaveApplicationRec.SetFilter("Start Date", '<=%1', Today);
                    LeaveApplicationRec.SetFilter("Resumption Date", '>=%1', Today);
                    LeaveApplicationRec.SetFilter("Duties Taken Over By", '<>%1', '');
                    if LeaveApplicationRec.FindFirst() then
                        ManagerNo := LeaveApplicationRec."Duties Taken Over By";

                    Employee.RESET;
                    Employee.SETRANGE("No.", ManagerNo);
                    IF Employee.FINDFIRST THEN BEGIN
                        ApprovalEntry."Approver Employee No" := ManagerNo;//Employee."Manager No.";
                        ApprovalEntry."Approver Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    END ELSE
                        ERROR('Supervisor with employee No. %1 not found!', EmpNo);
                END ELSE
                    ERROR('Employee No. %1 not found!', EmpNo);
                ApprovalEntry.MODIFY;
            END;
        END;
    end;


    var
        BaseAttachmentsMgmt: Codeunit "Base Attachments Management";
        MimeType: Text;
        FileExt: Text;

    procedure SendLeaveApprovalEmail(var ApprovalEntry: Record "Approval Entry"; DocumentNo: Code[20]) Ok: Boolean
    var
        Subject: Text;
        EmailReceiverName: Text;
        Body: Text;
        ApprovalEntry2: Record "Approval Entry";
        HRLeaveApplication: Record "Employee Leave Application";
        HrSetup: Record "Human Resources Setup";
        LeaveTypes: Record "Leave Types";
        DocAttachments: Record "Document Attachment";
        OutStr: OutStream;
        InStr: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        with ApprovalEntry do begin
            //Approver
            Subject := 'Approval Request';

            if Status = Status::Open then begin
                if "Approver Employee No" <> '' then
                    Employee.Get("Approver Employee No");
                EmailReceiverName := Employee.FullName;
                Body := Format(ApprovalEntry."Document Type") + ' Request No ' + "Document No." + ' requires your approval';

            end else
                if (Status = Status::Approved) or (Status = Status::Rejected) or (Status = Status::Canceled) then begin
                    Body := Format(ApprovalEntry."Document Type") + ' Request No ' + "Document No." + ' has been ' + Format(Status);
                    if "Approver Employee No" <> '' then
                        Employee.Get("Approver Employee No");
                    EmailReceiverName := Employee.FullName;
                end;
            if Employee."Company E-Mail" <> '' then begin
                HRLeaveApplication.Reset;
                if HRLeaveApplication.Get(DocumentNo) then;

                EmailMessage.Create(Employee."Company E-Mail", Subject, '', true);
                //SMTPMail.AddCC('dmunene@panachetechnohub.co.ke');
                EmailMessage.AppendToBody('Dear' + ' ' + EmailReceiverName + ',');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody(Body);
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('<table border="1"><tr><td>Staff Name:</td><td>' + HRLeaveApplication."Employee Name" + '</td></tr>');
                EmailMessage.AppendToBody('<tr><td>Company:</td><td> ' + CompanyName + '</td></tr>');
                EmailMessage.AppendToBody('<tr><td>Employee Code:</td><td> ' + HRLeaveApplication."Employee No" + '</td></tr>');
                EmailMessage.AppendToBody('<tr><td>Submitted:</td><td> ' + Format("Date-Time Sent for Approval") + '</td></tr>');
                HRLeaveApplication.Reset;
                if HRLeaveApplication.Get("Document No.") then begin
                    HRLeaveApplication.CalcFields("Leave balance");
                    EmailMessage.AppendToBody('<tr><td>Leave Type:</td><td> ' + HRLeaveApplication."Leave Type" + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Days Applied:</td><td> ' + Format(HRLeaveApplication."Days Applied") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Current Balance:</td><td> ' + Format(HRLeaveApplication.GetLeaveTypeBalance()/*"Leave balance"*/) + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Date From::</td><td> ' + Format(HRLeaveApplication."Start Date") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Date To:</td><td> ' + Format(HRLeaveApplication."End Date") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Resumption Date:</td><td> ' + Format(HRLeaveApplication."Resumption Date") + '</td></tr>');
                end;
                EmailMessage.AppendToBody('</table>');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('Approval Workflow History.');
                EmailMessage.AppendToBody('<table border="0.1"><tr><td>Sequence:</td><td>Approver</td><td>Status</td><td>Comment(s)</td></tr>');
                ApprovalEntry2.Reset;
                ApprovalEntry2.SetRange("Document Type", ApprovalEntry."Document Type");
                ApprovalEntry2.SetRange("Document No.", DocumentNo);
                if ApprovalEntry2.FindFirst then
                    repeat
                        if ApprovalEntry2."Approver Name" = '' then
                            ApprovalEntry2."Approver Name" := "Approver Name";

                        EmailMessage.AppendToBody('<tr><td>' + Format(ApprovalEntry2."Sequence No.") + '</td><td> ' + ApprovalEntry2."Approver Name" + '</td><td> ' + Format(ApprovalEntry2.Status) + '</td><td> ' + Format(ApprovalEntry2."Approval Comments") + '</td></tr>');

                    until ApprovalEntry2.Next = 0;
                EmailMessage.AppendToBody('</table>');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('<a href="https://ess.rwandair.com/" target="_blank">Click https://ess.rwandair.com/</a> to access ESS portal.');
                EmailMessage.AppendToBody('<p><strong>Note:</strong> This is a system generated email. Please do not reply.</p>');
                //SMTPMail.Send;
                if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
                    Ok := false
                else
                    Ok := true;

            end;

            //Requestor
            Subject := 'Approval Request';

            if Status = Status::Open then begin
                if "Sender Employee No" <> '' then
                    Employee.Get("Sender Employee No");
                EmailReceiverName := Employee.FullName;
                Body := 'Your ' + Format(ApprovalEntry."Document Type") + ' Request No ' + "Document No." + ' has been sent for approval';

            end else
                if (Status = Status::Approved) or (Status = Status::Rejected) or (Status = Status::Canceled) then begin
                    Body := 'Your ' + Format(ApprovalEntry."Document Type") + ' Request No ' + "Document No." + ' has been ' + Format(Status) + '.';
                    if "Sender Employee No" <> '' then
                        Employee.Get("Sender Employee No");
                    EmailReceiverName := Employee.FullName;
                end;

            if Employee."Company E-Mail" <> '' then begin
                EmailMessage.Create(Employee."Company E-Mail", Subject, '', true);
                //SMTPMail.AddCC('dmunene@panachetechnohub.co.ke');
                HrSetup.Get();
                if (HrSetup."HR Department Email" <> '') and (Status = Status::Approved) then
                    EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(HrSetup."HR Department Email", '<>'));
                if (HRLeaveApplication."Leave Type" = 'MATERNITY') and (HrSetup."Payroll Administrator Email" <> '') and (Status = Status::Approved) then
                    EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(HrSetup."Payroll Administrator Email", '<>'));
                EmailMessage.AppendToBody('Dear' + ' ' + EmailReceiverName + ',');
                EmailMessage.AppendToBody('<br><br>');
                // Body:='Your Request '+"Document No."+'has been '+FORMAT(Status);
                EmailMessage.AppendToBody(Body);
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('<table border="1"><tr><td>Staff Name:</td><td>' + EmailReceiverName + '</td></tr>');
                EmailMessage.AppendToBody('<tr><td>Company:</td><td> ' + CompanyName + '</td></tr>');
                EmailMessage.AppendToBody('<tr><td>Employee Code:</td><td> ' + Employee."No." + '</td></tr>');
                EmailMessage.AppendToBody('<tr><td>Submitted:</td><td> ' + Format("Date-Time Sent for Approval") + '</td></tr>');
                HRLeaveApplication.Reset;
                if HRLeaveApplication.Get("Document No.") then begin
                    //Copy any emails set in the leave type
                    LeaveTypes.Reset();
                    LeaveTypes.SetRange(Code, HRLeaveApplication."Leave Type");
                    LeaveTypes.SetFilter("Notification Email", '<>%1', '');
                    if LeaveTypes.FindFirst() then begin
                        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(LeaveTypes."Notification Email", '<>'));
                        //Upload the attachment as well
                        DocAttachments.Reset();
                        DocAttachments.SetRange("Table ID", Database::"Employee Leave Application");
                        DocAttachments.SetRange("No.", "Document No.");
                        if DocAttachments.FindSet() then
                            repeat
                                if DocAttachments."Document Reference ID".HasValue then begin
                                    TempBlob.CreateOutStream(OutStr);
                                    DocAttachments."Document Reference ID".ExportStream(OutStr);
                                    TempBlob.CreateInStream(InStr);
                                    //  BaseAttachmentsMgmt.GetMimeType('Support Doc - ' + DocAttachments."File Name" + '.' + DocAttachments."File Extension", MimeType, FileExt);
                                    EmailMessage.AddAttachment('Support Doc - ' + DocAttachments."File Name" + '.' + DocAttachments."File Extension", MimeType, InStr);
                                    Clear(OutStr);
                                    Clear(InStr);
                                end;
                            until DocAttachments.Next() = 0;
                    end;

                    HRLeaveApplication.CalcFields("Leave balance");
                    EmailMessage.AppendToBody('<tr><td>Leave Type:</td><td> ' + HRLeaveApplication."Leave Type" + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Days Applied:</td><td> ' + Format(HRLeaveApplication."Days Applied") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Current Balance:</td><td> ' + Format(HRLeaveApplication.GetLeaveTypeBalance()/*"Leave balance"*/) + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Date From::</td><td> ' + Format(HRLeaveApplication."Start Date") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Date To:</td><td> ' + Format(HRLeaveApplication."End Date") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Resumption Date:</td><td> ' + Format(HRLeaveApplication."Resumption Date") + '</td></tr>');

                end;
                EmailMessage.AppendToBody('</table>');

                EmailMessage.AppendToBody('Approval Workflow History.');
                EmailMessage.AppendToBody('<table border="0.1"><tr><td>Sequence:</td><td>Approver</td><td>Status</td><td>Comment(s)</td></tr>');
                ApprovalEntry2.Reset;
                ApprovalEntry2.SetRange("Document Type", ApprovalEntry."Document Type");
                ApprovalEntry2.SetRange("Document No.", DocumentNo);
                if ApprovalEntry2.FindFirst then
                    repeat
                        if ApprovalEntry2."Approver Name" = '' then
                            ApprovalEntry2."Approver Name" := "Approver Name";
                        EmailMessage.AppendToBody('<tr><td>' + Format(ApprovalEntry2."Sequence No.") + '</td><td> ' + ApprovalEntry2."Approver Name" + '</td><td> ' + Format(ApprovalEntry2.Status) + '</td> <td> ' + Format(ApprovalEntry2."Approval Comments") + '</td></tr>');
                    until ApprovalEntry2.Next = 0;
                EmailMessage.AppendToBody('</table>');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('<a href="https://ess.rwandair.com/" target="_blank">Click https://ess.rwandair.com/ </a> to access ESS portal.');
                EmailMessage.AppendToBody('<p><strong>Note:</strong> This is a system generated email. Please do not reply.</p>');
                //SMTPMail.Send;
                if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
                    Ok := false
                else
                    Ok := true;

            end;
        end;
    end;


    procedure SendLeaveRecallEmail(LeaveRecallNo: Code[20]) Ok: Boolean
    var
        Subject: Text;
        EmailReceiverName: Text;
        Body: Text;
        ApprovalEntry2: Record "Approval Entry";
        HRLeaveApplication: Record "Employee Leave Application";
        HrSetup: Record "Human Resources Setup";
        ApprovalEntry: Record "Approval Entry";
        LeaveRecall: Record "Leave Recall";
        "Approver Employee No": Code[100];
        "Reliever Employee No": Code[100];
        ApproverEmail: Text;
        RelieverEmail: Text;
    begin
        LeaveRecall.Reset();
        LeaveRecall.SetRange("No.", LeaveRecallNo);
        if LeaveRecall.FindFirst() then begin
            ApproverEmail := '';
            RelieverEmail := '';
            HRLeaveApplication.Reset();
            HRLeaveApplication.SetRange("Application No", LeaveRecall."Leave Application");
            if HRLeaveApplication.FindFirst() then begin
                "Reliever Employee No" := HRLeaveApplication."Duties Taken Over By";
                "Approver Employee No" := '';
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Document No.", LeaveRecall."Leave Application");
                ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
                if ApprovalEntry.FindLast() then
                    "Approver Employee No" := ApprovalEntry."Approver Employee No";

                Subject := 'Leave ' + LeaveRecall."Leave Application" + ' Recall';

                if "Approver Employee No" <> '' then begin
                    Employee.Reset();
                    Employee.SetRange("No.", "Approver Employee No");
                    if Employee.FindFirst() then
                        ApproverEmail := Employee."Company E-Mail";
                end;
                if "Reliever Employee No" <> '' then begin
                    Employee.Reset();
                    Employee.SetRange("No.", "Reliever Employee No");
                    if Employee.FindFirst() then
                        RelieverEmail := Employee."Company E-Mail";
                end;

                Body := 'You are hereby recalled from your leave ' + LeaveRecall."Leave Application" + ' for the following reason; <p>' + LeaveRecall."Reason for Recall" + '.</p>';
                Employee.Reset();
                Employee.SetRange("No.", HRLeaveApplication."Employee No");
                Employee.SetFilter("Company E-Mail", '<>%1', '');
                if Employee.FindFirst() then begin
                    EmailReceiverName := Employee.FullName;
                    EmailMessage.Create(Employee."Company E-Mail", Subject, '', true);

                    HrSetup.Get();
                    if (HrSetup."HR Department Email" <> '') then
                        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(HrSetup."HR Department Email", '<>'));
                    if (ApproverEmail <> '') then
                        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(ApproverEmail, '<>'));
                    if (RelieverEmail <> '') then
                        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(RelieverEmail, '<>'));

                    EmailMessage.AppendToBody('Dear' + ' ' + EmailReceiverName + ',');
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody(Body);
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody('<table border="1"><tr><td>Staff Name</td><td>' + HRLeaveApplication."Employee Name" + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Employee Code</td><td> ' + HRLeaveApplication."Employee No" + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td colspan="2"><center><strong>Original Leave Details</strong></center></td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Leave No.</td><td> ' + HRLeaveApplication."Application No" + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Leave Type</td><td> ' + HRLeaveApplication."Leave Type" + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Days Approved</td><td> ' + Format(HRLeaveApplication."Approved Days") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>From</td><td> ' + Format(HRLeaveApplication."Start Date") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>To</td><td> ' + Format(HRLeaveApplication."End Date") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Resumption Date</td><td> ' + Format(HRLeaveApplication."Resumption Date") + '</td></tr>');

                    EmailMessage.AppendToBody('<tr><td colspan="2"><center><strong>Leave Recall Details</strong></center></td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Recall No.</td><td> ' + LeaveRecallNo + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>No. of Recalled Days</td><td> ' + Format(LeaveRecall."No. of Off Days") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Recalled From</td><td> ' + Format(LeaveRecall."Recalled From") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>To</td><td> ' + Format(LeaveRecall."Recalled To") + '</td></tr>');
                    EmailMessage.AppendToBody('<tr><td>Remaining Leave Days</td><td> ' + Format(HRLeaveApplication."Approved Days" - LeaveRecall."No. of Off Days") + '</td></tr>');
                    HRLeaveApplication.CalcFields("Leave balance");
                    EmailMessage.AppendToBody('<tr><td>Current Balance:</td><td> ' + Format(HRLeaveApplication.GetLeaveTypeBalance()/*"Leave balance"*/) + '</td></tr>');
                end;
                EmailMessage.AppendToBody('</table>');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('Leave Approval Workflow History.');
                EmailMessage.AppendToBody('<table border="0.1"><tr><td>Sequence:</td><td>Approver</td><td>Status</td><td>Comment(s)</td></tr>');
                ApprovalEntry2.Reset;
                ApprovalEntry2.SetRange("Document No.", HRLeaveApplication."Application No");
                if ApprovalEntry2.FindFirst then
                    repeat
                        EmailMessage.AppendToBody('<tr><td>' + Format(ApprovalEntry2."Sequence No.") + '</td><td> ' + ApprovalEntry2."Approver Name" + '</td><td> ' + Format(ApprovalEntry2.Status) + '</td><td> ' + Format(ApprovalEntry2."Approval Comments") + '</td></tr>');
                    until ApprovalEntry2.Next = 0;
                EmailMessage.AppendToBody('</table>');
                EmailMessage.AppendToBody('<br><br>');
                EmailMessage.AppendToBody('<a href="https://ess.rwandair.com/" target="_blank">Click https://ess.rwandair.com/ </a> to access ESS portal.');
                EmailMessage.AppendToBody('<p><strong>Note:</strong> This is a system generated email. Please do not reply.</p>');
                //SMTPMail.Send;
                if not Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then
                    Ok := false
                else
                    Ok := true;
            end;
        end;
    end;

    procedure FnUpdateUserSetupRelieverDetails(LeaveUserID: Code[100]; DelegateStartDate: Date; DelegateEndDate: Date; RelieverID: Code[100])
    var
        usersetuprec: Record "User Setup";
    begin
        //UserSetupDelegationUpdate
        usersetuprec.Reset;
        usersetuprec.SetRange("User ID", LeaveUserID);
        if usersetuprec.FindFirst then begin
            usersetuprec."Delegation Start" := DelegateStartDate;
            usersetuprec."Delegation End" := DelegateEndDate;
            usersetuprec."Leave Reliever Code" := RelieverID;
            usersetuprec.Delegate := true;
            usersetuprec.Modify;

        end;
    end;

    procedure FormatDateDifferenceActual(StartDate: Date; EndDate: Date; RemoveExtraDays: Boolean): Text
    var
        TempDate: Date;
        Years: Integer;
        Months: Integer;
        Days: Integer;
    begin
        if EndDate < StartDate then
            exit('Invalid date range');

        TempDate := StartDate;

        // Count years
        while CalcDate('<1Y>', TempDate) <= EndDate do begin
            TempDate := CalcDate('<1Y>', TempDate);
            Years += 1;
        end;

        // Count months
        while CalcDate('<1M>', TempDate) <= EndDate do begin
            TempDate := CalcDate('<1M>', TempDate);
            Months += 1;
        end;

        // Remaining days
        Days := EndDate - TempDate;

        // Build the output string
        if Years > 0 then begin
            if RemoveExtraDays and (Days < 10) then
                exit(StrSubstNo('%1 year(s) %2 month(s)', Years, Months))
            else
                exit(StrSubstNo('%1 year(s) %2 month(s) %3 day(s)', Years, Months, Days));
        end else if Months > 0 then begin
            if RemoveExtraDays and (Days < 10) then begin
                if (Months >= 12) and (Months mod 12 = 0) then
                    exit(StrSubstNo('%1 year(s)', Months div 12))
                else
                    exit(StrSubstNo('%1 month(s)', Months));
            end else
                exit(StrSubstNo('%1 month(s) %2 day(s)', Months, Days));
        end else
            exit(StrSubstNo('%1 day(s)', Days));
    end;

    procedure InitializeAirtimeManagement()
    var
        HumanResSetup: Record "Human Resources Setup";
        JobQueueEntry: Record "Job Queue Entry";
        AirtimeMgmtFunctions: Codeunit "Airtime Management Functions";
    begin
        Window.Open('Creating no. series: #1#####\\Creating job queue: #2####');
        Window.Update(1, 'AIRTREC00001');
        if HumanResSetup.Get and (HumanResSetup."Airtime Request Nos" = '') then begin
            HumanResSetup."Airtime Request Nos" := 'AIRTREQ';
            if BaseFactory.CreateNoSeries('', HumanResSetup."Airtime Request Nos", 'Airtime request numbers', 'AIRTREQ00001') then begin
                HumanResSetup.Modify();
            end;
        end;

        Window.Update(2, 'Airtime allocation');
        JobQueueEntry.Reset();
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Airtime Management Functions");
        if not JobQueueEntry.FindFirst() then begin
            JobQueueEntry.Init();
            JobQueueEntry.InitRecurringJob(0);
            JobQueueEntry.Validate("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
            JobQueueEntry.Validate("Object ID to Run", Codeunit::"Airtime Management Functions");
            JobQueueEntry.ID := CreateGuid();
            JobQueueEntry."Earliest Start Date/Time" := CreateDateTime(CalcDate('1D', Today), 010000T);
            JobQueueEntry."Starting Time" := 010000T;
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry."Run in User Session" := false;
            JobQueueEntry."Notify On Success" := false;
            JobQueueEntry."Maximum No. of Attempts to Run" := 5;
            JobQueueEntry.Status := JobQueueEntry.Status::Ready;
            JobQueueEntry."Rerun Delay (sec.)" := 30;
            JobQueueEntry."Job Timeout" := JobQueueEntry.DefaultJobTimeout();
            JobQueueEntry.Description := 'Airtime Allocation';
            JobQueueEntry.Insert();
            ReScheduleJob(JobQueueEntry, '');
            if not JobQueueEntry.Modify() then
                JobQueueEntry.Insert();
        end;
        Window.Close();
        Message('Airtime management initialized successfully!');
    end;

    procedure ReScheduleJob(var vJobQueueEntry: Record "Job Queue Entry"; vCompanyName: Text)
    begin
        vJobQueueEntry.Status := vJobQueueEntry.Status::Ready;
        vJobQueueEntry."System Task ID" := TASKSCHEDULER.CreateTask(
          CODEUNIT::"Job Queue Dispatcher",
          CODEUNIT::"Job Queue Error Handler",
          true, vCompanyName, vJobQueueEntry."Earliest Start Date/Time", vJobQueueEntry.RecordId(), vJobQueueEntry."Job Timeout");
    end;


    procedure InitializeHotelManagement()
    var
        HumanResSetup: Record "Human Resources Setup";
        JobQueueEntry: Record "Job Queue Entry";
    begin
        Window.Open('Creating no. series: #1#####');
        Window.Update(1, 'HOTREQ');
        if HumanResSetup.Get and (HumanResSetup."Hotel Request Nos" = '') then begin
            HumanResSetup."Hotel Request Nos" := 'HOTREQ';
            if BaseFactory.CreateNoSeries('', HumanResSetup."Hotel Request Nos", 'Hotel request numbers', 'HOTTREQ00001') then begin
                HumanResSetup.Modify();
            end;
        end;

        Window.Close();
        Message('Hotel management initialized successfully!');
    end;

    var
        Window: Dialog;
        BaseFactory: Codeunit Factory;

}
