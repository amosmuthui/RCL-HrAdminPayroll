table 51525543 "Airtime Requests"
{
    Caption = 'Airtime Requests';
    DataClassification = ToBeClassified;
    LookupPageId = "Airtime Requests";
    DrillDownPageId = "Airtime Requests";

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
                        "Position Code" := Emp.Position;
                        "Position Title" := Emp."PTH Job Title";
                        if "Position Title" = '' then
                            "Position Title" := Emp."Job Title";
                        "Dept Code" := Emp."Responsibility Center";
                        "Dept Name" := Emp."Responsibility Center Name";
                        Validate("Job Category", Emp."Job Category");
                    end;
                end;
            end;
        }
        field(3; "Emp Name"; Text[250])
        {
            Caption = 'Emp Name';
            Editable = false;
        }
        field(4; "Position Code"; Code[20])
        {
            Caption = 'Position Code';
            Editable = false;
        }
        field(5; "Position Title"; Text[250])
        {
            Caption = 'Position Title';
            Editable = false;
        }
        field(6; "Dept Code"; Code[20])
        {
            Caption = 'Dept Code';
            Editable = false;
        }
        field(7; "Dept Name"; Text[250])
        {
            Caption = 'Dept Name';
            Editable = false;
        }
        field(8; "Job Category"; Code[20])
        {
            Caption = 'Job Category';
            Editable = false;
            TableRelation = "Job Categories";

            trigger OnValidate()
            begin
                if ("Job Category" = '') then
                    if GuiAllowed then
                        Error('Staff %1 - %2 has no defined Job category. Kindly review before proceeding.', "Emp No.", "Emp Name")
                    else
                        exit;

                if JobCategories.Get("Job Category") then begin
                    if JobCategories."Applicable Airtime Amount" = 0 then
                        if GuiAllowed then
                            Error('The applicable airtime amount for job category %1 - %2 is 0. You cannot proceed.', JobCategories.Code, JobCategories.Description)
                        else
                            exit;

                    "Applicable Amount" := JobCategories."Applicable Airtime Amount";
                end;
            end;
        }
        field(9; "Applicable Amount"; Decimal)
        {
            Caption = 'Applicable Amount';
            Editable = false;
        }
        field(10; "Applied Amount"; Decimal)
        {
            Caption = 'Applied Amount';

            trigger OnValidate()
            begin
                "Approved Amount" := "Applied Amount";
            end;
        }
        field(11; "Approved Amount"; Decimal)
        {
            Caption = 'Approved Amount';
        }
        field(12; Processed; Boolean)
        {
            Editable = false;
        }
        field(13; "Approval Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        BaseFactory: Codeunit Factory;
        Emp: Record Employee;
        JobCategories: Record "Job Categories";

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            if HumanResSetup."Airtime Request Nos" = '' then begin
                HumanResSetup."Airtime Request Nos" := 'AIRTREQ';
                if BaseFactory.CreateNoSeries('', HumanResSetup."Airtime Request Nos", 'Airtime request numbers', 'AIRTREQ00001') then
                    HumanResSetup.Modify();
            end;
            HumanResSetup.TestField("Airtime Request Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Airtime Request Nos");
        end;
    end;

    trigger OnDelete()
    begin
        if ("Approval Status" <> "Approval Status") or (Processed) then
            Error('You cannot delete at this stage!');
    end;
}
