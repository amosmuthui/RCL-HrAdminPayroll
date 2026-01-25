table 51525304 "Company Jobs"
{
    DrillDownPageID = "Company Job List";
    LookupPageID = "Company Job List";

    fields
    {
        field(1; "Job ID"; Code[150])
        {
            //NotBlank = true;
            Editable = false;
        }
        field(2; "Job Description"; Text[250])
        {
        }
        field(3; "No of Posts"; Integer)
        {

            trigger OnValidate()
            begin
                if "No of Posts" <> xRec."No of Posts" then
                    "Vacant Establishments" := "No of Posts" - "Occupied Establishments";
            end;
        }
        field(4; "Position Reporting to"; Code[60])
        {
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            var
                job: Record "Company Jobs";
            begin
                if "Position Reporting to" <> '' then begin
                    job.Reset();
                    job.SetRange("Job ID", "Position Reporting to");
                    if job.FindFirst() then
                        "Supervisor Position" := job."Job Description";
                end;
            end;
        }
        field(5; "Occupied Establishments"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Position = FIELD("Job ID"),
                                                Status = CONST(Active)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //Count(Employee WHERE (Position=FIELD(Job ID), Status=CONST(Active)))
            end;
        }
        field(6; "Vacant Establishments"; Integer)
        {
        }
        field(7; "Score code"; Code[20])
        {
            TableRelation = "Company Jobs";
        }
        field(8; "Dimension 1"; Code[30])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                DimensionRec.Reset;
                DimensionRec.SetRange("Global Dimension No.", 1);
                DimensionRec.SetRange(DimensionRec.Code, "Dimension 1");
                if DimensionRec.Find('-') then
                    "Directorate Name" := DimensionRec.Name;
            end;
        }
        field(9; "Dimension 2"; Code[30])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                DimensionRec.Reset;
                DimensionRec.SetRange("Global Dimension No.", 2);
                DimensionRec.SetRange(DimensionRec.Code, "Dimension 2");
                if DimensionRec.Find('-') then
                    "Department Name" := DimensionRec.Name;
            end;
        }
        field(10; "Dimension 3"; Code[30])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(11; "Dimension 4"; Code[30])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(12; "Dimension 5"; Code[30])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(13; "Dimension 6"; Code[30])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(14; "Dimension 7"; Code[30])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(15; "Dimension 8"; Code[30])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        field(16; "No of Position"; Integer)
        {
        }
        field(17; "Total Score"; Decimal)
        {
            CalcFormula = Sum("Job Requirement"."Score ID" WHERE("Job Id" = FIELD("Job ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Stage filter"; Integer)
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value";
        }
        field(19; Objective; Text[1094])
        {
        }
        field(21; "Key Position"; Boolean)
        {
        }
        field(22; Category; Code[40])
        {
        }
        field(23; Grade; Code[60])
        {
        }
        field(24; "Primary Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(25; "2nd Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(26; "3nd Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(27; Management; Boolean)
        {
        }
        field(28; Variance; Integer)
        {
        }
        field(29; "Notice Period"; DateFormula)
        {
        }
        field(30; "Probation Period"; DateFormula)
        {
        }
        field(31; "Date Active"; Date)
        {
        }
        field(32; "Structure Identifier"; Code[60])
        {
            //TableRelation = "Structure Identifier Tables";
        }
        field(33; "Directorate Name"; Text[80])
        {
        }
        field(34; "Department Name"; Text[80])
        {
        }
        field(35; Status; Option)
        {
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(36; "JD Attachment Link"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Salary Allocation %"; Decimal)
        {
            CalcFormula = Sum("Salary Allocation".Percentage WHERE("Job ID/Employee ID" = CONST(perJobID),
                                                                    "Employee No" = FIELD("Job ID")));
            Editable = false;
            FieldClass = FlowField;
            MaxValue = 100;
        }
        field(38; "Supervisor Position"; Text[250])
        {
            Editable = false;
        }
        field(39; "Department Code"; Code[250])
        {
            TableRelation = "Responsibility Center";
            trigger OnValidate()
            var
                resp: Record "Responsibility Center";
            begin
                if "Department Code" <> '' then begin
                    resp.Reset();
                    resp.SetRange(Code, "Department Code");
                    if resp.FindFirst() then
                        "Department Name" := resp.Name;
                end;
            end;
        }
        field(40; "Section Code"; Code[250])
        {
            TableRelation = "Sub Responsibility Center"."Code" where("Responsibility Center" = field("Department Code"));

            trigger OnValidate()
            var
                subResp: Record "Sub Responsibility Center";
            begin
                if "Section Code" <> '' then begin
                    subResp.Reset();
                    subResp.SetRange(Code, "Section Code");
                    if subResp.FindFirst() then
                        "Section Name" := subResp.Description;
                end;
            end;
        }
        field(41; "Section Name"; Text[250])
        {
            Editable = false;
        }
        field(42; "Given Transport Allowance"; Boolean)
        { }
    }

    keys
    {
        key(Key1; "Job ID", "Dimension 1")
        {
            Clustered = true;
        }
        key(Key2; "Vacant Establishments")
        {
        }
        key(Key3; "Dimension 1")
        {
        }
        key(Key4; "Dimension 2")
        {
        }
        key(Key5; "Job Description")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Job ID", "Job Description", "Dimension 1", "Dimension 2")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Job ID" = '' then begin
            CompJob.Reset();
            if CompJob.FindLast then begin
                "Job ID" := IncStr(CompJob."Job ID")
            end else begin
                "Job ID" := 'JOB0001';
            end;
        end;
    end;

    trigger OnDelete()
    begin
        Error('Deleting is not allowed!');
    end;

    var
        DimensionRec: Record "Dimension Value";
        CompJob: Record "Company Jobs";
}