pageextension 51525300 "HR Setup Ext" extends "Human Resources Setup"
{
    layout
    {
        addbefore(Numbering)
        {
            field("HR Department Email"; Rec."HR Department Email")
            {
                ApplicationArea = All;
            }
            field("Onboarding Section Email"; Rec."Onboarding Section Email")
            {
                ApplicationArea = All;
            }
        }

        addlast(Numbering)
        {
            field("Shift Nos"; Rec."Shift Nos")
            {

            }
            field("Memo Nos"; Rec."Memo Nos")
            {

            }
            field("Accident / Incident"; Rec."Accident / Incident")
            {

            }
            field("Loan Product Type Nos."; Rec."Loan Product Type Nos.")
            {
            }
            field("Applicants Nos."; Rec."Applicants Nos.")
            {
            }
            field("Recruitment Needs Nos."; Rec."Recruitment Needs Nos.")
            {
            }
            field("Disciplinary Cases Nos."; Rec."Disciplinary Cases Nos.")
            {
            }
            field("No. Of Days in Month"; Rec."No. Of Days in Month")
            {
            }
            /* field("Transport Request Nos"; Rec."Transport Request Nos")
            {
            } */
            field("Cover Selection Nos"; Rec."Cover Selection Nos")
            {
            }
            field("Qualification Days (Leave)"; Rec."Qualification Days (Leave)")
            {
            }
            field("Telephone Request Nos"; Rec."Telephone Request Nos")
            {
            }
            field("Training Request Nos"; Rec."Training Request Nos")
            {
            }
            field("Medical Claim Nos"; Rec."Medical Claim Nos")
            {
            }
            field("Account No (Training)"; Rec."Account No (Training)")
            {
            }
            field("Training Evaluation Nos"; Rec."Training Evaluation Nos")
            {
            }
            field("Off Days Code"; Rec."Off Days Code")
            {
            }
            field("Appraisal Nos"; Rec."Appraisal Nos")
            {
            }
            field("Keys Request Nos"; Rec."Keys Request Nos")
            {
            }
            field("Incidences Nos"; Rec."Incidences Nos")
            {
            }
            field("Sick Of Nos"; Rec."Sick Of Nos")
            {
            }
            field("Conveyance Nos"; Rec."Conveyance Nos")
            {
            }
            field("Membership No."; Rec."Membership No.")
            {
            }
            field("Conf/Sem Evaluation"; Rec."Conf/Sem Evaluation")
            {
            }
            field("User Incident"; Rec."User Incident")
            {
            }
            field("DMS LINK"; Rec."DMS LINK")
            {
            }
            field("Vehicle Filling No"; Rec."Vehicle Filling No")
            {
            }
            field("Savings Withdrawal No"; Rec."Savings Withdrawal No")
            {
            }
            field("All Staff Mail"; Rec."All Staff Mail")
            {
            }
            field("Resource Request Nos"; Rec."Resource Request Nos")
            {
            }
            field("Appraisal Objective Nos"; Rec."Appraisal Objective Nos")
            {
            }
            field("Training Need Nos"; Rec."Training Need Nos")
            {
            }
            field("Training Needs Request Nos"; Rec."Training Needs Request Nos")
            {
            }
            field("Employee Training Need Nos"; Rec."Employee Training Need Nos")
            {
            }
            field("Employee Timesheet No's"; Rec."Employee Timesheet No's")
            {
            }
            field("Job Structure Identifier"; Rec."Job Structure Identifier")
            {
            }
            field("Fleet Accident Nos."; Rec."Fleet Accident Nos.")
            {
            }
            field("Maintenance Req Nos"; Rec."Maintenance Req Nos")
            {
            }
            field("Grievance Nos"; Rec."Grievance Nos")
            {
            }
            field("Medical Claim Account No"; Rec."Medical Claim Account No")
            {
            }
            field("JobApplication Nos"; Rec."JobApplication Nos")
            {
                Visible = false;
            }
            field("Overtime Earning Code"; Rec."Overtime Earning Code")
            {
            }
            field("Contract Nos"; Rec."Contract Nos")
            {
            }
            field("Training Assessment Nos"; Rec."Training Assessment Nos")
            {
            }
            field("Email Nos"; Rec."Email Nos")
            {
            }
            field("Share Top Up Nos"; Rec."Share Top Up Nos")
            {
            }
            field("Signature Nos"; Rec."Signature Nos")
            {
            }
            field("Pension Code"; Rec."Pension Code")
            {
            }
            field("Pension Arrears Code"; Rec."Pension Arrears Code")
            {
            }
            field(NITA; Rec.NITA)
            {
            }
            field("Disciplinary Cases File"; Rec."Disciplinary Cases File")
            {
            }
            field("Disciplinary Nos"; Rec."Disciplinary Nos")
            {
            }
            field("Recruitment  File Path"; Rec."Recruitment  File Path")
            {
            }
            field("Training Evaluation Documents"; Rec."Training Evaluation Documents")
            {
            }
            field("Training Evaluation Cert Path"; Rec."Training Evaluation Cert Path")
            {
            }
            field("Payable Leave Days"; Rec."Payable Leave Days")
            {
            }
            field("Absence No"; Rec."Absence No")
            {
            }
            field("Transport DMS Link"; Rec."Transport DMS Link")
            {
            }
            field("Insurance Attachments"; Rec."Insurance Attachments")
            {
            }
            field("FY Deadline-Training Proposals"; Rec."FY Deadline-Training Proposals")
            {
            }
            field("Leave Recall Nos"; Rec."Leave Recall Nos")
            {
            }
            field("Excess Leave Days No"; Rec."Excess Leave Days No")
            {
            }
            field("Leave Plan Nos"; Rec."Leave Plan Nos")
            {
            }
            field("Leave Adjustment Nos"; Rec."Leave Adjustment Nos")
            {
            }
            field("Employee Transfer Nos"; Rec."Employee Transfer Nos")
            {
            }
            field("Employee Nos(Interns)"; Rec."Employee Nos(Interns)")
            {
            }
            field("Car Loan Documents Path"; Rec."Car Loan Documents Path")
            {
            }
            field("Car Loan Request Nos"; Rec."Car Loan Request Nos")
            {
            }
            field("Salary Advance Nos"; Rec."Salary Advance Nos")
            {
            }
            field("Mortgage Request Nos"; Rec."Mortgage Request Nos")
            {
            }
            field("HR HOD"; Rec."HR HOD")
            {
            }
            field(CEO; Rec.CEO)
            {
            }
            field("Director CS"; Rec."Director CS")
            {
            }
            field("Exit Interview Nos."; Rec."Exit Interview Nos.")
            {
            }
            field("Intern Nos"; Rec."Intern Nos")
            {
            }
            field("Employee On Contract Nos"; Rec."Employee On Contract Nos")
            {
            }
            field("Job Application No"; Rec."Job Application No")
            {
            }
            field("Payroll Processing No."; Rec."Payroll Processing No.")
            {
            }
            field("Repair Nos"; Rec."Repair Nos")
            {
            }
            field("HelpDesk Nos"; Rec."HelpDesk Nos")
            {
            }
            /*field("Asset Requisitions"; Rec."Asset Requisitions")
            { }
            field("Asset Allocation"; Rec."Asset Allocation")
            { }
            field("Asset Transfer No"; Rec."Asset Transfer No")
            {
            }*/
            field("Use Fiscal Year"; Rec."Use Fiscal Year")
            {
            }
            field("Batch Nos"; Rec."Batch Nos")
            {
            }
            field("Retirement Age PWD"; Rec."Retirement Age PWD")
            {
            }
            field("Employee Data Directory Name"; Rec."Employee Data Directory Name")
            {
            }
            field("Change Nos"; Rec."Change Nos")
            {
            }
        }

        addafter(Numbering)
        {
            group("Payroll Setup")
            {
                Caption = 'Payroll Setup';
                field("Final Payroll Adm Day"; Rec."Final Payroll Adm Day")
                { }
                field("Special Transport Allowance Cutoff"; Rec."Special Transport Allowance")
                { }
                field("Payroll Administrator Email"; Rec."Payroll Administrator Email")
                { }
                field("Company NHIF No"; Rec."Company NHIF No")
                {
                }
                field("Company NSSF No"; Rec."Company NSSF No")
                {
                }
                field("Company KRA No"; Rec."Company KRA No")
                {
                }
                field("Salary Increment Period"; Rec."Salary Increment Period")
                {
                }
                field("Technical Competence Overall %"; Rec."Technical Competence Overall %")
                {
                }
                field("Behaviour Competence Overall %"; Rec."Behaviour Competence Overall %")
                {
                }
                field("Retirement Age"; Rec."Retirement Age")
                {
                }
                field("Owner occupier interest"; Rec."Owner occupier interest")
                {
                }
                field("Probation Period(Months)"; Rec."Probation Period(Months)")
                {
                }
                field("Base Calender Code"; Rec."Base Calender Code")
                {
                }
                field("Employee Absentism"; Rec."Employee Absentism")
                {
                }
                field("Conf/Sem/Request"; Rec."Conf/Sem/Request")
                {
                }
                field("Tax Relief Amount"; Rec."Tax Relief Amount")
                {
                }
                field("Max Tax Exemption Amount"; Rec."Max Tax Exemption Amount")
                {
                }
                field("PAYE Flat Rate (%)"; Rec."PAYE Flat Rate (%)")
                {
                }
                field("Insurance Relief Rate (%)"; Rec."Insurance Relief Rate (%)")
                {
                }
                field("General Payslip Message"; Rec."General Payslip Message")
                {
                }
                /*field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                }*/
                field("Tax Table"; Rec."Tax Table")
                {
                }
                field("Corporation Tax"; Rec."Corporation Tax")
                {
                }
                field("Housing Earned Limit"; Rec."Housing Earned Limit")
                {
                }
                field("Pension Limit Percentage"; Rec."Pension Limit Percentage")
                {
                }
                field("Pension Limit Amount"; Rec."Pension Limit Amount")
                {
                }
                field("Round Down"; Rec."Round Down")
                {
                }
                field("Working Hours"; Rec."Working Hours")
                {
                }
                field("Payroll Rounding Precision"; Rec."Payroll Rounding Precision")
                {
                }
                field("Payroll Rounding Type"; Rec."Payroll Rounding Type")
                {
                }
                field("Special Duty Table"; Rec."Special Duty Table")
                {
                }
                field("CFW Round Deduction code"; Rec."CFW Round Deduction code")
                {
                }
                field("BFW Round Earning code"; Rec."BFW Round Earning code")
                {
                }
                field("Company overtime hours"; Rec."Company overtime hours")
                {
                }
                field("Incoming Mail Server"; Rec."Incoming Mail Server")
                {
                }
                field("Outgoing Mail Server"; Rec."Outgoing Mail Server")
                {
                }
                field("Email Text"; Rec."Email Text")
                {
                }
                field("Sender User ID"; Rec."Sender User ID")
                {
                }
                field("Sender Address"; Rec."Sender Address")
                {
                }
                field("Email Subject"; Rec."Email Subject")
                {
                }
                field("Template Location"; Rec."Template Location")
                {
                }
                field("Monthly PayDate"; Rec."Monthly PayDate")
                {
                }
                field("Payroll Template"; Rec."Payroll Template")
                {
                }
                field("Payroll Journal Batch"; Rec."Payroll Journal Batch")
                {
                }
            }
            group("Leave Setup")
            {
                Caption = 'Leave Setup';
                field("Leave Application Nos."; Rec."Leave Application Nos.")
                {
                }
                field("Leave Posting Period[FROM]"; Rec."Leave Posting Period[FROM]")
                {
                }
                field("Leave Posting Period[TO]"; Rec."Leave Posting Period[TO]")
                {
                }
                field("Default Leave Posting Template"; Rec."Default Leave Posting Template")
                {
                }
                field("Positive Leave Posting Batch"; Rec."Positive Leave Posting Batch")
                {
                }
                field("Leave Allowance Days"; Rec."Leave Allowance Days")
                {
                }
                field("Leave Allowance Code"; Rec."Leave Allowance Code")
                {
                }
                field("Leave Allowance Limit"; Rec."Leave Allowance Limit")
                {
                }
                field("Annual Leave Code"; Rec."Annual Leave Code")
                {
                }
                field(ExcessLeave; Rec.ExcessLeave)
                {
                }
            }
            group("Airtime Management")
            {
                field("Airtime Request Nos"; Rec."Airtime Request Nos")
                {
                    ApplicationArea = All;
                }
                field("Airtime Mgmt E-Mail"; Rec."Airtime Mgmt E-Mail")
                {
                    ApplicationArea = All;
                }
            }
            group("Hotel Management")
            {
                field("Hotel Request Nos"; Rec."Hotel Request Nos")
                {
                    ApplicationArea = All;
                }
                field("Hotel Mgmt E-Mail"; Rec."Hotel Mgmt E-Mail")
                {
                    ApplicationArea = All;
                }
            }
            group("Rrefreshment Voucher")
            {
                field("Refreshment Request Nos"; Rec."Refreshment Request Nos")
                {
                    ApplicationArea = All;
                }
                field("Refreshment Mgmt E-Mail"; Rec."Refreshment Mgmt E-Mail")
                {
                    ApplicationArea = All;
                }
            }
            group("Room Management")
            {
                field("Room Nos"; Rec."Room Nos")
                {
                    ApplicationArea = All;
                }
                field("Room Booking Nos"; Rec."Room Booking Nos")
                {
                    ApplicationArea = All;
                }
                field("Room Mgmt E-Mail"; Rec."Room Mgmt E-Mail")
                {
                    ApplicationArea = All;
                }
            }
            group("Visa Application")
            {
                field("Requisition Fees Nos"; Rec."Requisition Fees Nos")
                {
                    ApplicationArea = All;
                }
            }

            group("ESS My Profile Permissions")
            {
                field("Edit Bank Details"; Rec."Edit Bank Details")
                { }
                field("Edit Medical Details"; Rec."Edit Medical Details")
                { }
                field("Edit Pension Details"; Rec."Edit Pension Details")
                { }
                field("Edit TIN Details"; Rec."Edit TIN Details")
                { }
            }

            group("Reminder Setups")
            {
                field("Suspend Probation Reminders"; Rec."Suspend Probation Reminders")
                { }
                field("Suspend 10-year Reminders"; Rec."Suspend 10-year Reminders")
                { }
                field("10Y Notification Start Date"; Rec."10Y Notification Start Date")
                { }
                field("Suspend Retirement Reminders"; Rec."Suspend Retirement Reminders")
                { }
                field("Suspend Contract Reminders"; Rec."Suspend Contract Reminders")
                { }
            }
        }
    }

    actions
    {
        addlast(navigation)
        {
            action("Initialize Airtime Management")
            {
                Image = Setup;
                ApplicationArea = All;
                ToolTip = 'Creates no. series and job queue.';
                Caption = 'Initialize Airtime Management';
                trigger OnAction()
                begin
                    CustomHelperFunctions.InitializeAirtimeManagement();
                    CurrPage.Update(false);
                end;
            }
            action("Initialize Hotel Management")
            {
                Image = Setup;
                ApplicationArea = All;
                ToolTip = 'Creates no. series';
                Caption = 'Initialize Hotel Management';
                trigger OnAction()
                begin
                    CustomHelperFunctions.InitializeHotelManagement();
                    CurrPage.Update(false);
                end;
            }
        }

        addafter(Category_Category5)
        {
            group("Initialize Features")
            {
                actionref("Initialize Airtime Management_Promoted"; "Initialize Airtime Management")
                {
                }
                actionref("Initialize Hotel Management_Promoted"; "Initialize Hotel Management")
                {
                }
            }
        }
    }

    var
        CustomHelperFunctions: Codeunit "Custom Helper Functions HR";
}
