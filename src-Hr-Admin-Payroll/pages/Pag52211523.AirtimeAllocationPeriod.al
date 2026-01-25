page 52211523 "Airtime Allocation Batch"
{
    ApplicationArea = All;
    Caption = 'Airtime Allocation Batch';
    PageType = Card;
    SourceTable = "Airtime Allocation Batches";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Month Start Date"; Rec."Month Start Date")
                {
                    ToolTip = 'Specifies the value of the Month Start Date field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Service Provider"; Rec."Service Provider")
                {
                    ToolTip = 'Specifies the value of the Service Provider field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
            }
            part(Allocations; "Airtime Allocations")
            {
                SubPageLink = Period = field("Month Start Date");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create New")
            {
                Image = Create;
                ApplicationArea = All;
                ToolTip = 'Create New Batch';
                Caption = 'Create New';
                Visible = false;

                trigger OnAction()
                var
                    SelectedDate: Date;
                begin
                    if Confirm('Are you sure you want to create a new batch?') then begin
                        SelectedDate := AirtimeManagementFunctions.CreateDateSelection();
                        AirtimeManagementFunctions.CreateNewBatch(SelectedDate, false, false, false);
                    end;
                end;
            }
            action("Refresh Allocations")
            {
                Image = Refresh;
                ApplicationArea = All;
                ToolTip = 'Refresh Allocations';
                Caption = 'Refresh Allocations';
                Enabled = Rec."New Month";

                trigger OnAction()
                var
                    SelectedDate: Date;
                begin
                    if Confirm('Are you sure you want to refresh llocations?') then begin
                        AirtimeManagementFunctions.RefreshAllocations(Rec."Month Start Date");
                    end;
                end;
            }

            action(AllocationReport)
            {
                Caption = 'Allocation Report';
                Image = DepositSlip;

                trigger OnAction()
                var
                    AllocationPeriod: Record "Airtime Allocation Batches";
                begin
                    AllocationPeriod.Reset;
                    AllocationPeriod.SetRange("Month Start Date", Rec."Month Start Date");
                    if AllocationPeriod.Find('-') then begin
                        REPORT.Run(Report::"Airtime Allocations", true, true, AllocationPeriod);
                    end;
                end;
            }
            action("Send to Vendor")
            {
                Image = SendEmailPDF;
                ApplicationArea = All;
                ToolTip = 'Send to Vendor';
                Caption = 'Send to Vendor';
                Enabled = CanSendTovendor;

                trigger OnAction()
                var
                    SelectedDate: Date;
                begin
                    Rec.TestField("Service Provider");
                    if Confirm('Are you sure you want to send the airtime allocations to the service provider?') then begin
                        AirtimeManagementFunctions.SendToVendor(Rec."Month Start Date");
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("Send Approval Request")
            {
                Image = Approve;

                trigger OnAction()
                begin
                    Rec.TestField("Month Start Date");
                    Rec.TestField("Service Provider");

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
                actionref("Create New Promoted"; "Create New") { }
                actionref("Refresh Allocations Promoted"; "Refresh Allocations") { }
                actionref("AllocationReport Promoted"; AllocationReport) { }
                actionref("Send to Vendor Promoted"; "Send to Vendor") { }
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
        AirtimeManagementFunctions: Codeunit "Airtime Management Functions";
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
        CanSendTovendor: Boolean;
        UserSetup: Record "User Setup";


    trigger OnOpenPage()
    begin
        CanSendTovendor := false;
        if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
            CurrPage.Editable(false);

        if UserSetup.Get() then
            CanSendTovendor := UserSetup."Can Send Airtime Ls to Vendor";
    end;
}
