codeunit 51525307 "Custom Approvals Mgmt HR"
{
    trigger OnRun()
    begin
        AddWorkflowEventsToLibrary();
    end;


    var
        WorkflowManagement: Codeunit "Workflow Management";
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        NoWorkflowEnabledErr: Label 'This record is not supported by related approval workflow.';
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        "--EMPLOYEE TRAINING----": Label '**************';
        OnSendEmployeeTrainingApprovalRequestTxt: Label 'Approval of a Employee Training is requested';
        RunWorkflowOnSendEmployeeTrainingForApprovalCode: Label 'RUNWORKFLOWONSENDEMPLOYEETRAININGFORAPPROVAL';
        OnCancelEmployeeTrainingApprovalRequestTxt: Label 'An Approval of a Employee Trainings is canceled';
        RunWorkflowOnCancelEmployeeTrainingForApprovalCode: Label 'RUNWORKFLOWONCANCELEMPLOYEETRAININGSFORAPPROVAL';
        "--TRAINING NEEDS----": Label '**************';
        OnSendTrainingNeedsApprovalRequestTxt: Label 'Approval of a Training Needs is requested';
        RunWorkflowOnSendTrainingNeedsForApprovalCode: Label 'RUNWORKFLOWONSENDTRAININGNEEDSFORAPPROVAL';
        OnCancelTrainingNeedsApprovalRequestTxt: Label 'An Approval of a Training Needs is canceled';
        RunWorkflowOnCancelTrainingNeedsForApprovalCode: Label 'RUNWORKFLOWONCANCELTRAININGNEEDSFORAPPROVAL';
        "--JOB APPLICATION----": Label '**************';
        OnSendJobApplicationsApprovalRequestTxt: Label 'Approval of a Job Application is requested';
        RunWorkflowOnSendJobApplicationsForApprovalCode: Label 'RUNWORKFLOWONSENDJOBAPPLICATIONSFORAPPROVAL';
        OnCancelJobApplicationsApprovalRequestTxt: Label 'An Approval of a Job Application is canceled';
        RunWorkflowOnCancelJobApplicationsForApprovalCode: Label 'RUNWORKFLOWONCANCELJOBAPPLICATIONSFORAPPROVAL';
        "--Leave Application----": Label '**************';
        OnSendLeavesApplicationApprovalRequestTxt: Label 'Approval of a Leaves Application is requested';
        RunWorkflowOnSendLeavesApplicationForApprovalCode: Label 'RUNWORKFLOWONSENDLEAVESAPPLICATIONFORAPPROVAL';
        OnCancelLeaveApplicationApprovalRequestTxt: Label 'An Approval of a Leaves Application is canceled';
        RunWorkflowOnCancelLeaveApplicationForApprovalCode: Label 'RUNWORKFLOWONCANCELLEAVEAPPLICATIONFORAPPROVAL';
        LeaveRec: Page "Leave Application HR";
        Leave: Record "Employee Leave Application";

        PayrollProcessingHeader: Record "Payroll Processing Header";
        "--Pay Processing Header Header--": Label '**************';
        OnSendPayrollApprovalRequestTxt: Label 'An approval of a payroll processing header is requested';
        RunWorkflowSendPayrollApprovalCode: Label 'RUNWORKFLOWONSENDPAYROLLHEADERFORAPPROVAL';
        RunWorkflowSendRecruitmentDocApprovalCode: Label 'RUNWORKFLOWONSENDRECRUITMENTDOCFORAPPROVAL';

        OnCancelPayrollApprovalRequestTxt: Label 'An approval of a payroll processing header is canceled';
        RunWorkflowOnCancelPayrollApprovalCode: Label 'RUNWORKFLOWONCANCELPAYROLLPROCESSINGHEADERAPPROVAL';

        "--Terminal Dues--": Label '**************';
        OnSendTerminalDuesApprovalRequestTxt: Label 'Approval of final dues is requested';
        RunWorkflowOnSendTerminalDuesForApprovalCode: Label 'RUNWORKFLOWONSENDTERMINALDUESFORAPPROVAL';
        OnCancelTerminalDuesApprovalRequestTxt: Label 'An approval of final dues is canceled';
        RunWorkflowOnCancelTerminalDuesApprovalCode: Label 'RUNWORKFLOWONCANCELTERMINALDUESAPPROVAL';
        TerminalDues: Record "Terminal Dues Header";

        "--Employee Changes--": Label '**************';
        OnSendEmployeeChangesApprovalRequestTxt: Label 'Approval of Employee Changes is requested';
        RunWorkflowOnSendEmployeeChangesApprovalCode: Label 'RUNWORKFLOWONSENDEMPLOYEECHANGESAPPROVAL';
        OnCancelEmployeeChangesApprovalRequestTxt: Label 'An approval of Employee Changes is canceled';
        RunWorkflowOnCancelEmployeeChangesApprovalCode: Label 'RUNWORKFLOWONCANCELEMPLOYEECHANGESAPPROVAL';
        EmployeeChanges: Record "Change Request";


        "--Training Allowance Batches-": Label '**************';
        OnSendTrainingAllowanceApprovalRequestTxt: Label 'Approval of Training allowance is requested';
        RunWorkflowOnSendTrainingAllowanceApprovalCode: Label 'RUNWORKFLOWONSENDTRAININGALLOWANCEAPPROVAL';
        OnCancelTrainingAllowanceApprovalRequestTxt: Label 'An approval of Training allowance is canceled';
        RunWorkflowOnCancelTrainingAllowanceApprovalCode: Label 'RUNWORKFLOWONCANCELTRAININGALLOWANCEAPPROVAL';
        TrainingAllowanceBatch: Record "Training Allowance Batches";

        "--Airtime Allocation batch--": Label '**************';
        OnSendAirtimeAllocationBatchApprovalRequestTxt: Label 'Approval of an Airtime Allocation Batch is requested';
        RunWorkflowOnSendAirtimeAllocationBatchApprovalCode: Label 'RUNWORKFLOWONSENDAIRTIMEALLOCATIONBATCHAPPROVAL';
        OnCancelAirtimeAllocationBatchApprovalRequestTxt: Label 'An approval of an Airtime Allocation Batch is canceled';
        RunWorkflowOnCancelAirtimeAllocationBatchApprovalCode: Label 'RUNWORKFLOWONCANCELAIRTIMEALLOCATIONBATCHAPPROVAL';
        AirtimeAllocationBatch: Record "Airtime Allocation Batches";


        "--Airtime Requests--": Label '**************';
        OnSendAirtimeRequestApprovalRequestTxt: Label 'Approval of an Airtime Request is requested';
        RunWorkflowOnSendAirtimeRequestApprovalCode: Label 'RUNWORKFLOWONSENDAIRTIMEREQUESTAPPROVAL';
        OnCancelAirtimeRequestApprovalRequestTxt: Label 'An approval of an Airtime Request is canceled';
        RunWorkflowOnCancelAirtimeRequestApprovalCode: Label 'RUNWORKFLOWONCANCELAIRTIMEREQUESTAPPROVAL';
        AirtimeRequest: Record "Airtime Requests";


        "--Hotel Booking Requests--": Label '**************';
        OnSendHotelBookingRequestApprovalRequestTxt: Label 'Approval of a Hotel Booking Request is requested';
        RunWorkflowOnSendHotelBookingRequestApprovalCode: Label 'RUNWORKFLOWONSENDHOTELBOOKINGREQUESTAPPROVAL';
        OnCancelHotelBookingRequestApprovalRequestTxt: Label 'An approval of a Hotel Booking Request is canceled';
        RunWorkflowOnCancelHotelBookingRequestApprovalCode: Label 'RUNWORKFLOWONCANCELHOTELBOOKINGREQUESTAPPROVAL';
        HotelBookingRequest: Record "Hotel Booking Requests";

        "--Refreshment Requests--": Label '**************';
        OnSendRefreshmentRequestApprovalRequestTxt: Label 'Approval of a Refreshment Request is requested';
        RunWorkflowOnSendRefreshmentRequestApprovalCode: Label 'RUNWORKFLOWONSENDREFRESHMENTREQUESTAPPROVAL';
        OnCancelRefreshmentRequestApprovalRequestTxt: Label 'An approval of a Refreshment Request is canceled';
        RunWorkflowOnCancelRefreshmentRequestApprovalCode: Label 'RUNWORKFLOWONCANCELREFRESHMENTREQUESTAPPROVAL';
        RefreshmentRequest: Record "Refreshment Requests";

        "--Room Booking Requests--": Label '**************';
        OnSendRoomBookingRequestApprovalRequestTxt: Label 'Approval of a Room Booking Request is requested';
        RunWorkflowOnSendRoomBookingRequestApprovalCode: Label 'RUNWORKFLOWONSENDROOMBOOKINGREQUESTAPPROVAL';
        OnCancelRoomBookingRequestApprovalRequestTxt: Label 'An approval of a Room Booking Request is canceled';
        RunWorkflowOnCancelRoomBookingRequestApprovalCode: Label 'RUNWORKFLOWONCANCELROOMBOOKINGREQUESTAPPROVAL';
        RoomBooking: Record "Room Booking Requests";

        "--Requisition Fees Requests--": Label '**************';
        OnSendRequisitionFeesRequestApprovalRequestTxt: Label 'Approval of a Requisition Fees Request is requested';
        RunWorkflowOnSendRequisitionFeesRequestApprovalCode: Label 'RUNWORKFLOWONSENDREQUISITIONFEESREQUESTAPPROVAL';
        OnCancelRequisitionFeesRequestApprovalRequestTxt: Label 'An approval of a Requisition Fees Request is canceled';
        RunWorkflowOnCancelRequisitionFeesRequestApprovalCode: Label 'RUNWORKFLOWONCANCELREQUISITIONFEESREQUESTAPPROVAL';
        RequisitionFeesRequest: Record "Requisition Fees Requests";

        "--Memo Requests--": Label '**************';
        OnSendMemoRequestApprovalRequestTxt: Label 'Approval of a Memo  Request is requested';
        RunWorkflowOnSendMemoRequestApprovalCode: Label 'RUNWORKFLOWONSENDMemoREQUESTAPPROVAL';
        OnCancelMemoRequestApprovalRequestTxt: Label 'An approval of a Memo Request is canceled';
        RunWorkflowOnCancelMemoRequestApprovalCode: Label 'RUNWORKFLOWONCANCElMemoFREQUESTAPPROVAL';
        Memoequest: Record "Memo Header";

        "--Shift Requests--": Label '**************';
        OnSendShiftRequestApprovalRequestTxt: Label 'Approval of a Shift  Request is requested';
        RunWorkflowOnSendShiftRequestApprovalCode: Label 'RUNWORKFLOWONSENDShiftREQUESTAPPROVAL';
        OnCancelShiftRequestApprovalRequestTxt: Label 'An approval of a Shift Request is canceled';
        RunWorkflowOnCancelShiftRequestApprovalCode: Label 'RUNWORKFLOWONCANCElShiftFREQUESTAPPROVAL';
        ShiftRequest: Record "Shift Header";

        "--Claim Requests--": Label '**************';
        OnSendClaimRequestApprovalRequestTxt: Label 'Approval of a Claim  Request is requested';
        RunWorkflowOnSendClaimRequestApprovalCode: Label 'RUNWORKFLOWONSENDSCLAIMREQUESTAPPROVAL';
        OnCancelClaimRequestApprovalRequestTxt: Label 'An approval of a Claim Request is canceled';
        RunWorkflowOnCancelClaimRequestApprovalCode: Label 'RUNWORKFLOWONCANCElCLAIMFREQUESTAPPROVAL';
        ClaimRequest: Record "Shift Header";

        "--Travel Requests--": Label '**************';
        OnSendTravelRequestApprovalRequestTxt: Label 'Approval of a Travel  Request is requested';
        RunWorkflowOnSendTravelRequestApprovalCode: Label 'RUNWORKFLOWONSENDSTRAVELREQUESTAPPROVAL';
        OnCancelTravelRequestApprovalRequestTxt: Label 'An approval of a Travel Request is canceled';
        RunWorkflowOnCancelTravelRequestApprovalCode: Label 'RUNWORKFLOWONCANCElTRAVELFREQUESTAPPROVAL';
        TravelRequest: Record "Travelling Request";




    procedure CheckApprovalsWorkflowEnabled(var Variant: Variant): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            //Leave Application
            DATABASE::"Employee Leave Application":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendLeavesApplicationForApprovalCode));
            //Payroll Processing Header
            DATABASE::"Payroll Processing Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowSendPayrollApprovalCode));
            //Terminal Dues
            DATABASE::"Terminal Dues Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendTerminalDuesForApprovalCode));
            //Employee Changes
            DATABASE::"Change Request":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendEmployeeChangesApprovalCode));
            //Training Allowance Batches
            DATABASE::"Training Allowance Batches":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendTrainingAllowanceApprovalCode));
            //Airtime allocation batch
            DATABASE::"Airtime Allocation Batches":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendAirtimeAllocationBatchApprovalCode));
            //Airtime Requests
            DATABASE::"Airtime Requests":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendAirtimeRequestApprovalCode));
            //Hotel Booking Requests
            DATABASE::"Hotel Booking Requests":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHotelBookingRequestApprovalCode));
            //Refreshment Requests
            DATABASE::"Refreshment Requests":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendRefreshmentRequestApprovalCode));
            //Room Booking Requests
            DATABASE::"Room Booking Requests":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendRoomBookingRequestApprovalCode));
            //Requisition Fees Requests
            DATABASE::"Requisition Fees Requests":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendRequisitionFeesRequestApprovalCode));
            DATABASE::"Memo Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendMemoRequestApprovalCode));
            DATABASE::"Shift Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendShiftRequestApprovalCode));
            DATABASE::"Medical Claim Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendClaimRequestApprovalCode));
            DATABASE::"Travelling Request":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendTravelRequestApprovalCode));

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;


    [Scope('Cloud')]
    procedure CheckApprovalsWorkflowEnabledCode(var Variant: Variant; CheckApprovalsWorkflowTxt: Text): Boolean
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        begin
            if not WorkflowManagement.CanExecuteWorkflow(Variant, CheckApprovalsWorkflowTxt) then
                Error(NoWorkflowEnabledErr);
            exit(true);
        end;
    end;


    [IntegrationEvent(false, false)]
    procedure OnSendDocForApproval(var Variant: Variant)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDocApprovalRequest(var Variant: Variant)
    begin
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventsToLibrary, '', false, false)]
    procedure AddWorkflowEventsToLibrary()
    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin

        //Leave Application
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendLeavesApplicationForApprovalCode, DATABASE::"Employee Leave Application", OnSendLeavesApplicationApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelLeaveApplicationForApprovalCode, DATABASE::"Employee Leave Application", OnCancelLeaveApplicationApprovalRequestTxt, 0, false);

        //Terminal Dues
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendTerminalDuesForApprovalCode, DATABASE::"Terminal Dues Header", OnSendTerminalDuesApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelTerminalDuesApprovalCode, DATABASE::"Terminal Dues Header", OnCancelTerminalDuesApprovalRequestTxt, 0, false);

        //Employee Changes
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendEmployeeChangesApprovalCode, DATABASE::"Change Request", OnSendEmployeeChangesApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelEmployeeChangesApprovalCode, DATABASE::"Change Request", OnCancelEmployeeChangesApprovalRequestTxt, 0, false);

        //Training Allowance Batches
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendTrainingAllowanceApprovalCode, DATABASE::"Training Allowance Batches", OnSendTrainingAllowanceApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelTrainingAllowanceApprovalCode, DATABASE::"Training Allowance Batches", OnCancelTrainingAllowanceApprovalRequestTxt, 0, false);

        //Airtime allocation batch
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendAirtimeAllocationBatchApprovalCode, DATABASE::"Airtime Allocation Batches", OnSendAirtimeAllocationBatchApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelAirtimeAllocationBatchApprovalCode, DATABASE::"Airtime Allocation Batches", OnCancelAirtimeAllocationBatchApprovalRequestTxt, 0, false);

        //Airtime Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendAirtimeRequestApprovalCode, DATABASE::"Airtime Requests", OnSendAirtimeRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelAirtimeRequestApprovalCode, DATABASE::"Airtime Requests", OnCancelAirtimeRequestApprovalRequestTxt, 0, false);

        //Hotel Booking Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHotelBookingRequestApprovalCode, DATABASE::"Hotel Booking Requests", OnSendHotelBookingRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHotelBookingRequestApprovalCode, DATABASE::"Hotel Booking Requests", OnCancelHotelBookingRequestApprovalRequestTxt, 0, false);

        //Refreshment Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendRefreshmentRequestApprovalCode, DATABASE::"Refreshment Requests", OnSendRefreshmentRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelRefreshmentRequestApprovalCode, DATABASE::"Refreshment Requests", OnCancelRefreshmentRequestApprovalRequestTxt, 0, false);

        //Room Booking Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendRoomBookingRequestApprovalCode, DATABASE::"Room Booking Requests", OnSendRoomBookingRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelRoomBookingRequestApprovalCode, DATABASE::"Room Booking Requests", OnCancelRoomBookingRequestApprovalRequestTxt, 0, false);

        //Requisition Fees Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendRequisitionFeesRequestApprovalCode, DATABASE::"Requisition Fees Requests", OnSendRequisitionFeesRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelRequisitionFeesRequestApprovalCode, DATABASE::"Requisition Fees Requests", OnCancelRequisitionFeesRequestApprovalRequestTxt, 0, false);

        //Memo Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendMemoRequestApprovalCode, DATABASE::"Memo Header", OnSendMemoRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelMemoRequestApprovalCode, DATABASE::"Memo Header", OnCancelMemoRequestApprovalRequestTxt, 0, false);

        //Shift Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendShiftRequestApprovalCode, DATABASE::"Shift Header", OnSendShiftRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelShiftRequestApprovalCode, DATABASE::"Shift Header", OnCancelShiftRequestApprovalRequestTxt, 0, false);

        //Claim Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendClaimRequestApprovalCode, DATABASE::"Shift Header", OnSendClaimRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelClaimRequestApprovalCode, DATABASE::"Shift Header", OnCancelClaimRequestApprovalRequestTxt, 0, false);

        //Travel Requests
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendTravelRequestApprovalCode, DATABASE::"Travelling Request", OnSendTravelRequestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelTravelRequestApprovalCode, DATABASE::"Travelling Request", OnCancelTravelRequestApprovalRequestTxt, 0, false);

    end;

    local procedure RunWorkflowOnSendApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApprovalRequest'));
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approvals Mgmt HR", OnSendDocForApproval, '', false, false)]
    procedure RunWorkflowOnSendApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            //Leave Application
            DATABASE::"Employee Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendLeavesApplicationForApprovalCode, Variant);
            //Payroll Processing Header
            DATABASE::"Payroll Processing Header":
                WorkflowManagement.HandleEvent(RunWorkflowSendPayrollApprovalCode, Variant);
            //Terminal Dues
            DATABASE::"Terminal Dues Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendTerminalDuesForApprovalCode, Variant);
            //Employee Changes
            DATABASE::"Change Request":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendEmployeeChangesApprovalCode, Variant);
            //Training Allowance Batches
            DATABASE::"Training Allowance Batches":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendTrainingAllowanceApprovalCode, Variant);
            //Airtime allocation batch
            DATABASE::"Airtime Allocation Batches":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendAirtimeAllocationBatchApprovalCode, Variant);
            //Airtime Requests
            DATABASE::"Airtime Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendAirtimeRequestApprovalCode, Variant);
            //Hotel Booking Requests
            DATABASE::"Hotel Booking Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHotelBookingRequestApprovalCode, Variant);
            //Refreshment Requests
            DATABASE::"Refreshment Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendRefreshmentRequestApprovalCode, Variant);
            //Room Booking Requests
            DATABASE::"Room Booking Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendRoomBookingRequestApprovalCode, Variant);
            //Requisition Fees Requests
            DATABASE::"Requisition Fees Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendRequisitionFeesRequestApprovalCode, Variant);
            DATABASE::"Memo Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendMemoRequestApprovalCode, Variant);
            DATABASE::"Shift Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendShiftRequestApprovalCode, Variant);
            DATABASE::"Medical Claim Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendClaimRequestApprovalCode, Variant);
            DATABASE::"Travelling Request":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendTravelRequestApprovalCode, Variant);
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approvals Mgmt HR", OnCancelDocApprovalRequest, '', false, false)]
    procedure RunWorkflowOnCancelApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            //Leave Application
            DATABASE::"Employee Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelLeaveApplicationForApprovalCode, Variant);
            //Payroll Processing Header
            DATABASE::"Payroll Processing Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelPayrollApprovalCode, Variant);
            //Terminal Dues
            DATABASE::"Terminal Dues Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelTerminalDuesApprovalCode, Variant);
            //Employee Changes
            DATABASE::"Change Request":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelEmployeeChangesApprovalCode, Variant);
            //Training Allowance Batches
            DATABASE::"Training Allowance Batches":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelTrainingAllowanceApprovalCode, Variant);
            //Airtime allocation batch
            DATABASE::"Airtime Allocation Batches":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelAirtimeAllocationBatchApprovalCode, Variant);
            //Airtime Requests
            DATABASE::"Airtime Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelAirtimeRequestApprovalCode, Variant);
            //Hotel Booking Requests
            DATABASE::"Hotel Booking Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHotelBookingRequestApprovalCode, Variant);
            //Refreshment Requests
            DATABASE::"Refreshment Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelRefreshmentRequestApprovalCode, Variant);
            //Room Booking Requests
            DATABASE::"Room Booking Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelRoomBookingRequestApprovalCode, Variant);
            //Requisition Fees Requests
            DATABASE::"Requisition Fees Requests":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelRequisitionFeesRequestApprovalCode, Variant);
            DATABASE::"Memo Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelMemoRequestApprovalCode, Variant);
            DATABASE::"Shift Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelShiftRequestApprovalCode, Variant);
            DATABASE::"Medical Claim Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelClaimRequestApprovalCode, Variant);
            DATABASE::"Travelling Request":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelTravelRequestApprovalCode, Variant);
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;


    var
        ApprovalEntry: Record "Approval Entry";

        PortalApprovals: Codeunit "Custom Helper Functions HR";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnOpenDocument, '', false, false)]
    procedure Reopen(RecRef: RecordRef; var Handled: Boolean)
    var
    begin
        case RecRef.Number of
            //Leave Application
            DATABASE::"Employee Leave Application":
                begin
                    RecRef.SetTable(Leave);
                    Leave.Validate(Status, Leave.Status::Open);
                    Leave.Modify;
                    //Send cancellation
                    ApprovalEntry.Reset();
                    ApprovalEntry.SetRange("Document No.", Leave."Application No");
                    if ApprovalEntry.FindFirst() then
                        PortalApprovals.SendLeaveApprovalEmail(ApprovalEntry, ApprovalEntry."Document No.");
                    Handled := true;
                end;
            //Payroll Processing Header
            DATABASE::"Payroll Processing Header":
                begin
                    RecRef.SetTable(PayrollProcessingHeader);
                    PayrollProcessingHeader.Validate(Status, PayrollProcessingHeader.Status::Open);
                    PayrollProcessingHeader.Modify;
                    Handled := true;
                end;
            //Terminal Dues
            DATABASE::"Terminal Dues Header":
                begin
                    RecRef.SetTable(TerminalDues);
                    TerminalDues.Validate("Approval Status", TerminalDues."Approval Status"::Open);
                    TerminalDues.Modify;
                    Handled := true;
                end;
            //Employee Changes
            DATABASE::"Change Request":
                begin
                    RecRef.SetTable(EmployeeChanges);
                    EmployeeChanges.Validate("Change Approval Status", EmployeeChanges."Change Approval Status"::Open);
                    EmployeeChanges.Modify;
                    Handled := true;
                end;

            //Airtime allocation batch
            DATABASE::"Airtime Allocation Batches":
                begin
                    RecRef.SetTable(AirtimeAllocationBatch);
                    AirtimeAllocationBatch.Validate("Approval Status", AirtimeAllocationBatch."Approval Status"::Open);
                    AirtimeAllocationBatch.Modify;
                    Handled := true;
                end;

            //Airtime Requests
            DATABASE::"Airtime Requests":
                begin
                    RecRef.SetTable(AirtimeRequest);
                    AirtimeRequest.Validate("Approval Status", AirtimeRequest."Approval Status"::Open);
                    AirtimeRequest.Modify;
                    Handled := true;
                end;
            //Hotel Booking Requests
            DATABASE::"Hotel Booking Requests":
                begin
                    RecRef.SetTable(HotelBookingRequest);
                    HotelBookingRequest.Validate("Approval Status", HotelBookingRequest."Approval Status"::Open);
                    HotelBookingRequest.Modify;
                    Handled := true;
                end;
            //Refreshment Requests
            DATABASE::"Refreshment Requests":
                begin
                    RecRef.SetTable(RefreshmentRequest);
                    RefreshmentRequest.Validate("Approval Status", RefreshmentRequest."Approval Status"::Open);
                    RefreshmentRequest.Modify;
                    Handled := true;
                end;
            //Room Booking Requests
            DATABASE::"Room Booking Requests":
                begin
                    RecRef.SetTable(RoomBooking);
                    RoomBooking.Validate("Approval Status", RoomBooking."Approval Status"::Open);
                    RoomBooking.Modify;
                    Handled := true;
                end;
            //Requisition Fees Requests
            DATABASE::"Requisition Fees Requests":
                begin
                    RecRef.SetTable(RequisitionFeesRequest);
                    RequisitionFeesRequest.Validate("Approval Status", RequisitionFeesRequest."Approval Status"::Open);
                    RequisitionFeesRequest.Modify;
                    Handled := true;
                end;
            //Training Allowance Batches
            DATABASE::"Training Allowance Batches":
                begin
                    RecRef.SetTable(TrainingAllowanceBatch);
                    TrainingAllowanceBatch.Validate("Approval Status", TrainingAllowanceBatch."Approval Status"::Open);
                    TrainingAllowanceBatch.Modify;
                    Handled := true;
                end;
            //Memos
            DATABASE::"Memo Header":
                begin
                    RecRef.SetTable(Memoequest);
                    Memoequest.Validate("Approval Status", Memoequest."Approval Status"::Open);
                    Memoequest.Modify;
                    Handled := true;
                end;

            DATABASE::"Shift Header":
                begin
                    RecRef.SetTable(ShiftRequest);
                    ShiftRequest.Validate("Approval Status", ShiftRequest."Approval Status"::Open);
                    ShiftRequest.Modify;
                    Handled := true;
                end;

            DATABASE::"Medical Claim Header":
                begin
                    RecRef.SetTable(ClaimRequest);
                    ClaimRequest.Validate("Approval Status", ShiftRequest."Approval Status"::Open);
                    ClaimRequest.Modify;
                    Handled := true;
                end;

            DATABASE::"Travelling Request":
                begin
                    RecRef.SetTable(TravelRequest);
                    TravelRequest.Validate("Status", TravelRequest."Status"::Open);
                    TravelRequest.Modify;
                    Handled := true;
                end;

        end;
    end;


    var
        UserSetup: Record "User Setup";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnReleaseDocument, '', false, false)]
    procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        AirtimeManagementFunctions: Codeunit "Airtime Management Functions";
    begin
        case RecRef.Number of
            //Leave Application
            DATABASE::"Employee Leave Application":
                begin
                    RecRef.SetTable(Leave);
                    Leave.Validate(Status, Leave.Status::Released);
                    Leave.Modify;
                    Handled := true;
                    //=>Leave.FnPostLeave(Leave."Application No");
                    //LeaveRec.FnPostLeave(Leave."Application No");

                    //=========================================================Update Reliever Details
                    UserSetup.Reset;
                    UserSetup.SetRange("User ID", Leave."User ID");
                    if UserSetup.FindSet then begin
                        UserSetup."Delegation Start" := Leave."Start Date";
                        UserSetup."Delegation End" := Leave."Resumption Date";
                        UserSetup."Leave Reliever Code" := Leave."Duties Taken Over By";
                        UserSetup.Delegate := true;
                        UserSetup.Modify;
                    end;
                end;
            //Payroll Processing Header
            DATABASE::"Payroll Processing Header":
                begin
                    RecRef.SetTable(PayrollProcessingHeader);
                    PayrollProcessingHeader.Validate(Status, PayrollProcessingHeader.Status::Approved);
                    PayrollProcessingHeader.Modify;
                    Handled := true;
                end;
            //Terminal Dues
            DATABASE::"Terminal Dues Header":
                begin
                    RecRef.SetTable(TerminalDues);
                    TerminalDues.Validate("Approval Status", TerminalDues."Approval Status"::Released);
                    TerminalDues.Modify;
                    Handled := true;
                end;

            //Employee Changes
            DATABASE::"Change Request":
                begin
                    RecRef.SetTable(EmployeeChanges);
                    EmployeeChanges.Validate("Change Approval Status", EmployeeChanges."Change Approval Status"::Approved);
                    EmployeeChanges.UpdateEmployeeCard(); //update emp card
                    EmployeeChanges.Modify;
                    Handled := true;
                end;

            //Training Allowance Batches
            DATABASE::"Training Allowance Batches":
                begin
                    RecRef.SetTable(TrainingAllowanceBatch);
                    TrainingAllowanceBatch.Validate("Approval Status", TrainingAllowanceBatch."Approval Status"::Released);
                    TrainingAllowanceBatch.Modify;
                    Handled := true;
                end;

            //Airtime allocation batch
            DATABASE::"Airtime Allocation Batches":
                begin
                    RecRef.SetTable(AirtimeAllocationBatch);
                    AirtimeAllocationBatch.Validate("Approval Status", AirtimeAllocationBatch."Approval Status"::Released);
                    AirtimeManagementFunctions.SendToVendor(AirtimeAllocationBatch."Month Start Date");
                    AirtimeAllocationBatch.Modify;
                    Handled := true;
                end;

            //Airtime Requests
            DATABASE::"Airtime Requests":
                begin
                    RecRef.SetTable(AirtimeRequest);
                    AirtimeRequest.Validate("Approval Status", AirtimeRequest."Approval Status"::Released);
                    AirtimeRequest.Modify;
                    Handled := true;
                end;

            //Hotel Booking Requests
            DATABASE::"Hotel Booking Requests":
                begin
                    RecRef.SetTable(HotelBookingRequest);
                    HotelBookingRequest.Validate("Approval Status", HotelBookingRequest."Approval Status"::Released);
                    HotelBookingRequest.Modify;
                    Handled := true;
                end;

            //Refreshment Requests
            DATABASE::"Refreshment Requests":
                begin
                    RecRef.SetTable(RefreshmentRequest);
                    RefreshmentRequest.Validate("Approval Status", RefreshmentRequest."Approval Status"::Released);
                    RefreshmentRequest.Modify;
                    Handled := true;
                end;

            //Room Booking Requests
            DATABASE::"Room Booking Requests":
                begin
                    RecRef.SetTable(RoomBooking);
                    RoomBooking.Validate("Approval Status", RoomBooking."Approval Status"::Released);
                    RoomBooking.Modify;
                    Handled := true;
                end;

            //Requisition Fees Requests
            DATABASE::"Requisition Fees Requests":
                begin
                    RecRef.SetTable(RequisitionFeesRequest);
                    RequisitionFeesRequest.Validate("Approval Status", RequisitionFeesRequest."Approval Status"::Released);
                    OnReleaseRequisitionFeesRequestBeforeModify(RequisitionFeesRequest);
                    RequisitionFeesRequest.Modify;
                    Handled := true;
                end;
            DATABASE::"Memo Header":
                begin
                    RecRef.SetTable(Memoequest);
                    Memoequest.Validate("Approval Status", Memoequest."Approval Status"::Released);
                    Memoequest.Modify;
                    Handled := true;
                end;

            DATABASE::"Shift Header":
                begin
                    RecRef.SetTable(ShiftRequest);
                    ShiftRequest.Validate("Approval Status", ShiftRequest."Approval Status"::Released);
                    ShiftRequest.Modify;
                    Handled := true;
                end;

            DATABASE::"Medical Claim Header":
                begin
                    RecRef.SetTable(ClaimRequest);
                    ClaimRequest.Validate("Approval Status", ClaimRequest."Approval Status"::Released);
                    ClaimRequest.Modify;
                    Handled := true;
                end;

            DATABASE::"Travelling Request":
                begin
                    RecRef.SetTable(TravelRequest);
                    TravelRequest.Validate("Status", TravelRequest."Status"::Released);
                    TravelRequest.Modify;
                    Handled := true;
                end;
        end;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnSetStatusToPendingApproval, '', false, false)]
    local procedure SetStatusToPending(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            //Leave Application
            DATABASE::"Employee Leave Application":
                begin
                    RecRef.SetTable(Leave);
                    Leave.Validate(Status, Leave.Status::"Pending Approval");
                    Leave.Modify;
                    Variant := Leave;
                    IsHandled := true;
                end;

            //Payroll Processing Header
            DATABASE::"Payroll Processing Header":
                begin
                    RecRef.SetTable(PayrollProcessingHeader);
                    PayrollProcessingHeader.Validate(Status, PayrollProcessingHeader.Status::"Pending Approval");
                    PayrollProcessingHeader.Modify;
                    Variant := PayrollProcessingHeader;
                    IsHandled := true;
                end;

            //Terminal Dues
            DATABASE::"Terminal Dues Header":
                begin
                    RecRef.SetTable(TerminalDues);
                    TerminalDues.Validate("Approval Status", TerminalDues."Approval Status"::"Pending Approval");
                    TerminalDues.Modify;
                    Variant := TerminalDues;
                    IsHandled := true;
                end;
            //Employee Changes
            DATABASE::"Change Request":
                begin
                    RecRef.SetTable(EmployeeChanges);
                    EmployeeChanges.Validate("Change Approval Status", EmployeeChanges."Change Approval Status"::"Pending Approval");
                    EmployeeChanges.Modify();
                    Variant := EmployeeChanges;
                    IsHandled := true;
                end;
            //Training Allowance Batches
            DATABASE::"Training Allowance Batches":
                begin
                    RecRef.SetTable(TrainingAllowanceBatch);
                    TrainingAllowanceBatch.Validate("Approval Status", TrainingAllowanceBatch."Approval Status"::"Pending Approval");
                    TrainingAllowanceBatch.Modify();
                    Variant := TrainingAllowanceBatch;
                    IsHandled := true;
                end;
            //Airtime allocation batch
            DATABASE::"Airtime Allocation Batches":
                begin
                    RecRef.SetTable(AirtimeAllocationBatch);
                    AirtimeAllocationBatch.Validate("Approval Status", AirtimeAllocationBatch."Approval Status"::"Pending Approval");
                    AirtimeAllocationBatch.Modify();
                    Variant := AirtimeAllocationBatch;
                    IsHandled := true;
                end;
            //Airtime Requests
            DATABASE::"Airtime Requests":
                begin
                    RecRef.SetTable(AirtimeRequest);
                    AirtimeRequest.Validate("Approval Status", AirtimeRequest."Approval Status"::"Pending Approval");
                    AirtimeRequest.Modify();
                    Variant := AirtimeRequest;
                    IsHandled := true;
                end;
            //Hotel Booking Requests
            DATABASE::"Hotel Booking Requests":
                begin
                    RecRef.SetTable(HotelBookingRequest);
                    HotelBookingRequest.Validate("Approval Status", HotelBookingRequest."Approval Status"::"Pending Approval");
                    HotelBookingRequest.Modify();
                    Variant := HotelBookingRequest;
                    IsHandled := true;
                end;
            //Refreshment Requests
            DATABASE::"Refreshment Requests":
                begin
                    RecRef.SetTable(RefreshmentRequest);
                    RefreshmentRequest.Validate("Approval Status", RefreshmentRequest."Approval Status"::"Pending Approval");
                    RefreshmentRequest.Modify();
                    Variant := RefreshmentRequest;
                    IsHandled := true;
                end;
            //Room Booking Requests
            DATABASE::"Room Booking Requests":
                begin
                    RecRef.SetTable(RoomBooking);
                    RoomBooking.Validate("Approval Status", RoomBooking."Approval Status"::"Pending Approval");
                    RoomBooking.Modify();
                    Variant := RoomBooking;
                    IsHandled := true;
                end;
            //Requisition Fees Requests
            DATABASE::"Requisition Fees Requests":
                begin
                    RecRef.SetTable(RequisitionFeesRequest);
                    RequisitionFeesRequest.Validate("Approval Status", RequisitionFeesRequest."Approval Status"::"Pending Approval");
                    RequisitionFeesRequest.Modify();
                    Variant := RequisitionFeesRequest;
                    IsHandled := true;
                end;
            DATABASE::"Memo Header":
                begin
                    RecRef.SetTable(Memoequest);
                    Memoequest.Validate("Approval Status", Memoequest."Approval Status"::"Pending Approval");
                    Memoequest.Modify();
                    Variant := Memoequest;
                    IsHandled := true;
                end;

            DATABASE::"Shift Header":
                begin
                    RecRef.SetTable(ShiftRequest);
                    ShiftRequest.Validate("Approval Status", ShiftRequest."Approval Status"::"Pending Approval");
                    ShiftRequest.Modify();
                    Variant := ShiftRequest;
                    IsHandled := true;
                end;

            DATABASE::"Medical Claim Header":
                begin
                    RecRef.SetTable(ClaimRequest);
                    ClaimRequest.Validate("Approval Status", ClaimRequest."Approval Status"::"Pending Approval");
                    ClaimRequest.Modify();
                    Variant := ClaimRequest;
                    IsHandled := true;
                end;

            DATABASE::"Travelling Request":
                begin
                    RecRef.SetTable(TravelRequest);
                    TravelRequest.Validate("Status", TravelRequest."Status"::"Pending Approval");
                    TravelRequest.Modify();
                    Variant := TravelRequest;
                    IsHandled := true;
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnPopulateApprovalEntryArgument, '', false, false)]
    procedure PopulateApprovalEntryArgument(RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance") //Found: Boolean
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        case RecRef.Number of
            //Leave Application
            DATABASE::"Employee Leave Application":
                begin
                    RecRef.SetTable(Leave);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::LeaveApplication;
                    ApprovalEntryArgument."Document No." := Leave."Application No";
                    ApprovalEntryArgument.Validate("Document No.");
                end;
            //Payroll Processing Header
            DATABASE::"Payroll Processing Header":
                begin
                    RecRef.SetTable(PayrollProcessingHeader);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::Payroll;
                    ApprovalEntryArgument."Document No." := PayrollProcessingHeader."Payroll Processing No";
                    ApprovalEntryArgument.Validate("Document No.");
                end;

            //Terminal Dues
            DATABASE::"Terminal Dues Header":
                begin
                    RecRef.SetTable(TerminalDues);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Final Dues";
                    ApprovalEntryArgument."Document No." := TerminalDues."No.";
                    ApprovalEntryArgument.Description := 'Approval of ' + TerminalDues."No." + ' Final Dues for ' + TerminalDues."WB No." + ' ' + TerminalDues."Full Name";
                    TerminalDues.CalcFields(Balance);
                    ApprovalEntryArgument.Amount := TerminalDues.Balance;
                    //ApprovalEntryArgument."Amount (LCY)" := GenJournalLine."Amount (LCY)";
                    //ApprovalEntryArgument."Currency Code" := GenJournalLine."Currency Code";
                end;
            //Employee Changes
            DATABASE::"Change Request":
                begin
                    RecRef.SetTable(EmployeeChanges);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Employee Change";
                    ApprovalEntryArgument."Document No." := EmployeeChanges."No.";
                    ApprovalEntryArgument.Description := 'Approval of ' + EmployeeChanges."No." + ' employee change request for ' + EmployeeChanges."Emp No." + ' ' + EmployeeChanges.FullName;
                end;

            //Training Allowance Batches
            DATABASE::"Training Allowance Batches":
                begin
                    RecRef.SetTable(TrainingAllowanceBatch);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Training Allowance";
                    ApprovalEntryArgument."Document No." := TrainingAllowanceBatch."Batch Name";
                    ApprovalEntryArgument.Description := 'Approval of ' + TrainingAllowanceBatch.Description;
                end;
            //Airtime allocation batch
            DATABASE::"Airtime Allocation Batches":
                begin
                    RecRef.SetTable(AirtimeAllocationBatch);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Airtime Allocation Batch";
                    ApprovalEntryArgument."Document No." := AirtimeAllocationBatch."Doc No";
                    ApprovalEntryArgument.Description := 'Approval of airtime allocation batch ' + Format(AirtimeAllocationBatch."Month Start Date") + ' - ' + AirtimeAllocationBatch.Description;
                end;
            //Airtime Requests
            DATABASE::"Airtime Requests":
                begin
                    RecRef.SetTable(AirtimeRequest);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Hotel Booking Request";
                    ApprovalEntryArgument."Document No." := AirtimeRequest."No.";
                    ApprovalEntryArgument.Description := 'Approval of airtime request ' + AirtimeRequest."No." + ' for ' + AirtimeRequest."Emp No." + ' - ' + AirtimeRequest."Emp Name";
                end;
            //Hotel Booking Requests
            DATABASE::"Hotel Booking Requests":
                begin
                    RecRef.SetTable(HotelBookingRequest);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Airtime Request";
                    ApprovalEntryArgument."Document No." := HotelBookingRequest."No.";
                    ApprovalEntryArgument.Description := 'Approval of hotel booking request ' + HotelBookingRequest."No." + ' for ' + HotelBookingRequest."Hotel Name" + ' raised by ' + HotelBookingRequest."Requested By Emp Name";
                end;
            //Refreshment Requests
            DATABASE::"Refreshment Requests":
                begin
                    RecRef.SetTable(RefreshmentRequest);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Refreshment Request";
                    ApprovalEntryArgument."Document No." := RefreshmentRequest."No.";
                    ApprovalEntryArgument.Description := 'Approval of refreshment request ' + RefreshmentRequest."No.";
                end;
            //Room Booking Requests
            DATABASE::"Room Booking Requests":
                begin
                    RecRef.SetTable(RoomBooking);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Room Booking Request";
                    ApprovalEntryArgument."Document No." := RoomBooking."No.";
                    ApprovalEntryArgument.Description := 'Approval of room booking request ' + RoomBooking."No.";
                end;
            //Requisition Fees Requests
            DATABASE::"Requisition Fees Requests":
                begin
                    RecRef.SetTable(RequisitionFeesRequest);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Room Booking Request";
                    ApprovalEntryArgument."Document No." := RequisitionFeesRequest."No.";
                    ApprovalEntryArgument.Description := 'Approval of requisition fees request ' + RequisitionFeesRequest."No.";
                end;
            DATABASE::"Memo Header":
                begin
                    RecRef.SetTable(Memoequest);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
                    ApprovalEntryArgument."Document No." := Memoequest."No.";
                    ApprovalEntryArgument.Description := 'Approval of Memo request ' + Memoequest."No.";
                end;

            DATABASE::"Shift Header":
                begin
                    RecRef.SetTable(ShiftRequest);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
                    ApprovalEntryArgument."Document No." := ShiftRequest."No.";
                    ApprovalEntryArgument.Description := 'Approval of Shift request ' + ShiftRequest."No.";
                end;

            DATABASE::"Medical Claim Header":
                begin
                    RecRef.SetTable(ClaimRequest);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
                    ApprovalEntryArgument."Document No." := ClaimRequest."No.";
                    ApprovalEntryArgument.Description := 'Approval of Claim request ' + ClaimRequest."No.";
                end;

            DATABASE::"Travelling Request":
                begin
                    RecRef.SetTable(TravelRequest);
                    ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
                    ApprovalEntryArgument."Document No." := TravelRequest."Request No.";
                    ApprovalEntryArgument.Description := 'Approval of Claim request ' + TravelRequest."Request No.";
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnRejectApprovalRequest, '', false, false)]
    procedure Reject(var ApprovalEntry: Record "Approval Entry")
    begin
        case ApprovalEntry."Table ID" of
            //Leave Application
            DATABASE::"Employee Leave Application":
                begin
                    Leave.Reset();
                    Leave.SetRange("Application No", ApprovalEntry."Document No.");
                    if Leave.FindFirst() then begin
                        Leave.Validate(Status, Leave.Status::Open);
                        Leave.Modify;
                    end;
                end;
            //Payroll Processing Header
            DATABASE::"Payroll Processing Header":
                begin
                    PayrollProcessingHeader.Reset();
                    PayrollProcessingHeader.SetRange("Payroll Processing No", ApprovalEntry."Document No.");
                    if PayrollProcessingHeader.FindFirst() then begin
                        PayrollProcessingHeader.Validate(Status, PayrollProcessingHeader.Status::Open);
                        PayrollProcessingHeader.Modify();
                    end;
                end;
            //Terminal Dues
            DATABASE::"Terminal Dues Header":
                begin
                    TerminalDues.Reset();
                    TerminalDues.SetRange("No.", ApprovalEntry."Document No.");
                    if TerminalDues.FindFirst() then begin
                        TerminalDues.Validate("Approval Status", TerminalDues."Approval Status"::Rejected);
                        TerminalDues.Modify;
                    end;
                end;

            //Employee Changes
            DATABASE::"Change Request":
                begin
                    EmployeeChanges.Reset();
                    EmployeeChanges.SetRange("No.", ApprovalEntry."Document No.");
                    if EmployeeChanges.FindFirst() then begin
                        EmployeeChanges.Validate("Change Approval Status", EmployeeChanges."Change Approval Status"::Rejected);
                        EmployeeChanges.Modify;
                    end;
                end;

            //Training Allowance Batches
            DATABASE::"Training Allowance Batches":
                begin
                    TrainingAllowanceBatch.Reset();
                    TrainingAllowanceBatch.SetRange("Batch Name", ApprovalEntry."Document No.");
                    if TrainingAllowanceBatch.FindFirst() then begin
                        TrainingAllowanceBatch.Validate("Approval Status", TrainingAllowanceBatch."Approval Status"::Rejected);
                        TrainingAllowanceBatch.Modify;
                    end;
                end;

            //Airtime allocation batch
            DATABASE::"Airtime Allocation Batches":
                begin
                    AirtimeAllocationBatch.Reset();
                    AirtimeAllocationBatch.SetRange("Doc No", ApprovalEntry."Document No.");
                    if AirtimeAllocationBatch.FindFirst() then begin
                        AirtimeAllocationBatch.Validate("Approval Status", AirtimeAllocationBatch."Approval Status"::Rejected);
                        AirtimeAllocationBatch.Modify;
                    end;
                end;

            //Airtime Requests
            DATABASE::"Airtime Requests":
                begin
                    AirtimeRequest.Reset();
                    AirtimeRequest.SetRange("No.", ApprovalEntry."Document No.");
                    if AirtimeRequest.FindFirst() then begin
                        AirtimeRequest.Validate("Approval Status", AirtimeRequest."Approval Status"::Rejected);
                        AirtimeRequest.Modify;
                    end;
                end;

            //Hotel Booking Requests
            DATABASE::"Hotel Booking Requests":
                begin
                    HotelBookingRequest.Reset();
                    HotelBookingRequest.SetRange("No.", ApprovalEntry."Document No.");
                    if HotelBookingRequest.FindFirst() then begin
                        HotelBookingRequest.Validate("Approval Status", HotelBookingRequest."Approval Status"::Rejected);
                        HotelBookingRequest.Modify;
                    end;
                end;

            //Refreshment Requests
            DATABASE::"Refreshment Requests":
                begin
                    RefreshmentRequest.Reset();
                    RefreshmentRequest.SetRange("No.", ApprovalEntry."Document No.");
                    if RefreshmentRequest.FindFirst() then begin
                        RefreshmentRequest.Validate("Approval Status", RefreshmentRequest."Approval Status"::Rejected);
                        RefreshmentRequest.Modify;
                    end;
                end;

            //Room Booking Requests
            DATABASE::"Room Booking Requests":
                begin
                    RoomBooking.Reset();
                    RoomBooking.SetRange("No.", ApprovalEntry."Document No.");
                    if RoomBooking.FindFirst() then begin
                        RoomBooking.Validate("Approval Status", RoomBooking."Approval Status"::Rejected);
                        RoomBooking.Modify;
                    end;
                end;

            //Requisition Fees Requests
            DATABASE::"Requisition Fees Requests":
                begin
                    RequisitionFeesRequest.Reset();
                    RequisitionFeesRequest.SetRange("No.", ApprovalEntry."Document No.");
                    if RequisitionFeesRequest.FindFirst() then begin
                        RequisitionFeesRequest.Validate("Approval Status", RequisitionFeesRequest."Approval Status"::Rejected);
                        RequisitionFeesRequest.Modify;
                    end;
                end;
            DATABASE::"Memo Header":
                begin
                    Memoequest.Reset();
                    Memoequest.SetRange("No.", ApprovalEntry."Document No.");
                    if Memoequest.FindFirst() then begin
                        Memoequest.Validate("Approval Status", Memoequest."Approval Status"::Rejected);
                        Memoequest.Modify;
                    end;
                end;

            DATABASE::"Shift Header":
                begin
                    ShiftRequest.Reset();
                    ShiftRequest.SetRange("No.", ApprovalEntry."Document No.");
                    if ShiftRequest.FindFirst() then begin
                        ShiftRequest.Validate("Approval Status", ShiftRequest."Approval Status"::Rejected);
                        ShiftRequest.Modify;
                    end;
                end;

            DATABASE::"Medical Claim Header":
                begin
                    ClaimRequest.Reset();
                    ClaimRequest.SetRange("No.", ApprovalEntry."Document No.");
                    if ClaimRequest.FindFirst() then begin
                        ClaimRequest.Validate("Approval Status", ClaimRequest."Approval Status"::Rejected);
                        ClaimRequest.Modify;
                    end;
                end;

            DATABASE::"Travelling Request":
                begin
                    TravelRequest.Reset();
                    TravelRequest.SetRange("Request No.", ApprovalEntry."Document No.");
                    if TravelRequest.FindFirst() then begin
                        TravelRequest.Validate("Status", TravelRequest."Status"::Rejected);
                        TravelRequest.Modify;
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequest, '', false, false)]
    local procedure OnApproveApprovalRequest(VAR ApprovalEntry: Record "Approval Entry")
    var
    begin
        FnApproveRecordsWithSameSequenceNumber(ApprovalEntry);
    end;

    LOCAL PROCEDURE FnApproveRecordsWithSameSequenceNumber(ApprovalEntry: Record "Approval Entry"): Boolean
    VAR
        otherApprovalEntries: Record "Approval Entry";
    BEGIN
        otherApprovalEntries.RESET;
        otherApprovalEntries.SETRANGE("Sequence No.", ApprovalEntry."Sequence No.");
        otherApprovalEntries.SETRANGE("Document No.", ApprovalEntry."Document No.");
        IF otherApprovalEntries.FIND('-') THEN BEGIN
            REPEAT
                otherApprovalEntries.VALIDATE(Status, ApprovalEntry.Status::Approved);
                otherApprovalEntries.MODIFY(TRUE);
            UNTIL otherApprovalEntries.NEXT = 0;
        END;
    END;


    [IntegrationEvent(false, false)]
    local procedure OnReleaseRequisitionFeesRequestBeforeModify(var RequisitionFeesRequest: Record "Requisition Fees Requests")
    begin
    end;

}
