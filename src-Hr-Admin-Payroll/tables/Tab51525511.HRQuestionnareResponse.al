table 51525511 "HR Questionnare Response"
{
    fields
    {
        field(1; numbers; Code[20])
        {
        }
        field(2; Applicant; Code[20])
        {
        }
        field(3; codes; Code[20])
        {
        }
        field(4; Answer; Text[200])
        {
        }
        field(5; answer2; Integer)
        {
        }
        field(6; "Marks Scored"; Decimal)
        {
        }
        field(7; Description; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; numbers, Applicant)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}