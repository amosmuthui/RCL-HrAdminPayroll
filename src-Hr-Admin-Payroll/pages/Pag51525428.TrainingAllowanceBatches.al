page 51525428 "Training Allowance Batches"
{
    ApplicationArea = All;
    Caption = 'Training Allowance Batches';
    PageType = List;
    SourceTable = "Training Allowance Batches";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting("Payroll Period") order(descending);
    PromotedActionCategories = 'New,Process,Report,Approval Request';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field("Batch Name"; Rec."Batch Name")
                {
                    ToolTip = 'Specifies the value of the Batch Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Classes/Instructors"; Rec."Classes/Instructors")
                {
                    ToolTip = 'Specifies the value of the Classes/Instructors field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                { }
                field("Amendment Instructions"; Rec."Amendment Instructions")
                {
                    MultiLine = true;
                }
                field("Previous Amendments"; Rec."Previous Amendments")
                {
                    MultiLine = true;
                }
                field("Submitted On"; Rec."Submitted On")
                { }
                field("Submitted By"; Rec."Submitted By")
                { }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            action("Create New")
            {
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    createNewBatch(true);
                end;
            }
            action("Refresh Records")
            {
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Batch);
                    if Batch.Find('-') then begin
                        if (Batch.Status <> Batch.Status::Open) and (Batch.Status <> Batch.Status::"Pending Amendment") then
                            Error('This operation is only allowed if status is open or pending ammendment!');
                        if not confirm('Do you want to refresh the instructor allowance records to pick latest changes from class records?') then
                            Error('Process aborted successfully!');
                        refreshEntries(Batch."Payroll Period", true);
                        Message('Records updated successfully!');
                        //CurrPage.close();
                    end else
                        Error('Nothing was selected!');
                end;
            }
            action("Send to Payroll")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AlreadyProcessed: Boolean;
                begin
                    AlreadyProcessed := false;
                    CurrPage.SetSelectionFilter(Batch);
                    if Batch.Find('-') then begin
                        if (Batch.Status <> Batch.Status::Open) and (Batch.Status <> Batch.Status::"Pending Amendment") and (Batch.Status <> Batch.Status::Processed) then
                            Error('This operation is only allowed if status is open or pending ammendment!');
                        if (Batch.Status = Batch.Status::Processed) then begin
                            AlreadyProcessed := true;
                            if ((Batch."Approval Status" = Batch."Approval Status"::Open) or (Batch."Approval Status" = Batch."Approval Status"::Rejected)) then begin
                                if confirm('The batch has already been processed, do you wish to resubmit it for processing?') then
                                    AlreadyProcessed := false;
                            end;
                        end;
                        if AlreadyProcessed then Error('Batch already processed!');
                        if not confirm('Do you want to send batch ' + Batch."Batch Name" + ' to payroll for processing?') then
                            Error('Process aborted successfully!');

                        sendToPayroll(Batch."Payroll Period");

                        HrSetup.Get();
                        if HrSetup."Payroll Administrator Email" <> '' then begin
                            BodyText := 'Dear Payroll team,<br>';
                            BodyText += 'The training section has just submitted the ' + Batch."Batch Name" + ' in-house instructor allowances for your processing. Kindly login to the ERP and look into it.<br> Kind Regards.<br>';
                            SendEmailNotification('In-house Instructor Allowance Processing - ' + Batch."Batch Name", BodyText, HrSetup."Payroll Administrator Email");
                        end;

                        Message('Batch sent successfully!');
                        //CurrPage.close(); //then reopen it
                        //Page.Run(Page::"Training Allowance Batches");

                    end else
                        Error('Nothing was selected!');
                end;
            }
            action("Decline with comments")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Batch);
                    if Batch.Find('-') then begin
                        if (Batch.Status <> Batch.Status::"Sent to Payroll") then
                            Error('This operation is only allowed if status is Sent to Payroll!');
                        if not confirm('Do you want to send batch ' + Batch."Batch Name" + ' back to training for amendments?') then
                            Error('Process aborted successfully!');
                        if Batch."Amendment Instructions" = '' then
                            Error('Kindly provide the amendment instructions in the provided field before proceeding!');

                        if Batch."Submitted By" <> '' then begin
                            Emp.Reset();
                            Emp.SetRange("User ID", Batch."Submitted By");
                            Emp.SetFilter("Company E-Mail", '<>%1', '');
                            if Emp.FindFirst() then begin
                                BodyText := 'Dear ' + Emp."First Name" + '<br>';
                                BodyText += 'The payroll team has returned the ' + Batch."Batch Name" + ' in-house instructor allowances to you for amendment. Kindly login to the ERP and look into these amendments then resend to payroll.<br>';
                                BodyText += '<strong>Amendment Instructions</strong><p>' + Batch."Amendment Instructions" + '</p>';
                                BodyText += 'Kind Regards.<br>';
                                SendEmailNotification('In-house Instructor Allowance amendments - ' + Batch."Batch Name", BodyText, Emp."Company E-Mail");
                            end;
                        end;
                        Batch.Status := Batch.Status::"Pending Amendment";
                        Batch.Modify();
                        Message('Amendments sent successfully!');
                        //CurrPage.close(); //then reopen it
                        //Page.Run(Page::"Training Allowance Batches");
                    end else
                        Error('Nothing was selected!');
                end;
            }
            action("Add to Payroll")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SetSelectionFilter(Batch);
                    if Batch.Find('-') then begin
                        if (Batch.Status <> Batch.Status::"Sent to Payroll") then
                            Error('This operation is only allowed if status is Sent to Payroll!');
                        if not confirm('Do you want to add ' + Batch."Batch Name" + ' batch to payroll, thereby assigning all instructors the applicable allowance?') then
                            Error('Process aborted successfully!');

                        PayrollPeriod.Reset();
                        PayrollPeriod.SetRange(Closed, false);
                        PayrollPeriod.SetRange("Starting Date", Batch."Payroll Period");
                        if not PayrollPeriod.FindFirst() then
                            Error('It appears the selected period %1 has already been closed!', Batch."Payroll Period");

                        addToPayroll(Batch."Payroll Period");

                        Message('Added successfully! All instructors added to payroll ');
                        //CurrPage.close();
                    end else
                        Error('Nothing was selected!');
                end;
            }

            action("Generate Report")
            {
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    InAllowanceReport: Report "Instructor Allowance";
                begin
                    CurrPage.SetSelectionFilter(Batch);
                    if Batch.Find('-') then begin
                        Commit();
                        InAllowanceReport.SetParameters(Batch."Payroll Period", 'RWF', 1); //By default, generate before processing
                        InAllowanceReport.Run();
                        //Report.Run(Report::"Instructor Allowance", true, false, Batch);
                    end else
                        Error('Nothing was selected!');
                end;
            }

            action("Send Approval Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                //PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Processed then
                        Error('The batch has not been processsed!');

                    VarVariant := Rec;

                    if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
                        Error('Approval Status has to be open');
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                //PromotedIsBig = true;

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
                Promoted = true;
                PromotedCategory = Category4;
                //PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
                end;
            }
        }
    }

    var
        Batches: Record "Training Allowance Batches";
        Batch: Record "Training Allowance Batches";
        BatchInit: Record "Training Allowance Batches";
        BatcheEntries: Record "Training Allowance Entries";
        BatcheEntriesInit: Record "Training Allowance Entries";
        Emp: Record Employee;
        Classes: Record "Training Schedules";
        LastMonth: Date;
        StartDate: Date;
        EndDate: Date;
        EntryNo: Integer;
        PayrollPeriod: Record "Payroll Period";
        HrSetup: Record "Human Resources Setup";
        BodyText: Text;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
        VarVariant: Variant;

    procedure createNewBatch(showMessages: Boolean)
    begin
        PayrollPeriod.Reset();
        PayrollPeriod.SetRange(Closed, false);
        if PayrollPeriod.FindFirst() then begin
            Batches.Reset();
            Batches.SetRange("Payroll Period", PayrollPeriod."Starting Date");
            if Batches.FindFirst() then begin
                refreshEntries(Batches."Payroll Period", true);
                if showMessages then
                    Message('Batch for current payroll period already exists. We''ve just refreshed records.');
            end else begin
                LastMonth := CalcDate('-1M', PayrollPeriod."Starting Date");
                BatchInit.Init();
                BatchInit."Payroll Period" := PayrollPeriod."Starting Date";
                BatchInit."Batch Name" := Format(PayrollPeriod."Starting Date", 0, '<Month Text> <Year4>');
                BatchInit.Description := Format(LastMonth, 0, '<Month Text> <Year4>') + ' instructor allowances processed in ' + Format(PayrollPeriod."Starting Date", 0, '<Month Text> <Year4>');
                BatchInit.Insert();

                refreshEntries(PayrollPeriod."Starting Date", showMessages);
                if showMessages then
                    Message('Batch created successfully. All instructor allowances have been added to the batch.')
            end;
        end;
    end;

    procedure refreshEntries(batchDate: Date; showMessages: Boolean)
    var
        AdditionalInstructors: Record "Additional Instructors";
    begin
        if batchDate = 0D then
            Error('Batch payroll date not set!');
        LastMonth := CalcDate('-1M', batchDate);
        StartDate := CalcDate('-CM', LastMonth);
        EndDate := CalcDate('<CM>', LastMonth);

        Classes.Reset();
        Classes.SetRange("Trainer Category", Classes."Trainer Category"::Internal);
        Classes.SetRange(Status, Classes.Status::Done);
        Classes.SetFilter("Start Date", '%1..%2', StartDate, EndDate);
        Classes.SetFilter("Trainer No.", '<>%1', '');
        Classes.SetFilter("Instructor Allowance", '<>%1', 0);
        if Classes.FindSet() then begin
            BatcheEntries.Reset();
            BatcheEntries.SetCurrentKey("Entry No.");
            BatcheEntries.SetAscending("Entry No.", true);
            if BatcheEntries.FindLast() then
                EntryNo := BatcheEntries."Entry No.";

            repeat
                BatcheEntries.Reset();
                BatcheEntries.SetRange("Payroll Period", batchDate);
                BatcheEntries.SetRange("Class No.", Classes."No.");
                BatcheEntries.SetRange("Instructor No.", Classes."Trainer No.");
                if BatcheEntries.FindFirst() then begin
                    BatcheEntries."Instructor No." := Classes."Trainer No.";
                    BatcheEntries."Instructor Name" := Classes."Trainer Name";
                    BatcheEntries.Allowance := Classes."Instructor Allowance";
                    BatcheEntries.Modify();
                end else begin
                    EntryNo += 1;
                    BatcheEntriesInit.Init();
                    BatcheEntriesInit."Entry No." := EntryNo;
                    BatcheEntriesInit."Payroll Period" := batchDate;
                    BatcheEntriesInit."Class No." := Classes."No.";
                    BatcheEntriesInit."Instructor No." := Classes."Trainer No.";
                    BatcheEntriesInit."Instructor Name" := Classes."Trainer Name";
                    BatcheEntriesInit.Allowance := Classes."Instructor Allowance";
                    BatcheEntriesInit.Insert();
                end;

                //Additional
                AdditionalInstructors.Reset();
                AdditionalInstructors.SetRange("Class No.", Classes."No.");
                AdditionalInstructors.SetRange(Category, AdditionalInstructors.Category::Internal);
                AdditionalInstructors.SetFilter("No.", '<>%1', '');
                AdditionalInstructors.SetFilter(Allowance, '<>%1', 0);
                if AdditionalInstructors.FindSet() then
                    repeat
                        BatcheEntries.Reset();
                        BatcheEntries.SetRange("Payroll Period", batchDate);
                        BatcheEntries.SetRange("Class No.", Classes."No.");
                        BatcheEntries.SetRange("Instructor No.", AdditionalInstructors."No.");
                        if BatcheEntries.FindFirst() then begin
                            BatcheEntries.Allowance := AdditionalInstructors.Allowance;
                            BatcheEntries.Modify();
                        end else begin
                            EntryNo += 1;
                            BatcheEntriesInit.Init();
                            BatcheEntriesInit."Entry No." := EntryNo;
                            BatcheEntriesInit."Payroll Period" := batchDate;
                            BatcheEntriesInit."Class No." := Classes."No.";
                            BatcheEntriesInit."Instructor No." := AdditionalInstructors."No.";
                            BatcheEntriesInit."Instructor Name" := AdditionalInstructors.Name;
                            BatcheEntriesInit.Allowance := AdditionalInstructors.Allowance;
                            BatcheEntriesInit.Insert();
                        end;
                    until AdditionalInstructors.Next() = 0;
            until Classes.Next() = 0;
        end else
            if showMessages then
                Error('There are no classes with status Done, trainer category Internal, Trainer No. not blank, instructor allowance not 0, and schedule date between %1 and %2', Format(StartDate, 0, '<Day,2> <Month Text> <Year4>'), Format(EndDate, 0, '<Day,2> <Month Text> <Year4>'));
    end;

    procedure sendToPayroll(batchDate: Date)
    var
        AssignmentMatrix: Record "Assignment Matrix";
    begin
        Batches.Reset();
        Batches.SetRange("Payroll Period", batchDate);
        if Batches.FindFirst() then begin
            Batches.CalcFields("Classes/Instructors");
            if Batches."Classes/Instructors" = 0 then
                Error('This batch has no instructors. Ensure you have updated all classes with instructors and instructor allowances.');
            if Batches."Amendment Instructions" <> '' then begin
                if Batches."Previous Amendments" = '' then
                    Batches."Previous Amendments" := Batches."Amendment Instructions"
                else
                    Batches."Previous Amendments" := ' <===> ' + Batches."Amendment Instructions";
                Batches."Amendment Instructions" := '';
            end;
            Batches.Status := Batches.Status::"Sent to Payroll";
            Batches."Submitted By" := UserId;
            Batches."Submitted On" := CurrentDateTime;
            Batches.Modify();

            AssignmentMatrix.Reset();
            AssignmentMatrix.SetRange("Payroll Period", Batches."Payroll Period");
            AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
            AssignmentMatrix.SetRange("Transaction Title", 'IN-HOUSE INSTRUCTOR ALLOWANCE');
            AssignmentMatrix.ModifyAll("Inhouse Allowance Processed", false);
        end;
    end;

    procedure addToPayroll(batchDate: Date)
    var
        AssignmentMatrix: Record "Assignment Matrix";
        AssignmentMatrixInit: Record "Assignment Matrix";
        Movement: Record "Internal Employement History";
        InstructorAllowanceEarning: Record Earnings;
        WinDialog: Dialog;
    begin
        WinDialog.Open('Adding in-house instructor allowance for #1#############');
        Batches.Reset();
        Batches.SetRange("Payroll Period", batchDate);
        if Batches.FindFirst() then begin
            //Delete all existing assignment entries first
            AssignmentMatrix.Reset();
            AssignmentMatrix.SetRange("Payroll Period", Batches."Payroll Period");
            AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
            AssignmentMatrix.SetRange("Transaction Title", 'IN-HOUSE INSTRUCTOR ALLOWANCE');
            AssignmentMatrix.DeleteAll();

            BatcheEntries.Reset();
            BatcheEntries.SetRange("Payroll Period", batchDate);
            if BatcheEntries.FindSet() then
                repeat
                    Emp.Reset();
                    Emp.SetRange("No.", BatcheEntries."Instructor No.");
                    if Emp.FindFirst() then begin
                        WinDialog.Update(1, Emp."No." + ' - ' + Emp.FullName());
                        /*if Emp.Status <> Emp.Status::Active then begin
                            if Confirm('Instructor ' + BatcheEntries."Instructor Name" + ' is Inactive. We cannot assign them the instructor allowance now. It can be added alongside final dues later.\Do you wish to pause this process and activate them before proceeding?') then
                                Error('Process aborted successfully. Ensure all the instructors are active if you wish to process their allowances now.');
                            //If you want them to remain inactive
                            BatcheEntries.Processed := false;
                            BatcheEntries."Processing Comments" := 'Instructor staff status is Inactive. Claim this allowance later during final dues processing';
                        end;*/
                        BatcheEntries.Processed := true;
                        BatcheEntries."Processing Comments" := '';

                        //Get their current movement
                        Movement.Reset();
                        Movement.SetRange("Emp No.", Emp."No.");
                        Movement.SetRange(Status, Movement.Status::Current);
                        if not Movement.FindFirst() then
                            Error('Instructor ' + BatcheEntries."Instructor Name" + ' does not have a current movement status. Set it before proceeding!')
                        else begin
                            InstructorAllowanceEarning.Reset();
                            InstructorAllowanceEarning.SetRange(Country, Movement."Payroll Country");
                            InstructorAllowanceEarning.SetRange("Universal Title", 'IN-HOUSE INSTRUCTOR ALLOWANCE');
                            if not InstructorAllowanceEarning.FindFirst() then
                                Error('There is no allowance with the title "IN-HOUSE INSTRUCTOR ALLOWANCE for payroll country %1. You must create one.', Movement."Payroll Country")
                            else begin
                                AssignmentMatrix.Reset();
                                AssignmentMatrix.SetRange("Payroll Period", Batches."Payroll Period");
                                AssignmentMatrix.SetRange("Employee No", Emp."No.");
                                AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Payment);
                                AssignmentMatrix.SetRange(Country, Movement."Payroll Country");
                                AssignmentMatrix.SetRange(Code, InstructorAllowanceEarning.Code);
                                if AssignmentMatrix.FindFirst() then begin
                                    AssignmentMatrix."Amount Type" := AssignmentMatrix."Amount Type"::Net;
                                    AssignmentMatrix."Amount In FCY" := BatcheEntries.Allowance;
                                    AssignmentMatrix."Exclude from Payroll" := true;
                                    AssignmentMatrix."Inhouse instructor Allowance" := true;
                                    AssignmentMatrix."Net Amount" := AssignmentMatrix."Net Amount" + BatcheEntries.Allowance;
                                    AssignmentMatrix.Amount := AssignmentMatrix.Amount + BatcheEntries.Allowance;
                                    AssignmentMatrix.Modify();
                                end else begin
                                    AssignmentMatrixInit.Init();
                                    AssignmentMatrixInit.Type := AssignmentMatrixInit.Type::Payment;
                                    AssignmentMatrixInit."Payroll Period" := Batches."Payroll Period";
                                    AssignmentMatrixInit."Employee No" := Emp."No.";
                                    AssignmentMatrixInit.Code := InstructorAllowanceEarning.Code;
                                    AssignmentMatrixInit.Description := InstructorAllowanceEarning.Description;
                                    AssignmentMatrixInit."Country Currency" := Movement."Payroll Currency";
                                    AssignmentMatrixInit."Earning Currency" := 'RWF';
                                    AssignmentMatrixInit.Country := Movement."Payroll Country";
                                    AssignmentMatrixInit."Net Amount" := BatcheEntries.Allowance;
                                    AssignmentMatrixInit.Amount := BatcheEntries.Allowance;
                                    AssignmentMatrixInit."Amount Type" := AssignmentMatrix."Amount Type"::Net;
                                    AssignmentMatrixInit."Amount In FCY" := BatcheEntries.Allowance;
                                    AssignmentMatrixInit.Validate("Employee No");
                                    AssignmentMatrixInit.Validate(Code);
                                    AssignmentMatrixInit.Validate(Amount);
                                    AssignmentMatrixInit."Exclude from Payroll" := true;
                                    AssignmentMatrixInit."Inhouse instructor Allowance" := true;
                                    AssignmentMatrixInit."Allow temp staff activation" := true;
                                    AssignmentMatrixInit.Insert();
                                end;
                            end;
                        end;
                    end;
                    BatcheEntries.Modify();
                until BatcheEntries.Next() = 0;
            Batches.Status := Batches.Status::Processing;
            Batches.Modify();

            if Batches."Submitted By" <> '' then begin
                Emp.Reset();
                Emp.SetRange("User ID", Batches."Submitted By");
                Emp.SetFilter("Company E-Mail", '<>%1', '');
                if Emp.FindFirst() then begin
                    BodyText := 'Dear ' + Emp."First Name" + '<br>';
                    BodyText += 'The payroll team has started processing the ' + Batches."Batch Name" + ' in-house instructor allowances batch that you submitted.<br>';
                    BodyText += 'You will get another notification when the entire batch is processed.</p>';
                    BodyText += 'Kind Regards.<br>';
                    SendEmailNotification('In-house Instructor Allowance Processed - ' + Batches."Batch Name", BodyText, Emp."Company E-Mail");
                end;
            end;
        end;
        WinDialog.Close();
    end;

    procedure notifySenderBatchProcessed(batchDate: Date)
    var
        WinDialog: Dialog;
    begin
        WinDialog.Open('Notifying in-house instructor allowance sender #1#############');
        Batches.Reset();
        Batches.SetRange("Payroll Period", batchDate);
        if Batches.FindFirst() then begin
            if Batches."Submitted By" <> '' then begin
                Emp.Reset();
                Emp.SetRange("User ID", Batches."Submitted By");
                Emp.SetFilter("Company E-Mail", '<>%1', '');
                if Emp.FindFirst() then begin
                    WinDialog.Update(1, Emp."No." + ' - ' + Emp.FullName());
                    BodyText := 'Dear ' + Emp."First Name" + '<br>';
                    BodyText += 'The payroll team has processed the ' + Batches."Batch Name" + ' in-house instructor allowances batch that you submitted.<br>';
                    BodyText += 'You can now generate the In-house Instructor allowance report "After Payroll Processing", verify, then send for approval.</p>';
                    BodyText += 'Kind Regards.<br>';
                    SendEmailNotification('In-house Instructor Allowance Processed - ' + Batches."Batch Name", BodyText, Emp."Company E-Mail");
                end;
            end;
            WinDialog.Close();
            Batches.Status := Batches.Status::Processed;
            Batches.Modify();
        end;
    end;

    procedure SendEmailNotification(Subject: Text[250]; Body: Text; RecipientEmail: Text[150])
    var
        BodyText: Text[250];
        EmpRec: Record Employee;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
    begin
        EmailMessage.Create(RecipientEmail, Subject, Body, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}