table 51525537 "Job Academic  Requirement"
{
    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; "Code"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Education Level";

            trigger OnValidate()
            var
                LevelID: Integer;
            begin
                AcademicEducationLevel.Reset;
                AcademicEducationLevel.SetRange(EducationLevelID, Code);
                if AcademicEducationLevel.FindFirst then begin
                    Description := AcademicEducationLevel.Description;
                end;
            end;
        }
        field(4; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Mandatory; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AcademicEducationLevel: Record "Academic Education Level";
}