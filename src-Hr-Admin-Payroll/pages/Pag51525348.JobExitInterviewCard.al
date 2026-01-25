page 51525348 "Job Exit Interview Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Job Exit Interview";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Employee No."; Rec."Employee No.")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                }
                field(Supervisor; Rec.Supervisor)
                {
                    Editable = false;
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                { }
                field("Date of Join"; Rec."Date of Join")
                {
                    Editable = false;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                }
                field("Reason for Leaving"; Rec."Reason for Leaving")
                {
                }
                field("Job Satisfying areas"; Rec."Job Satisfying areas")
                {
                    MultiLine = true;
                }
                field("Job Frustrating Areas"; Rec."Job Frustrating Areas")
                {
                    MultiLine = true;
                }
                field("Complicated Company Policies"; Rec."Complicated Company Policies")
                {
                    Caption = 'Complicated Company Policies/Procedures';
                    MultiLine = true;
                }
                field("Future Re-Employment"; Rec."Future Re-Employment")
                {
                }
                field("Recommend To Others"; Rec."Recommend To Others")
                {
                    Caption = 'Would you recommend us to Others?';
                }
                field("Leaving could have prevented"; Rec."Leaving could have prevented")
                {

                    trigger OnValidate()
                    begin
                        if Rec."Leaving could have prevented" = true then
                            PreventiveMeasureDescriptionEnabled := true
                        else
                            PreventiveMeasureDescriptionEnabled := false;
                    end;
                }
                group(Control25)
                {
                    ShowCaption = false;
                    Visible = PreventiveMeasureDescriptionEnabled;
                    field("Preventive Measure Description"; Rec."Preventive Measure Description")
                    {
                        MultiLine = true;
                    }
                }
            }
            group("Employment Experience Rating")
            {
                Caption = 'Employment Experience Rating';
            }
            part(Control19; "Employee work Experience Ratin")
            {
                SubPageLink = "Exit Interview Code" = FIELD(Code);
            }
            group("Supervisor Rating")
            {
                Caption = 'Supervisor Rating';
            }
            part("Employee-Supervisor Experience Rating"; "Employee Supervisor Exp Rating")
            {
                Caption = 'Employee-Supervisor Experience Rating';
                SubPageLink = "Exit Interview Code" = FIELD(Code);
            }
            field("Other Helpful  Information"; Rec."Other Helpful  Information")
            {
                MultiLine = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            /*action("Send Mail")
            {
                Caption = 'Send Mail';
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to send notification to your supervisor?') = true then begin
                        HumanResourcesSetupRec.Get;
                        TestField("Termination Date");
                        TestField("Reason for Leaving");

                        //Get Hod's email
                        SupervisorEmail := '';
                        UserSetupCopy.Reset;
                        UserSetupCopy.SetRange(UserSetupCopy."Employee No.", "Employee No.");
                        if UserSetupCopy.FindFirst then
                            if UserSetupRec.Get(UserSetupCopy."Immediate Supervisor") then
                                SupervisorEmail := UserSetupRec."E-Mail";

                        //Get Hr hod email
                        if UserSetupCopy.Get(HumanResourcesSetupRec."HR HOD") then
                            HRHoDEmail := UserSetupCopy."E-Mail";

                        CompanyInformationRec.Get;
                        CompanyInformationRec.TestField("Administrator Email");
                        SenderAddress := CompanyInformationRec."Administrator Email";
                        if SenderAddress <> '' then begin
                            SenderName := CompanyName;
                            Body := StrSubstNo('Hello,<br>This is to bring to your attention my exit interview %1  for your action<br><br>Kind Regardsbr<br>');
                            Body := StrSubstNo(Body, Code);
                            Subject := StrSubstNo('REF:Exit Interview');
                            SMTPSetup.CreateMessage(SenderName, SenderAddress, SupervisorEmail, Subject, Body, true);
                            SMTPSetup.AddCC(HRHoDEmail);
                            SMTPSetup.Send;
                            Rec.Modify;
                        end;
                        CurrPage.Close();
                    end;
                end;
            }*/
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Leaving could have prevented" = true then
            PreventiveMeasureDescriptionEnabled := true
        else
            PreventiveMeasureDescriptionEnabled := false;
    end;

    var
        CompanyInformationRec: Record "Company Information";
        //SMTPSetup: Codeunit "SMTP Mail";
        UserSetup: Record "User Setup";
        SenderAddress: Text[80];
        Recipients: Text[80];
        SenderName: Text[50];
        Body: Text[250];
        Subject: Text[80];
        HumanResourcesSetupRec: Record "Human Resources Setup";
        userchoice: Integer;
        UserSetupCopy: Record "User Setup";
        UserSetupRec: Record "User Setup";
        SupervisorEmail: Text;
        HRHoDEmail: Text;
        PreventiveMeasureDescriptionEnabled: Boolean;
}