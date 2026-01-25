page 51525480 "Email Candidates"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Job Applications";

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
                field("Applicant ID"; Rec.ApplicantID)
                {
                    Editable = false;
                }
                field(ApplicantName; Rec.ApplicantName)
                {
                    Editable = false;
                }
                field("Recruitment Need Code"; Rec."Recruitment Need Code")
                {
                    Editable = false;
                }
                field(JobDescription; Rec.JobDescription)
                {
                    Editable = false;
                }
                field("Application Date"; Rec."Application Date")
                {
                    Editable = false;
                }
                field(Shortlist; Rec.Shortlist)
                {
                    Caption = 'Shortlisted';
                }
                field("Passed First Interview"; Rec."Passed First Interview")
                {
                }
                field("Passed Due Diligence"; Rec."Passed Due Diligence")
                {
                }
                field("Passed Second Interview"; Rec."Passed Second Interview")
                {
                }
                field(Successful; Rec.Successful)
                { }
                field("Shortlisted Emailed"; Rec."Shortlisted Emailed")
                { }

                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {

            action("Congratulate Shortlisted")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = EmailAction = 'Congratulate Shortlisted';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send congratulation emails to the selected shortlisted candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Shortlisted Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := StrSubstNo('Successfully Shortlisted!');
                                Body := 'Dear ' + JobApplicationsTable.ApplicantName + ',<br>';
                                Body += 'I hope this email finds you well. <br><br>You have been successfully shortlisted for the position of <strong>' + JobApplicationsTable.JobDescription + '</strong>.<br>';
                                Body += 'Kindly await further communication from the organization.<br><br>.';
                                Body += 'Best Regards,<br>Recruitment Team.';
                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Shortlisted Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."Shortlisted Emailed" := true;
                                RecruitmentNeeds."Shortlisted Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            action("Regret Unshortlisted")
            {
                Caption = 'Regret to Not Shortlisted';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = EmailAction = 'Regret Unshortlisted';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send regret emails to the selected candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Unshortlisted Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := StrSubstNo('Job Application Update');

                                ExternalInternalRegretMessage := '';
                                JobApplicationsTable.CalcFields("Requisition Type");
                                if JobApplicationsTable."Requisition Type" = JobApplicationsTable."Requisition Type"::Internal then
                                    ExternalInternalRegretMessage := 'We appreciate your interest in the <strong>' + JobApplicationsTable.JobDescription + '</strong> role and thank you for your time and energy in applying for this job opening.'
                                else
                                    ExternalInternalRegretMessage := 'We appreciate your interest in joining our company and want to thank you for your time and energy in applying for our <strong>' + JobApplicationsTable.JobDescription + '</strong> job opening.';
                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>We hope this email finds you well.</p>' +
                                '<p>' + ExternalInternalRegretMessage + '</p>' +
                                '<p>After careful review and consideration, we regret to inform you that we will not be proceeding with your application.</p>' +
                                '<p>Unfortunately, due to the high level of applications, we are unable to provide individual feedback. Should you wish to apply for a different vacancy, please do so through our <a href="https://erecruitment.rwandair.com/" target="_blank">e-recruitment portal</a>.</p>' +
                                '<p>We wish you every success in your future endeavours.</p>' +
                                '<p>Best Wishes,</p>' +
                                '<p>RwandAir Talent Acquisition</p>';

                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Shortlisted Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."Shortlisted Emailed" := true;
                                RecruitmentNeeds."Shortlisted Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            action("First Interview Invite")
            {
                Caption = 'Written Interview Invite';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = EmailAction = 'First Interview Invite';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    DayName := '';
                    InterviewDuration := 0;
                    InterviewRequiredDocs := '';
                    InterviewRequiredMaterials := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send written interview invites to the selected candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Written Interview Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := StrSubstNo('Written Exam Assessment Invitation');

                                if not InterviewItemsCaptured then begin
                                    RecruitmentNeeds.Reset();
                                    RecruitmentNeeds.SetRange("No.", JobApplicationsTable."Recruitment Need Code");
                                    if RecruitmentNeeds.FindFirst() then begin
                                        InterviewDateTime := RecruitmentNeeds."Written Interview DateTime";
                                        InterviewVenue := RecruitmentNeeds."Written Interview Venue";
                                        InterviewItemsCaptured := true;
                                        DayName := GetNameOfDay(Date2DWY(DT2Date(InterviewDateTime), 1));
                                        InterviewDuration := RecruitmentNeeds."Written Interview Duration";
                                        InterviewRequiredDocs := RecruitmentNeeds."Written Required Documents";
                                        InterviewRequiredMaterials := RecruitmentNeeds."Written Required Materials";
                                    end;
                                end;

                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>We appreciate your interest in the <strong>' + JobApplicationsTable.JobDescription + '</strong> position at ' + CompanyName + '.</p>' +
                                '<p>After reviewing your application, we are excited to congratulate you on being shortlisted and invite you to a <strong>Written Exam</strong> on <strong>' + DayName + FORMAT(InterviewDateTime, 0, ',<Month Text> <Day,2>, <Year4>') + '</strong>. Please find the details of the meeting below:</p>' +
                                '<table style="border-collapse: collapse;">' +
                                    '<tr><td style="padding: 4px;"><strong>Venue:</strong></td><td style="padding: 4px;"><strong>' + InterviewVenue + '</strong></td></tr>' +
                                    '<tr><td style="padding: 4px;"><strong>Time:</strong></td><td style="padding: 4px;"><strong>' + FORMAT(InterviewDateTime, 0, '<Hours12,2>:<Minutes,2> <AM/PM>') + '</strong> </td></tr>';
                                if InterviewRequiredDocs <> '' then
                                    Body += '<tr><td style="padding: 4px;"><strong>Required Documents:</strong></td><td style="padding: 4px;"><strong>' + InterviewRequiredDocs + '</strong></td></tr>';
                                if InterviewRequiredMaterials <> '' then
                                    Body += '<tr><td style="padding: 4px;"><strong>Materials Required:</strong></td><td style="padding: 4px;"><strong>' + InterviewRequiredMaterials + '</strong></td></tr>';
                                Body += '<tr><td style="padding: 4px;"><strong>Duration:</strong></td><td style="padding: 4px;"><strong>' + Format(InterviewDuration) + ' Hours</strong></td></tr>' +
                            '</table>' +
                            '<p><em><strong>NB:</strong> Please be aware that calculators, cell phones, and smartwatches are strictly prohibited during the exam. These devices must be left outside the examination room or kept away from the candidate before the test begins. If any of these items are used during the exam, it will result in automatic disqualification.</em></p>' +
                            '<p>Best Wishes,</p>' +
                            '<p>RwandAir Talent Acquisition</p>';

                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Written Interview Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."First Interview Emailed" := true;
                                RecruitmentNeeds."First Interview Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            action("Second Interview Invite - No Exam")
            {
                Caption = 'Oral Interview Invite - No Exam';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = EmailAction = 'Oral Interview Invite - No Exam';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    DayName := '';
                    InterviewDuration := 0;
                    InterviewRequiredDocs := '';
                    InterviewRequiredMaterials := '';
                    InterviewDressCode := '';
                    InterviewEndTime := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send oral interview invites to the selected candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Oral Interview Invite Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := 'Invitation to the ' + JobApplicationsTable.JobDescription + ' Interview';

                                if not InterviewItemsCaptured then begin
                                    RecruitmentNeeds.Reset();
                                    RecruitmentNeeds.SetRange("No.", JobApplicationsTable."Recruitment Need Code");
                                    if RecruitmentNeeds.FindFirst() then begin
                                        InterviewDateTime := RecruitmentNeeds."Oral Interview DateTime";
                                        InterviewVenue := RecruitmentNeeds."Oral Interview Venue";
                                        InterviewItemsCaptured := true;
                                        DayName := GetNameOfDay(Date2DWY(DT2Date(InterviewDateTime), 1));
                                        InterviewDuration := RecruitmentNeeds."Oral Interview Duration";
                                        InterviewRequiredDocs := RecruitmentNeeds."Oral Required Documents";
                                        InterviewRequiredMaterials := RecruitmentNeeds."Oral Required Materials";
                                        InterviewDressCode := RecruitmentNeeds."Oral Interview Dress Code";
                                        InterviewEndTime := getInterviewEndTime(InterviewDateTime, InterviewDuration);
                                    end;
                                end;

                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>We appreciate your interest in the <strong>' + JobApplicationsTable.JobDescription + '</strong> position at ' + CompanyName + '.</p>' +
                                '<p>After reviewing your application, we are excited to congratulate you on being shortlisted and invite you to a face-to-face with our team on <strong>' + DayName + FORMAT(InterviewDateTime, 0, ',<Month Text> <Day,2>, <Year4>') + '</strong>, to learn more about you. Please find the details of the meeting below:</p>' +
                                '<table style="border-collapse: collapse;">' +
                                    '<tr><td style="padding: 4px;"><strong>Venue:</strong></td><td style="padding: 4px;"><strong>' + InterviewVenue + '</strong></td></tr>' +
                                    '<tr><td style="padding: 4px;"><strong>Time:</strong></td><td style="padding: 4px;"><strong>' + FORMAT(InterviewDateTime, 0, '<Hours12,2>:<Minutes,2> <AM/PM>') + '</strong> </td></tr>';
                                if InterviewRequiredDocs <> '' then
                                    Body += '<tr><td style="padding: 4px;"><strong>Required Documents:</strong></td><td style="padding: 4px;"><strong>' + InterviewRequiredDocs + '</strong></td></tr>';
                                if InterviewRequiredMaterials <> '' then
                                    Body += '<tr><td style="padding: 4px;"><strong>Materials Required:</strong></td><td style="padding: 4px;"><strong>' + InterviewRequiredMaterials + '</strong></td></tr>';
                                if InterviewDressCode <> '' then
                                    Body += '<tr><td style="padding: 4px;"><strong>Dress Code:</strong></td><td style="padding: 4px;"><strong>' + InterviewDressCode + '</strong></td></tr>';
                                Body += '<tr><td style="padding: 4px;"><strong>Duration:</strong></td><td style="padding: 4px;"><strong>' + Format(InterviewDuration) + ' Hours</strong></td></tr>' +
                            '</table>' +
                            '<p><em><strong>NB: Please clear your calendar from ' + FORMAT(InterviewDateTime, 0, '<Hours12,2>:<Minutes,2> <AM/PM>') + ' to ' + InterviewEndTime + '</strong></em></p>' +
                            '<p>Best Wishes,</p>' +
                            '<p>RwandAir Talent Acquisition</p>';

                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Written Interview Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."First Interview Emailed" := true;
                                RecruitmentNeeds."First Interview Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            action("Second Interview Invite - Passed Exam")
            {
                Caption = 'Oral Interview Invite - Passed Exam';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = EmailAction = 'Oral Interview Invite - Passed Exam';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    DayName := '';
                    InterviewDuration := 0;
                    InterviewRequiredDocs := '';
                    InterviewRequiredMaterials := '';
                    InterviewDressCode := '';
                    InterviewEndTime := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send oral interview invites to the selected candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Oral Interview Invite Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := 'Invitation to the ' + JobApplicationsTable.JobDescription + ' Interview';

                                if not InterviewItemsCaptured then begin
                                    RecruitmentNeeds.Reset();
                                    RecruitmentNeeds.SetRange("No.", JobApplicationsTable."Recruitment Need Code");
                                    if RecruitmentNeeds.FindFirst() then begin
                                        InterviewDateTime := RecruitmentNeeds."Oral Interview DateTime";
                                        InterviewVenue := RecruitmentNeeds."Oral Interview Venue";
                                        InterviewItemsCaptured := true;
                                        DayName := GetNameOfDay(Date2DWY(DT2Date(InterviewDateTime), 1));
                                        InterviewDuration := RecruitmentNeeds."Oral Interview Duration";
                                        InterviewRequiredDocs := RecruitmentNeeds."Oral Required Documents";
                                        InterviewRequiredMaterials := RecruitmentNeeds."Oral Required Materials";
                                        InterviewDressCode := RecruitmentNeeds."Oral Interview Dress Code";
                                        InterviewEndTime := getInterviewEndTime(InterviewDateTime, InterviewDuration);
                                    end;
                                end;

                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>Thank you for taking the recent written exam for the <strong>' + JobApplicationsTable.JobDescription + '</strong> position at ' + CompanyName + '.</p>' +
                                '<p>We are delighted to inform you that you have been recommended for the next round of our recruitment process. The next round involves a face-to-face interview with our team on <strong>' + DayName + FORMAT(InterviewDateTime, 0, ',<Month Text> <Day,2>, <Year4>') + '</strong>, to discuss the role and learn more about you. Please find the details of the meeting below:</p>' +
                                '<table style="border-collapse: collapse;">' +
                                    '<tr><td style="padding: 4px;"><strong>Venue:</strong></td><td style="padding: 4px;"><strong>' + InterviewVenue + '</strong></td></tr>' +
                                    '<tr><td style="padding: 4px;"><strong>Time:</strong></td><td style="padding: 4px;"><strong>' + FORMAT(InterviewDateTime, 0, '<Hours12,2>:<Minutes,2> <AM/PM>') + '</strong> </td></tr>';
                                if InterviewRequiredDocs <> '' then
                                    Body += '<tr><td style="padding: 4px;"><strong>Required Documents:</strong></td><td style="padding: 4px;"><strong>' + InterviewRequiredDocs + '</strong></td></tr>';
                                if InterviewRequiredMaterials <> '' then
                                    Body += '<tr><td style="padding: 4px;"><strong>Materials Required:</strong></td><td style="padding: 4px;"><strong>' + InterviewRequiredMaterials + '</strong></td></tr>';
                                if InterviewDressCode <> '' then
                                    Body += '<tr><td style="padding: 4px;"><strong>Dress Code:</strong></td><td style="padding: 4px;"><strong>' + InterviewDressCode + '</strong></td></tr>';
                                Body += '<tr><td style="padding: 4px;"><strong>Duration:</strong></td><td style="padding: 4px;"><strong>' + Format(InterviewDuration) + ' Hours</strong></td></tr>' +
                            '</table>' +
                            '<p>Best Wishes,</p>' +
                            '<p>RwandAir Talent Acquisition</p>';

                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Written Interview Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."First Interview Emailed" := true;
                                RecruitmentNeeds."First Interview Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            action("Second Interview Invite")
            {
                Caption = 'Oral Interview Invite';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;//EmailAction = 'Second Interview Invite';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send oral interview invites to the selected candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Oral Interview Invite Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := StrSubstNo('Interview Invitation');

                                if not InterviewItemsCaptured then begin
                                    RecruitmentNeeds.Reset();
                                    RecruitmentNeeds.SetRange("No.", JobApplicationsTable."Recruitment Need Code");
                                    if RecruitmentNeeds.FindFirst() then begin
                                        InterviewDateTime := RecruitmentNeeds."Written Interview DateTime";
                                        InterviewVenue := RecruitmentNeeds."Written Interview Venue";
                                        InterviewItemsCaptured := true;
                                    end;
                                end;

                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>We trust this email notification finds you well.</p>' +
                                '<p>Following your successful shortlisting and initial screening for the <strong>' + JobApplicationsTable.JobDescription + '</strong> position, we are pleased to invite you for an oral interview as follows;</p>' +
                                '<p><ul><li>Interview Date & Time: <strong>' + FORMAT(InterviewDateTime) + '</strong></li>' +
                                '<li>Venue: <strong>' + InterviewVenue + '</strong></li></ul> +</p>' +
                                '<p>Kindly remember to carry all the necessary documents.</p>' +
                                '<p>Best regards,</p>' +
                                '<p>RwandAir Talent Acquisition</p>';

                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Oral Interview Invite Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."Second Interview Inv Emailed" := true;
                                RecruitmentNeeds."Sec. Interview Inv Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            action("Vetting Regret")
            {
                Caption = 'Vetting Regret';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = EmailAction = 'Vetting Regret';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send regret emails to the selected candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Regret Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := StrSubstNo('Job Application Update');

                                //ExternalInternalRegretMessage := '';
                                //JobApplicationsTable.CalcFields("Requisition Type");
                                //if JobApplicationsTable."Requisition Type" = JobApplicationsTable."Requisition Type"::Internal then
                                //ExternalInternalRegretMessage := 'We appreciate your interest in the <strong>' + JobApplicationsTable.JobDescription + '</strong> role and thank you for your time and energy in applying for this job opening.'
                                //else
                                //ExternalInternalRegretMessage := 'We appreciate your interest in joining our company and want to thank you for your time and energy in applying for our <strong>' + JobApplicationsTable.JobDescription + '</strong> job opening.';
                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>However, we regret to inform you that the candidate we feel most closely meets the position''s requirements has been selected.</p>' +
                                '<p>We sincerely appreciate your interest in joining our team, and We wish you the best of luck in your future endeavours.</p>' +
                                '<p>Best Wishes,</p>' +
                                '<p>RwandAir Talent Acquisition</p>';
                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Regret Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."Regret Emailed" := true;
                                RecruitmentNeeds."Regret Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            action("General Regret")
            {
                Caption = 'Send Regret Message';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = EmailAction = 'General Regret';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send regret emails to the selected unsuccessful candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Regret Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := StrSubstNo('Job Application Update');

                                ExternalInternalRegretMessage := '';
                                JobApplicationsTable.CalcFields("Requisition Type");
                                if JobApplicationsTable."Requisition Type" = JobApplicationsTable."Requisition Type"::Internal then
                                    ExternalInternalRegretMessage := 'We appreciate your interest in the <strong>' + JobApplicationsTable.JobDescription + '</strong> role and thank you for your time and energy in applying for this job opening.'
                                else
                                    ExternalInternalRegretMessage := 'We appreciate your interest in joining our company and want to thank you for your time and energy in applying for our <strong>' + JobApplicationsTable.JobDescription + '</strong> job opening.';
                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>We hope this email finds you well.</p>' +
                                '<p>' + ExternalInternalRegretMessage + '</p>' +
                                '<p>After careful review and consideration, we regret to inform you that we will not be proceeding with your application.</p>' +
                                '<p>Unfortunately, due to the high level of applications, we are unable to provide individual feedback. Should you wish to apply for a different vacancy, please do so through our <a href="https://erecruitment.rwandair.com/" target="_blank">e-recruitment portal</a>.</p>' +
                                '<p>We wish you every success in your future endeavours.</p>' +
                                '<p>Best Wishes,</p>' +
                                '<p>RwandAir Talent Acquisition</p>';
                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Regret Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."Regret Emailed" := true;
                                RecruitmentNeeds."Regret Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            action("Congratulate Successful")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = EmailAction = 'Congratulate Successful';
                trigger OnAction()
                var
                begin
                    ReqDocNo := '';
                    SkipRecord := false;
                    CandidateEmailed := false;
                    TestEmail := '';
                    RecipientEmail := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        if Confirm('Do you want to send yourself a test email first?') then begin
                            GetTestEmail();
                            if TestEmail = '' then
                                Error('Kindly ask the admin to update your company email in Employee card or user setup then retry!');
                        end;
                        if TestEmail = '' then
                            if not confirm('Are you sure you want to send congratulation emails to the selected candidates?') then exit;
                        Window.OPEN('Sending message to #######1');
                        repeat
                            Window.update(1, JobApplicationsTable.ApplicantName);
                            if (JobApplicationsTable."Success Emailed") and (TestEmail = '') then begin
                                if not confirm('Applicant ' + JobApplicationsTable.ApplicantName + ' has already been emailed. Do you want to email them again?') then
                                    SkipRecord := true;
                            end;

                            if not SkipRecord then begin
                                Subject := StrSubstNo('Congratulations!');
                                Body := 'Dear ' + JobApplicationsTable.ApplicantName + '<br>';
                                Body += 'I hope this email finds you well. <br><br>We have completed the review of applications for the <strong>' + JobApplicationsTable.JobDescription + '</strong> position and we are pleased to inform you that you have qualified for the position.<br>';
                                Body += 'Kindly await further communication from the organization.<br><br>.';
                                Body += 'Best Regards,<br>Recruitment Team.';
                                if JobApplicants.Get(JobApplicationsTable."Applicant Email") then begin
                                    if JobApplicants."Email Address" <> '' then begin
                                        RecipientEmail := TestEmail;
                                        if TestEmail = '' then
                                            RecipientEmail := JobApplicants."Email Address";
                                        EmailMessage.Create(RecipientEmail, Subject, Body, true);

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
                                        CandidateEmailed := true;
                                    end;
                                end;
                            end;
                            if (CandidateEmailed) and (TestEmail = '') then begin
                                if ReqDocNo = '' then
                                    ReqDocNo := JobApplicationsTable."Recruitment Need Code";
                                JobApplicationsTable."Success Emailed" := true;
                                JobApplicationsTable.Modify();
                            end;
                            if TestEmail <> '' then
                                break;
                        until (JobApplicationsTable.next() = 0);
                        if ReqDocNo <> '' then begin
                            RecruitmentNeeds.Reset();
                            RecruitmentNeeds.SetRange("No.", ReqDocNo);
                            if (RecruitmentNeeds.FindFirst()) and (TestEmail = '') then begin
                                RecruitmentNeeds."Success Emailed" := true;
                                RecruitmentNeeds."Success Emailed On" := CREATEDATETIME(TODAY, TIME);
                                RecruitmentNeeds.Modify();
                            end;
                            if TestEmail <> '' then
                                Message('Test email sent to %1', TestEmail)
                            else
                                Message('Message(s) sent successfully!');
                        end;
                        Window.close();
                    end else
                        Error('No candidate selected!');
                end;
            }
            /*action("Shortlist CandidatesNew")
            {
                Image = Interaction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Shortlist Candidates";
                Visible = false;

                trigger OnAction()
                var
                    shortlistrec: Record "Company Jobs";
                    applrec: Record "Job Applications";
                    Dialogr: Dialog;
                    k: Integer;
                    l: Integer;
                    advertrec: Record "Recruitment Needs";
                    experincerec: Record "Job Requirement App";
                    yaersofexperience: Integer;
                    applicantdetails: Record "Applicants Qualification";
                    academicrec: Record "Indept Recruitment Needs App";
                    m: Integer;
                    n: Integer;
                    professionalrec: Record "Indept Recruitment Needs App";
                    proffid: Integer;
                    membershiprec: Record "Job Professional Bodies";
                    passedcheck: Integer;
                    countrows: Integer;
                    remaining: Integer;
                    applrecx: Record "Job Applications";
                    needs: Record "Recruitment Needs";
                begin
                end;
            }*/
        }
    }

    trigger OnOpenPage()
    begin
    end;

    var
        shortlisting: Boolean;
        RecruitmentNeeds: Record "Recruitment Needs";
        TotalScores: Boolean;
        TotalScore: Boolean;
        JobApplicationsTable: Record "Job Applications";
        JAppPage: Page "Job Application Card";
        applrecs: Record "Job Applications";
        applrecss: Record "Job Applications";
        ZipedFile: OutStream;
        FileName: array[4] of Text;
        FileContent: array[4] of BigText;
        ZipName: Text;
        FileMgt: Codeunit "File Management";
        ZipStream: InStream;
        FileStream: InStream;
        i: Integer;
        DocAttachment: Record "Document Attachment";
        ReqDocNo: Code[100];
        SkipRecord: Boolean;
        Window: Dialog;
        SecondaryEmailRecipients: Record "Secondary Email Recipients";
        SenderAddress: Text[100];
        Subject: Text[250];
        SenderName: Text[100];
        Body: Text[2000];
        JobApplicants: Record "HR Online Applicant";//"Job Applicants";
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        CandidateEmailed: Boolean;
        InterviewDateTime: DateTime;
        InterviewVenue: Text[250];
        InterviewDuration: Decimal;
        InterviewRequiredDocs: Text;
        InterviewRequiredMaterials: Text;
        InterviewDressCode: Text;
        InterviewEndTime: Text;
        InterviewItemsCaptured: Boolean;
        ExternalInternalRegretMessage: Text[250];
        EmailAction: Text[50];
        TestEmail: Text;
        RecipientEmail: Text;
        DayName: Text;
        UserSetup: Record "User Setup";
        EmpRec: Record Employee;


    procedure setEmailAction(Act: Text[50])
    begin
        EmailAction := act;
    end;

    procedure GetTestEmail()
    begin
        TestEmail := '';

        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetFilter("E-Mail", '<>%1', '');
        if UserSetup.FindFirst() then
            TestEmail := UserSetup."E-Mail";

        if TestEmail = '' then begin
            EmpRec.Reset();
            EmpRec.SetRange("User ID", UserId);
            EmpRec.SetFilter("Company E-Mail", '<>%1', '');
            if EmpRec.FindFirst() then
                TestEmail := EmpRec."Company E-Mail";
        end;

    end;

    procedure GetNameOfDay(DayOfWeek: Integer) NameOfDay: Text
    begin
        case DayOfWeek of
            1:
                NameOfDay := 'Monday';
            2:
                NameOfDay := 'Tuesday';
            3:
                NameOfDay := 'Wednesday';
            4:
                NameOfDay := 'Thursday';
            5:
                NameOfDay := 'Friday';
            6:
                NameOfDay := 'Saturday';
            7:
                NameOfDay := 'Sunday';
        end;
    end;

    procedure getInterviewEndTime(IntViewDateTime: DateTime; InterviewDur: Decimal) EndTime: Text
    var
        EndDateTime: DateTime;
    begin
        EndTime := '';
        if (IntViewDateTime <> CreateDateTime(0D, 0T)) then begin
            EndDateTime := IntViewDateTime + (InterviewDur * 3600000);
            EndTime := Format(EndDateTime, 0, '<Hours12,2>:<Minutes,2> <AM/PM>');
        end;
    end;
}