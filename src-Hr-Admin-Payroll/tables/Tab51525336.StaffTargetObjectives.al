table 51525336 "Staff Target Objectives"
{
    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                Department := '';
                Section := '';
                Supervisor := '';
                "Staff Name" := '';
                ObjEmp.Reset;
                ObjEmp.SetRange("No.", "Staff No");
                if ObjEmp.Find('-') then begin
                    "Staff Name" := ObjEmp."First Name" + ' ' + ObjEmp."Middle Name" + ' ' + ObjEmp."Last Name";
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
                    ObjPeriods.Reset;
                    ObjPeriods.SetRange(ObjPeriods.Open, true);
                    if ObjPeriods.Find('-') then
                        Period := ObjPeriods.Code;
                    Validate(Department);
                end;

                //if Confirm('The existing lines will be deleted. Do you still want to continue?', true) = true then begin
                /*ObjDeptObjectivesHeader.Reset;
                ObjDeptObjectivesHeader.SetRange(Department, Department);
                ObjDeptObjectivesHeader.SetRange(Directorate, Directorate);
                ObjDeptObjectivesHeader.SetRange(Period, Period);
                if ObjDeptObjectivesHeader.Find('-') then begin*/
                StaffTargetsLines.Reset;
                StaffTargetsLines.SetRange("Staff No", "Staff No");
                StaffTargetsLines.SetRange(Period, Period);
                if StaffTargetsLines.Find('-') then begin
                    if Confirm('Any existing lines will be deleted. Do you still want to continue?', true) = true then begin
                        StaffTargetsLines.DeleteAll;
                    end;
                    /*ObjDeptObjectives.Reset;
                    ObjDeptObjectives.SetRange("Doc No", ObjDeptObjectivesHeader.No);
                    if ObjDeptObjectives.Find('-') then begin
                        repeat
                            StaffTargetsLines.Init;
                            StaffTargetsLines.No := '';
                            StaffTargetsLines."Doc No" := No;
                            StaffTargetsLines."Objective Code" := ObjDeptObjectives."Objective Code";
                            StaffTargetsLines.Objective := ObjDeptObjectives.Objective;
                            //StaffTargetsLines."Success Measure":=ObjDeptObjectives."Success Measure";
                            StaffTargetsLines.Period := Period;
                            StaffTargetsLines."Staff No" := "Staff No";
                            StaffTargetsLines.Insert(true);
                        until ObjDeptObjectives.Next = 0;
                    end else
                        Message('Department Objectives not found.');*/
                    //end;
                end;/* else
                    Message('Current lines have been retained');*/
            end;
        }
        field(3; "Staff Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Directorate; Code[240])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
        }
        field(5; Department; Code[240])
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
            Editable = false;

            trigger OnValidate()
            var
                ResponsibilityCenter: Record "Responsibility Center";
            begin
                if ResponsibilityCenter.Get(Department) then begin
                    "Department Name" := ResponsibilityCenter.Name;
                end;
            end;

            /*DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD(Directorate));

            trigger OnValidate()
            begin
                /*IF CONFIRM('Do you want to replace the current lines?', TRUE) = TRUE THEN BEGIN
                ObjDeptObjectivesHeader.RESET;
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
                END ELSE MESSAGE('Current lines have not been replaced');/

            end;*/
        }
        field(6; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;
            Editable = false;
        }
        field(7; "Created On"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Created By"; Code[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; Supervisor; Code[60])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
            Editable = false;
        }
        field(10; "Supervisor Name"; Text[250])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD(Supervisor)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(11; "Period Desc"; Text[250])
        {
            CalcFormula = Lookup("HR Appraisal Periods".Description WHERE(Code = FIELD(Period)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(12; Designation; Text[250])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE("No." = FIELD("Staff No")));
            FieldClass = FlowField;
        }
        field(13; "Sent to Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Approved By Supervisor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; SupervisiorComment; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Annual,Probation;
            Editable = false;
        }
        field(17; "Department Name"; Text[240])
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
        field(19; "DateTime Submitted"; DateTime)
        {
            Editable = false;
        }
        field(20; "DateTime Approved"; DateTime)
        {
            Editable = false;
        }
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
        StaffTargetsLines.Reset;
        StaffTargetsLines.SetRange("Doc No", No);
        if StaffTargetsLines.FindSet then
            StaffTargetsLines.DeleteAll;
    end;

    trigger OnInsert()
    begin
        ObjPeriods.Reset;
        ObjPeriods.SetRange(ObjPeriods.Open, true);
        if not ObjPeriods.Find('-') then
            Error('There are no open periods!')//Period := ObjPeriods.Code;
        else
            Period := ObjPeriods.Code;

        if No = '' then begin
            StaffTargets.Reset;
            if StaffTargets.FindLast then begin
                No := IncStr(StaffTargets.No);
            end else begin
                No := 'STAFFOBJ-001';
            end;
        end;
        "Created By" := UserId;
        "Created On" := Today;
    end;

    var
        StaffTargets: Record "Staff Target Objectives";
        ObjEmp: Record Employee;
        ObjPeriods: Record "HR Appraisal Periods";
        ObjDeptObjectives: Record "Department Objective Lines";
        StaffTargetsLines: Record "Staff Target Lines";
        ObjDeptObjectivesHeader: Record "Department Objectives Header";
        ObjEmp2: Record Employee;
}