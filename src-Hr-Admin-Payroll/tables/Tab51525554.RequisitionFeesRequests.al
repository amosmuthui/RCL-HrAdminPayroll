table 51525554 "Requisition Fees Requests"
{
    Caption = 'Requisition Fees Requests';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Requisition Fees Requests";
    LookupPageId = "Requisition Fees Requests";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Emp No."; Code[20])
        {
            Caption = 'Emp No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Emp Name" := '';
                if "Emp No." <> '' then begin
                    if Emp.Get("Emp No.") then begin
                        "Emp Name" := Emp.FullName();
                    end;
                end;
            end;
        }
        field(3; "Emp Name"; Text[250])
        {
            Editable = false;
            Caption = 'Emp Name';
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
            MinValue = 1;
        }
        field(5; Purpose; Text[250])
        {
            Caption = 'Purpose';
        }
        field(6; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;
        }
        field(7; "PV No."; Code[20])
        {
            Editable = false;
            Caption = 'PV No.';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            if HumanResSetup."Requisition Fees Nos" = '' then begin
                HumanResSetup."Requisition Fees Nos" := 'VSAREQ';
                if BaseFactory.CreateNoSeries('', HumanResSetup."Requisition Fees Nos", 'Visa Requisition request numbers', 'VSAREQ00001') then
                    HumanResSetup.Modify();
            end;
            HumanResSetup.TestField("Requisition Fees Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Requisition Fees Nos");
        end;
    end;

    var
        Emp: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        BaseFactory: Codeunit Factory;
}
