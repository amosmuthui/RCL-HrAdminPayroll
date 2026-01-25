page 51525355 "Payment & Deductions"
{
    DataCaptionFields = "Employee No", Type, "Code";
    PageType = Card;
    SourceTable = "Assignment Matrix";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Employee No"; Rec."Employee No")
                {
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Visible = FALSE;
                }
                field(Country; Rec.Country)
                {

                }
                field("Code"; Rec.Code)
                {
                    /*trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec.Country = '' then
                            Error('Select country first');
                    end;*/

                    trigger OnValidate()
                    begin
                        /* IF Type=Type::Deduction THEN
                         BEGIN
                         IF Deductions.GET(Code) THEN
                         IF Deductions.Loan=TRUE THEN
                         ERROR('You cannot enter loans through this screen');
                         END; */

                    end;
                }
                field("Policy No./Loan No."; Rec."Policy No./Loan No.")
                {
                    Visible = false;
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    Visible = false;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    Visible = true;
                }
                field("Gratuity PAYE"; Rec."Gratuity PAYE")
                {
                    Visible = false;
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    Visible = false;
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    Visible = false;
                }
                field("Main Deduction Code"; Rec."Main Deduction Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Overtime Period"; Rec."Overtime Period")
                { }
                field("Overtime Hours"; Rec."Overtime Hours")
                { }
                field("Overtime Minutes"; Rec."Overtime Minutes")
                { }
                field("Basic Salary Code"; Rec."Basic Salary Code")
                {
                    Visible = false;
                }
                field("No. of Units"; Rec."No. of Units")
                {
                    Visible = false;
                }
                field(Frequency; Rec.Frequency)
                {
                    Visible = false;
                }
                field(CFPay; Rec.CFPay)
                {
                    Visible = false;
                }
                field("Period Repayment"; Rec."Period Repayment")
                {
                    Visible = false;
                }
                field("Earning Currency"; Rec."Earning Currency")
                {
                    Caption = 'Currency';
                }
                field("Amount Type"; Rec."Amount Type")
                {
                }
                field("Start Date"; Rec."Start Date")
                { }
                field("End Date"; Rec."End Date")
                { }
                field("Full Month Amount"; Rec."Full Month Amount")
                { }
                field("Net Amount"; Rec."Net Amount")
                {
                }
                field("Amount In FCY"; Rec."Amount In FCY")
                {
                    Caption = 'Amount(FCY)';

                    trigger OnValidate()
                    begin
                        if LoanTrans.CheckIfAnotherTransactionExistsExternal(Rec."Employee No", Rec.Code, Rec.Country) then
                            Error('There is already an existing installment transaction for this deduction. If you want to add an amount, kindly go to installment deductions and add a new one!');
                        Rec."Manual Entry" := true;
                    end;
                }
                field(Amount; Rec.Amount)
                {

                    trigger OnValidate()
                    begin
                        if LoanTrans.CheckIfAnotherTransactionExistsExternal(Rec."Employee No", Rec.Code, Rec.Country) then
                            Error('There is already an existing installment transaction for this deduction. If you want to add an amount, kindly go to installment deductions and add a new one!');
                        Rec."Manual Entry" := true;
                    end;
                }
                field("Employee Voluntary"; Rec."Employee Voluntary")
                {
                    Visible = false;
                }
                field("Voluntary Percentage"; Rec."Voluntary Percentage")
                {
                    Visible = false;
                }
                field("Outstanding Amount"; Rec."Outstanding Amount")
                {
                    Visible = false;
                }
                field("Employer Amount"; Rec."Employer Amount")
                {
                }
                field("Next Period Entry"; Rec."Next Period Entry")
                {
                }
                field("Block Employee Contribution"; Rec."Block Employee Contribution")
                {
                    Visible = false;
                }
                field("Block Employer Contribution"; Rec."Block Employer Contribution")
                {
                    Visible = false;
                }
                field("Opening Balance Company"; Rec."Opening Balance Company")
                {
                }
                field("Opening Balance"; Rec."Opening Balance")
                {
                    Visible = true;
                }
                field("Loan Balance"; Rec."Loan Balance")
                { }
                field(Cost; Rec.Cost)
                {
                }
                field("Loan Repay"; Rec."Loan Repay")
                {
                    Visible = false;
                }
                field("Non-Cash Benefit"; Rec."Non-Cash Benefit")
                {
                    Visible = false;
                }
                field("Tax Deductible"; Rec."Tax Deductible")
                {
                }
                field(Taxable; Rec.Taxable)
                {
                    Visible = true;
                }
                field("Tax Relief"; Rec."Tax Relief")
                {
                }
                field(Retirement; Rec.Retirement)
                {
                }
                field(Closed; Rec.Closed)
                {
                    Editable = false;
                    Visible = true;
                }
                field("Taxable amount"; Rec."Taxable amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Quarters; Rec.Quarters)
                {
                    Visible = false;
                }
                field("Loan Interest"; Rec."Loan Interest")
                {
                    Visible = false;
                }
                field("Interest Amount"; Rec."Interest Amount")
                {
                    Visible = false;
                }
                field("Normal Earnings"; Rec."Normal Earnings")
                {
                }
                field("Insurance Code"; Rec."Insurance Code")
                {
                }
                field("Do Not Deduct"; Rec."Do Not Deduct")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        /*  IF Type=Type::Deduction THEN
          BEGIN
          IF Deductions.GET(Code) THEN
          IF Deductions.Loan=TRUE THEN
          ERROR('You cannot delete loans through this screen');
          END;*/

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        /* IF Type=Type::Deduction THEN
         BEGIN
         IF Deductions.GET(Code) THEN
         IF Deductions.Loan=TRUE THEN
         ERROR('You cannot enter loans through this screen');
         END;*/

    end;

    trigger OnModifyRecord(): Boolean
    begin
        if Rec.Type = Rec.Type::Deduction then begin
            if Deductions.Get(Rec.Code) then
                ;
            //IF Deductions.Loan=TRUE THEN
            //ERROR('You cannot modify loans through this screen');
        end;
    end;

    var
        //GetGroup: Codeunit "Payment- Post";
        GroupCode: Code[20];
        CUser: Code[20];
        Deductions: Record Deductions;
        LoanTrans: Record "Loans transactions";
}