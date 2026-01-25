table 51525320 Institution
{
    DrillDownPageID = Insitutions;
    LookupPageID = Insitutions;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Name; Text[30])
        {
        }
        field(3; Address; Text[30])
        {
        }
        field(4; City; Text[30])
        {
        }
        field(5; "Bank Account Number"; Code[100])
        {
            NotBlank = true;
        }
        field(6; "Bank Branch"; Code[100])
        {
            //TableRelation = "Staff  Bank Account"."Bank Branch No." WHERE(Code = FIELD("Institution's Bank"));
        }
        field(7; "Institution's Bank"; Code[100])
        {
            NotBlank = true;
            //TableRelation = "Staff  Bank Account";
        }
        field(8; "Paying Bank Code"; Code[10])
        {
            TableRelation = "Bank Account";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}