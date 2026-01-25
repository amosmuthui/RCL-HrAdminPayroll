table 51525461 "Loan Product Type"
{
    DrillDownPageID = "Loan Product Type list";
    LookupPageID = "Loan Product Type list";

    fields
    {
        field(1; "Code"; Code[50])
        {

            trigger OnValidate()
            begin
                if Code <> xRec.Code then begin
                    SalesSetup.Get;
                    // NoSeriesMgt.TestManual(HRsetup."Loan Product Type Nos.");
                    "No Series" := '';
                end;
            end;
        }
        field(2; Description; Text[80])
        {
        }
        field(3; "Interest Rate"; Decimal)
        {
            DecimalPlaces = 2 : 10;
        }
        field(4; "Interest Calculation Method"; Option)
        {
            OptionCaption = '  ,Flat Rate,Reducing Balance,Amortized,Sacco Reducing Balance';
            OptionMembers = "  ","Flat Rate","Reducing Balance",Amortized,"Sacco Reducing Balance";
        }
        field(5; "No Series"; Code[10])
        {
        }
        field(6; "No of Instalment"; Integer)
        {
        }
        field(7; "Loan No Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(8; Rounding; Option)
        {
            OptionCaption = 'Nearest,Down,Up';
            OptionMembers = Nearest,Down,Up;
        }
        field(28; "Rounding Precision"; Decimal)
        {
            InitValue = 1;
            MaxValue = 1;
            MinValue = 0.01;
        }
        field(29; "Loan Category"; Option)
        {
            OptionMembers = " ",Advance,"Bisco Loan","Other Loan";
        }
        field(30; "Calculate Interest"; Boolean)
        {
        }
        field(31; "Interest Deduction Code"; Code[10])
        {
            TableRelation = Deductions;
        }
        field(32; "Deduction Code"; Code[50])
        {
            TableRelation = Deductions;
        }
        field(33; Internal; Boolean)
        {
        }
        field(34; "Fringe Benefit Code"; Code[30])
        {
            TableRelation = Earnings;
        }
        field(35; "Calculate On"; Option)
        {
            OptionCaption = ' ,Opening Balance,Closing Balance';
            OptionMembers = " ","Opening Balance","Closing Balance";
        }
        field(36; "Principal Deduction Code"; Code[10])
        {
            TableRelation = Deductions;
        }
        field(37; Mortgage; Code[30])
        {
            TableRelation = Earnings;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Loan Category")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if Code = '' then begin
            HRsetup.Get;
            // HRsetup.TESTFIELD(HRsetup."Loan Product Type Nos.");
            //NoSeriesMgt.InitSeries(HRsetup."Loan Product Type Nos.",xRec."No Series",0D,Code,"No Series");
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        HRsetup: Record "Human Resources Setup";
}