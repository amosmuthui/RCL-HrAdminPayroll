table 51525483 "Seconding Organizations"
{
    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Ministry,Parastatal,Private,NGO';
            OptionMembers = ,Ministry,Parastatal,Private,NGO;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}