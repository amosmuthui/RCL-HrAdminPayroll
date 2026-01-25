page 51525320 "Recruitment Request"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Recruitment Needs";
    PromotedActionCategories = 'Manage,Process,Report,Approvals,Detailed JD,Email Candidates,Convert To Employee,Attachments';

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = FieldsEditable;
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                }
                field("Job ID"; Rec."Job ID")
                {
                    Editable = FieldsEditable;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    Editable = FieldsEditable;
                }
                field("Appointment Type"; Rec."Appointment Type")
                {
                    Editable = FieldsEditable;
                }
                /*field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                }*/
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Sub Responsibility Center"; Rec."Sub Responsibility Center")
                {
                }
                field("Reporting To"; Rec."Reporting To")
                {
                }
                field("Reporting To(Desc)"; Rec."Reporting To(Desc)")
                {
                    Editable = false;
                }
                field(Location; Rec.Location)
                { }
                field("Reason for Recruitment"; Rec."Reason for Recruitment")
                {
                    Editable = FieldsEditable;
                }
                field(Positions; Rec.Positions)
                { }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Applicable Interviews"; Rec."Applicable Interview(s)")
                {
                }
                field("Budget Status"; Rec."Budget Status")
                { }
                field("Expected Reporting Date"; Rec."Expected Reporting Date")
                {
                    Editable = FieldsEditable;
                    Visible = false;
                }
                field("Job Application URL"; Rec."Job Application URL")
                { }
                field("Requested By"; Rec."Requested By")
                {
                    Editable = false;
                }
                field("Current Stage"; Rec."Current Stage")
                {
                    Enabled = false;
                }
                field(Status; Rec.Status)
                {
                    Enabled = false;
                }
                field("Requires Aptitude Test"; Rec."Requires Aptitude Test")
                {
                    Visible = false;
                }
                field(Advertise; Rec.Advertise)
                {
                    Editable = Rec.Status = Rec.Status::Released;
                }
                field(Closed; Rec.Closed)
                {
                }
                field("JD Attachment"; Rec."Detailed JD Attachment")
                {
                }
            }
            group("Interviews Setup")
            {
                Visible = Rec.Status <> Rec.Status::Open;
                field("Written Interview Venue"; Rec."Written Interview Venue")
                { }
                field("Written Interview DateTime"; Rec."Written Interview DateTime")
                { }
                field("Written Interview Duration"; Rec."Written Interview Duration")
                { }
                field("Written Required Documents"; Rec."Written Required Documents")
                { }
                field("Written Required Materials"; Rec."Written Required Materials")
                { }
                field("Oral Interview Venue"; Rec."Oral Interview Venue")
                { }
                field("Oral Interview DateTime"; Rec."Oral Interview DateTime")
                { }
                field("Oral Interview Duration"; Rec."Oral Interview Duration")
                { }
                field("Oral Required Documents"; Rec."Oral Required Documents")
                { }
                field("Oral Required Materials"; Rec."Oral Required Materials")
                { }
                field("Oral Interview Dress Code"; Rec."Oral Interview Dress Code")
                { }
            }
            group("Email Notifications Sent")
            {
                Visible = Rec.Status <> Rec.Status::Open;
                field("Unshortlisted Emailed"; Rec."Unshortlisted Emailed")
                {
                    Caption = 'Unsuccessful shortlisting';
                }
                field("Unshortlisted Emailed On"; Rec."Unshortlisted Emailed On")
                {
                    Caption = 'Time Sent';
                }
                field("Shortlisted Emailed"; Rec."Shortlisted Emailed")
                {
                    Caption = 'Shortlisted ';
                }
                field("Shortlisted Emailed On"; Rec."Shortlisted Emailed On")
                {
                    Caption = 'Time Sent';
                }
                field("First Interview Emailed"; Rec."First Interview Emailed")
                {
                    Caption = 'Written Interview Invite';
                }
                field("First Interview Emailed On"; Rec."Unshortlisted Emailed On")
                {
                    Caption = 'Time Sent';
                }
                field("Second Interview Inv Emailed"; Rec."Second Interview Inv Emailed")
                {
                    //Caption = 'Unsuccessful shortlisting';
                }
                field("Sec. Interview Inv Emailed On"; Rec."Sec. Interview Inv Emailed On")
                {
                    Caption = 'Time Sent';
                }
                field("Regret Emailed"; Rec."Regret Emailed")
                {
                    //Caption = 'Unsuccessful shortlisting';
                }
                field("Regret Emailed On"; Rec."Regret Emailed On")
                {
                    Caption = 'Time Sent';
                }
                field("Success Emailed"; Rec."Success Emailed")
                {
                    Caption = 'Unsuccessful shortlisting';
                }
                field("Success Emailed On"; Rec."Success Emailed On")
                {
                    Caption = 'Time Sent';
                }
            }
            group("BASIC REQUIREMENTS")
            {
                Caption = 'Basic Requirements';
                Editable = FieldsEditable;
                field("Experience(Yrs)"; Rec."Experience(Yrs)")
                {
                    Editable = FieldsEditable;
                }
                /*field("Total Interview Score"; Rec."Total Interview Score")
                {
                }
                field("Select Top"; Rec."Select Top")
                {
                }
                field("Pass Mark"; Rec."Pass Mark")
                {
                }
                field("Validate Required Attachments"; Rec."Validate Required Attachments")
                {
                }
                field("Validate Prof Documents"; Rec."Validate Prof Documents")
                {
                }*/
                field("Minimum Academic Level"; Rec."Minimum Academic Level")
                {
                }
                field("Other Requirements"; Rec."Other Requirements")
                {
                }
                field("Minimum Academic Level Lk"; Rec."Minimum Academic Level Lk")
                {
                    Visible = false;
                }
                field("Screening Passmark (%)"; Rec."Screening Passmark (%)")
                {
                    Editable = not Rec.Advertise;
                }
            }
            part("Screening Questions"; "Job Screening Questions")
            {
                SubPageLink = "Job No." = field("No.");
                Editable = not Rec.Advertise;
            }
            part("ACADEMIC REQUIREMENTS"; "Needs Requirements")
            {
                Caption = 'Academic Requirements';
                Editable = FieldsEditable;
                SubPageLink = "Need Id" = FIELD("No.");
            }
            part("PROFFESSIONAL BODIES"; "Professional Bodies Needs")
            {
                Caption = 'Proffessional Bodies';
                Editable = FieldsEditable;
                SubPageLink = "Job ID" = FIELD("Job ID");
            }
            part(KPA; "Job Responsiblities")
            {
                Caption = 'Job Responsibilities';
                Editable = FieldsEditable;
                SubPageLink = "Job ID" = FIELD("Job ID");
            }
            part("Mandatory Documents"; "Recruitment Need Docs Mandator")
            {
                Caption = 'Mandatory Documents';
                Editable = FieldsEditable;
                SubPageLink = "Recruitment Need Code" = FIELD("No.");
            }
            part(Skills; "Recruitment Need Skills")
            {
                Caption = 'Skills';
                Editable = FieldsEditable;
                SubPageLink = "Recruitment Need Code" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Action25)
            {
                Caption = 'Detailed JD';
                Visible = true;
                action("Attach Detailed JD")
                {
                    Caption = 'Attach Detailed JD';
                    Image = Documents;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = FieldsEditable;
                    /*RunObject = Page "Portal Attachments";
                    RunPageLink = "DocumentNo." = FIELD("No.");*/

                    trigger OnAction()
                    var
                        OutStr: OutStream;
                        Instr: InStream;
                        DialogTitle: Label 'Please select a file...';
                        TempFileName: Text;
                        FileName: Text;
                    begin
                        IF /*Rec."Detailed JD Attachment".HasValue*/ Rec."JD SharePoint File ID" <> '' THEN begin
                            IF NOT CONFIRM('The detailed JD file already exists. Do you want to replace it?') THEN EXIT;
                            //  SharePointHandler.DeleteFileInSharePointNoTable(Rec."JD SharePoint File ID");
                            Rec."JD Web Url" := '';
                            Rec."Detailed JD FileName" := '';
                        end;
                        UPLOADINTOSTREAM(DialogTitle, '', 'PDF Files (*.pdf)|*.pdf', TempFileName, Instr);
                        IF NOT (TempFileName = '') THEN BEGIN
                            //Rec."Detailed JD Attachment".ImportStream(Instr, TempFileName);
                            //COPYSTREAM(OutStr, Instr);
                            FileName := TempFileName;
                            WHILE STRPOS(FileName, '\') <> 0 DO
                                FileName := COPYSTR(FileName, 1 + STRPOS(FileName, '\'));
                            //  SharePointHandler.UploadFilesToSharePointNoTable(FileName, '', Instr, Rec."JD SharePoint File ID", Rec."JD Web Url");
                            Rec."Detailed JD FileName" := FileName;
                            Rec.MODIFY;
                            MESSAGE('File attached successfully!');
                        END;
                    end;
                }
                action("Detailed JD")
                {
                    Caption = 'Detailed JD';
                    Image = Documents;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    /*RunObject = Page "Portal Attachments";
                    RunPageLink = "DocumentNo." = FIELD("No.");*/

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                        TempBlob: Codeunit "Temp Blob";
                        OutStr: OutStream;
                        Instr: InStream;
                    begin
                        //RecRef.GetTable(Rec);
                        //DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        //DocumentAttachmentDetails.RunModal;
                        /*DocumentAttachmentDetails.SetFilters(FALSE, Rec."No.");
                        DocumentAttachmentDetails.RUNMODAL;*/

                        //TempBlob.CreateOutStream(OutStr);
                        //Rec."Detailed JD Attachment".ExportStream(OutStr);
                        //OutStr.WriteText(Rec."Detailed JD Attachment");
                        //TempBlob.Blob.CreateInStream(Instr);
                        if Rec."JD SharePoint File ID" = '' then
                            Error('File not found!');
                        //   SharePointHandler.DownloadFileFromSharePointNoTable(Rec."JD SharePoint File ID", Rec."Detailed JD FileName");
                        /*if Rec."Detailed JD Attachment".HasValue then begin
                            TempBlob.CreateOutStream(OutStr);
                            Rec."Detailed JD Attachment".ExportStream(OutStr);
                            TempBlob.CreateInStream(Instr);
                            DOWNLOADFROMSTREAM(Instr, '', '', '', Rec."Detailed JD FileName");
                        end else
                            Error('File does not exist!');*/
                    end;
                }
                /*action("Request Related Requirements")
                {
                    Caption = 'Request Related Requirements';
                    RunObject = Page RequestRelatedRequirements;
                    RunPageLink = RecruitmentRequest = FIELD("No.");
                    Visible = false;
                }*/
                action(Responsibilities)
                {
                    Image = Agreement;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "J. Responsiblities";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                }
                /*action("Recruitment Need Matrix")
                {
                    Caption = 'Recruitment Need Matrix';
                    Image = MachineCenter;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Needs Requirements";
                    RunPageLink = "Need Id" = FIELD("No.");
                    Visible = false;
                }
                action(Action7)
                {
                    Caption = 'Recruitment Need Matrix';
                    Image = MachineCenter;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Needs Requirements";
                    RunPageLink = "Need Id" = FIELD("No.");
                    Visible = false;
                }*/
                action(Specification)
                {
                    Image = AgreementQuote;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "J. Specification";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                }
                /*action("Do Oral Interviewers")
                {
                    RunObject = Page "Applicant Interview List";
                    RunPageLink = "Recruitment Code" = FIELD("No.");
                    Visible = false;

                    trigger OnAction()
                    begin

                        //51525435
                    end;
                }*/
            }
            group("Email Candidates")
            {
                Caption = 'Email Candidates';
                Visible = true;

                action("Congratulate Shortlisted")
                {
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        //if not confirm('Are you sure you want to send congratulation emails to shortlisted candidates?') then exit;
                        //Shortlisting stage must have passed
                        if Rec."Current Stage" in [Rec."Current Stage"::"Pending Applications", Rec."Current Stage"::"Receiving Applications", Rec."Current Stage"::Shortlisting] then
                            Error('You can only send this notification after shortlisting. Be sure to move the current stage beyond shortlisting!');

                        if (Rec."Shortlisted Emailed") then begin
                            if not confirm('The successful shortlisting message was already sent on ' + format(Rec."Shortlisted Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange(Shortlist, true);
                        if JobApplicationsTable.Find('-') then begin
                            EmailCandidatesPage.setEmailAction('Congratulate Shortlisted');
                            //EmailCandidatesPage.SetRecord(JobApplicationsTable);
                            EmailCandidatesPage.SetTableView(JobApplicationsTable);
                            EmailCandidatesPage.Run();
                            //Page.Run(PAGE::"Email Candidates", JobApplicationsTable);
                        end else
                            Error('No candidates in this category!');
                        /*if JobApplicationsTable.FindFirst then begin
                            //CompanyInfo.Get();
                            //SenderAddress := CompanyInfo."Administrator Email";
                            //SenderName := CompanyInfo.Name;
                            Window.OPEN('Sending message to #######1');
                            repeat
                                //Body := StrSubstNo('Please find attached');
                                Window.update(1, JobApplicationsTable.ApplicantName);
                                Subject := StrSubstNo('Successfully Shortlisted!');
                                Body := 'Dear ' + JobApplicationsTable.ApplicantName + '<br>';
                                Body := 'I hope this email finds you well. <br><br>You have been successfully shortlisted for the position of ' + Rec.Description + '<br>';
                                ///if (JobApplicationsTable.Shortlist = false) then
                                begin
                                    Subject := StrSubstNo('Unsuccessful Shortlisting');
                                    Body := 'Dear ' + JobApplicationsTable.ApplicantName + '<br>';
                                    Body := 'I hope this email finds you well. <br><br>You have been shortlisted for the position of ' + Rec.Description + '<br>';
                                end;///
                                Body := 'Kindly await further communication from the organization.<br><br>.';
                                Body := 'Best Regards,<br>Recruitment Team.';
                                if JobApplicants.Get(JobApplicationsTable.ApplicantID) then begin
                                    MailSetup.Get();
                                    SMTPSetup.CreateMessage(COMPANYNAME, MailSetup."User ID", JobApplicants."E-Mail", Subject, Body, true);
                                    //SMTPSetup.AddCC(CompanyInfo."HR Support Email");

                                    //CC the others
                                    SecondaryEmailRecipients.Reset();
                                    SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Recruitment Notification");
                                    SecondaryEmailRecipients.SetFilter("E-mail", '<>%1', '');
                                    if SecondaryEmailRecipients.FindSet() then
                                        repeat
                                            Window.update(1, SecondaryEmailRecipients.Name);
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::"Send to" then
                                                SMTPSetup.AddRecipients(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::cc then
                                                SMTPSetup.AddCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::bcc then
                                                SMTPSetup.AddBCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                        until SecondaryEmailRecipients.next() = 0;

                                    SMTPSetup.AppendBody('<br><br><em>This is a system generated email. Please do not reply.</em>');
                                    SMTPSetup.Send;
                                    //message('Email configurations not done!');
                                end;
                                JobApplicationsTable."Shortlisted Emailed" := true;
                                JobApplicationsTable.Modify();
                            until JobApplicationsTable.next = 0;
                            Rec."Shortlisted Emailed" := true;
                            Rec."Shortlisted Emailed On" := CREATEDATETIME(TODAY, TIME);
                            Rec.Modify();
                            Message('Message(s) sent successfully!');
                            Window.close();
                            //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end;*/
                    end;
                }
                action("Regret Unshortlisted")
                {
                    Caption = 'Regret to Not Shortlisted';
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        skipEntry: Boolean;
                    begin
                        //if not confirm('Are you sure you want to send regret emails to candidates who were not shortlisted?') then exit;
                        //Shortlisting stage must have passed
                        if Rec."Current Stage" in [Rec."Current Stage"::"Pending Applications", Rec."Current Stage"::"Receiving Applications", Rec."Current Stage"::Shortlisting] then
                            Error('You can only send this notification after shortlisting. Be sure to move the current stage beyond shortlisting!');

                        if (Rec."Unshortlisted Emailed") then begin
                            if not confirm('The shortlisting regret message was already sent on ' + format(Rec."Unshortlisted Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange(Shortlist, false);
                        if JobApplicationsTable.Find('-') then begin
                            EmailCandidatesPage.setEmailAction('Regret Unshortlisted');
                            //EmailCandidatesPage.SetRecord(JobApplicationsTable);
                            EmailCandidatesPage.SetTableView(JobApplicationsTable);
                            EmailCandidatesPage.Run();
                            //Page.Run(PAGE::"Email Candidates", JobApplicationsTable);
                        end else
                            Error('No candidates in this category!');
                        /*if JobApplicationsTable.FindFirst then begin
                            //CompanyInfo.Get();
                            //SenderAddress := CompanyInfo."Administrator Email";
                            //SenderName := CompanyInfo.Name;
                            Window.OPEN('Sending message to #######1');
                            repeat
                                //Body := StrSubstNo('Please find attached');
                                ///skipEntry := false;
                                if JobApplicationsTable."Unshortlisted Emailed" = true then
                                begin
                                    if not confirm('Candidate ')
                                end;///
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
                                    MailSetup.Get();
                                    SMTPSetup.CreateMessage(COMPANYNAME, MailSetup."User ID", JobApplicants."E-Mail", Subject, Body, true);
                                    //SMTPSetup.AddCC(CompanyInfo."HR Support Email");

                                    //CC the others
                                    SecondaryEmailRecipients.Reset();
                                    SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Recruitment Notification");
                                    SecondaryEmailRecipients.SetFilter("E-mail", '<>%1', '');
                                    if SecondaryEmailRecipients.FindSet() then
                                        repeat
                                            Window.update(1, SecondaryEmailRecipients.Name);
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::"Send to" then
                                                SMTPSetup.AddRecipients(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::cc then
                                                SMTPSetup.AddCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::bcc then
                                                SMTPSetup.AddBCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                        until SecondaryEmailRecipients.next() = 0;

                                    SMTPSetup.AppendBody('<br><br><em>This is a system generated email. Please do not reply.</em>');
                                    SMTPSetup.Send;
                                    //message('Email configurations not done!');
                                end;
                                JobApplicationsTable."Unshortlisted Emailed" := true;
                                JobApplicationsTable.Modify();
                            until JobApplicationsTable.next = 0;
                            Message('Message(s) sent successfully!');
                            Window.close();
                            Rec."Unshortlisted Emailed" := true;
                            Rec."Unshortlisted Emailed On" := CREATEDATETIME(TODAY, TIME);
                            Rec.Modify();
                            //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end;*/
                    end;
                }
                action("First Interview Invite")
                {
                    Caption = 'Written Interview Invite';
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        skipEntry: Boolean;
                    begin
                        if (Rec."Written Interview Venue" = '') or (Rec."Written Interview DateTime" = CreateDateTime(0D, 0T)) or (Rec."Written Interview Duration" = 0) then
                            Error('You must set the written interview venue and date & time, and duration first!');
                        //Written Interview Duration
                        //if not confirm('Are you sure you want to send written interview invites?') then exit;
                        //Shortlisting stage must have passed
                        if Rec."Current Stage" <> Rec."Current Stage"::"First Interview" then
                            Error('You can only send written interview invites when the current stage is First Interview!');

                        if (Rec."First Interview Emailed") then begin
                            if not confirm('The written interview invite was already sent on ' + format(Rec."First Interview Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange(Shortlist, true);
                        if JobApplicationsTable.Find('-') then begin
                            EmailCandidatesPage.setEmailAction('First Interview Invite');
                            //EmailCandidatesPage.SetRecord(JobApplicationsTable);
                            EmailCandidatesPage.SetTableView(JobApplicationsTable);
                            EmailCandidatesPage.Run();
                            //Page.Run(PAGE::"Email Candidates", JobApplicationsTable);
                        end else
                            Error('No candidates in this category!');
                        /*if JobApplicationsTable.FindFirst then begin
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
                                '<p><ul><li>Interview Date & Time: ' + FORMAT(Rec."Written Interview DateTime") + '</li>' +
                                '<li>Venue: ' + Rec."Written Interview Venue" + '</li></ul> +</p>' +
                                '<p>Kindly remember to carry all the necessary documents.</p>' +
                                '<p>Best regards,</p>' +
                                '<p>Recruitment Team</p>';

                                if JobApplicants.Get(JobApplicationsTable.ApplicantID) then begin
                                    MailSetup.Get();
                                    SMTPSetup.CreateMessage(COMPANYNAME, MailSetup."User ID", JobApplicants."E-Mail", Subject, Body, true);
                                    //SMTPSetup.AddCC(CompanyInfo."HR Support Email");

                                    //CC the others
                                    SecondaryEmailRecipients.Reset();
                                    SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Recruitment Notification");
                                    SecondaryEmailRecipients.SetFilter("E-mail", '<>%1', '');
                                    if SecondaryEmailRecipients.FindSet() then
                                        repeat
                                            Window.update(1, SecondaryEmailRecipients.Name);
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::"Send to" then
                                                SMTPSetup.AddRecipients(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::cc then
                                                SMTPSetup.AddCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::bcc then
                                                SMTPSetup.AddBCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                        until SecondaryEmailRecipients.next() = 0;

                                    SMTPSetup.AppendBody('<br><br><em>This is a system generated email. Please do not reply.</em>');
                                    SMTPSetup.Send;
                                    //message('Email configurations not done!');
                                end;
                                JobApplicationsTable."Written Interview Emailed" := true;
                                JobApplicationsTable.Modify();
                            until JobApplicationsTable.next = 0;
                            Message('Message(s) sent successfully!');
                            Window.close();
                            Rec."First Interview Emailed" := true;
                            Rec."First Interview Emailed On" := CREATEDATETIME(TODAY, TIME);
                            Rec.Modify();
                            //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end;*/
                    end;
                }
                action("Second Interview Invite - No Exam")
                {
                    Caption = 'Oral Interview Invite - No Exam';
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        skipEntry: Boolean;
                    begin
                        if Rec."Oral Interview Venue" = '' then
                            Error('You must set the oral interview venue and date & time first!');
                        //if not confirm('Are you sure you want to send oral interview invites?') then exit;
                        //Shortlisting stage must have passed
                        if Rec."Current Stage" <> Rec."Current Stage"::"Second Interview" then
                            Error('You can only send oral interview invites when the current stage is Second Interview!');

                        if (Rec."Second Interview Inv Emailed") then begin
                            if not confirm('The oral interview invite was already sent on ' + format(Rec."Sec. Interview Inv Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange("Passed Due Diligence", true);
                        if JobApplicationsTable.Find('-') then begin
                            EmailCandidatesPage.setEmailAction('Second Interview Invite - No Exam');
                            //EmailCandidatesPage.SetRecord(JobApplicationsTable);
                            EmailCandidatesPage.SetTableView(JobApplicationsTable);
                            EmailCandidatesPage.Run();
                            //Page.Run(PAGE::"Email Candidates", JobApplicationsTable);
                        end;
                    end;
                }
                action("Second Interview Invite - Passed Exam")
                {
                    Caption = 'Oral Interview Invite - Passed Exam';
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        skipEntry: Boolean;
                    begin
                        if Rec."Oral Interview Venue" = '' then
                            Error('You must set the oral interview venue and date & time first!');
                        //if not confirm('Are you sure you want to send oral interview invites?') then exit;
                        //Shortlisting stage must have passed
                        if Rec."Current Stage" <> Rec."Current Stage"::"Second Interview" then
                            Error('You can only send oral interview invites when the current stage is Second Interview!');

                        if (Rec."Second Interview Inv Emailed") then begin
                            if not confirm('The oral interview invite was already sent on ' + format(Rec."Sec. Interview Inv Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange("Passed First Interview", true);
                        JobApplicationsTable.SetRange("Passed Due Diligence", true);
                        if JobApplicationsTable.Find('-') then begin
                            EmailCandidatesPage.setEmailAction('Second Interview Invite - Passed Exam');
                            //EmailCandidatesPage.SetRecord(JobApplicationsTable);
                            EmailCandidatesPage.SetTableView(JobApplicationsTable);
                            EmailCandidatesPage.Run();
                            //Page.Run(PAGE::"Email Candidates", JobApplicationsTable);
                        end else
                            Error('No candidates in this category!');
                    end;
                }
                action("Vetting Regret")
                {
                    Caption = 'Vetting Regret';
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        skipEntry: Boolean;
                    begin
                        //if not confirm('Are you sure you want to send regret emails to candidates who were not shortlisted?') then exit;
                        //Shortlisting stage must have passed
                        if Rec."Current Stage" in [Rec."Current Stage"::"Pending Applications", Rec."Current Stage"::"Receiving Applications", Rec."Current Stage"::Shortlisting] then
                            Error('You can only send this notification after shortlisting. Be sure to move the current stage beyond shortlisting!');

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange("Passed Due Diligence", false);
                        if JobApplicationsTable.Find('-') then begin
                            EmailCandidatesPage.setEmailAction('Vetting Regret');
                            //EmailCandidatesPage.SetRecord(JobApplicationsTable);
                            EmailCandidatesPage.SetTableView(JobApplicationsTable);
                            EmailCandidatesPage.Run();
                            //Page.Run(PAGE::"Email Candidates", JobApplicationsTable);
                        end else
                            Error('No candidates in this category!');
                    end;
                }

                action("General Regret")
                {
                    Caption = 'General Regret';
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        skipEntry: Boolean;
                    begin
                        //if not confirm('Are you sure you want to send regret emails to the unsuccessful candidates?') then exit;
                        //Shortlisting stage must have passed
                        if Rec."Current Stage" <> Rec."Current Stage"::Completed then
                            Error('You can only send this notification after completing the whole review process. Be sure to move the current stage to completed!');

                        if (Rec."Regret Emailed") then begin
                            if not confirm('The regret message was already sent on ' + format(Rec."Regret Emailed On") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange("Passed Second Interview", false);
                        if JobApplicationsTable.Find('-') then begin
                            EmailCandidatesPage.setEmailAction('General Regret');
                            //EmailCandidatesPage.SetRecord(JobApplicationsTable);
                            EmailCandidatesPage.SetTableView(JobApplicationsTable);
                            EmailCandidatesPage.Run();
                            //Page.Run(PAGE::"Email Candidates", JobApplicationsTable);
                        end else
                            Error('No candidates in this category!');
                        /*if JobApplicationsTable.FindFirst then begin
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
                                end;///
                                Window.update(1, JobApplicationsTable.ApplicantName);
                                Subject := StrSubstNo('Job Application Update');

                                Body :=
                                '<p>Dear ' + JobApplicationsTable.ApplicantName + ',</p>' +
                                '<p>We trust this email notification finds you well.</p>' +
                                '<p>It was a pleasure meeting with you to discuss employment opportunities for the' + JobApplicationsTable.JobDescription + ' position in our firm.</p>' +
                                '<p>We have now considered all the candidates against the criteria we had set out for the role. The decision was not an easy one as the overall standards of all the candidates were high. Your credentials were specifically very impressive. However, after careful consideration we regret to inform you that they did not match up exactly with what we were seeking.</p>' +
                                '<p>Thank you for showing interest in working with us. We encourage to keep visiting the careers website for future roles as we wish you all the best in your future endeavors.</p>' +
                                '<p>Best regards,</p>' +
                                '<p>Recruitment Team</p>';

                                if JobApplicants.Get(JobApplicationsTable.ApplicantID) then begin
                                    MailSetup.Get();
                                    SMTPSetup.CreateMessage(COMPANYNAME, MailSetup."User ID", JobApplicants."E-Mail", Subject, Body, true);
                                    //SMTPSetup.AddCC(CompanyInfo."HR Support Email");

                                    //CC the others
                                    SecondaryEmailRecipients.Reset();
                                    SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Recruitment Notification");
                                    SecondaryEmailRecipients.SetFilter("E-mail", '<>%1', '');
                                    if SecondaryEmailRecipients.FindSet() then
                                        repeat
                                            Window.update(1, SecondaryEmailRecipients.Name);
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::"Send to" then
                                                SMTPSetup.AddRecipients(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::cc then
                                                SMTPSetup.AddCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::bcc then
                                                SMTPSetup.AddBCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                        until SecondaryEmailRecipients.next() = 0;

                                    SMTPSetup.AppendBody('<br><br><em>This is a system generated email. Please do not reply.</em>');
                                    SMTPSetup.Send;
                                    //message('Email configurations not done!');
                                end;
                                JobApplicationsTable."Regret Emailed" := true;
                                JobApplicationsTable.Modify();
                            until JobApplicationsTable.next = 0;
                            Message('Message(s) sent successfully!');
                            Window.close();
                            Rec."Regret Emailed" := true;
                            Rec."Regret Emailed On" := CREATEDATETIME(TODAY, TIME);
                            Rec.Modify();
                            //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end;*/
                    end;
                }
                action("Congratulate Successful")
                {
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                    begin
                        if not confirm('Are you sure you want to send congratulation emails to successful candidate(s)') then exit;
                        //Shortlisting stage must have passed
                        if Rec."Current Stage" <> Rec."Current Stage"::Completed then
                            Error('You can only send this notification after completing the whole review process. Be sure to move the current stage to completed!');

                        if (Rec."Success Emailed") then begin
                            if not confirm('The success message was already sent on ' + format(Rec."Success Emailed") + '. Do you still want to send?') then
                                Error('Process aborted!');
                        end;

                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange(Submitted, true);
                        JobApplicationsTable.SetRange(Successful, true);//"Passed Second Interview"
                        if JobApplicationsTable.Find('-') then begin
                            EmailCandidatesPage.setEmailAction('Congratulate Successful');
                            //EmailCandidatesPage.SetRecord(JobApplicationsTable);
                            EmailCandidatesPage.SetTableView(JobApplicationsTable);
                            EmailCandidatesPage.Run();
                            //Page.Run(PAGE::"Email Candidates", JobApplicationsTable);
                        end else
                            Error('No candidates in this category!');
                        /*if JobApplicationsTable.FindFirst then begin
                            //CompanyInfo.Get();
                            //SenderAddress := CompanyInfo."Administrator Email";
                            //SenderName := CompanyInfo.Name;
                            Window.OPEN('Sending message to #######1');
                            repeat
                                //Body := StrSubstNo('Please find attached');
                                Window.update(1, JobApplicationsTable.ApplicantName);
                                Subject := StrSubstNo('Congratulations!');
                                Body := 'Dear ' + JobApplicationsTable.ApplicantName + '<br>';
                                Body := 'I hope this email finds you well. <br><br>We have completed the review of applications for the ' + Rec.Description + ' position and we are pleased to inform you that you have qualified for the position.<br>';
                                Body := 'Kindly await further communication from the organization.<br><br>.';
                                Body := 'Best Regards,<br>Recruitment Team.';
                                if JobApplicants.Get(JobApplicationsTable.ApplicantID) then begin
                                    MailSetup.Get();
                                    SMTPSetup.CreateMessage(COMPANYNAME, MailSetup."User ID", JobApplicants."E-Mail", Subject, Body, true);
                                    //SMTPSetup.AddCC(CompanyInfo."HR Support Email");

                                    //CC the others
                                    SecondaryEmailRecipients.Reset();
                                    SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Recruitment Notification");
                                    SecondaryEmailRecipients.SetFilter("E-mail", '<>%1', '');
                                    if SecondaryEmailRecipients.FindSet() then
                                        repeat
                                            Window.update(1, SecondaryEmailRecipients.Name);
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::"Send to" then
                                                SMTPSetup.AddRecipients(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::cc then
                                                SMTPSetup.AddCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                            if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::bcc then
                                                SMTPSetup.AddBCC(DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                                        until SecondaryEmailRecipients.next() = 0;

                                    SMTPSetup.AppendBody('<br><br><em>This is a system generated email. Please do not reply.</em>');
                                    SMTPSetup.Send;
                                    //message('Email configurations not done!');
                                end;
                                JobApplicationsTable."Success Emailed" := true;
                                JobApplicationsTable.Modify();
                            until JobApplicationsTable.next = 0;
                            Rec."Success Emailed" := true;
                            Rec."Success Emailed On" := CREATEDATETIME(TODAY, TIME);
                            Rec.Modify();
                            Message('Message(s) sent successfully!');
                            Window.close();
                            //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end;*/
                    end;
                }
                action("Letter of Regret")
                {
                    Caption = 'Letter of Regret';
                    Enabled = false;
                    Visible = false;//LetterSending;

                    trigger OnAction()
                    begin
                        Message('GREAT');
                    end;
                }
                /*action("Letter of Success")
                {
                    Caption = 'Letter of Success';
                    Visible = false;//LetterSending;

                    trigger OnAction()
                    begin
                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                        JobApplicationsTable.SetRange("Offer Letter of Appointment", true);
                        if JobApplicationsTable.FindFirst then begin
                            CompanyInfo.Get();
                            SenderAddress := '';//CompanyInfo."Administrator Email";
                            //ERROR('...........%1',SenderAddress);
                            SenderName := CompanyInfo.Name;
                            Subject := StrSubstNo('Letter of Success');
                            Body := StrSubstNo('Please find attached');
                            if JobApplicants.Get(JobApplicationsTable.ApplicantID) then begin
                                SMTPSetup.CreateMessage(SenderName, SenderAddress, JobApplicants."E-Mail", Subject, Body, true);
                                FileName := FileMangement.ServerTempFileName('.pdf');
                                REPORT.SaveAsPdf(REPORT::"Letter of Success", FileName, JobApplicants);
                                SMTPSetup.AddAttachment(FileName, '');
                                //SMTPSetup.AddCC(CompanyInfo."HR Support Email");
                                SMTPSetup.Send;
                            end;
                            Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                        end else begin

                        end;
                    end;
                }*/
                action("Positions Reporting to Job Holder")
                {
                    Caption = 'Positions Reporting to Job Holder';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "J. Position Supervised";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                    Visible = false;
                }
                action("Job Specification")
                {
                    Caption = 'Job Specification';
                    Image = Description;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "J. Specification";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                    Visible = false;
                }
                action("Key Responsibilities")
                {
                    Caption = 'Key Responsibilities';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "J. Responsiblities";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                    Visible = false;
                }
                action("Working Relationships")
                {
                    Caption = 'Working Relationships';
                    Image = Relationship;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "J. Responsiblities";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                    Visible = false;
                }
            }
            group("Employee Creation")
            {
                Caption = 'Employee Creation';
                Visible = false;
            }
            action("Convert To Employee")
            {
                Caption = 'Employ and Onboard Succesful Candidate(s)';
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //Visible = false;
                RunObject = Page "Successful Candidates";
                RunPageLink = "Recruitment Need Code" = FIELD("No.");//, Successful = CONST(true);
                /*trigger OnAction()
                var
                    Applicants: Record "Job Applicants";
                    Applicants2: Record "Job Applicants";
                begin

                    JobApplicationsTable.Reset;
                    JobApplicationsTable.SetRange("Recruitment Need Code", "No.");
                    JobApplicationsTable.SetRange(Successful, true);
                    if JobApplicationsTable.FindFirst then begin
                        if Confirm('Are You Sure You Want To Convert  ' + JobApplicationsTable.ApplicantName + '  As Employee?', false) = true then begin
                            Applicants.EmployApplicant(JobApplicationsTable, "Job ID", Description, "Job ID");
                        end else begin
                            Message('No candidate Found.');

                        end;
                    end;
                end;*/
            }
        }
        area(processing)
        {
            action("View Applicants")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Job Applications List";
                RunPageLink = "Recruitment Need Code" = FIELD("No.");
                Visible = true;
            }
            action("View Applicants_")
            {
                Caption = 'View Shortlisted Applicants';
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Job Applications List";
                RunPageLink = "Recruitment Need Code" = FIELD("No."),
                              "Shortlist" = CONST(true);
                Visible = true;
            }
            action("Job Interviewers")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Job Interviewers List";
                RunPageLink = "Recruitment Need" = FIELD("No.");
                Visible = true;

                trigger OnAction()
                begin

                    //51525438
                end;
            }

            action("Update Multiple Candidates")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Update Multiple Candidates";
                RunPageLink = "Recruitment Need Code" = FIELD("No.");
            }

            action("Process Screening")
            {
                Caption = 'Process Screening Results';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = /*(Rec.Advertise) and*/ (Rec."Current Stage" = Rec."Current Stage"::Shortlisting);
                trigger OnAction()
                var
                    ApplicationResponses: Record "Application Screening Response";
                    ApplicationMultiChoiceAnswers: Record "Application Multichoice Answer";
                    jobApplicationsList: Record "Job Applications";
                    TotalWeight: Decimal;
                    TotalCandidateScore: Decimal;
                    CandidatePercentageScore: Decimal;
                    LowerBound: Decimal;
                    UpperBound: Decimal;
                    ProvidedAnswerDec: Decimal;
                    RangeParts: List of [Text];
                begin
                    //"Screening Processed"
                    if (Rec."Current Stage" <> Rec."Current Stage"::Shortlisting) then
                        Error('You can only process screening results when in the shortlisting stage!');

                    Window.OPEN('Sending message to #######1');
                    jobApplicationsList.Reset();
                    jobApplicationsList.SetRange("Recruitment Need Code", Rec."No.");
                    jobApplicationsList.SetRange(Submitted, true);
                    if jobApplicationsList.findset then
                        repeat
                            Window.update(1, jobApplicationsList.ApplicantName);
                            TotalWeight := 0;
                            TotalCandidateScore := 0;
                            CandidatePercentageScore := 0;

                            ApplicationResponses.Reset();
                            ApplicationResponses.SetRange("Application No.", jobApplicationsList.ApplicationNo);
                            if ApplicationResponses.FindSet() then
                                repeat
                                    TotalWeight += ApplicationResponses.Weight;
                                    if (ApplicationResponses."Response Type" = ApplicationResponses."Response Type"::"Yes/No") or (ApplicationResponses."Response Type" = ApplicationResponses."Response Type"::Text) then begin
                                        if UpperCase(Format(ApplicationResponses."Provided Answer")) = UpperCase(ApplicationResponses."Expected Answer") then
                                            TotalCandidateScore += ApplicationResponses.Weight;
                                    end;

                                    if ApplicationResponses."Response Type" = ApplicationResponses."Response Type"::Numeric then begin
                                        if Format(ApplicationResponses."Provided Answer") = ApplicationResponses."Expected Answer" then
                                            TotalCandidateScore += ApplicationResponses.Weight;
                                    end;

                                    if ApplicationResponses."Response Type" = ApplicationResponses."Response Type"::Range then begin
                                        LowerBound := 0;
                                        UpperBound := 0;
                                        ProvidedAnswerDec := 0;
                                        Evaluate(ProvidedAnswerDec, Format(ApplicationResponses."Provided Answer"));
                                        Clear(RangeParts);
                                        RangeParts := ApplicationResponses."Expected Answer".Split('..');
                                        if RangeParts.Count = 2 then begin
                                            Evaluate(LowerBound, RangeParts.Get(1));
                                            Evaluate(UpperBound, RangeParts.Get(2));
                                        end;
                                        if (ProvidedAnswerDec >= LowerBound) and (ProvidedAnswerDec <= UpperBound) then
                                            TotalCandidateScore += ApplicationResponses.Weight;
                                    end;

                                    if ApplicationResponses."Response Type" = ApplicationResponses."Response Type"::"Multiple Choice" then begin
                                        ApplicationMultiChoiceAnswers.Reset();
                                        ApplicationMultiChoiceAnswers.SetRange("Application No.", jobApplicationsList.ApplicationNo);
                                        ApplicationMultiChoiceAnswers.SetRange("Question Entry No.", ApplicationResponses."Question No.");
                                        ApplicationMultiChoiceAnswers.SetRange("Candidate Selected", true);
                                        ApplicationMultiChoiceAnswers.SetRange("Is Correct", true);
                                        if ApplicationMultiChoiceAnswers.FindFirst() then
                                            TotalCandidateScore += ApplicationResponses.Weight;
                                    end;
                                until ApplicationResponses.Next() = 0;
                            if TotalWeight = 0 then begin
                                jobApplicationsList."Screening Score (%)" := 0;
                                jobApplicationsList."Screening Score (%)" := Rec."Screening Passmark (%)";
                                jobApplicationsList."Screening Outcome" := jobApplicationsList."Screening Outcome"::Pass;
                                jobApplicationsList.Shortlist := true;
                                jobApplicationsList.Shortlisted := true;
                                jobApplicationsList."Not Shortlisted" := false;
                            end else begin
                                CandidatePercentageScore := (TotalCandidateScore / TotalWeight) * 100;
                                jobApplicationsList."Screening Score (%)" := CandidatePercentageScore;
                                jobApplicationsList."Screening Score (%)" := Rec."Screening Passmark (%)";
                                jobApplicationsList."Screening Outcome" := jobApplicationsList."Screening Outcome"::Fail;
                                jobApplicationsList.Shortlist := false;
                                jobApplicationsList.Shortlisted := false;
                                jobApplicationsList."Not Shortlisted" := true;
                                if CandidatePercentageScore < Rec."Screening Passmark (%)" then begin
                                    jobApplicationsList."Screening Outcome" := jobApplicationsList."Screening Outcome"::Pass;
                                    jobApplicationsList.Shortlist := true;
                                    jobApplicationsList.Shortlisted := true;
                                    jobApplicationsList."Not Shortlisted" := false;
                                end;
                            end;
                            jobApplicationsList.modify();
                        until jobApplicationsList.next = 0;
                    Window.Close();

                    Rec."Screening Processed" := true;
                    Rec.Modify();
                    Message('Screening results processed and successful candidates marked as shortlisted. Kindly proceed to review the short list then process the Shortlisting stage.');
                end;
            }

            action("Move to Next Stage")
            {
                Caption = 'Process Current Stage';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    NextStage: Option "Pending Applications","Receiving Applications",Shortlisting,"First Interview","Due Diligence","Second Interview",Completed;
                    SkipBool: Boolean;
                    NoFirstInterview: Boolean;
                begin
                    SkipBool := false;
                    NoFirstInterview := false;
                    if Rec."Applicable Interview(s)" = Rec."Applicable Interview(s)"::Oral then
                        NoFirstInterview := true;

                    //Code to process stage
                    if (Rec."Current Stage" = Rec."Current Stage"::"Pending Applications") then begin
                        if (Rec."Start Date" > TODAY) then
                            Error('The job cannot be updated as published before its start date!');
                        if (Rec."End Date" >= TODAY) then begin
                            if not confirm('Are you sure you want update this job as published and receiving applications?') then exit;
                            Rec."Current Stage" := Rec."Current Stage"::"Receiving Applications";
                            Rec.Modify();
                            SkipBool := true;
                        end else begin
                            //In case the said date has passed - we'll still update but without confirmation
                            Rec."Current Stage" := Rec."Current Stage"::"Receiving Applications";
                            Rec.Modify();
                        end;
                    end;

                    if not SkipBool then begin
                        if (Rec."End Date" >= TODAY) then
                            Error('You cannot start processing applications until the end date is surpassed!');

                        if (Rec."Current Stage" = Rec."Current Stage"::"Receiving Applications") then
                            NextStage := NextStage::Shortlisting;
                        //if (Rec."Current Stage" = Rec."Current Stage"::Shortlisting) and (not "Screening Processed") then
                        //Error('Kindly Process Screening Results before processing the shortlisting stage!');

                        if (Rec."Current Stage" = Rec."Current Stage"::Shortlisting) then begin
                            NextStage := NextStage::"First Interview";
                            if NoFirstInterview then
                                NextStage := NextStage::"Due Diligence";
                        end;
                        if (Rec."Current Stage" = Rec."Current Stage"::"First Interview") then
                            NextStage := NextStage::"Due Diligence";
                        if (Rec."Current Stage" = Rec."Current Stage"::"Due Diligence") then
                            NextStage := NextStage::"Second Interview";
                        if (Rec."Current Stage" = Rec."Current Stage"::"Second Interview") then
                            NextStage := NextStage::Completed;

                        //if not (confirm('The job is now in the ' + format(Rec."Current Stage") + ' stage. Are you sure you want to process it and move to the ' + format(NextStage) + ' stage?')) then exit;
                        if NextStage = NextStage::Completed then begin
                            if not (confirm('The job is now in the ' + format(Rec."Current Stage") + ' stage. Are you sure you want to process it and complete the process in readiness for onboarding!')) then
                                exit;
                        end else begin
                            if Rec."Current Stage" = Rec."Current Stage"::Completed then
                                Error('This job has already been processed to completion!')
                            else
                                if not (confirm('The job is now in the ' + format(Rec."Current Stage") + ' stage. Are you sure you want to process it and move to the ' + format(NextStage) + ' stage?')) then exit;
                        end;

                        processApplication(NextStage, Rec."No.", NoFirstInterview);

                        //If shortlisting stage
                        /*if (Rec."Current Stage" = Rec."Current Stage"::Shortlisting) then begin
                            if not (confirm('Being the shortlisting stage, would you like to send the regret and success notifications to applicants?')) then exit;

                            JobApplicationsTable.Reset;
                            JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                            JobApplicationsTable.SetRange(Submitted, true);
                            JobApplicationsTable.SetRange(Shortlist, true);
                            if JobApplicationsTable.FindFirst then begin
                                CompanyInfo.Get();
                                SenderAddress := CompanyInfo."Administrator Email";
                                SenderName := CompanyInfo.Name;
                                repeat
                                    //Body := StrSubstNo('Please find attached');
                                    Subject := StrSubstNo('Successfully Shortlisted!');
                                    Body := 'Dear ' + JobApplicationsTable.ApplicantName + '<br>';
                                    Body := 'I hope this email finds you well. <br><br>You have been shortlisted for the position of ' + Rec.Description + '<br>';
                                    /*if (JobApplicationsTable.Shortlist = false) then
                                    begin
                                        Subject := StrSubstNo('Unsuccessful Shortlisting');
                                        Body := 'Dear ' + JobApplicationsTable.ApplicantName + '<br>';
                                        Body := 'I hope this email finds you well. <br><br>You have been shortlisted for the position of ' + Rec.Description + '<br>';
                                    end;////
                                    Body := 'Kindly await further communication from the organization.<br><br>.';
                                    Body := 'For any enquiries kindly contact the undersigned!<br><br> Kind Regards.';
                                    if JobApplicants.Get(JobApplicationsTable.ApplicantID) then begin
                                        SMTPSetup.CreateMessage(SenderName, SenderAddress, JobApplicants."E-Mail", Subject, Body, true);
                                        /*FileName := FileMangement.ServerTempFileName('.pdf');
                                        REPORT.SaveAsPdf(REPORT::"Letter of Success", FileName, JobApplicants);
                                        SMTPSetup.AddAttachment(FileName, '');/////
                                        //SMTPSetup.AddCC(CompanyInfo."HR Support Email");
                                        SMTPSetup.Send;
                                        //message('Email configurations not done!');
                                    end;
                                until JobApplicationsTable.next = 0;
                                //Message('Offer Letter Sent To %1 Successfully!!!', JobApplicationsTable.ApplicantName);
                            end;
                        end;*/
                        Rec."Current Stage" := NextStage;
                    end;
                    Message('Operation successful. The job is now in the %1 stage!', Rec."Current Stage");
                end;
            }
            action("Return to Previous Stage")
            {
                Caption = 'Return to Previous Stage';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;
                Image = Undo;

                trigger OnAction()
                var
                    PrevStage: Option "Pending Applications","Receiving Applications",Shortlisting,"First Interview","Due Diligence","Second Interview",Completed;
                    NoFirstInterview: Boolean;
                begin
                    NoFirstInterview := false;
                    if Rec."Applicable Interview(s)" = Rec."Applicable Interview(s)"::Oral then
                        NoFirstInterview := true;

                    if (Rec."Current Stage" = Rec."Current Stage"::"Pending Applications") then
                        Error('This is the initial stage!')
                    else if (Rec."Current Stage" = Rec."Current Stage"::"Receiving Applications") then begin
                        if not confirm('Are you sure you want to go back to the "Pending Applications" stage?') then exit;
                        PrevStage := PrevStage::"Pending Applications";
                        Rec."Current Stage" := Rec."Current Stage"::"Pending Applications";
                        Rec.Modify();
                    end else if (Rec."Current Stage" = Rec."Current Stage"::Shortlisting) then begin
                        if not confirm('Are you sure you want to go back to the "Receiving Applications" stage?') then exit;
                        Rec."Current Stage" := Rec."Current Stage"::"Receiving Applications";
                        PrevStage := PrevStage::"Receiving Applications";
                        Rec.Modify();
                    end else if (Rec."Current Stage" = Rec."Current Stage"::"First Interview") then begin
                        if not confirm('Are you sure you want to go back to the "Shortlisting" stage?') then exit;
                        Rec."Current Stage" := Rec."Current Stage"::Shortlisting;
                        PrevStage := PrevStage::Shortlisting;
                        Rec.Modify();
                    end else if (Rec."Current Stage" = Rec."Current Stage"::"Due Diligence") and NoFirstInterview then begin
                        if not confirm('Are you sure you want to go back to the "Shortlisting" stage?') then exit;
                        Rec."Current Stage" := Rec."Current Stage"::Shortlisting;
                        PrevStage := PrevStage::Shortlisting;
                        Rec.Modify();
                    end else if (Rec."Current Stage" = Rec."Current Stage"::"Due Diligence") and (not NoFirstInterview) then begin
                        if not confirm('Are you sure you want to go back to the "First Interview" stage?') then exit;
                        Rec."Current Stage" := Rec."Current Stage"::"First Interview";
                        PrevStage := PrevStage::"First Interview";
                        Rec.Modify();
                    end else if (Rec."Current Stage" = Rec."Current Stage"::"Second Interview") then begin
                        if not confirm('Are you sure you want to go back to the "Due Diligence" stage?') then exit;
                        Rec."Current Stage" := Rec."Current Stage"::"Due Diligence";
                        PrevStage := PrevStage::"Due Diligence";
                        Rec.Modify();
                    end else if (Rec."Current Stage" = Rec."Current Stage"::Completed) then begin
                        if not confirm('Are you sure you want to go back to the "Second Interview" stage?') then exit;
                        Rec."Current Stage" := Rec."Current Stage"::"Second Interview";
                        PrevStage := PrevStage::"Second Interview";
                        Rec.Modify();
                    end else
                        Error('Stage not found!');
                    processApplication(PrevStage, Rec."No.", NoFirstInterview);
                    Message('Operation successful!');
                end;
            }
            action("View Job Report")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = Report "Job Report";
                Visible = true;

                trigger OnAction()
                var
                    ReqNeed: Record "Recruitment Needs";
                begin
                    ReqNeed.Reset;
                    ReqNeed.SetRange(ReqNeed."No.", Rec."No.");
                    if ReqNeed.FindFirst() then begin
                        REPORT.Run(Report::"Job Report", true, true, ReqNeed);
                    end;
                end;
            }
            /*action("Oral Interview Test")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Job Interview List";
                RunPageLink = "Recruitment No." = FIELD("No."),
                              "Interview Type" = CONST("Oral Interview");
                Visible = false;
            }
            action("Start Oral Interview")
            {
                Image = Start;
                Visible = false;

                trigger OnAction()
                var
                    ApplicantInterviewTable: Record "Applicant Interview Table";
                    ApplicantInterviewLines: Record "Applicant Interview Lines";
                    Interviewers: Record "Job Interviewers";
                    JobApplicationsTable: Record "Job Applications";
                    JobInterviewList: Record "Job Interview List";
                    testnumbers: Integer;
                    appnumber: Integer;
                    ApplicantInterview: Record "Applicant Interview Table";
                begin
                    testnumbers := 200;
                    appnumber := 100;
                    ApplicantInterview.SetCurrentKey(Code);
                    ApplicantInterview.Ascending(false);
                    if ApplicantInterview.FindFirst then begin
                        appnumber := ApplicantInterview.Code + 1;

                    end;

                    if "Short Listing Done?" = false then
                        Error('Sorry!!,Shortilisting Has Not Been Done!');
                    if Confirm('Are You Sure You Want to Start Oral Interview Test?', false) = true then begin

                        Interviewers.Reset;
                        Interviewers.SetRange("Recruitment Need", "No.");
                        Interviewers.SetRange("Interview Type", Interviewers."Interview Type"::"Oral Interview");
                        if Interviewers.Find('-') then begin

                            repeat
                                JobApplicationsTable.Reset;
                                JobApplicationsTable.SetRange("Recruitment Need Code", Interviewers."Recruitment Need");
                                JobApplicationsTable.SetRange("Passed Stage", true);
                                if JobApplicationsTable.Find('-') then begin

                                    repeat
                                        ApplicantInterviewTable.Init;
                                        ApplicantInterviewTable.Code := 0;
                                        ApplicantInterviewTable."Recruitment Code" := JobApplicationsTable."Recruitment Need Code";
                                        ApplicantInterviewTable."Applicant ID" := JobApplicationsTable.ApplicationNo;
                                        ApplicantInterviewTable."Applicant Name" := JobApplicationsTable.ApplicantName;
                                        ApplicantInterviewTable."Interview Type" := Interviewers."Interview Type"::"Oral Interview";
                                        ApplicantInterviewTable.Interviewer := Interviewers.Interviewer;

                                        if ApplicantInterviewTable.Insert then begin
                                            appnumber := appnumber + 1;
                                            JobInterviewList.Reset;
                                            JobInterviewList.SetRange("Recruitment No.", ApplicantInterviewTable."Recruitment Code");
                                            JobInterviewList.SetRange("Interview Type", ApplicantInterviewTable."Interview Type");
                                            if JobInterviewList.Find('-') then begin
                                                repeat
                                                    ApplicantInterviewLines.Init;
                                                    ApplicantInterviewLines."Line Number" := testnumbers;
                                                    ;
                                                    ApplicantInterviewLines."Recruitment Code" := ApplicantInterviewTable."Recruitment Code";
                                                    ApplicantInterviewLines."Applicant ID" := ApplicantInterviewTable."Applicant ID";
                                                    ApplicantInterviewLines.Description := JobInterviewList.Description;
                                                    ApplicantInterviewLines.Score := 0;
                                                    ApplicantInterviewLines."Interview Type" := ApplicantInterviewTable."Interview Type";
                                                    ApplicantInterviewLines."Maximamum Score" := JobInterviewList."Maximum Score";
                                                    ApplicantInterviewLines."User ID" := Interviewers.Interviewer;
                                                    ApplicantInterviewLines.Code := ApplicantInterviewTable.Code;
                                                    ApplicantInterviewLines.Insert;
                                                    testnumbers := testnumbers + 1;
                                                until JobInterviewList.Next = 0;
                                            end;
                                        end;
                                        JobApplicationsTable."Invited Oral" := true;
                                        JobApplicationsTable.Modify;
                                    until JobApplicationsTable.Next = 0;
                                end;

                            until Interviewers.Next = 0;
                        end;
                        Message('Oral Interview Successfully Started!');
                    end;
                end;
            }
            action("Consolidate Oral Interview")
            {
                Image = Allocate;
                Visible = false;

                trigger OnAction()
                begin
                    InterHeader.Reset;
                    InterHeader.SetRange("Recruitment Code", Rec."No.");
                    InterHeader.SetRange(Submitted, false);
                    InterHeader.SetRange("Interview Type", InterHeader."Interview Type"::"Oral Interview");
                    if InterHeader.Find('-') then
                        Error('There are incomplete/unsubmitted interview entries');

                    InterHeader.Reset;
                    InterHeader.SetRange("Recruitment Code", Rec."No.");
                    InterHeader.SetRange(Submitted, true);
                    InterHeader.SetRange("Interview Type", InterHeader."Interview Type"::"Oral Interview");
                    if not InterHeader.Find('-') then
                        Error('There are no entries for this request, please start oral interview to continue');

                    JobApplicationsTable.Reset;
                    JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                    JobApplicationsTable.SetRange("Invited Oral", true);
                    if JobApplicationsTable.Find('-') then begin
                        repeat
                            InterLines.Reset;
                            InterLines.SetRange("Interview Type", InterLines."Interview Type"::"Oral Interview");
                            InterLines.SetRange("Recruitment Code", "No.");
                            InterLines.SetRange("Applicant ID", JobApplicationsTable.ApplicationNo);
                            if InterLines.Find('-') then begin
                                InterLines.CalcSums(Score);
                                JobApplicationsTable."Total Score Oral  Interview" := InterLines.Score;
                                JobApplicationsTable.Modify;
                            end;
                        until JobApplicationsTable.Next = 0;
                        Message('Oral interview scores consolidated');
                    end;
                end;
            }
            action("Compute Oral Interview")
            {
                Caption = 'Compute Oral Interview.';
                Visible = false;

                trigger OnAction()
                var
                    Interviewers: Record "Job Interviewers";
                    conting: Integer;
                    ApplicantInterviewLines: Record "Applicant Interview Lines";
                    totalscore: Decimal;
                    averagescore: Decimal;
                begin
                    InterHeader.Reset;
                    InterHeader.SetRange("Recruitment Code", Rec."No.");
                    InterHeader.SetRange(Submitted, false);
                    InterHeader.SetRange("Interview Type", InterHeader."Interview Type"::"Oral Interview");
                    if InterHeader.Find('-') then
                        Error('There are incomplete/unsubmitted interview entries');

                    conting := 0;
                    Interviewers.Reset;
                    Interviewers.SetRange("Recruitment Need", "No.");
                    Interviewers.SetRange("Interview Type", Interviewers."Interview Type"::"Oral Interview");
                    conting := Interviewers.Count;
                    //MESSAGE('this is what I want %1',conting);
                    JobApplicationsTable.Reset;
                    JobApplicationsTable.SetRange("Recruitment Need Code", "No.");
                    JobApplicationsTable.SetRange("Passed Stage", true);
                    if JobApplicationsTable.FindFirst then begin
                        repeat
                            totalscore := 0;
                            averagescore := 0;
                            //MESSAGE(JobApplicationsTable.ApplicantName);
                            ApplicantInterviewLines.Reset;
                            ApplicantInterviewLines.SetRange("Recruitment Code", "No.");
                            ApplicantInterviewLines.SetRange("Applicant ID", JobApplicationsTable.ApplicationNo);
                            ApplicantInterviewLines.SetRange("Interview Type", Interviewers."Interview Type"::"Oral Interview");
                            if ApplicantInterviewLines.FindFirst then begin
                                repeat
                                    totalscore := totalscore + ApplicantInterviewLines.Score;
                                until ApplicantInterviewLines.Next = 0;
                            end;
                            averagescore := Round(totalscore / conting, 0.01, '=');
                            //  MESSAGE('this is the marks %1',averagescore);
                            JobApplicationsTable."Total Score Oral  Interview" := totalscore;
                            JobApplicationsTable."Average Score Oral" := averagescore;
                            JobApplicationsTable.Modify;
                        until JobApplicationsTable.Next = 0;
                        Message('Oral interview scores consolidated');
                    end;
                end;
            }
            action("Technical Interview Test")
            {
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Job Interview List";
                RunPageLink = "Recruitment No." = FIELD("No."),
                              "Interview Type" = CONST("Technical Interview");
                Visible = false;
            }
            action("Start Technical Interview")
            {
                Image = OpenJournal;
                Visible = false;

                trigger OnAction()
                var
                    ApplicantInterviewTable: Record "Applicant Interview Table";
                    ApplicantInterviewLines: Record "Applicant Interview Lines";
                    Interviewers: Record "Job Interviewers";
                    JobApplicationsTable: Record "Job Applications";
                    JobInterviewList: Record "Job Interview List";
                    testnumbers: Integer;
                    appnumber: Integer;
                    ApplicantInterview: Record "Applicant Interview Table";
                begin
                    testnumbers := 200;
                    appnumber := 100;
                    ApplicantInterview.SetCurrentKey(Code);
                    ApplicantInterview.Ascending(false);
                    if ApplicantInterview.FindFirst then begin
                        appnumber := ApplicantInterview.Code + 1;

                    end;

                    if "Short Listing Done?" = false then
                        Error('Sorry!!,Shortilisting Has Not Been Done!');
                    if Confirm('Are You Sure You Want to Start Technical Interview Test?', false) = true then begin
                        Interviewers.Reset;
                        Interviewers.SetRange("Recruitment Need", "No.");
                        Interviewers.SetRange("Interview Type", Interviewers."Interview Type"::"Technical Interview");
                        if Interviewers.Find('-') then begin
                            repeat
                                JobApplicationsTable.Reset;
                                JobApplicationsTable.SetRange("Recruitment Need Code", Interviewers."Recruitment Need");
                                JobApplicationsTable.SetRange("Passed Stage", true);
                                if JobApplicationsTable.Find('-') then begin
                                    repeat
                                        ApplicantInterviewTable.Init;
                                        ApplicantInterviewTable.Code := 0;
                                        ApplicantInterviewTable."Recruitment Code" := JobApplicationsTable."Recruitment Need Code";
                                        ApplicantInterviewTable."Applicant ID" := JobApplicationsTable.ApplicationNo;
                                        ApplicantInterviewTable."Applicant Name" := JobApplicationsTable.ApplicantName;
                                        ApplicantInterviewTable."Interview Type" := Interviewers."Interview Type"::"Technical Interview";
                                        ApplicantInterviewTable.Interviewer := Interviewers.Interviewer;

                                        if ApplicantInterviewTable.Insert then begin
                                            appnumber := appnumber + 1;

                                            JobInterviewList.Reset;
                                            JobInterviewList.SetRange("Recruitment No.", ApplicantInterviewTable."Recruitment Code");
                                            JobInterviewList.SetRange("Interview Type", ApplicantInterviewTable."Interview Type");
                                            if JobInterviewList.Find('-') then begin
                                                repeat
                                                    ApplicantInterviewLines.Init;
                                                    ApplicantInterviewLines."Line Number" := testnumbers;
                                                    ApplicantInterviewLines."Recruitment Code" := ApplicantInterviewTable."Recruitment Code";
                                                    ApplicantInterviewLines."Applicant ID" := ApplicantInterviewTable."Applicant ID";
                                                    ApplicantInterviewLines.Description := JobInterviewList.Description;
                                                    ApplicantInterviewLines.Score := 0;
                                                    ApplicantInterviewLines."Interview Type" := ApplicantInterviewTable."Interview Type";
                                                    ApplicantInterviewLines."Maximamum Score" := JobInterviewList."Maximum Score";
                                                    ApplicantInterviewLines."User ID" := Interviewers.Interviewer;
                                                    ApplicantInterviewLines.Code := ApplicantInterviewTable.Code;
                                                    ApplicantInterviewLines.Insert;
                                                    testnumbers := testnumbers + 1;
                                                until JobInterviewList.Next = 0;
                                            end;
                                        end;
                                        JobApplicationsTable."invited Technical" := true;
                                        JobApplicationsTable.Modify;
                                    until JobApplicationsTable.Next = 0;
                                end;

                            until Interviewers.Next = 0;
                        end;
                        Message('Technical Interview Successfully Started!');
                    end;
                end;
            }
            action("Consolidate Technical Interview")
            {
                Image = Allocations;
                Visible = false;

                trigger OnAction()
                begin
                    InterHeader.Reset;
                    InterHeader.SetRange("Recruitment Code", Rec."No.");
                    InterHeader.SetRange(Submitted, false);
                    InterHeader.SetRange("Interview Type", InterHeader."Interview Type"::"Technical Interview");
                    if InterHeader.Find('-') then
                        Error('There are incomplete/unsubmitted interview entries');
                    InterHeader.Reset;
                    InterHeader.SetRange("Recruitment Code", Rec."No.");
                    InterHeader.SetRange(Submitted, true);
                    InterHeader.SetRange("Interview Type", InterHeader."Interview Type"::"Technical Interview");
                    if not InterHeader.Find('-') then
                        Error('There are no entries for this request, please start technical interview to continue');

                    JobApplicationsTable.Reset;
                    JobApplicationsTable.SetRange("Recruitment Need Code", Rec."No.");
                    JobApplicationsTable.SetRange("invited Technical", true);
                    if JobApplicationsTable.Find('-') then begin
                        repeat
                            InterLines.Reset;
                            InterLines.SetRange("Interview Type", InterLines."Interview Type"::"Technical Interview");
                            InterLines.SetRange("Recruitment Code", "No.");
                            InterLines.SetRange("Applicant ID", JobApplicationsTable.ApplicationNo);
                            if InterLines.Find('-') then begin
                                InterLines.CalcSums(Score);
                                JobApplicationsTable."Total Technical Score" := InterLines.Score;
                                JobApplicationsTable.Modify;
                            end;
                        until JobApplicationsTable.Next = 0;
                        Message('technical interview scores consolidated');
                    end;
                end;
            }
            action("Compute Total Score")
            {
                Visible = false;

                trigger OnAction()
                var
                    Interviewers: Record "Job Interviewers";
                    conting: Integer;
                    ApplicantInterviewLines: Record "Applicant Interview Lines";
                    totalscore: Decimal;
                    averagescore: Decimal;
                begin
                    TestField("Total Interview Score");
                    conting := 0;
                    Interviewers.Reset;
                    Interviewers.SetRange("Recruitment Need", "No.");
                    conting := Interviewers.Count;

                    JobApplicationsTable.Reset;
                    JobApplicationsTable.SetRange("Recruitment Need Code", "No.");
                    JobApplicationsTable.SetRange("Passed Stage", true);
                    if JobApplicationsTable.FindFirst then begin
                        repeat
                            totalscore := 0;
                            averagescore := 0;

                            ApplicantInterviewLines.Reset;
                            ApplicantInterviewLines.SetRange("Recruitment Code", "No.");
                            ApplicantInterviewLines.SetRange("Applicant ID", JobApplicationsTable.ApplicationNo);
                            if ApplicantInterviewLines.FindFirst then begin
                                repeat
                                    totalscore := totalscore + ApplicantInterviewLines.Score;
                                until ApplicantInterviewLines.Next = 0;
                            end;
                            averagescore := Round(totalscore / conting, 0.02);
                            JobApplicationsTable."Applicant Total Score" := averagescore / "Total Interview Score" * 100;
                            JobApplicationsTable.Modify;
                        until JobApplicationsTable.Next = 0;
                        Message('Total scores computed.');
                    end;
                end;
            }
            action("Insert Scores")
            {
                Image = Line;
                RunObject = Page "Job Interview Card";
                RunPageLink = "Recruitment Code" = FIELD("No.");
                Visible = false;
            }
            action("Open Interview List")
            {
                Image = Apply;
                RunObject = Page "Job Shortlisting/ Interviews";
                RunPageLink = "Recruitment Code" = FIELD("No.");
                RunPageView = WHERE(Submitted = CONST(false));
                Visible = false;
            }
            action("View Submited Scores")
            {
                Image = Apply;
                RunObject = Page "Job Shortlisting/ Interviews";
                RunPageLink = "Recruitment Code" = FIELD("No.");
                RunPageView = WHERE(Submitted = CONST(true));
                Visible = false;
            }
            action("Consolidated Report")
            {
                Image = "report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    ApplicantInterviewTable.Reset;
                    ApplicantInterviewTable.SetRange("Recruitment Code", "No.");
                    REPORT.Run(51525087, true, false, ApplicantInterviewTable);
                end;
            }
            action("Select Top Interviewees")
            {
                Visible = false;

                trigger OnAction()
                var
                    Interviewers: Record "Job Interviewers";
                    conting: Integer;
                    ApplicantInterviewLines: Record "Applicant Interview Lines";
                    totalscore: Decimal;
                    averagescore: Decimal;
                begin
                    conting := 1;
                    if Confirm('The interviewees will be selected based on the selected criteria.Are you sure you want to proceed?', true, false) = true then begin
                        JobApplicationsTable.Reset;
                        JobApplicationsTable.SetCurrentKey(JobApplicationsTable."Applicant Total Score");
                        JobApplicationsTable.Ascending(false);
                        JobApplicationsTable.SetRange("Recruitment Need Code", "No.");
                        JobApplicationsTable.SetRange("Passed Stage", true);
                        JobApplicationsTable.SetFilter(JobApplicationsTable."Applicant Total Score", '>=%1', "Pass Mark");
                        if JobApplicationsTable.FindFirst then begin
                            repeat
                                if conting <= "Select Top" then begin
                                    conting := conting + 1;
                                    JobApplicationsTable."Passed Interview" := true;
                                    JobApplicationsTable."Passed Oral Interview" := true;
                                    JobApplicationsTable.Modify;
                                end;
                            until JobApplicationsTable.Next = 0;
                            Message('The interviewees have been successfully selected.');
                        end;
                        "In Oral Test" := true;
                        "Past Oral Test" := true;
                        Rec.Modify;
                    end;
                end;
            }
            action("Move To Post Applications")
            {
                Enabled = false;
                Image = Allocations;
                Promoted = true;
                Visible = false;//ClosedEnabled;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to close this aplication?', true, false) = true then begin
                        "Short Listing Done?" := true;
                        "In Oral Test" := true;
                        "Past Oral Test" := true;
                        "Closed Applications" := false;
                        Rec.Modify;
                    end;
                end;
            }
            action("Close Application")
            {
                Enabled = false;
                Image = Allocations;
                Promoted = true;
                Visible = ClosedEnabled;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to close this aplication?', true, false) = true then begin
                        "Closed Applications" := true;
                        Rec.Modify;
                    end;
                end;
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                //PromotedOnly = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
            action("Export Attachments")
            {
                Image = ExportAttachment;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    DocAttachments: Record "Document Attachment";
                    Windows: Dialog;
                    "Count": Integer;
                    FullFileName: Text;
                    //FILEoBJ: Automation;
                    Folder: Text;
                begin
                    Windows.Open('Exporting Files for #1');
                    Count := 0;
                    JobApps.Reset;
                    JobApps.SetRange("Recruitment Need Code", Rec."No.");
                    if JobApps.Find('-') then begin
                        repeat
                            //Windows.UPDATE(Count, JobApps.ApplicantName);
                            DocAttachments.Reset;
                            DocAttachments.SetRange("No.", JobApps.ApplicationNo);
                            if DocAttachments.Find('-') then
                                Folder := 'C:\Attachments\Application HR\' + Description + '\';
                            /*if Rec.IsClear(FILEoBJ) then
                                Rec.Create(FILEoBJ, false, true);
                            if not FILEoBJ.FolderExists(Folder) then
                                FILEoBJ.CreateFolder(Folder);//
                            FullFileName := Folder + '_' + JobApps.ApplicationNo + DocAttachments."File Name" + '.' + DocAttachments."File Extension";
                            DocAttachments."Document Reference ID".ExportFile(FullFileName);
                            Count := Count + 1;
                        until JobApps.Next = 0;
                    end;
                    Windows.Close;
                    Message('Exported ' + Format(Count) + ' files');
                    /*IF DocAttachments."File Name" <> '' THEN
                      IF (DocAttachments."File Extension" = 'pdf') OR (DocAttachments."File Extension" = 'docx') THEN BEGIN
                        //get the extension in base 64
                        DocAttachments."Document Reference ID".EXPORTFILE(IStream);
                        MemoryStream2 := MemoryStream2.MemoryStream();
                        COPYSTREAM(MemoryStream2,IStream);
                        Bytes2 := MemoryStream2.GetBuffer();
                        ToFile := Convert.ToBase64String(Bytes2);
                        //convert base 64 to pdf
                        Bytes:=Convert.FromBase64String(ToFile);
                        MemoryStream:=MemoryStream.MemoryStream(Bytes);
                        TempBlob.Blob.CREATEOUTSTREAM(DocumentStream);
                        MemoryStream.WriteTo(DocumentStream);
                        //FullFileName := TEMPORARYPATH+"File Name" + '.' + "File Extension";
                        FullFileName := '\\192.168.1.28\Software\TempReports\'+"File Name" + '.' + "File Extension";
                        TempBlob.Blob.EXPORT(FullFileName);
                    
                        HYPERLINK(FullFileName);
                      END;*

                end;
            }*/
            group(Action6)
            {
                Caption = 'Approvals';
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ReqNeeds: Record "Recruitment Needs";
                    begin
                        VarVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);
                        //Rec.Status := Rec.Status::Released;
                        //Rec.Modify;                        
                        //message('Approved!');
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
                action("Reopen")
                {
                    Caption = 'Reopen Job';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                    begin
                        if Rec.Status <> Rec.Status::Released then
                            Error('The status must be released!');
                        if confirm('Are you sure you want to reopen this job?') then begin
                            Rec.Status := Rec.Status::Open;
                            Rec.Closed := false;
                            Rec."Reopening DateTime" := CurrentDateTime();
                            Rec."Reopened By" := UserId;
                            Rec.Modify();
                            Message('Job reopened successfully. Find it in the open jobs list, make the necessary adjustments, then resend for approval');
                            CurrPage.Close();
                        end;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        ClosedEnabled := false;
        if Rec."In Oral Test" = true then begin
            seepanelists := true;
            ClosedEnabled := true;
        end;
        if Rec."Short Listing Done?" = false then begin
            seeoriginalmembers := true;
            seeoriginalmembers2 := false;
        end;
        if Rec."Short Listing Done?" = true then begin
            seeoriginalmembers := false;
            seeoriginalmembers2 := true;
        end;
        if Rec."Closed Applications" = true then begin
            LetterSending := true;
        end;
        FieldsEditable := true;
        if Rec.Advertise then begin //Rec.Status <> Rec.Status::Open
            FieldsEditable := false;
        end;
    end;

    procedure processApplication(var nextProcessingStage: Option "Pending Applications","Receiving Applications",Shortlisting,"First Interview","Due Diligence","Second Interview",Completed; var RecruitmentNeedId: Code[30]; var HasNoFirstInterview: Boolean)
    var
        jobApplicationsList: Record "Job Applications";
    begin
        //Applications submmited, now we move to shortlisting
        if nextProcessingStage = nextProcessingStage::Shortlisting then begin //at submitting
            jobApplicationsList.Reset();
            jobApplicationsList.SetRange("Recruitment Need Code", RecruitmentNeedId);
            jobApplicationsList.SetRange(Submitted, true);
            if jobApplicationsList.findset then
                repeat
                    jobApplicationsList.Status := jobApplicationsList.Status::Submitted;
                    jobApplicationsList.Stage := jobApplicationsList.Stage::Shortlisting;
                    jobApplicationsList.modify();
                until jobApplicationsList.next = 0;
        end;

        //Those marked as shortlist to be shortlisted and moved to next stage
        if nextProcessingStage = nextProcessingStage::"First Interview" then begin //at shortlisting
            jobApplicationsList.Reset();
            jobApplicationsList.SetRange("Recruitment Need Code", RecruitmentNeedId);
            jobApplicationsList.SetRange(Submitted, true);
            jobApplicationsList.SetRange(Shortlist, true);
            if jobApplicationsList.findset then
                repeat
                    jobApplicationsList.Status := jobApplicationsList.Status::Shortlisted;
                    jobApplicationsList.Stage := jobApplicationsList.Stage::"First Interview";
                    if HasNoFirstInterview then
                        jobApplicationsList.Stage := jobApplicationsList.Stage::"Due Diligence";
                    if not jobApplicationsList.Shortlisted then begin
                        jobApplicationsList.Status := jobApplicationsList.Status::"Not Listed";
                    end;

                    jobApplicationsList.modify();
                until jobApplicationsList.next = 0;
        end;

        //Those who passed first interview moving to due diligence
        if nextProcessingStage = nextProcessingStage::"Due Diligence" then begin //At first interview //or at shortlisting
            jobApplicationsList.Reset();
            jobApplicationsList.SetRange("Recruitment Need Code", RecruitmentNeedId);
            jobApplicationsList.SetRange(Submitted, true);
            if jobApplicationsList.findset then
                repeat
                    jobApplicationsList.Status := jobApplicationsList.Status::"Passed First Interview";
                    jobApplicationsList.Stage := jobApplicationsList.Stage::"Due Diligence";
                    if not jobApplicationsList."Passed First Interview" then begin
                        jobApplicationsList.Status := jobApplicationsList.Status::"Failed First Interview";
                    end;

                    //Came straight from shortlisting
                    if HasNoFirstInterview then begin
                        jobApplicationsList.Status := jobApplicationsList.Status::Shortlisted;
                        if not jobApplicationsList."Passed First Interview" then
                            jobApplicationsList.Status := jobApplicationsList.Status::"Not Listed";
                    end;

                    jobApplicationsList.modify();
                until jobApplicationsList.next = 0;
        end;

        //Those who passed due diligence moving to second interview
        if nextProcessingStage = nextProcessingStage::"Second Interview" then begin //At due diligence
            jobApplicationsList.Reset();
            jobApplicationsList.SetRange("Recruitment Need Code", RecruitmentNeedId);
            jobApplicationsList.SetRange(Submitted, true);
            if jobApplicationsList.findset then
                repeat
                    jobApplicationsList.Status := jobApplicationsList.Status::"Passed Due Diligence";
                    jobApplicationsList.Stage := jobApplicationsList.Stage::"Second Interview";
                    if not jobApplicationsList."Passed Due Diligence" then begin
                        jobApplicationsList.Status := jobApplicationsList.Status::"Failed Due Diligence";
                    end;
                    jobApplicationsList.modify();
                until jobApplicationsList.next = 0;
        end;

        //Who succeeded and who failed
        if nextProcessingStage = nextProcessingStage::Completed then begin
            jobApplicationsList.Reset();
            jobApplicationsList.SetRange("Recruitment Need Code", RecruitmentNeedId);
            jobApplicationsList.SetRange(Submitted, true);
            if jobApplicationsList.findset then
                repeat
                    jobApplicationsList.Status := jobApplicationsList.Status::Completed;//Successful;
                    jobApplicationsList.Stage := jobApplicationsList.Stage::Completed;//Succeeded;
                    /*if not jobApplicationsList."Passed Second Interview" then begin
                        jobApplicationsList.Status := jobApplicationsList.Status::Successful;
                        jobApplicationsList.Stage := jobApplicationsList.Stage::Failed;
                    end;*/

                    jobApplicationsList.modify();
                until jobApplicationsList.next = 0;

            Rec."Closed Applications" := true;
            LetterSending := true;
        end else begin
            Rec."Closed Applications" := false;
            LetterSending := false;
        end;
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        seepanelists: Boolean;
        seeoriginalmembers: Boolean;
        seeoriginalmembers2: Boolean;
        LetterSending: Boolean;
        JobApplicationsTable: Record "Job Applications";
        CompanyInfo: Record "Company Information";
        SenderAddress: Text[100];
        Subject: Text[250];
        SenderName: Text[100];
        Body: Text[2000];
        //SMTPSetup: Codeunit "SMTP Mail";
        //MailSetup: Record "SMTP Mail Setup";
        FileName: Text[250];
        FileMangement: Codeunit "File Management";
        JobApplicants: Record "Job Applicants";
        //InterHeader: Record "Applicant Interview Table";
        //InterLines: Record "Applicant Interview Lines";
        ClosedEnabled: Boolean;
        FieldsEditable: Boolean;
        //ApplicantInterviewTable: Record "Applicant Interview Table";
        JobApps: Record "Job Applications";
        Window: Dialog;
        SecondaryEmailRecipients: Record "Secondary Email Recipients";
        EmailCandidatesPage: Page "Email Candidates";
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
    // SharePointHandler: Codeunit SharePointHandler;
}