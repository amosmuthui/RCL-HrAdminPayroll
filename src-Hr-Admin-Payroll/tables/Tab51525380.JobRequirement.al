table 51525380 "Job Requirement"
{
    fields
    {
        field(1; "Job Id"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";
        }
        field(2; "Qualification Type"; Option)
        {
            NotBlank = false;
            OptionCaption = ' ,Academic,Professional,Technical,Experience,Personal Attributes,Membership,Proffessional Bodies';
            OptionMembers = " ",Academic,Professional,Technical,Experience,"Personal Attributes",Membership,"Proffessional Bodies";
        }
        field(3; "Qualification Code"; Integer)
        {
            Editable = true;
            NotBlank = true;
            TableRelation = IF ("Qualification Type" = CONST(Academic)) "Academic Certificates".CertificateID WHERE(EducationLevelID = FIELD(Level))
            ELSE
            IF ("Qualification Type" = CONST(Professional)) "Academic Certificates".CertificateID WHERE(EducationLevelID = CONST(7))
            ELSE
            IF ("Qualification Type" = CONST(Membership)) "Membership Categories".MembershipCategoryID WHERE(MembershipBodyID = field(Level));

            trigger OnValidate()
            begin

                if "Qualification Type" = "Qualification Type"::Academic then begin
                    Certific.Reset;
                    Certific.SetRange(EducationLevelID, Level);
                    Certific.SetFilter(CertificateID, Format("Qualification Code"));
                    if Certific.Find('-') then
                        Qualification := Certific.CertificateName;
                end;
                if "Qualification Type" = "Qualification Type"::Membership then begin
                    Membersh.Reset;
                    Membersh.SetRange(MembershipBodyID, Level);
                    Membersh.SetRange(MembershipCategoryID, "Qualification Code");
                    if Membersh.Find('-') then
                        Qualification := Membersh.MembershipCategoryName;
                end;
                if "Qualification Type" = "Qualification Type"::Professional then begin
                    Certific.Reset;
                    Certific.SetRange(EducationLevelID, Level);
                    Certific.SetFilter(CertificateID, Format("Qualification Code"));
                    if Certific.Find('-') then
                        Qualification := Certific.CertificateName;
                end;
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
        field(50005; Level; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Qualification Type" = CONST(Academic)) "Academic Education Level".EducationLevelID
            ELSE
            IF ("Qualification Type" = CONST(Professional)) "Academic Education Level".EducationLevelID WHERE(EducationLevelID = CONST(7))
            ELSE
            IF ("Qualification Type" = CONST(Membership)) "Membership Bodies".MembershipBodyID
            ELSE
            IF ("Qualification Type" = CONST("Proffessional Bodies")) "Professional Bodies".ProfessionalBodyID;

            trigger OnValidate()
            begin

                if ("Qualification Type" = "Qualification Type"::Academic) or ("Qualification Type" = "Qualification Type"::Professional) then begin
                    AcademicLevel.Reset;
                    AcademicLevel.SetRange(EducationLevelID, Level);
                    if AcademicLevel.Find('-') then
                        Description := AcademicLevel.Description;
                end;
                if "Qualification Type" = "Qualification Type"::Membership then begin
                    Membersh.Reset;
                    Membersh.SetRange(MembershipBodyID, Level);
                    if Membersh.Find('-') then
                        Description := Membersh."Membership Body Name";
                end;
                if "Qualification Type" = "Qualification Type"::"Proffessional Bodies" then begin
                    ProfBody.Reset;
                    ProfBody.SetRange(ProfessionalBodyID, Level);
                    if ProfBody.Find('-') then
                        Description := ProfBody.ProfessionalBodyName;
                end;
            end;
        }
        field(50006; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job Id", Level, "Qualification Code", "Qualification Type")
        {
            Clustered = true;
            SumIndexFields = "Score ID";
        }
        /*key(Key2;'')
        {
            Enabled = false;
        }*/
    }

    fieldgroups
    {
    }

    var
        QualificationSetUp: Record Qualification;
        Employee: Record Employee;
        Certific: Record "Academic Certificates";
        Profess: Record "Professional Levels";
        Membersh: Record "Membership Categories";
        AcademicLevel: Record "Academic Education Level";
        ProfBody: Record "Professional Bodies";
}