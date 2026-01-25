table 51525496 "Staff Appraisal Lines"
{
    fields
    {
        field(1; "Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Objectives,Management Leadership,Job Knowledge,Problem Solving,Communication and Teamwork,Learning Goals,Employee Comments,Supervisor Comments';
            OptionMembers = ,Objectives,"Management Leadership","Job Knowledge","Problem Solving","Communication and Teamwork","Learning Goals","Employee Comments","Supervisor Comments";
        }
        field(4; Rate; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 1;

            trigger OnValidate()
            begin
                if Rate > 5 then Error('Rate cannot be more than 5');
                //"Section Rating":=("Supervisor Rate"+Rate)/2;
                //"Section Rating" := "Supervisor Rate";
                Validate("Supervisor Rate");
            end;
        }
        field(5; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Objective Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Staff Target Lines".No WHERE(Period = FIELD(Period), "Staff No" = FIELD("Staff No"));

            trigger OnValidate()
            var
                StaffTargetLines: Record "Staff Target Lines";
            begin
                Objective := '';
                if "Objective Code" <> '' then begin
                    StaffTargetLines.Reset();
                    StaffTargetLines.SetRange(No, "Objective Code");
                    if StaffTargetLines.FindFirst() then
                        Objective := StaffTargetLines.Objective;
                end;
            end;
        }
        field(7; Objective; Text[250])
        {
            FieldClass = Normal;
            Editable = false;
        }
        field(8; "Supervisor Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Supervisor Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 1;

            trigger OnValidate()
            begin
                if "Supervisor Rate" > 5 then Error('Rate cannot be more than 5');
                if Rate <> 0 then
                    "Section Rating" := Round(("Supervisor Rate" + Rate) / 2, 1, '=')
                else
                    "Section Rating" := "Supervisor Rate";
                Validate("Section Rating");
            end;
        }
        field(10; "Staff No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Success Measure"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Section Rating"; Decimal)
        {
            Caption = 'Agreed Rating';
            MaxValue = 5;
            MinValue = 1;

            trigger OnValidate()
            begin
                if "Section Rating" > 5 then Error('Rate cannot be more than 5');
                "Remark Id" := "Section Rating";
                Validate("Remark Id");
                "Score(%)" := ("Section Rating" / 5) * 100;
            end;
        }
        field(14; "Remark Id"; Integer)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            TableRelation = "Appraisal Remarks"."Entry No";

            trigger OnValidate()
            begin
                //Force remark id to pick from agreed rating
                "Remark Id" := "Section Rating";
                if AppraisalRemarks.Get("Remark Id") then
                    Remarks := AppraisalRemarks.Remarks;
            end;
        }
        field(15; "Employees Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Appraisee Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Appraisee Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 5;
            MinValue = 1;
        }
        field(18; "Peer 1 Feedback"; Text[250])
        {
            FieldClass = Normal;
        }
        field(19; "Peer 2 Feedback"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Peer 3 Feedback"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(21; Period; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods".Code;
        }
        field(22; "Big Success Measure"; BLOB)
        {
            Compressed = false;
            DataClassification = ToBeClassified;
        }
        field(23; Theme; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Score(%)"; Decimal)
        {

        }
    }

    keys
    {
        key(Key1; "Doc No", "Entry No")
        {
            Clustered = true;
        }
        key(Key2; "Doc No", Type, "Entry No", "Objective Code", "Staff No")
        {
            //Clustered = true;
            Enabled = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        /*PeerAppraisalHeader.RESET;
        PeerAppraisalHeader.SETRANGE(No, "Doc No");
        PeerAppraisalHeader.SETRANGE();*/


        StaffApprHeader.Reset;
        StaffApprHeader.SetRange(No, "Doc No");
        if StaffApprHeader.FindFirst then begin
            "Staff No" := StaffApprHeader."Staff No";
            Period := StaffApprHeader.Period;
        end;

        StaffApprLines.Reset;
        StaffApprLines.SetRange("Staff No", "Staff No");
        StaffApprLines.SetRange(Period, Period);
        //IF (Type IN [Type::"Communication and Teamwork",Type::"Management Leadership",Type::"Job Knowledge",Type::"Problem Solving"]) THEN
        StaffApprLines.SetRange(Type, Type);
        /*IF (Type = Type::Objectives) AND ("Objective Code" <> '') THEN BEGIN
          StaffApprLines.SETRANGE("Objective Code","Objective Code");
        END;*/
        StaffApprLines.SetFilter("Entry No", '<>%1', "Entry No");
        if (StaffApprLines.FindFirst) and (Type in [Type::"Communication and Teamwork", Type::"Management Leadership", Type::"Job Knowledge", Type::"Problem Solving"]) then
            Error('For section 2, you can only input 1 line per sub-section');


        if Type = Type::"Management Leadership" then
            PeerApprType := PeerApprType::"Management Leadership";
        if Type = Type::"Job Knowledge" then
            PeerApprType := PeerApprType::"Job Knowledge";
        if Type = Type::"Problem Solving" then
            PeerApprType := PeerApprType::"Problem Solving";
        if Type = Type::"Communication and Teamwork" then
            PeerApprType := PeerApprType::"Communication and Teamwork";

        PeerApprLines.Reset;
        PeerApprLines.SetRange("Staff No", "Staff No");
        PeerApprLines.SetRange(Period, Period);
        PeerApprLines.SetRange(Type, PeerApprType);
        if PeerApprLines.FindSet then begin
            repeat
                if /*(PeerApprLines.Type = Type) AND*/ (PeerApprLines."Peer Level" = PeerApprLines."Peer Level"::First) then
                    "Peer 1 Feedback" := PeerApprLines.Remarks;
                if /*(PeerApprLines.Type = Type) AND*/ (PeerApprLines."Peer Level" = PeerApprLines."Peer Level"::Second) then
                    "Peer 2 Feedback" := PeerApprLines.Remarks;
                if /*(PeerApprLines.Type = Type) AND*/ (PeerApprLines."Peer Level" = PeerApprLines."Peer Level"::Third) then
                    "Peer 3 Feedback" := PeerApprLines.Remarks;
            until PeerApprLines.Next = 0;
        end;

        Validate(Rate);
        Validate("Supervisor Rate");
        Validate("Appraisee Rate");
        Validate("Section Rating");

    end;

    trigger OnModify()
    begin
        Validate(Rate);
        Validate("Supervisor Rate");
        Validate("Appraisee Rate");
        Validate("Section Rating");
    end;

    var
        //MidYearLines: Record "MidYear Appraisal Lines";
        PeerAppraisalHeader: Record "Peer Appraisal Header";
        ObjEmp: Record Employee;
        AppraisalRemarks: Record "Appraisal Remarks";
        StaffApprLines: Record "Staff Appraisal Lines";
        StaffApprHeader: Record "Staff Appraisal Header";
        PeerApprLines: Record "Peer Appraisal Lines";
        PeerApprType: Option " ","Management Leadership","Job Knowledge","Problem Solving","Communication and Teamwork","Additional Comments";
}