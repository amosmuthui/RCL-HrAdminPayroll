table 51525430 "Employee Transfer Lines"
{
    fields
    {
        field(1; "Transfer No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Employee No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Employee Name" := '';
                if EmployeeRec.Get("Employee No.") then begin
                    "Employee Name" := EmployeeRec."Last Name" + ' ' + EmployeeRec."First Name";
                    "Current Job Title Code" := EmployeeRec.Position;
                    Validate("Current Job Title Code");
                    "Current Directorate" := EmployeeRec."Responsibility Center";
                    Validate("Current Directorate");
                    "Current Department" := EmployeeRec."Sub Responsibility Center";
                    Validate("Current Department");
                    "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    Validate("Global Dimension 1 Code");
                    "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                    Validate("Global Dimension 2 Code");
                    "Current Location Code" := EmployeeRec."Location Code";
                    Validate("Current Location Code");
                    "Current Category" := EmployeeRec.Category;
                    "Date Of Current Appointment" := EmployeeRec."Date of Appointment";
                    "Transfer Date" := Today;
                end;
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
            FieldClass = Normal;
        }
        field(5; "Current Job Title"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Current Job Title Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                if CompanyJobsRec.Get("Current Job Title Code") then
                    "Current Job Title" := CompanyJobsRec."Job Description";
            end;
        }
        field(7; "New Job Title"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Transfer Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',lateral,Voluntary,Non-Voluntary';
            OptionMembers = ,lateral,Voluntary,"Non-Voluntary";
        }
        field(9; Remark; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "New Job Title Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                if CompanyJobsRec.Get("New Job Title Code") then
                    "New Job Title" := CompanyJobsRec."Job Description";
            end;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
        }
        field(13; "Current Directorate"; Code[20])
        {
            Caption = 'Current Directorate';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                if ResponsibilityCenter.Get("Current Directorate") then begin
                    "Current Directorate Name" := ResponsibilityCenter.Name;
                end;
            end;
        }
        field(14; "Current Directorate Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Current Department"; Code[240])
        {
            Caption = 'Current Department';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD("Current Directorate"));
        }
        field(16; "New Directorate"; Code[20])
        {
            Caption = 'New Directorate';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                if ResponsibilityCenter.Get("New Directorate") then begin
                    "New Directorate Name" := ResponsibilityCenter.Name;
                end;
            end;
        }
        field(17; "New Directorate Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "New Department"; Code[70])
        {
            Caption = 'New Department';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD("New Directorate"));
        }
        field(19; "Current Location Code"; Code[100])
        {
            Caption = 'Current Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;

            trigger OnValidate()
            var
                Item: Record Item;
                IsHandled: Boolean;
            begin
                if Locations.Get("Current Location Code") then "Current Location" := Locations.Name;
            end;
        }
        field(20; "Current Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Shared,Fixed';
            OptionMembers = ,Shared,"Fixed";

            trigger OnValidate()
            begin
                if "Current Category" = "Current Category"::Shared then
                    "Global Dimension 2 Code" := 'SHARED';
                Rec.Modify;
            end;
        }
        field(21; "Current Location"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "New Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Shared,Fixed';
            OptionMembers = ,Shared,"Fixed";

            trigger OnValidate()
            begin
                if "Current Category" = "Current Category"::Shared then
                    "Global Dimension 2 Code" := 'SHARED';
                Rec.Modify;
            end;
        }
        field(23; "New Location Code"; Code[100])
        {
            Caption = 'New Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;

            trigger OnValidate()
            var
                Item: Record Item;
                IsHandled: Boolean;
            begin
                if Locations.Get("New Location Code") then "New Location" := Locations.Name;
            end;
        }
        field(24; "New Location"; Text[100])
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
        field(39; "Transfer Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Transfer No", "Line No.")
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

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Employee, "Employee No.", FieldNumber, ShortcutDimCode);
        Rec.Modify;
    end;
}