table 51525449 "Employee Timesheet Lines"
{
    fields
    {
        field(1; "TS  No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; "Employee No."; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Employee Name" := '';
                if EmployeeRec.Get("Employee No.") then begin
                    "Employee Name" := EmployeeRec."Last Name" + ' ' + EmployeeRec."First Name";
                    "Job Title Code" := EmployeeRec.Position;
                    Validate("Job Title Code");
                    Directorate := EmployeeRec."Responsibility Center";
                    Validate(Directorate);
                    Department := EmployeeRec."Sub Responsibility Center";
                    //VALIDATE(Department);
                    "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                    "Location Code" := EmployeeRec."Location Code";
                    //VALIDATE("Location Code");
                    Category := EmployeeRec.Category;
                    "Date Of Current Appointment" := EmployeeRec."Date of Appointment";
                    "Supervisor No." := EmployeeRec."Manager No.";

                end;
                EmpTSHeader.Reset;
                EmpTSHeader.SetRange("No.", "TS  No");
                if EmpTSHeader.FindFirst then begin
                    Month := EmpTSHeader.Month;
                    Year := EmpTSHeader.Year;
                    "Period Start date" := EmpTSHeader."Timesheet Start Date";
                    "Period End Date" := EmpTSHeader."Timesheet End Date";

                end;
                Validate("Global Dimension 1 Code");
                Validate("Global Dimension 2 Code");
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            FieldClass = Normal;
        }
        field(5; "Job Title"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Job Title Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                if CompanyJobsRec.Get("Job Title Code") then
                    "Job Title" := CompanyJobsRec."Job Description";
            end;
        }
        field(9; "List of Key Tasks Undertaken"; Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Approval Status", "Approval Status"::Employee);
            end;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
        }
        field(13; Directorate; Code[20])
        {
            Caption = 'Current Directorate';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                if ResponsibilityCenter.Get(Directorate) then begin
                    "Directorate Name" := ResponsibilityCenter.Name;
                end;
            end;
        }
        field(14; "Directorate Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; Department; Code[240])
        {
            Caption = 'Current Department';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD(Directorate));
        }
        field(19; "Location Code"; Code[100])
        {
            Caption = 'Current Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;

            trigger OnValidate()
            var
                Item: Record Item;
                IsHandled: Boolean;
            begin
                if Locations.Get("Location Code") then Location := Locations.Name;
            end;
        }
        field(20; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Shared,Fixed';
            OptionMembers = ,Shared,"Fixed";

            trigger OnValidate()
            begin
                if Category = Category::Shared then
                    "Global Dimension 2 Code" := 'SHARED';
                Rec.Modify;
            end;
        }
        field(21; Location; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Global Dimension 1 Code"; Code[40])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(37; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(38; "Date Of Current Appointment"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(39; Month; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(40; Year; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(41; "Hours Worked"; Decimal)
        {
            CalcFormula = Sum("Employee Timesheet Ledger".Hours WHERE("Line No." = FIELD("Line No."),
                                                                       "Day Type" = FILTER("Working Day"),
                                                                       Month = FIELD(Month),
                                                                       Year = FIELD(Year)));
            FieldClass = FlowField;
        }
        field(42; "Total Days Worked"; Integer)
        {
            CalcFormula = Count("Employee Timesheet Ledger" WHERE("Line No." = FIELD("Line No."),
                                                                   "Day Type" = FILTER("Working Day"),
                                                                   Hours = FILTER(<> 0),
                                                                   Month = FIELD(Month),
                                                                   Year = FIELD(Year)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Period Start date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Period End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Supervisor No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(46; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Employee,Supervisor,Approved';
            OptionMembers = Employee,Supervisor,Approved;
        }
        field(47; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Offday Hours"; Decimal)
        {
            CalcFormula = Sum("Employee Timesheet Ledger".Hours WHERE("Line No." = FIELD("Line No."),
                                                                       "Day Type" = FILTER(<> "Working Day"),
                                                                       Month = FIELD(Month),
                                                                       Year = FIELD(Year)));
            FieldClass = FlowField;
        }
        field(49; "Date Submitted to Supervisor"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; "Date Approved"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50000; "Processed for One Employee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "TS  No", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        EmployeeRec: Record Employee;
        DimensionValueRec: Record "Dimension Value";
        ResponsibilityCenter: Record "Responsibility Center";
        DimMgt: Codeunit DimensionManagement;
        Locations: Record Location;
        CompanyJobsRec: Record "Company Jobs";
        EmpTSHeader: Record "Employee Timesheet Header";

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Employee, "Employee No.", FieldNumber, ShortcutDimCode);
        //MODIFY;
    end;
}