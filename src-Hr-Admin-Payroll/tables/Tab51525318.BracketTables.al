table 51525318 "Bracket Tables"
{
    DrillDownPageID = "Bracket Tables";
    LookupPageID = "Bracket Tables";

    fields
    {
        field(1; "Bracket Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; "Bracket Description"; Text[80])
        {
        }
        field(3; "Effective Starting Date"; Date)
        {
        }
        field(4; "Effective End Date"; Date)
        {
        }
        field(5; Annual; Boolean)
        {
        }
        field(6; Type; Option)
        {
            OptionCaption = 'Fixed,Graduating Scale';
            OptionMembers = "Fixed","Graduating Scale";
        }
        field(7; NHIF; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(46; kimoo; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(47; NSSF; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(48; Country; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(PK; "Bracket Code"/*, Country*/)//Let us use country-unique codes eg RWPAYE for Rwanda PAYE
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //FRED 20/02/23 Prevent selection of both
        if NHIF and NSSF then
            Error('A deduction can either be NHIF or NSSF or none! You have selected both NHIF and NSSF!');
    end;

    trigger OnModify()
    begin
        //FRED 20/02/23 Prevent selection of both
        if NHIF and NSSF then
            Error('A deduction can either be NHIF or NSSF or none! You have selected both NHIF and NSSF!');
    end;
}