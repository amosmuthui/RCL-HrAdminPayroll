table 51525505 "Loan Repayments"
{
    Caption = 'Loan Repayments';
    DataClassification = ToBeClassified;
    LookupPageId = "Loan Repayments";
    DrillDownPageId = "Loan Repayments";

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            Caption = 'Loan No.';
            TableRelation = "Loans transactions".No;
        }
        field(2; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
            TableRelation = "Payroll Period"."Starting Date";
        }
        field(3; "Amount Deducted"; Decimal)
        {
            Caption = 'Amount Deducted';
        }
        field(4; "Oustanding Balance"; Decimal)
        {
            Caption = 'Oustanding Balance';
        }
        field(5; Closed; Boolean)
        {

        }
    }
    keys
    {
        key(PK; "Loan No.", "Payroll Period")
        {
            Clustered = true;
        }
    }
}