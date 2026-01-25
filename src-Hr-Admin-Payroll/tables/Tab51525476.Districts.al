table 51525476 Districts
{
    Caption = 'Districts';
    DataClassification = ToBeClassified;
    LookupPageId = Districts;

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
        field(3; Province; Code[50])
        {
            Caption = 'Province';
            TableRelation = "Provinces";
        }
    }
    keys
    {
        key(PK; Name, Province)
        {
            Clustered = true;
        }
    }
}