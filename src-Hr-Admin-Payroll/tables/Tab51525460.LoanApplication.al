table 51525460 "Loan Application"
{
    // // Flat Rate
    // LineNoInt := 1;
    // //IF LoanTypeRec."Interest Calculation Method"=LoanTypeRec."Interest Calculation Method"::"Flat Rate" THEN
    // IF "Interest Calculation Method"="Interest Calculation Method"::"Flat Rate" THEN
    // BEGIN
    // 
    // //
    // EVALUATE(GP,FORMAT("Grace Period"));
    // //
    // RemainingPrincipalAmountDec :="Approved Amount";
    // IF "Pays Interest During GP"=FALSE THEN BEGIN
    //  IF GP<>'' THEN
    //   RunningDate:=CALCDATE("Grace Period",RunningDate)
    //  ELSE
    //   RunningDate:=CALCDATE("Instalment Period",RunningDate);
    // END ELSE
    //   RunningDate:=CALCDATE("Instalment Period",RunningDate);
    // IF LineNoInt <Installments+1 THEN BEGIN
    //  REPEAT
    //   NewSchedule."Instalment No":= LineNoInt;
    //   NewSchedule."Member No." :="Client Code";
    //   NewSchedule."Loan No." :="Loan  No.";
    //   NewSchedule."Repayment Date" := RunningDate;
    //   NewSchedule."Monthly Interest" := "Flat rate Interest";
    //   NewSchedule."Monthly Repayment":=Repayment;
    //   NewSchedule."Loan Category":="Loan product type";
    //   NewSchedule."Loan Amount":="Approved Amount";
    //   NewSchedule."Group Code":="Group Code";
    //   NewSchedule."Loan Application No":="Loan  No.";
    //   NewSchedule."Principal Repayment" := "Flat Rate Principal";
    //   IF Installments=1 THEN
    //    RemainingPrincipalAmountDec:="Approved Amount"-Repayment
    //   ELSE
    //    RemainingPrincipalAmountDec:=RemainingPrincipalAmountDec-Repayment;
    // 
    //   NewSchedule."Remaining Debt" :=RemainingPrincipalAmountDec;
    // 
    //   NewSchedule."Instalment No" := LineNoInt;
    //   EVALUATE(ScheduleCode, FORMAT(LineNoInt));
    //   NewSchedule."Repayment Code":=ScheduleCode;
    // 
    //   LineNoInt:=LineNoInt+1;
    //    IF InstalmentDays<>0 THEN
    //     RunningDate:=RunningDate+InstalmentDays
    //    ELSE
    //     RunningDate:=CALCDATE("Instalment Period",RunningDate);
    //  NewSchedule.INSERT;
    //  UNTIL LineNoInt>Installments
    //  END;
    // 
    // END;

    DrillDownPageID = "Pay Periods";
    LookupPageID = "Pay Periods";

    fields
    {
        field(1; "Loan No"; Code[20])
        {

            trigger OnValidate()
            begin
                if "Loan No" <> xRec."Loan No" then begin
                    if LoanType.Get("Loan Product Type") then begin
                        NoSeriesMgt.TestManual(LoanType."Loan No Series");
                        "No Series" := '';
                    end;
                end;
            end;
        }
        field(2; "Application Date"; Date)
        {
        }
        field(3; "Loan Product Type"; Code[20])
        {
            TableRelation = "Loan Product Type".Code;

            trigger OnValidate()
            begin
                if LoanType.Get("Loan Product Type") then begin
                    "Interest Deduction Code" := LoanType."Interest Deduction Code";
                    "Deduction Code" := LoanType."Deduction Code";
                    Description := LoanType.Description;
                    "Interest Rate" := LoanType."Interest Rate";
                    "Interest Calculation Method" := LoanType."Interest Calculation Method";

                end;
            end;
        }
        field(4; "Amount Requested"; Decimal)
        {
        }
        field(5; "Approved Amount"; Decimal)
        {

            trigger OnValidate()
            begin

                // My amortization formula.....MIKE
                Denominator := 0;
                Numerator := 0;
                Repayment := 0;

                if "Interest Calculation Method" = "Interest Calculation Method"::" " then
                    Error('Interest Calculation method can only be Balance');
                Installments := Instalment;
                if Installments <= 0 then
                    Error('Number of installments must be greater than Zero!');

                if LoanType.Get("Loan Product Type") then begin
                    if "Interest Calculation Method" = "Interest Calculation Method"::"Reducing Balance" then begin
                        Repayment := Round(("Interest Rate" / 12 / 100) / (1 - Power((1 + ("Interest Rate" / 12 / 100)),
                                      -Instalment)) * "Approved Amount", 0.0001, '>');

                    end;
                    if "Interest Calculation Method" = "Interest Calculation Method"::"Sacco Reducing Balance" then begin
                        Repayment := Round(("Approved Amount" / Installments), 0.01, '>');
                    end;
                end;

                //Sacco Loan Reducing balance
                //Principal Repayment is calculated as straight line
                //Monthly Interest is based on the balance
                //Monthly Repayment is based on the principal repayment + monthly interest
                if LoanType.Get("Loan Product Type") then begin
                    if "Interest Calculation Method" = "Interest Calculation Method"::Amortized then begin
                        Numerator := ("Approved Amount" * ("Interest Rate" / 12));
                        Denominator := (1 - (Power((1 + ("Interest Rate" / 12)), -Instalment)));
                        Repayment := Round((Numerator / Denominator), 0.0001, '>');
                    end;
                end;

                if "Interest Calculation Method" = "Interest Calculation Method"::"Flat Rate" then begin
                    if LoanType.Get("Loan Product Type") then begin
                        if LoanType.Rounding = LoanType.Rounding::Up then
                            RoundingPrecision := '>'
                        else
                            if
                        LoanType.Rounding = LoanType.Rounding::Nearest then
                                RoundingPrecision := '='
                            else
                                if
                            LoanType.Rounding = LoanType.Rounding::Down then
                                    RoundingPrecision := '<';


                        Repayment := Round(("Approved Amount" / Installments) + FlatRateCalc("Approved Amount", Interest), LoanType."Rounding Precision",
                                           RoundingPrecision);
                        "Flat Rate Interest" := Round(FlatRateCalc("Approved Amount", "Interest Rate"), LoanType."Rounding Precision", RoundingPrecision);
                        "Flat Rate Principal" := Repayment - "Flat Rate Interest";
                    end;
                end;


                "Approved Amount" := Abs("Approved Amount");
            end;
        }
        field(6; "Loan Status"; Option)
        {
            OptionCaption = 'Application,Being Processed,Rejected,Approved,Issued,Being Repaid,Repaid';
            OptionMembers = Application,"Being Processed",Rejected,Approved,Issued,"Being Repaid",Repaid;
        }
        field(7; "Issued Date"; Date)
        {
            TableRelation = "Payroll Period"."Starting Date";
        }
        field(8; Instalment; Integer)
        {

            trigger OnValidate()
            begin
                /*
                IF "Approved Amount"<>0 THEN
                BEGIN
                 IF LoanType.GET("Loan Product Type") THEN
                 BEGIN
                   IF "Interest Calculation Method" = "Interest Calculation Method"::"Reducing Balance" THEN
                   BEGIN
                    Repayment := ROUND("Approved Amount"/ Installments,0.0001,'>');
                   END;
                 END;
                END;
                */

            end;
        }
        field(9; Repayment; Decimal)
        {
        }
        field(10; "Flat Rate Principal"; Decimal)
        {
        }
        field(11; "Flat Rate Interest"; Decimal)
        {
        }
        field(12; "Interest Rate"; Decimal)
        {
        }
        field(13; "No Series"; Code[10])
        {
        }
        field(14; "Interest Calculation Method"; Option)
        {
            OptionCaption = ' ,Flat Rate,Reducing Balance,Amortized,Sacco Reducing Balance';
            OptionMembers = " ","Flat Rate","Reducing Balance",Amortized,"Sacco Reducing Balance";
        }
        field(15; "Employee No"; Code[20])
        {
            TableRelation = Employee."No." WHERE(Status = CONST(Active));

            trigger OnValidate()
            begin
                EmpRec.Reset;
                if EmpRec.Get("Employee No") then
                    "Employee Name" := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
            end;
        }
        field(16; "Employee Name"; Text[100])
        {
        }
        field(17; "Payroll Group"; Code[20])
        {
            TableRelation = "Staff Posting Group".Code;
        }
        field(18; Description; Text[80])
        {
        }
        field(19; "Opening Loan"; Boolean)
        {
            Editable = true;
        }
        field(20; "Total Repayment"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("Employee No"),
                                                                Type = CONST(Deduction),
                                                                Code = FIELD("Deduction Code"),
                                                                "Payroll Period" = FIELD(UPPERLIMIT("Date filter")),
                                                                "Reference No" = FIELD("Loan No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Date filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(22; "Period Repayment"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("Employee No"),
                                                                Type = CONST(Deduction),
                                                                Code = FIELD("Deduction Code"),
                                                                "Payroll Period" = FIELD(UPPERLIMIT("Date filter")),
                                                                "Reference No" = FIELD("Loan No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; Interest; Decimal)
        {
        }
        field(24; "Interest Imported"; Decimal)
        {
        }
        field(25; "principal imported"; Decimal)
        {
        }
        field(26; "Interest Rate Per"; Option)
        {
            OptionMembers = " ",Annum,Monthly;
        }
        field(27; "Reference No"; Code[50])
        {
        }
        field(28; "Interest Deduction Code"; Code[10])
        {
            TableRelation = Deductions;
        }
        field(29; "Deduction Code"; Code[10])
        {
            TableRelation = Deductions;
        }
        field(30; "Debtors Code"; Code[10])
        {
            TableRelation = Customer;
        }
        field(31; "Interest Amount"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("Employee No"),
                                                                Type = CONST(Deduction),
                                                                Code = FIELD("Interest Deduction Code"),
                                                                "Payroll Period" = FIELD(UPPERLIMIT("Date filter")),
                                                                "Reference No" = FIELD("Loan No")));
            FieldClass = FlowField;
        }
        field(32; "External Document No"; Code[20])
        {
        }
        field(33; Receipts; Decimal)
        {
            CalcFormula = Sum("Non Payroll Receipts".Amount WHERE("Loan No" = FIELD("Loan No"),
                                                                   "Payroll Period" = FIELD("Date filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "HELB No."; Code[50])
        {
        }
        field(35; "University Name"; Code[100])
        {
        }
        field(36; "Stop Loan"; Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                if "Stop Loan" then
                    Error('The loan is already stopped');
            end;
        }
        field(37; Select; Boolean)
        {
        }
        field(38; "Total Loan"; Decimal)
        {
            CalcFormula = Sum("Loan Top-up".Amount WHERE("Loan No" = FIELD("Loan No"),
                                                          "Payroll Period" = FIELD("Date filter")));
            FieldClass = FlowField;
        }
        field(39; StopagePeriod; Date)
        {
            TableRelation = "Payroll Period"."Starting Date";
        }
        field(40; Reason; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Loan No", "Loan Product Type")
        {
            Clustered = true;
        }
        key(Key2; "Payroll Group", "Loan Product Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Loan Status" = "Loan Status"::Issued then begin
            AssMatrix.Reset;
            AssMatrix.SetRange(AssMatrix."Employee No", "Loan No", AssMatrix."Reference No");
            AssMatrix.SetRange(AssMatrix.Closed, true);
            if AssMatrix.Find('-') then
                Error('Cannot delete loan already issued');
        end;
    end;

    trigger OnInsert()
    begin

        if "Loan No" = '' then begin
            if LoanType.Get("Loan Product Type") then begin
                LoanType.TestField(LoanType."Loan No Series");
                "Loan No" := NoSeriesMgt.GetNextNo(LoanType."Loan No Series");
                //NoSeriesMgt.InitSeries(LoanType."Loan No Series", xRec."No Series", 0D, "Loan No", "No Series");
            end;
        end
    end;

    trigger OnModify()
    begin
        AssMatrix.Reset;
        AssMatrix.SetRange(AssMatrix."Employee No", "Loan No", AssMatrix."Reference No");
        AssMatrix.SetRange(AssMatrix.Closed, true);
        if AssMatrix.Find('-') then
            Error('Cannot modify a running loan');
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
        AssMatrix: Record "Assignment Matrix1 to";
        Topups: Record "Loan Top-up";
        RepaymentAmt: Decimal;
        PreviewShedule: Record "Repayment Schedule";
        LastDate: Date;
        LoanBalance: Decimal;
        TopupAmt: Decimal;
        EndDate: Date;
        RoundingPrecision: Text;
        topupno: Integer;
        Numerator: Decimal;
        Denominator: Decimal;
        Numerator1: Decimal;
        Denominator1: Decimal;
        Repayment1: Decimal;
        Startcount: Integer;
        InterestAmount: Decimal;
        Principamount: Decimal;
        Principal2: Decimal;
        Principalamount: Decimal;


    procedure DebtService(Principal: Decimal; Interest: Decimal; PayPeriods: Integer): Decimal
    var
        PeriodInterest: Decimal;
    begin
        //PeriodInterval:=
        //EVALUATE(PeriodInterval,FORMAT("Instalment Period"));
        //1M
        //IF PeriodInterval='1M' THEN

        PeriodInterest := Interest / 12 / 100;

        exit(PeriodInterest / (1 - Power((1 + PeriodInterest), -PayPeriods)) * Principal);
        /*
         //1W
        IF PeriodInterval='1W' THEN
         PeriodInterest:= Interest / 52 / 100;
         //2W
        IF PeriodInterval='2W' THEN
         PeriodInterest:= Interest / 26 / 100;
         //1Q
        IF PeriodInterval='1Q' THEN
         PeriodInterest:= Interest / 4 / 100;
        
        
        */

    end;


    procedure CreateAnnuityLoan()
    var
        LoanEntryRec: Record "Loan Application";
        LoanTypeRec: Record "Loan Product Type";
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin


        //Loan Applic. No.,Group Code,Client Code,Loan no
        Installments := Instalment;

        if Installments <= 0 then
            Error('Instalment Amount must be specified');
        //IF  Repayment> "Approved Amount" THEN
        //  ERROR('Instalment Amount is higher than Principal');
        LoopEndBool := false;

        LineNoInt := 0;

        LoanTypeRec.Get("Loan Product Type");

        case LoanTypeRec.Rounding of
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        end;

        RoundPrecisionDec := LoanTypeRec."Rounding Precision";
        //
        //EVALUATE(GP,FORMAT("Grace Period"));
        //
        RemainingPrincipalAmountDec := "Approved Amount";
        RunningDate := "Issued Date";

        repeat
            InterestAmountDec := Round(RemainingPrincipalAmountDec / 100 / 12 *
           LoanTypeRec."Interest Rate", RoundPrecisionDec, RoundDirectionCode);

            if InterestAmountDec >= Repayment then
                Error('This Loan is not possible because\the the instalment Amount must\be higher than %1', InterestAmountDec);
            //
            LineNoInt := LineNoInt + 1;

            NewSchedule."Instalment No" := LineNoInt;
            NewSchedule."Employee No" := "Employee No";
            NewSchedule."Loan No" := "Loan No";
            NewSchedule."Repayment Date" := RunningDate;
            NewSchedule."Monthly Interest" := InterestAmountDec;
            NewSchedule."Monthly Repayment" := Repayment;
            NewSchedule."Loan Category" := "Loan Product Type";
            NewSchedule."Loan Amount" := "Approved Amount";

            // Area to be looked at
            if LineNoInt = Installments then begin
                NewSchedule."Remaining Debt" := 0;
                NewSchedule."Monthly Repayment" := RemainingPrincipalAmountDec + NewSchedule."Monthly Interest";
                NewSchedule."Principal Repayment" := NewSchedule."Monthly Repayment" - NewSchedule."Monthly Interest";

                LoopEndBool := true;
            end;

            if (Repayment - InterestAmountDec) >= RemainingPrincipalAmountDec then begin
                NewSchedule."Principal Repayment" := RemainingPrincipalAmountDec;
                NewSchedule."Remaining Debt" := 0;
                LoopEndBool := true;
            end else begin
                NewSchedule."Principal Repayment" := Repayment - InterestAmountDec;
                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - (Repayment - InterestAmountDec);
                NewSchedule."Remaining Debt" := RemainingPrincipalAmountDec;
            end;
            NewSchedule.Insert;
            RunningDate := CalcDate('1M', RunningDate)
        //RunningDate:=CALCDATE("Instalment Period",RunningDate)

        //MODIFY;
        until LoopEndBool;

        Message('Schedule Created');
    end;


    procedure FlatRateCalc(var FlatLoanAmount: Decimal; var FlatInterestRate: Decimal) FlatRateCalc: Decimal
    begin
        /*//FlatPeriodInterval:=
        //EVALUATE(FlatPeriodInterval,FORMAT("Instalment Period"));
        //1M
        //IF FlatPeriodInterval='1M' THEN
        
        FlatPeriodInterest:= FlatLoanAmount*FlatInterestRate/100*1/12;
        FlatRateCalc:= FlatPeriodInterest;
        
        {
         //1W
        
        IF FlatPeriodInterval='1W' THEN
         FlatPeriodInterest:= FlatLoanAmount*FlatInterestRate/100*1/52;
         //2W
        IF FlatPeriodInterval='2W' THEN
         FlatPeriodInterest:= FlatLoanAmount*FlatInterestRate/100*1/26;
         //1Q
        IF FlatPeriodInterval='1Q' THEN
         FlatPeriodInterest:= FlatLoanAmount*FlatInterestRate/100*1/4;
        }
         */



        /////NEW
        //FlatPeriodInterval:=
        //EVALUATE(FlatPeriodInterval,FORMAT("Instalment Period"));
        //1M
        //IF FlatPeriodInterval='1M' THEN

        FlatPeriodInterest := FlatLoanAmount * FlatInterestRate / 100 * 1 / 12;
        FlatRateCalc := FlatPeriodInterest;

        /*
         //1W
        
        IF FlatPeriodInterval='1W' THEN
         FlatPeriodInterest:= FlatLoanAmount*FlatInterestRate/100*1/52;
         //2W
        IF FlatPeriodInterval='2W' THEN
         FlatPeriodInterest:= FlatLoanAmount*FlatInterestRate/100*1/26;
         //1Q
        IF FlatPeriodInterval='1Q' THEN
         FlatPeriodInterest:= FlatLoanAmount*FlatInterestRate/100*1/4;
        */

    end;


    procedure CreateFlatRateSchedule()
    begin
        /*// Flat Rate
        LineNoInt := 1;
        Installments:=Instalment;
        IF "Interest Calculation Method"="Interest Calculation Method"::"Flat Rate" THEN
        BEGIN
        RunningDate:="Issued Date";
        
        RemainingPrincipalAmountDec :="Approved Amount";
        
        IF LineNoInt <Installments+1 THEN BEGIN
         REPEAT
          NewSchedule."Instalment No":= LineNoInt;
          NewSchedule."Employee No" :="Employee No";
          NewSchedule."Loan No" :="Loan No";
          NewSchedule."Repayment Date" := RunningDate;
          NewSchedule."Monthly Interest" := "Flat Rate Interest";
          NewSchedule."Monthly Repayment":=Repayment;
          NewSchedule."Loan Category":="Loan Product Type";
          NewSchedule."Loan Amount":="Approved Amount";
          NewSchedule."Principal Repayment" := "Flat Rate Principal";
          IF LineNoInt=1 THEN
           RemainingPrincipalAmountDec:="Approved Amount"-Repayment
          ELSE
           RemainingPrincipalAmountDec:=RemainingPrincipalAmountDec-Repayment;
          NewSchedule."Remaining Debt" :=RemainingPrincipalAmountDec;
          NewSchedule."Instalment No" := LineNoInt;
          NewSchedule.INSERT;
        
          LineNoInt:=LineNoInt+1;
          RunningDate:=CALCDATE('CD+1M',RunningDate);
        
         UNTIL LineNoInt>Installments
         END;
        
        END;
        MESSAGE('Schedule Created');
         */



        // Flat Rate
        LineNoInt := 1;
        Installments := Instalment;
        if "Interest Calculation Method" = "Interest Calculation Method"::"Flat Rate" then begin
            RunningDate := "Issued Date";

            RemainingPrincipalAmountDec := "Approved Amount";

            if LineNoInt < Installments + 1 then begin
                repeat
                    NewSchedule."Instalment No" := LineNoInt;
                    NewSchedule."Employee No" := "Employee No";
                    NewSchedule."Loan No" := "Loan No";
                    NewSchedule."Repayment Date" := RunningDate;
                    NewSchedule."Monthly Interest" := "Flat Rate Interest";
                    NewSchedule."Monthly Repayment" := Repayment;
                    NewSchedule."Loan Category" := "Loan Product Type";
                    NewSchedule."Loan Amount" := "Approved Amount";
                    NewSchedule."Principal Repayment" := "Flat Rate Principal";
                    if LineNoInt = 1 then
                        RemainingPrincipalAmountDec := "Approved Amount" - Repayment
                    else
                        RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - Repayment;
                    NewSchedule."Remaining Debt" := RemainingPrincipalAmountDec;
                    NewSchedule."Instalment No" := LineNoInt;
                    NewSchedule.Insert;

                    LineNoInt := LineNoInt + 1;
                    RunningDate := CalcDate('CD+1M', RunningDate);

                until LineNoInt > Installments
            end;

        end;
        Message('Schedule Created');

    end;


    procedure CreateSaccoReducing()
    var
        LoanEntryRec: Record "Loan Application";
        LoanTypeRec: Record "Loan Product Type";
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin

        //Loan Applic. No.,Group Code,Client Code,Loan no
        Installments := Instalment;

        if Installments <= 0 then
            Error('Instalment Amount must be specified');
        LoopEndBool := false;

        LineNoInt := 0;

        LoanTypeRec.Get("Loan Product Type");

        case LoanTypeRec.Rounding of
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        end;

        RoundPrecisionDec := LoanTypeRec."Rounding Precision";
        RemainingPrincipalAmountDec := "Approved Amount";
        RunningDate := "Issued Date";

        repeat
            InterestAmountDec := Round(RemainingPrincipalAmountDec / 100 / 12 *
           LoanTypeRec."Interest Rate", RoundPrecisionDec, RoundDirectionCode);

            if InterestAmountDec >= Repayment then
                Error('This Loan is not possible because\the the instalment Amount must\be higher than %1', InterestAmountDec);
            //
            LineNoInt := LineNoInt + 1;

            NewSchedule."Instalment No" := LineNoInt;
            NewSchedule."Employee No" := "Employee No";
            NewSchedule."Loan No" := "Loan No";
            NewSchedule."Repayment Date" := RunningDate;
            NewSchedule."Monthly Interest" := InterestAmountDec;
            NewSchedule."Monthly Repayment" := Repayment + InterestAmountDec;
            NewSchedule."Loan Category" := "Loan Product Type";
            NewSchedule."Loan Amount" := "Approved Amount";

            // Area to be looked at
            if LineNoInt = Installments then begin
                NewSchedule."Remaining Debt" := 0;
                NewSchedule."Monthly Repayment" := RemainingPrincipalAmountDec + NewSchedule."Monthly Interest";
                NewSchedule."Principal Repayment" := NewSchedule."Monthly Repayment" - NewSchedule."Monthly Interest";

                LoopEndBool := true;
            end;

            if (Repayment - InterestAmountDec) >= RemainingPrincipalAmountDec then begin
                NewSchedule."Principal Repayment" := RemainingPrincipalAmountDec;
                NewSchedule."Remaining Debt" := 0;
                LoopEndBool := true;
            end else begin
                NewSchedule."Principal Repayment" := Repayment;
                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - Repayment;
                NewSchedule."Remaining Debt" := RemainingPrincipalAmountDec;
            end;
            NewSchedule.Insert;
            RunningDate := CalcDate('1M', RunningDate)

        until LoopEndBool;

        Message('Schedule Created');
    end;


    procedure IssueLoan()
    var
        periodrec: Record "Payroll Period";
        currentdateP: Date;
        schedulerec: Record "Repayment Schedule";
        assignM: Record "Assignment Matrix";
        assignM2: Record "Assignment Matrix";
    begin
        periodrec.Reset;
        periodrec.SetFilter(periodrec.Closed, '%1', true);
        if periodrec.FindLast then begin
            currentdateP := periodrec."Starting Date";
            currentdateP := CalcDate('1M', currentdateP); //Message('%1',currentdateP);


            schedulerec.Reset;
            schedulerec.SetFilter(schedulerec."Loan Category", '%1', "Loan Product Type");
            schedulerec.SetFilter(schedulerec."Repayment Date", '%1', currentdateP);
            schedulerec.SetFilter(schedulerec."Employee No", "Employee No");
            schedulerec.SetFilter("Loan No", "Loan No");
            if schedulerec.FindSet then begin
                assignM.Reset;
                assignM.SetFilter(assignM."Employee No", "Employee No");
                assignM.SetFilter(assignM.Type, '%1', assignM.Type::Deduction);
                assignM.SetFilter(assignM.Code, '%1', "Deduction Code");
                assignM.SetFilter(assignM."Payroll Period", '%1', currentdateP);
                if assignM.FindSet then begin
                    assignM2.Reset;
                    assignM2.Init;
                    assignM2.Copy(assignM);
                    assignM.Delete;
                    assignM2."Reference No" := schedulerec."Loan No";
                    assignM2.Amount := 0 - Abs(schedulerec."Monthly Repayment");
                    assignM2."Outstanding Amount" := schedulerec."Remaining Debt";
                    assignM2."Interest Amount" := schedulerec."Monthly Interest";
                    assignM2."Amount  less interest" := schedulerec."Principal Repayment";
                    assignM2.Insert;
                end;
                if not assignM.FindSet then begin
                    assignM2.Init;
                    assignM2."Employee No" := "Employee No";
                    assignM2.Validate(assignM2."Employee No");
                    assignM2.Type := assignM2.Type::Deduction;
                    assignM2.Code := "Deduction Code";
                    assignM2.Validate(assignM2.Code);
                    assignM2."Payroll Period" := currentdateP;
                    assignM2."Reference No" := schedulerec."Loan No";
                    assignM2.Amount := 0 - Abs(schedulerec."Monthly Repayment");
                    assignM2."Outstanding Amount" := schedulerec."Remaining Debt";
                    assignM2."Interest Amount" := schedulerec."Monthly Interest";
                    assignM2."Amount  less interest" := schedulerec."Principal Repayment";
                    assignM2.Insert;

                end;
            end;


        end;
        Message('Loan Issued Successfully!');
    end;


    procedure CreateAnnuityLoanTopUp(var LoanNo: Code[20]; var LoanProductType: Code[20]; var Repaymentno: Integer; var NewLoanAmount: Decimal; var IssuedDate: Date; var TopUpAmount: Decimal)
    var
        LoanEntryRec: Record "Loan Application";
        LoanTypeRec: Record "Loan Product Type";
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
        LoanCard: Record "Loan Application";
    begin
        //Error if the Top-Up Already has the Schedule====
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        NewSchedule.SetFilter("Repayment Date", '%1', IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        if NewSchedule.FindSet then begin
            Error('This Top-up has already been included in the Repayment Schedule!!!');
        end;
        //Find the Top up no. Like top up1 , top up 2...upto 7 topups
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        //NewSchedule.SETFILTER("Top Up 2",'%1',TRUE);
        if NewSchedule.FindSet then begin
            topupno := 2;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 2", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 3;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 3", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 4;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 4", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 5;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 5", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 6;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 6", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 7;
        end;
        //===========================================================
        //================================================
        ///Brian Kibet ===================================
        //
        //
        //
        ///////////////////////////////////////////////////
        LoanCard.Reset;
        LoanCard.Get(LoanNo, LoanProductType);

        //Loan Applic. No.,Group Code,Client Code,Loan no
        Installments := Round((NewLoanAmount / LoanCard.Repayment), 1);//LoanCard.Instalment;//extra installments
        //MESSAGE('%1',Installments);
        if Installments <= 0 then
            Error('Instalment Amount must be specified');

        LoopEndBool := false;

        LineNoInt := Repaymentno;//Brian Kibet-Picks from the Last Loan Repayment No.

        LoanTypeRec.Get(LoanCard."Loan Product Type");

        case LoanTypeRec.Rounding of
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        end;

        RoundPrecisionDec := LoanTypeRec."Rounding Precision";
        //
        //EVALUATE(GP,FORMAT("Grace Period"));

        RemainingPrincipalAmountDec := NewLoanAmount;//"Approved Amount";
        RunningDate := IssuedDate;//"Issued Date";

        repeat
            InterestAmountDec := Round(RemainingPrincipalAmountDec / 100 / 12 *
           LoanTypeRec."Interest Rate", RoundPrecisionDec, RoundDirectionCode);

            if InterestAmountDec >= LoanCard.Repayment then
                Error('This Loan is not possible because\the the instalment Amount must\be higher than %1', InterestAmountDec);
            //
            LineNoInt := LineNoInt + 1;

            NewSchedule."Instalment No" := LineNoInt;
            NewSchedule."Employee No" := LoanCard."Employee No";
            NewSchedule."Loan No" := LoanCard."Loan No";
            NewSchedule."Repayment Date" := RunningDate;
            NewSchedule."Monthly Interest" := InterestAmountDec;
            NewSchedule."Monthly Repayment" := LoanCard.Repayment;
            NewSchedule."Loan Category" := "Loan Product Type";
            NewSchedule."Loan Amount" := NewLoanAmount;//"Approved Amount";
            NewSchedule."Top up" := true;
            NewSchedule."Top up Amount 1" := TopUpAmount;
            case topupno of
                2:
                    begin
                        NewSchedule."Top Up 2" := true;
                        NewSchedule."Top Up 2 Amount" := NewLoanAmount;
                    end;
                3:
                    begin
                        NewSchedule."Top Up 3" := true;
                        NewSchedule."Top Up 3 Amount" := NewLoanAmount;
                    end;
                4:
                    begin
                        NewSchedule."Top Up 4" := true;
                        NewSchedule."Top Up 4 Amount" := NewLoanAmount;
                    end;
                5:
                    begin
                        NewSchedule."Top Up 5" := true;
                        NewSchedule."Top Up 5 Amount" := NewLoanAmount;
                    end;
                6:
                    begin
                        NewSchedule."Top Up 6" := true;
                        NewSchedule."Top Up 6 Amount" := NewLoanAmount;
                    end;
                7:
                    begin
                        NewSchedule."Top Up 7" := true;
                        NewSchedule."Top Up 7 Amount" := NewLoanAmount;
                    end;

            end;

            // Area to be looked at
            if LineNoInt = (Installments + Repaymentno) then begin
                NewSchedule."Remaining Debt" := 0;
                NewSchedule."Monthly Repayment" := RemainingPrincipalAmountDec + NewSchedule."Monthly Interest";
                NewSchedule."Principal Repayment" := NewSchedule."Monthly Repayment" - NewSchedule."Monthly Interest";
                LoopEndBool := true;
            end;

            if (LoanCard.Repayment - InterestAmountDec) >= RemainingPrincipalAmountDec then begin
                NewSchedule."Principal Repayment" := RemainingPrincipalAmountDec;
                NewSchedule."Remaining Debt" := 0;
                LoopEndBool := true;
            end else begin
                NewSchedule."Principal Repayment" := LoanCard.Repayment - InterestAmountDec;
                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - (LoanCard.Repayment - InterestAmountDec);
                NewSchedule."Remaining Debt" := RemainingPrincipalAmountDec;
            end;
            NewSchedule.Insert;
            RunningDate := CalcDate('1M', RunningDate)
        //RunningDate:=CALCDATE("Instalment Period",RunningDate)

        //MODIFY;
        until LoopEndBool;

        Message('Top Up Schedule Created');
    end;


    procedure CreateAnnuityLoanTopUp2(var LoanNo: Code[20]; var LoanProductType: Code[20]; var Repaymentno: Integer; var NewLoanAmount: Decimal; var IssuedDate: Date; var TopUpAmount: Decimal; var NewRepaymentAmount: Decimal; var NewInstallment: Integer)
    var
        LoanEntryRec: Record "Loan Application";
        LoanTypeRec: Record "Loan Product Type";
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
        LoanCard: Record "Loan Application";
    begin
        //Error if the Top-Up Already has the Schedule====
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        NewSchedule.SetFilter("Repayment Date", '%1', IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        if NewSchedule.FindSet then begin
            Error('This Top-up has already been included in the Repayment Schedule!!!');
        end;
        //Find the Top up no. Like top up1 , top up 2...upto 7 topups
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        //NewSchedule.SETFILTER("Top Up 2",'%1',TRUE);
        if NewSchedule.FindSet then begin
            topupno := 2;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 2", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 3;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 3", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 4;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 4", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 5;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 5", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 6;
        end;
        NewSchedule.Reset;
        NewSchedule.SetFilter("Top up", '%1', true);
        NewSchedule.SetFilter("Top up Amount 1", '%1', TopUpAmount);
        //NewSchedule.SETFILTER("Repayment Date",'%1',IssuedDate);
        NewSchedule.SetFilter("Loan No", LoanNo);
        NewSchedule.SetFilter("Top Up 6", '%1', true);
        if NewSchedule.FindSet then begin
            topupno := 7;
        end;
        //===========================================================
        //================================================
        ///Brian Kibet ===================================
        //
        //
        //
        ///////////////////////////////////////////////////
        LoanCard.Reset;
        LoanCard.Get(LoanNo, LoanProductType);

        //Loan Applic. No.,Group Code,Client Code,Loan no
        Installments := Round((NewInstallment), 1);//LoanCard.Instalment;//extra installments
        //MESSAGE('%1',Installments);
        if Installments <= 0 then
            Error('Instalment Amount must be specified');

        LoopEndBool := false;

        LineNoInt := Repaymentno;//Brian Kibet-Picks from the Last Loan Repayment No.

        LoanTypeRec.Get(LoanCard."Loan Product Type");

        case LoanTypeRec.Rounding of
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        end;

        RoundPrecisionDec := LoanTypeRec."Rounding Precision";
        //
        //EVALUATE(GP,FORMAT("Grace Period"));

        RemainingPrincipalAmountDec := NewLoanAmount;//"Approved Amount";
        RunningDate := IssuedDate;//"Issued Date";

        repeat
            InterestAmountDec := Round(RemainingPrincipalAmountDec / 100 / 12 *
           LoanTypeRec."Interest Rate", RoundPrecisionDec, RoundDirectionCode);

            if InterestAmountDec >= LoanCard.Repayment then
                Error('This Loan is not possible because\the the instalment Amount must\be higher than %1', InterestAmountDec);
            //
            LineNoInt := LineNoInt + 1;

            NewSchedule."Instalment No" := LineNoInt;
            NewSchedule."Employee No" := LoanCard."Employee No";
            NewSchedule."Loan No" := LoanCard."Loan No";
            NewSchedule."Repayment Date" := RunningDate;
            NewSchedule."Monthly Interest" := InterestAmountDec;
            NewSchedule."Monthly Repayment" := NewRepaymentAmount;//LoanCard.Repayment;
            NewSchedule."Loan Category" := "Loan Product Type";
            NewSchedule."Loan Amount" := NewLoanAmount;//"Approved Amount";
            NewSchedule."Top up" := true;
            NewSchedule."Top up Amount 1" := TopUpAmount;
            case topupno of
                2:
                    begin
                        NewSchedule."Top Up 2" := true;
                        NewSchedule."Top Up 2 Amount" := NewLoanAmount;
                    end;
                3:
                    begin
                        NewSchedule."Top Up 3" := true;
                        NewSchedule."Top Up 3 Amount" := NewLoanAmount;
                    end;
                4:
                    begin
                        NewSchedule."Top Up 4" := true;
                        NewSchedule."Top Up 4 Amount" := NewLoanAmount;
                    end;
                5:
                    begin
                        NewSchedule."Top Up 5" := true;
                        NewSchedule."Top Up 5 Amount" := NewLoanAmount;
                    end;
                6:
                    begin
                        NewSchedule."Top Up 6" := true;
                        NewSchedule."Top Up 6 Amount" := NewLoanAmount;
                    end;
                7:
                    begin
                        NewSchedule."Top Up 7" := true;
                        NewSchedule."Top Up 7 Amount" := NewLoanAmount;
                    end;

            end;

            // Area to be looked at
            if LineNoInt = (Installments + Repaymentno) then begin
                NewSchedule."Remaining Debt" := 0;
                NewSchedule."Monthly Repayment" := RemainingPrincipalAmountDec + NewSchedule."Monthly Interest";
                NewSchedule."Principal Repayment" := NewSchedule."Monthly Repayment" - NewSchedule."Monthly Interest";
                LoopEndBool := true;
            end;

            if (LoanCard.Repayment - InterestAmountDec) >= RemainingPrincipalAmountDec then begin
                NewSchedule."Principal Repayment" := RemainingPrincipalAmountDec;
                NewSchedule."Remaining Debt" := 0;
                LoopEndBool := true;
            end else begin
                NewSchedule."Principal Repayment" := NewRepaymentAmount - InterestAmountDec;
                RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - (NewRepaymentAmount - InterestAmountDec);
                NewSchedule."Remaining Debt" := RemainingPrincipalAmountDec;
            end;
            NewSchedule.Insert;
            RunningDate := CalcDate('1M', RunningDate)
        //RunningDate:=CALCDATE("Instalment Period",RunningDate)

        //MODIFY;
        until LoopEndBool;

        Message('Top Up Schedule Created');
    end;


    procedure CreateAmortized()
    var
        LoanEntryRec: Record "Loan Application";
        LoanTypeRec: Record "Loan Product Type";
        LoopEndBool: Boolean;
        LineNoInt: Integer;
        PeriodCode: Code[10];
        InterestAmountDec: Decimal;
        RemainingPrincipalAmountDec: Decimal;
        RepaymentAmountDec: Decimal;
        RoundPrecisionDec: Decimal;
        RoundDirectionCode: Code[10];
    begin
        RunningDate := "Issued Date";
        LineNoInt := 0;
        InterestAmountDec := 0;
        RepaymentAmt := Repayment;
        Principamount := 0;
        Principalamount := "Approved Amount";
        RemainingPrincipalAmountDec := "Approved Amount";
        Startcount := 1;
        Installments := Instalment;
        //Loan Applic. No.,Group Code,Client Code,Loan no
        if Installments <= 0 then
            Error('Instalment Amount must be specified');
        LoanTypeRec.Get("Loan Product Type");
        case LoanTypeRec.Rounding of
            LoanTypeRec.Rounding::Nearest:
                RoundDirectionCode := '=';
            LoanTypeRec.Rounding::Down:
                RoundDirectionCode := '<';
            LoanTypeRec.Rounding::Up:
                RoundDirectionCode := '>';
        end;
        RoundPrecisionDec := LoanTypeRec."Rounding Precision";
        while Startcount <= Installments do begin
            LineNoInt := LineNoInt + 1;
            //====================calculations
            // InterestAmountDec:=ROUND((("Interest Rate"/12)*RemainingPrincipalAmountDec),RoundPrecisionDec,RoundDirectionCode);
            InterestAmountDec := Round((("Interest Rate" / 12) * RemainingPrincipalAmountDec), 0.05, '>');
            Principamount := Repayment - InterestAmountDec;
            //=========================end callculations
            NewSchedule."Instalment No" := LineNoInt;
            NewSchedule."Employee No" := "Employee No";
            NewSchedule."Loan No" := "Loan No";
            NewSchedule."Repayment Date" := RunningDate;
            NewSchedule."Monthly Interest" := InterestAmountDec;
            NewSchedule."Monthly Repayment" := Repayment;
            NewSchedule."Loan Category" := "Loan Product Type";
            NewSchedule."Loan Amount" := "Approved Amount";
            NewSchedule."Remaining Debt" := RemainingPrincipalAmountDec - Principamount;
            if NewSchedule."Remaining Debt" < 0 then
                NewSchedule."Remaining Debt" := 0;
            NewSchedule."Principal Repayment" := Principamount;
            NewSchedule.Insert;
            InterestAmountDec := 0;
            RemainingPrincipalAmountDec := RemainingPrincipalAmountDec - Principamount;
            Startcount := Startcount + 1;
            RunningDate := CalcDate('1M', RunningDate);
        end;
        Message('Schedule Created Successfully!');
    end;
}