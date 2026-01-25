table 51525471 "Staff Movement Temp"
{
    Caption = 'Staff Movement Temp';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Emp No."; Code[50])
        {
            Caption = 'Emp No.';
            TableRelation = Employee."No.";
        }
        field(3; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Change Type"; Code[200])
        {
        }
        field(5; "First Date"; Date)
        {
            Caption = 'First Date';
            trigger OnValidate()
            begin
                if (("First Date" <> 0D) and ("Last Date" <> 0D) and ("First Date" > "Last Date")) then
                    Error('The first date cannot be greater than the last date!');
            end;
        }
        field(6; "Last Date"; Date)
        {
            Caption = 'Last Date';
            trigger OnValidate()
            begin
                if (("First Date" <> 0D) and ("Last Date" <> 0D) and ("First Date" > "Last Date")) then
                    Error('The last date cannot be earlier than the first date!');
            end;
        }
        field(7; "Workstation Country"; Code[100])
        {
            Caption = 'Workstation Country';
            TableRelation = "Country/Region";
            trigger OnValidate()
            var
            //SelectedCountry: Record "Country/Region";
            begin
                if ("Payroll Country" <> '') then begin
                    "Payroll Country" := "Workstation Country";
                    Validate("Payroll Country");
                end;
            end;
        }
        field(8; "Station Code"; Code[50])
        {
            Caption = 'Station Name';
            trigger OnValidate()
            var
                stations: record Stations;
            begin

                if ("Station Code" <> '') then begin
                    stations.Reset();
                    stations.SetRange(Name, "Station Code");
                    if stations.FindFirst() then
                        "Station Title" := stations.Description
                end;
            end;
        }
        field(9; "Station Title"; Text[250])
        {
            Caption = 'Station Description';
            Editable = false;
        }
        field(10; "Dept Code"; Code[100])
        {
            Caption = 'Dept Code';
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            var
                Dept: Record "Responsibility Center";
            begin
                Dept.Reset();
                Dept.SetRange(Code, "Dept Code");
                if Dept.FindFirst() then
                    "Department Name" := Dept.Name;
            end;
        }
        field(11; "Department Name"; Text[250])
        {
            Caption = 'Department Name';
            Editable = false;
        }
        field(12; "Section Code"; Code[100])
        {
            Caption = 'Section Code';
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD("Dept Code"));

            trigger OnValidate()
            var
                Sects: Record "Sub Responsibility Center";
            begin
                Sects.Reset();
                Sects.SetRange(Code, "Dept Code");
                if Sects.FindFirst() then
                    "Section Title" := Sects.Description;
            end;
        }
        field(13; "Section Title"; Text[250])
        {
            Caption = 'Section Title';
            Editable = false;
        }
        field(14; "Position Code"; Code[100])
        {
            Caption = 'Position Code';
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            var
                Jobs: Record "Company Jobs";
            begin
                if "Position Code" <> '' then begin
                    Jobs.Reset();
                    Jobs.SetRange("Job ID", "Position Code");
                    if Jobs.FindFirst() then
                        "Job Title" := Jobs."Job Description";
                end;
            end;
        }
        field(15; "Job Title"; Text[250])
        {
            Caption = 'Job Title';
            Editable = false;
        }
        field(16; "Contractual Amount Type"; Option)
        {
            Caption = 'Contractual Amt Type';
            OptionCaption = 'Gross Pay,Basic Pay,Net Pay';
            OptionMembers = "Gross Pay","Basic Pay","Net Pay";
        }
        field(17; "Contractual Amount Currency"; Code[50])
        {
            Caption = 'Contractual Amt Currency';
            TableRelation = "Currency";
        }
        field(18; "Contractual Amount Value"; Decimal)
        {
            Caption = 'Contractual Amount';
        }
        field(19; "Payroll Currency"; Code[50])
        {
            Caption = 'Payroll Currency';
            TableRelation = "Currency";
        }
        field(20; Remarks; Text[250])
        {
            Caption = 'Remarks';
        }
        field(21; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending,Past,Current;

            trigger OnValidate()
            begin
                //If added after 15th, do not change their status
            end;
        }
        field(22; "Payroll Country"; Code[50])
        {
            //Caption = 'Country';
            TableRelation = "Country/Region";
            trigger OnValidate()
            var
                SelectedCountry: Record "Country/Region";
            begin
                SelectedCountry.reset;
                SelectedCountry.setrange("Code", "Payroll Country");
                if SelectedCountry.findfirst then begin
                    "Payroll Currency" := SelectedCountry."Country Currency";
                end;
            end;
        }
        field(23; "No Transport Allowance"; Boolean)
        {
            trigger OnValidate()
            begin
                "Applicable House Allowance (%)" := 0;
                if "No Transport Allowance" then
                    "Applicable House Allowance (%)" := 22;
            end;

        }
        field(24; "Applicable House Allowance (%)"; Decimal)
        {

        }

        field(25; "Apply Paye Multiplier"; Boolean)
        {

        }
        field(26; "Paye Multiplier"; Decimal)
        {

        }

    }
    keys
    {
        key(PK; "Emp No.", "Change Type")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        HrSetup: Record "Human Resources Setup";
        lastDay: Integer;
    begin
    end;

    trigger OnModify()
    begin
    end;

    var
        IntEmpHist: Record "Internal Employement History";

}