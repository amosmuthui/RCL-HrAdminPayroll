table 51525386 "Professional Bodies"
{
    fields
    {
        field(1; ProfessionalBodyID; Integer)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(2; ProfessionalBodyName; Text[250])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ProfessionalBodyID, ProfessionalBodyName)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; ProfessionalBodyID, ProfessionalBodyName)
        {
        }
    }
}