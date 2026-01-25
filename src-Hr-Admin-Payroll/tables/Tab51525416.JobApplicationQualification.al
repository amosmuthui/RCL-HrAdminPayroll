table 51525416 "Job Application Qualification"
{
    fields
    {
        field(1; "Applicant No."; Code[20])
        {
            Caption = 'Applicant No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Qualification Code"; Code[20])
        {
            Caption = 'Qualification Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Qualification.Code;
        }
        field(4; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = ToBeClassified;
        }
        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = ToBeClassified;
        }
        field(6; Type; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Internal,External,Previous Position';
            OptionMembers = " ",Internal,External,"Previous Position";
        }
        field(7; Description; Text[200])
        {
            CalcFormula = Lookup(Qualification.Description WHERE(Code = FIELD("Qualification Code")));
            Caption = 'Description';
            FieldClass = FlowField;
        }
        field(8; "Institution/Company"; Text[200])
        {
            Caption = 'Institution/Company';
            DataClassification = ToBeClassified;
        }
        field(9; Cost; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost';
            DataClassification = ToBeClassified;
        }
        field(10; "Course Grade"; Text[200])
        {
            Caption = 'Course Grade';
            DataClassification = ToBeClassified;
        }
        field(11; "Score Id"; Decimal)
        {
            CalcFormula = Sum("Needs Requirement"."Score ID" WHERE("Education Level Id" = FIELD("Education Level Id"),
                                                                    "Need Id" = FIELD("Job Need Id"),
                                                                    "Course Id" = FIELD("Course Id")));
            FieldClass = FlowField;
        }
        field(12; "Job App ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Applications";
        }
        field(13; "Job Need Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Recruitment Needs"."No.";
        }
        field(14; "Grade Id"; Integer)
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Academic Level Scores".Code WHERE(Rec."Academic Level" = FIELD(Rec."Education Level Id"));

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
            TableRelation = "Academic Certificates".CertificateID WHERE("Academic Field" = FIELD("Field of Study"));

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
                if AccLevels.Get("Education Level Id") then begin
                    "Education Level Name" := AccLevels.Description;
                    //MODIFY;
                end;
            end;
        }
        field(19; "Education Level Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Field of Study"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Fields".Code WHERE(Category = FIELD("Education Level Id"));
        }
        field(21; "Academic Field"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Found; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "File Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job App ID", "Applicant No.", "Line No.", "Job Need Id", "Education Level Id", "Course Id")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AccLevels: Record "Academic Education Level";
        AccCerts: Record "Academic Certificates";
        AccGrades: Record "Academic Grades";
}