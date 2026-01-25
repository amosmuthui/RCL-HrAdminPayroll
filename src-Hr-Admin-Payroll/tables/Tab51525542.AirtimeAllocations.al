table 51525542 "Airtime Allocations"
{
    Caption = 'Airtime Allocations';
    DataClassification = ToBeClassified;
    LookupPageId = "Airtime Allocations";
    DrillDownPageId = "Airtime Allocations";

    fields
    {
        field(1; Period; Date)
        {
            Caption = 'Period';
            TableRelation = "Airtime Allocation Batches";
            Editable = false;
        }
        field(2; "Emp No."; Code[20])
        {
            Caption = 'Emp No.';
            TableRelation = Employee where(Status = const(Active), "Ineligible for Airtime" = const(false), "Job Category" = filter(<> ''));

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
                        "Phone No." := Emp."Phone No.";
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
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(5; "Airtime Amount"; Decimal)
        {
            Caption = 'Airtime Amount';
            MinValue = 0;
        }
        field(6; "Position Code"; Code[20])
        {
            Caption = 'Position Code';
            TableRelation = "Company Jobs"."Job ID";
            Editable = false;
        }
        field(7; "Position Title"; Text[250])
        {
            Caption = 'Position Title';
            Editable = false;
        }
        field(8; "Dept Code"; Code[20])
        {
            Caption = 'Dept Code';
            TableRelation = "Responsibility Center";
            Editable = false;
        }
        field(9; "Dept Name"; Text[250])
        {
            Caption = 'Dept Name';
            Editable = false;
        }
        field(10; "Job Category"; Code[20])
        {
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

                    "Airtime Amount" := JobCategories."Applicable Airtime Amount";
                end;
            end;
        }
        field(11; "Sent to Vendor"; Boolean)
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; Period, "Emp No.")
        {
            Clustered = true;
        }
    }

    var
        Emp: Record Employee;
        AllocationPeriods: Record "Airtime Allocation Batches";
        Depts: Record "Responsibility Center";
        JobPositions: Record "Company Jobs";
        JobCategories: Record "Job Categories";
}
