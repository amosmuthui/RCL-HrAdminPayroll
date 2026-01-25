table 51525506 "Terminal Dues Salary Structure"
{
    Caption = 'Terminal Dues Salary Structure';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Header No."; Code[100])
        {
            Caption = 'Header No.';
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(3; Description; Text[240])
        {
            Caption = 'Description';
        }
        field(4; Currency; Code[100])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Is Basic"; Boolean)
        {
            Editable = false;
        }
        field(7; "Is House"; Boolean)
        {
            Editable = false;
        }
        field(8; "Is Transport"; Boolean)
        {
            Editable = false;
        }
        field(9; "System Entry"; Boolean)
        {
            Editable = false;
        }
        field(10; "Amount (FCY)"; Decimal)
        {
            Caption = 'Amount';
            trigger OnValidate()
            begin
                Amount := "Amount (FCY)";
            end;
        }

        field(11; "Period Processed"; Date)
        {

        }
        field(12; "Payroll Currency"; Code[50])
        {
            TableRelation = Currency;
        }
    }
    keys
    {
        key(PK; "Header No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key1; "System Entry")
        { }
    }
}