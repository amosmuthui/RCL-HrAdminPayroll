table 51525478 Cells
{
    Caption = 'Cells';
    DataClassification = ToBeClassified;
    LookupPageId = Cells;

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
        field(3; Sector; Code[50])
        {
            Caption = 'Sector';
            TableRelation = "Sectors";
        }
    }
    keys
    {
        key(PK; Name, Sector)
        {
            Clustered = true;
        }
    }
}