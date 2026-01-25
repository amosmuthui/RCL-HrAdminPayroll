table 51525548 "Refreshment Types"
{
    Caption = 'Refreshment Types';
    DataClassification = ToBeClassified;
    LookupPageId = "Refreshment Types";
    DrillDownPageId = "Refreshment Types";

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    var
        RefreshmentDetails: Record "Refreshment Details";

    trigger OnDelete()
    begin
        RefreshmentDetails.Reset();
        RefreshmentDetails.SetRange("Type Code", Rec.Code);
        if RefreshmentDetails.Find('-') then
            Error('You cannot delete this refresh type because it has been used in refreshment requests!');
    end;
}
