table 51525350 "Loans transactions"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
            TableRelation = Deductions WHERE(Country = field(Country), "Calculation Method" = const("Flat amount"));

            trigger OnValidate()
            begin
                Deductions.Reset();
                Deductions.SetRange(Country, Country);
                Deductions.SetRange(Code, Code);
                if Deductions.FindFirst() then begin
                    Name := Deductions.Description;
                    "Maximum limit" := Deductions."Maximum Amount";
                    "Repayment Grace period" := Deductions."Grace period";
                    "Repayment Period" := Deductions."Repayment Period";
                    "Initial Paid Amount" := 0;
                end;
                if EmpRec.Get(Employee) then
                    "Debtor Code" := EmpRec."Customer Code";
            end;
        }
        field(2; Name; Text[30])
        {
        }
        field(3; Employee; Code[20])
        {
            Caption = 'WB No.';
            TableRelation = Employee;
            trigger OnValidate()
            begin
                "Employee Name" := '';
                if Employee <> '' then begin
                    EmpRec.Reset();
                    EmpRec.SetRange("No.", Employee);
                    if EmpRec.FindFirst() then
                        "Employee Name" := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
                end;
            end;
        }
        field(4; "Maximum limit"; Decimal)
        {
        }
        field(5; "Loan Amount"; Decimal)
        {
            //Caption = 'Initial Amount';

            trigger OnValidate()
            begin
                Validate("No. of Repayments Period");
                "Opening Balance" := "Loan Amount" - "Initial Paid Amount";
            end;
        }
        field(6; "Repayment Grace period"; DateFormula)
        {
        }
        field(7; "Repayment Period"; DateFormula)
        {
        }
        field(8; "Outstanding Amount"; Decimal)
        {
        }
        field(9; "Amount Paid"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Loan Repayments"."Amount Deducted" where("Loan No." = field(No), Closed = const(true)));
            /*CalcFormula = Sum("Assignment Matrix"."Period Repayment" WHERE("Employee No" = FIELD(Employee),
                                                                Type = CONST(Deduction),
                                                                Code = FIELD(Code),
                                                                "Loan No." = FIELD(No),
                                                                Closed = const(true),
                                                                "Payroll Period" = FIELD("Date Filter")));*/
        }
        field(10; "Period Repayments"; Decimal)
        {
            Caption = 'Installment Amount';
            trigger OnValidate()
            begin
                if ("Period Repayments" <> 0) and ("No. of Repayments Period" = 0) then begin
                    "No. of Repayments Period" := Round("Loan Amount" / "Period Repayments", 1);
                end;
            end;
        }
        field(11; "Repayment Begin Date"; Date)
        {
        }
        field(12; "Repayment End Date"; Date)
        {
        }
        field(13; "Loan Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate()
            begin
                "Repayment Begin Date" := CalcDate("Repayment Grace period", "Loan Date");
                "Repayment End Date" := CalcDate("Repayment Period", "Repayment Begin Date");
            end;
        }
        field(14; "No. of Repayments Period"; Integer)
        {
            Caption = 'No. of Installments';
            InitValue = 1;

            trigger OnValidate()
            begin
                if "No. of Repayments Period" <> 0 then
                    "Period Repayments" := "Loan Amount" / "No. of Repayments Period";
                "Period Repayments" := Round("Period Repayments", 1, '>');
            end;
        }
        field(15; "Interest Rate"; Decimal)
        {
        }
        field(16; "Opening Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Balance';
        }
        field(17; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll Period";
        }
        field(18; "Interest Type"; Option)
        {
            OptionMembers = Compound,Simple,"Simple Reducing Balance";
        }
        field(19; "Interest Repaid to Date"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix"."Interest Amount" WHERE("Employee No" = FIELD(Employee),
                                                                           Type = CONST(Deduction),
                                                                           Code = FIELD(Code),
                                                                            "Loan No." = FIELD(No),
                                                                            Closed = const(true),
                                                                            "Payroll Period" = FIELD(UPPERLIMIT("Date Filter"))));
            FieldClass = FlowField;
        }
        field(20; "Cumm. Period Repayments"; Decimal)
        {
            Caption = 'Cumm. Repayments';
            CalcFormula = sum("Loan Repayments"."Amount Deducted" where("Loan No." = field(No), Closed = const(true)));
            /*CalcFormula = Sum("Assignment Matrix"."Period Repayment" WHERE("Employee No" = FIELD(Employee),//Period Repayment
                                                                            Type = CONST(Deduction),
                                                                            Code = FIELD(Code),
                                                                            "Loan No." = FIELD(No),
                                                                            Closed = const(true),
                                                                            "Payroll Period" = FIELD("Date Filter")));*/
            FieldClass = FlowField;
            Editable = false;
        }
        field(21; "Bal Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(22; "Bal Account No"; Code[10])
        {
            TableRelation = IF ("Bal Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(23; "Interest Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(24; "Debt Updated"; Boolean)
        {
        }
        field(25; "Debtor Code"; Code[20])
        {
            TableRelation = Customer;
        }
        field(26; "External Interest Rate"; Decimal)
        {
        }
        field(27; "Cumm. Period Repayments1"; Decimal)
        {
            CalcFormula = sum("Loan Repayments"."Amount Deducted" where("Loan No." = field(No), Closed = const(true)));
            /*CalcFormula = Sum("Assignment Matrix"."Period Repayment" WHERE("Employee No" = FIELD(Employee),
                                                                            Type = CONST(Deduction),
                                                                            Code = FIELD(Code),
                                                                            "Loan No." = FIELD(No),
                                                                            "Payroll Period" = FIELD("Date Filter"),
                                                                            Closed = CONST(true)));*/
            FieldClass = FlowField;
            Editable = false;
        }
        field(28; No; Code[20])
        {
            Editable = false;
        }
        field(29; Country; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(30; "Country Currency"; Code[50])
        {
            Editable = false;
            TableRelation = "Currency";
        }
        field(31; "Deduction Currency"; Code[50])
        {
            TableRelation = "Currency";
            trigger OnValidate()
            begin
                //Validate("Amount In FCY");
            end;
        }
        field(32; "Exchange Rate Type"; Option)
        {
            Caption = 'Exchange Rate Used';
            OptionMembers = Initial,Current;
        }
        field(33; "Start Deducting"; Boolean)
        {
            Editable = false;
        }
        field(34; "Employee Name"; Text[240])
        {
            Editable = false;
        }
        field(35; Pause; Boolean)
        {
            Editable = false;
        }
        field(36; Cleared; Boolean)
        {
            Editable = false;
        }
        field(37; "Initial Paid Amount"; Decimal)
        {
            Caption = 'Initially Paid Amount';
        }
        field(38; Suspend; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
            SumIndexFields = "Loan Amount";
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        if No = '' then begin
            LoanTrans.Reset();
            if LoanTrans.FindLast then begin
                No := IncStr(LoanTrans.No)
            end else begin
                No := 'LN00001';
            end;
        end;
    end;

    /*trigger OnModify()
    begin
        if "Start Deducting" then
            Error('You cannot modify an none-open installment deduction!')
    end;*/

    trigger OnDelete()
    begin
        if "Amount Paid" <> 0 then
            Error('Cannot delete a loan with repayments');
    end;

    var
        Deductions: Record Deductions;
        EmpRec: Record Employee;
        LoanTrans: Record "Loans transactions";

    procedure CheckIfAnotherTransactionExists(): Boolean
    var
        AnotherExists: Boolean;
    begin
        AnotherExists := false;
        LoanTrans.Reset();
        LoanTrans.SetRange(Employee, Employee);
        LoanTrans.SetRange(Code, Code);
        LoanTrans.SetRange(Country, Country);
        LoanTrans.SetRange("Start Deducting", true);
        LoanTrans.SetRange(Pause, false);
        LoanTrans.SetRange(Suspend, false);
        LoanTrans.SetRange(Cleared, false);
        if LoanTrans.Find('-') then
            AnotherExists := false;
        exit(AnotherExists);
    end;

    procedure CheckIfAnotherTransactionExistsExternal(EmpNo: Code[20]; TransCode: Code[20]; TransCountry: Code[100]): Boolean
    var
        AnotherExists: Boolean;
    begin
        AnotherExists := false;
        LoanTrans.Reset();
        LoanTrans.SetRange(Employee, EmpNo);
        LoanTrans.SetRange(Code, TransCode);
        LoanTrans.SetRange(Country, TransCountry);
        LoanTrans.SetRange("Start Deducting", true);
        LoanTrans.SetRange(Pause, false);
        LoanTrans.SetRange(Suspend, false);
        LoanTrans.SetRange(Cleared, false);
        if LoanTrans.Find('-') then
            AnotherExists := true;
        exit(AnotherExists);
    end;

    procedure LastInstallmentPeriod(): Text
    var
        OustandingBalance: Decimal;
        CurrentPayrollPeriod: Date;
        PayPeriods: Record "Payroll Period";
        LastInstDate: Date;
        LastInstPeriod: Text[240];
        ApproxRemainingRepayments: Decimal;
    begin
        LastInstPeriod := '';
        CurrentPayrollPeriod := 0D;
        PayPeriods.Reset();
        PayPeriods.SetRange(Closed, false);
        if PayPeriods.FindFirst() then
            CurrentPayrollPeriod := PayPeriods."Starting Date";
        if "Loan Date" > CurrentPayrollPeriod then
            CurrentPayrollPeriod := "Loan Date";

        CalcFields("Amount Paid", "Interest Repaid to Date");
        OustandingBalance := "Loan Amount" - "Amount Paid" - Abs("Interest Repaid to Date") - Abs("Initial Paid Amount");
        ApproxRemainingRepayments := 0;
        if ("Period Repayments" > 0) and (OustandingBalance > 0) then
            ApproxRemainingRepayments := (Round(OustandingBalance / "Period Repayments", 1, '>')) - 1;
        //if ApproxRemainingRepayments > 0 then
        //begin
        LastInstDate := CalcDate(format(ApproxRemainingRepayments) + 'M', CurrentPayrollPeriod);
        LastInstPeriod := Format(LastInstDate, 0, '<Month Text> <Year4>');
        //end;
        exit(LastInstPeriod);
    end;
}