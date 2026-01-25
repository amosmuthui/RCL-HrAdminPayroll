page 51525408 "Training Schedule Card"
{
    ApplicationArea = All;
    Caption = 'Training Schedule Card';
    PageType = Card;
    SourceTable = "Training Schedules";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = EnableEditing;
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Emp No."; Rec."Emp No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Emp No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Training No."; Rec."Training No.")
                {
                    ToolTip = 'Specifies the value of the Training No. field.';
                }
                field("Training Title"; Rec."Training Title")
                {
                    ToolTip = 'Specifies the value of the Training Title field.';
                }
                field("Training Description"; Rec."Training Description")
                {
                    ToolTip = 'Specifies the value of the Training Description field.';
                }
                field(Department; Rec.Department)
                {
                    Visible = true;
                }
                field(Section; Rec.Section)
                {
                    Visible = false;
                }
                field(Position; Rec.Position)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Position ID field.';
                }
                field("Job Title"; Rec."Job Title")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Position Title field.';
                }
                field(Frequency; Rec.Frequency)
                { }
                field("Duration"; Rec."Duration")
                {
                    Caption = 'Duration (H,D,M,Y)';
                    ToolTip = 'Specify a number then letter H for hours, D-days, M-months, Y-years eg 3M';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Training Location"; Rec."Training Location")
                { }
                field("Trainer Category"; Rec."Trainer Category")
                { }
                field("Trainer No."; Rec."Trainer No.")
                { }
                field("Trainer Name"; Rec."Trainer Name")
                { }
                field("Talent Dev. No."; Rec."Talent Dev. No.")
                { }
                field("Talent Development Specialist"; Rec."Talent Development Specialist")
                { }
                field(Objectives; Rec.Objectives)
                {
                    MultiLine = true;
                }
                group("Costs (RWF)")
                {
                    field("Instructor Allowance"; Rec."Instructor Allowance")
                    { }
                    field("Facility Costs"; Rec."Facility Costs")
                    { }
                    /*field("Facility Lunch"; Rec."Facility Lunch")
                    { }*/
                    field("Head office Lunch"; Rec."Head office Lunch")
                    { }
                    /*field("Other Costs"; Rec."Other Costs")
                    { }*/
                }
                field("Training Report (Summary)"; Rec."Training Report (Summary)")
                {
                    ToolTip = 'Specifies the value of the Training Report (Summary) field.';
                    MultiLine = true;
                }
                field("Certificates Issued?"; Rec."Certificates Issued?")
                { }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Participants Count"; Rec."Participants Count")
                { }
                field("Legacy Data"; Rec."Legacy Data")
                { }
            }
            part("Training Schedule Lines"; "Training Schedule Lines")
            {
                Caption = 'Participants';
                SubPageLink = "Schedule No." = FIELD("No.");
                UpdatePropagation = Both;
                Editable = EnableEditing;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    //DocumentAttachmentDetails.SetFilters(FALSE, Rec."No.");
                    DocumentAttachmentDetails.RunModal;
                end;
            }
            action("Additional Instructors")
            {
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Additional Instructors";
                RunPageLink = "Class No." = field("No.");
            }
            action("Notify Participants")
            {
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    TrainSchedLines: Record "Training Schedule Lines";
                    Email: Codeunit "Email";
                    EmailMessage: Codeunit "Email message";
                    emailhdr: Text;
                    emailbody: Text;
                    Window: Dialog;
                    TotalCount: Integer;
                    Percentage: Integer;
                    Counter: Integer;
                    Emp: Record Employee;
                    EmailsSent: Integer;

                /*filePath: Text;
                exportFile: File;
                dataOutStream: OutStream;*/
                begin
                    EmailsSent := 0;

                    if Rec."Participants Emailed" then
                        if not Confirm('The participants were already notified on ' + Format(Rec."Participants Emailed On") + '. Do you still want to email them?') then exit;
                    Window.Open('Notifying participant: #1##');

                    TrainSchedLines.Reset();
                    TrainSchedLines.SetRange("Schedule No.", Rec."No.");
                    if TrainSchedLines.FindSet() then begin
                        repeat
                            Window.Update(1, TrainSchedLines."Emp No." + ' : ' + TrainSchedLines."Employee Name");

                            Emp.Reset();
                            Emp.SetRange("No.", TrainSchedLines."Emp No.");
                            if Emp.FindFirst() then begin
                                if Emp."Company E-Mail" <> '' then begin
                                    emailbody := 'Dear ' + TrainSchedLines."Employee Name" + ',<br>';
                                    emailbody := emailbody + '<p>Kindly note that you are a participant of this training: <strong>' + Rec."Training Title" + '</strong> which has been scheduled to take place on <strong>' + Format(Rec."Start Date") + '</strong>. Kindly prepare accordingly.<br>';
                                    //emailbody := emailbody + 'Kindly go through it, sign, then send back to us. <br> For any inquiries, reach us via <b>' + setuprec."Procurement Email" + '</b>. <p>';
                                    emailbody := emailbody + 'Kind Regards.<br><br>';
                                    EmailMessage.Create(Emp."Company E-Mail", 'Training Schedule: ' + Rec."Training Title", emailbody, true);
                                    Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
                                    EmailsSent += 1;
                                end;
                            end;
                        until TrainSchedLines.Next() = 0;
                    end;

                    Window.Close;
                    if EmailsSent > 0 then begin
                        Rec."Participants Emailed" := true;
                        Rec."Participants Emailed On" := CurrentDateTime;
                        Rec.Modify;
                        Message('Participant(s) Notified Successfully!!');
                    end else
                        Error('Notifications not sent! Try again later.');
                end;
            }

            action("Update Records")
            {
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    if UserId = 'RWANDAIR\PORTALUSER' then
                        UpdateRecords();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        LineNo: Integer;
        TrainingMasterRec: Record "Training Master Plan Header";
        OldEmpNo: Code[50];
        NewEmpNo: Code[50];
        Update: Boolean;
    begin
        CurrPage.Editable(true);
        EnableEditing := true;
        if TrainingMasterRec.IsAReadOnlyUser() then
            EnableEditing := false;//CurrPage.Editable(false);
        /*Classes.Reset();
        Classes.SetRange("Legacy Data", true);
        if Classes.FindSet() then
            repeat
                //LineNo := 0;
                Participants.Reset();
                Participants.SetRange("Schedule No.", Classes."No.");
                //Participants.SetRange("Emp No.",'WB ');
                if Participants.FindSet() then
                    repeat
                        Update := true;
                        //LineNo += 1;
                        //Participants."Line No." := LineNo;
                        if StrPos(Participants."Emp No.", 'WB ') <> 0 then begin
                            OldEmpNo := Participants."Emp No.";
                            NewEmpNo := 'WB' + DelChr(CopyStr(Participants."Emp No.", 3), '=', ' ');
                            OtherParticipants.Reset();
                            OtherParticipants.SetRange("Schedule No.", Classes."No.");
                            OtherParticipants.SetRange("Emp No.", NewEmpNo);
                            if OtherParticipants.FindFirst() then begin
                                Update := false;
                                if (OtherParticipants."Certificate Serial No." = '') and (OtherParticipants."Certificate Link" = '') then begin
                                    OtherParticipants.delete();
                                    Update := true;
                                end;
                            end;
                            Participants."Emp No." := NewEmpNo;
                            EmpRec.Reset();
                            EmpRec.SetRange("No.", NewEmpNo);
                            if EmpRec.FindFirst() then begin
                                Participants."Employee Name" := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
                                Participants."Department Code" := EmpRec."Responsibility Center";
                                Participants."Job Title" := EmpRec."Job Title";
                                Participants.Section := EmpRec."Sub Responsibility Center";
                            end;
                            //Participants.Validate("Emp No.");
                            Participants.updateParticipantType();
                            if Update then
                            //Delete then add as a new entry
                                Participants.Rename(NewEmpNo, Classes."No."); //Participants.Modify();
                        end;
                    until Participants.Next() = 0;
            //Classes.Validate("Start Date");
            //Classes.Validate(Status);
            until Classes.Next() = 0;*/
    end;

    var
        Classes: Record "Training Schedules";
        Participants: Record "Training Schedule Lines";
        OtherParticipants: Record "Training Schedule Lines";
        ParticipantInit: Record "Training Schedule Lines";
        EmpRec: Record Employee;
        EnableEditing: Boolean;
        Window: Dialog;


    procedure UpdateRecords()
    var
        LineNo: Integer;
        TrainingMasterRec: Record "Training Master Plan Header";
        OldEmpNo: Code[50];
        NewEmpNo: Code[50];
        Update: Boolean;
        DocAttachments: Record "Document Attachment";
        DocAttachmentsInit: Record "Document Attachment";
    begin
        Window.Open('Processing: ##');
        Classes.Reset();
        Classes.SetRange("Legacy Data", true);
        if Classes.FindSet() then
            repeat
                //LineNo := 0;
                Participants.Reset();
                Participants.SetRange("Schedule No.", Classes."No.");
                //Participants.SetRange("Emp No.",'WB ');
                if Participants.FindSet() then
                    repeat
                        Window.Update(0, Participants."Emp No.");
                        Update := true;
                        //LineNo += 1;
                        //Participants."Line No." := LineNo;
                        if StrPos(Participants."Emp No.", 'WB ') <> 0 then begin
                            OldEmpNo := Participants."Emp No.";
                            NewEmpNo := 'WB' + DelChr(CopyStr(Participants."Emp No.", 3), '=', ' ');
                            OtherParticipants.Reset();
                            OtherParticipants.SetRange("Schedule No.", Classes."No.");
                            OtherParticipants.SetRange("Emp No.", NewEmpNo);
                            if OtherParticipants.FindFirst() then begin
                                Update := false;
                                if (OtherParticipants."Certificate Serial No." = '') and (OtherParticipants."Certificate Link" = '') then begin
                                    OtherParticipants.delete();
                                    Update := true;
                                end;
                            end;
                            //Participants."Emp No." := NewEmpNo;
                            EmpRec.Reset();
                            EmpRec.SetRange("No.", NewEmpNo);
                            if EmpRec.FindFirst() then begin
                                Participants."Employee Name" := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
                                Participants."Department Code" := EmpRec."Responsibility Center";
                                Participants."Job Title" := EmpRec."Job Title";
                                Participants.Section := EmpRec."Sub Responsibility Center";
                            end;
                            //Participants.Validate("Emp No.");
                            //Participants.updateParticipantType();
                            if Update then begin
                                //Delete then add as a new entry
                                //Participants.Rename(NewEmpNo, Classes."No."); //Participants.Modify();
                                ParticipantInit.Init();
                                ParticipantInit.TransferFields(Participants);
                                ParticipantInit."Emp No." := NewEmpNo;
                                ParticipantInit.updateParticipantType();
                                Participants.Delete();
                                ParticipantInit.Insert();

                                //Cater for attachments
                                DocAttachments.Reset();
                                DocAttachments.SetRange("Table ID", Database::"Training Schedule Lines");
                                DocAttachments.SetRange("No.", Classes."No." + '-' + OldEmpNo);
                                if DocAttachments.FindSet() then
                                    repeat
                                        DocAttachments."No." := Classes."No." + '-' + NewEmpNo;
                                        DocAttachments.Modify();
                                    until DocAttachments.Next() = 0;
                            end;
                        end;
                    until Participants.Next() = 0;
            //Classes.Validate("Start Date");
            //Classes.Validate(Status);
            until Classes.Next() = 0;
        Window.Close();
    end;
}