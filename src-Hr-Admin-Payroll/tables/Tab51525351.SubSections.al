table 51525351 "Sub Sections"
{
    Caption = 'Sub Sections';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[240])
        {
            Caption = 'Code';
        }
        field(2; "Section Code"; Code[240])
        {
            Caption = 'Section Code';
            TableRelation = "Sub Responsibility Center";
        }
        field(3; Name; Text[240])
        {
            Caption = 'Name';
        }
    }
    keys
    {
        key(PK; "Code", "Section Code")
        {
            Clustered = true;
        }
    }
}