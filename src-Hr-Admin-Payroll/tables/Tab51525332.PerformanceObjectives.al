table 51525332 "Performance Objectives"
{
    Caption = 'Performance Objectives';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No; Code[50])
        {
            Caption = 'No';
            Editable = false;
        }
        field(2; Theme; Text[100])
        {
            Caption = 'Theme';
            TableRelation = "Performance Management Themes".Title;
        }
        field(3; "Objective Description"; Text[250])
        {
            Caption = 'Objective Description';
        }
        field(4; "Success Measure"; Text[250])
        {
            Caption = 'Success Measure';
        }
        field(5; "Specific Action Plan"; Text[250])
        {
            Caption = 'Specific Action Plan';
        }
        field(6; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;
            Editable = false;
        }
    }
    keys
    {
        key(PK; No, "Objective Description")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if No = '' then begin
            PerfObjs.Reset;
            if PerfObjs.FindLast then begin
                No := IncStr(PerfObjs.No);
            end else begin
                No := 'POBJ-001';
            end;
        end;
        ObjPeriods.Reset;
        ObjPeriods.SetRange(ObjPeriods.Open, true);
        if not ObjPeriods.Find('-') then
            Error('There are no open periods!')//Period := ObjPeriods.Code;
        else
            Period := ObjPeriods.Code;
        //"Created By" := UserId;
        //"Created On" := Today;
    end;

    var
        PerfObjs: Record "Performance Objectives";
        ObjPeriods: Record "HR Appraisal Periods";
}