table 51525343 "Internal Employement History"
{
    Caption = 'Internal Employement History';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[50])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Emp No."; Code[50])
        {
            Caption = 'Emp No.';
            TableRelation = Employee."No.";

            /*trigger OnValidate()
            var
                empRec: Record Employee;
            begin
                if "Emp No." <> '' then begin
                    empRec.Reset();
                    empRec.SetRange("No.", "Emp No.");
                    if empRec.FindFirst() then begin
                        "Employee Name" := empRec."First Name" + ' ' + empRec."Middle Name" + ' ' + empRec."Last Name";
                        //if empRec.Position = '' then
                        //Error('You must specify the job position of the selected employee in the employee card!');
                        "Position Code" := empRec.Position;
                        "Job Title" := empRec."Job Title";
                        //Validate("Position Code");
                        "Dept Code" := empRec."Responsibility Center";
                        "Department Name" := empRec."Responsibility Center Name";
                        "Section Code" := empRec."Sub Responsibility Center";
                        Validate("Section Code");
                        "Station Code" := empRec.Station;
                        Validate("Station Code");
                        "Workstation Country" := empRec."Workstation Country";
                        "Payroll Country" := empRec."Payroll Country";
                        "Payroll Currency" := empRec."Payroll Currency";
                    end;
                end;
            end;*/
        }
        field(3; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Type"; Option)
        {
            Caption = 'Change Type';
            OptionMembers = "August 2023",Initial,Country,Station,"Department/Section",Promotion,Demotion,"Salary Adjustment","Temporary Contract","New Appointment","Additional Duties/Responsibility",Reintegration,"Temporary Contract Extension","Final Call Letter","End of additional duties/responsibility",Seniority,"Employment Contract Amendment","Reinstatement Letter",Other,"Salary Alignment",Trainee,Consultant,"Title Change and Responsibilities","Gross Adjustment due to New Pension Rate","Change due to Transformation";

            trigger OnValidate()
            begin
                if (Type = Type::"August 2023") or (Type = Type::Initial) then
                    Status := Status::Current;
            end;
        }
        field(5; "First Date"; Date)
        {
            Caption = 'First Date';
            trigger OnValidate()
            var
                empRec: Record Employee;
            begin
                "Last Date" := 0D;
                if (("First Date" <> 0D) and ("Last Date" <> 0D) and ("First Date" > "Last Date")) then
                    Error('The first date cannot be greater than the last date!');
                if ("First Date" <> 0D) and ("Last Date" = 0D) then begin
                    empRec.Reset();
                    empRec.SetRange("No.", "Emp No.");
                    //empRec.SetFilter("Contract Type", '%1|%2', 'PERMANENT', '');
                    if empRec.FindFirst() then begin
                        if empRec."Contract End Date" <> 0D then
                            "Last Date" := empRec."Contract End Date"
                        else if empRec."Retirement Date" <> 0D then
                            "Last Date" := empRec."Retirement Date"
                        else
                            "Last Date" := DMY2DATE(31, 12, DATE2DMY(Today, 3)); //Default - end of current year
                    end;
                end;
            end;
        }
        field(6; "Last Date"; Date)
        {
            Caption = 'Last Date';
            trigger OnValidate()
            begin
                if "First Date" = 0D then
                    Error('Start with the First Date!');
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
                if ("Payroll Country" = '') then begin
                    "Payroll Country" := "Workstation Country";
                    Validate("Payroll Country");
                end;
            end;
        }
        field(8; "Station Code"; Code[50])
        {
            Caption = 'Station Name';
            TableRelation = "Stations";

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
        field(10; "Dept Code"; Code[240])
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
                Sects.SetRange(Code, "Section Code");
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
            var
                LastMvtNo: Code[100];
            begin
                //If added after 15th, do not change their status                
                if (Status = Status::Current) then begin
                    IntEmpHist.Reset();
                    IntEmpHist.SetRange("Emp No.", "Emp No.");
                    IntEmpHist.SetFilter("No.", '<>%1', "No.");
                    IntEmpHist.SetRange(Status, IntEmpHist.Status::Current);
                    if IntEmpHist.FindLast()/*Find('-')*/ then
                        //IntEmpHist.ModifyAll(Status, IntEmpHist.Status::Past);
                        begin
                        LastMvtNo := IntEmpHist."No.";
                        repeat
                            if IntEmpHist."No." = LastMvtNo then //Set most recent mvt to have ended a day before this
                            begin
                                if "First Date" <> 0D then
                                    IntEmpHist."Last Date" := CalcDate('-1D', "First Date");
                            end;
                            IntEmpHist.Status := IntEmpHist.Status::Past;
                            IntEmpHist.Modify();
                        until IntEmpHist.Next() = 0;
                    end;
                end;
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
                if ("Workstation Country" = '') and ("Payroll Country" <> '') then
                    "Workstation Country" := "Payroll Country";
            end;
        }
        field(23; "No Transport Allowance"; Boolean)
        {
            trigger OnValidate()
            begin
                "Applicable House Allowance (%)" := 0;
                if "No Transport Allowance" then
                    "Applicable House Allowance (%)" := 84;
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
        field(27; "Terminal Dues"; Boolean)
        {

        }
        field(29; "Salary Scale"; Code[30])
        {
            Caption = 'Salary Grade';
            DataClassification = ToBeClassified;
            TableRelation = "Salary Scales".Scale;
        }
        field(30; "Next Seniority Date"; Date)
        {
        }
    }
    keys
    {
        key(PK; "No.", "Emp No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        HrSetup: Record "Human Resources Setup";
        lastDay: Integer;
    begin
        //Don't create this after the set date. Wait for next month
        IntEmpHist.Reset();
        IntEmpHist.SetRange("Emp No.", "Emp No.");
        if not IntEmpHist.FindFirst() then //Only if they are being added for the first tine
            begin
            HrSetup.Get();
            lastDay := HrSetup."Final Payroll Adm Day";
            if lastDay = 0 then
                lastDay := 15;
            if (Date2DMY(Today, 1) > lastDay) then //must wait until payroll period is closed
                Error('Wait until the new month before creating staff movement for new employees!');
        end;


        if "No." = '' then begin
            IntEmpHist.Reset();
            if IntEmpHist.FindLast then begin
                "No." := IncStr(IntEmpHist."No.")
            end else begin
                "No." := 'EMPHST-00001';
            end;
        end;
    end;

    trigger OnModify()
    begin
        updateEmployeeCard();
    end;

    var
        IntEmpHist: Record "Internal Employement History";

    procedure updateEmployeeCard() //When you adjust the current record here, also update the 
    var
        empRec: Record Employee;
    begin
        if ("Emp No." <> '') and (Status = Status::Current) then begin
            empRec.Reset();
            empRec.SetRange("No.", "Emp No.");
            if empRec.FindFirst() then begin
                if (empRec."Payroll Country" <> '') and (empRec."Payment/Bank Country" = '') then
                    Error('Kindly provide the bank country for employee No. ' + "Emp No.");
                if "Position Code" <> '' then begin
                    empRec.Position := "Position Code";
                    //empRec.Validate(Position);
                    empRec."Job Title" := "Job Title";
                end;
                if "Dept Code" <> '' then begin
                    empRec."Responsibility Center" := "Dept Code";
                    empRec."Responsibility Center Name" := "Department Name";
                end;
                if "Section Code" <> '' then begin
                    empRec."Sub Responsibility Center" := "Section Code";
                    empRec.Validate("Sub Responsibility Center");
                end;
                if "Station Code" <> '' then begin
                    empRec.Station := "Station Code";
                    Validate("Station Code");
                end;
                empRec."Workstation Country" := "Workstation Country";
                empRec."Payroll Country" := "Payroll Country";
                empRec.Validate("Payroll Country");
                empRec."Payroll Currency" := "Payroll Currency";
                empRec."Contractual Amount Currency" := "Contractual Amount Currency";
                empRec."Contractual Amount Type" := "Contractual Amount Type";
                empRec."Assigned Gross Pay" := "Contractual Amount Value";
                empRec."Apply Paye Multiplier" := "Apply Paye Multiplier";
                empRec."Paye Multiplier" := "Paye Multiplier";
                empRec."Terminal Dues" := "Terminal Dues";
                if ("Salary Scale" <> '') then begin
                    EmpRec."Salary Scale" := "Salary Scale";
                end;
                if ("Next Seniority Date" <> 0D) then begin
                    EmpRec."Next Seniority Date" := "Next Seniority Date";
                end;
                empRec.Validate("Terminal Dues");
                empRec.modify();
            end;
        end;
    end;
}