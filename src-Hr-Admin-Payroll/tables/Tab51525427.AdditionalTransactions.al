table 51525427 "Additional Transactions"
{
    Caption = 'Additional Transactions';
    DataClassification = ToBeClassified;
    LookupPageId = "Additional Transactions";
    DrillDownPageId = "Additional Transactions";

    fields
    {
        field(1; "WB No."; Code[100])
        {
            Caption = 'WB No.';
            Editable = false;
        }
        field(2; "Trans Code"; Code[100])
        {
            Caption = 'Trans Code';
            Editable = false;
        }
        field(3; "Trans Type"; Option)
        {
            Caption = 'Trans Type';
            OptionMembers = Earning,Deduction;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            TableRelation = "Additional Trans Description".Description where(Type = field("Trans Type"));

            trigger OnValidate()
            var
                TransDescriptions: Record "Additional Trans Description";
            begin
                TransDescriptions.Reset();
                TransDescriptions.SetRange(Type, "Trans Type");
                TransDescriptions.SetRange(Description, Description);
                if TransDescriptions.FindFirst() then
                    "Trans Code" := TransDescriptions."Trans Code";
            end;
        }
        field(5; "Amount Type"; Option)
        {
            Caption = 'Amount Type';
            OptionMembers = Gross,Net;
        }
        field(6; Currency; Code[100])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
        }
    }
    keys
    {
        key(PK; "WB No.", "Trans Code")
        {
            Clustered = true;
        }
    }
}