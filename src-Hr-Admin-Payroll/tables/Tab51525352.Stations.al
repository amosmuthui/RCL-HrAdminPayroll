table 51525352 Stations
{
    Caption = 'Stations';
    DataClassification = ToBeClassified;
    LookupPageId = Stations;

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
        field(3; Country; Code[50])
        {
            Caption = 'Country';
            TableRelation = "Country/Region";
        }
    }
    keys
    {
        key(PK; Name, Country)
        {
            Clustered = true;
        }
    }
}