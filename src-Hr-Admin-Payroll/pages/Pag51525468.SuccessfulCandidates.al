page 51525468 "Successful Candidates"
{
    ApplicationArea = All;
    CardPageID = "Job Application Card";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Applications";
    SourceTableView = WHERE(Successful = CONST(true)/*,
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
                field(Submitted; Rec.Submitted)
                {
                    Visible = false;
                }
                field("Total Score"; Rec."Total Score Shorlisting")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                }
                field(Onboarded; Rec.Onboarded)
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {

            action("Convert To Employee")
            {
                //Caption = 'Employ and Onboard Succesful Candidate(s)';
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                    Applicants: Record "Job Applicants";
                    Applicants2: Record "HR Online Applicant";
                    EmpNo: Code[100];
                    EmpRec: Record Employee;
                    ChangeRequestRec: Record "Change Request";
                begin
                    EmpNo := '';
                    CurrPage.SETSELECTIONFILTER(JobApplicationsTable);
                    if JobApplicationsTable.FindSet(true) then begin
                        repeat
                            if (JobApplicationsTable.Successful) and (not JobApplicationsTable.Onboarded) then begin
                                if Confirm('Are you sure you want to create an employee file for  ' + JobApplicationsTable.ApplicantName + ' ?', false) = true then begin
                                    Applicants2.Reset();
                                    Applicants2.SetRange("Email Address", JobApplicationsTable."Applicant Email");
                                    if Applicants2.FindFirst() then begin
                                        EmpNo := Applicants.EmployApplicant(Applicants2, JobApplicationsTable."Job Applied For", JobApplicationsTable.JobDescription, JobApplicationsTable."Job Applied For", JobApplicationsTable.ApplicationNo /*"Job ID", Description, "Job ID"*/);
                                        JobApplicationsTable.Onboarded := true;
                                        //JobApplicationsTable."Employee No" := EmpNo;
                                        JobApplicationsTable."Change Request No." := EmpNo;
                                        JobApplicationsTable.Modify();
                                    end;
                                end;
                            end else
                                Message('No candidate Found.');
                        until JobApplicationsTable.Next() = 0;
                        if EmpNo <> '' then begin
                            /*EmpRec.Reset();
                            EmpRec.SetRange("No.", EmpNo);
                            if EmpRec.Find('-') then
                                Page.Run(Page::"Employee Card", EmpRec);
                                */
                            ChangeRequestRec.Reset();
                            ChangeRequestRec.SetRange("No.", EmpNo);
                            if ChangeRequestRec.Find('-') then
                                Page.Run(Page::"Employee Change Card", ChangeRequestRec);
                        end;
                    end else
                        Message('No candidate selected!');
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
        }
    }

    trigger OnOpenPage()
    begin

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
        //ReqNeedss: Record "Job Application Qualification";
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
}