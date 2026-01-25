page 51525344 "HR Employee-Intern"
{
    ApplicationArea = All;
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
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Caption = 'Other Names';
                }
                field(Initials; Rec.Initials)
                {
                }
                field("ID Number"; Rec."ID Number")
                {
                }
                field("Passport Number"; Rec."Passport Number")
                {
                }
                field("Driving Licence"; Rec."Driving Licence")
                {
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("Postal Address"; Rec."Postal Address")
                {
                }
                field("Postal Address2"; Rec."Postal Address2")
                {
                    Caption = 'Town';
                }
                field("Postal Address3"; Rec."Postal Address3")
                {
                }
                field("Post Code2"; Rec."Post Code2")
                {
                    Caption = 'Post Code';
                    LookupPageID = "Post Codes";
                }
                field("Residential Address"; Rec."Residential Address")
                {
                }
                field("Residential Address2"; Rec."Residential Address2")
                {
                }
                field("Residential Address3"; Rec."Residential Address3")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field(Picture; Rec.Image)
                {
                    Visible = true;
                }
            }
            group("Personal Details")
            {
                Caption = 'Personal Details';
                field(Gender; Rec.Gender)
                {
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                }
                field("Marital Status"; Rec."Marital Status")
                {
                }
                field(Religion; Rec.Religion)
                {
                }
                field("Ethnic Group"; Rec."Ethnic Group")
                {
                }
                field("First Language Read"; Rec."First Language Read")
                {
                    Caption = 'English Read';
                }
                field("First Language Write"; Rec."First Language Write")
                {
                    Caption = 'English Written';
                }
                field("First Language Speak"; Rec."First Language Speak")
                {
                    Caption = 'English Spoken';
                }
                field("Second Language Read"; Rec."Second Language Read")
                {
                    Caption = 'Kiswahili Read';
                }
                field("Second Language Write"; Rec."Second Language Write")
                {
                    Caption = 'Kiswahili Written';
                }
                field("Second Language Speak"; Rec."Second Language Speak")
                {
                    Caption = 'Kiswahili Spoken';
                }
                field("Additional Language"; Rec."Additional Language")
                {
                    Caption = 'Other';
                }
                field("Other Language Read"; Rec."Other Language Read")
                {
                    Caption = 'Other Language Read';
                }
                field("Other Language Write"; Rec."Other Language Write")
                {
                    Caption = 'Other Language Written';
                }
                field("Other Language Speak"; Rec."Other Language Speak")
                {
                    Caption = 'Other Language Spoken';
                }
            }
            group("Job Information")
            {
                Caption = 'Job Information';
                field(Position; Rec.Position)
                {
                    Caption = 'Job Position';
                    Visible = true;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = true;
                    Visible = true;
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
                field("Employee Job Type"; Rec."Employee Job Type")
                {
                    Caption = 'Job Type(for Fleet)';
                    Editable = true;
                }
                field("Notice Period"; Rec."Notice Period")
                {
                    Caption = 'Notice Period After Confirmation';
                    Editable = false;
                }
            }
            group("Payment Information")
            {
                Caption = 'Payment Information';
                field("PIN Number"; Rec."PIN Number")
                {
                }
                field("P.I.N"; Rec."P.I.N")
                {
                    ShowCaption = true;
                    Visible = false;
                }
                field("NSSF No."; Rec."NSSF No.")
                {
                }
                field("NHIF No."; Rec."NHIF No.")
                {
                }
                field("HELB No"; Rec."HELB No")
                {
                }
                field("Co-Operative No"; Rec."Co-Operative No")
                {
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                }
                field("Employee's Bank"; Rec."Employee's Bank")
                {
                }
                field("Bank Branch"; Rec."Bank Branch")
                {
                    Visible = false;
                }
                field("Bank Account Number"; Rec."Bank Account Number")
                {
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    Caption = 'HR Posting Group/Contract Type';
                }
                field("Salary Scale"; Rec."Salary Scale")
                {
                    Caption = 'Grade';
                }
                field(Present; Rec.Present)
                {
                }
                field(Previous; Rec.Previous)
                {
                    Editable = false;
                }
                field(Halt; Rec.Halt)
                {
                    Editable = false;
                }
            }
            group("Important Dates")
            {
                Caption = 'Important Dates';
                field("Date Of Join"; Rec."Date Of Join")
                {
                    Caption = 'Date of Joining Company';
                }
                field("End Of Probation Date"; Rec."End Of Probation Date")
                {
                }
                label(Control35)
                {
                    ShowCaption = false;
                }
                field("Pension Scheme Join"; Rec."Pension Scheme Join")
                {
                }
                field("Medical Scheme Join"; Rec."Medical Scheme Join")
                {
                }
                field("Date OfJoining Payroll"; Rec."Date OfJoining Payroll")
                {
                }
            }
            group("Contact Numbers")
            {
                Caption = 'Contact Numbers';
                field("Home Phone Number"; Rec."Home Phone Number")
                {
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                }
                field("Fax Number"; Rec."Fax Number")
                {
                }
                field("Work Phone Number"; Rec."Work Phone Number")
                {
                }
                field("Ext."; Rec."Ext.")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
            }
            group("Contract Information")
            {
                Caption = 'Contract Information';
                field("Full / Part Time"; Rec."Full / Part Time")
                {
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Contract Number"; Rec."Contract Number")
                {
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                }
                field("Send Alert to"; Rec."Send Alert to")
                {
                }
            }
            group(Separation)
            {
                Caption = 'Separation';
                field("Date Of Leaving"; Rec."Date Of Leaving")
                {
                }
                field("Served Notice Period"; Rec."Served Notice Period")
                {
                }
                field("Termination Category"; Rec."Termination Category")
                {
                }
                field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Exit Interview Date"; Rec."Exit Interview Date")
                {
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
            group("Pay Manager")
            {
                Caption = 'Pay Manager';
                /*action("Employee Accounts Mapping")
                {
                    Image = Accounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Employee Account Mapping";
                    RunPageLink = "Employee No." = FIELD("No.");
                    Visible = false;
                }*/
            }
            group("Employee's")
            {
                Caption = 'Employee''s';
                group("Employee Details")
                {
                    Caption = 'Employee Details';
                    Image = HumanResources;
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
                            Rec.Status := Rec.Status::Inactive;
                            Rec.Modify;
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
                    action("Emergency Contacts")
                    {
                        Caption = 'Emergency Contacts';
                        RunObject = Page "Employee Emergency Contacts";
                        RunPageLink = "No." = FIELD("No.");
                    }
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
                    action("Misc. Article Information")
                    {
                        Caption = 'Misc. Article Information';
                        RunObject = Page "Misc. Article Info.";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    action("Medical Info.")
                    {
                        Caption = 'Medical Info.';
                        RunObject = Page "Employee Medical Information";
                        RunPageLink = "No." = FIELD("No.");
                    }
                    separator(Action115)
                    {
                    }
                    action(Unions)
                    {
                        Caption = 'Unions';
                        RunObject = Page Unions;
                        RunPageLink = Code = FIELD("No.");
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
                    action(Action139)
                    {
                        RunObject = Page "Employee Transfer Lines";
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Is Intern" := true;
    end;
}