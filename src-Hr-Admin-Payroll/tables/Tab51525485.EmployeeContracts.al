table 51525485 "Employee Contracts"
{
    //DrillDownPageID = "Employee Qualifications List";
    //LookupPageID = "Employee Qualifications List";

    fields
    {
        field(1; "Contract No"; Code[30])
        {
        }
        field(2; "Employee No"; Code[50])
        {
            TableRelation = Employee."No." WHERE(Status = CONST(Active),
                                                  "On Contract" = CONST(true));

            trigger OnValidate()
            begin
                EmpRec.Reset;
                if EmpRec.Get("Employee No") then begin
                    "Employee Name" := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";

                end;
                EmpContracts.Reset;
                EmpContracts.SetRange(EmpContracts."Employee No", "Employee No");
                EmpContracts.SetRange(EmpContracts."Contract End Date", 0D, Today);
                if EmpContracts.FindLast then begin
                    EmpContracts.Expired := true;
                    EmpContracts.Modify;

                end;
            end;
        }
        field(3; "Contract Start Date"; Date)
        {

            trigger OnValidate()
            begin


                //Calculate balance brought forward from previous contract period
                "Balance Brought Forward" := 0;
                EndDate := CalcDate('-1D', "Contract Start Date");

                EmpContracts.Reset;
                EmpContracts.SetRange(EmpContracts."Employee No", "Employee No");
                EmpContracts.SetRange(EmpContracts."Contract End Date", EndDate);
                if EmpContracts.FindLast then begin
                    TotalDays1 := 0;
                    Recalled1 := 0;
                    Absent1 := 0;

                    EmpLeaveApps.Reset;
                    EmpLeaveApps.SetRange(EmpLeaveApps."Employee No", EmpContracts."Employee No");
                    EmpLeaveApps.SetRange(EmpLeaveApps."Leave Type", 'ANNUAL');
                    EmpLeaveApps.SetRange(EmpLeaveApps."Start Date", EmpContracts."Contract Start Date", EmpContracts."Contract End Date");
                    EmpLeaveApps.SetRange(EmpLeaveApps.Status, EmpLeaveApps.Status::Released);
                    if EmpLeaveApps.FindFirst then begin
                        repeat
                            TotalDays1 := TotalDays1 + EmpLeaveApps."Days Applied";
                        until EmpLeaveApps.Next = 0;
                    end;

                    LeaveRecallRec.Reset;
                    LeaveRecallRec.SetRange(LeaveRecallRec."Employee No", "Employee No");
                    LeaveRecallRec.SetRange(LeaveRecallRec."Recalled From", EmpContracts."Contract Start Date", EmpContracts."Contract End Date");
                    if LeaveRecallRec.Find('-') then begin
                        repeat
                            Recalled1 := Recalled1 + LeaveRecallRec."No. of Off Days";
                        until LeaveRecallRec.Next = 0;
                    end;

                    EmpAbsence.Reset;
                    EmpAbsence.SetRange(EmpAbsence."Employee No", "Employee No");
                    EmpAbsence.SetRange(EmpAbsence."Absent From", EmpContracts."Contract Start Date", EmpContracts."Contract End Date");
                    if EmpAbsence.Find('-') then begin
                        repeat
                            Absent1 := Absent1 + EmpAbsence."No. of  Days Absent";
                        until EmpAbsence.Next = 0;
                    end;

                    "Balance Brought Forward" := (EmpContracts."Contract Leave Entitlement" + EmpContracts."Balance Brought Forward" + Recalled1) -
                (TotalDays1 + Absent1);
                end;
            end;
        }
        field(4; "Contract End Date"; Date)
        {
        }
        field(6; Expired; Boolean)
        {
        }
        field(7; "Contract Leave Entitlement"; Decimal)
        {
        }
        field(8; "Balance Brought Forward"; Decimal)
        {

            trigger OnValidate()
            begin
                Validate("Employee No");
                Validate("Contract No");
                Validate("Contract Leave Entitlement");

                AccPeriod.Reset;
                AccPeriod.SetRange(AccPeriod."Starting Date", 0D, "Contract Start Date");
                AccPeriod.SetRange(AccPeriod."New Fiscal Year", true);
                if AccPeriod.FindFirst then begin
                    //FiscalStart:=AccPeriod."Starting Date";
                    MaturityDate := CalcDate('1Y', AccPeriod."Starting Date") - 1;
                end;

                Empleave.Init;
                Empleave."Employee No" := "Employee No";
                Empleave."Leave Code" := 'ANNUAL';
                Empleave."Maturity Date" := MaturityDate;
                Empleave.Entitlement := "Contract Leave Entitlement";
                Empleave."Balance Brought Forward" := "Balance Brought Forward";
                Evaluate(Empleave."Temp. Emp. Contract", "Contract No");
                if not Empleave.Get(Empleave."Employee No", Empleave."Leave Code", Empleave."Maturity Date") then
                    Empleave.Insert;
            end;
        }
        field(9; "Contract Leave Balance"; Decimal)
        {
        }
        field(10; "Employee Name"; Text[80])
        {
        }
        field(11; "User ID"; Code[70])
        {
        }
        field(12; "Creation Date"; Date)
        {
        }
        field(13; "Total Days Taken"; Decimal)
        {
            CalcFormula = Sum("Employee Leave Application"."Days Applied" WHERE("Employee No" = FIELD("Employee No"),
                                                                                 "Contract No." = FIELD("Contract No"),
                                                                                 Status = CONST(Released),
                                                                                 "Leave Type" = CONST('ANNUAL')));
            FieldClass = FlowField;
        }
        field(14; "Recalled Days"; Decimal)
        {
            CalcFormula = Sum("Leave Recall"."No. of Off Days" WHERE("Employee No" = FIELD("Employee No"),
                                                                      "Contract No." = FIELD("Contract No")));
            FieldClass = FlowField;
        }
        field(15; "Days Absent"; Decimal)
        {
            CalcFormula = Sum("Employee Absentism"."No. of  Days Absent" WHERE("Employee No" = FIELD("Employee No"),
                                                                                "Contract No." = FIELD("Contract No")));
            FieldClass = FlowField;
        }
        field(16; "Off Days"; Decimal)
        {
        }
        field(17; Status; Option)
        {
            OptionMembers = Active,Expired,Terminated;
        }
        field(18; Created; Boolean)
        {
        }
        field(19; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(20; "Date Filter"; Date)
        {
        }
        field(21; "Expiry Date"; Date)
        {
        }
        field(22; "Termination Date"; Date)
        {
        }
        field(23; "Contract Period"; DateFormula)
        {

            trigger OnValidate()
            begin
                "Contract End Date" := CalcDate("Contract Period", "Contract Start Date");
                // "Contract Leave Entitlement":=2.5*"Contract Period";
            end;
        }
        field(24; "Employee Posting Group"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Staff Posting Group";
        }
    }

    keys
    {
        key(Key1; "Contract No", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        /*fieldgroup(DropDown; "Contract No", "Employee No", "Contract Start Date", "Contract End Date", Field5)
        {
        }*/
    }

    trigger OnInsert()
    begin

        "User ID" := UserId;
        "Creation Date" := Today;
    end;

    var
        //LeaveTypes: Record "HR Learning Intervention";
        EmpContracts: Record "Employee Contracts";
        EndDate: Date;
        EmpLeaveApps: Record "Employee Leave Application";
        LeaveRecallRec: Record "Leave Recall";
        EmpAbsence: Record "Employee Absentism";
        TotalDays: Decimal;
        Recalled: Decimal;
        Absent: Decimal;
        Absent1: Decimal;
        TotalDays1: Decimal;
        Recalled1: Decimal;
        EmpRec: Record Employee;
        Empleave: Record "Employee Leave Entitlement";
        NextMaturityDate: Date;
        CalendarMgmt: Codeunit "Calendar Management";
        NextDate: Date;
        NoOfMonths: Decimal;
        Description: Text[50];
        EndOfYear: Boolean;
        MaturityDate: Date;
        AccPeriod: Record "Payroll Period";
        NoSeriesMgt: Codeunit "No. Series";
        HRSetup: Record "Human Resources Setup";
}