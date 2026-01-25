table 51525358 "External Trainers"
{
    Caption = 'External Trainers';
    DataClassification = ToBeClassified;
    LookupPageId = "External Trainers";
    DrillDownPageId = "External Trainers";

    fields
    {
        field(1; "No."; Code[100])
        {
            Editable = false;
            Caption = 'No.';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; Signature; BLOB)
        {
            Caption = 'Signature';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        ExtTr: Record "External Trainers";
    begin
        if TrainingMasterPlan.IsAReadOnlyUser() then
            Error('You are not authorized to modify these records!');

        if "No." = '' then begin
            ExtTr.Reset();
            if ExtTr.FindLast() then
                "No." := IncStr(ExtTr."No.")
            else
                "No." := 'TRNR00001';
        end;
    end;

    trigger OnModify()
    begin
        if TrainingMasterPlan.IsAReadOnlyUser() then
            Error('You are not authorized to modify these records!');
    end;

    var
        TrainingMasterPlan: Record "Training Master Plan Header";
}