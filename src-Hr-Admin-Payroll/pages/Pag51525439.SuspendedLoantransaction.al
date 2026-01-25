page 51525439 "Suspended Loan transaction"
{
    ApplicationArea = All;
    Caption = 'Suspended Installment Deductions';
    DataCaptionFields = Employee, Name;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Loans transactions";
    Editable = true;
    DeleteAllowed = true;
    SourceTableView = WHERE("Start Deducting" = CONST(true), Suspend = CONST(true), cleared = CONST(false));

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
                    Caption = 'Outstanding Amount';
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    Caption = 'Amount Paid + Interest';
                    Editable = false;
                }
                field("Interest Repaid to Date"; Rec."Interest Repaid to Date")
                {
                }
                field("Opening Balance"; Rec."Opening Balance")
                { }
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
            /*action("Restart Deductions")
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
                        if not confirm('Are you sure you want to restart the selected deductions?') then
                            Error('Process aborted successfully!');
                        LoanTrans.ModifyAll("Stop/Pause", false);
                        Message('Selected transaction(s) restarted successfully!');
                        CurrPage.close();
                    end else
                        Error('Nothing was selected!');
                end;
            }*/
        }
    }

    var
        Loans: Record "Loans transactions";
        Emp: Record Employee;
        Journal: Record "Gen. Journal Line";
}