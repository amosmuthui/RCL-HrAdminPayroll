table 51525346 "Training Schedules"
{
    Caption = 'Training Schedules';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Training Schedules";
    LookupPageId = "Training Schedules";

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Emp No."; Code[50])
        {
            Caption = 'Emp No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                empRec: Record Employee;
            begin
                if "Emp No." <> '' then begin
                    empRec.Reset();
                    empRec.SetRange("No.", "Emp No.");
                    if empRec.FindFirst() then begin
                        "Employee Name" := empRec."First Name" + ' ' + empRec."Middle Name" + ' ' + empRec."Last Name";
                        if empRec.Position = '' then
                            Error('You must specify the job position of the selected employee in the employee card!');
                        Position := empRec.Position;
                        DeptCode := empRec."Responsibility Center";
                        Department := empRec."Responsibility Center Name";
                        Section := empRec."Sub Responsibility Center";
                        Validate(Position);
                    end;
                end;
            end;
        }
        field(3; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Training No."; Code[50])
        {
            Caption = 'Course No.';
            //TableRelation = "Training Master Plan Lines"."No." where(Position = FIELD(Position));
            TableRelation = "Training Master Plan Header"."No.";

            trigger OnValidate()
            var
                TMPHeader: Record "Training Master Plan Header";
                TMPLine: Record "Training Master Plan Lines";
            begin
                if "Training No." <> '' then begin
                    TMPHeader.Reset();
                    TMPHeader.SetRange("No.", "Training No.");
                    if TMPHeader.FindFirst() then begin
                        "Training Title" := TMPHeader.Title;
                        "Training Description" := TMPHeader.Description;
                        "Duration" := TMPHeader."Approximate Duration";
                        Objectives := TMPHeader.Objectives;
                        Department := 'Unclassified';
                        Frequency := TMPHeader.Frequency;
                    end;
                end;
            end;
        }
        field(5; "Training Title"; Text[250])
        {
            Caption = 'Event Title';
            Editable = false;
        }
        field(6; "Training Description"; Text[2000])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; "Start Date"; Date)
        {
            Caption = 'Scheduled Date';

            trigger OnValidate()
            var
                DateFilter: Text[20];
            begin
                "End Date" := 0D;
                if "Start Date" <> 0D then begin
                    if ((StrPos("Duration", 'H') > 0) or (Duration = '')) then
                        DateFilter := '0D'
                    else
                        DateFilter := Duration;
                    "End Date" := CalcDate(DateFilter, "Start Date");

                    //If duration is in days, reduce by a day to get the actual
                    if (StrPos("Duration", 'D') > 0) then
                        "End Date" := CalcDate('<-1D>', "End Date");
                end;
                Validate("End Date");
            end;
        }
        field(8; "End Date"; Date)
        {
            Caption = 'Completion Date';

            trigger OnValidate()
            begin
                UpdateLineDates();
                /*ScheduleLines.Reset();
                ScheduleLines.SetRange("Schedule No.", "No.");
                if ScheduleLines.Find('-') then
                    ScheduleLines.ModifyAll("Renew By", "End Date");*/
            end;
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Pending,Postponed,Ongoing,Done;

            trigger OnValidate()
            var
                Window: Dialog;
                CourseAbbreviation: Code[100];
                ParticipantLineNo: Integer;
            begin
                ParticipantLineNo := 0;
                CourseAbbreviation := '';
                if (Status = Status::Done) and ("Trainer Category" = "Trainer Category"::Internal) then begin
                    ScheduleLines.Reset();
                    ScheduleLines.SetRange("Schedule No.", "No.");
                    if ScheduleLines.FindSet() then begin
                        Window.Open('Generating certificate serial number for ##');
                        TrainingMasterPlan.Reset();
                        TrainingMasterPlan.SetRange("No.", "Training No.");
                        TrainingMasterPlan.SetFilter("Course Abbreviation", '<>%1', '');
                        if TrainingMasterPlan.FindFirst() then
                            CourseAbbreviation := TrainingMasterPlan."Course Abbreviation"
                        else
                            Error('Kindly set the course abbreviation for %1', "Training Title");
                        repeat
                            Window.Update(0, ScheduleLines."Employee Name");
                            ParticipantLineNo += 1;
                            ScheduleLines."Line No." := ParticipantLineNo;
                            ScheduleLines."Certificate Serial No." := 'CORP-' + CourseAbbreviation + '-' + CopyStr('0000' + Format(ParticipantLineNo), StrLen(Format(ParticipantLineNo)) + 1, 5);
                            ScheduleLines.updateParticipantType();
                            ScheduleLines.Modify();
                        until ScheduleLines.Next() = 0;
                        Window.Close();
                    end;
                end;
            end;
        }
        field(10; "Training Report (Summary)"; Text[250])
        {
            Caption = 'Training Report (Summary)';
        }
        field(11; Position; Code[50])
        {
            Caption = 'Position ID';
            TableRelation = "Company Jobs"."Job ID";
            //Editable = false;

            trigger OnValidate()
            var
                Jobs: Record "Company Jobs";
            begin
                if Position <> '' then begin
                    Jobs.Reset();
                    Jobs.SetRange("Job ID", Position);
                    if Jobs.FindFirst() then
                        "Job Title" := Jobs."Job Description";
                end;
            end;
        }
        field(12; "Job Title"; Text[250])
        {
            Caption = 'Position Title';
            Editable = false;
        }
        field(13; "Duration"; Code[10])
        {
            Caption = 'Duration';
            trigger OnValidate()
            begin
                "Duration" := DelChr("Duration", '=', ''); //Remove spaces
                if (("Duration" <> '') and (StrPos("Duration", 'H') = 0) and (StrPos("Duration", 'D') = 0) and (StrPos("Duration", 'W') = 0) and (StrPos("Duration", 'M') = 0) and (StrPos("Duration", 'Y') = 0)) then
                    Error('The Duration should be a number followed by either H for hours, D for days, W for weeks, M for months, or Y for years!');
                Validate("Start Date");
            end;
        }
        field(14; DeptCode; Code[240])
        {
            //Editable = false;
            TableRelation = "Responsibility Center".Code;
        }
        field(15; Department; Text[240])
        {
            Caption = 'Category';
            Editable = false;
            TableRelation = "Responsibility Center".Name;
        }
        field(16; Section; Text[100])
        {
            //Editable = false;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD("DeptCode"));
        }
        field(17; "Participants Emailed"; Boolean)
        {
            Editable = false;
        }
        field(18; "Participants Emailed On"; DateTime)
        {
            Editable = false;
        }
        field(19; Objectives; Text[2000])
        {

        }
        field(20; "Trainer Category"; Option)
        {
            OptionMembers = "Internal",Supplier;
        }
        field(21; "Training Location"; Text[250])
        {
            Caption = 'Location';
            TableRelation = "Training Locations".Location;
        }
        field(22; "Trainer No."; Code[100])
        {
            TableRelation = IF ("Trainer Category" = CONST("Internal")) "Employee"
            ELSE
            IF ("Trainer Category" = CONST(Supplier)) "External Trainers";

            trigger OnValidate()
            var
                ExtTrainer: Record "External Trainers";
                InternalTrainer: Record Employee;
            begin
                "Trainer Name" := '';
                if "Trainer No." <> '' then begin
                    if "Trainer Category" = "Trainer Category"::"Internal" then begin
                        InternalTrainer.Reset();
                        InternalTrainer.SetRange("No.", "Trainer No.");
                        if InternalTrainer.FindFirst() then
                            "Trainer Name" := InternalTrainer."First Name" + ' ' + InternalTrainer."Middle Name" + ' ' + InternalTrainer."Last Name";
                    end;
                    if "Trainer Category" = "Trainer Category"::Supplier then begin
                        ExtTrainer.Reset();
                        ExtTrainer.SetRange("No.", "Trainer No.");
                        if ExtTrainer.FindFirst() then
                            "Trainer Name" := ExtTrainer.Name;
                    end;
                end;
            end;
        }
        field(23; "Trainer Name"; Text[250])
        {
            Editable = false;
        }
        field(24; Frequency; Code[10])
        {
            Caption = 'Frequency';
            trigger OnValidate()
            begin
                Frequency := DelChr(Frequency, '=', ''); //Remove spaces
                if ((Frequency <> '') and (StrPos(Frequency, 'D') = 0) and (StrPos(Frequency, 'W') = 0) and (StrPos(Frequency, 'M') = 0) and (StrPos(Frequency, 'Y') = 0)) then
                    Error('The Frequency should be a number followed by either D for days, W for weeks, M for months, or Y for years!');
                UpdateLineDates();
            end;
        }
        field(25; "Legacy Data"; Boolean)
        {
            Editable = false;
        }
        field(26; "Talent Dev. No."; Code[100])
        {
            TableRelation = "Employee";

            trigger OnValidate()
            var
                Emp: Record Employee;
            begin
                "Talent Development Specialist" := '';
                if "Talent Dev. No." <> '' then begin
                    Emp.Reset();
                    Emp.SetRange("No.", "Talent Dev. No.");
                    if Emp.FindFirst() then
                        "Talent Development Specialist" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                end;
            end;
        }
        field(27; "Talent Development Specialist"; Text[250])
        {
            Editable = false;
        }
        /*field(28; "Trainer Signature"; Blob)
        {
            FieldClass = FlowField;
            SubType = Bitmap;

            CalcFormula =
            IF ("Trainer Category" = CONST(Internal)) 
                Lookup(Employee."Employee Signature" WHERE("No." = FIELD("Trainer No.")))
            ELSE 
            IF ("Trainer Category" = CONST(Supplier)) 
                Lookup("External Trainers".Signature WHERE("No." = FIELD("Trainer No.")));
        }*/
        field(28; "Instructor Allowance"; Decimal)
        { }
        field(29; "Facility Costs"; Decimal)
        { }
        field(30; "Certificates Issued?"; Option)
        {
            OptionMembers = Yes,No;
        }
        field(31; "Facility Lunch"; Decimal)
        { }
        field(32; "Head office Lunch"; Decimal)
        { }
        field(33; "Other Costs"; Decimal)
        { }
        field(34; "Participants Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Training Schedule Lines" where("Schedule No." = field("No.")));
        }
        field(35; "Add. Instructor Allowances"; Integer)
        {
            Caption = 'Additional Instructor Allowances';
            FieldClass = FlowField;
            CalcFormula = sum("Additional Instructors".Allowance where("Class No." = field("No.")));
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
        if TrainingMasterPlan.IsAReadOnlyUser() then
            Error('You are not authorized to modify these records!');

        if "No." = '' then begin
            TraingScheds.Reset();
            if TraingScheds.FindLast then begin
                "No." := IncStr(TraingScheds."No.")
            end else begin
                "No." := 'TRN-0001';
            end;
        end;
    end;

    trigger OnModify()
    begin
        if TrainingMasterPlan.IsAReadOnlyUser() then
            Error('You are not authorized to modify these records!');
    end;

    trigger OnDelete()
    begin
        Error('Deletion is not allowed!');
    end;

    var
        TraingScheds: Record "Training Schedules";
        ScheduleLines: Record "Training Schedule Lines";
        TrainingMasterPlan: Record "Training Master Plan Header";

    procedure UpdateLineDates()
    begin
        ScheduleLines.Reset();
        ScheduleLines.SetRange("Schedule No.", "No.");
        if ScheduleLines.FindSet() then
            repeat
                ScheduleLines."Start Date" := "Start Date";
                ScheduleLines."End Date" := "End Date";
                if ("End Date" <> 0D) and (Frequency <> '') then
                    ScheduleLines."Renew By" := CalcDate(Frequency, "Start Date");
                ScheduleLines.Modify();
            until ScheduleLines.Next() = 0;
    end;
}