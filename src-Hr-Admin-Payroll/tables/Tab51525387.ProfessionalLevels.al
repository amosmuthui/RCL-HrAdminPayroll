table 51525387 "Professional Levels"
{
    fields
    {
        field(1; ProfessionalLevelID; Integer)
        {
        }
        field(2; ProfessionalLevelName; Text[250])
        {
        }
        field(3; ProfessionalBodyID; Integer)
        {
            TableRelation = "Professional Bodies".ProfessionalBodyID;
        }
        field(4; "Body Name"; Text[250])
        {
            CalcFormula = Lookup("Professional Bodies".ProfessionalBodyName WHERE(ProfessionalBodyID = FIELD(ProfessionalBodyID)));
            FieldClass = FlowField;
        }
        field(5; "Email Address"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ProfessionalLevelID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; ProfessionalLevelID, ProfessionalLevelName)
        {
        }
    }
}