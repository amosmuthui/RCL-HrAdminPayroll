page 51525313 "Company Jobs"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Company Jobs";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Job Description"; Rec."Job Description")
                {
                    Caption = 'Job Title';
                }
                field("Position Reporting to"; Rec."Position Reporting to")
                {
                    Caption = 'Immediate Supervisor';
                }
                field("Supervisor Position"; Rec."Supervisor Position")
                { }
                field("Department Code"; Rec."Department Code")
                { }
                field("Department Name"; Rec."Department Name")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Section Code"; Rec."Section Code")
                { }
                field("Section Name"; Rec."Section Name")
                { }
                field("Dimension 1"; Rec."Dimension 1")
                {
                    Visible = false;
                }
                field("Directorate Name"; Rec."Directorate Name")
                {
                    Caption = 'Directorate Name.';
                    Editable = false;
                    Visible = false;
                }
                field("Dimension 2"; Rec."Dimension 2")
                {
                    Visible = false;
                }
                field(Grade; Rec.Grade)
                {
                }
                field("Given Transport Allowance"; Rec."Given Transport Allowance")
                { }
                field(Objective; Rec.Objective)
                {
                    Caption = 'Job Purpose';
                    MultiLine = true;
                }
                field("No of Posts"; Rec."No of Posts")
                {
                }
                field("Occupied Establishments"; Rec."Occupied Establishments")
                {
                    Caption = 'No. of Holders';
                }
                field("""No of Posts""-""Occupied Establishments"""; Rec."No of Posts" - Rec."Occupied Establishments")
                {
                    Caption = 'Vacant Positions';
                    Editable = false;
                }
                field("Notice Period"; Rec."Notice Period")
                {
                    Caption = 'Notice Period (D,W,M,Y)';
                    Tooltip = 'Specify the notice period number followed by D for day, W for week, M for month and Y for year';
                }
                field("Probation Period"; Rec."Probation Period")
                {
                    Caption = 'Probation Period (D,W,M,Y)';
                    Tooltip = 'Specify the probation period number followed by D for day, W for week, M for month and Y for year';
                }
                field("Date Active"; Rec."Date Active")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Salary Allocation %"; Rec."Salary Allocation %")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Job)
            {
                Caption = 'Job';
                action("Positions Reporting to Job Holder")
                {
                    Caption = 'Positions Reporting to Job Holder';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "J. Position Supervised";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                }
                action("Salary Allocation")
                {
                    Caption = ' Salary Allocation';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SalaryAllocation.Reset;
                        SalaryAllocation.SetRange("Employee No", Rec."Job ID");
                        SalaryAllocation.SetRange(SalaryAllocation."Job ID/Employee ID", SalaryAllocation."Job ID/Employee ID"::perJobID);
                        //IF SalaryAllocation.FIND('-') THEN BEGIN
                        PAGE.Run(52090, SalaryAllocation);
                        //END;
                    end;
                }
                action("Job Specification")
                {
                    Caption = 'Job Specification';
                    Image = Description;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "J. Specification";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                }
                action("Key Responsibilities")
                {
                    Caption = 'Key Responsibilities';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "J. Responsiblities";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                }
                action("Working Relationships")
                {
                    Caption = 'Working Relationships';
                    Image = Relationship;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "J. Responsiblities";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                }
                separator(Action1000000025)
                {
                }
                action("Vacant Positions")
                {
                    Caption = 'Vacant Positions';
                    Image = OpportunityList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vacant Establishments";
                }
                action("Screening Questions")
                {
                    Caption = 'Screening Questions';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunPageLink = "Position No." = field("Job ID");
                    RunObject = Page "Position Screening Questions";
                }
                action("Over Staffed Positions")
                {
                    Caption = 'Over Staffed Positions';
                    Image = Lot;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Over Staffed Establishments";
                }
                /*action("Attach JD Document")
                {
                    Caption = 'Attach JD Document';
                    Visible = false;

                    trigger OnAction()
                    begin
                        docname := Rec."Job ID";
                        docname := ConvertStr(docname, '/', '_');
                        docname := ConvertStr(docname, '\', '_');

                        HrSetup.Reset;
                        HrSetup.Get;
                        HrSetup.TestField("DMS LINK");
                        FileName := filecu.OpenFileDialog('Select Letter of Acceptance File', 'Acceptance File', 'PDF Files (*.PDF)|*.PDF|All Files (*.*)|*.*');
                        FileName2 := HrSetup."DMS LINK" + docname + '_Acceptance' + '_' + filecu.GetFileName(FileName);

                        filecu.CopyClientFile(FileName, FileName2, true);

                        "JD Attachment Link" := FileName2;
                        Rec.Modify;

                        Message('Letter of Award Attached Successfully!');
                    end;
                }*/
            }
        }
        area(processing)
        {
            action(Preview)
            {
                Caption = 'Preview';
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    Jobs.Reset;
                    Jobs.SetRange(Jobs."Job ID", Rec."Job ID");
                    if Jobs.Find('-') then
                        REPORT.RunModal(Report::"Job Description", true, false, Jobs);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        Jobs: Record "Company Jobs";
        JobReq: Record "Job Requirement";
        EmpQualification: Record "Employee Qualification";
        Employee: Record Employee;
        Qualifies: Boolean;
        //Applicant: Record Applicants;
        //ApplicantQualification: Record "Applicants Qualification";
        JobDescriptionReport: Report "Job Description";
        FileName: Text;
        FileName2: Text;
        docname: Text;
        //filecu: Codeunit "File Management";
        HrSetup: Record "Human Resources Setup";
        SalaryAllocation: Record "Salary Allocation";

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        if Rec."No of Posts" <> xRec."No of Posts" then
            Rec."Vacant Establishments" := Rec."No of Posts" - Rec."Occupied Establishments";
    end;
}