table 51525338 "Mid Year Appraisal"
{
    DrillDownPageId = "Mid Year Appraisal";
    LookupPageId = "Mid Year Appraisal";

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
                updatePeriod();

                Department := '';
                Section := '';
                Supervisor := '';
                "Staff Name" := '';
                MidYearAppraisalLines.Reset;
                MidYearAppraisalLines.SetRange(MidYearAppraisalLines."Doc No", No);
                if MidYearAppraisalLines.FindSet then begin
                    MidYearAppraisalLines.DeleteAll;
                end;

                ObjEmp.Reset;
                ObjEmp.SetRange("No.", "Staff No");
                if ObjEmp.Find('-') then begin
                    "Staff Name" := ObjEmp."First Name" + ' ' + ObjEmp."Middle Name" + ' ' + ObjEmp."Last Name";
                    Directorate := ObjEmp."Responsibility Center";
                    Department := ObjEmp."Sub Responsibility Center";
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
                    ObjPeriods.SetRange(ObjPeriods.Open, true);//FALSE FRED 5/3/23 Changed from FALSE to true. We need an open period
                    if ObjPeriods.Find('-') then
                        Period := ObjPeriods.Code;
                    Validate(Department);

                    MidYearAppraisal.Reset();
                    MidYearAppraisal.SetRange(Period, Period);
                    MidYearAppraisal.SetRange("Staff No", "Staff No");
                    MidYearAppraisal.SetRange(Date, Date);
                    MidYearAppraisal.SetFilter(No, '<>%1', No);
                    if MidYearAppraisal.FindFirst() then
                        Error('You already have another review %1 for the selected date %2', MidYearAppraisal.No, Date);

                    if Confirm('This will create new lines. Do you want to proceed?', true) = true then begin
                        MidYearAppraisalLines.Reset;
                        MidYearAppraisalLines.SetRange(MidYearAppraisalLines."Doc No", No);
                        if MidYearAppraisalLines.FindSet then begin
                            MidYearAppraisalLines.DeleteAll;
                        end;
                        EntryNo := 0;
                        MidYearAppraisalLines.Reset();
                        MidYearAppraisalLines.SetCurrentKey("Entry No");
                        MidYearAppraisalLines.SetAscending("Entry No", true);
                        if MidYearAppraisalLines.FindLast() then
                            EntryNo := MidYearAppraisalLines."Entry No";

                        StaffTargetsLines.Reset;
                        StaffTargetsLines.SetRange("Staff No", "Staff No");
                        StaffTargetsLines.SetRange(Period, Period);
                        //StaffTargetsLines.SetRange("Due Date", Date);
                        if StaffTargetsLines.FindSet() then begin
                            repeat
                                StaffTargetsLines.CalcFields("Approved By Supervisor");
                                if StaffTargetsLines."Approved By Supervisor" then begin
                                    EntryNo += 1;
                                    MidYearAppraisalLines.Init;
                                    MidYearAppraisalLines."Doc No" := No;
                                    MidYearAppraisalLines."Entry No" := EntryNo;
                                    MidYearAppraisalLines.Type := MidYearAppraisalLines.Type::"Checkin Agenda";
                                    MidYearAppraisalLines."Objective Code" := StaffTargetsLines.No;
                                    MidYearAppraisalLines."Items/Description" := StaffTargetsLines.Objective;
                                    MidYearAppraisalLines."Staff No" := "Staff No";
                                    MidYearAppraisalLines.Period := StaffTargetsLines.Period;
                                    MidYearAppraisalLines."Success Measure" := StaffTargetsLines."Success Measure";
                                    MidYearAppraisalLines."Review Date" := Date;
                                    MidYearAppraisalLines.Insert;
                                end;
                            until StaffTargetsLines.Next = 0;
                        end else
                            Error('Targets for staff %1 for period %2 due on %3 not found', "Staff No", Period, Date);
                    end else
                        Message('Current lines retained');
                end;
            end;
        }
        field(3; "Staff Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Directorate; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
            Editable = false;
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
            begin
                if ResponsibilityCenter.Get(Department) then begin
                    "Department Name" := ResponsibilityCenter.Name;
                end;
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
                END ELSE MESSAGE('Current lines have not been replaced');*/

            end;
        }
        field(6; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;

            trigger OnValidate()
            begin
                /*MidYearAppraisalLines.Reset;
                MidYearAppraisalLines.SetRange(MidYearAppraisalLines."Doc No", No);
                if MidYearAppraisalLines.FindSet then begin
                    MidYearAppraisalLines.DeleteAll;
                end;

                StaffTargetLines.Reset;
                StaffTargetLines.SetRange("Staff No", "Staff No");
                StaffTargetLines.SetRange(Period, Period);
                if StaffTargetLines.FindFirst then begin
                    repeat*/
                //CreateMYALines(No,MDYALType::Goals,StaffTargetLines.Objective,StaffTargetLines."Success Measure");
                //CreateMYALines(No, MDYALType::"Checkin Agenda", StaffTargetLines.Objective, StaffTargetLines."Success Measure");
                //FRED 5/3/23 Added
                //CreateMYALines(No,MDYALType::Achievements,StaffTargetLines.Objective,StaffTargetLines."Success Measure");
                //CreateMYALines(No,MDYALType::Concerns,StaffTargetLines.Objective,StaffTargetLines."Success Measure");
                // CreateMYALines(No,MDYALType::"Agreed Actions",StaffTargetLines.Objective,StaffTargetLines."Success Measure");
                //until StaffTargetLines.Next = 0;

                //end;

                // StaffTargetLines.RESET;
                // StaffTargetLines.SETRANGE("Staff No","Staff No");
                // StaffTargetLines.SETRANGE(Period,Period);
                // IF StaffTargetLines.FINDFIRST THEN BEGIN
                //  REPEAT
                //    MidYearAppraisalLines2."Entry No":=MidYearAppraisalLines2."Entry No"+1;
                //    MidYearAppraisalLines2."Doc No":=No;
                //    MidYearAppraisalLines2.Type:=MidYearAppraisalLines.Type::"Checkin Agenda";
                //    MidYearAppraisalLines2."Items/Description":=StaffTargetLines.Objective;
                //    MidYearAppraisalLines2.INSERT;
                //  UNTIL StaffTargetLines.NEXT=0;
                //
                // END;
            end;
        }
        field(7; "Created On"; Date)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(8; "Created By"; Code[100])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(9; Supervisor; Code[20])
        {
            DataClassification = ToBeClassified;
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
        field(15; "Employee Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Supervisor Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; Date; Date)
        {
            Caption = 'Review Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                updatePeriod();
                if "Staff No" = '' then begin
                    MidYearAppraisalLines.Reset;
                    MidYearAppraisalLines.SetRange(MidYearAppraisalLines."Doc No", No);
                    if MidYearAppraisalLines.FindSet then
                        MidYearAppraisalLines.DeleteAll;
                end else
                    Validate("Staff No");
            end;
        }
        field(18; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open, Released';
            OptionMembers = Open,Released;
        }
        field(19; "Date-Time Sent For Approval"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Date-Time Approved"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Supervisor Rejection Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Annual,Probation;
        }
        field(23; "Department Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; Section; Code[70])
        {
            Caption = 'Section';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD(Department));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Created On", Period, No)
        {
            Clustered = true;
        }
        key(Key2; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ("Sent to Supervisor") or ("Approved By Supervisor") then
            Error('You cannot delete the record at this stage');
        MidYearAppraisalLines.Reset;
        MidYearAppraisalLines.SetRange(MidYearAppraisalLines."Doc No", No);
        if MidYearAppraisalLines.FindSet then begin
            MidYearAppraisalLines.DeleteAll;
        end;
    end;

    trigger OnInsert()
    begin
        if No = '' then begin
            MidYearAppraisal.Reset;
            if MidYearAppraisal.FindLast then begin
                No := IncStr(MidYearAppraisal.No);
            end else begin
                No := 'MDAPPR-001';
            end;
        end;
        if "Created By" = '' then
            "Created By" := UserId;
    end;

    var
        MidYearAppraisal: Record "Mid Year Appraisal";
        ObjEmp: Record Employee;
        ObjEmp2: Record Employee;
        ObjPeriods: Record "HR Appraisal Periods";
        StaffTargetLines: Record "Staff Target Lines";
        StaffTargetObjectives: Record "Staff Target Objectives";
        MDYALType: Option " ",Goals,"Checkin Agenda",Achievements,Concerns,"Agreed Actions","Employee Comments","Supervisor Comments";
        MidYearAppraisalLines: Record "MidYear Appraisal Lines";
        StaffTargetsLines: Record "Staff Target Lines";
        EntryNo: Integer;

    local procedure CreateMYALines(Docno: Code[100]; MYType: Option " ",Goals,"Checkin Agenda",Achievements,Concerns,"Agreed Actions","Employee Comments","Supervisor Comments"; Objjective: Text[250]; SuccessMeasure: Text[250])
    var
        MidYearAppraisalLines: Record "MidYear Appraisal Lines";
    begin
        MidYearAppraisalLines."Doc No" := Docno;
        MidYearAppraisalLines.Type := MYType;
        MidYearAppraisalLines."Items/Description" := Objjective;
        MidYearAppraisalLines."Success Measure" := SuccessMeasure;
        MidYearAppraisalLines.Insert;
        Commit;
    end;

    procedure updatePeriod()
    begin
        ObjPeriods.Reset;
        ObjPeriods.SetRange(ObjPeriods.Open, true);//FALSE FRED 5/3/23 Changed from FALSE to true. We need an open period
        if ObjPeriods.Find('-') then
            Period := ObjPeriods.Code;
    end;
}