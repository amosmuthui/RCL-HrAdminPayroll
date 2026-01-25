table 51525534 "Job Qualification Requirement"
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
            TableRelation = "Professional Levels";

            trigger OnValidate()
            var
                LevelID: Integer;
            begin
                ProfessionalLevels.Reset;
                ProfessionalLevels.SetRange(ProfessionalLevelID, Code);
                if ProfessionalLevels.FindFirst then begin
                    Description := ProfessionalLevels.ProfessionalLevelName;
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
        ProfessionalLevels: Record "Professional Levels";
}