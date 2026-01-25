table 51525503 "Payroll Approval"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Code <> xRec.Code then begin
                    PaySet.Reset;
                    //PaySet.SetFilter("Approval Nos", '<>%1', '');
                    if PaySet.FindFirst then
                        //NoSeriesMgt.TestManual(PaySet."Approval Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Payroll Period"; Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll Period"."Starting Date";

            trigger OnValidate()
            begin
                Name := Format("Payroll Period", 0, '<Month Text> <Year4>');
                //if Status = Status::Open then
                //Factry.FnCreatePayrollApproval(Code, "Payroll Period");
            end;
        }
        field(3; Name; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(7; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Total Earnings"; Decimal)
        {
            CalcFormula = Sum("Payroll Approval Transactions".Amount WHERE(Type = CONST(Earning),
                                                                            "Non Cash" = CONST(false),
                                                                            Code = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(9; "Total Deductions"; Decimal)
        {
            CalcFormula = Sum("Payroll Approval Transactions".Amount WHERE(Type = CONST(Deduction),
                                                                            Code = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(10; "Net Pay"; Decimal)
        {
            CalcFormula = Sum("Payroll Approval Transactions".Amount WHERE(Code = FIELD(Code),
                                                                            "Non Cash" = CONST(false)));
            FieldClass = FlowField;
        }
        field(11; "Total Employer Amount"; Decimal)
        {
            CalcFormula = Sum("Payroll Approval Transactions"."Employer Amount" WHERE(Code = FIELD(Code),
                                                                                       Type = CONST(Deduction)));
            FieldClass = FlowField;
        }
        field(12; "Current Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "No of Approvers"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Final Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if Code = '' then begin
            PaySet.Reset;
            //PaySet.SetFilter("Approval Nos", '<>%1', '');
            if PaySet.FindFirst then begin
                //PaySet.TestField("Approval Nos");
                //NoSeriesMgt.InitSeries(PaySet."Approval Nos", xRec."No. Series", 0D, Code, "No. Series");
            end;
        end;
        "Created By" := UserId;
        "Date Created" := Today;
    end;

    var
        PaySet: Record "Payroll Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Trans: Record "Payroll Approval Transactions";
        Factry: Codeunit Factory;
}
