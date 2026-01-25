table 51525307 "Job Applications"
{
    fields
    {
        field(1; ApplicationNo; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Job Applied For"; Code[20])
        {
            Editable = false;
        }
        field(3; "Recruitment Need Code"; Code[20])
        {
            TableRelation = "Recruitment Needs"."No.";
            Editable = true;

            trigger OnValidate()
            var
                LastApplicationForThisJob: Record "Job Applications";
            begin
                Needs.Reset;
                Needs.SetRange(Needs."No.", "Recruitment Need Code");
                if Needs.Find('-') then begin
                    "Job Applied For" := Needs."Job ID";
                    JobDescription := Needs.Description;
                end;

                "Serial No." := 1;
                if "Recruitment Need Code" <> '' then begin
                    LastApplicationForThisJob.Reset();
                    LastApplicationForThisJob.SetRange("Recruitment Need Code", "Recruitment Need Code");
                    LastApplicationForThisJob.SetFilter(ApplicationNo, '<>%1', ApplicationNo);
                    if LastApplicationForThisJob.FindLast() then
                        "Serial No." := LastApplicationForThisJob."Serial No." + 1;
                end;
                fetchAdvertScreeningQuestions();
            end;
        }
        field(4; "Total Score Shorlisting"; Decimal)
        {
            CalcFormula = Sum("HR Questionnare Response"."Marks Scored" WHERE(Applicant = FIELD(ApplicationNo)));
            FieldClass = FlowField;
        }
        field(5; Shortlist; Boolean)
        {
            Caption = 'Shortlisted';
            trigger OnValidate()
            begin
                Shortlisted := Shortlist;
                "Not Shortlisted" := not Shortlist;
            end;
        }
        field(6; Stage; Option)
        {
            OptionCaption = ',Submitted,Applying,Shortlisting,First Interview,Due Diligence,Second Interview,Succeeded,Failed,Completed';
            OptionMembers = ,Submitted,"Applying",Shortlisting,"First Interview","Due Diligence","Second Interview",Succeeded,Failed,Completed;
            Editable = false;
        }
        field(7; "Application Date"; Date)
        {
        }
        field(8; JobDescription; Text[200])
        {
            Caption = 'Job Title';
            Editable = false;
        }
        field(9; NoSeries; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; ApplicantID; Code[20])
        {
            Caption = 'Applicant ID';
            FieldClass = Normal;
            TableRelation = "HR Online Applicant";//"Job Applicants";
            Editable = false;

            trigger OnValidate()
            begin
                TestField("Recruitment Need Code");
                Applicants.Reset;
                Applicants.SetRange(Applicants."No.", ApplicantID);
                if Applicants.Find('-') then begin
                    ApplicantName := Applicants."First Name" + ' ' + Applicants."Middle Name" + ' ' + Applicants."Last Name";
                    "Birth Date" := Applicants."Date Of Birth";
                    "ID No./Passport No." := Applicants."ID Number";
                    "Applicant Email" := Applicants."Email Address";//."E-Mail";
                    Gender := Applicants.Gender;
                    "Ethnic Origin" := Applicants."Ethnic Origin";
                    "Marital Status" := Applicants."Marital Status";
                    if Applicants.Disabled = Applicants.Disabled::Yes then begin
                        Disabled := true;
                    end;

                    //Country:=Applicants.cou
                    fnFetchAndPopulateQualifications(Rec);
                    fnFetchAndPopulateExperience(Rec);
                    fnFetchAndPopulateReferees(Rec);
                    fnFetchAndPopulateDocs(Rec);
                    fnFetchAndPopulateCommentsNViews(Rec);

                end;
            end;
        }
        field(11; CurrentSalary; Decimal)
        {
            Caption = 'Current Salary';
        }
        field(12; ApplicantName; Text[150])
        {
            Caption = 'Applicant Name';
            Editable = false;
        }
        field(13; Submitted; Boolean)
        {
        }
        field(14; Certification; Boolean)
        {
        }
        field(15; "Birth Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Age:=Dates.DetermineAge("Date Of Birth",TODAY);
                //MODIFY;
            end;
        }
        field(16; "ID No./Passport No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Degree; Boolean)
        {
        }
        field(26; Masters; Boolean)
        {
        }
        field(32; "Years of Experince"; Integer)
        {
            Caption = 'Years of Experience';
            Editable = false;
        }
        field(33; "Passed Short Listing"; Boolean)
        {
        }
        field(34; "Cert Passed"; Boolean)
        {
        }
        field(35; "Degree Passed"; Boolean)
        {
        }
        field(36; "Masters Passed"; Boolean)
        {
        }
        field(37; "PHD Passed"; Boolean)
        {
        }
        field(38; "Experience Passed"; Boolean)
        {
        }
        field(39; "Employee Type"; Option)
        {
            OptionMembers = ,Normal,Contract;
        }
        field(40; "Passed Aptitude"; Boolean)
        {
        }
        field(41; "Passed Oral Interview"; Boolean)
        {
        }
        field(42; "Offer Letter of Appointment"; Boolean)
        {
        }
        field(43; "Appointment Letter"; Text[250])
        {
        }
        field(44; "Offer Letter Accepted"; Boolean)
        {
        }
        field(45; "Employee No"; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(46; "Applicant Email"; Text[150])
        {
            TableRelation = "HR Online Applicant";//"Job Applicants";
            Editable = true;

            trigger OnValidate()
            begin
                TestField("Recruitment Need Code");
                Applicants.Reset;
                Applicants.SetRange(Applicants."Email Address", "Applicant Email");
                if Applicants.Find('-') then begin
                    ApplicantName := Applicants."First Name" + ' ' + Applicants."Middle Name" + ' ' + Applicants."Last Name";
                    "Birth Date" := Applicants."Date Of Birth";
                    "ID No./Passport No." := Applicants."ID Number";
                    ApplicantID := Applicants."No.";
                    Gender := Applicants.Gender;
                    "Ethnic Origin" := Applicants."Ethnic Origin";
                    "Marital Status" := Applicants."Marital Status";
                    if Applicants.Disabled = Applicants.Disabled::Yes then begin
                        Disabled := true;
                    end;
                    if Applicants."No." = '' then begin
                        Applicants.Validate("No.");
                        ApplicantID := Applicants."No.";
                        Applicants.Modify();
                    end;

                    //Country:=Applicants.cou
                    fnFetchAndPopulateQualifications(Rec);
                    fnFetchAndPopulateExperience(Rec);
                    fnFetchAndPopulateReferees(Rec);
                    fnFetchAndPopulateDocs(Rec);
                    fnFetchAndPopulateCommentsNViews(Rec);

                end;
            end;
        }
        field(47; "No. Series"; Code[20])
        {
        }
        field(48; "Total Score Oral  Interview"; Decimal)
        {
        }
        field(49; "Qualification Score"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50; "Total Technical Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Invited Oral"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "invited Technical"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Shortlisting Stage"; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Recruitment Stages1"."Recruitement Stage";
        }
        field(54; "Passed Stage"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Residential Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Postal Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(57; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Male,Female';
            OptionMembers = ,Male,Female;
        }
        field(58; Country; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(59; "County Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = County.Code;

            trigger OnValidate()
            var
                County: Record County;
            begin
                County.Reset;
                County.SetRange(County.Code, "County Code");
                if County.FindFirst then begin
                    "County Name" := County.Name;
                end;
            end;
        }
        field(60; "County Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Sub-County Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(62; "Sub-County Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(63; "Ethnic Origin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ethnic Groups";
        }
        field(64; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(65; Religion; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(66; "Home Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(67; "Cellular Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(68; "Work Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(69; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(70; "Person Living With Disability"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',No,Yes';
            OptionMembers = ,No,Yes;
        }
        field(71; "Know Any current Employee"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',No,Yes';
            OptionMembers = ,No,Yes;
        }
        field(72; "Have Any Relative in Org."; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',No,Yes';
            OptionMembers = ,No,Yes;
        }
        field(73; "Name of Employee"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(74; "Name of Relative"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(75; "Expected Gross Salary"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(76; "Not Qualified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(77; "First Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(78; "Middle Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(79; "Last Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(80; Citizenship; Code[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(81; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Submitted,Shortlisted,Passed First Interview,Failed First Interview,Passed Due Diligence,Failed Due Diligence,Passed Second Interview,Failed Second Interview,Successful,Unsuccessful,Not Listed,Completed';
            OptionMembers = ,Submitted,Shortlisted,"Passed First Interview","Failed First Interview","Passed Due Diligence","Failed Due Diligence","Passed Second Interview","Failed Second Interview",Successful,Unsuccessful,"Not Listed",Completed;
            Editable = false;
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
        field(86; "Tax Compliance Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(87; Disabled; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(88; "Manually Shortlisted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(89; "Shortlisted By"; Code[60])
        {
            DataClassification = ToBeClassified;
        }
        field(90; "Current Gross Salary"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(91; "Notice Period"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(92; "Applicant Total Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(93; "Passed Interview"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(94; "Experience Years"; Decimal)
        {
            CalcFormula = Sum("Job App Work Experience"."Experience Period" WHERE("Applicant No." = FIELD(ApplicationNo)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(95; "Average Score Oral"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(96; "County of Work"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = County.Code;
        }
        field(97; "Required Attachments Present"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(98; "YOE Passed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99; "Required Proff Docs Present"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(100; "Minimum Academic Level Meet"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(101; "Passed Automatic Shorlisting"; Boolean)
        {
            Caption = 'Passed Shortlisting';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(102; Shortlisted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(103; "Passed First Interview"; Boolean)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger OnValidate()
            begin
                "Failed First Interview" := not "Passed First Interview";
            end;
        }
        field(104; "Passed Due Diligence"; Boolean)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger OnValidate()
            begin
                "Failed Due Diligence" := not "Passed Due Diligence";
            end;
        }
        field(105; "Passed Second Interview"; Boolean)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger OnValidate()
            begin
                "Failed Second Interview" := not "Passed Second Interview";
            end;
        }
        field(106; Successful; Boolean)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            trigger OnValidate()
            begin
                Unsuccessful := not Successful;
            end;
        }
        field(107; "Unshortlisted Emailed"; Boolean)
        {
            Editable = false;
        }
        field(108; "Shortlisted Emailed"; Boolean)
        {
            Editable = false;
        }
        field(109; "Written Interview Emailed"; Boolean)
        {
            Editable = false;
        }
        field(110; "Oral Interview Invite Emailed"; Boolean)
        {
            Editable = false;
        }
        field(111; "Regret Emailed"; Boolean)
        {
            Editable = false;
        }
        field(112; "Success Emailed"; Boolean)
        {
            Editable = false;
        }
        field(113; Onboarded; Boolean)
        {
            Editable = false;
        }
        field(114; "Not Shortlisted"; Boolean)
        {
            trigger OnValidate()
            begin
                Shortlist := not "Not Shortlisted";
            end;
        }
        field(115; "Failed First Interview"; Boolean)
        {
            trigger OnValidate()
            begin
                "Passed First Interview" := not "Failed First Interview";
            end;
        }
        field(116; "Failed Due Diligence"; Boolean)
        {
            trigger OnValidate()
            begin
                "Passed Due Diligence" := not "Failed Due Diligence";
            end;
        }
        field(117; "Failed Second Interview"; Boolean)
        {
            trigger OnValidate()
            begin
                "Passed Second Interview" := not "Failed Second Interview";
            end;
        }
        field(118; "Shortlisting Comments"; Text[240])
        {
        }
        field(119; "First Interview Comments"; Text[240])
        {
        }
        field(120; "Due Diligence Comments"; Text[240])
        {
        }
        field(121; "Second Interview Comments"; Text[240])
        {
        }
        field(122; "Mobile No."; Code[30])
        {
            Caption = 'Phone Number';
            DataClassification = ToBeClassified;
        }
        field(123; Unsuccessful; Boolean)
        {
            trigger OnValidate()
            begin
                Successful := not Unsuccessful;
            end;
        }
        field(124; "Final Comments"; Text[240])
        {
        }
        field(125; "Requisition Type"; Option)
        {
            CalcFormula = Lookup("Recruitment Needs"."Requisition Type" WHERE("No." = FIELD("Recruitment Need Code")));
            OptionCaption = 'Open,Internal,External';
            OptionMembers = Open,Internal,External;

            FieldClass = FlowField;
        }
        field(126; "Serial No."; Integer)
        {
            Caption = '#';
            Editable = false;
        }
        field(127; "Talent Pool"; Code[250])
        {
            TableRelation = "Talent Pools".Code;

            trigger OnValidate()
            var
                CandidateTalentPools: Record "Candidate Talent Pools";
                CandidateTalentPools2: Record "Candidate Talent Pools";
                CandidateTalentPoolInit: Record "Candidate Talent Pools";
            begin
                if "Talent Pool" <> '' then begin
                    CandidateTalentPools.Reset();
                    CandidateTalentPools.SetRange("Pool Code", "Talent Pool");
                    CandidateTalentPools.SetRange("Application No.", ApplicationNo);
                    if not CandidateTalentPools.FindFirst() then begin
                        CandidateTalentPools2.Reset();
                        CandidateTalentPools2.SetRange("Pool Code", "Talent Pool");
                        CandidateTalentPools2.SetRange("Candidate Email", "Applicant Email"); //Rem candidate ID is the PK
                        if CandidateTalentPools2.FindFirst() then begin
                            if CandidateTalentPools2."Application No." = '' then begin
                                CandidateTalentPools2."Application No." := ApplicationNo;
                                CandidateTalentPools2.Modify();
                            end;
                        end else begin
                            CandidateTalentPoolInit.Reset();
                            CandidateTalentPoolInit.Init();
                            CandidateTalentPoolInit."Pool Code" := "Talent Pool";
                            CandidateTalentPoolInit.Validate("Pool Code");
                            CandidateTalentPoolInit."Candidate Email" := "Applicant Email";
                            CandidateTalentPoolInit.Validate("Candidate Email");
                            CandidateTalentPoolInit."Application No." := ApplicationNo;
                            CandidateTalentPoolInit.Insert();
                        end;
                    end;
                end;
            end;
        }
        field(128; "Screening Score (%)"; Decimal)
        {
            Editable = false;
        }
        field(129; "Screening Passmark (%)"; Decimal)
        {
            Editable = false;
        }
        field(130; "Screening Outcome"; Option)
        {
            OptionMembers = Pending,Fail,Pass;
            Editable = false;
        }
        field(131; "Change Request No."; Code[20])
        {
            TableRelation = "Change Request"."No.";
        }
    }

    keys
    {
        key(Key1; ApplicationNo)
        {
            Clustered = true;
        }
        key(Key2; "Recruitment Need Code", ApplicantID)
        {
        }
        key(Key3; "Serial No.")
        { }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if ApplicationNo = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Job Application No");
            ApplicationNo := NoSeriesMgt.GetNextNo(HumanResSetup."Job Application No");
        end;
    end;

    var
        Needs: Record "Recruitment Needs";
        Applicants: Record "HR Online Applicant";//"Job Applicants";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        JobAppQua: Record "Job Application Qualification";
        JobAppW: Record "Job App Work Experience";
        JobAppRef: Record "Job Application Referees";
        JobAppDocs: Record "Job App Documents";
        JobAppComm: Record "Job App Comments/Views";
        AppWork: Record "Applicant Work Experience";
        Dates: Codeunit "HR Dates";

    local procedure fnFetchAndPopulateQualifications(varJobApp: Record "Job Applications")
    var
        objJobAppQua: Record "Job Application Qualification";
        objAppWork: Record "Applicant Qualification";
    begin
        objAppWork.Reset;
        objAppWork.SetRange(objAppWork."Applicant No.", varJobApp.ApplicantID);
        if objAppWork.FindSet(true) then begin
            repeat
                objJobAppQua.Init;
                objJobAppQua."Job App ID" := varJobApp.ApplicationNo;
                objJobAppQua."Applicant No." := varJobApp.ApplicantID;
                objJobAppQua."Job Need Id" := varJobApp."Recruitment Need Code";
                objJobAppQua."Qualification Code" := objAppWork."Qualification Code";
                objJobAppQua."From Date" := objAppWork."From Date";
                objJobAppQua."To Date" := objAppWork."To Date";
                objJobAppQua.Type := objJobAppQua.Type;
                objJobAppQua."Institution/Company" := objAppWork."Institution/Company";
                objJobAppQua.Cost := objAppWork.Cost;
                objJobAppQua."Course Grade" := objAppWork."Course Grade";
                objJobAppQua."Score Id" := objAppWork."Score Id";
                objJobAppQua.Description := objAppWork.Description;
                objJobAppQua."Education Level Id" := objAppWork."Education Level Id";
                objJobAppQua."Education Level Name" := objAppWork."Education Level Name";
                objJobAppQua."Course Id" := objAppWork."Course Id";
                objJobAppQua."Course Name" := objAppWork."Course Name";
                objJobAppQua."Grade Id" := objAppWork."Grade Id";
                objJobAppQua."Grade Name" := objAppWork."Grade Name";
                objJobAppQua.Insert;
            until objAppWork.Next = 0;
        end;
    end;

    local procedure fnFetchAndPopulateExperience(varJobApp: Record "Job Applications")
    var
        objJobAppExp: Record "Job App Work Experience";
        objAppWork: Record "Applicant Work Experience";
    begin
        objAppWork.Reset;
        objAppWork.SetRange(objAppWork."Applicant No.", varJobApp.ApplicantID);
        if objAppWork.FindSet(true) then begin
            repeat
                objJobAppExp.Init;
                objJobAppExp."Job App ID" := varJobApp.ApplicationNo;
                objJobAppExp."Applicant No." := varJobApp.ApplicantID;
                objJobAppExp."From Date" := objAppWork."From Date";
                objJobAppExp."To Date" := objAppWork."To Date";
                objJobAppExp.Responsibility := objAppWork.Responsibility;
                objJobAppExp."Institution/Company" := objAppWork."Institution/Company";
                objJobAppExp."Position Code" := objAppWork."Position Code";
                objJobAppExp."Experience No" := objAppWork."Experience No";
                objJobAppExp.Salary := objAppWork."Gross Salary";
                objJobAppExp."Position Description" := objAppWork."Position Description";
                objJobAppExp.Insert;
            until objAppWork.Next = 0;
        end;
    end;

    local procedure fnFetchAndPopulateReferees(varJobApp: Record "Job Applications")
    var
        objJobAppRef: Record "Job Application Referees";
        objAppRef: Record "Applicant Referees";
    begin
        objAppRef.Reset;
        objAppRef.SetRange(objAppRef.No, varJobApp.ApplicantID);
        if objAppRef.FindSet(true) then begin
            repeat
                objJobAppRef.Init;
                objJobAppRef."Job App ID" := varJobApp.ApplicationNo;
                objJobAppRef.No := varJobApp.ApplicantID;

                objJobAppRef.Names := objAppRef.Names;
                objJobAppRef.Designation := objAppRef.Designation;
                objJobAppRef.Company := objAppRef.Company;
                objJobAppRef.Address := objAppRef."Postal Address";
                objJobAppRef."Line No" := objJobAppRef."Line No" + 1;
                objJobAppRef."Telephone No" := objAppRef."Mobile No";
                objJobAppRef."E-Mail" := objAppRef."Applicant Email";
                objJobAppRef.Notes := objAppRef.Notes;
                objJobAppRef.Insert;
            until objAppRef.Next = 0;
        end;
    end;

    local procedure fnFetchAndPopulateDocs(varJobApp: Record "Job Applications")
    var
        objJobAppDocs: Record "Job App Documents";
        objAppDocs: Record "Applicant Documents";
        lineno: Integer;
    begin
        lineno := 0;
        objAppDocs.Reset;
        objAppDocs.SetRange(objAppDocs."Applicant No", varJobApp.ApplicantID);
        if objAppDocs.Find('-') then begin
            repeat
                objJobAppDocs.Init;
                lineno := lineno + 1;
                // MESSAGE('Line No. %1',lineno);
                objJobAppDocs."Job App ID" := varJobApp.ApplicationNo;
                objJobAppDocs."Applicant No" := varJobApp.ApplicantID;
                objJobAppDocs."Document Description" := objAppDocs."Document Description";
                objJobAppDocs."Document Link" := objAppDocs."Document Link";
                objJobAppDocs."Line No." := lineno;
                objJobAppDocs.Attached := objAppDocs.Attached;
                objJobAppDocs.Insert;

            until objAppDocs.Next = 0;
        end;
    end;

    local procedure fnFetchAndPopulateCommentsNViews(varJobApp: Record "Job Applications")
    var
        objJobAppComms: Record "Job App Comments/Views";
        objAppComms: Record "Applicant Comments/Views";
        lineno: Integer;
    begin
        lineno := 0;
        objAppComms.Reset;
        objAppComms.SetRange(objAppComms."Applicant No", varJobApp.ApplicantID);
        if objAppComms.Find('-') then begin
            repeat
                lineno := lineno + 1;
                objJobAppComms.Init;
                objJobAppComms."Job App ID" := varJobApp.ApplicationNo;
                objJobAppComms."Applicant No" := varJobApp.ApplicantID;
                objJobAppComms.Date := objAppComms.Date;
                objJobAppComms."Line No." := lineno;
                objJobAppComms."Views/Comments" := objAppComms."Views/Comments";
                objJobAppComms.Insert;
            until objAppComms.Next = 0;
        end;
    end;

    procedure PortalStatus() Stat: Text
    var
        JobApp: Record "Job Applications";
    begin
        //statOptionMembers = ,Submitted,Shortlisted,"Passed First Interview","Failed First Interview","Passed Due Diligence","Failed Due Diligence","Passed Second Interview","Failed Second Interview",Successful,Unsuccessful,"Not Listed",Completed;
        //stage OptionMembers = ,Submitted,"Applying",Shortlisting,"First Interview","Due Diligence","Second Interview",Succeeded,Failed,Completed;
        Stat := 'Open';
        Needs.Reset();
        Needs.SetRange("No.", "Recruitment Need Code");
        if Needs.FindFirst() then begin
            if ((Needs."Current Stage" = Needs."Current Stage"::"Pending Applications") or (Needs."Current Stage" = Needs."Current Stage"::"Receiving Applications")) and (Submitted) then
                if Stage <> Stage::Applying then
                    Stage := Stage::Applying;
            if Status <> Status::Submitted then
                Status := Status::Submitted;
            Stat := 'Submitted';
            if (Needs."Current Stage" = Needs."Current Stage"::Shortlisting) then begin
                if Submitted then
                    Stat := 'Submitted';

                if Stage <> Stage::Shortlisting then
                    Stage := Stage::Shortlisting;
                if Submitted then
                    Status := Status::Submitted;
            end;

            if (Needs."Current Stage" = Needs."Current Stage"::"First Interview") then begin
                if Shortlist then
                    Stat := 'Shortlisted';
                if (not Shortlist) or ("Not Shortlisted") then begin
                    Stat := 'Not Shortlisted';
                    if "Talent Pool" <> '' then
                        Stat := 'Processing'; //Can be considered for another position.
                end;

                if Stage <> Stage::"First Interview" then
                    Stage := Stage::"First Interview";
                if (Stat = 'Shortlisted') and (Status <> Status::Shortlisted) then
                    Status := Status::Shortlisted;
                if (Stat = 'Not Shortlisted') and (Status <> Status::"Not Listed") then
                    Status := Status::"Not Listed";
            end;

            if (Needs."Current Stage" = Needs."Current Stage"::"Due Diligence") then begin
                if "Passed First Interview" then
                    Stat := 'Passed First Interview';
                if (not "Passed First Interview") or ("Failed First Interview") then begin
                    Stat := 'Failed First Interview';
                    if "Talent Pool" <> '' then
                        Stat := 'Processing'; //Can be considered for another position.
                end;


                if Stage <> Stage::"Due Diligence" then
                    Stage := Stage::"Due Diligence";
                if (Stat = 'Passed First Interview') and (Status <> Status::"Passed First Interview") then
                    Status := Status::"Passed First Interview";
                if (Stat = 'Failed First Interview') and (Status <> Status::"Failed First Interview") then
                    Status := Status::"Failed First Interview";

                if Needs."Applicable Interview(s)" = Needs."Applicable Interview(s)"::Oral then begin //Had no first interview
                    if Shortlist then
                        Stat := 'Shortlisted';
                    if (not Shortlist) or ("Not Shortlisted") then begin
                        Stat := 'Not Shortlisted';
                        if "Talent Pool" <> '' then
                            Stat := 'Processing'; //Can be considered for another position.
                    end;

                    if Stage <> Stage::"Due Diligence" then
                        Stage := Stage::"Due Diligence";
                    if (Stat = 'Shortlisted') and (Status <> Status::Shortlisted) then
                        Status := Status::Shortlisted;
                    if (Stat = 'Not Shortlisted') and (Status <> Status::"Not Listed") then
                        Status := Status::"Not Listed";
                end;
            end;

            if (Needs."Current Stage" = Needs."Current Stage"::"Second Interview") then begin
                if "Passed Due Diligence" then
                    Stat := 'Passed Due Diligence';
                if (not "Passed Due Diligence") or ("Failed Due Diligence") then begin
                    Stat := 'Failed Due Diligence';
                    if "Talent Pool" <> '' then
                        Stat := 'Processing'; //Can be considered for another position.
                end;

                if Stage <> Stage::"Second Interview" then
                    Stage := Stage::"Second Interview";
                if (Stat = 'Passed Due Diligence') and (Status <> Status::"Passed Due Diligence") then
                    Status := Status::"Passed Due Diligence";
                if (Stat = 'Failed Due Diligence') and (Status <> Status::"Failed Due Diligence") then
                    Status := Status::"Failed Due Diligence";
            end;

            if (Needs."Current Stage" = Needs."Current Stage"::Completed) then begin
                if "Passed Second Interview" then
                    Stat := 'Passed Second Interview';
                if (not "Passed Second Interview") or ("Failed Second Interview") then begin
                    Stat := 'Failed Second Interview';
                    if "Talent Pool" <> '' then
                        Stat := 'Processing'; //Can be considered for another position.
                end;

                if Stage <> Stage::Completed then
                    Stage := Stage::Completed;
                if (Stat = 'Passed Second Interview') and (Status <> Status::"Passed Second Interview") then
                    Status := Status::"Passed Second Interview";
                if (Stat = 'Failed Second Interview') and (Status <> Status::"Failed Second Interview") then begin
                    Status := Status::"Failed Second Interview";
                    if "Talent Pool" <> '' then
                        Stat := 'Processing'; //Can be considered for another position.
                end;

                if Successful then
                    Stat := 'Successful';
                if /*(not Successful) or*/ (Unsuccessful) then begin
                    Stat := 'Unsuccessful';
                    if "Talent Pool" <> '' then
                        Stat := 'Processing'; //Can be considered for another position.
                end;

                if (Successful) and (Status <> Status::Successful) then
                    Status := Status::Successful;
                if (Unsuccessful) and (Status <> Status::Unsuccessful) then
                    Status := Status::Unsuccessful;
            end;
        end;
    end;

    procedure fetchAdvertScreeningQuestions()
    var
        JobScreeningQuestions: Record "Job Screening Questions";
        JobScreeningAnswers: Record "Job Screening Answers";
        ApplicationResponses: Record "Application Screening Response";
        ApplicationResponseInit: Record "Application Screening Response";
        ApplicationMultiChoiceAnswers: Record "Application Multichoice Answer";
        ApplicationMultiChoiceAnswerInit: Record "Application Multichoice Answer";
    begin
        if (ApplicationNo <> '') and ("Recruitment Need Code" <> '') then begin
            ApplicationResponses.Reset();
            ApplicationResponses.SetRange("Application No.", ApplicationNo);
            ApplicationResponses.SetRange("Recruitment Need No.", "Recruitment Need Code");
            if not ApplicationResponses.FindFirst() then begin
                JobScreeningQuestions.Reset();
                JobScreeningQuestions.SetRange("Job No.", "Recruitment Need Code");
                if JobScreeningQuestions.FindSet() then
                    repeat
                        ApplicationResponseInit.Init();
                        ApplicationResponseInit."Application No." := ApplicationNo;
                        ApplicationResponseInit."Recruitment Need No." := "Recruitment Need Code";
                        ApplicationResponseInit."Question No." := JobScreeningQuestions."Question Entry No.";
                        ApplicationResponseInit."Applicant Email" := "Applicant Email";
                        ApplicationResponseInit.Description := JobScreeningQuestions.Description;
                        ApplicationResponseInit."Response Type" := JobScreeningQuestions."Response Type";
                        ApplicationResponseInit."Numeric Answer Filters" := JobScreeningQuestions."Numeric Answer Filter";
                        if JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::"Yes/No" then
                            ApplicationResponseInit."Expected Answer" := format(JobScreeningQuestions."YesNo Answer");
                        if JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::Numeric then
                            ApplicationResponseInit."Expected Answer" := Format(JobScreeningQuestions."Numeric Answer");
                        if JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::Text then
                            ApplicationResponseInit."Expected Answer" := JobScreeningQuestions."Text Answer";
                        if JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::Range then
                            ApplicationResponseInit."Expected Answer" := format(JobScreeningQuestions."Range Answer Start") + '..' + Format(JobScreeningQuestions."Range Answer End");
                        ApplicationResponseInit."Display Order No." := JobScreeningQuestions."Display Order No.";
                        ApplicationResponseInit."Provided Answer" := '';
                        ApplicationResponseInit.Score := 0;
                        ApplicationResponseInit.Insert();

                        if JobScreeningQuestions."Response Type" = JobScreeningQuestions."Response Type"::"Multiple Choice" then begin
                            ApplicationMultiChoiceAnswers.Reset();
                            ApplicationMultiChoiceAnswers.SetRange("Application No.", ApplicationNo);
                            ApplicationMultiChoiceAnswers.SetRange("Question Entry No.", JobScreeningQuestions."Question Entry No.");
                            if ApplicationMultiChoiceAnswers.Find('-') then
                                ApplicationMultiChoiceAnswers.DeleteAll();

                            JobScreeningAnswers.Reset();
                            JobScreeningAnswers.SetRange("Job No.", "Recruitment Need Code");
                            JobScreeningAnswers.SetRange("Question Entry No.", JobScreeningQuestions."Question Entry No.");
                            if JobScreeningAnswers.FindSet() then
                                repeat
                                    ApplicationMultiChoiceAnswerInit.Init();
                                    ApplicationMultiChoiceAnswerInit."Application No." := ApplicationNo;
                                    ApplicationMultiChoiceAnswerInit."Question Entry No." := JobScreeningAnswers."Question Entry No.";
                                    ApplicationMultiChoiceAnswerInit."Entry No." := JobScreeningAnswers."Entry No.";
                                    ApplicationMultiChoiceAnswerInit.Answer := JobScreeningAnswers.Answer;
                                    ApplicationMultiChoiceAnswerInit."Is Correct" := JobScreeningAnswers."Is Correct";
                                    ApplicationMultiChoiceAnswerInit."Candidate Selected" := false;
                                    ApplicationMultiChoiceAnswerInit.Insert();
                                until JobScreeningAnswers.Next() = 0;
                        end;
                    until JobScreeningQuestions.Next() = 0;
            end;
        end;
    end;

    procedure ScreeningResults() Result: Text
    begin
        Result := Format("Screening Score (%)") + '% (' + Format("Screening Outcome") + ')';
        if "Screening Outcome" = Rec."Screening Outcome"::Pending then
            Result := '-';
    end;
}