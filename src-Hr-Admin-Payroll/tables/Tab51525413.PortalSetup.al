table 51525413 "Portal Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "Server File Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Local File Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Company Data Directory"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Employee Data  Directory"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Jobs Data Directory"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Local Payslip Directory"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Server Payslip Directory"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Local P9 Directory"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Server P9 Directory"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Attachment File Path"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Applicant Online File Path"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Curriculum Vitae Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(14; "Cover Letter Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(15; "Chapter 6 Req Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(16; "NCPWD Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}