table 51525547 "Refreshment Requests"
{
    Caption = 'Refreshment Requests';
    DataClassification = ToBeClassified;
    LookupPageId = "Refreshment Requests";
    DrillDownPageId = "Refreshment Requests";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Requested By Emp No."; Code[20])
        {
            Caption = 'Requested By Emp. No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Requested By Emp Name" := '';
                if "Requested By Emp No." <> '' then begin
                    if Emp.Get("Requested By Emp No.") then begin
                        "Requested By Emp Name" := Emp.FullName();
                    end;
                end;
            end;
        }
        field(3; "Requested By Emp Name"; Text[250])
        {
            Editable = false;
            Caption = 'Requested By Emp Name';
        }
        field(4; Purpose; Text[250])
        {
            Caption = 'Purpose';
        }
        field(5; "Date Required"; Date)
        {
            Caption = 'Date Required';
        }
        field(6; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;
        }
        field(7; "No. of Refreshments"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Refreshment Details" where("Request No." = field("No.")));
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
            if HumanResSetup."Hotel Request Nos" = '' then begin
                HumanResSetup."Hotel Request Nos" := 'REFREQ';
                if BaseFactory.CreateNoSeries('', HumanResSetup."Hotel Request Nos", 'Refreshment request numbers', 'REFREQ00001') then
                    HumanResSetup.Modify();
            end;
            HumanResSetup.TestField("Hotel Request Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Hotel Request Nos");
        end;
    end;

    var
        Emp: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        BaseFactory: Codeunit Factory;
}
