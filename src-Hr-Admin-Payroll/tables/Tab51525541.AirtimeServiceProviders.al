table 51525541 "Airtime Service Providers"
{
    Caption = 'Airtime Service Providers';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Airtime Service Providers";
    LookupPageId = "Airtime Service Providers";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[200])
        {
            Caption = 'Name';
        }
        field(3; "E-Mail"; Text[200])
        {
            Caption = 'E-Mail';
        }
        field(4; Default; Boolean)
        {
            Caption = 'Default';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
