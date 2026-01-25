page 51525440 "Cleared Loan transaction"
{
    ApplicationArea = All;
    Caption = 'Cleared Installment Deductions';
    DataCaptionFields = Employee, Name;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Loans transactions";
    Editable = false;
    DeleteAllowed = false;
    SourceTableView = WHERE("Start Deducting" = CONST(true), cleared = CONST(true));

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
                    Caption = 'Outstanding Amount';
                }
                field("Interest Repaid to Date"; Rec."Interest Repaid to Date")
                {
                    Visible = false;
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
            action("Start Deducting")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    LoanTrans: Record "Loans transactions";
                begin
                    CurrPage.SetSelectionFilter(LoanTrans);
                    if LoanTrans.Find('-') then begin
                        if not confirm('Are you sure you want to kickstart the selected deductions? No editing is allowed once you start') then
                            Error('Process aborted successfully!');
                        LoanTrans.ModifyAll("Start Deducting", true);
                        Message('Selected transaction(s) started successfully!');
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