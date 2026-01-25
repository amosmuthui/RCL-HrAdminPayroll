table 51525466 "Loan Top-up"
{
    //DrillDownPageID = "Asset Transfer Header-Receive";
    //LookupPageID = "Asset Transfer Header-Receive";

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            TableRelation = "Loan Application";
        }
        field(2; "Line No"; Integer)
        {
        }
        field(3; Description; Text[100])
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; Installment; Integer)
        {

            trigger OnValidate()
            begin
                TestField(Amount);
                LoanApp.Reset;
                LoanApp.SetRange(LoanApp."Loan No", "Loan No");
                if LoanApp.FindSet then begin
                    if LoanType.Get(LoanApp."Loan Product Type") then begin
                        if LoanType."Interest Calculation Method" = LoanType."Interest Calculation Method"::"Reducing Balance" then begin
                            Repayment := Round((LoanType."Interest Rate" / 12 / 100) / (1 - Power((1 + (LoanType."Interest Rate" / 12 / 100)), -Installment)) * Amount, 0.0001, '>');

                        end;
                    end;
                end;
            end;
        }
        field(6; Repayment; Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Installment);
            end;
        }
        field(7; Interest; Decimal)
        {
        }
        field(8; "Payroll Period"; Date)
        {
            TableRelation = "Payroll Period"."Starting Date" WHERE(Closed = CONST(false));

            trigger OnValidate()
            begin

                NewSchedule.Reset;
                LoanApp.Reset;
                LoanApp.SetFilter("Loan No", "Loan No");
                if LoanApp.FindSet then begin
                    NewSchedule.SetFilter("Loan No", LoanApp."Loan No");
                    NewSchedule.SetFilter("Employee No", LoanApp."Employee No");
                    NewSchedule.SetFilter("Repayment Date", '%1', CalcDate('-1M', "Payroll Period"));
                    NewSchedule.SetFilter("Loan Category", LoanApp."Loan Product Type");
                    if NewSchedule.FindSet then begin
                        "Current Balance" := NewSchedule."Remaining Debt";
                    end;
                end;
            end;
        }
        field(9; "Same Repayment Amount"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Same Repayment Amount" = true then begin
                    "Different Repayment Amount" := false;
                end;
                if "Same Repayment Amount" = false then begin
                    "Different Repayment Amount" := true;
                end;
            end;
        }
        field(10; "Different Repayment Amount"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Different Repayment Amount" = false then begin
                    "Same Repayment Amount" := true;
                end;
                if "Different Repayment Amount" = true then begin
                    "Same Repayment Amount" := false;
                end;
            end;
        }
        field(11; "Current Balance"; Decimal)
        {
        }
        field(12; Applied; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No", "Line No")
        {
            Clustered = true;
        }
        key(Key2; "Loan No", "Payroll Period")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Applied = true then begin
            //ERROR('You cannot Delete an Applied TopUp!');
        end;
    end;

    trigger OnModify()
    begin
        if Applied = true then begin
            //ERROR('You cannot Modify an Applied TopUp!');
        end;
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        HRsetup: Record "Human Resources Setup";
        LoanType: Record "Loan Product Type";
        EmpRec: Record Employee;
        PeriodInterest: Decimal;
        Installments: Decimal;
        NewSchedule: Record "Repayment Schedule";
        RunningDate: Date;
        Interest: Decimal;
        FlatPeriodInterest: Decimal;
        FlatRateTotalInterest: Decimal;
        FlatPeriodInterval: Code[10];
        LineNoInt: Integer;
        RemainingPrincipalAmountDec: Decimal;
        //AssMatrix: Record "Staff Ledger Entry";
        LoanApp: Record "Loan Application";
}