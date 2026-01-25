page 51525328 "Failed Shortlisting List"
{
    ApplicationArea = All;
    CardPageID = "Job Application Card";//"Shortlisted Applicants Card";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Applications";
    SourceTableView = WHERE("Not Shortlisted" = CONST(true));

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
            action("Regret Unshortlisted")
            {
                Caption = 'Send Regret Message';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = false;
                trigger OnAction()
                var
                    skipEntry: Boolean;
                begin
                    RecruitmentNeeds.reset();
                    RecruitmentNeeds.SetRange("No.", Rec."Recruitment Need Code");
                    if RecruitmentNeeds.FindFirst() then begin
                        if not confirm('Are you sure you want to send regret emails to candidates who were not shortlisted?') then exit;
                        //Shortlisting stage must have passed
                        if RecruitmentNeeds."Current Stage" in [RecruitmentNeeds."Current Stage"::"Pending Applications", RecruitmentNeeds."Current Stage"::"Receiving Applications", RecruitmentNeeds."Current Stage"::Shortlisting] then
                            Error('You can only send this notification after shortlisting. Be sure to move the current stage beyond shortlisting!');

                        if (RecruitmentNeeds."Unshortlisted Emailed") then begin
                            if not confirm('The shortlisting regret message was already sent on ' + format(RecruitmentNeeds."Unshortlisted Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", RecruitmentNeeds."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange(Shortlist, false);
                        if JobApplicationsTable.FindFirst then begin
                            //CompanyInfo.Get();
                            //SenderAddress := CompanyInfo."Administrator Email";
                            //SenderName := CompanyInfo.Name;
                            Window.OPEN('Sending message to #######1');
                            repeat
                                //Body := StrSubstNo('Please find attached');
                                /*skipEntry := false;
                                if JobApplicationsTable."Unshortlisted Emailed" = true then
                                begin
                                    if not confirm('Candidate ')
                                end;*/
                                Window.update(1, JobApplicationsTable.ApplicantName);
                                Subject := StrSubstNo('Job Application Update');

                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>We trust this email notification finds you well.</p>' +
                                '<p>We have been reviewing all applications for the ' + JobApplicationsTable.JobDescription + ' position where you were part of the candidates.</p>' +
                                '<p>We have now considered all the candidates against the criteria we had set out for the role. The decision was not an easy one as the overall standards of all the candidates were high. Your credentials were specifically very impressive. However, after careful consideration we regret to inform you that they did not match up exactly with what we were seeking.</p>' +
                                '<p>Thank you for showing interest in working with us. We encourage to keep visiting the careers website for future roles as we wish you all the best in your future endeavors.</p>' +
                                '<p>Best regards,</p>' +
                                '<p>Recruitment Team</p>';

                                if JobApplicants.Get(JobApplicationsTable.ApplicantID) then begin
                                    EmailMessage.Create(JobApplicants."Email Address", Subject, Body, true);
                                    //SMTPSetup.AddCC(CompanyInfo."HR Support Email");

                                    //CC the others
                                    SecondaryEmailRecipients.Reset();
                                    SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Recruitment Notification");
                                    SecondaryEmailRecipients.SetFilter("E-mail", '<>%1', '');
                                    if SecondaryEmailRecipients.FindSet() then
                                        repeat
                                            Window.update(1, SecondaryEmailRecipients.Name);
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::"Send to" then
                                                EmailMessage.AddRecipient(Enum::"Email Recipient Type"::"To", DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::cc then
                                                EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::bcc then
                                                EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Bcc, DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                        until SecondaryEmailRecipients.next() = 0;

                                    EmailMessage.AppendToBody('<br><br><em>This is a system generated email. Please do not reply.</em>');
                                    Email.Send(EmailMessage, Enum::"Email Scenario"::"Talent Acquisition");
                                    //message('Email configurations not done!');
                                end;
                                JobApplicationsTable."Unshortlisted Emailed" := true;
                                JobApplicationsTable.Modify();
                            until JobApplicationsTable.next = 0;
                            Message('Message(s) sent successfully!');
                            Window.close();
                            //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end;
                        RecruitmentNeeds."Unshortlisted Emailed" := true;
                        RecruitmentNeeds."Unshortlisted Emailed On" := CREATEDATETIME(TODAY, TIME);
                        RecruitmentNeeds.Modify();
                    end;
                end;
            }
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
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        Window: Dialog;
        SecondaryEmailRecipients: Record "Secondary Email Recipients";
        Subject: Text[250];
        SenderName: Text[100];
        Body: Text[2000];
        JobApplicants: Record "HR Online Applicant";//"Job Applicants";

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