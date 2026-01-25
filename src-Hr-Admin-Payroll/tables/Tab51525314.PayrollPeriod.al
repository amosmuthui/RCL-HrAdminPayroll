table 51525314 "Payroll Period"
{
    DrillDownPageID = "Pay Periods";
    LookupPageID = "Pay Periods";

    fields
    {
        field(1; "Starting Date"; Date)
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                Year := Date2DMY("Starting Date", 3);
                //MESSAGE(FORMAT(Year));
                Name := Format("Starting Date", 0, '<Month Text>') + ' ' + Format(Year);//+FORMAT(Type);
                "Period code" := Format(Date2DMY("Starting Date", 3)) + Format(Date2DMY("Starting Date", 2)) + Format(Date2DMY("Starting Date", 1))
            end;
        }
        field(2; Name; Text[20])
        {

            trigger OnValidate()
            begin
                "Period code" := Format(Date2DMY("Starting Date", 3)) + Format(Date2DMY("Starting Date", 2)) + Format(Date2DMY("Starting Date", 1))
            end;
        }
        field(3; "New Fiscal Year"; Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Date Locked", false);
            end;
        }
        field(4; Closed; Boolean)
        {
            Editable = true;
        }
        field(5; "Date Locked"; Boolean)
        {
            Editable = true;
        }
        field(50000; "Pay Date"; Date)
        {
        }
        field(50001; "Close Pay"; Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                //TESTFIELD("Close Pay",FALSE);
                /*
                IF "Close Pay"=TRUE THEN BEGIN
                  "Closed By":=USERID;
                  "Closed on Date":=CURRENTDATETIME;
                END;
                */

            end;
        }
        field(50002; "P.A.Y.E"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Payroll Period" = FIELD("Starting Date"),
                                                                Paye = CONST(true)));
            FieldClass = FlowField;
        }
        field(50003; "Basic Pay"; Decimal)
        {
            CalcFormula = Sum("Staff Ledger Entry"."Basic Pay" WHERE("Payroll Period" = FIELD("Starting Date")));
            FieldClass = FlowField;
        }
        field(50004; "Market Interest Rate %"; Decimal)
        {
        }
        field(50005; "CMS Starting Date"; Date)
        {
        }
        field(50006; "CMS End Date"; Date)
        {
        }
        field(50007; "Closed By"; Code[30])
        {
        }
        field(50008; "Closed on Date"; DateTime)
        {
        }
        field(50009; Type; Option)
        {
            OptionCaption = ' ,Daily,Weekly,Bi-Weekly,Monthly';
            OptionMembers = " ",Daily,Weekly,"Bi-Weekly",Monthly;
        }
        field(50010; Sendslip; Boolean)
        {
        }
        field(50015; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Released,Canceled,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Canceled,Rejected;
        }
        field(50016; "Approver 1"; Boolean)
        {
        }
        field(50017; "Approver 2"; Boolean)
        {
        }
        field(50018; "Approver 3"; Boolean)
        {
        }
        field(50019; "Approver 4"; Boolean)
        {
        }
        field(50020; "Approver 5"; Boolean)
        {
        }
        field(50021; "Approver 6"; Boolean)
        {
        }
        field(50022; "Approver 7"; Boolean)
        {
        }
        field(50023; "Start Approval"; Boolean)
        {
        }
        field(50024; "Period code"; Code[20])
        {
        }
        field(50025; "Approval Status"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Document Type" = CONST(Payroll),
                                                        "Document No." = FIELD("Period code")));
            FieldClass = FlowField;
        }
        field(50026; "No. Series"; Code[20])
        {
        }
        field(50027; "Total Net Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Period Codes"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Display On Portal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Starting Date")
        {
            Clustered = true;
        }
        key(Key2; "New Fiscal Year", "Date Locked")
        {
        }
        key(Key3; Closed)
        {
        }
        key(Key4; Type)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //TESTFIELD("Date Locked",FALSE);
    end;

    trigger OnInsert()
    begin
        AccountingPeriod2 := Rec;
        if AccountingPeriod2.Find('>') then
            AccountingPeriod2.TestField("Date Locked", false);
    end;

    trigger OnRename()
    begin
        TestField("Date Locked", false);
        AccountingPeriod2 := Rec;
        if AccountingPeriod2.Find('>') then
            AccountingPeriod2.TestField("Date Locked", false);
    end;

    var
        AccountingPeriod2: Record "Payroll Period";
        Year: Integer;

    procedure CreateLeaveEntitlment(var PayrollPeriod: Record "Payroll Period")
    var
        AccPeriod: Record "Payroll Period";
        NextDate: Date;
        EndOfYear: Boolean;
        Empleave: Record "Employee Leave Entitlement";
        LeaveType: Record "Leave Types";
        MaturityDate: Date;
        NextMaturityDate: Date;
        Emp: Record Employee;
        CarryForwardDays: Decimal;
        EmpleaveCpy: Record "Employee Leave Entitlement";
    begin
        EndOfYear := false;
        NextDate := CalcDate('1M', "Starting Date");
        if AccPeriod.Get(NextDate) then
            if AccPeriod."New Fiscal Year" then
                EndOfYear := true;

        if EndOfYear then begin

            MaturityDate := CalcDate('1M', PayrollPeriod."Starting Date") - 1;
            NextMaturityDate := CalcDate('1Y', MaturityDate);

            LeaveType.Reset;
            LeaveType.SetRange(LeaveType."Annual Leave", true);
            if LeaveType.Find('-') then begin

                Emp.Reset;
                Emp.SetRange(Emp.Status, Emp.Status::Active);
                //Emp.SETFILTER(Emp."Posting Group",'<>%1','INTERN');
                if Emp.Find('-') then
                    repeat
                        // IF (Emp."Posting Group"='PARMANENT') THEN BEGIN

                        if EmpleaveCpy.Get(Emp."No.", LeaveType.Code, MaturityDate) then begin
                            EmpleaveCpy.CalcFields(EmpleaveCpy."Total Days Taken");
                            CarryForwardDays := EmpleaveCpy.Entitlement + EmpleaveCpy."Balance Brought Forward" + EmpleaveCpy."Recalled Days"
                            - EmpleaveCpy."Total Days Taken";
                            if CarryForwardDays > LeaveType."Max Carry Forward Days" then
                                CarryForwardDays := LeaveType."Max Carry Forward Days";
                        end;

                        //MKU LEAVES
                        CarryForwardDays := 0;

                        Empleave.Init;
                        Empleave."Employee No" := Emp."No.";
                        Empleave."Leave Code" := LeaveType.Code;
                        Empleave."Maturity Date" := NextMaturityDate;
                        // IF Emp."Date Of Join">"Starting Date" THEN
                        //   Empleave.Entitlement:=
                        // ELSE
                        Empleave.Entitlement := LeaveType.Days;
                        Empleave."Balance Brought Forward" := CarryForwardDays;
                        if not Empleave.Get(Empleave."Employee No", Empleave."Leave Code", Empleave."Maturity Date") then
                            Empleave.Insert;

                    /*
                     END ELSE

                   IF (Emp."Posting Group"='TEMP') OR (Emp."Posting Group"='INTERN') THEN BEGIN

                    IF EmpleaveCpy.GET(Emp."No.",LeaveType.Code,MaturityDate) THEN
                    BEGIN
                    EmpleaveCpy.CALCFIELDS(EmpleaveCpy."Total Days Taken");
                    CarryForwardDays:=EmpleaveCpy.Entitlement+EmpleaveCpy."Balance Brought Forward"+EmpleaveCpy."Recalled Days"
                    -EmpleaveCpy."Total Days Taken";
                    IF CarryForwardDays>LeaveType."Max Carry Forward Days" THEN
                    CarryForwardDays:=LeaveType."Max Carry Forward Days";
                    END;

                    Empleave.INIT;
                    Empleave."Employee No":=Emp."No.";
                    Empleave."Leave Code":=LeaveType.Code;
                    Empleave."Maturity Date":=NextMaturityDate;
                   // IF Emp."Date Of Join">"Starting Date" THEN
                   //   Empleave.Entitlement:=
                   // ELSE
                    Empleave.Entitlement:=ROUND(((Emp."Contract End Date"-Emp."Contract Start Date")/30),1)*2.5;
                    Empleave."Balance Brought Forward":=CarryForwardDays;
                    IF NOT Empleave.GET(Empleave."Employee No", Empleave."Leave Code",Empleave."Maturity Date") THEN
                    Empleave.INSERT;
                   END;

                  */
                    until Emp.Next = 0;

            end
            else
                Error('You must select one leave type as annual on the leave setup');

        end;

    end;
}