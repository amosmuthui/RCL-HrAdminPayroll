table 51525528 "Department Objective Lines"
{
    fields
    {
        field(1; "Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Objective Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Objective; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Success Measure"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Output,Outcome;
        }
        field(5; "Department LK"; Code[20])
        {
            CalcFormula = Lookup("Department Objectives Header".Department WHERE(No = FIELD("Doc No")));
            FieldClass = FlowField;
        }
        field(6; "Directorate LK"; Code[20])
        {
            CalcFormula = Lookup("Department Objectives Header".Directorate WHERE(No = FIELD("Doc No")));
            FieldClass = FlowField;
        }
        field(7; "Period LK"; Code[20])
        {
            CalcFormula = Lookup("Department Objectives Header".Period WHERE(No = FIELD("Doc No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Doc No", "Objective Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Objective Code" = '' then begin
            Objectives.Reset;
            Objectives.SetRange(Objectives."Doc No", "Doc No");
            if Objectives.FindLast then begin
                "Objective Code" := IncStr(Objectives."Objective Code");
            end else begin
                "Objective Code" := 'OBJECTIVE-001';
            end;
        end;
    end;

    var
        Objectives: Record "Department Objective Lines";
}