table 51525409 "Applicant Referees"
{
    fields
    {
        field(1; No; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Names; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Designation; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Company; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Postal Address"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Mobile No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Applicant Email"; Text[100])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
        }
        field(8; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(9; Notes; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Referee Email"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "First Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Middle Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Last Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Residential Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Referee Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Social,Professional';
            OptionMembers = ,Social,Professional;
        }
    }

    keys
    {
        key(Key1; No, "Line No", Names)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}