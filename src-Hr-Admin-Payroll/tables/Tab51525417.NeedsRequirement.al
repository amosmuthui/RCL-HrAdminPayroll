table 51525417 "Needs Requirement"
{
    DrillDownPageID = "Needs Requirements";
    LookupPageID = "Needs Requirements";

    fields
    {
        field(1; "Need Id"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Recruitment Needs"."No.";
        }
        field(2; "Qualification Type"; Option)
        {
            NotBlank = false;
            OptionMembers = " ",Academic,Professional,Technical,Experience,"Personal Attributes";
        }
        field(3; "Qualification Code"; Code[30])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = Qualification.Code;

            trigger OnValidate()
            begin
                QualificationSetUp.Reset;
                QualificationSetUp.SetRange(QualificationSetUp.Code, "Qualification Code");
                if QualificationSetUp.Find('-') then
                    Qualification := QualificationSetUp.Description;
            end;
        }
        field(4; Qualification; Text[250])
        {
            NotBlank = false;
        }
        field(5; "Job Requirements"; Text[250])
        {
            NotBlank = true;
        }
        field(6; Priority; Option)
        {
            OptionMembers = " ",High,Medium,Low;
        }
        field(7; "Job Specification"; Option)
        {
            OptionMembers = " ",Academic,Professional,Technical,Experience;
        }
        field(8; "Score ID"; Decimal)
        {
        }
        field(9; "Job Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";
        }
        field(14; "Grade Id"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Grades".GradeID WHERE(CertificateID = FIELD("Course Id"));

            trigger OnValidate()
            begin
                if AccGrades.Get("Grade Id") then
                    "Grade Name" := AccGrades.GradeName;
                //MODIFY;
            end;
        }
        field(15; "Grade Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Course Id"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Certificates".CertificateID WHERE(EducationLevelID = FIELD("Education Level Id"));

            trigger OnValidate()
            begin
                if AccCerts.Get("Course Id") then
                    "Course Name" := AccCerts.CertificateName;
                //MODIFY;
            end;
        }
        field(17; "Course Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Education Level Id"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Education Level".EducationLevelID;

            trigger OnValidate()
            begin
                AccLevels.Reset;
                AccLevels.SetRange(AccLevels.EducationLevelID, "Education Level Id");
                if AccLevels.FindFirst then begin
                    "Education Level Name" := AccLevels.Description;
                end;
            end;
        }
        field(19; "Education Level Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(21; Mandatory; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Need Id", "Job Id", "Grade Id", "Course Id", "Education Level Id", "Qualification Type", "Qualification Code")
        {
            Clustered = true;
            SumIndexFields = "Score ID";
        }
    }

    fieldgroups
    {
    }

    var
        QualificationSetUp: Record Qualification;
        AccLevels: Record "Academic Education Level";
        AccCerts: Record "Academic Certificates";
        AccGrades: Record "Academic Grades";
}