table 51525405 "Applicant Online Qualification"
{
    fields
    {
        field(1; "Email Address"; Text[100])
        {
            Caption = 'Email Address';
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
            DataClassification = ToBeClassified;
        }
        field(12; "Grade Id"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Grades".GradeID;

            trigger OnValidate()
            begin
                if AccGrades.Get("Grade Id") then
                    "Grade Name" := AccGrades.GradeName;
                Rec.Modify;
            end;
        }
        field(13; "Grade Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Course Id"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Certificates".CertificateID WHERE(EducationLevelID = FIELD("Education Level Id"));

            trigger OnValidate()
            begin
                if AccCerts.Get("Course Id") then
                    "Course Name" := AccCerts.CertificateName;
                Rec.Modify;
            end;
        }
        field(15; "Course Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Education Level Id"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Education Level".EducationLevelID;

            trigger OnValidate()
            begin
                if AccLevels.Get("Education Level Id") then begin
                    "Education Level Name" := AccLevels.Description;
                    Rec.Modify;
                end;
            end;
        }
        field(17; "Education Level Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Attachement Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Attached; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "SharePoint Url"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Email Address", "Line No.")
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