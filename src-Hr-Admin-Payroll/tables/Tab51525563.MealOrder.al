table 51525563 "Meal Order"
{
    Caption = 'Meal Order';
    DataClassification = ToBeClassified;
    LookupPageId = "Meal Order Setup";

    fields
    {
        field(1; "Code"; Code[30])
        {
            Caption = 'Code';
        }
        field(2; "task assignments "; Text[300])
        {
            Caption = 'task assignments ';
        }
        field(3; "Meal Orders"; Text[300])
        {
            Caption = 'Meal Orders';
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
