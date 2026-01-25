page 51525560 "Employee Absentism Card"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Employee Absentism";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Absent No."; Rec."Absent No.")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                    Editable = true;
                    NotBlank = true;

                    trigger OnValidate()
                    begin
                        if Rec."Employee No" <> '' then
                            LinesVisible := true;
                    end;
                }
                field("Absent From"; Rec."Absent From")
                {
                    NotBlank = true;
                }
                field("Absent To"; Rec."Absent To")
                {
                    NotBlank = true;
                }
                field("Reason for Absentism"; Rec."Reason for Absentism")
                {
                    NotBlank = true;
                }
                field(Penalty; Rec.Penalty)
                {
                    NotBlank = true;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                }
                field("No. of  Days Absent"; Rec."No. of  Days Absent")
                {
                    Editable = false;
                }
            }
            part("Employee Absentism List"; "Employee Absentism Line")
            {
                Caption = 'Employee Absentism List';
                SubPageLink = "Employee No" = FIELD("Employee No");
                Visible = LinesVisible;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendMail)
            {
                Caption = 'SendMail';
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to report this case?') = true then begin
                        HumanResourcesSetupRec.Get;
                        Rec.TestField("No. of  Days Absent");
                        Rec.TestField("Employee No");

                        if UserSetup.Get(UserId) then
                            SenderAddress := UserSetup."E-Mail";
                        //Get Hr hod email
                        if UserSetupCopy.Get(HumanResourcesSetupRec."HR HOD") then
                            HRHoDEmail := UserSetupCopy."E-Mail";
                        CompanyInformationRec.Get;
                        //CompanyInformationRec.TestField("Administrator Email");
                        if SenderAddress <> '' then begin
                            SenderName := CompanyName;
                            Body := StrSubstNo('Hello,<br>This is to bring to your attention %1 absence  for %2 days for your action<br><br>Kind Regardsbr<br>');
                            //Body := StrSubstNo(Body, "Absent No.", "Employee Name");
                            Subject := StrSubstNo('REF:Employee Absence');
                            //SMTPSetup.CreateMessage(SenderName, SenderAddress, HRHoDEmail, Subject, Body, true);
                            //SMTPSetup.Send;
                            Rec.Status := Rec.Status::Released;
                            Rec.Modify;
                        end;

                    end
                    else
                        exit;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Employee No" <> '' then
            LinesVisible := true;
    end;

    var
        email: Text[50];
        Mail: Codeunit Mail;
        EmployeeRec: Record Employee;
        UserSetup: Record "User Setup";
        OfficeEmail: Text[50];
        d: Date;
        LinesVisible: Boolean;
        CompanyInformationRec: Record "Company Information";
        //SMTPSetup: Codeunit "SMTP Mail";
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
}