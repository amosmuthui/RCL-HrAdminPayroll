page 51525398 "Peer Appraisal Card"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    SourceTable = "Peer Appraisal Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field(Period; Rec.Period)
                {
                    Editable = false;
                }
                field("Staff No"; Rec."Staff No")
                {
                    Editable = false;
                }
                field("Staff Name"; StaffName)
                {
                    Editable = false;
                }
                field("Peer Appraiser 1"; Rec."Peer Appraiser 1")
                {
                    Visible = false;
                }
                field("Peer Appraiser 2"; Rec."Peer Appraiser 2")
                {
                    Visible = false;
                }
                field("Peer Appraiser 3"; Rec."Peer Appraiser 3")
                {
                    Visible = false;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Created On"; Rec."Created On")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Directorate; Rec.Directorate)
                {
                    Editable = false;
                }
                field(Department; Rec.Department)
                {
                    Editable = false;
                }
                field(Supervisor; Rec.Supervisor)
                {
                    Editable = false;
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    Editable = false;
                }
                field(Designation; Rec.Designation)
                {
                    Caption = 'Employee Designation';
                    Editable = false;
                }
            }
            part(PeerManagementReview; "Peer Management Review")
            {
                Caption = '2.1 Management and Leadership - Description: Guides the team to achieve desired results. Delegate''s responsibilities appropriately and effectively, while developing direct reports.Evaluation scale 5   Excellent (consistently exceeds standards)4   Outstanding (frequently exceeds standards)3   Satisfactory (generally meets standards)2   Needs Improvement (frequently fails to meet standards)1   Unacceptable (fails to meet standards)s.';
                SubPageLink = "Doc No" = FIELD(No),
                              Type = FILTER("Management Leadership");
            }
            part(PeerJobKnowledgeReview; "PeerJob Knowledge Review")
            {
                Caption = '2.2 Job Knowledge Description: Applies the technical and professional skills needed for the jEob.';
                SubPageLink = "Doc No" = FIELD(No),
                              Type = FILTER("Job Knowledge");
            }
            part(PeerProblemSolving; "Peer Problem Solving")
            {
                Caption = '2.3 Problem Solving Description: Identifies and analyzes problems, makes logical decisions and seeks solutions to individual and organizational challenges.';
                SubPageLink = "Doc No" = FIELD(No),
                Type = FILTER("Problem Solving");
            }
            part(PeerCommunication; "Peer Communication")
            {
                Caption = '2.4 Communication and Teamwork Description: Listens effectively and provides information and guidance to individuals in an appropriate timely mann er.';
                SubPageLink = "Doc No" = FIELD(No),
                Type = FILTER("Communication and Teamwork");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("360 Feedback Form")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*MidYear.RESET;
                    MidYear.SETRANGE(No, No);
                    IF MidYear.FIND('-') THEN
                      REPORT.RUN(51525262, TRUE, FALSE,MidYear);*/

                    Feed360Form.SetFilters(Rec.No, AppraisorNo, IsSupervisor);
                    Feed360Form.Run;

                end;
            }
            action("Send Back To Supervisor")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = NOT IsSupervisor;

                trigger OnAction()
                begin
                    if Rec."Send Back To Supervisor" then
                        Error('The document has already been sent back to the supervisor!');

                    if Confirm('Are you sure you want to send the document to the supervisor?') then begin
                        Rec."Send Back To Supervisor" := true;
                        Rec.Modify;
                        Message('Done');
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsSupervisor := false;

        if Rec."Send Back To Supervisor" then
            CurrPage.Editable := false;

        Emp.Reset;
        Emp.SetRange("No.", Rec."Staff No");
        if Emp.FindFirst then
            StaffName := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";

        Emp.Reset;
        Emp.SetRange("User ID", UserId);//USERID UMSOMIHVKENYA\DTOBON UMSOMIHVKENYA\AAKINYI  UMSOMIHVKENYA\NLANGAT
        if Emp.Find('-') then begin
            if Emp."No." in [Rec."Peer Appraiser 1", Rec."Peer Appraiser 2", Rec."Peer Appraiser 3"] then
                AppraisorNo := Emp."No."
            else begin
                if Emp."No." = Rec.Supervisor then begin
                    IsSupervisor := true;
                    CurrPage.Editable := false;
                end;
                //ELSE ERROR('You cannot access this page since you are neither a supervisor nor a selected peer reviewer.');
            end;
        end;
        //ELSE ERROR('Your employment records have not been found! Kindly liaise with HR.');
        //MESSAGE('%1',AppraisorNo);
        //Set filters on the listpart pages
        CurrPage.PeerManagementReview.PAGE.SetFilters(Rec.No, AppraisorNo, IsSupervisor);
        CurrPage.PeerJobKnowledgeReview.PAGE.SetFilters(Rec.No, AppraisorNo, IsSupervisor);
        CurrPage.PeerProblemSolving.PAGE.SetFilters(Rec.No, AppraisorNo, IsSupervisor);
        CurrPage.PeerCommunication.PAGE.SetFilters(Rec.No, AppraisorNo, IsSupervisor);
    end;

    var
        MidYear: Record "Peer Appraisal Header";
        Emp: Record Employee;
        StaffName: Text[100];
        AppraisorNo: Code[30];
        IsSupervisor: Boolean;
        Feed360Form: Report "Peer Appraisal 360 Report";
}