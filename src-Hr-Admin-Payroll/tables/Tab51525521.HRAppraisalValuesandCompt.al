table 51525521 "HR Appraisal Values and Compt."
{
    Caption = 'HR Appraisal Values & Competences';
    DrillDownPageID = "HR Appraisal Values - List";
    LookupPageID = "HR Appraisal Values - List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Editable = false;
        }
        field(2; Category; Option)
        {
            OptionMembers = " ","Staff Values & Core Competence","Peers And Surbodinates","External Customer";
        }
        field(3; Description; Text[250])
        {
        }
        field(4; "Description 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Appraisal Period"; Code[60])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Appraisal Periods";
        }
    }

    keys
    {
        key(Key1; "Code", Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Lines_ValComp: Record "HR Appraisal Lines - Values";
    begin
        Lines_ValComp.Reset;
        Lines_ValComp.SetRange(Description, Description);
        if not Lines_ValComp.IsEmpty then begin
            Error('You cannot Delete this Records because it in use already in an Appraisal Period');
        end;
    end;

    trigger OnInsert()
    begin
        //No. Series
        if Code = '' then begin
            HRAppValComp.Reset();
            if HRAppValComp.FindLast then begin
                Code := IncStr(HRAppValComp.Code)
            end else begin
                Code := 'VCL-0001';
            end;
        end;
    end;

    var
        HRAppValComp: Record "HR Appraisal Values and Compt.";
        HRAppraisalPeriods: Record "HR Appraisal Periods";
}