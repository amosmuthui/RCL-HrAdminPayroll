page 51525325 "Job Applications List"
{
    ApplicationArea = All;
    CardPageID = "Job Application Card";
    DeleteAllowed = false;
    Editable = true;
    ModifyAllowed = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Applications";
    SourceTableView = sorting(ApplicationNo) order(descending);

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
                field(Gender; Rec.Gender)
                { }
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
                field(Submitted; Rec.Submitted)
                {
                    Visible = false;
                }
                field("Total Score"; Rec."Total Score Shorlisting")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Status; Rec.PortalStatus())//Status
                {
                }
                field("Applicant Email"; Rec."Applicant Email")
                {
                    Editable = false;
                }
                field("Phone Number"; Rec."Mobile No.")
                {
                    Editable = false;
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
                    Editable = Rec.Stage = Rec.Stage::"Second Interview";
                }
                field("Passed Short Listing"; Rec."Passed Short Listing")
                {
                    Visible = false;
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
                    Editable = Rec.Stage = Rec.Stage::Completed;
                }
                field("Talent Pool"; Rec."Talent Pool")
                { }
                field("Qualification Score"; Rec."Qualification Score")
                {
                    Visible = false;
                }
                field("Total Score Oral  Interview"; Rec."Total Score Oral  Interview")
                {
                    Editable = false;
                    Visible = false;
                }
            }
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Start Shortlisting")
            {
                Image = Interaction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Get Scores")
            {
                Image = Interaction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    shortlistrec: Record "Company Jobs";
                    applrec: Record "Job Applications";
                    Dialogr: Dialog;
                    k: Integer;
                    l: Integer;
                    advertrec: Record "Recruitment Needs";
                    //experincerec: Record "Job Requirement App";
                    yaersofexperience: Integer;
                    applicantdetails: Record "Applicants Qualification";
                    //academicrec: Record "Indept Recruitment Needs App";
                    m: Integer;
                    n: Integer;
                    //professionalrec: Record "Indept Recruitment Needs App";
                    proffid: Integer;
                    membershiprec: Record "Job Professional Bodies";
                    passedcheck: Integer;
                    countrows: Integer;
                    remaining: Integer;
                begin

                    applrec.Reset;
                    applrec.SetRange("Recruitment Need Code", Rec."Recruitment Need Code");
                    if applrec.FindSet(true) then begin
                        repeat
                            applrec."Qualification Score" := fnGetQualificationScore(applrec);
                            applrec.Modify;
                        until applrec.Next = 0;
                    end;

                end;
            }
            action("Shortlist Candidates_")
            {
                Image = Interaction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    shortlistrec: Record "Company Jobs";
                    applrec: Record "Job Applications";
                    Dialogr: Dialog;
                    k: Integer;
                    l: Integer;
                    advertrec: Record "Recruitment Needs";
                    //experincerec: Record "Job Requirement App";
                    yaersofexperience: Integer;
                    applicantdetails: Record "Applicants Qualification";
                    //academicrec: Record "Indept Recruitment Needs App";
                    m: Integer;
                    n: Integer;
                    //professionalrec: Record "Indept Recruitment Needs App";
                    proffid: Integer;
                    membershiprec: Record "Job Professional Bodies";
                    passedcheck: Integer;
                    countrows: Integer;
                    remaining: Integer;
                    applrecx: Record "Job Applications";
                    needs: Record "Recruitment Needs";
                begin
                    if Rec."Recruitment Need Code" <> '' then begin
                        advertrec.Get(Rec."Recruitment Need Code");
                        countrows := 0;
                        remaining := 0;
                        passedcheck := 0;
                        //FnCheckFormSixRequirements("Recruitment Need Code");

                        FnShortlistAppplicants(Rec."Recruitment Need Code");
                        Commit;
                        applrec.Reset;
                        applrec.SetRange("Recruitment Need Code", Rec."Recruitment Need Code");
                        if applrec.FindFirst then begin
                            repeat
                                ReqNeedss.Reset;
                                ReqNeedss.SetRange(ReqNeedss."Job Need Id", Rec."Recruitment Need Code");
                                ReqNeedss.SetRange(ReqNeedss.Found, false);
                                if ReqNeedss.FindFirst then begin

                                    applrecss.Reset;
                                    applrecss.SetRange(applrecss.ApplicantID, ReqNeedss."Applicant No.");
                                    if applrecss.FindFirst then begin

                                        applrecss."Not Qualified" := true;
                                        applrecss.Modify;
                                    end;
                                end;
                            until applrecss.Next = 0;
                        end;
                        Commit;


                        applrecs.Reset;
                        applrecs.SetRange(applrecs."Recruitment Need Code", Rec."Recruitment Need Code");
                        applrecs.SetRange(applrecs."Not Qualified", false);
                        if applrecs.FindFirst then begin
                            repeat
                                if advertrec."Experience(Yrs)" <= applrecs."Years of Experince" then begin
                                    passedcheck := 0;
                                    passedcheck := passedcheck + 1;

                                    applrecs.Shortlist := true;
                                    applrecs."Passed Short Listing" := true;
                                    applrecs."Passed Stage" := true;
                                    applrecs.Modify(true);
                                end;
                            until applrecs.Next = 0;
                        end;

                        if passedcheck >= 1 then begin
                            advertrec."Short Listing Done?" := true;
                            advertrec.Modify;
                            Message('Shortlisting Complete. Check it on Separate Menu.');
                            CurrPage.Close;
                        end;
                        if passedcheck = 0 then begin
                            Message('No One Passed the Short Listing Level!!!');
                        end;
                    end;
                end;
            }
            action("Shortlist CandidatesNew")
            {
                Image = Interaction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //RunObject = Report "Shortlist Candidates";
                Visible = false;

                trigger OnAction()
                var
                    shortlistrec: Record "Company Jobs";
                    applrec: Record "Job Applications";
                    Dialogr: Dialog;
                    k: Integer;
                    l: Integer;
                    advertrec: Record "Recruitment Needs";
                    //experincerec: Record "Job Requirement App";
                    yaersofexperience: Integer;
                    applicantdetails: Record "Applicants Qualification";
                    //academicrec: Record "Indept Recruitment Needs App";
                    m: Integer;
                    n: Integer;
                    //professionalrec: Record "Indept Recruitment Needs App";
                    proffid: Integer;
                    membershiprec: Record "Job Professional Bodies";
                    passedcheck: Integer;
                    countrows: Integer;
                    remaining: Integer;
                    applrecx: Record "Job Applications";
                    needs: Record "Recruitment Needs";
                begin
                end;
            }
            action("Pick Best Candidate")
            {
                Image = VendorContact;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = TotalScores;

                trigger OnAction()
                begin
                    /*IF CONFIRM('Are You Sure You Want To Pick The Best candidate??',FALSE)=TRUE THEN BEGIN
                    JobApplicationsTable.RESET;
                    JobApplicationsTable.SETCURRENTKEY("Total Score Oral  Interview");
                    JobApplicationsTable.ASCENDING(FALSE);
                    JobApplicationsTable.SETRANGE("Passed Stage",TRUE);
                    JobApplicationsTable.SETRANGE("Invited Oral",TRUE);
                    IF JobApplicationsTable.FINDFIRST THEN BEGIN
                      JobApplicationsTable."Passed Oral Interview":=TRUE;
                      JobApplicationsTable."Offer Letter of Appointment":=TRUE;
                      JobApplicationsTable.MODIFY;
                     IF RecruitmentNeeds.GET("Recruitment Need Code") THEN BEGIN
                      RecruitmentNeeds."In Oral Test":=TRUE;
                      RecruitmentNeeds."Past Oral Test":=TRUE;
                      RecruitmentNeeds."Closed Applications":=TRUE;
                      RecruitmentNeeds.MODIFY;
                      END;
                      MESSAGE('The best candidate is %1',JobApplicationsTable.ApplicantName);
                      CurrPage.CLOSE;
                      END;
                    END;*/

                end;
            }
            action("Download All Attachments")
            {
                Image = Database;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //RunObject = Report "Download Applicant Documents";
                Visible = false;

                trigger OnAction()
                begin
                    /*        FileBlob.Blob.CREATEINSTREAM(FileStream);
                            ZipBlob.Blob.CREATEOUTSTREAM(ZipedFile);
                            ZipName := STRSUBSTNO('%1.zip','ApplicantDocuments');
                    
                    
                              DocAttachment.RESET;
                              DocAttachment.SETRANGE("Table ID",51525286);
                              //DocAttachment.SETRANGE("No.","Job Applications".ApplicationNo);
                              IF DocAttachment.FINDSET(TRUE,FALSE) THEN BEGIN
                                REPEAT
                                  //DocAttachment
                                  FileMgt.AddStreamToZipStream(ZipedFile, FileStream,DocAttachment."File Name");
                                  UNTIL DocAttachment.NEXT = 0;
                                END;
                             //FileMgt.AddStreamToZipStream(ZipedFile, FileStream, FileName[i]);
                    
                    
                             ZipBlob.Blob.CREATEINSTREAM(ZipStream);
                             DOWNLOADFROMSTREAM(ZipStream, 'Dialog', 'Folder', '', ZipName);*/

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if RecruitmentNeeds.Get(Rec."Recruitment Need Code") then
            if RecruitmentNeeds."Short Listing Done?" = true then begin
                Rec.SetCurrentKey("Total Score Oral  Interview");
                Rec.Ascending(false);
                TotalScores := true;
                shortlisting := false;
            end else begin
                Rec.SetCurrentKey("Total Score Shorlisting");
                Rec.Ascending(false);
                TotalScore := true;
                shortlisting := true;
            end;
        //UpdateSerialNos();

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
        //ApplicantsNeeds: Record "Needs Requirement";
        ReqNeedss: Record "Job Application Qualification";
        applrecss: Record "Job Applications";
        ZipedFile: OutStream;
        FileName: array[4] of Text;
        FileContent: array[4] of BigText;
        ZipName: Text;
        FileMgt: Codeunit "File Management";
        //FileBlob: Record TempBlob temporary;
        //ZipBlob: Record TempBlob temporary;
        ZipStream: InStream;
        FileStream: InStream;
        i: Integer;
        DocAttachment: Record "Document Attachment";

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

    procedure UpdateSerialNos()
    var
        JobApplication: Record "Job Applications";
        LastApplicationForThisJob: Record "Job Applications";
        SerialNo: Integer;
        RecruitmentNeeds: Record "Recruitment Needs";
    begin
        RecruitmentNeeds.Reset();
        if RecruitmentNeeds.FindFirst() then
            repeat
                SerialNo := 0;
                JobApplication.Reset();
                JobApplication.SetRange("Recruitment Need Code", RecruitmentNeeds."No.");
                JobApplication.SetCurrentKey(ApplicationNo);
                JobApplication.SetAscending(ApplicationNo, true);
                if JobApplication.FindFirst() then
                    repeat
                        SerialNo += 1;
                        /*JobApplication."Serial No." := 1;
                        LastApplicationForThisJob.Reset();
                        LastApplicationForThisJob.SetRange("Recruitment Need Code", JobApplication."Recruitment Need Code");
                        LastApplicationForThisJob.SetFilter(ApplicationNo, '<>%1', JobApplication.ApplicationNo);
                        if LastApplicationForThisJob.FindLast() then*/
                        JobApplication."Serial No." := SerialNo;//LastApplicationForThisJob."Serial No." + 1;
                        JobApplication.Modify();
                    until JobApplication.Next() = 0;
            until RecruitmentNeeds.Next() = 0;
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