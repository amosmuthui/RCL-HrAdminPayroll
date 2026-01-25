table 51525442 "Training Needs"
{
    DrillDownPageID = "Travelling Employees";
    LookupPageID = "Travelling Employees";

    fields
    {
        field(1; "Code"; Integer)
        {
            AutoIncrement = true;
            NotBlank = false;
        }
        field(2; Description; Text[250])
        {
        }
        field(3; "Start Date"; Date)
        {
        }
        field(4; "End Date"; Date)
        {
        }
        field(5; "Duration Units"; Option)
        {
            OptionMembers = Hours,Days,Weeks,Months,Years;
        }
        field(6; Duration; Decimal)
        {
        }
        field(7; "Cost Of Training"; Decimal)
        {

            trigger OnValidate()
            begin
                if Posted then begin
                    if Duration <> xRec.Duration then begin
                        Message('%1', 'You cannot change the costs after posting');
                        Duration := xRec.Duration;
                    end
                end
            end;
        }
        field(8; Location; Text[100])
        {
        }
        field(9; Qualification; Code[30])
        {
            NotBlank = true;
            TableRelation = Qualification.Code;
        }
        field(10; "Re-Assessment Date"; Date)
        {
        }
        field(11; Source; Code[50])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                //"Training Source".Source
            end;
        }
        field(12; "Need Source"; Option)
        {
            OptionCaption = ' ,Succesion,Training,Employee,Employee Skill Plan';
            OptionMembers = " ",Succesion,Training,Employee,"Employee Skill Plan";

            trigger OnValidate()
            begin
                TrainingNeed := '';

                if "Need Source" = "Need Source"::Succesion then
                    // BEGIN
                    DevelopmentNeed.Reset;
                DevelopmentNeed.SetRange(DevelopmentNeed."Employee No.", "Employee No");
                DevelopmentNeed.SetRange(DevelopmentNeed."Appraisal Period", "Appraisal Period");
                if DevelopmentNeed.Find('-') then
                    /* REPEAT
                     TrainingNeed:=TrainingNeed+DevelopmentNeed."Development Need";
                    UNTIL DevelopmentNeed.NEXT=0;
                     Description:=TrainingNeed;
                    END ELSE
                     */

                    // MESSAGE('development need=%1',DevelopmentNeed."Development Need");

                    Description := DevelopmentNeed."Development Need";

            end;
        }
        field(13; Provider; Code[20])
        {
            TableRelation = Vendor."No.";
        }
        field(14; Post; Boolean)
        {
        }
        field(15; Posted; Boolean)
        {
            Editable = true;
        }
        field(16; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnLookup()
            begin

                DimensionValue.Reset;
                if DimensionValue.Get('WORKSTATION', "Department Code") then
                    "Department Name" := DimensionValue.Name;
            end;

            trigger OnValidate()
            begin
                DimensionValue.Reset;
                if DimensionValue.Get('DEPARTMENT', "Department Code") then
                    "Department Name" := DimensionValue.Name;
            end;
        }
        field(17; "Employee No"; Code[20])
        {
            TableRelation = Employee WHERE("Global Dimension 1 Code" = FIELD(Directorate),
                                            "Global Dimension 2 Code" = FIELD("Department Code"));

            trigger OnValidate()
            begin
                Employee.Reset;
                if Employee.Get("Employee No") then
                    "Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
            end;
        }
        field(18; "Employee Name"; Text[50])
        {
        }
        field(19; "Appraisal Period"; Code[20])
        {
        }
        field(20; "Proposed Training"; Text[250])
        {
        }
        field(21; Directorate; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin

                DimensionValue.Reset;
                if DimensionValue.Get('WORKSTATION', Directorate) then
                    "Workstation Name" := DimensionValue.Name;
            end;
        }
        field(22; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected;
        }
        field(23; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(24; "HOD/Individual"; Option)
        {
            OptionCaption = 'HOD,Individual';
            OptionMembers = HOD,Individual;
        }
        field(25; "Duration(Date)"; Date)
        {
        }
        field(26; Select; Boolean)
        {
        }
        field(27; "Workstation Name"; Text[50])
        {
        }
        field(28; "Department Name"; Text[50])
        {
        }
        field(29; "Header No."; Code[20])
        {
        }
        field(30; "Period End Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Code", Directorate, "Department Code", "Period End Date", "Header No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Description, "Employee No", "Employee Name")
        {
        }
    }

    trigger OnInsert()
    begin

        /*IF Code = '' THEN BEGIN
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD(HumanResSetup."Training Need Nos");
          NoSeriesMgt.InitSeries(HumanResSetup."Training Need Nos",xRec."No. Series",0D,Code,"No. Series");
        END;
         */

    end;

    var
        Employee: Record Employee;
        OK: Boolean;
        AppraisalLines: Record "Appraisal Lines";
        TrainingNeed: Text[250];
        DevelopmentNeed: Record "Appraisal Development Needs";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        DimensionValue: Record "Dimension Value";
}