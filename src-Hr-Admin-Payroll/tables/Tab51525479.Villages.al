table 51525479 Villages
{
    Caption = 'Villages';
    DataClassification = ToBeClassified;
    LookupPageId = Villages;

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
        field(3; Cell; Code[50])
        {
            Caption = 'Cell';
            TableRelation = "Cells";
        }
    }
    keys
    {
        key(PK; Name, Cell)
        {
            Clustered = true;
        }
    }
}