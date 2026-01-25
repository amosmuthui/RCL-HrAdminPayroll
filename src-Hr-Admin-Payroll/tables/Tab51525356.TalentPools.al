table 51525356 "Talent Pools"
{
    Caption = 'Talent Pools';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Talent Pools";
    LookupPageId = "Talent Pools";

    fields
    {
        field(1; "Code"; Code[250])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(3; "No. of Candidates"; Integer)
        {
            Caption = 'No. of Candidates';
            FieldClass = FlowField;
            CalcFormula = count("Candidate Talent Pools" where("Pool Code" = field(Code)));
        }
        field(4; "No. of Applications"; Integer)
        {
            Caption = 'No. of Applications';
            FieldClass = FlowField;
            CalcFormula = count("Candidate Talent Pools" where("Pool Code" = field(Code), "Application No." = filter(<> '')));
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}