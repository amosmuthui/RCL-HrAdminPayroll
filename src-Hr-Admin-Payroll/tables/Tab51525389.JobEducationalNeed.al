table 51525389 "Job Educational Need"
{
    fields
    {
        field(1; "Job ID"; Code[20])
        {
        }
        field(2; "Education Level"; Integer)
        {
            TableRelation = "Academic Education Level";

            trigger OnValidate()
            begin
                AcademicEducationLevelRec.Reset;
                AcademicEducationLevelRec.SetRange(EducationLevelID, "Education Level");
                if AcademicEducationLevelRec.FindFirst then
                    "Education Level Name" := AcademicEducationLevelRec.Description;
            end;
        }
        field(3; "Education Level Name"; Text[250])
        {
            FieldClass = Normal;
        }
        field(25; Grade; Text[250])
        {
            FieldClass = Normal;
        }
        field(26; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job ID", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AcademicEducationLevelRec: Record "Academic Education Level";
}