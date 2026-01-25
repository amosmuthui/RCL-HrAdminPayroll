table 51525382 "Academic Education Level"
{
    DrillDownPageID = "Education Levels";
    LookupPageID = "Education Levels";

    fields
    {
        field(1; EducationLevelID; Integer)
        {
            Caption = 'Level ID';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Rank; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; EducationLevelID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; EducationLevelID, Description)
        {
        }
    }
}