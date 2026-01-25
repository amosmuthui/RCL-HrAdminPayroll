table 51525311 "Job Exit Interview"
{
    DrillDownPageID = "Job Exit Interview List";
    LookupPageID = "Job Exit Interview List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Employee No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                Supervisor := '';
                "Supervisor Name" := '';
                "Date of Join" := 0D;
                "Employee Name" := '';
                if "Employee No." <> '' then begin
                    Emp.Reset();
                    Emp.SetRange("No.", "Employee No.");
                    if Emp.FindFirst() then begin
                        "Employee Name" := Emp.FullName();
                        Supervisor := Emp."Manager No.";
                        Validate(Supervisor);
                        "Date of Join" := Emp."Date Of Join";
                    end;
                end;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Position; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Supervisor; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                "Supervisor Name" := '';
                if Supervisor <> '' then begin
                    Emp.Reset();
                    Emp.SetRange("No.", Supervisor);
                    if Emp.FindFirst() then
                        "Supervisor Name" := Emp.FullName();
                end;
            end;
        }
        field(6; "Date of Join"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Termination Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Reason for Leaving"; Text[150])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Exit Reason";
        }
        field(9; "Job Satisfying areas"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Job Frustrating Areas"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Complicated Company Policies"; Text[250])
        {
            Caption = '<Complicated Company Policies/Procedures>';
            DataClassification = ToBeClassified;
        }
        field(12; "Future Re-Employment"; Boolean)
        {
            Caption = 'Available for future Re-employment?';
            DataClassification = ToBeClassified;
        }
        field(13; "Recommend To Others"; Boolean)
        {
            Caption = 'Would you recommend CMA to Others?';
            DataClassification = ToBeClassified;
        }
        field(14; "Leaving could have prevented"; Boolean)
        {
            Caption = 'Leaving could have been prevented';
            DataClassification = ToBeClassified;
        }
        field(15; "Preventive Measure Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Other Helpful  Information"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(18; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "User Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(20; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Sent';
            OptionMembers = Open,Sent;
        }
        field(21; "Supervisor Name"; Text[250])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if (Code = '') then begin
            HumanResourcesSetupRec.Get;
            HumanResourcesSetupRec.TestField(HumanResourcesSetupRec."Exit Interview Nos.");
            Code := NoSeriesMgt.GetNextNo(HumanResourcesSetupRec."Exit Interview Nos.");
        end;

        "User Id" := UserId;
        "Document Date" := Today;
        if UserSetupRec.Get(UserId) then begin
            if EmployeeRec.Get(UserSetupRec."Employee No.") then begin
                "Employee No." := EmployeeRec."No.";
                "Employee Name" := EmployeeRec."Last Name" + ' ' + EmployeeRec."First Name";//+EmployeeRec."Middle Name";
                "Date of Join" := EmployeeRec."Date Of Join";
                Position := EmployeeRec."Job Title";
            end;
        end;

        //Populate employee experience lines
        EmploymentExperienceRatingRec.Reset;
        EmploymentExperienceRatingRec.SetRange("Work Experienc Rating", true);
        if EmploymentExperienceRatingRec.FindFirst then
            repeat
                EmployeeExperienceRatingRec.Init;
                EmployeeExperienceRatingRec."Exit Interview Code" := Code;
                EmployeeExperienceRatingRec."Line No." := EmployeeExperienceRatingRec."Line No." + 10000;
                EmployeeExperienceRatingRec.Description := EmploymentExperienceRatingRec.Description;
                EmployeeExperienceRatingRec.Insert;

            until EmploymentExperienceRatingRec.Next = 0;


        EmploymentExperienceRatingRec.Reset;
        EmploymentExperienceRatingRec.SetRange("Supervisor Rating", true);
        if EmploymentExperienceRatingRec.FindFirst then
            repeat
                SupervisorExperienceRatingRec.Init;
                SupervisorExperienceRatingRec."Exit Interview Code" := Code;
                SupervisorExperienceRatingRec."Line No." := SupervisorExperienceRatingRec."Line No." + 10000;
                SupervisorExperienceRatingRec.Description := EmploymentExperienceRatingRec.Description;
                SupervisorExperienceRatingRec.Insert;

            until EmploymentExperienceRatingRec.Next = 0;
    end;

    var
        HumanResourcesSetupRec: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        UserSetupRec: Record "User Setup";
        EmployeeRec: Record Employee;
        EmployeeExperienceRatingRec: Record "Employee Experience Rating";
        EmploymentExperienceRatingRec: Record "Employment Experience Rating";
        SupervisorExperienceRatingRec: Record "Supervisor Experience Rating";
        LineNo: Integer;
}