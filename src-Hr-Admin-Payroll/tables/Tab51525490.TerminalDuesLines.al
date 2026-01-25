table 51525490 "Terminal Dues Lines"
{
    Caption = 'Terminal Dues Lines';
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
        field(3; "Trans Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionMembers = Earning,Deduction,Employer;
            trigger OnValidate()
            begin
                validateAmount();
            end;
        }
        field(4; Description; Text[240])
        {
            Caption = 'Description';
        }
        field(5; Currency; Code[50])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            trigger OnValidate()
            begin
                validateAmount();
            end;
        }
        field(7; "System Entry"; Boolean)
        {
            Editable = false;
        }
        field(8; "Is Basic"; Boolean)
        {
            Editable = false;
        }
        field(9; "Is House"; Boolean)
        {
            Editable = false;
        }
        field(10; "Is Transport"; Boolean)
        {
            Editable = false;
        }
        field(11; "Amount (FCY)"; Decimal)
        {
            Caption = 'Amount';
            trigger OnValidate()
            begin
                Amount := "Amount (FCY)";
                validateAmount();
            end;
        }
        field(12; "Period Processed"; Date)
        {

        }
        field(13; "Payroll Currency"; Code[50])
        {
            TableRelation = Currency;
        }
        field(14; Taxable; Boolean)
        {

        }
    }
    keys
    {
        key(PK; "Header No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure validateAmount()
    begin
        if "Trans Type" = "Trans Type"::Earning then begin
            Amount := Abs(Amount);
            "Amount (FCY)" := Abs("Amount (FCY)");
            Taxable := true;
        end else begin
            Amount := -Abs(Amount);
            "Amount (FCY)" := -Abs("Amount (FCY)");
        end;
    end;
}