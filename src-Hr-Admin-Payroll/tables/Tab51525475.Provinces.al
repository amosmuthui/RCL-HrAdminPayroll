table 51525475 Provinces
{
    Caption = 'Provinces';
    DataClassification = ToBeClassified;
    LookupPageId = Provinces;

    fields
    {
        field(1; Name; Code[50])
        {
            Caption = 'Name';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}