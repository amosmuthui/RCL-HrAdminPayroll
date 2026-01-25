page 51525326 "Job Application Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Job Applications";
    DeleteAllowed = false;
    PromotedActionCategories = 'Manage,Process,Report,Related Information,Grouped Attachments';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Bio Data';
                field(ApplicationNo; Rec.ApplicationNo)
                {
                }
                field("Application Date"; Rec."Application Date")
                {
                }
                field("Recruitment Need Code"; Rec."Recruitment Need Code")
                {
                    Editable = KeyFieldsEditable;
                }
                field(ApplicantID; Rec.ApplicantID)
                {
                }
                field(ApplicantName; Rec.ApplicantName)
                {
                }
                field(Gender; Rec.Gender)
                { }
                field("Applicant Email"; Rec."Applicant Email")
                {
                    Editable = KeyFieldsEditable;
                }
                field("Phone Number"; Rec."Mobile No.")
                {
                    Editable = false;
                }
                field("Job Applied For"; Rec."Job Applied For")
                {
                }
                field(JobDescription; Rec.JobDescription)
                {
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                }
                field("County Code"; Rec."County Code")
                {
                    Caption = 'Home County';
                    Visible = false;
                }
                field("County Name"; Rec."County Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Years of Experince"; Rec."Years of Experince")
                {
                }
                field("Current Gross Salary"; Rec."Current Gross Salary")
                {
                }
                field("Expected Gross Salary"; Rec."Expected Gross Salary")
                {
                }
                /*field("Ethnic Origin"; Rec."Ethnic Origin")
                {
                }*/
                field(Disabled; Rec.Disabled)
                {
                }
                /*field("Notice Period"; Rec."Notice Period")
                {
                }
                field("Total Score Oral  Interview"; Rec."Total Score Oral  Interview")
                {
                    Editable = false;
                }
                field("Average Score Oral"; Rec."Average Score Oral")
                {
                    Editable = false;
                }
                field("Total Technical Score"; Rec."Total Technical Score")
                {
                    Editable = false;
                }
                field("Applicant Total Score"; Rec."Applicant Total Score")
                {
                    Editable = false;
                }*/
                field(Submitted; Rec.Submitted)
                {
                    Editable = false;
                }
            }
            group("Shortlisting Creteria")
            {
                Caption = 'Shortlisting Creteria';
                Visible = false;
                field("Required Attachments Present"; Rec."Required Attachments Present")
                {
                }
                field("YOE Passed"; Rec."YOE Passed")
                {
                }
                field("Required Proff Docs Present"; Rec."Required Proff Docs Present")
                {
                }
                field("Minimum Academic Level Meet"; Rec."Minimum Academic Level Meet")
                {
                }
                field("Passed Automatic Shorlisting"; Rec."Passed Automatic Shorlisting")
                {
                }
            }
            group("Application Processing")
            {
                Caption = 'Application Processing';
                field(Status; Rec.PortalStatus())//Status
                {
                }
                field("Screening Results"; Rec.ScreeningResults())
                {
                }
                field(Shortlist; Rec.Shortlist)
                {
                    Editable = Rec.Stage = Rec.Stage::Shortlisting;
                }
                field("Not Shortlisted"; Rec."Not Shortlisted")
                {
                    Editable = Rec.Stage = Rec.Stage::Shortlisting;
                }
                field("Shortlisting Comments"; Rec."Shortlisting Comments")
                {
                    MultiLine = true;
                    Editable = Rec.Stage = Rec.Stage::Shortlisting;
                }
                field("Passed First Interview"; Rec."Passed First Interview")
                {
                    Editable = Rec.Stage = Rec.Stage::"First Interview";
                }
                field("Failed First Interview"; Rec."Failed First Interview")
                {
                    Editable = Rec.Stage = Rec.Stage::"First Interview";
                }
                field("First Interview Comments"; Rec."First Interview Comments")
                {
                    MultiLine = true;
                    Editable = Rec.Stage = Rec.Stage::"First Interview";
                }
                field("Passed Due Diligence"; Rec."Passed Due Diligence")
                {
                    Editable = Rec.Stage = Rec.Stage::"Due Diligence";
                }
                field("Failed Due Diligence"; Rec."Failed Due Diligence")
                {
                    Editable = Rec.Stage = Rec.Stage::"Due Diligence";
                }
                field("Due Diligence Comments"; Rec."Due Diligence Comments")
                {
                    MultiLine = true;
                    Editable = Rec.Stage = Rec.Stage::"Due Diligence";
                }
                field("Passed Second Interview"; Rec."Passed Second Interview")
                {
                    Editable = Rec.Stage = Rec.Stage::"Second Interview";
                }
                field("Failed Second Interview"; Rec."Failed Second Interview")
                {
                    Editable = Rec.Stage = Rec.Stage::"Second Interview";
                }
                field("Second Interview Comments"; Rec."Second Interview Comments")
                {
                    MultiLine = true;
                    Editable = Rec.Stage = Rec.Stage::"Second Interview";
                }
                field(Successful; Rec.Successful)
                {
                    Editable = Rec.Stage = Rec.Stage::Completed;
                }
                field(Unsuccessful; Rec.Unsuccessful)
                {
                    Editable = Rec.Stage = Rec.Stage::Completed;
                }

                field("Final Comments"; Rec."Final Comments")
                {
                    MultiLine = true;
                    Editable = Rec.Stage = Rec.Stage::Completed;
                }
                field("Talent Pool"; Rec."Talent Pool")
                { }
            }
            /*part(Control1; "Job Questionnare Response")
            {
                SubPageLink = Applicant = FIELD(ApplicationNo);
                Visible = false;
            }*/
            part("Screening Questions"; "Application Screening Response")
            {
                SubPageLink = "Application No." = field(ApplicationNo);
                Editable = KeyFieldsEditable;
            }
            part("ACADEMIC RECORDS"; "Job Application Qualification")
            {
                Caption = 'Academic Records';
                SubPageLink = "Job App ID" = FIELD(ApplicationNo)/*,
                              "Applicant No." = FIELD(ApplicantID),
                              "Job Need Id" = FIELD("Recruitment Need Code")*/;
                Editable = false;
            }
            part("PROFESSIONAL BODIES"; "Membership and Certifications")
            {
                Caption = 'Professional Bodies';
                SubPageLink = Code = FIELD(ApplicationNo);
                Editable = false;
            }
            part("EMPLOYMENT HISTORY"; "Job App Work Experience")
            {
                Caption = 'Employment History';
                SubPageLink = "Job App ID" = FIELD(ApplicationNo),
                              "Applicant No." = FIELD(ApplicantID);
                Editable = false;
            }
            part(REFEREES; "Job Application Referees")
            {
                Caption = 'Referees';
                SubPageLink = "Job App ID" = FIELD(ApplicationNo),
                              No = FIELD(ApplicantID);
                Editable = false;
            }
            /*part(Control8; "Job App Documents")
            {
                SubPageLink = "Job App ID" = FIELD(ApplicationNo),
                              "Applicant No" = FIELD(ApplicantID);
                Visible = false;
            }
            part(Control9; "Job App Comments/Views")
            {
                SubPageLink = "Job App ID" = FIELD(ApplicationNo);
                Visible = false;
            }*/
        }
        area(factboxes)
        {
            part("Attached Documents"; /*"Document Attachment Factbox"*/"Attached Documents")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(51525286),
                              "No." = FIELD(ApplicationNo);
            }
            part("Academic Attachments"; "Academic Certificates FactBox")
            {
                ApplicationArea = All;
                Caption = 'Academic Attachments';
                SubPageLink = "Email Address" = FIELD("Applicant Email");
                ;
            }
            part("Professional Certificates"; "Professional Certs FactBox")
            {
                ApplicationArea = All;
                Caption = 'Professional Certificates';
                SubPageLink = "Email Address" = FIELD("Applicant Email");
            }
            systempart(Control1900383207; Links)
            {
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("See Attachments")
            {
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            /*action("Populate Response")
            {
                Visible = false;

                trigger OnAction()
                var
                    HRQuestionare: Record "HR Questionare";
                    HRQuestionnareResponse: Record "HR Questionnare Response";
                    HRQuestionareR: Record "HR Questionnare Response";
                begin
                    HRQuestionare.Reset;
                    HRQuestionare.SetRange("Job ID", "Job Applied For");
                    if HRQuestionare.FindFirst then begin
                        repeat
                            HRQuestionareR.Init;
                            HRQuestionareR.numbers := HRQuestionare.code;
                            HRQuestionareR.codes := HRQuestionare.code;
                            HRQuestionareR.Applicant := ApplicationNo;
                            HRQuestionareR.Description := HRQuestionare.description;
                            if not HRQuestionareR.Get(HRQuestionare.code, ApplicationNo) then begin
                                HRQuestionareR.Insert;
                            end;
                        until HRQuestionare.Next = 0;
                    end;
                end;
            }*/
            action(" Academic Attachments")
            {
                Caption = ' Academic Attachments';
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Academic Attachments";
                RunPageLink = "Email Address" = FIELD("Applicant Email");
            }
            action(" Chapter 6, CV & Application Letter Attachments")
            {
                Caption = ' Chapter 6, CV & Application Letter Attachments';
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Applicant Attachments";
                RunPageLink = "Email Address" = FIELD("Applicant Email"), "Job No" = FIELD("Recruitment Need Code");
            }
            action(" Professional Certificates")
            {
                Caption = ' Professional Certificates';
                Image = Documents;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Professional Attachments";
                RunPageLink = "Email Address" = FIELD("Applicant Email");
            }
            action(Attachments)
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Document Attachment Details";
                RunPageLink = "No." = FIELD(ApplicationNo);
            }
            action("Submit")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                Visible = KeyFieldsEditable;

                trigger OnAction()
                begin
                    if not confirm('Are you sure you want to submit this application?') then exit;
                    Rec.Submitted := true;
                    Rec.Status := Rec.Status::Submitted;
                    Rec.Modify();
                    Message('Applications submitted successfully!');
                end;
            }
            action("Update Multiple Candidates")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Update Multiple Candidates";
                RunPageLink = "Recruitment Need Code" = FIELD("Recruitment Need Code");
            }
            action("Job Details")
            {
                //Image = Attach;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Recruitment Request";
                RunPageLink = "No." = FIELD("Recruitment Need Code");
            }
            action("Applicant Details")
            {
                //Image = Attach;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Applicant Card";
                //RunPageLink = "No." = FIELD(ApplicantID);
                RunPageLink = "Email Address" = field("Applicant Email");
            }
            action("Talent Pools")
            {
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Candidate Talent Pools";
                RunPageLink = "Candidate Email" = field("Applicant Email");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //"Qualification Score":=fnGetQualificationScore(Rec);
        Rec.PortalStatus();
    end;

    trigger OnOpenPage()
    var
        //HrRecruitmentWS: Codeunit "HR Recruitment WS";
        HrOnlineApplicant: Record "HR Online Applicant";
        HrApplications: Record "Job Applications";
    begin
        KeyFieldsEditable := false;
        Rec.PortalStatus();
        if UserId = 'RWANDAIR\PORTALUSER' then begin
            KeyFieldsEditable := true; //For PTL tests
            //HrRecruitmentWS.CopyCorrectApplicationAttachments;
            /*HrOnlineApplicant.Reset();
            HrOnlineApplicant.SetRange("No.", '');
            if HrOnlineApplicant.FindSet() then
                repeat
                    HrOnlineApplicant.Validate("No.");

                    HrApplications.Reset();
                    HrApplications.SetRange("Applicant Email", HrOnlineApplicant."Email Address");
                    if HrApplications.FindSet() then
                        repeat
                            HrApplications.ApplicantID := HrOnlineApplicant."No.";
                            HrApplications.Modify();
                        until HrApplications.Next() = 0;

                    HrOnlineApplicant.Modify();
                until HrOnlineApplicant.Next() = 0;
            Message('Done');*/
        end;
    end;

    var
        //HRQuestionares: Record "HR Questionare";
        //HRQuestionareRs: Record "HR Questionare";
        KeyFieldsEditable: Boolean;


    procedure fnGetQualificationScore(JApp: Record "Job Applications") QualificationScoreID: Decimal
    var
        objJAQ: Record "Job Application Qualification";
    begin
        QualificationScoreID := 0;
        objJAQ.Reset;
        objJAQ.SetRange("Applicant No.", JApp.ApplicantID);
        objJAQ.SetRange("Job App ID", JApp.ApplicationNo);
        if objJAQ.FindSet(true) then begin
            repeat
                objJAQ.CalcFields("Score Id");
                //QualificationScoreID:= QualificationScoreID+objJAQ."Score Id";
                QualificationScoreID += objJAQ."Score Id";
            until objJAQ.Next = 0;
        end;
        exit(QualificationScoreID)
    end;
}