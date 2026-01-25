table 51525529 "Department Objectives Header"
{
    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;
        }
        field(4; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Department; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD(Directorate));
        }
        field(6; Directorate; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
        }
        field(7; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Created On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'General,Probation';
            OptionMembers = General,Probation;
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

    trigger OnInsert()
    begin
        if No = '' then begin
            DeptObjectives.Reset;
            if DeptObjectives.FindLast then begin
                No := IncStr(DeptObjectives.No);
            end else begin
                No := 'DEPT-OBJECTIVE001';
            end;
        end;
        "Created By" := UserId;
        "Created On" := CreateDateTime(Today, Time);
    end;

    var
        DeptObjectives: Record "Department Objectives Header";
}