table 51525493 "Training Locations"
{
    Caption = 'Training Locations';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Training Locations";
    LookupPageId = "Training Locations";

    fields
    {
        field(1; "Line No."; Integer)
        {
            Editable = false;
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(2; Location; Text[250])
        {
            Caption = 'Location';
        }
    }
    keys
    {
        key(PK; "Line No.", Location)
        {
            Clustered = true;
        }
        key(Key2; Location)
        { }
    }
}