table 51525339 "Staff Appraisal Header"
{
    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if No = '' then
                    Insert(true);
                Department := '';
                Section := '';
                Supervisor := '';
                "Staff Name" := '';
                ObjEmp.Reset;
                ObjEmp.SetRange("No.", "Staff No");
                if ObjEmp.Find('-') then begin
                    "Staff Name" := ObjEmp."First Name" + ' ' + ObjEmp."Middle Name" + ' ' + ObjEmp."Last Name";
                    //Directorate := ObjEmp."Responsibility Center";
                    Department := ObjEmp."Responsibility Center";
                    Section := ObjEmp."Sub Responsibility Center";
                    Supervisor := ObjEmp."Manager No.";
                    if Supervisor = '' then
                        Error('Kindly ask the HR department to set the supervisor (Manager No.) for %1', "Staff No");
                    if Supervisor <> '' then begin
                        ObjEmp2.Reset;
                        ObjEmp2.SetRange("No.", Supervisor);
                        if ObjEmp2.FindFirst() then
                            ObjEmp2.Modify(true); //Ensures full name is updated
                    end;
                    "Review Date" := 0D;
                    ObjPeriods.Reset;
                    ObjPeriods.SetRange(ObjPeriods.Open, false);
                    if ObjPeriods.Find('-') then
                        Period := ObjPeriods.Code;
                    Validate(Department);
                end;
            end;
        }
        field(3; "Staff Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Directorate; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
        }
        field(5; Department; Code[20])
        {

            Caption = 'Department';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
            Editable = false;

            trigger OnValidate()
            var
                ResponsibilityCenter: Record "Responsibility Center";
                EntryNo: Integer;
            begin
                if ResponsibilityCenter.Get(Department) then begin
                    "Department Name" := ResponsibilityCenter.Name;
                end;

                AppraisalHeader.Reset();
                AppraisalHeader.SetRange("Staff No", "Staff No");
                AppraisalHeader.SetRange(Period, Period);
                AppraisalHeader.SetFilter(No, '<>%1', No);
                if AppraisalHeader.FindFirst() then
                    Error('You have already created End Year Appraisal No. %1 for this period!', AppraisalHeader.No);

                if Confirm('This will create new lines. Do you want to proceed?', true) = true then begin
                    EntryNo := 0;
                    ObjAppraisalLines.Reset();
                    ObjAppraisalLines.SetRange("Doc No", No);
                    if ObjAppraisalLines.Find('-') then
                        ObjAppraisalLines.DeleteAll();

                    ObjAppraisalLines.Reset();
                    ObjAppraisalLines.SetCurrentKey("Entry No");
                    ObjAppraisalLines.SetAscending("Entry No", true);
                    if ObjAppraisalLines.FindLast() then
                        EntryNo := ObjAppraisalLines."Entry No";

                    StaffTargetsLines.Reset;
                    StaffTargetsLines.SetRange("Staff No", "Staff No");
                    StaffTargetsLines.SetRange(Period, Period);
                    StaffTargetsLines.SetRange("Due Date", "Review Date");
                    if StaffTargetsLines.Find('-') then begin
                        repeat
                            StaffTargetsLines.CalcFields("Approved By Supervisor");
                            if StaffTargetsLines."Approved By Supervisor" then begin
                                EntryNo += 1;
                                ObjAppraisalLines.Init;
                                ObjAppraisalLines."Doc No" := No;
                                ObjAppraisalLines."Entry No" := EntryNo;
                                ObjAppraisalLines.Type := ObjAppraisalLines.Type::Objectives;
                                ObjAppraisalLines."Objective Code" := StaffTargetsLines.No;
                                ObjAppraisalLines.Objective := StaffTargetsLines.Objective;
                                ObjAppraisalLines.Theme := StaffTargetsLines.Theme;
                                ObjAppraisalLines."Staff No" := "Staff No";
                                ObjAppraisalLines.Period := StaffTargetsLines.Period;
                                ObjAppraisalLines."Success Measure" := StaffTargetsLines."Success Measure";
                                ObjAppraisalLines."Due Date" := StaffTargetsLines."Due Date";
                                ObjAppraisalLines.Insert;
                            end;
                        until StaffTargetsLines.Next = 0;
                    end else
                        Error('Targets for staff %1 for period %2 due on %3 not found', "Staff No", Period, "Review Date");
                end else
                    Message('Current lines retained');

                /*ObjDeptObjectivesHeader.RESET;
                ObjDeptObjectivesHeader.SETRANGE(Department, Department);
                ObjDeptObjectivesHeader.SETRANGE(Directorate, Directorate);
                ObjDeptObjectivesHeader.SETRANGE(Period, Period);
                IF ObjDeptObjectivesHeader.FIND('-') THEN BEGIN
                  StaffTargetsLines.RESET;
                  StaffTargetsLines.SETRANGE("Staff No", "Staff No");
                  StaffTargetsLines.SETRANGE(Period, Period);
                  IF StaffTargetsLines.FIND('-') THEN
                      StaffTargetsLines.DELETEALL;
                    ObjDeptObjectives.RESET;
                    ObjDeptObjectives.SETRANGE("Doc No", ObjDeptObjectivesHeader.No);
                    IF ObjDeptObjectives.FIND('-') THEN BEGIN
                      REPEAT
                        StaffTargetsLines.INIT;
                        StaffTargetsLines.No:='';
                        StaffTargetsLines."Doc No":=No;
                        StaffTargetsLines."Objective Code":=ObjDeptObjectives."Objective Code";
                        StaffTargetsLines.Objective:=ObjDeptObjectives.Objective;
                        StaffTargetsLines."Success Measure":=ObjDeptObjectives."Success Measure";
                        StaffTargetsLines.Period:=Period;
                        StaffTargetsLines."Staff No":="Staff No";
                        StaffTargetsLines.INSERT(TRUE);
                        UNTIL ObjDeptObjectives.NEXT=0;
                      END ELSE MESSAGE('Department Objectives not found');
                  END;
                END ELSE MESSAGE('Current lines have not been replaced');*/

            end;
        }
        field(6; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;

            trigger OnValidate()
            begin
                StaffTargetLines.Reset;
                StaffTargetLines.SetRange("Staff No", "Staff No");
                StaffTargetLines.SetRange(Period, Period);
                if StaffTargetLines.FindFirst then begin
                    repeat
                        CreateMYALines(No, StaffTargetLines.No, StaffTargetLines."Success Measure", StaffTargetLines.Theme);
                    until StaffTargetLines.Next = 0;

                end;
            end;
        }
        field(7; "Created On"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Created By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; Supervisor; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
            Editable = false;
        }
        field(10; "Supervisor Name"; Text[250])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD(Supervisor)));
            FieldClass = FlowField;
        }
        field(11; "Period Desc"; Text[250])
        {
            CalcFormula = Lookup("HR Appraisal Periods".Description WHERE(Code = FIELD(Period)));
            FieldClass = FlowField;
        }
        field(12; Designation; Text[250])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE("No." = FIELD("Staff No")));
            FieldClass = FlowField;
        }
        field(13; "Sent to Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Approved By Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'General,Probation';
            OptionMembers = General,Probation;
        }
        field(16; "Supervisor Rejection Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Department Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; Section; Code[70])
        {
            Caption = 'Section';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD(Department));
            Editable = false;
        }
        field(19; "Overall Score(%)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Staff Appraisal Lines"."Score(%)" WHERE(Type = CONST(Objectives),
                                                                     "Staff No" = FIELD("Staff No"), Period = FIELD(Period)));
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(20; "Review Date"; Date)
        { }
        field(21; "Date-Time Sent For Approval"; DateTime)
        { }
        field(22; "Date-Time Approved"; DateTime)
        { }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ("Sent to Supervisor") or ("Approved By Supervisor") then
            //Error('You cannot delete the record at this stage');
            StaffApprLines.Reset;
        StaffApprLines.SetRange("Doc No", No);
        if StaffApprLines.FindSet then
            StaffApprLines.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if No = '' then begin
            AppraisalHeader.Reset;
            if AppraisalHeader.FindLast then begin
                No := IncStr(AppraisalHeader.No);
            end else begin
                No := 'APPR-001';
            end;
        end;
        "Created By" := UserId;
        "Created On" := Today;
    end;

    var
        AppraisalHeader: Record "Staff Appraisal Header";
        ObjEmp: Record Employee;
        ObjPeriods: Record "HR Appraisal Periods";
        ObjDeptObjectives: Record "Department Objective Lines";
        StaffTargetsLines: Record "Staff Target Lines";
        ObjDeptObjectivesHeader: Record "Department Objectives Header";
        ObjAppraisalLines: Record "Staff Appraisal Lines";
        StaffTargetLines: Record "Staff Target Lines";
        StaffTargetObjectives: Record "Staff Target Objectives";
        MDYALType: Option " ",Goals,"Checkin Agenda",Achievements,Concerns,"Agreed Actions","Employee Comments","Supervisor Comments";
        StaffApprLines: Record "Staff Appraisal Lines";
        ObjEmp2: Record Employee;

    local procedure CreateMYALines(Docno: Code[100]; ObjjectiveCode: Code[100]; SuccessMeasure: Text[250]; ThemeArea: Text[250])
    var
        StaffAppraisalLines: Record "Staff Appraisal Lines";
    begin
        StaffAppraisalLines."Doc No" := Docno;
        StaffAppraisalLines.Theme := ThemeArea;
        StaffAppraisalLines.Type := StaffAppraisalLines.Type::Objectives;
        StaffAppraisalLines."Objective Code" := ObjjectiveCode;
        StaffAppraisalLines."Success Measure" := SuccessMeasure;
        StaffAppraisalLines.Insert;
        Commit;
    end;
}