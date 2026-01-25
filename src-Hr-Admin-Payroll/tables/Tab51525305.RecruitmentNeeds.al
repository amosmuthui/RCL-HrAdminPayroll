table 51525305 "Recruitment Needs"
{
    DrillDownPageID = "All Recruitment Needs";
    LookupPageID = "All Recruitment Needs";

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = false;
        }
        field(2; "Job ID"; Code[20])
        {
            NotBlank = false;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            var
                JobScreeningQuestions: Record "Job Screening Questions";
                JobScreeningQuestionsInit: Record "Job Screening Questions";
                ApplicablePositions: Record "Applicable Positions";
            begin
                Jobs.Reset;
                Jobs.SetRange(Jobs."Job ID", "Job ID");
                if Jobs.Find('-') then
                    Description := Jobs."Job Description";
                Positions := Jobs."Vacant Establishments";

                if "Job ID" <> '' then begin
                    JobScreeningQuestions.Reset();
                    JobScreeningQuestions.SetRange("Job No.", "No.");
                    JobScreeningQuestions.SetFilter(Description, '<>%1', '');
                    if not JobScreeningQuestions.FindFirst() then begin
                        //Questions don't exist, copy all that apply to this position
                        ApplicablePositions.Reset();
                        ApplicablePositions.SetRange("Position No.", "Job ID");
                        if ApplicablePositions.FindSet() then
                            repeat
                                JobScreeningQuestionsInit.Init();
                                JobScreeningQuestionsInit."Job No." := "No.";
                                JobScreeningQuestionsInit."Question Entry No." := ApplicablePositions."Question No.";
                                JobScreeningQuestionsInit.Validate("Question Entry No.");
                                JobScreeningQuestionsInit.Insert();
                            until ApplicablePositions.Next() = 0;
                    end;
                end;

                NeedsRequirements.Reset;
                NeedsRequirements.SetRange("Need Id", "No.");
                if NeedsRequirements.Find('-') then begin
                    NeedsRequirements.DeleteAll
                end;

                JobRequirements.Reset;
                JobRequirements.SetRange(JobRequirements."Job Id", "Job ID");
                if JobRequirements.FindSet(true) then begin
                    repeat
                        if JobRequirements.Description <> '' then begin
                            NeedsRequirements.Init;
                            NeedsRequirements."Need Id" := "No.";
                            NeedsRequirements."Job Id" := JobRequirements."Job Id";
                            NeedsRequirements."Qualification Type" := JobRequirements."Qualification Type";
                            NeedsRequirements.Qualification := JobRequirements.Qualification;
                            NeedsRequirements."Course Name" := JobRequirements.Description;
                            NeedsRequirements."Education Level Name" := JobRequirements.Qualification;
                            NeedsRequirements.Priority := JobRequirements.Priority;
                            NeedsRequirements."Course Id" := JobRequirements.Level;
                            NeedsRequirements."Education Level Id" := JobRequirements."Qualification Code";
                            NeedsRequirements.Insert;
                        end;
                    until JobRequirements.Next = 0;

                end;
            end;
        }
        field(3; Date; Date)
        {
        }
        field(4; Priority; Option)
        {
            OptionCaption = 'High,Medium,Low';
            OptionMembers = High,Medium,Low;
        }
        field(5; Positions; Integer)
        {
        }
        field(6; Approved; Boolean)
        {

            trigger OnValidate()
            begin
                "Date Approved" := Today;
            end;
        }
        field(7; "Date Approved"; Date)
        {
        }
        field(8; Description; Text[200])
        {
        }
        field(9; Stage; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Recruitment Stages1"."Recruitement Stage";

            trigger OnValidate()
            begin
                /*
                RShort.RESET;
                RShort.SETRANGE(RShort."Need Code","Need Code");
                RShort.SETRANGE(RShort."Stage Code",Stage);
                RShort.CALCSUMS(RShort."Desired Score");
                Score:=RShort."Desired Score";
                */

            end;
        }
        field(10; Score; Decimal)
        {
            FieldClass = Normal;
        }
        field(11; "Stage Code"; Code[20])
        {
            TableRelation = "Recruitment Stages1"."Recruitement Stage";
        }
        field(12; Qualified; Boolean)
        {
            FieldClass = Normal;
        }
        field(13; "No Filter"; Integer)
        {
            FieldClass = FlowFilter;
        }
        field(14; "Start Date"; Date)
        {
        }
        field(15; "End Date"; Date)
        {
        }
        field(16; "Documentation Link"; Text[200])
        {
        }
        field(17; "Turn Around Time"; Integer)
        {
            Editable = false;
        }
        field(18; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(19; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(20; "Reason for Recruitment"; Option)
        {
            OptionMembers = " ","New Hire","Replacement";
        }
        field(21; "Appointment Type"; Code[10])
        {
            TableRelation = "Employment Contract";
        }
        field(22; "Requested By"; Code[30])
        {
        }
        field(23; "Expected Reporting Date"; Date)
        {
        }
        field(24; Status; Option)
        {
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected,Closed;

            //temporarily
            trigger OnValidate()
            begin
                if Status = Status::Released then
                    Advertise := true;
            end;
        }
        field(25; "Recruitment Cycle"; Code[30])
        {
            TableRelation = "Recruitment Cycles";
        }
        field(26; Degree; Boolean)
        {

            trigger OnValidate()
            begin
                if Degree = true then begin
                    "Shortlisting Criteria" += 1;
                end;
                if Degree = false then begin
                    "Shortlisting Criteria" -= 1;
                end;
            end;
        }
        field(27; Masters; Boolean)
        {

            trigger OnValidate()
            begin
                if Masters = true then begin
                    "Shortlisting Criteria" += 1;
                end;
                if Masters = false then begin
                    "Shortlisting Criteria" -= 1;
                end;
            end;
        }
        field(28; PHD; Boolean)
        {

            trigger OnValidate()
            begin
                if PHD = true then begin
                    "Shortlisting Criteria" += 1;
                end;
                if PHD = false then begin
                    "Shortlisting Criteria" -= 1;
                end;
            end;
        }
        field(29; Certification; Boolean)
        {

            trigger OnValidate()
            begin
                if Certification = true then begin
                    "Shortlisting Criteria" += 1;
                end;
                if Certification = false then begin
                    "Shortlisting Criteria" -= 1;
                end;
            end;
        }
        field(30; "Professional Body"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Professional Body" = true then begin
                    "Shortlisting Criteria" += 1;
                end;
                if "Professional Body" = false then begin
                    "Shortlisting Criteria" -= 1;
                end;
            end;
        }
        field(31; diploma; Boolean)
        {

            trigger OnValidate()
            begin
                if diploma = true then begin
                    "Shortlisting Criteria" += 1;
                end;
                if diploma = false then begin
                    "Shortlisting Criteria" -= 1;
                end;
            end;
        }
        field(32; "Shortlisting Criteria"; Integer)
        {
        }
        field(33; "Experience(Yrs)"; Integer)
        {

            trigger OnValidate()
            begin
                /*IF "Experience(Yrs)"<>0 THEN BEGIN
                    "Shortlisting Criteria"+=1;
                  JobApplicationsTable.RESET;
                  JobApplicationsTable.SETRANGE("Recruitment Need Code","No.");
                  IF "Experience(Yrs)">JobApplicationsTable.COUNT THEN
                    ERROR('Only %1 Candidates Applied For this Position',JobApplicationsTable.COUNT);
                END;*/

            end;
        }
        field(34; "Level Or Higher"; Boolean)
        {
        }
        field(35; "Course 1"; Text[200])
        {
            TableRelation = "Courses Setup";
        }
        field(36; "Course 2"; Text[200])
        {
            TableRelation = "Courses Setup";
        }
        field(37; "Masters Course"; Text[200])
        {
            TableRelation = "Courses Setup" WHERE("Course Type" = CONST(Masters));
        }
        field(38; "Course 3"; Text[200])
        {
            TableRelation = "Courses Setup";
        }
        field(39; "PHD Course"; Text[200])
        {
            TableRelation = "Courses Setup" WHERE("Course Type" = CONST(PHD));
        }
        field(40; "Professional Body 1"; Text[200])
        {
            TableRelation = "Professional Bodies";
        }
        field(41; "Professional Body 2"; Text[200])
        {
            TableRelation = "Professional Bodies";
        }
        field(42; "Professional Body 3"; Text[200])
        {
            TableRelation = "Professional Bodies";
        }
        field(43; "Professional Body 4"; Text[200])
        {
            TableRelation = "Professional Bodies";
        }
        field(44; "Professional Body 5"; Text[200])
        {
            TableRelation = "Professional Bodies";
        }
        field(45; "Short Listing Done?"; Boolean)
        {
        }
        field(46; "Requires Aptitude Test"; Boolean)
        {
        }
        field(47; "Minutes Path"; Text[200])
        {
        }
        field(48; "Recruitment Closed"; Boolean)
        {
        }
        field(49; "In Oral Test"; Boolean)
        {
        }
        field(50; "Past Oral Test"; Boolean)
        {
        }
        field(51; "Closed Applications"; Boolean)
        {
        }
        field(52; "Panelist 1"; Code[20])
        {
            TableRelation = "User Setup";
        }
        field(53; "Panelist 2"; Code[20])
        {
            TableRelation = "User Setup";
        }
        field(54; "Panelist 3"; Code[20])
        {
            TableRelation = "User Setup";
        }
        field(55; "Panelist 4"; Code[20])
        {
            TableRelation = "User Setup";
        }
        field(56; "Panelist 5"; Code[20])
        {
            TableRelation = "User Setup";
        }
        field(57; DateTimeAdded; DateTime)
        {
        }
        field(58; isInternship; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Oral Interview Complete"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Technical Interview Complete"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(61; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(62; "Requisition Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Internal,External';
            OptionMembers = Open,Internal,External;
        }
        field(63; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                Employee.Reset;
                Employee.SetRange("No.", "Employee No.");
                if Employee.FindFirst then begin
                    "Global Dimension 1" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2" := Employee."Global Dimension 2 Code";
                    "Shortcut Dimension 3" := Employee."Shortcut Dimension 3 Code";
                    "Employee Name" := Employee.FullName;
                    "Requested By" := Employee."User ID";
                    "Responsibility Center" := Employee."Responsibility Center";
                    "Sub Responsibility Center" := Employee."Sub Responsibility Center";
                end else begin
                    "Global Dimension 1" := '';
                    "Global Dimension 2" := '';
                    "Shortcut Dimension 3" := '';
                    "Employee Name" := '';
                    "Requested By" := '';
                    "Responsibility Center" := '';
                    "Sub Responsibility Center" := '';
                end;
            end;
        }
        field(64; "Employee Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(65; "Global Dimension 1"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(66; "Global Dimension 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(67; "Shortcut Dimension 3"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(68; "Portal Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(82; "Cert of Good Conduct Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(83; "HELB Clearance Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(84; "E.A.C.C Clearance Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85; "CRB Clearance Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(86; "TAX Compliance Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(87; "Advertisement Link"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(88; "Select Top"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(89; "Pass Mark"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90; "Total Interview Score"; Decimal)
        {
            CalcFormula = Sum("Job Interview List"."Maximum Score" WHERE("Recruitment No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(91; "Validate Required Attachments"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(92; "Validate Prof Documents"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(93; "Minimum Academic Level"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Academic Education Level".EducationLevelID;
        }
        field(94; "Other Requirements"; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(95; "Minimum Academic Level Lk"; Text[100])
        {
            CalcFormula = Lookup("Academic Education Level".Description WHERE(EducationLevelID = FIELD("Minimum Academic Level")));
            FieldClass = FlowField;
        }
        field(96; "Reporting To"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Company Jobs"."Job ID";
        }
        field(97; "Reporting To(Desc)"; Text[250])
        {
            CalcFormula = Lookup("Company Jobs"."Job Description" WHERE("Job ID" = FIELD("Reporting To")));
            FieldClass = FlowField;
        }
        field(98; "Responsibility Center"; Code[240])
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                if ResponsibilityCenter.Get("Responsibility Center") then begin
                    "Responsibility Center Name" := ResponsibilityCenter.Name;
                end;
            end;
        }
        field(99; "Responsibility Center Name"; Text[240])
        {
            DataClassification = ToBeClassified;
            Caption = 'Department';
        }
        field(100; "Sub Responsibility Center"; Code[70])
        {
            Caption = 'Section';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code WHERE("Responsibility Center" = FIELD("Responsibility Center"));
        }
        field(101; "Applicable Interview(s)"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Written and Oral,Oral';
            OptionMembers = "Written and Oral",Oral;
        }
        field(102; "Current Stage"; Option)
        {
            OptionCaption = 'Pending,Receiving Applications,Shortlisting,First Interview,Due Diligence,Second Interview,Completed';
            OptionMembers = "Pending Applications","Receiving Applications",Shortlisting,"First Interview","Due Diligence","Second Interview",Completed;
        }
        field(103; "Budget Status"; Option)
        {
            OptionMembers = Budgeted,"Not Budgeted";
            trigger OnValidate()
            begin
                if "Budget Status" = "Budget Status"::"Not Budgeted" then
                    Message('For a non-budgeted request, you must attach a supporting document!');
            end;
        }
        field(104; "Detailed JD Attachment"; Media)
        {
        }
        field(105; "Detailed JD FileName"; Text[250])
        {

        }
        field(106; "Written Interview DateTime"; DateTime)
        {

        }
        field(107; "Oral Interview DateTime"; DateTime)
        {

        }
        field(108; "Written Interview Venue"; Text[250])
        {

        }
        field(109; "Oral Interview Venue"; Text[250])
        {

        }
        field(110; "Job Application URL"; Text[250])
        {
            Editable = false;
        }
        field(111; "Unshortlisted Emailed"; Boolean)
        {
            Editable = false;
        }
        field(112; "Unshortlisted Emailed On"; DateTime)
        {
            Editable = false;
        }
        field(113; "Shortlisted Emailed"; Boolean)
        {
            Editable = false;
        }
        field(114; "Shortlisted Emailed On"; DateTime)
        {
            Editable = false;
        }
        field(115; "First Interview Emailed"; Boolean)
        {
            Editable = false;
            Caption = 'Written Interview Emailed';
        }
        field(116; "First Interview Emailed On"; DateTime)
        {
            Editable = false;
            Caption = 'Written Interview Invite Time';
        }
        field(117; "Second Interview Inv Emailed"; Boolean)
        {
            Editable = false;
            Caption = 'Oral Interview Invite Sent';
        }
        field(118; "Sec. Interview Inv Emailed On"; DateTime)
        {
            Editable = false;
            Caption = 'Oral Interview Invite Time';
        }
        field(119; "Regret Emailed"; Boolean)
        {
            Editable = false;
        }
        field(120; "Regret Emailed On"; DateTime)
        {
            Editable = false;
        }
        field(121; "Success Emailed"; Boolean)
        {
            Editable = false;
        }
        field(122; "Success Emailed On"; DateTime)
        {
            Editable = false;
        }
        field(123; "Reopening DateTime"; DateTime)
        {
            Editable = false;
        }
        field(124; "Reopened By"; Code[200])
        {
            Editable = false;
        }
        field(125; Location; Code[50])
        {
            TableRelation = "Country/Region";
        }
        field(126; "Screening Passmark (%)"; Decimal)
        {
            trigger OnValidate()
            begin
                if ("Screening Passmark (%)" < 0) or ("Screening Passmark (%)" > 100) then
                    Error('Screening Passmark is a percentage. It must lie between 0 and 100');
            end;
        }
        field(127; Advertise; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                JobScreeningQuestions: Record "Job Screening Questions";
                JobScreeningAnswers: Record "Job Screening Answers";
            begin
                /*if Advertise then begin
                    if "Screening Passmark (%)" = 0 then begin
                        if not confirm('Screening passmark is currently 0. Every candidate will be shortlisted. Is that your wish? If not then click No and set a passmark before advertising this vacancy') then Error('Kindly set the screening passmark before advertising this vacancy.');
                    end;

                    JobScreeningQuestions.Reset();
                    JobScreeningQuestions.SetRange("Job No.", "No.");
                    JobScreeningQuestions.SetFilter(Description, '<>%1', '');
                    if JobScreeningQuestions.FindSet() then begin
                        repeat
                            if JobScreeningQuestions."Display Order No." = 0 then
                                Error('Set the display order for all questions starting from 1!. Check question no. %1', JobScreeningQuestions."Question Entry No.");
                            if JobScreeningQuestions.Weight = 0 then
                                Error('Set the weight for each question (it cannot be 0)! Check question no. %1', JobScreeningQuestions."Question Entry No.");
                            if (JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::Numeric) and (JobScreeningQuestions."Numeric Answer" = 0) then
                                Error('You must set numeric answers for all Numeric questions. Check question no. %1', JobScreeningQuestions."Question Entry No.");
                            if (JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::Text) and (JobScreeningQuestions."Text Answer" = '') then
                                Error('You must set text answers for all Text questions. Check question no. %1', JobScreeningQuestions."Question Entry No.");
                            if (JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::Range) and (JobScreeningQuestions."Range Answer Start" = JobScreeningQuestions."Range Answer End") then
                                Error('For Range questions, the start and end values cannot be the same. Check question no. %1', JobScreeningQuestions."Question Entry No.");
                            if (JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::"Multiple Choice") then begin
                                JobScreeningAnswers.Reset();
                                JobScreeningAnswers.SetRange("Job No.", "No.");
                                JobScreeningAnswers.SetRange("Question Entry No.", JobScreeningQuestions."Question Entry No.");
                                JobScreeningAnswers.SetFilter(Answer, '<>%1', '');
                                JobScreeningAnswers.SetRange("Is Correct", true);
                                if not JobScreeningAnswers.FindFirst() then
                                    Error('You must set answers for all multiple choice questions and then tick at least one of the answers as "Is Correct". Check question no. %1', JobScreeningQuestions."Question Entry No.");
                            end;
                        until JobScreeningQuestions.Next() = 0;
                    end else
                        Error('You must set at least one (1) screening question for this job before advertising. Things like expected experience in years, minimum academic qualifications, among others.');
                end;*/
            end;
        }
        field(128; "Screening Processed"; Boolean)
        { }
        field(129; "Written Interview Duration"; Decimal)
        { }
        field(130; "Written Required Documents"; Text[250])
        { }
        field(131; "Written Required Materials"; Text[250])
        { }
        field(132; "Oral Interview Duration"; Decimal)
        { }
        field(133; "Oral Required Documents"; Text[250])
        { }
        field(134; "Oral Required Materials"; Text[250])
        { }
        field(135; "Oral Interview Dress Code"; Text[250])
        { }
        field(136; "JD SharePoint File ID"; Text[100])
        {
            Caption = 'JD SharePoint File ID';
            Editable = false;
        }

        field(137; "JD Web Url"; Text[1024])
        {
            Caption = 'JD Web URL';
            ExtendedDatatype = URL;
            Editable = false;
        }
        field(138; "JD Mime Type"; Text[100])
        {
            Caption = 'JD Mime Type';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Recruitment Needs Nos.");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Recruitment Needs Nos.");
        end;
        Date := Today;
        if "Requested By" = '' then //In case it's created from portal
            "Requested By" := UserId;
        DateTimeAdded := CurrentDateTime;

        //If another open entry exists, finish and send it for approval first
        RecruitmentNeeds.Reset();
        RecruitmentNeeds.SetRange("Requested By", "Requested By");
        RecruitmentNeeds.SetRange(Status, RecruitmentNeeds.Status::Open);
        RecruitmentNeeds.SetFilter("No.", '<>%1', "No.");
        if RecruitmentNeeds.FindFirst() then begin
            Error('Kindly finish working on request number %1 and send it for approval before creating another!', RecruitmentNeeds."No.");
        end;
    end;

    trigger OnDelete()
    var
        UserSetup: Record "User Setup";
    begin
        if Status <> Status::Open then
            Error('You can only delete when the approval status is Open!');

        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange("Can Delete Recruitment Needs", true);
        if not UserSetup.FindFirst() then begin
            if "Requested By" <> UserId then
                Error('You can only delete records created by you. If you need to delete other people''s records kindly contact IT!');
        end;

        JobApplicationsTable.Reset();
        JobApplicationsTable.SetRange("Recruitment Need Code", "No.");
        if JobApplicationsTable.Find('-') then
            Error('You cannot delete this record. It has applications!');

        DeleteChildren();
    end;

    var
        Jobs: Record "Company Jobs";
        App: Record Applicants;
        //RShort: Record "R. Shortlisting Criteria";
        DimMgt: Codeunit DimensionManagement;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        JobApplicationsTable: Record "Job Applications";
        NeedsRequirements: Record "Needs Requirement";
        JobRequirements: Record "Job Requirement";
        Employee: Record Employee;
        ResponsibilityCenter: Record "Responsibility Center";
        JobRequirementNeed: Record "Job Professional Need";
        JobResponsibilities: Record "Job Responsiblities";
        MandatoryDocs: Record "Recruitment Mandatory Docs";
        RecruitmentNeedSkills: Record "Recruitment Needs Skills";
        RecruitmentNeeds: Record "Recruitment Needs";

    procedure DeleteChildren()
    begin
        NeedsRequirements.Reset();
        NeedsRequirements.SetRange("Need Id", "No.");
        if NeedsRequirements.Find('-') then
            NeedsRequirements.DeleteAll();

        JobRequirementNeed.Reset();
        JobRequirementNeed.SetRange("Need Id", "No.");
        if JobRequirementNeed.Find('-') then
            JobRequirementNeed.DeleteAll();

        JobResponsibilities.Reset();
        JobResponsibilities.SetRange("Need Id", "No.");
        if JobResponsibilities.Find('-') then
            JobResponsibilities.DeleteAll();

        MandatoryDocs.Reset();
        MandatoryDocs.SetRange("Recruitment Need Code", "No.");
        if MandatoryDocs.Find('-') then
            MandatoryDocs.DeleteAll();

        RecruitmentNeedSkills.Reset();
        RecruitmentNeedSkills.SetRange("Recruitment Need Code", "No.");
        if RecruitmentNeedSkills.Find('-') then
            RecruitmentNeedSkills.DeleteAll();
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        //DimMgt.SaveDefaultDim(DATABASE::"Recruitment Needs","No.",FieldNumber,ShortcutDimCode);
        Rec.Modify;
    end;

    local procedure fnPopulateNeedsRequirements()
    begin
    end;

    procedure FnCheckIfJobClosed()
    begin
        if "End Date" < Today then
            Closed := true
        else
            Closed := false;
    end;
}