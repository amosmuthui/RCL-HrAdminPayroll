page 51525332 "Failed Due Diligence List"
{
    ApplicationArea = All;
    CardPageID = "Job Application Card";//"Shortlisted Applicants Card";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Applications";
    SourceTableView = WHERE("Failed Due Diligence" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ApplicationNo; Rec.ApplicationNo)
                {
                    Visible = true;
                }
                field("Serial No."; Rec."Serial No.")
                { }
                field("Applicant ID"; Rec.ApplicantID)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Recruitment Need Code"; Rec."Recruitment Need Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Application Date"; Rec."Application Date")
                {
                    Editable = false;
                }
                field(ApplicantName; Rec.ApplicantName)
                {
                    Editable = false;
                }
                field(JobDescription; Rec.JobDescription)
                {
                    Editable = false;
                }
                field(CurrentSalary; Rec.CurrentSalary)
                {
                    Caption = 'Current Salary';
                    Editable = false;
                    Visible = false;
                }
                /*field(Submitted; Rec.Submitted)
                {
                    Visible = false;
                }
                field("Total Score"; Rec."Total Score Shorlisting")
                {
                    Editable = false;
                    Visible = true;
                }
                field(Shortlist; Rec.Shortlist)
                {
                }
                field("Passed Short Listing"; Rec."Passed Short Listing")
                {
                }
                field("Qualification Score"; Rec."Qualification Score")
                {
                    Visible = false;
                }
                field("Total Score Oral  Interview"; Rec."Total Score Oral  Interview")
                {
                    Editable = false;
                }*/
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnOpenPage()
    begin
        /*if RecruitmentNeeds.Get("Recruitment Need Code") then
            if RecruitmentNeeds."Short Listing Done?" = true then begin
                SetCurrentKey("Total Score Oral  Interview");
                Rec.Ascending(false);
                TotalScores := true;
                shortlisting := false;
            end else begin
                SetCurrentKey("Total Score Shorlisting");
                Rec.Ascending(false);
                TotalScore := true;
                shortlisting := true;
            end;*/

        //"Qualification Score":=JAppPage.fnGetQualificationScore(Rec);
    end;

    var
        shortlisting: Boolean;
        RecruitmentNeeds: Record "Recruitment Needs";
        TotalScores: Boolean;
        TotalScore: Boolean;
        JobApplicationsTable: Record "Job Applications";
        JAppPage: Page "Job Application Card";
        applrecs: Record "Job Applications";
        ApplicantsNeeds: Record "Needs Requirement";
        ReqNeedss: Record "Job Application Qualification";
        applrecss: Record "Job Applications";

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

    local procedure FnShortlistAppplicants(RecruitmentNeed: Code[10])
    var
        NeedsReq: Record "Needs Requirement";
        ReqNeeds: Record "Job Application Qualification";
        RecruitmentNeeds: Record "Recruitment Needs";
        JobApplications: Record "Job Applications";
        NeedsReqs: Record "Needs Requirement";
    begin
        JobApplications.Reset;
        JobApplications.SetRange(JobApplications."Recruitment Need Code", RecruitmentNeed);
        if JobApplications.FindFirst then begin
            repeat
                NeedsReqs.Reset;
                NeedsReqs.SetRange(NeedsReqs."Need Id", RecruitmentNeed);
                //NeedsReqs.SETRANGE(NeedsReqs.Mandatory,TRUE);
                if NeedsReqs.FindSet then begin
                    repeat
                        ReqNeeds.Reset;
                        ReqNeeds.SetRange(ReqNeeds."Job Need Id", NeedsReqs."Need Id");
                        ReqNeeds.SetRange(ReqNeeds."Applicant No.", JobApplications.ApplicantID);
                        ReqNeeds.SetRange(ReqNeeds."Job Need Id", RecruitmentNeed);
                        ReqNeeds.SetRange(ReqNeeds."Course Id", NeedsReqs."Course Id");
                        if ReqNeeds.FindFirst then begin
                            repeat
                                NeedsReq.Reset;
                                NeedsReq.SetRange(NeedsReq."Need Id", JobApplications."Recruitment Need Code");
                                NeedsReq.SetRange(NeedsReq."Course Id", ReqNeeds."Course Id");
                                //NeedsReq.SETRANGE(NeedsReq.Mandatory,TRUE);
                                if NeedsReq.FindFirst then
                                    ReqNeeds.Found := true;
                                ReqNeeds.Modify;
                            until ReqNeeds.Next = 0;
                        end;
                    until NeedsReqs.Next = 0;
                end;
            until JobApplications.Next = 0;
        end;
    end;

    local procedure FnCheckFormSixRequirements(RecruitmentNeed: Code[10])
    var
        NeedsReq: Record "Needs Requirement";
        ReqNeeds: Record "Recruitment Needs";
        JobApplications: Record "Job Applications";
    begin
        JobApplications.Reset;
        JobApplications.SetRange(JobApplications."Recruitment Need Code", RecruitmentNeed);
        if JobApplications.FindFirst then begin
            repeat
                ReqNeeds.Reset;
                ReqNeeds.SetRange(ReqNeeds."No.", JobApplications."Recruitment Need Code");
                ReqNeeds.SetRange(ReqNeeds."Cert of Good Conduct Attached", JobApplications."Cert of Good Conduct Attached");
                ReqNeeds.SetRange(ReqNeeds."HELB Clearance Attached", JobApplications."HELB Clearance Attached");
                ReqNeeds.SetRange(ReqNeeds."E.A.C.C Clearance Attached", JobApplications."E.A.C.C Clearance Attached");
                ReqNeeds.SetRange(ReqNeeds."CRB Clearance Attached", JobApplications."CRB Clearance Attached");
                ReqNeeds.SetRange(ReqNeeds."TAX Compliance Attached", JobApplications."Tax Compliance Attached");
                if not ReqNeeds.FindFirst then begin
                    JobApplications."Not Qualified" := true;
                    JobApplications.Modify;
                end;
            until JobApplications.Next = 0;
        end;
        Commit;
    end;
}