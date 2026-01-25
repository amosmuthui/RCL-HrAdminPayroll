table 51525321 "Social Grades"
{
    Caption = 'Social Grades';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Band No."; Code[20])
        {
            Caption = 'Band No.';
        }
        field(2; Country; Code[50])
        {
            Caption = 'Country';
            TableRelation = "Country/Region";
        }
        field(3; "No. of Children"; Integer)
        {
            Caption = 'No. of Children';
        }
        field(4; "Married Grade"; Decimal)
        {
            Caption = 'Married Grade';
        }
        field(5; "Single Grade"; Decimal)
        {
            Caption = 'Single Grade';
        }
    }
    keys
    {
        key(PK; "Band No.", Country)
        {
            Clustered = true;
        }
    }
}