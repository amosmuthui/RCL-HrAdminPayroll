table 51525477 Sectors
{
    Caption = 'Sectors';
    DataClassification = ToBeClassified;
    LookupPageId = Sectors;

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
        field(3; District; Code[50])
        {
            Caption = 'District';
            TableRelation = "Districts";
        }
    }
    keys
    {
        key(PK; Name, District)
        {
            Clustered = true;
        }
    }
}