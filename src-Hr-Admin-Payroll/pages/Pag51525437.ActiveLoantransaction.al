page 51525437 "Active Loan transaction"
{
    ApplicationArea = All;
    Caption = 'Active Installment Deductions';
    DataCaptionFields = Employee, Name;
    PageType = List;
    UsageCategory = Lists;
    Editable = true;
    DeleteAllowed = false;
    SourceTable = "Loans transactions";
    SourceTableView = WHERE("Start Deducting" = CONST(true), Suspend = CONST(false), Pause = CONST(false), cleared = CONST(false));

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

                field("Amount Paid"; Rec."Amount Paid")
                {
                    Caption = 'Amount Paid + Interest';
                    Editable = false;
                }
                field("""Loan Amount""+""Amount Paid""+ABS(""Interest Repaid to Date"")"; Rec."Loan Amount" - Rec."Amount Paid" - Abs(Rec."Interest Repaid to Date") - Abs(Rec."Initial Paid Amount"))
                {
                    Caption = 'Outstanding Balance';
                }
                field("Interest Repaid to Date"; Rec."Interest Repaid to Date")
                {
                    Visible = false;
                }
                field("Last Installment Period"; Rec.LastInstallmentPeriod())
                {
                    Visible = true;
                }
                field("Opening Balance"; Rec."Opening Balance")
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
            action("Pause Deduction")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LoanTrans: Record "Loans transactions";
                begin
                    CurrPage.SetSelectionFilter(LoanTrans);
                    if LoanTrans.Find('-') then begin
                        if not confirm('Are you sure you want to pause the selected deductions? You can restart later.') then
                            Error('Process aborted successfully!');
                        LoanTrans.ModifyAll(Pause, true);
                        Message('Selected transaction(s) paused successfully!');
                        CurrPage.close();
                    end else
                        Error('Nothing was selected!');
                end;
            }
            action("Suspend Deduction")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LoanTrans: Record "Loans transactions";
                begin
                    CurrPage.SetSelectionFilter(LoanTrans);
                    if LoanTrans.Find('-') then begin
                        if not confirm('Are you sure you want to suspend the selected deductions? Once you suspend a transaction you cannot restart it again!') then
                            Error('Process aborted successfully!');
                        LoanTrans.ModifyAll(Suspend, true);
                        Message('Selected transaction(s) suspended successfully!');
                        CurrPage.close();
                    end else
                        Error('Nothing was selected!');
                end;
            }
            action("Clear Deduction")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LoanTrans: Record "Loans transactions";
                begin
                    CurrPage.SetSelectionFilter(LoanTrans);
                    if LoanTrans.Find('-') then begin
                        if not confirm('Are you sure you want to mark the selected deduction(s) as cleared?') then
                            Error('Process aborted successfully!');
                        LoanTrans.ModifyAll(Cleared, true);
                        Message('Selected transaction(s) cleared successfully!');
                        CurrPage.close();
                    end else
                        Error('Nothing was selected!');
                end;
            }
        }
    }

    var
        Loans: Record "Loans transactions";
        Emp: Record Employee;
        Journal: Record "Gen. Journal Line";
}