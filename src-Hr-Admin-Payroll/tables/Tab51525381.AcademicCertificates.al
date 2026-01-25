table 51525381 "Academic Certificates"
{
    DrillDownPageID = "Academic Certificates";
    LookupPageID = "Academic Certificates";

    fields
    {
        field(1; CertificateID; Integer)
        {
            AutoIncrement = true;
        }
        field(2; CertificateName; Text[250])
        {
        }
        field(3; EducationLevelID; Integer)
        {
            TableRelation = "Academic Education Level";
        }
        field(4; "Level Name"; Text[250])
        {
            CalcFormula = Lookup("Academic Education Level".Description WHERE(EducationLevelID = FIELD(EducationLevelID)));
            FieldClass = FlowField;
        }
        field(5; "Academic Field"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Fields".Code;
        }
    }

    keys
    {
        key(Key1; CertificateID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; CertificateID, CertificateName)
        {
        }
    }
}