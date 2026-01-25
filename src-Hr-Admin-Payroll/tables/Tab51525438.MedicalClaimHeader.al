table 51525438 "Medical Claim Header"
{
    //DrillDownPageID = Attachments;
    //LookupPageID = Attachments;

    fields
    {
        field(1; "Claim No"; Code[20])
        {
        }
        field(2; "Claim Date"; Date)
        {
        }
        field(3; "Service Provider"; Code[20])
        {
            TableRelation = Vendor /*WHERE ("Vendor Type" = FILTER (Medical))*/;

            trigger OnValidate()
            begin
                if VendorRec.Get("Service Provider") then
                    "Service Provider Name" := VendorRec.Name;
            end;
        }
        field(4; "Service Provider Name"; Text[100])
        {
        }
        field(5; "No. Series"; Code[10])
        {
        }
        field(6; Claimant; Option)
        {
            OptionMembers = " ","Service Provider",Employee;
        }
        field(7; Amount; Decimal)
        {
            CalcFormula = Sum("Claim Line".Amount WHERE("Claim No" = FIELD("Claim No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; Settled; Boolean)
        {
        }
        field(9; "Cheque No"; Code[20])
        {
        }
        field(10; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;

        }
        field(11; "Transferred to Journal"; Boolean)
        {
        }
        field(12; "No. of Approvals"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(51525183),
                                                        "Document No." = FIELD("Claim No")));
            FieldClass = FlowField;
        }
        field(13; "Fiscal Year"; Code[50])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(14; "Claimant No."; Code[100])
        {
            Editable = false;
        }
        field(15; "Claimant Name"; Text[1000])
        {
            Editable = false;
        }
        field(16; Department; Code[300])
        {
            Editable = false;
        }
        field(17; Posted; Boolean)
        {

        }

    }

    keys
    {
        key(Key1; "Claim No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        empl: Record Employee;
    begin
        if "Claim No" = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Medical Claim Nos");
            "Claim No" := NoSeriesMgt.GetNextNo((HumanResSetup."Medical Claim Nos"));
        end;

        "Claim Date" := Today;
        //ERROR("Claim No");

        GLSetup.Reset;
        GLSetup.Get;
        "Fiscal Year" := GLSetup."Current Budget";

        empl.Reset();
        empl.SetRange("User ID", UserId);
        if (empl.FindFirst) then begin
            "Claim No" := empl."No.";
            "Department" := empl."Responsibility Center";
        end;

    end;

    var
        VendorRec: Record Vendor;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        GLSetup: Record "General Ledger Setup";
}