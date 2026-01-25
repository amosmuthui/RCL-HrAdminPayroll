page 51525307 "HR Leave Journal Lines"
{
    ApplicationArea = All;
    DelayedInsert = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Functions,Approvals';
    RefreshOnActivate = true;
    SaveValues = false;
    SourceTable = "HR Leave Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;

                    //Rec.RESET;

                    InsuranceJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    InsuranceJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field("Line No."; Rec."Line No.")
                {
                }
                field("Leave Period"; Rec."Leave Period")
                {
                    TableRelation = "HR Leave Periods"."Period Code";
                }
                field("Staff No."; Rec."Staff No.")
                {
                    TableRelation = Employee;
                }
                field("Staff Name"; Rec."Staff Name")
                {
                }
                field("Leave Type"; Rec."Leave Type")
                {
                }
                field("Leave Entry Type"; Rec."Leave Entry Type")
                {
                }
                field("No. of Days"; Rec."No. of Days")
                {
                }
                field(Adjustment; Rec.Adjustment)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Post Adjustment")
                {
                    Caption = 'Post Adjustment';
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        CODEUNIT.Run(CODEUNIT::"HR Leave Jnl.-Post", Rec);

                        CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("Batch Allocation")
                {
                    Image = Allocate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    //RunObject = Report Report51525050;
                }
                action("Import Leave")
                {
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    //RunObject = XMLport "Import Leave";
                }
            }
            group(Action1102755006)
            {
                action("<Action1102756003>")
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval",JV;
                    begin
                    end;
                }
                action("<Action1102756005>")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    var
                        //ApprovalMgt: Codeunit "Approvals Mgmt.";
                        GenLedgSetup: Record "General Ledger Setup";
                        NoSeriesMgt: Codeunit "No. Series";
                        Text001: Label 'This batch is already pending approval';
                    begin
                    end;
                }
                action("<Action1102756006>")
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;
                }
                action(Import)
                {

                    trigger OnAction()
                    begin
                        XMLPORT.Run(50011, false, true);
                    end;
                }
            }
            action(Import2)
            {
                Image = ImportChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    XMLPORT.Run(50011, false, true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
        InsuranceJnlManagement: Codeunit "HR Leave Jnl Management";
    begin
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') and (Rec."Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            InsuranceJnlManagement.OpenJournal(CurrentJnlBatchName, Rec);
            exit;
        end;
        InsuranceJnlManagement.TemplateSelection(PAGE::"HR Leave Journal Lines", Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        InsuranceJnlManagement.OpenJournal(CurrentJnlBatchName, Rec);
    end;

    var
        HRLeaveTypes: Record "Leave Types";
        HREmp: Record Employee;
        HRLeaveLedger: Record "HR Leave Ledger Entries";
        InsuranceJnlManagement: Codeunit "HR Leave Jnl Management";
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        InsuranceDescription: Text[30];
        FADescription: Text[30];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        HRLeavePeriods: Record "HR Leave Periods";
        AllocationDone: Boolean;
        HRJournalBatch: Record "HR Leave Journal Batch";
        OK: Boolean;
        ApprovalEntries: Record "Approval Entry";
        LLE: Record "HR Leave Ledger Entries";

    procedure CheckGender(Emp: Record Employee; LeaveType: Record "Leave Types") Allocate: Boolean
    begin

        //CHECK IF LEAVE TYPE ALLOCATION APPLIES TO EMPLOYEE'S GENDER

        if Emp.Gender = Emp.Gender::Male then begin
            if LeaveType.Gender = LeaveType.Gender::Male then
                Allocate := true;
        end;

        if Emp.Gender = Emp.Gender::Female then begin
            if LeaveType.Gender = LeaveType.Gender::Female then
                Allocate := true;
        end;

        if LeaveType.Gender = LeaveType.Gender::Both then
            Allocate := true;
        exit(Allocate);

        if Emp.Gender <> LeaveType.Gender then
            Allocate := false;

        exit(Allocate);
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        InsuranceJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    procedure AllocateLeave1()
    begin
    end;

    procedure AllocateLeave2()
    begin
    end;
}