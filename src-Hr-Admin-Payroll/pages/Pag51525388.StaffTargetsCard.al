page 51525388 "Staff Targets Card"
{
    ApplicationArea = All;
    Editable = true;
    SourceTable = "Staff Target Objectives";

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
                field("Staff No"; Rec."Staff No")
                {
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    Editable = false;
                }
                field("Department Name"; Rec."Department Name")
                {
                }
                field(Section; Rec.Section)
                {
                }
                field(Period; Rec.Period)
                {

                    trigger OnValidate()
                    begin
                        //FRED 5/3/23 Limit modification to within set dates
                        HrAppraissalPeriods.Reset;
                        HrAppraissalPeriods.SetRange(Code, Rec.Period);
                        if HrAppraissalPeriods.FindFirst then begin
                            if (HrAppraissalPeriods."Allow Edits From" <> 0D) and (HrAppraissalPeriods."Allow Edits To" <> 0D) then begin
                                if (Today < HrAppraissalPeriods."Allow Edits From") or (Today > HrAppraissalPeriods."Allow Edits To") then begin
                                    Error('You are no longer allowed to modify this target because the working date is outside the allowable modification dates for this period!');
                                end;
                            end;
                        end;
                    end;
                }
                field("Created On"; Rec."Created On")
                {
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                    Editable = false;
                }
                field(Supervisor; Rec.Supervisor)
                {
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                }
            }
            part(Planning; "Staff Targets ListPart")
            {
                Caption = 'Planning';
                SubPageLink = "Doc No" = FIELD(No);//,
                                                   //"Staff No" = FIELD("Staff No"),
                                                   //Period = FIELD(Period);
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Performance Planning")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Targets.Reset;
                    Targets.SetRange(No, Rec.No);
                    if Targets.Find('-') then
                        REPORT.Run(51525260, true, false, Targets);
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
                        Error('Targets already approved!');
                    if Rec."Sent to Supervisor" then
                        Error('Targets already sent for approval!');
                    Rec.CalcFields("Supervisor Name");
                    if Confirm('Are you sure you want to send these targets for review to ' + Rec."Supervisor Name" + '? ', false) = true then begin
                        Rec."Sent to Supervisor" := true;
                        Rec."DateTime Submitted" := CurrentDateTime();
                        Rec.Modify;

                        //FRED 5/3/23 - Send email notification
                        /*Employee.Reset;
                        Employee.SetRange("No.", "Staff No");
                        if Employee.FindFirst then begin
                            SenderStaffID := Employee."User ID";
                        end;*/

                        /*Employee.Reset;
                        Employee.SetRange("No.", Supervisor);
                        if Employee.FindFirst then begin
                            SupervisorID := Employee."User ID";
                        end;*/
                        //MESSAGE('%1, %2, %3, %4',SenderStaffID,SupervisorID,"Staff Name","Supervisor Name"); EXIT;
                        SendEmailNotification(Rec.No, Rec."Staff No", Rec.Supervisor, Rec."Staff Name", Rec."Supervisor Name", 'UP', 'REQUEST');

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
                        Error('Targets already approved!');
                    if Rec."Sent to Supervisor" then
                        Error('Targets already sent for approval!');

                    Rec.CalcFields("Supervisor Name");
                    //TESTFIELD("Approved By Supervisor",FALSE);
                    if Confirm('Send Back to staff ' + Rec."Staff Name" + '? ', false) = true then begin
                        Rec."Sent to Supervisor" := false;
                        Rec."DateTime Approved" := CurrentDateTime();
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
            action("Approve Targets")
            {
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Approved By Supervisor" then
                        Error('Targets already approved!');
                    if Rec."Sent to Supervisor" then
                        Error('Targets already sent for approval!');

                    Rec.CalcFields("Supervisor Name");
                    /*UserSetup.Reset;
                    //UserSetup.SETRANGE("User ID",USERID);
                    UserSetup.SetRange("Employee No.", Supervisor);
                    if not UserSetup.FindFirst then begin
                        //ERROR('Approval targets can only be approved by Supervisor %1',"Supervisor Name");
                        Error('User setup data for Supervisor %1 not found. Ask the System Admin to set it up before proceeding!', "Supervisor Name");
                    end;*/


                    //IF CONFIRM('Are you sure you want to send these targets for review to '+"Supervisor Name"+'? ', FALSE) = TRUE THEN
                    if Confirm('Are you sure you want to approve these targets? ', false) = true then begin
                        Rec."Sent to Supervisor" := true;
                        Rec."Approved By Supervisor" := true;
                        Rec."DateTime Approved" := CurrentDateTime();
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
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        //FRED 5/3/23 Limit modification to within set dates
        HrAppraissalPeriods.Reset;
        HrAppraissalPeriods.SetRange(Code, Rec.Period);
        if HrAppraissalPeriods.FindFirst then begin
            if (HrAppraissalPeriods."Allow Edits From" <> 0D) and (HrAppraissalPeriods."Allow Edits To" <> 0D) then begin
                if (Today < HrAppraissalPeriods."Allow Edits From") or (Today > HrAppraissalPeriods."Allow Edits To") then begin
                    Error('You are no longer allowed to modify this target because the working date is outside the allowable modification dates for this period!');
                end;
            end;
        end;

        //Sorted OnOpenPage but this is just for abundance of caution
        /*IF "Approved By Supervisor" THEN
          ERROR('You are not allowed to edit targets after approval!');*/

    end;

    trigger OnOpenPage()
    begin
        if Rec."Approved By Supervisor" then
            CurrPage.Editable := false;
    end;

    var
        Targets: Record "Staff Target Objectives";
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
        HrAppraissalPeriods: Record "HR Appraisal Periods";

    [ServiceEnabled]
    procedure SendEmailNotification(DocNo: Code[20]; SenderEmpNo: Code[30]; ApproverEmpNo: Code[30]; SenderName: Text[100]; ApproverName: Text[100]; Direction: Code[70]; Verdict: Code[70])
    var
        Subject: Code[30];
        BodyText: Text[250];
        RecipientName: Text[250];
        RecipientEmail: Text[100];
        EmpRec: Record Employee;
    begin
        RecipientEmail := '';
        RecipientName := '';
        if Direction = 'UP' then begin
            Subject := 'REQUEST FOR APPROVAL';
            RecipientName := ApproverName;
            BodyText := 'You have a pending Staff Targets approval, Document No: ' + DocNo + ' from ' + SenderName + '. Kindly Log in and check the document then Approve/Reject on your basis.';

            EmpRec.Reset();
            EmpRec.SetRange("No.", ApproverEmpNo);
            EmpRec.SetRange("Company E-Mail", '<>%1', '');
            if EmpRec.Find('-') then
                RecipientEmail := EmpRec."Company E-Mail";
        end else begin
            RecipientName := SenderName;
            if Verdict = 'APPROVED' then begin
                Subject := 'TARGETS APPROVED';
                BodyText := 'Your Staff Targets approval request for Document No: ' + DocNo + ' has been approved by your supervisor, ' + ApproverName + '. Kindly Log in to the system then proceed with subsequent steps.';
            end else begin
                Subject := 'TARGETS REJECTED';
                BodyText := 'Your Staff Targets approval request for Document No: ' + DocNo + ' has been rejected by your supervisor, ' + ApproverName + '. Kindly Log in to the system then take the necessary steps.';

                EmpRec.Reset();
                EmpRec.SetRange("No.", SenderEmpNo);
                EmpRec.SetRange("Company E-Mail", '<>%1', '');
                if EmpRec.Find('-') then
                    RecipientEmail := EmpRec."Company E-Mail";
            end;
        end;

        if RecipientEmail <> '' then begin
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
}