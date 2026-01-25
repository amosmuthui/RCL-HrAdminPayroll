table 51525540 "Applicant Professional Body"
{
    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Application No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Qualification;
        }
        field(3; "Qualification Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Qualification;
        }
        field(4; "Qualification Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Professional Body";
        }
        field(5; "Professional Body"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Joining Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Completion Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Award Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Award Score"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Applicant Email Addres"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Attachment; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Attached; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Recruitment Need Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "SharePoint Url"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No", "Applicant Email Addres")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Needs: Record "Recruitment Needs";
}