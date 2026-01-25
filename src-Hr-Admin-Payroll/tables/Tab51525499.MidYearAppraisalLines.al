table 51525499 "MidYear Appraisal Lines"
{
    fields
    {
        field(1; "Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Mid Year Appraisal".No;
        }
        field(2; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Goals,Checkin Agenda,Achievements,Concerns,Agreed Actions,Employee Comments,Supervisor Comments';
            OptionMembers = " ",Goals,"Checkin Agenda",Achievements,Concerns,"Agreed Actions","Employee Comments","Supervisor Comments";
        }
        field(4; "Section No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Items/Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Objective';
            //We do not expect you to add objectives because the targets were already approved
            Editable = false;
            //TableRelation = "Staff Target Lines".Objective WHERE(Period = FIELD(Period), Period = FIELD(Period));
        }
        field(6; "Staff Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Supervisor Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Period; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;
        }
        field(9; "Success Measure"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Big Success Measure"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Big Items/Description"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Proposed Resolution"; Text[250])
        { }
        field(13; "Concern Raised"; Text[250])
        { }
        field(14; "Agreed Support"; Text[250])
        { }
        field(15; "Big Agreed Support"; BLOB)
        { }
        field(16; "Big Concern Raised"; BLOB)
        { }
        field(17; "Big Proposed Resolution"; BLOB)
        { }
        field(18; "Staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(19; "Objective Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Staff Target Lines".No WHERE(Period = FIELD(Period), "Staff No" = FIELD("Staff No"));
            TableRelation = "Staff Target Lines".No WHERE(Period = FIELD(Period), "Staff No" = FIELD("Staff No"), "Due Date" = field("Review Date"));

            trigger OnValidate()
            var
                StaffTargetLines: Record "Staff Target Lines";
            begin
                "Items/Description" := '';
                if "Objective Code" <> '' then begin
                    StaffTargetLines.Reset();
                    StaffTargetLines.SetRange(No, "Objective Code");
                    if StaffTargetLines.FindFirst() then
                        "Items/Description" := StaffTargetLines.Objective;
                end;
            end;
        }

        field(20; "Review Date"; Date)
        { }
    }

    keys
    {
        key(Key1; "Doc No", Type, "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        MidYearLines: Record "MidYear Appraisal Lines";

    procedure setCriticalFields()
    var
        Header: Record "Mid Year Appraisal";
    begin
        Header.Reset();
        Header.SetRange(No, "Doc No");
        if Header.FindFirst() then begin
            "Staff No" := Header."Staff No";
            Period := Header.Period;
            "Review Date" := Header.Date;
        end;
    end;
}