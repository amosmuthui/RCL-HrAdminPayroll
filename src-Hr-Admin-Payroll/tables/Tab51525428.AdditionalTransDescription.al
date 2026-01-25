table 51525428 "Additional Trans Description"
{
    Caption = 'Additional Trans Description';
    DataClassification = ToBeClassified;
    LookupPageId = "Additional Trans Description";
    DrillDownPageId = "Additional Trans Description";

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(2; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = Earning,Deduction;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Trans Code"; Code[20])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Line No.", "Type", Description)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if ("Trans Code" = '') and ("Type" = "Type"::Earning) then begin
            TransDescriptions.Reset();
            TransDescriptions.SetRange("Type", "Type"::Earning);
            if TransDescriptions.FindLast then begin
                "Trans Code" := IncStr(TransDescriptions."Trans Code")
            end else begin
                "Trans Code" := 'E01';
            end;
        end;
        if ("Trans Code" = '') and ("Type" = "Type"::Deduction) then begin
            TransDescriptions.Reset();
            TransDescriptions.SetRange("Type", "Type"::Deduction);
            if TransDescriptions.FindLast then begin
                "Trans Code" := IncStr(TransDescriptions."Trans Code")
            end else begin
                "Trans Code" := 'D01';
            end;
        end;
    end;

    var
        TransDescriptions: Record "Additional Trans Description";
}