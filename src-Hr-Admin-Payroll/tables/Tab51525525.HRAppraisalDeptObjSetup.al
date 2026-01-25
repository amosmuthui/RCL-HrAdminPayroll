table 51525525 "HR Appraisal Dept. Obj. Setup"
{
    Caption = 'HR Appraisal Departmental Objectives Setup';
    DrillDownPageID = "HR Appraisal Dept. Obj. Setup";
    LookupPageID = "HR Appraisal Dept. Obj. Setup";

    fields
    {
        field(1; "Objective Code"; Code[20])
        {
            Editable = false;
        }
        field(2; "Objective Description"; Text[150])
        {
        }
        field(3; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;

            trigger OnValidate()
            var
                DimensionValue: Record "Dimension Value";
            begin

                Clear("Department Name");

                DimensionValue.Reset();
                DimensionValue.SetRange(Code, "Department Code");
                if DimensionValue.FindFirst() then "Department Name" := DimensionValue.Name;
            end;
        }
        field(4; "Appraisal Period"; Code[20])
        {
            Editable = false;
            TableRelation = "HR Appraisal Periods".Code;
        }
        field(5; "Department Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Perspective Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code WHERE(Type = CONST("Appraisal Perspective"));

            trigger OnValidate()
            begin
                HRLookupValues.Reset();
                HRLookupValues.SetRange(Type, HRLookupValues.Type::"Appraisal Perspective");
                HRLookupValues.SetRange(Code, "Perspective Type");
                HRLookupValues.FindFirst();

                "Perspective Description" := HRLookupValues.Description;
            end;
        }
        field(9; "Perspective Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Objective Code", "Department Code", "Perspective Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Lines_DeptObject: Record "HR Appraisal Lines - DO";
        ERR_DELETE_OBJECTIVE: Label 'You cannot Delete the Objective because it has been Assigned in Appraisal File [ %1 ]';
    begin
    end;

    trigger OnInsert()
    begin
        //Insert Appraisal Period
        HRAppPeriod.Reset;
        HRAppPeriod.SetRange(Open, true);
        if HRAppPeriod.Find('-') then begin
            //More than once period exists
            if HRAppPeriod.Count > 1 then Error(ERR_ACTIVE_APPRAISAL_PERIOD, HRAppPeriod.Count);

            HRAppPeriod.TestField("Period Start Date");
            HRAppPeriod.TestField("Period End Date");

            "Appraisal Period" := HRAppPeriod.Code;
        end;

        //No. Series
        if "Objective Code" = '' then begin
            HRAppDeptObj.Reset();
            if HRAppDeptObj.FindLast then begin
                "Objective Code" := IncStr(HRAppDeptObj."Objective Code")
            end else begin
                "Objective Code" := 'OBJ-0001';
            end;
        end;
    end;

    var
        ERR_ACTIVE_APPRAISAL_PERIOD: Label 'There are currently [ %1 ] Active Appraisal Period. Please ensure one Period  is Active';
        HRAppPeriod: Record "HR Appraisal Periods";
        HRAppDeptObj: Record "HR Appraisal Dept. Obj. Setup";
        HRApprPespectives: Record "HR Appraisal Pespectives";
        HRLookupValues: Record "HR Lookup Values";
}