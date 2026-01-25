page 51525340 "HR Employee list All data"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Control164)
            {
                ShowCaption = false;
                field("Employee Act. Qty"; Rec."Employee Act. Qty")
                {
                    Caption = 'Active';
                    Editable = false;
                    Visible = false;
                }
                field("Employee Arc. Qty"; Rec."Employee Arc. Qty")
                {
                    Caption = 'Archived';
                    Editable = false;
                    Visible = false;
                }
                field("""Employee Act. Qty""+""Employee Arc. Qty"""; Rec."Employee Act. Qty" + Rec."Employee Arc. Qty")
                {
                    Caption = 'All';
                    Editable = false;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    AssistEdit = true;
                    Editable = true;

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
                }
                field("First Name"; Rec."First Name")
                {
                    ShowMandatory = true;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Caption = 'Other Names';
                    ShowMandatory = true;
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
                /*field(Picture; Rec.Picture)
                {
                    Visible = false;
                }*/
                field("<Employee Signature>"; Rec."Employee Signature")
                {
                    Caption = 'Signature';
                }
                field(Disabled; Rec.Disabled)
                {
                    Caption = 'PWD(Person With Disability)';
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
                field(Gender; Rec.Gender)
                {
                }
                field("Marital Status"; Rec."Marital Status")
                {
                }
                field(Religion; Rec.Religion)
                {
                }
                field(Citizenship; Rec.Citizenship)
                {
                }
                field("Ethnic Group"; Rec."Ethnic Group")
                {
                }
                field(County; Rec.County)
                {
                }
                field("Sub County"; Rec."Sub County")
                {
                }
                field(Constituency; Rec.Constituency)
                {
                    Visible = false;
                }
                field(Category; Rec.Category)
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Sub Responsibility Center"; Rec."Sub Responsibility Center")
                {
                    Caption = 'Department';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = true;
                    Visible = true;
                }
                field(Position; Rec.Position)
                {
                    Caption = 'Job Title Code';
                    Visible = true;
                }
                field("Job Title"; Rec."Job Title")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = true;
                    Visible = true;
                }
                field(Level; Rec.Level)
                {
                    Editable = false;
                    Visible = false;
                }
                /*field("Employee Job Type"; Rec."Employee Job Type")
                {
                    Caption = 'Job Type(for Fleet)';
                    Editable = true;
                    Enabled = false;
                    Visible = false;
                }*/
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
                }
                field("PIN Number"; Rec."PIN Number")
                {
                    ShowMandatory = true;
                }
                field("NSSF No."; Rec."NSSF No.")
                {
                    ShowMandatory = true;
                }
                field("NHIF No."; Rec."NHIF No.")
                {
                    ShowMandatory = true;
                }
                field("HELB No"; Rec."HELB No")
                {
                    ShowMandatory = true;
                }
                field("Co-Operative No"; Rec."Co-Operative No")
                {
                    ShowMandatory = true;
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
                }
                field("Bank Brach Name"; Rec."Bank Brach Name")
                {
                    Editable = false;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ShowMandatory = true;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Basic Pay"; Rec."Basic Pay")
                {
                    Visible = true;
                }
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
                    Caption = 'Grade';
                    Visible = false;
                }
                field(Present; Rec.Present)
                {
                    Caption = 'Present Pointer';
                    Visible = false;
                }
                field(Previous; Rec.Previous)
                {
                    Caption = 'Previous Pointer';
                    Editable = false;
                    Visible = false;
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
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                }
                field("Birth Date"; Rec."Birth Date")
                {
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
                }
                field("Duration In Position"; Rec."Duration In Position")
                {
                }
                field("End Of Probation Date"; Rec."End Of Probation Date")
                {
                }
                field("Pension Scheme Join"; Rec."Pension Scheme Join")
                {
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
                field("Postal Address"; Rec."Postal Address")
                {
                }
                field("Post Code2"; Rec."Post Code2")
                {
                    Caption = 'Post Code';
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
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Caption = 'Personal Email';
                }
                field("Full / Part Time"; Rec."Full / Part Time")
                {
                    Visible = false;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Contract Number"; Rec."Contract Number")
                {
                    Visible = false;
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                }
                field("Send Alert to"; Rec."Send Alert to")
                {
                    Visible = false;
                }
                field("Disciplinary Actions"; Rec."Disciplinary Actions")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Date Of Leaving"; Rec."Date Of Leaving")
                {
                }
                field("Termination Category"; Rec."Termination Category")
                {
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
            action("Attach Document")
            {
                Caption = 'Attach Document';
                Image = Attach;
                Visible = false;

                trigger OnAction()
                begin
                    DocType := DocType::"Employee Data";
                    //Dmsmngr.UploadDocument(DocType, "No.", FullName, RecordId);
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
                    action("Staff Timesheet")
                    {
                        Caption = 'Staff Timesheet';
                        RunObject = Page "Staff Timesheet";
                        RunPageLink = "Employee No." = FIELD("No."),
                                      "Approval Status" = FILTER(Employee);
                    }
                    action("Supervisor Timesheet")
                    {
                        Caption = 'Supervisor Timesheet';
                        RunObject = Page "Supervisor Timesheet";
                        RunPageLink = "Supervisor No." = FIELD("No.");
                    }
                    action("Approved Timesheets")
                    {
                        Caption = 'Approved Timesheets';
                        RunObject = Page "Approved Timesheet";
                        RunPageLink = "Employee No." = FIELD("No.");
                    }
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
                    }
                    separator(Action123)
                    {
                    }
                    action("Emergency Contacts")
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
                    action(" Employee Transfer History")
                    {
                        Caption = ' Employee Transfer History';
                        RunObject = Page "Employee Transfer History";
                        RunPageLink = "Employee No." = FIELD("No.");
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

    trigger OnAfterGetCurrRecord()
    begin
        Rec.Validate("Date of Appointment");
    end;

    var
        //Dmsmngr: Codeunit "DMS Management";
        DocType: Option ,"Purchase Requisition",Imprest,"Imprest Surrender","Employee Data","RFX Documents";
}