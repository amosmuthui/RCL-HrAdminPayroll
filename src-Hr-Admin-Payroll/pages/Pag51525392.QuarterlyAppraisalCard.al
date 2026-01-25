page 51525392 "Quarterly Appraisal Card"
{
    ApplicationArea = All;
    Caption = 'Mid-Period Review';
    SourceTable = "Mid Year Appraisal";

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
                field(Date; Rec.Date)
                {
                }
                field("Staff No"; Rec."Staff No")
                {
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    Editable = false;
                }
                field(Directorate; Rec.Directorate)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Department; Rec."Department Name")
                {
                    Editable = false;
                }
                field(Period; Rec.Period)
                {
                    Editable = false;
                }
                field("Created On"; Rec."Created On")
                {
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
                field("Supervisor No"; Rec.Supervisor)
                {
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    Editable = false;
                }
                field("Employee Comments"; Rec."Employee Comments")
                {
                    RowSpan = 5;
                }
                field("Supervisor Comments"; Rec."Supervisor Comments")
                {
                    RowSpan = 5;
                }
                field(Status; Rec.Status)
                {
                    Visible = false;
                }
            }
            /*part("Goals (as agreed during probation or in last annual appraisal)"; "Quarter Goals")
            {
                Caption = 'Goals (as agreed during probation or in last annual appraisal)';
                SubPageLink = "Doc No" = FIELD(No),
                              Type = FILTER(Goals);
                Visible = false;
            }*/
            part("Quarterly Check-in Agenda"; "Quarter Agenda")
            {
                Caption = 'Appraisal Lines';
                SubPageLink = "Doc No" = FIELD(No),
                              Type = FILTER("Checkin Agenda");
            }
            /*part("Achievements in the period under review:"; "Quarter Achievements")
            {
                Caption = 'Achievements in the period under review:';
                SubPageLink = "Doc No" = FIELD(No),
                              Type = FILTER(Achievements);
                Visible = false;
            }*/
            part("Concerns Raised (if any):"; "Quarter Concerns")
            {
                Caption = 'Concerns Raised (if any)';
                SubPageLink = "Doc No" = FIELD(No),
                              Type = FILTER(Concerns);
            }
            part("Agreed Action Plan/Support to be given:"; "Quarter Action Plan")
            {
                Caption = 'Agreed Action Plan/Support to be given:';
                SubPageLink = "Doc No" = FIELD(No),
                              Type = FILTER("Agreed Actions");
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Mid Year Checkin Form")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MidYear.Reset;
                    MidYear.SetRange(No, Rec.No);
                    if MidYear.Find('-') then
                        REPORT.Run(51525261, true, false, MidYear);
                end;
            }
            action("Send to Supervisor")
            {
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Approved By Supervisor" then
                        Error('Appraisal already approved!');
                    if Rec."Sent to Supervisor" then
                        Error('Appraisal already sent for approval!');
                    Rec.CalcFields("Supervisor Name");
                    if Confirm('Are you sure you want to send these appraisal for review to ' + Rec."Supervisor Name" + '? ', false) = true then begin
                        Rec."Sent to Supervisor" := true;
                        Rec."Date-Time Sent For Approval" := CurrentDateTime;
                        Rec.Modify;
                        Message('Success');
                        CurrPage.Update
                    end else
                        Error('Process Aborted');
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Approved By Supervisor" then
                        Error('Appraisal already approved!');
                    Rec.CalcFields("Supervisor Name");
                    Rec.TestField("Approved By Supervisor", false);
                    if Confirm('Send Back to staff ' + Rec."Staff Name" + '? ', false) = true then begin
                        Rec."Sent to Supervisor" := false;
                        Rec."Date-Time Approved" := CurrentDateTime; //Date-time rejected
                        Rec.Modify;

                        //FRED 5/3/23 - Send email notification
                        Employee.Reset;
                        Employee.SetRange("No.", Rec."Staff No");
                        if Employee.FindFirst then begin
                            SenderStaffID := Employee."User ID";
                        end;

                        Employee.Reset;
                        Employee.SetRange("No.", Rec.Supervisor);
                        if Employee.FindFirst then begin
                            SupervisorID := Employee."User ID";
                        end;
                        //MESSAGE('%1, %2, %3, %4',SenderStaffID,SupervisorID,"Staff Name","Supervisor Name"); EXIT;
                        SendEmailNotification(Rec.No, SenderStaffID, SupervisorID, Rec."Staff Name", Rec."Supervisor Name", 'DOWN', 'REJECTED');

                        Message('Success');
                        CurrPage.Update
                    end else
                        Error('Process Aborted');
                end;
            }
            action(Approve)
            {
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Approved By Supervisor" then
                        Error('Appraisal already approved!');
                    Rec.CalcFields("Supervisor Name");
                    UserSetup.Reset;
                    //UserSetup.SETRANGE("User ID",USERID);
                    UserSetup.SetRange("Employee No.", Rec.Supervisor);
                    if not UserSetup.FindFirst then begin
                        //ERROR('Approval targets can only be approved by Supervisor %1',"Supervisor Name");
                        Error('User setup data for Supervisor %1 not found. Ask the System Admin to set it up before proceeding!', Rec."Supervisor Name");
                    end;


                    //IF CONFIRM('Are you sure you want to send these targets for review to '+"Supervisor Name"+'? ', FALSE) = TRUE THEN
                    if Confirm('Are you sure you want to approve this appraisal? ', false) = true then begin
                        Rec."Sent to Supervisor" := true;
                        Rec."Approved By Supervisor" := true;
                        Rec."Date-Time Approved" := CurrentDateTime;
                        Rec.Modify;

                        //FRED 5/3/23 - Send email notification
                        Employee.Reset;
                        Employee.SetRange("No.", Rec."Staff No");
                        if Employee.FindFirst then begin
                            SenderStaffID := Employee."User ID";
                        end;

                        Employee.Reset;
                        Employee.SetRange("No.", Rec.Supervisor);
                        if Employee.FindFirst then begin
                            SupervisorID := Employee."User ID";
                        end;
                        //MESSAGE('%1, %2, %3, %4',SenderStaffID,SupervisorID,"Staff Name","Supervisor Name"); EXIT;
                        SendEmailNotification(Rec.No, SenderStaffID, SupervisorID, Rec."Staff Name", Rec."Supervisor Name", 'DOWN', 'APPROVED');


                        Message('Success');
                        CurrPage.Update
                    end else
                        Error('Process Aborted');
                end;
            }
            action("Performance Planning")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    Targets: Record "Staff Target Objectives";
                begin
                    Targets.Reset;
                    Targets.SetRange(No, Rec.No);
                    if Targets.Find('-') then
                        REPORT.Run(51525260, true, false, Targets);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Approved By Supervisor" then
            CurrPage.Editable := false;
    end;

    var
        MidYear: Record "Mid Year Appraisal";
        UserSetup: Record "User Setup";
        SenderUserSetup: Record "User Setup";
        ApproverUserSetup: Record "User Setup";
        SenderName: Text[100];
        ApproverName: Text[100];
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        Employee: Record Employee;
        SenderStaffID: Code[30];
        SupervisorID: Code[30];

    local procedure SendEmailNotification(DocNo: Code[20]; SenderID: Code[30]; ApproverID: Code[30]; SenderName: Text[100]; ApproverName: Text[100]; Direction: Code[10]; Verdict: Code[10])
    var
        Subject: Code[30];
        BodyText: Text[250];
        RecipientName: Text[250];
        RecipientEmail: Text[100];
    begin
        if Direction = 'UP' then begin
            Subject := 'REQUEST FOR APPROVAL';
            RecipientName := ApproverName;
            BodyText := 'You have a pending Appraissal approval, Document No: ' + DocNo + ' from ' + SenderName + '. Kindly Log in and check the document then Approve/Reject on your basis.';
        end else begin
            RecipientName := SenderName;
            if Verdict = 'APPROVED' then begin
                Subject := 'APPRAISAL APPROVED';
                BodyText := 'Your Appraissal approval request for Document No: ' + DocNo + ' has been approved by your supervisor, ' + ApproverName + '. Kindly Log in to the system then proceed with subsequent steps.';
            end else begin
                Subject := 'APPRAISAL REJECTED';
                BodyText := 'Your Appraissal approval request for Document No: ' + DocNo + ' has been rejected by your supervisor, ' + ApproverName + '. Kindly Log in to the system then take the necessary steps.';
            end;
        end;


        SenderUserSetup.Reset;
        SenderUserSetup.SetRange("User ID", SenderID);
        SenderUserSetup.SetFilter("E-Mail", '<>%1', '');
        if SenderUserSetup.FindFirst then begin
            //MESSAGE('here %1',ApproverID);
            ApproverUserSetup.Reset;
            ApproverUserSetup.SetRange("User ID", ApproverID);
            if ApproverUserSetup.Find('-') then begin
                //MESSAGE('Approver %1',ApproverUserSetup."E-Mail");
                if ApproverUserSetup."E-Mail" <> '' then begin
                    if Direction = 'UP' then
                        RecipientEmail := ApproverUserSetup."E-Mail"
                    else
                        RecipientEmail := SenderUserSetup."E-Mail";
                    EmailMessage.Create(RecipientEmail, Subject, '', true);
                    EmailMessage.AppendToBody('<HR>');
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody('Dear ' + RecipientName + ',');
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody(BodyText);
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody('Kind Regards');
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody(CompanyName);
                    EmailMessage.AppendToBody('<br><br>');
                    EmailMessage.AppendToBody('<HR>');
                    //SLEEP(3000);
                    Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                    //MESSAGE('here 1');
                end;
            end;
        end;
    end;
}