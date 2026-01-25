table 51525395 "Applicants Qualification"
{
    Caption = 'Applicants Qualification';
    DataCaptionFields = "Applicant No.";
    DrillDownPageID = "HR Employee List";
    LookupPageID = "HR Employee List";

    fields
    {
        field(1; "Applicant No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Applicants."Applicant No.";
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(3; "Qualification Code"; Code[20])
        {
            Caption = 'Qualification Code';
            NotBlank = true;
            TableRelation = Qualification.Code;

            trigger OnValidate()
            begin
                Qualifications.Reset;
                Qualifications.SetRange(Qualifications.Code, "Qualification Code");
                if Qualifications.Find('-') then
                    Qualification := Qualifications.Description;
            end;
        }
        field(4; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(5; "To Date"; Date)
        {
            Caption = 'To Date';
        }
        field(6; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Internal,External,Previous Position';
            OptionMembers = " ",Internal,External,"Previous Position";
        }
        field(7; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(8; "Institution/Company"; Text[200])
        {
            Caption = 'Institution/Company';
        }
        field(9; Cost; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost';
        }
        field(10; "Course Grade"; Text[200])
        {
            Caption = 'Course Grade';
        }
        field(11; "Employee Status"; Option)
        {
            Caption = 'Employee Status';
            Editable = false;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(12; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST("Employee Qualification"),
                                                                     "No." = FIELD("Applicant No."),
                                                                     "Table Line No." = FIELD("Line No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(50000; "Qualification Type"; Option)
        {
            NotBlank = false;
            OptionCaption = ' ,Academic,Professional,Technical ,Experience,Personal Attributes,Professional Membership';
            OptionMembers = " ",Academic,Professional,"Technical ",Experience,"Personal Attributes","Professional Membership";
        }
        field(50001; Qualification; Text[200])
        {
            NotBlank = true;
        }
        field(50003; "Score ID"; Decimal)
        {
            //TableRelation = "Score Setup"."Score ID";
        }
        field(50004; AcademicEducationLevelID; Integer)
        {
            NotBlank = true;
            TableRelation = "Academic Education Level".EducationLevelID;

            trigger OnValidate()
            begin
                AREC1.Reset;
                AREC1.Get(AcademicEducationLevelID);
                "Academic Level Name" := AREC1.Description;
            end;
        }
        field(50005; AcademicCertificateID; Integer)
        {
            TableRelation = "Academic Certificates".CertificateID;
        }
        field(50006; AcademicGradeID; Integer)
        {
            TableRelation = "Academic Grades".GradeID;
        }
        field(50007; "Academic Level Name"; Text[100])
        {
            CalcFormula = Lookup("Academic Education Level".Description WHERE(EducationLevelID = FIELD(AcademicEducationLevelID)));
            FieldClass = FlowField;
        }
        field(50008; "Academic Certificate Name"; Text[100])
        {
            CalcFormula = Lookup("Academic Certificates".CertificateName WHERE(EducationLevelID = FIELD(AcademicEducationLevelID),
                                                                                CertificateID = FIELD(AcademicCertificateID)));
            FieldClass = FlowField;
        }
        field(50009; "Grade Name"; Text[100])
        {
            CalcFormula = Lookup("Academic Grades".GradeName WHERE(GradeID = FIELD(AcademicGradeID)));
            FieldClass = FlowField;
        }
        field(50010; ProfessionalBodyID; Integer)
        {
        }
        field(50011; ProfessionalLevelID; Integer)
        {
        }
        field(50012; ProfessionalCertificateID; Integer)
        {
        }
        field(50013; MembershipBodyID; Integer)
        {
        }
        field(50014; MembershipCategoryID; Integer)
        {
        }
        field(50015; MembershipCertificateID; Integer)
        {
        }
        field(50016; MembershipRegistrationNumber; Text[250])
        {
        }
        field(50017; CurrentEmployment; Integer)
        {
        }
        field(50018; CurrentSalary; Integer)
        {
        }
        field(50019; ExpectedSalary; Integer)
        {
        }
        field(50020; "Professional Body Name"; Text[250])
        {
            CalcFormula = Lookup("Professional Bodies".ProfessionalBodyName WHERE(ProfessionalBodyID = FIELD(ProfessionalBodyID)));
            FieldClass = FlowField;
        }
        field(50021; "Professional Level Name"; Text[250])
        {
            CalcFormula = Lookup("Professional Levels".ProfessionalLevelName WHERE(ProfessionalLevelID = FIELD(ProfessionalLevelID),
                                                                                    ProfessionalBodyID = FIELD(ProfessionalBodyID)));
            FieldClass = FlowField;
        }
        field(50022; "Membership Body Name"; Text[250])
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Applicant No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Score ID";
        }
        key(Key2; "Qualification Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Qualifications: Record Qualification;
        Applicant: Record Applicants;
        Position: Code[20];
        AREC1: Record "Academic Education Level";
}