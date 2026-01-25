table 51525335 "WB Departmental Targets"
{
    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            /*trigger OnValidate()
            begin
                "Objective Code" := No;
            end;*/
        }
        field(2; "Main Objective Code"; Code[20])
        {
            Caption = 'Org. Target Code';
            DataClassification = ToBeClassified;
            TableRelation = "Performance Objectives".No where(Period = field(Period));

            trigger OnValidate()
            var
                PerfObjectives: Record "Performance Objectives";
                MaxValue: Integer;
                CurrentValueText: Text[250];
                CurrentValue: Integer;
                Number: Code[250];
            begin
                if No = '' then begin
                    // DeptTargets.Reset;
                    // if DeptTargets.FindLast then begin
                    //     No := IncStr(DeptTargets.No);
                    // end else begin
                    //     No := 'DPOBJ-001';
                    // end;
                    MaxValue := 0;
                    DeptTargets.RESET;
                    IF DeptTargets.FINDSET THEN
                        REPEAT
                            CurrentValueText := DELCHR(DeptTargets.No, '=', DELCHR(DeptTargets.No, '=', '1234567890'));
                            EVALUATE(CurrentValue, CurrentValueText);
                            IF CurrentValue > MaxValue THEN
                                MaxValue := CurrentValue;
                        UNTIL DeptTargets.NEXT = 0;

                    Number := 'DPOBJ-' + FORMAT(MaxValue + 1);
                    No := Number;
                end;

                PerfObjectives.Reset();
                PerfObjectives.SetRange(No, "Main Objective Code");
                if PerfObjectives.FindFirst() then begin
                    "Main Objective Description" := PerfObjectives."Objective Description";
                    "Success Measure" := PerfObjectives."Success Measure";
                    "Specific Action Plan" := PerfObjectives."Specific Action Plan";
                    Theme := PerfObjectives.Theme;
                end;
            end;
        }
        field(3; "Main Objective Description"; Text[250])
        {
            Caption = 'Org. Target Description';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(4; "Success Measure"; Text[250])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(5; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Department Code"; Code[240])
        {
            Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
            trigger OnValidate()
            var
                ResponsibilityCenter: Record "Responsibility Center";
            begin
                if ResponsibilityCenter.Get("Department Code") then begin
                    "Department Name" := ResponsibilityCenter.Name;
                end;
            end;
        }
        field(7; "Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Appraisal Periods".Period;
            Editable = false;
        }
        field(9; "Specific Action Plan"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Due Date Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Big Specific Action Plan"; BLOB)
        {
            Compressed = false;
            DataClassification = ToBeClassified;
        }
        field(12; "Big Success Measure"; BLOB)
        {
            Compressed = false;
            DataClassification = ToBeClassified;
        }
        field(13; Theme; Text[100])
        {
            Caption = 'Theme';
            TableRelation = "Performance Management Themes".Title;
            Editable = false;
        }
        field(14; "Departmental Objective"; Text[100])
        {
            Caption = 'Departmental Target';
        }
        field(15; "Department Name"; Text[240])
        {
            Editable = false;
        }
        field(16; "Created By"; Code[240])
        {
            TableRelation = User;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Department Code", No, Period)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        MaxValue: Integer;
        CurrentValueText: Text[250];
        CurrentValue: Integer;
        Number: Code[250];
    begin
        if CreatedBy = '' then
            CreatedBy := UserId;
        EmpRec.Reset();
        EmpRec.SetRange("User ID", CreatedBy);
        if EmpRec.FindFirst() then begin
            EmpRec.CalcFields("Is HoD");
            if not EmpRec."Is HoD" then
                Error('Only department heads are allowed to create departmental targets!');
        end;
        if No = '' then begin
            // DeptTargets.Reset;
            // if DeptTargets.FindLast then begin
            //     No := IncStr(DeptTargets.No);
            // end else begin
            //     No := 'DPOBJ-001';
            // end;
            MaxValue := 0;
            DeptTargets.RESET;
            IF DeptTargets.FINDSET THEN
                REPEAT
                    CurrentValueText := DELCHR(DeptTargets.No, '=', DELCHR(DeptTargets.No, '=', '1234567890'));
                    EVALUATE(CurrentValue, CurrentValueText);
                    IF CurrentValue > MaxValue THEN
                        MaxValue := CurrentValue;
                UNTIL DeptTargets.NEXT = 0;

            Number := 'DPOBJ-' + FORMAT(MaxValue + 1);
            No := Number;
        end;
        //Validate(No);
        HrAppraissalPeriods.Reset();
        HrAppraissalPeriods.SetRange(Open, true);
        if HrAppraissalPeriods.FindFirst() then
            Period := HrAppraissalPeriods.Code
        else
            Error('There are no open periods!');
    end;

    trigger OnModify()
    var
    begin
        if CreatedBy = '' then
            CreatedBy := UserId;
        EmpRec.Reset();
        EmpRec.SetRange("User ID", CreatedBy);
        if EmpRec.FindFirst() then begin
            EmpRec.CalcFields("Is HoD");
            if not EmpRec."Is HoD" then
                Error('Only department heads are allowed to edit departmental targets!');
        end;
    end;

    var
        DeptTargets: Record "WB Departmental Targets";
        StaffTargetObjectives: Record "Staff Target Objectives";
        HrAppraissalPeriods: Record "HR Appraisal Periods";
        EmpRec: Record Employee;
        CreatedBy: Code[200];
}