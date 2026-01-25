page 51525436 "Loan transaction"
{
    ApplicationArea = All;
    Caption = 'Open Installment Deductions';
    DataCaptionFields = Employee, Name;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Loans transactions";
    SourceTableView = WHERE("Start Deducting" = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(No; Rec.No)
                { }
                field(Country; Rec.Country)
                { }
                field("Code"; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Employee; Rec.Employee)
                {
                }
                field("Employee Name"; Rec."Employee Name")
                { }
                field("Deduction Currency"; Rec."Deduction Currency")
                { }
                field("Loan Amount"; Rec."Loan Amount")
                {
                }
                field("Initial Paid Amount"; Rec."Initial Paid Amount")
                {
                }
                field("Exchange Rate Type"; Rec."Exchange Rate Type")
                { }
                field("Loan Date"; Rec."Loan Date")
                {
                }
                field("Interest Type"; Rec."Interest Type")
                {
                    Visible = false;
                }
                field("Debtor Code"; Rec."Debtor Code")
                {
                    Visible = false;
                    Editable = false;
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                }
                field("No. of Repayments Period"; Rec."No. of Repayments Period")
                {
                }
                field("Period Repayments"; Rec."Period Repayments")
                {
                }
                field("Cumm. Period Repayments"; Rec."Cumm. Period Repayments")
                {
                }
                field("Repayment Grace period"; Rec."Repayment Grace period")
                {
                    Visible = false;
                }
                field("Repayment Period"; Rec."Repayment Period")
                {
                    Visible = false;
                }
                field("Repayment Begin Date"; Rec."Repayment Begin Date")
                {
                    Visible = false;
                }
                field("Repayment End Date"; Rec."Repayment End Date")
                {
                    Visible = false;
                }
                field("Bal Account Type"; Rec."Bal Account Type")
                {
                    Visible = false;
                }
                field("Bal Account No"; Rec."Bal Account No")
                {
                    Visible = false;
                }
                field("Interest Account"; Rec."Interest Account")
                {
                    Visible = false;
                }
                field("""Loan Amount""+""Amount Paid""+ABS(""Interest Repaid to Date"")"; Rec."Loan Amount" - Rec."Amount Paid" - Abs(Rec."Interest Repaid to Date") - Abs(Rec."Initial Paid Amount"))
                {
                    Caption = 'Outstanding Balance';
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    Caption = 'Amount Paid + Interest';
                    Editable = false;
                    Visible = false;
                }
                field("Interest Repaid to Date"; Rec."Interest Repaid to Date")
                {
                    Visible = false;
                }
                field("Maximum limit"; Rec."Maximum limit")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Start Deducting")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LoanTrans: Record "Loans transactions";
                begin
                    CurrPage.SetSelectionFilter(LoanTrans);
                    LoanTrans.SetFilter("Loan date", '<>%1', 0D);
                    LoanTrans.SetFilter("Loan Amount", '>%1', 0);
                    if LoanTrans.Find('-') then begin
                        if not confirm('Are you sure you want to kickstart the selected deductions? No editing is allowed once you start') then
                            Error('Process aborted successfully!');
                        //LoanTrans.ModifyAll("Start Deducting", true);
                        repeat
                            if LoanTrans.CheckIfAnotherTransactionExists() then begin
                                if Confirm('There exists another installment deduction for ' + LoanTrans."Employee Name" + ' - ' + LoanTrans.Code + ' - ' + LoanTrans.Name + '. Do you want to add this?') then begin
                                    LoanTrans."Start Deducting" := true;
                                    LoanTrans.Modify();
                                end;
                            end else begin
                                LoanTrans."Start Deducting" := true;
                                LoanTrans.Modify();
                            end;
                        until LoanTrans.Next() = 0;

                        Message('Selected and confirmed transaction(s) started successfully!');
                        CurrPage.close();
                    end else
                        Error('Nothing was selected! Ensure you set start date and loan amount');
                end;
            }
            action(ExportImportLoans)
            {
                Caption = 'Export/Import Loans';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "ExIm Installment Deductions";

                trigger OnAction()
                begin
                    /*Filename:='';
                    HumanResourcesSetup.GET;
                    Filename:= HumanResourcesSetup."Path to Save Employee Data"+'EmployeeImportantDates.csv';
                    
                    EmployeeImportantDatesFile.CREATE(Filename);
                    EmployeeImportantDatesFile.CREATEOUTSTREAM(EmployeeImportantDatesFileStream);
                    XMLPORT.EXPORT(50001,EmployeeImportantDatesFileStream);
                    EmployeeImportantDatesFile.CLOSE; */

                end;
            }
        }
    }

    var
        Loans: Record "Loans transactions";
        Emp: Record Employee;
        Journal: Record "Gen. Journal Line";
}