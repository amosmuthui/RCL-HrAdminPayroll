table 51525398 "Academic Grades"
{
    DrillDownPageID = "Academic Grades List";
    LookupPageID = "Academic Grades List";

    fields
    {
        field(1; GradeID; Integer)
        {
        }
        field(2; GradeName; Text[30])
        {
        }
        field(3; CertificateID; Integer)
        {
            TableRelation = "Academic Certificates".CertificateID;
        }
        field(4; EducationLevelID; Integer)
        {
            TableRelation = "Academic Education Level".EducationLevelID;
        }
        field(5; "Certificate Name"; Text[250])
        {
            CalcFormula = Lookup("Academic Certificates".CertificateName WHERE(CertificateID = FIELD(CertificateID)));
            FieldClass = FlowField;
        }
        field(6; "Education Level Name"; Text[250])
        {
            CalcFormula = Lookup("Academic Education Level".Description WHERE(EducationLevelID = FIELD(EducationLevelID)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; GradeID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; GradeID, GradeName)
        {
        }
    }
}