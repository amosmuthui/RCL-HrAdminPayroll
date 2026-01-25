page 51525351 "Payroll Processing Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Payroll Processing Header";
    PromotedActionCategories = 'Manage,Process,Report,Approvals,Data Update,Payslips';
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Payroll Processing No"; Rec."Payroll Processing No")
                {
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Date Processed"; Rec."Date Processed")
                {
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                }
            }
            part(Matrix; "Assigment Matrix")
            {
                Editable = false;
                SubPageLink = "Payroll Period" = FIELD("Payroll Period");
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1>")
            {
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    Approvalentries: Page "Approval Entries";
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                end;
            }
            action("<Action2>")
            {
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
                    VarVariant: Variant;
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('Record is already approved.');
                    VarVariant := Rec;
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);
                end;
            }
            action("<Action3>")
            {
                Caption = 'Cancel Approval Re&quest';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    ApprovalMgt: Codeunit "Approvals Mgmt.";
                    CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
                    VarVariant: Variant;
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('You cant cancel an approved document.');
                    VarVariant := Rec;
                    CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    //IF Status<>Status::Approved THEN
                    //ApprovalsMgmt.OnCancelPayrollHeaderApprovalRequest(Rec);
                end;
            }
            action("Payroll Run")
            {
                Caption = '1. Payroll Run';
                Image = PaymentPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //RunObject = Report "Payroll Run";

                trigger OnAction()
                var
                    placeHolder: Code[10];
                begin
                    placeHolder := '';
                    PayrollRunReport.SetReportFilter(Rec."Payroll Period", placeHolder);
                    PayrollRunReport.RUN;

                    //Show who processed and when
                    PayProcessHeader.RESET;
                    //PayProcessHeader.SETRANGE(No,Rec.No);
                    PayProcessHeader.SETRANGE("Payroll Period", Rec."Payroll Period");
                    IF PayProcessHeader.FIND('-') THEN begin
                        PayProcessHeader."Date Processed" := TODAY;
                        PayProcessHeader.Modify();
                    end;
                end;
            }
            action("Payroll Statistics")
            {
                Caption = '2. Payroll Statistics';
                Image = PaymentPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //RunObject = Report "Payroll-Statistics";
                trigger OnAction()
                var
                    EmpRec: Record Employee;
                    PayStatReport: Report "Detailed Payroll Statistics";
                begin
                    EmpRec.Reset;
                    EmpRec.SetRange(EmpRec."Pay Period Filter", Rec."Payroll Period");
                    if EmpRec.Find('-') then begin
                        PayStatReport.SetTableView(EmpRec);
                        //EmpRec.Setrange("Payroll Country", LastPayrollCountry);
                        PayStatReport.SetReportFilter(Rec."Payroll Period", '');
                        Commit();
                        PayStatReport.Run();
                        //REPORT.Run(REPORT::"Detailed Payroll Statistics", true, true, EmpRec);
                    end;
                end;
            }
            action("3.  Transfer to Journal")
            {
                Caption = '3.  Transfer to Journal';
                Image = TransferToGeneralJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Transfer To Journal Allocation";
                Enabled = false;
            }
            action("4. Open Payroll Journal")
            {
                Image = JobJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = false;

                trigger OnAction()
                begin
                    BatchName := 'SALARIES';
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLine.SetRange("Journal Batch Name", BatchName);
                    if GenJournalLine.Find('-') then begin
                        //GenJnlManagement.OpenJnl(BatchName, GenJournalLine, 0);
                        PAGE.Run(39, GenJournalLine);
                    end;
                end;
            }
            action("5.  Close Payroll Period")
            {
                Caption = '5. Close Payroll Period';
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Close Pay period";
            }


            action("6. Close Payroll Document")
            {
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = false;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to close payroll card?', true, false) = true then begin
                        Rec."Close Payroll" := true;
                        Rec.Modify;
                        Message('The payroll document period %1 has been closed.', Rec."Payroll Period");
                    end;
                end;
            }
            /*action("4. Send Employee Payslip")
            {
                Caption = '4. Send Employee Payslip';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Codeunit "Send Employee Payslip";
                Visible = false;
            }*/
            action("Send Payslips")
            {
                Caption = '7. Send Payslips';
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Send Payslips";
                Enabled = false;
            }
            action("Export Assignment Matrix")
            {
                Caption = 'Export Bulk Earnings and Deductions';
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportTransactionsReport.SetReportFilter(Rec."Payroll Period");
                    ExportTransactionsReport.Run();
                    /*PayProcessHeader.RESET;
                    PayProcessHeader.SETRANGE("Payroll Period", Rec."Payroll Period");
                    IF PayProcessHeader.FIND('-') THEN
                        REPORT.RUN(51525170, TRUE, FALSE, PayProcessHeader);*/
                end;
            }
            action("Import Assignment Matrix")
            {
                Caption = 'Import Bulk Earnings and Deductions';
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PayProcessHeader.RESET;
                    PayProcessHeader.SETRANGE("Payroll Period", Rec."Payroll Period");
                    IF PayProcessHeader.FIND('-') THEN
                        REPORT.RUN(51525235, TRUE, FALSE, PayProcessHeader);
                end;
            }
            action("Update Single Earning")
            {
                Caption = 'Update Single Earning';
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportSingleEarningReport.SetReportFilter(Rec."Payroll Period");
                    ExportSingleEarningReport.Run();
                end;
            }
            action("Update Single Deduction")
            {
                Caption = 'Update Single Deduction';
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ExportSingleDeductionReport.SetReportFilter(Rec."Payroll Period");
                    ExportSingleDeductionReport.Run();
                end;
            }
            action("Summarized Payroll Statistics")
            {
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    EmpRec: Record Employee;
                begin
                    EmpRec.Reset;
                    EmpRec.SetRange(EmpRec."Pay Period Filter", Rec."Payroll Period");
                    if EmpRec.Find('-') then begin
                        //EmpRec.Setrange("Payroll Country", LastPayrollCountry);
                        Commit();
                        REPORT.Run(REPORT::"Payroll-Statistics Summarized", true, true, EmpRec);
                    end;
                end;
            }
            action("Bank Pay Report")
            {
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    EmpRec: Record "Employee Period Bank Details"; //Employee
                    PayrollBankAdvice: Report "Payroll Bank Advice - Simp";
                begin
                    EmpRec.Reset;
                    //EmpRec.SetRange(EmpRec."Pay Period Filter", Rec."Payroll Period");
                    if EmpRec.Find('-') then begin
                        //EmpRec.Setrange("Payroll Country", LastPayrollCountry);
                        //Commit();
                        //REPORT.Run(REPORT::"Payroll Bank Advice - Simp", true, true, EmpRec);
                        PayrollBankAdvice.SetTableView(EmpRec);
                        PayrollBankAdvice.SetReportFilter(Rec."Payroll Period", '');
                        PayrollBankAdvice.Run();
                    end;
                end;
            }
            action("Payroll Variance Report")
            {
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    EmpRec: Record Employee;
                begin
                    EmpRec.Reset;
                    EmpRec.SetRange(EmpRec."Pay Period Filter", Rec."Payroll Period");
                    if EmpRec.Find('-') then begin
                        //EmpRec.Setrange("Payroll Country", LastPayrollCountry);
                        Commit();
                        REPORT.Run(REPORT::"Payroll Variance Report", true, true, EmpRec);
                    end;
                end;
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                    NotEditable: Boolean;
                begin
                    NotEditable := true;
                    if Rec.Status = Rec.Status::Open then
                        NotEditable := false;
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    //DocumentAttachmentDetails.SetFilters(NotEditable, Rec."Payroll Processing No");
                    DocumentAttachmentDetails.RunModal;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PayrollEditable := false;
        JournalTransEditable := false;
        if Rec.Status = Rec.Status::Approved then begin
            PayrollEditable := true;
            JournalTransEditable := true;
        end
    end;

    trigger OnOpenPage()
    begin
        CanEditCard := false;
        CanEditPaymentInfo := false;
        CanEditLeaveInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then begin
            CanEditCard := UserSetup."Can Edit Emp Card";
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
            CanEditLeaveInfo := UserSetup."Can Edit Leave Entitlement";
        end;

        if not CanEditPaymentInfo then
            Error('Apologies, but it seems you don''t have the necessary permissions to view this page.');
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        PayrollEditable: Boolean;
        JournalTransEditable: Boolean;
        GenJnlManagement: Codeunit GenJnlManagement;
        GenJournalLine: Record "Gen. Journal Line";
        BatchName: Code[20];
        PayProcessHeader: Record "Payroll Processing Header";
        PayrollRunReport: Report "Payroll Run";
        ExportTransactionsReport: Report "Export Earnings and Deductions";
        ExportSingleEarningReport: Report "Export Import Single Earning";
        ExportSingleDeductionReport: Report "Export Import Single Deduction";
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
}