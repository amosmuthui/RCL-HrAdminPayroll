table 51525440 "Job Professional Need"
{
    DrillDownPageId = "Professional Bodies Needs";
    LookupPageId = "Professional Bodies Needs";

    fields
    {
        field(1; "Job ID"; Code[20])
        {
        }
        field(2; "Professional Body"; Integer)
        {
            TableRelation = "Professional Bodies".ProfessionalBodyID;

            trigger OnValidate()
            begin
                Prof.Reset;
                Prof.SetRange(Prof.ProfessionalBodyID, "Professional Body");
                if Prof.FindFirst then begin
                    "Body Name" := Prof.ProfessionalBodyName;
                end;
            end;
        }
        field(3; "Body Name"; Text[250])
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                //Lookup("Professional Bodies".ProfessionalBodyName WHERE (ProfessionalBodyID=FIELD(ProfessionalBodyID)))
            end;
        }
        field(4; "Professional Level"; Code[10])
        {

            trigger OnValidate()
            begin
                //"Professional Levels" WHERE (ProfessionalBodyID=FIELD(ProfessionalBodyID))
            end;
        }
        field(5; "Level Name"; Text[250])
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                //Lookup("Professional Levels".ProfessionalLevelName WHERE (ProfessionalLevelID=FIELD(ProfessionalLevelID)))
            end;
        }
        field(6; "Professional Qualification"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Qualification;

            trigger OnValidate()
            begin
                /*QualificationRec.Reset;
                QualificationSetRange(Code, "Professional Qualification");
                if QualificationRec.FindLast then*/
                //"Professional Body":=QualificationRec."Professional Body";
            end;
        }
        field(7; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Need ID"; Code[20])
        {
            CalcFormula = Lookup("Recruitment Needs"."No." WHERE("Job ID" = FIELD("Job ID")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Job ID", "Line No.", "Professional Body")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        QualificationRec: Record Qualification;
        Prof: Record "Professional Bodies";
}