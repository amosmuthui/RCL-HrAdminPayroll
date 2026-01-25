page 52211525 "Airtime Request Card"
{
    ApplicationArea = All;
    Caption = 'Airtime Request Card';
    PageType = Card;
    SourceTable = "Airtime Requests";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.', Comment = '%';
                }
                field("Emp Name"; Rec."Emp Name")
                {
                    ToolTip = 'Specifies the value of the Emp Name field.', Comment = '%';
                }
                field("Position Code"; Rec."Position Code")
                {
                    ToolTip = 'Specifies the value of the Position Code field.', Comment = '%';
                }
                field("Position Title"; Rec."Position Title")
                {
                    ToolTip = 'Specifies the value of the Position Title field.', Comment = '%';
                }
                field("Dept Code"; Rec."Dept Code")
                {
                    ToolTip = 'Specifies the value of the Dept Code field.', Comment = '%';
                }
                field("Dept Name"; Rec."Dept Name")
                {
                    ToolTip = 'Specifies the value of the Dept Name field.', Comment = '%';
                }
                field("Job Category"; Rec."Job Category")
                {
                    ToolTip = 'Specifies the value of the Job Category field.', Comment = '%';
                }
                field("Applicable Amount"; Rec."Applicable Amount")
                {
                    ToolTip = 'Specifies the value of the Applicable Amount field.', Comment = '%';
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ToolTip = 'Specifies the value of the Applied Amount field.', Comment = '%';
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Approved Amount field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Add to Batch")
            {
                Image = Create;
                ApplicationArea = All;
                ToolTip = 'Add to Batch';
                Caption = 'Add to Batch';
                Enabled = not Rec.Processed;

                trigger OnAction()
                var
                    SelectedDate: Date;
                    ExistingAllocationPeriods: Record "Airtime Allocation Batches";
                begin
                    if confirm('Do you want to add this request to an existing allocation batch?') then begin
                        ExistingAllocationPeriods.Reset();
                        ExistingAllocationPeriods.SetFilter("Approval Status", '%1|%2', ExistingAllocationPeriods."Approval Status"::Open, ExistingAllocationPeriods."Approval Status"::Rejected);
                        if ExistingAllocationPeriods.Find('-') then begin
                            if PAGE.RunModal(Page::"Airtime Allocation Batches", ExistingAllocationPeriods) = ACTION::LookupOK then
                                SelectedDate := ExistingAllocationPeriods."Month Start Date";
                            if SelectedDate = 0D then
                                Error('You have not selected any entry!');
                            AirtimeManagementFunctions.AddToBatch(SelectedDate, Rec);
                            CurrPage.Update(false);
                        end else
                            Error('There are no open/rejected allocation periods. Please create one then retry.');
                    end;
                end;
            }
            action("Send to Vendor")
            {
                Image = SendEmailPDF;
                ApplicationArea = All;
                ToolTip = 'Send to Vendor';
                Caption = 'Send to Vendor';
                Visible = false;

                trigger OnAction()
                var
                    SelectedDate: Date;
                begin
                    if Confirm('Are you sure you want to send the airtime allocations to vendor?') then begin
                        AirtimeManagementFunctions.AddToBatch(SelectedDate, Rec);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("Send Approval Request")
            {
                Image = Approve;

                trigger OnAction()
                begin
                    Rec.TestField("Emp No.");
                    Rec.TestField("Applied Amount");

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
                actionref("Add to Batch Promoted"; "Add to Batch") { }
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

    trigger OnOpenPage()
    begin
        if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
            CurrPage.Editable(false);
    end;
}
