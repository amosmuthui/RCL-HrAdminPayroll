table 51525342 "Training Master Plan Lines"
{
    Caption = 'Training Master Plan Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(2; "No."; Code[30])
        {
            Caption = 'No.';
            Editable = false;
            TableRelation = "Training Master Plan Header"."No.";
        }
        field(3; Position; Code[50])
        {
            Caption = 'Position ID';
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            var
                Jobs: Record "Company Jobs";
            begin
                if Position <> '' then begin
                    Jobs.Reset();
                    Jobs.SetRange("Job ID", Position);
                    if Jobs.FindFirst() then
                        "Job Title" := Jobs."Job Description";
                end;
            end;
        }
        field(4; "Job Title"; Text[250])
        {
            Caption = 'Position Title';
            Editable = false;
        }
        field(5; "Dept Code"; Code[50])
        {
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            var
                Dept: Record "Responsibility Center";
            begin
                Dept.Reset();
                Dept.SetRange(Code, "Dept Code");
                if Dept.FindFirst() then
                    "Department Name" := Dept.Name;
            end;
        }
        field(6; "Department Name"; Text[250])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Line No.", "No.")
        {
            Clustered = true;
        }
    }
}