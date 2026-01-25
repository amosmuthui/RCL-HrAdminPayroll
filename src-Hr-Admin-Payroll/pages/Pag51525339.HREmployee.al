page 51525339 "HR Employee"
{
    ApplicationArea = All;
    Caption = 'Employee Card';
    DeleteAllowed = false;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field("Employee Act. Qty"; Rec."Employee Act. Qty")
            {
                Caption = 'Active';
                Editable = false;
            }
            field("Employee Arc. Qty"; Rec."Employee Arc. Qty")
            {
                Caption = 'Archived';
                Editable = false;
            }
            field("""Employee Act. Qty""+""Employee Arc. Qty"""; Rec."Employee Act. Qty" + Rec."Employee Arc. Qty")
            {
                Caption = 'All';
                Editable = false;
            }
            group("General Information")
            {
                Caption = 'General Information';
                Editable = CanEditCard;
                field("No."; Rec."No.")
                {
                    AssistEdit = true;
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        //   IF AssistEdit(xRec) THEN
                        //  CurrPage.UPDATE;
                    end;
                }
                field(Title; Rec.Title)
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                    DrillDown = true;
                    ShowMandatory = true;
                    Editable = false;
                }
                field("First Name"; Rec."First Name")
                {
                    ShowMandatory = true;
                    Editable = false;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    //Caption = 'Other Names';
                    //ShowMandatory = true;
                    Editable = false;
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field("ID Number"; Rec."ID Number")
                {
                    ShowMandatory = true;
                }
                field("Passport Number"; Rec."Passport Number")
                {
                }
                field("Driving Licence"; Rec."Driving Licence")
                {
                    Visible = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field(Picture; Rec.Image)
                {
                    Visible = true;
                }
                field("<Employee Signature>"; Rec."Employee Signature")
                {
                    Caption = 'Signature';
                }
                field(Disabled; Rec.Disabled)
                {
                    Caption = 'Tax Exemption';
                }
                field("Earns Gratuity"; Rec."Earns Gratuity")
                {
                }
                field("Pays tax"; Rec."Pays tax")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Manager No."; Rec."Manager No.")
                {
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {

                }
                field("Is Seconded"; Rec."Is Seconded")
                {
                }
                field("Apply Daily Rates"; Rec."Apply Daily Rates")
                {

                    trigger OnValidate()
                    begin
                        if (Rec."Daily Rate" > 0) and (not Rec."Apply Daily Rates") then
                            Error('You must select Apply Daily Rates before providing the daily rate!');
                    end;
                }
                field("Daily Rate"; Rec."Daily Rate")
                {
                }
                field("Exempt from Housing Levy"; Rec."Exempt from Housing Levy")
                {
                    Visible = false;
                }
                field("Skip Processing Housing Levy"; Rec."Skip Processing Housing Levy")
                {
                    Visible = false;
                }
                field("MyID Eligibility"; Rec."MyID Eligibility")
                { }
            }
            part(Control53; "Employee Disability Info")
            {
                SubPageLink = "Employee No." = FIELD("No.");
                Visible = Rec.Disabled = TRUE;
            }
            group("Personal Details")
            {
                Caption = 'Personal Details';
                Editable = CanEditCard;
                field(Gender; Rec.Gender)
                {
                }
                field("Marital Status"; Rec."Marital Status")
                {
                }
                field("No. of Children"; Rec."No. of Children")
                {
                }
                field(Religion; Rec.Religion)
                {
                }
                field(Nationality; Rec."Country/Region Code")
                {
                }

                field(Citizenship; Rec.Citizenship)
                {
                    Visible = false;
                }
                field(Province; Rec.Province)
                {

                }
                field(District; Rec.District)
                {

                }
                field(Sector; Rec.Sector)
                { }
                field(Cell; Rec.Cell)
                { }
                field(Village; Rec.Village)
                { }
                /*field("Ethnic Group"; Rec."Ethnic Group")
                {
                }
                field(County; Rec.County)
                {
                }
                field("Sub County"; Rec."Sub County")
                {
                }*/
                field(Constituency; Rec.Constituency)
                {
                    Visible = false;
                }
            }
            group("Job Information")
            {
                Caption = 'Job Information';
                field(Category; Rec.Category)
                {
                    Visible = false;
                }
                field("Workstation Country"; Rec."Workstation Country")
                {
                    Editable = MovementFieldsEditable;
                }
                field(Station; Rec.Station)
                {
                    Editable = MovementFieldsEditable;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = MovementFieldsEditable;
                }
                field("Is HoD"; Rec."Is HoD")
                { }
                field("Sub Responsibility Center"; Rec."Sub Responsibility Center")
                {
                    Caption = 'Section';
                    Editable = MovementFieldsEditable;
                }
                field("Sub Section"; Rec."Sub Section")
                {
                    Editable = CanEditCard;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = true;
                    Visible = false;
                }
                field(Position; Rec.Position)
                {
                    Caption = 'Job Title Code';
                    Visible = true;
                    Editable = MovementFieldsEditable;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
                }
                field("Annual Leave Entitlement"; Rec."Annual Leave Entitlement")
                {
                    Editable = CanEditLeaveInfo;
                }
                field("Suspend Leave Accrual"; Rec."Suspend Leave Accrual")
                {
                    Editable = CanEditLeaveInfo;
                }
                field("Leave Accrual Suspended By"; Rec."Leave Accrual Suspended By")
                { }
                field("Leave Accrual Suspended On"; Rec."Leave Accrual Suspended On")
                { }
                field("Medical Insurance"; Rec."Medical Insurance")
                {
                    Editable = CanEditCard;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = true;
                    Visible = false;
                }
                field(Level; Rec.Level)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Employee Job Type"; Rec."Employee Job Type")
                {
                    Caption = 'Job Type (for Fleet)';
                    Editable = true;
                    Enabled = true;
                    Visible = TRUE;
                }
                field("Notice Period"; Rec."Notice Period")
                {
                    Caption = 'Notice Period After Confirmation';
                    Editable = false;
                    Visible = false;
                }
                field("Current Appointment Date"; Rec."Current Appointment Date")
                {
                    Caption = 'Date of Current Apointment';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                }
            }
            part("Staff Movement"; "Internal Emp. History List")
            {
                SubPageLink = "Emp No." = FIELD("No.");
                Editable = CanEditCard;
            }
            group("Airtime Management")
            {
                field("Job Category - Admin"; Rec."Job Category")
                {
                    Caption = 'Job Category';
                    ApplicationArea = All;
                }
                field("Ineligible for Airtime"; Rec."Ineligible for Airtime")
                {
                    ApplicationArea = All;
                }
            }
            group("Payment Information")
            {
                Caption = 'Payment Information';
                Editable = CanEditPaymentInfo;
                field("PIN Number"; Rec."PIN Number")
                {
                    ShowMandatory = false;
                }
                field("NSSF No."; Rec."NSSF No.")
                {
                    ShowMandatory = false;
                    Visible = false;
                }
                field("NHIF No."; Rec."NHIF No.")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field(PensionNo; Rec."NSSF No.")
                { }
                field("Medical No."; Rec."NHIF No.")
                { }
                field("HELB No"; Rec."HELB No")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Co-Operative No"; Rec."Co-Operative No")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ShowMandatory = true;
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ShowMandatory = true;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                }
                field("Bank Branch Code"; Rec."Bank Branch Code")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Bank Brach Name"; Rec."Bank Brach Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                }
                field(IBAN; Rec.IBAN)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                    Visible = true;
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the employee has the account.';
                }
                field("Sort Code"; Rec."Sort Code")
                { }
                field(Indicatif; Rec.Indicatif)
                { }
                field("Code B.I.C."; Rec."Code B.I.C.")
                { }
                field("Posting Group"; Rec."Posting Group")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Contractual Amount Type"; Rec."Contractual Amount Type")
                {
                    Visible = false;
                }
                field("Assigned Gross Pay"; Rec."Assigned Gross Pay")
                {
                    Visible = false;
                }
                field("Contractual Amount Currency"; Rec."Contractual Amount Currency")
                {
                    Visible = false;
                }
                field("Basic Pay"; Rec."Basic Pay")
                {
                    Visible = false;
                }
                field("Payroll Country"; Rec."Payroll Country")
                {
                }
                field("Payroll Currency"; Rec."Payroll Currency")
                {
                }
                field("Payment/Bank Country"; Rec."Payment/Bank Country")
                {
                    ShowMandatory = true;
                }
                field("No Transport Allowance"; Rec."No Transport Allowance")
                {
                    Tooltip = 'Does not earn transport allowance';
                    Visible = false;
                }
                field("Applicable House Allowance (%)"; Rec."Applicable House Allowance (%)")
                {
                    Tooltip = 'For those who dont earn transport allowance';
                    Visible = false;
                }

                field("Apply Paye Multiplier"; Rec."Apply Paye Multiplier")
                { }
                field("Paye Multiplier"; Rec."Paye Multiplier")
                { }
                field("Secondment Amount"; Rec."Secondment Amount")
                {
                    Visible = false;
                }
                field("Secondment Basic"; Rec."Secondment Basic")
                {
                    Visible = false;
                }
                field("Salary Scale"; Rec."Salary Scale")
                {
                    Caption = 'Grade/Scale';
                    Visible = true;
                }
                field(Present; Rec.Present)
                {
                    Caption = 'Current Pointer';
                    Visible = true;
                }
                field(Previous; Rec.Previous)
                {
                    Caption = 'Previous Pointer';
                    Editable = false;
                    Visible = true;
                }
                field(Halt; Rec.Halt)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Home Ownership Status"; Rec."Home Ownership Status")
                {
                    Visible = false;
                }
            }
            group("Important Dates")
            {
                Caption = 'Important Dates';
                Editable = CanEditCard;
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    Visible = false;
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                    Caption = 'Date of First Appointment';
                }
                field("Years In Employment"; Rec."Years In Employment")
                {
                }
                field("Date of Appointment"; Rec."Date of Appointment")
                {
                    Caption = 'Date of Current Apointment';
                    Visible = false;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Current Contract Start Date"; Rec."Contract Start Date")
                {
                    Visible = true;
                }
                field("Current Contract End Date>"; Rec."Contract End Date")
                {
                    Visible = true;
                    Caption = 'Current Contract End Date';
                }
                field("Duration In Position"; Rec."Duration In Position")
                {
                    Visible = false;
                }
                field("End Of Probation Date"; Rec."End Of Probation Date")
                {
                }
                field("Pension Scheme Join"; Rec."Pension Scheme Join")
                {
                    Visible = false;
                }
                field("Date OfJoining Payroll"; Rec."Date OfJoining Payroll")
                {
                    Visible = false;
                }
                field("Retirement Date"; Rec."Retirement Date")
                {
                    Editable = false;
                }
                field("Remainig Years Before Retireme"; Rec."Remainig Years Before Retireme")
                {
                    Caption = 'Remaining Years Before Retirement';
                    Editable = false;
                }
                field("Suspend Probation Reminders"; Rec."Suspend Probation Reminders")
                {
                }
                field("Suspend Contract Reminders"; Rec."Suspend Contract Reminders")
                {
                }
                field("1Year Retirement Reminder Sent"; Rec."1Year Retirement Reminder Sent")
                {
                }
                field("Suspend Retirement Reminders"; Rec."Suspend Retirement Reminders")
                {
                }
            }
            group("Contact Information")
            {
                Caption = 'Contact Information';
                Editable = CanEditCard;
                field("Postal Address"; Rec."Postal Address")
                {
                    Visible = false;
                }
                field("Post Code2"; Rec."Post Code2")
                {
                    Caption = 'Post Code';
                    Visible = false;
                }
                field("Postal Address2"; Rec."Postal Address2")
                {
                    Visible = false;
                }
                field("Postal Address3"; Rec."Postal Address3")
                {
                    Visible = false;
                }
                field("Residential Address"; Rec."Residential Address")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Residential Address2"; Rec."Residential Address2")
                {
                    Visible = false;
                }
                field("Residential Address3"; Rec."Residential Address3")
                {
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Home Phone Number"; Rec."Home Phone Number")
                {
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                }
                field("Fax Number"; Rec."Fax Number")
                {
                    Visible = false;
                }
                field("Work Phone Number"; Rec."Work Phone Number")
                {
                    Visible = false;
                }
                field("Ext."; Rec."Ext.")
                {
                    Visible = false;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Caption = 'Personal Email';
                }
                field("Plot No."; Rec."Plot No.")
                { }
                field("Street No."; Rec."Street No.")
                { }
            }
            group("Contract Information")
            {
                Caption = 'Contract Information';
                Visible = false;
                field("Full / Part Time"; Rec."Full / Part Time")
                {
                    Visible = false;
                }
                field("Contract Number"; Rec."Contract Number")
                {
                    Visible = false;
                }
                field("Send Alert to"; Rec."Send Alert to")
                {
                    Visible = false;
                }
            }
            group(Disciplinary)
            {
                Caption = 'Disciplinary';
                Editable = CanEditCard;
                field("Disciplinary Actions"; Rec."Disciplinary Actions")
                {
                }
            }
            group(Separation)
            {
                Caption = 'Separation';
                Editable = CanEditCard;
                field(Status; Rec.Status)
                {
                }
                field("Date Of Leaving"; Rec."Date Of Leaving")
                {
                }
                field("Cause of Inactivity Code"; Rec."Cause of Inactivity Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a code for the cause of inactivity by the employee.';
                }
                field("Cause of Inactivity"; Rec."Cause of Inactivity")
                {

                }
                field("Termination Category"; Rec."Termination Category")
                {
                    Visible = false;
                }
                field("Served Notice Period"; Rec."Served Notice Period")
                {
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                    Visible = false;
                }
                field("Exit Interview"; Rec."Exit Interview")
                {
                }
                field("Exit Interview Date"; Rec."Exit Interview Date")
                {
                    Editable = false;
                }
                field("Exit Interview Done by"; Rec."Exit Interview Done by")
                {
                }
                field("Allow Re-Employment In Future"; Rec."Allow Re-Employment In Future")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1; "Employee Picture")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("No.");
                Visible = false;
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(5200),
                              "No." = FIELD("No.");
            }
            part("Applicant Attachments"; "Attached Documents")
            {
                ApplicationArea = All;
                Caption = 'Applicant Attachments';
                SubPageLink = "Table ID" = CONST(51525286),
                              "No." = FIELD("Job Application No.");
            }
            part("Academic Attachments"; "Academic Certificates FactBox")
            {
                ApplicationArea = All;
                Caption = 'Academic Attachments';
                SubPageLink = "Email Address" = FIELD("E-Mail");
                ;
            }
            part("Professional Certificates"; "Professional Certs FactBox")
            {
                ApplicationArea = All;
                Caption = 'Professional Certificates';
                SubPageLink = "Email Address" = FIELD("E-Mail");
            }
            systempart(Control1900383207; Links)
            {
                Visible = false;
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
            action("Employee Subscriptions")
            {
                Caption = 'Employee Subscriptions';
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
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
                    DocumentAttachmentDetails.RunModal;
                end;
            }
            action(DocAttachHRLetters)
            {
                ApplicationArea = All;
                Caption = 'Letters';
                Image = Attach;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CanViewHrLetters;

                trigger OnAction()
                var
                    HRLettersAttachmentDetails: Page "HR Letters Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    HRLettersAttachmentDetails.OpenForRecRef(RecRef);
                    HRLettersAttachmentDetails.RunModal;
                end;
            }
            action("Update Movement")
            {
                ApplicationArea = All;
                Caption = 'Create Initial Staff Movement';
                Image = New;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CanEditCard;
                //Visible = false;
                ToolTip = 'Creates the initial entry in the staff movement table';

                trigger OnAction()
                var
                    ExistingMovements: Record "Internal Employement History";
                    MovementInit: Record "Internal Employement History";
                    Emps: Record Employee;
                    Window: Dialog;
                    AssignmentMatrix: Record "Assignment Matrix";
                //PayPeriods: Record pa
                begin
                    Emps.Reset();
                    if Emps.FindSet() then begin
                        Window.OPEN('Processing staff movement data for Employee No. #######1');
                        repeat
                            Window.Update(1, Emps."No.");
                            ExistingMovements.Reset();
                            ExistingMovements.SetRange("Emp No.", Emps."No.");
                            if not ExistingMovements.FindFirst() then begin
                                MovementInit.Reset();
                                MovementInit.Init();
                                MovementInit."Emp No." := Emps."No.";
                                //MovementInit.Validate("Emp No.");
                                MovementInit."Employee Name" := Emps."First Name" + ' ' + Emps."Middle Name" + ' ' + Emps."Last Name";
                                MovementInit."Position Code" := Emps.Position;
                                MovementInit."Job Title" := Emps."Job Title";
                                MovementInit."Dept Code" := Emps."Responsibility Center";
                                MovementInit."Department Name" := Emps."Responsibility Center Name";
                                MovementInit."Section Code" := Emps."Sub Responsibility Center";
                                MovementInit.Validate("Section Code");
                                MovementInit."Station Code" := Emps.Station;
                                MovementInit.Validate("Station Code");
                                MovementInit."Workstation Country" := Emps."Workstation Country";
                                MovementInit."Payroll Country" := Emps."Payroll Country";
                                MovementInit."Payroll Currency" := Emps."Payroll Currency";
                                MovementInit.Type := MovementInit.Type::Initial;
                                MovementInit."Contractual Amount Currency" := Emps."Contractual Amount Currency";
                                MovementInit."Contractual Amount Type" := Emps."Contractual Amount Type";
                                MovementInit."Contractual Amount Value" := Emps."Assigned Gross Pay";
                                MovementInit."Apply Paye Multiplier" := Emps."Apply Paye Multiplier";
                                MovementInit."Paye Multiplier" := Emps."Paye Multiplier";
                                if Emps."Date Of Join" = 0D then begin
                                    Emps."Date Of Join" := Emps."Date of Appointment";
                                end;
                                MovementInit."First Date" := Emps."Date Of Join";
                                if MovementInit."First Date" = 0D then
                                    MovementInit."First Date" := 19000101D;
                                MovementInit."Last Date" := Emps."Date Of Leaving";
                                if Emps."Date Of Leaving" = 0D then
                                    MovementInit."Last Date" := Emps."Retirement Date";
                                if MovementInit."Last Date" = 0D then
                                    MovementInit."Last Date" := 20501231D;
                                MovementInit.Status := MovementInit.Status::Current;
                                MovementInit."Payroll Country" := Emps."Payroll Country";
                                MovementInit.Insert(true);
                            end;/* else begin
                                if (/(ExistingMovements.Type = ExistingMovements.Type::"August 2023") and/ (MovementInit.Status = MovementInit.Status::Current)) then begin
                                    ExistingMovements.Validate("Emp No.");
                                    ExistingMovements."Contractual Amount Currency" := Emps."Contractual Amount Currency";
                                    ExistingMovements."Contractual Amount Type" := Emps."Contractual Amount Type";
                                    ExistingMovements."Contractual Amount Value" := Emps."Assigned Gross Pay";
                                    ExistingMovements."First Date" := Emps."Date Of Join";
                                    if ExistingMovements."First Date" = 0D then
                                        ExistingMovements."First Date" := 19000101D;
                                    ExistingMovements."Last Date" := Emps."Date Of Leaving";
                                    if ExistingMovements."Last Date" = 0D then
                                        ExistingMovements."Last Date" := 20501231D;
                                    ExistingMovements."Apply Paye Multiplier" := Emps."Apply Paye Multiplier";
                                    ExistingMovements."Paye Multiplier" := Emps."Paye Multiplier";
                                    ExistingMovements."Payroll Country" := Emps."Payroll Country";
                                    ExistingMovements.Modify();
                                end;
                            end;*/

                            //Update assignment matrix temporarily to capture the is flat amount
                            /*AssignmentMatrix.Reset();
                            AssignmentMatrix.SetRange("Employee No", Emps."No.");
                            AssignmentMatrix.SetRange("Payroll Period", 20230801D);
                            if AssignmentMatrix.FindSet() then
                                repeat
                                    AssignmentMatrix.Validate("Payroll Period");
                                    AssignmentMatrix.Modify();
                                until AssignmentMatrix.Next() = 0;*/
                            //Emps.Validate("Payroll Country");
                            Emps.Validate("No.");
                            Emps.Modify();
                        until Emps.Next() = 0;
                        Window.Close();
                        Message('Done');
                    end;

                end;
            }
            action("Refresh Dates")
            {
                ApplicationArea = All;
                //'Caption = 'Create Initial Staff Movement';
                Image = Attach;
                Promoted = false;
                Visible = false;
                ToolTip = 'Creates the initial entry in the staff movement table';

                trigger OnAction()
                var
                    Emps: Record Employee;
                    ExistingMovements: Record "Internal Employement History";
                    Window: Dialog;
                    PrevPeriod: Date;
                    CurrPeriod: Date;
                    Periods: Record "Payroll Period";
                    CausesOfInactivity: Record "Period Causes of Inactivity";
                    CausesOfInactivityInit: Record "Period Causes of Inactivity";
                    Sections: Record "Sub Responsibility Center";
                //PayPeriods: Record pa
                begin
                    Periods.Reset();
                    Periods.SetRange(Closed, false);
                    if Periods.FindFirst() then
                        CurrPeriod := Periods."Starting Date";
                    PrevPeriod := CalcDate('-1M', CurrPeriod);

                    Emps.Reset();
                    Emps.SetRange(Status, Emps.Status::Inactive);
                    if Emps.FindSet() then begin
                        Window.OPEN('Refreshing Dates for Employee No. #######1');
                        repeat
                            Window.Update(1, Emps."No.");
                            /*ExistingMovements.Reset();
                            ExistingMovements.SetRange("Emp No.", Emps."No.");
                            ExistingMovements.SetRange(Status, ExistingMovements.Status::Current);
                            //ExistingMovements.SetFilter("Last Date", '<=%1', CalcDate('CM', CurrPeriod));
                            if ExistingMovements.FindSet() then
                                repeat
                                    ExistingMovements."Position Code" := Emps.Position;
                                    ExistingMovements."Job Title" := Emps."Job Title";
                                    ExistingMovements."Dept Code" := Emps."Responsibility Center";
                                    ExistingMovements."Department Name" := Emps."Responsibility Center Name";
                                    ExistingMovements."Section Code" := Emps."Sub Responsibility Center";

                                    Sections.Reset();
                                    Sections.SetRange(Code, Emps."Sub Responsibility Center");
                                    if Sections.FindFirst() then
                                        ExistingMovements."Section Title" := Sections.Code;
                                    //ExistingMovements.Validate("Section Code");
                                    //ExistingMovements.Validate("Position Code");
                                    ExistingMovements.Modify();
                                until ExistingMovements.Next() = 0;*/

                            if Emps.Status = Emps.Status::Inactive then begin
                                ExistingMovements.Reset();
                                ExistingMovements.SetRange("Emp No.", Emps."No.");
                                ExistingMovements.SetRange(Status, ExistingMovements.Status::Current);
                                ExistingMovements.SetFilter("Last Date", '<=%1', CalcDate('CM', PrevPeriod));
                                if ExistingMovements.FindSet() then begin
                                    repeat
                                        CausesOfInactivity.Reset();
                                        CausesOfInactivity.SetRange("Emp No.", Emps."No.");
                                        CausesOfInactivity.SetRange("Payroll Period", PrevPeriod);
                                        //CausesOfInactivity.DeleteAll();
                                        if not CausesOfInactivity.FindFirst() then begin
                                            Emps.Validate("Cause of Inactivity Code");
                                            if Emps."Cause of Inactivity" <> '' then begin
                                                CausesOfInactivityInit.Reset();
                                                CausesOfInactivityInit.Init();
                                                CausesOfInactivityInit."Emp No." := Emps."No.";
                                                CausesOfInactivityInit."Payroll Period" := PrevPeriod;
                                                CausesOfInactivityInit."Cause of Inactivity" := Emps."Cause of Inactivity";
                                                CausesOfInactivityInit.Insert();
                                            end;
                                        end;
                                    until ExistingMovements.Next() = 0;
                                end;

                                //Terminal dues team
                                /*ExistingMovements.Reset();
                                ExistingMovements.SetRange("Emp No.", Emps."No.");
                                ExistingMovements.SetRange(Status, ExistingMovements.Status::Current);
                                ExistingMovements.SetFilter("Last Date", '>%1', CalcDate('CM', PrevPeriod));//Curr month
                                ExistingMovements.SetRange("Terminal Dues", true);
                                if ExistingMovements.FindSet() then begin
                                    repeat
                                        CausesOfInactivity.Reset();
                                        CausesOfInactivity.SetRange("Emp No.", Emps."No.");
                                        CausesOfInactivity.SetRange("Payroll Period", PrevPeriod);
                                        CausesOfInactivity.DeleteAll();

                                        /**ExistingMovements."Position Code" := Emps.Position;
                                        ExistingMovements."Dept Code" := Emps."Responsibility Center";
                                        ExistingMovements."Department Name" := Emps."Responsibility Center Name";
                                        ExistingMovements."Section Code" := Emps."Sub Responsibility Center";
                                        ExistingMovements.Validate("Section Code");
                                        ExistingMovements.Validate("Position Code");
                                        ExistingMovements.Modify();///

                                        Emps.Validate("Cause of Inactivity Code");
                                        if Emps."Cause of Inactivity" <> '' then begin
                                            CausesOfInactivityInit.Reset();
                                            CausesOfInactivityInit.Init();
                                            CausesOfInactivityInit."Emp No." := Emps."No.";
                                            CausesOfInactivityInit."Payroll Period" := PrevPeriod;
                                            CausesOfInactivityInit."Cause of Inactivity" := Emps."Cause of Inactivity";
                                            CausesOfInactivityInit.Insert();
                                        end;
                                    until ExistingMovements.Next() = 0;
                                end;*/
                            end;
                        /*if Emps."Date Of Birth" <> 0D then
                            Emps.Validate("Date Of Birth");*/
                        /*Emps.Validate(Position);
                        Emps.Modify();*/
                        until Emps.Next() = 0;
                        Window.Close();
                        Message('Done');
                    end;

                end;
            }
            action("Additional Transactions")
            {
                Caption = 'Additional Earnings and Deductions';
                Image = Payment;
                RunObject = Page "Additional Transactions";
                Visible = CanEditPaymentInfo or CanEditCard;
                RunPageLink = "WB No." = FIELD("No.");
            }
            action("Attach Document")
            {
                Caption = 'Attach Document';
                Image = Attach;
                Visible = false;

                trigger OnAction()
                begin
                    DocType := DocType::"Employee Data";
                    //Dmsmngr.UploadDocument(DocType, Rec."No.", Rec.FullName(), Rec.RecordId);
                end;
            }
            group("Pay Manager")
            {
                Caption = 'Pay Manager';
                action("Employee Accounts Mapping")
                {
                    Image = Accounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //RunObject = Page "Employee Account Mapping";
                    //RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                }
            }
            group("Employee's")
            {
                Caption = 'Employee''s';
                group("Employee Details")
                {
                    Caption = 'Employee Details';
                    Image = HumanResources;
                    /*action("Staff Timesheet")
                    {
                        Caption = 'Staff Timesheet';
                        RunObject = Page "Staff Timesheet";
                        RunPageLink = "Employee No." = FIELD("No."),
                                      "Approval Status" = FILTER(Employee);
                        Visible = false;
                    }
                    action("Supervisor Timesheet")
                    {
                        Caption = 'Supervisor Timesheet';
                        RunObject = Page "Supervisor Timesheet";
                        RunPageLink = "Supervisor No." = FIELD("No.");
                        Visible = false;
                    }
                    action("Approved Timesheets")
                    {
                        Caption = 'Approved Timesheets';
                        RunObject = Page "Approved Timesheet";
                        RunPageLink = "Employee No." = FIELD("No.");
                        Visible = false;
                    }*/
                    action("Q&ualifications")
                    {
                        Caption = 'Q&ualifications';
                        RunObject = Page "Emp Qualification";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    action("Employment History")
                    {
                        Caption = 'Employment History';
                        RunObject = Page "Employment History";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    action("Employee Transfer History")
                    {
                        Caption = 'Employee Transfer History';
                        RunObject = Page "Employee Transfer History";
                        RunPageLink = "Employee No." = FIELD("No.");
                    }
                    action("Employee Responsibilities")
                    {
                        Caption = 'Employee Responsibilities';
                        RunObject = Page "J. Responsiblities";
                        RunPageLink = "Job ID" = FIELD("No.");
                    }
                    separator(Action129)
                    {
                        Caption = '';
                    }
                    action("Employee Appointment Checklist")
                    {
                        Caption = 'Employee Appointment Checklist';
                        RunObject = Page "Appointment Checklist";
                        RunPageLink = "Employee No." = FIELD("No.");
                    }
                    separator(Action127)
                    {
                        Caption = '';
                    }
                    action(Terminate)
                    {
                        Caption = 'Terminate';
                        Visible = false;

                        trigger OnAction()
                        begin
                            Rec.TestField("Date Of Leaving");
                            Rec.TestField("Termination Category");
                            Rec.TestField("Grounds for Term. Code");
                            Rec.Status := Rec.Status::Inactive;
                            Rec.Modify;
                            Message('Employee %1: %2 %3 has been terminated', Rec."No.", Rec."First Name", Rec."Last Name");
                        end;
                    }
                    separator(Action125)
                    {
                        Caption = '';
                    }
                    /*action(Action124)
                    {
                        Caption = 'Employee Responsibilities';
                        RunObject = Page "Employee Responsibilities";
                        RunPageLink = "No." = FIELD("No.");
                        Visible = false;
                    }*/
                    separator(Action123)
                    {
                    }
                    /*action("Emergency Contacts")
                    {
                        Caption = 'Emergency Contacts';
                        RunObject = Page "Employee Emergency Contacts";
                        RunPageLink = "No." = FIELD("No.");
                        Visible = false;
                    }*/
                    action("Alternative Addresses")
                    {
                        Caption = 'Alternative Addresses';
                        RunObject = Page "Employee Aternative Addresses";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    action("Next Of Kin")
                    {
                        Caption = 'Next Of Kin';
                        RunObject = Page "Employee Kin";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    action(Dependants)
                    {
                        Caption = 'Dependants';
                        RunObject = Page "Employee Dependants";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    action(Relatives)
                    {
                        Caption = 'Relatives';
                        RunObject = Page "Employee Relatives";
                        RunPageLink = "Employee No." = FIELD("No.");
                    }
                    separator(Action118)
                    {
                    }
                    /*action("Misc. Article Information")
                    {
                        Caption = 'Misc. Article Information';
                        RunObject = Page "Misc. Article Info.";
                        RunPageLink = "No." = FIELD("No.");
                        Visible = false;
                    }
                    action("Medical Info.")
                    {
                        Caption = 'Medical Info.';
                        RunObject = Page "Employee Medical Information";
                        RunPageLink = "No." = FIELD("No.");
                        Visible = false;
                    }*/
                    separator(Action115)
                    {
                    }
                    action(Unions)
                    {
                        Caption = 'Unions';
                        RunObject = Page Unions;
                        RunPageLink = Code = FIELD("No.");
                        Visible = false;
                    }
                    separator(Action113)
                    {
                    }
                    action("Linked Documents")
                    {
                        Caption = 'Linked Documents';
                        RunObject = Page "Employee Linked Docs";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    action("Linked Assets")
                    {
                        Caption = 'Linked Assets';
                        Image = Allocations;
                        RunObject = Page "Fixed Asset List";
                        RunPageLink = "Responsible Employee" = FIELD("No.");
                    }
                    separator(Action89)
                    {
                    }
                    action("A&bsences")
                    {
                        Caption = 'A&bsences';
                        RunObject = Page "Capacity Absence";
                        //RunPageLink = "Capacity Type" = FIELD ("No.");
                    }
                    separator(Action83)
                    {
                    }
                    action("Succesion Planning & Requirements")
                    {
                        Caption = 'Succesion Planning & Requirements';
                        RunObject = Page "Succesion Planning";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    separator(Action63)
                    {
                    }
                    action("Absences by Ca&tegories")
                    {
                        Caption = 'Absences by Ca&tegories';
                        RunObject = Page "Empl. Absences by Categories";
                    }
                    action("Misc. Articles &Overview")
                    {
                        Caption = 'Misc. Articles &Overview';
                        RunObject = Page "Misc. Articles Overview";
                        Visible = false;
                    }
                    separator(Action57)
                    {
                    }
                    separator(Action37)
                    {
                    }
                    action("Separation Details")
                    {
                        Caption = 'Separation Details';
                        RunObject = Page "Separtion Lines";
                        RunPageLink = "Employee No" = FIELD("No.");
                    }
                    separator(Action31)
                    {
                    }
                    action("Membership Subscription")
                    {
                        Caption = 'Membership Subscription';
                        RunObject = Page "Employee Profess Subscriptions";
                        RunPageLink = Employee = FIELD("No.");
                    }
                    action("<Action1000000159>")
                    {
                        Caption = 'Employee List (All Employees)';
                        RunObject = Page "Employee List";
                        RunPageLink = "No." = FIELD("No.");
                        Visible = false;
                    }
                    action("Employee Detail Summary View (Card)")
                    {
                        Caption = 'Employee Detail Summary View (Card)';
                        Enabled = false;
                        Visible = false;
                    }
                    separator(Action26)
                    {
                    }
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.Validate(Position);
    end;

    trigger OnOpenPage()
    begin
        MovementFieldsEditable := true;
        MovementFieldsTooltip := '';

        CanViewHR := false;
        CanEditCard := false;
        CanEditPaymentInfo := false;
        CanEditLeaveInfo := false;
        CanViewHrLetters := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then begin
            CanEditCard := UserSetup."Can Edit Emp Card";
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
            CanEditLeaveInfo := UserSetup."Can Edit Leave Entitlement";
            CanViewHrLetters := UserSetup."Can View HR Letters";
            CanViewHR := UserSetup."Can View HR";
        end;
        MovementFieldsEditable := CanEditCard;
        if not CanViewHR then
            Error('You do not have permission to view HR records. Kindly contact the System Administrator!');

        //If has movement entries with one being current, then update these fields there so make them uneditable here
        if (Rec."No." <> '') and (CanEditCard) then begin
            MovementRec.Reset();
            MovementRec.SetRange("Emp No.", Rec."No.");
            MovementRec.SetRange(Status, MovementRec.Status::Current);
            if MovementRec.FindFirst() then begin
                MovementFieldsEditable := false;
                MovementFieldsTooltip := 'Update the field on the current/new movement list';
            end;
        end;
        Rec.Validate(Position);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec.Validate("Date of Appointment");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        FreshRec: Record Employee;
    begin
        //Rec.Modify(); //Save adjustments like position-title - but fetch as fresh to prevent errors
        FreshRec.Reset();
        FreshRec.SetRange("No.", Rec."No.");
        if FreshRec.FindFirst() then begin
            FreshRec."Job Title" := Rec."Job Title";
            FreshRec."Overtime AC" := Rec."Overtime AC";
            FreshRec."Overtime Amount Currency" := Rec."Overtime Amount Currency";
            FreshRec.Modify();
        end;
        /*if ("Daily Rate" = 0) and ("Apply Daily Rates") then
            Error('You have checked the Apply Daily Rates option but failed to provide the daily rate (amount)! Kindly provide the rate or uncheck the Apply Daily Rates!');
        if Rec."Payment/Bank Country" = '' then
            Message('Consider providing the Payment/Bank Country before you leave this page!');*/
    end;

    var
        //Dmsmngr: Codeunit "DMS Management";
        DocType: Option ,"Purchase Requisition",Imprest,"Imprest Surrender","Employee Data","RFX Documents";
        MovementRec: Record "Internal Employement History";
        MovementFieldsEditable: Boolean;
        MovementFieldsTooltip: Text;
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanViewHrLetters: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
        CanViewHR: Boolean;
}