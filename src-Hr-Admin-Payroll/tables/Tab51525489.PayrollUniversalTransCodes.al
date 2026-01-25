table 51525489 "Payroll Universal Trans Codes"
{
    Caption = 'Payroll Universal Trans Codes';
    DataClassification = ToBeClassified;
    LookupPageId = "Payroll Universal Trans Codes";
    DrillDownPageId = "Payroll Universal Trans Codes";

    fields
    {
        field(1; Title; Code[100])
        {
            Caption = 'Title';
        }
        field(2; Description; Text[240])
        {
            Caption = 'Description';
        }
        field(3; "Transaction Type"; Option)
        {
            OptionMembers = Earning,Deduction;
        }
        field(4; "Display Order"; Integer)
        { }
    }
    keys
    {
        key(PK; Title, "Transaction Type")
        {
            Clustered = true;
        }
        key(Key1; "Display Order")
        { }
    }
}