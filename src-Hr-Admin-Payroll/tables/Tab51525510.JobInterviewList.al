table 51525510 "Job Interview List"
{
    fields
    {
        field(1; "Recruitment No."; Code[20])
        {
        }
        field(2; "Interview Type"; Option)
        {
            OptionCaption = ',Oral Interview,Technical Interview';
            OptionMembers = ,"Oral Interview","Technical Interview";
        }
        field(3; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(4; Description; Text[250])
        {
        }
        field(5; Score; Decimal)
        {
        }
        field(6; "Maximum Score"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Recruitment No.", "Interview Type", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*if ProcurementRequest.Get("Recruitment No.") then begin
            if ProcurementRequest.Status <> ProcurementRequest.Status::Open then
                Error('You Cannot Modify This Document At this Level');
        end;*/
    end;

    trigger OnInsert()
    begin
        /*if ProcurementRequest.Get("Recruitment No.") then begin
            if ProcurementRequest.Status <> ProcurementRequest.Status::Open then
                Error('You Cannot Modify This Document At this Level');
        end;*/
    end;

    trigger OnModify()
    begin
        /*if ProcurementRequest.Get("Recruitment No.") then begin
            if ProcurementRequest.Status <> ProcurementRequest.Status::Open then
                Error('You Cannot Modify This Document At this Level');
        end;*/
    end;

    var
    //ProcurementRequest: Record "Procurement Request";
}