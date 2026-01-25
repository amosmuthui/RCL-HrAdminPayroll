page 51525377 "Leave Recall"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Leave Recall";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Leave Application"; Rec."Leave Application")
                {
                    NotBlank = true;
                }
                field("Recall Date"; Rec."Recall Date")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = false;
                }
                field("Department Name"; Rec."Department Name")
                {
                    Editable = false;
                }
                field("Leave Start Date"; Rec."Leave Start Date")
                {
                    Editable = false;
                }
                field("Leave Ending Date"; Rec."Leave Ending Date")
                {
                    Editable = false;
                }
                field("Leave Days"; Rec."Leave Days")
                {
                }
                field("No. of Off Days"; Rec."No. of Off Days")
                {
                    Caption = 'No. of Recalled Days';
                    Editable = true;
                }
                field("Recalled From"; Rec."Recalled From")
                {
                }
                field("Recalled To"; Rec."Recalled To")
                {
                    Editable = false;
                }
                field("Reason for Recall"; Rec."Reason for Recall")
                {
                    MultiLine = true;
                    NotBlank = true;
                }
                field("Recalled By"; Rec."Recalled By")
                {
                    Editable = false;
                    NotBlank = true;
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                    Visible = false;
                }
                field("Head Of Department"; Rec."Head Of Department")
                {
                    Caption = 'Recalling Department';
                    Editable = false;
                    NotBlank = true;
                    Visible = false;
                }
                field(Posted; Rec.Posted)
                {
                }
                field("Posting DateTime"; Rec."Posting DateTime")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Email")
            {
                Caption = 'Post Recall';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = not Rec.Posted;

                trigger OnAction()
                var
                    LRegister: Record "Employee Leave Application";
                    HRLeaveApplication: Record "Employee Leave Application";
                    HRLeavePeriods: Record "HR Leave Periods";
                    journal: Record "HR Leave Journal Line";
                    HRSetup: Record "Human Resources Setup";
                    PortalApprovalsCU: Codeunit "Custom Helper Functions HR";
                begin
                    if not CanEditLeaveInfo then
                        Error('You are not authorized to perform this operation!');

                    if Confirm('Are you sure you want to recall this employee from leave?') = true then begin
                        Rec.TestField("Leave Application");
                        Rec.TestField("Employee No");
                        //TestField(Name);
                        //TestField("Leave Ending Date");
                        Rec.TestField("Recalled From");
                        //TestField("Recalled To");
                        Rec.TestField("No. of Off Days");
                        Rec.TestField("Reason for Recall");
                        //TESTFIELD("Head Of Department");
                        //TESTFIELD("Department Name");
                        Rec.TestField("Recall Date");

                        /*if EmployeeRec.Get("Employee No") then
                            email := EmployeeRec."E-Mail";
                        HumanResourcesSetupRec.Get;
                        if Users.Get(HumanResourcesSetupRec."HR HOD") then
                            HrEmail := Users."E-Mail";

                        EmployeeMail := '';
                        UserSetup.Reset;
                        UserSetup.SetRange(UserSetup."Employee No.", "Employee No");
                        if UserSetup.Find('-') then begin
                            EmployeeMail := UserSetup."E-Mail";
                        end;


                        if UserSetup.Get(UserId) then
                            SenderAddress := UserSetup."E-Mail"; //ERROR('**%1..\%2',SenderAddress,hod);

                        CompInfo.Reset;
                        CompInfo.Get;
                        SMTP.CreateMessage(CompanyName, CompInfo."HR Support Email", EmployeeMail, 'Recall for Leave No ' + "Leave Application", "Employee Name" +
                        ' on leave to ' + Format("Leave Ending Date") + ' has been recalled for ' + Format("No. of Off Days") + ' from '
                        + Format("Recalled From") + ' to ' + Format("Recalled To") + ' by ' + Name + 'on ' + Format("Recall Date") +
                        ' reason for recall, ' + "Reason for Recall" + ', as requested by ' + "Department Name" + ' department', true);
                        SMTP.AddCC(HrEmail);
                        SMTP.Send;
                        Rec.Status := Rec.Status::Released;*/

                        HRSetup.Get();
                        journal.Reset;
                        journal.SetRange("Journal Template Name", HRSetup."Default Leave Posting Template");
                        journal.SetRange("Journal Batch Name", HRSetup."Positive Leave Posting Batch");
                        if journal.Find('-') then
                            journal.DeleteAll;

                        journal.Init;
                        journal."Line No." := journal."Line No." + 1000;
                        journal."Journal Batch Name" := HRSetup."Positive Leave Posting Batch";
                        journal."Document No." := Rec."No.";
                        journal."Journal Template Name" := HRSetup."Default Leave Posting Template";
                        journal."Staff No." := Rec."Employee No";
                        journal.Validate("Staff No.");
                        journal."No. of Days" := Rec."No. of Off Days";
                        journal."Leave Period" := Rec."Leave Period";
                        journal."Leave Entry Type" := journal."Leave Entry Type"::Positive;
                        journal.Validate("Leave Entry Type");
                        journal.Description := Format(Rec."Leave Type") + ' ' + Rec."Employee No" + ' Recall ' + Rec."No.";
                        journal."Leave Type" := Rec."Leave Type";
                        journal."Posting Date" := Rec."Recall Date";
                        journal."Leave Period Start Date" := Rec."Recalled From";
                        journal."Leave Period End Date" := Rec."Recalled To";
                        journal.Validate("Leave Type");
                        journal.IsMonthlyAccrued := false;
                        journal.Insert;

                        journal.Reset;
                        journal.SetRange("Journal Template Name", HRSetup."Default Leave Posting Template");
                        journal.SetRange("Journal Batch Name", HRSetup."Positive Leave Posting Batch");
                        if journal.Find('-') then begin
                            CODEUNIT.Run(CODEUNIT::"HR Leave Jnl.-Post", journal);
                        end;
                        PortalApprovalsCU.SendLeaveRecallEmail(Rec."No.");
                        Rec.Posted := true;
                        Rec."Posting DateTime" := CurrentDateTime;
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                        Message('Leave recall posted successfully!');
                        CurrPage.Close();
                    end;
                end;
            }
            /*action("DMS Link")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin

                    GLSetup.Get();
                    link := GLSetup."DMS Imprest Link" + Rec."No.";
                    HyperLink(link);
                end;
            }*/
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.Editable(true);
        if Rec.Posted then
            CurrPage.Editable(false);

        CanEditLeaveInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        UserSetup.SetRange("Can Edit Leave Entitlement", true);
        if UserSetup.FindFirst() then
            CanEditLeaveInfo := true
        else
            CurrPage.Editable(false);



    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if not CanEditLeaveInfo then
            Error('You are not authorized to perform this operation!');
        HRLeavePeriods.Reset;
        HRLeavePeriods.SetRange(HRLeavePeriods.Closed, false);
        if HRLeavePeriods.FindLast then
            Rec."Leave Period" := HRLeavePeriods."Period Code"
        else
            Error('There is no open leave period!');
    end;

    var
        d: Date;
        Mail: Codeunit Mail;
        EmployeeRec: Record Employee;
        email: Text[50];
        UserSetup: Record "User Setup";
        OfficeEmail: Text[50];
        Requester: Text[50];
        hod: Text[80];
        CompInfo: Record "Company Information";
        SenderAddress: Text[80];
        Users: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        link: Text;
        EmployeeMail: Text;
        HrEmail: Text;
        HumanResourcesSetupRec: Record "Human Resources Setup";
        CanEditLeaveInfo: Boolean;
        HRLeavePeriods: Record "HR Leave Periods";
}