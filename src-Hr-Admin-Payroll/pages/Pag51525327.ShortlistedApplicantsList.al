page 51525327 "Shortlisted Applicants List"
{
    ApplicationArea = All;
    CardPageID = "Job Application Card";//"Shortlisted Applicants Card";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Applications";
    SourceTableView = WHERE(Shortlist = CONST(true)/*,
                            "Passed Short Listing" = CONST(true)*/);

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
                }
                field("Recruitment Need Code"; Rec."Recruitment Need Code")
                {
                    Editable = false;
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
        area(Creation)
        {
            action("Send Congratulatory Message")
            {
                //Caption = 'Send Congratulatory Message
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = false;
                trigger OnAction()
                var
                begin
                    RecruitmentNeed.reset();
                    RecruitmentNeed.SetRange("No.", Rec."Recruitment Need Code");
                    if RecruitmentNeed.FindFirst() then begin
                        if not confirm('Are you sure you want to send congratulation emails to shortlisted candidates') then exit;
                        //Shortlisting stage must have passed
                        if RecruitmentNeed."Current Stage" in [RecruitmentNeed."Current Stage"::"Pending Applications", RecruitmentNeed."Current Stage"::"Receiving Applications", RecruitmentNeed."Current Stage"::Shortlisting] then
                            Error('You can only send this notification after shortlisting. Be sure to move the current stage beyond shortlisting!');

                        if (Rec."Shortlisted Emailed") then begin
                            if not confirm('The successful shortlisting message was already sent on ' + format(RecruitmentNeed."Shortlisted Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", RecruitmentNeed."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange(Shortlist, true);
                        if JobApplicationsTable.FindFirst then begin
                            //CompanyInfo.Get();
                            //SenderAddress := CompanyInfo."Administrator Email";
                            //SenderName := CompanyInfo.Name;
                            Window.OPEN('Sending message to #######1');
                            repeat
                                //Body := StrSubstNo('Please find attached');
                                Window.update(1, JobApplicationsTable.ApplicantName);
                                Subject := StrSubstNo('Successfully Shortlisted!');
                                Body := 'Dear ' + JobApplicationsTable.ApplicantName + '<br>';
                                Body := 'I hope this email finds you well. <br><br>You have been successfully shortlisted for the position of ' + RecruitmentNeed.Description + '<br>';
                                /*if (JobApplicationsTable.Shortlist = false) then
                                begin
                                    Subject := StrSubstNo('Unsuccessful Shortlisting');
                                    Body := 'Dear ' + JobApplicationsTable.ApplicantName + '<br>';
                                    Body := 'I hope this email finds you well. <br><br>You have been shortlisted for the position of ' + RecruitmentNeedDescription + '<br>';
                                end;*/
                                Body := 'Kindly await further communication from the organization.<br><br>.';
                                Body := 'Best Regards,<br>Recruitment Team.';
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
                                JobApplicationsTable."Shortlisted Emailed" := true;
                                JobApplicationsTable.Modify();
                            until JobApplicationsTable.next = 0;
                            Message('Message(s) sent successfully!');
                            Window.close();
                            //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end;
                        RecruitmentNeed."Shortlisted Emailed" := true;
                        RecruitmentNeed."Shortlisted Emailed On" := CREATEDATETIME(TODAY, TIME);
                        RecruitmentNeed.Modify();
                    end;
                end;
            }
            action("First Interview Invite")
            {
                Caption = 'Written Interview Invite';
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
                        if RecruitmentNeeds."Written Interview Venue" = '' then
                            Error('You must set the written interview venue and date & time first!');
                        if not confirm('Are you sure you want to send written interview invites?') then exit;
                        //Shortlisting stage must have passed
                        if RecruitmentNeeds."Current Stage" <> RecruitmentNeeds."Current Stage"::"First Interview" then
                            Error('You can only send written interview invites when the current stage is First Interview!');

                        if (RecruitmentNeeds."First Interview Emailed") then begin
                            if not confirm('The written interview invite was already sent on ' + format(RecruitmentNeeds."First Interview Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", RecruitmentNeeds."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange(Shortlist, true);
                        if JobApplicationsTable.FindFirst then begin
                            //CompanyInfo.Get();
                            //SenderAddress := CompanyInfo."Administrator Email";
                            //SenderName := CompanyInfo.Name;
                            Window.OPEN('Sending message to #######1');
                            repeat
                                Window.update(1, JobApplicationsTable.ApplicantName);
                                Subject := StrSubstNo('Interview Invitation');

                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>We trust this email notification finds you well.</p>' +
                                '<p>Following your successful shortlisting for the ' + JobApplicationsTable.JobDescription + ' position, we are pleased to invite you for an interview as follows;</p>' +
                                '<p><ul><li>Interview Date & Time: ' + FORMAT(RecruitmentNeeds."Written Interview DateTime") + '</li>' +
                                '<li>Venue: ' + RecruitmentNeeds."Written Interview Venue" + '</li></ul> +</p>' +
                                '<p>Kindly remember to carry all the necessary documents.</p>' +
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
                                JobApplicationsTable."Written Interview Emailed" := true;
                                JobApplicationsTable.Modify();
                            until JobApplicationsTable.next = 0;
                            Message('Message(s) sent successfully!');
                            Window.close();
                            //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end;
                        RecruitmentNeeds."First Interview Emailed" := true;
                        RecruitmentNeeds."First Interview Emailed On" := CREATEDATETIME(TODAY, TIME);
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
        JAppPage: Page "Job Application Card";
        applrecs: Record "Job Applications";
        ApplicantsNeeds: Record "Needs Requirement";
        ReqNeedss: Record "Job Application Qualification";
        applrecss: Record "Job Applications";
        RecruitmentNeed: Record "Recruitment Needs";
        JobApplicationsTable: Record "Job Applications";
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