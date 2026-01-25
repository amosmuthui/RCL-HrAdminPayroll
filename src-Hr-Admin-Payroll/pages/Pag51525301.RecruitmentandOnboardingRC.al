page 51525301 "Recruitment and Onboarding R.C"
{
    ApplicationArea = All;
    Caption = 'Recruitment and Onboarding';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control8; "Common Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control7; "Recruitment & Onboarding Cues")
            {
            }
            part(Control6; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
                Visible = true;
            }
            part(Control5; "My Job Queue")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control4; "My Items")
            {
                AccessByPermission = TableData "My Item" = R;
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            systempart(Control2; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control3; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = R;
                ApplicationArea = Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("Departmental Contracts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Departmental Contracts';
                RunObject = Page "Departmental Contracts";
            }
        }
        area(processing)
        {
            group(Setups)
            {
                Caption = 'Setups';
                action("HR Setups")
                {
                    Image = Setup;
                    RunObject = Page "Human Resources Setup";
                }
            }
            group(Action85)
            {
                Caption = 'Company Information';
                action("Company Information")
                {
                    RunObject = Page "Company Information";
                }
            }
            group("Payroll Reports")
            {
                Caption = 'Reports';
                Visible = true;
                group("Management Reports")
                {
                    Caption = 'Management Reports';
                    Image = Balance;
                    action(Joiners)
                    {
                        RunObject = Report Joiners;
                    }
                    action(Leavers)
                    {
                        RunObject = Report Leavers;
                    }
                    action(Transfers)
                    {
                        RunObject = Report Transfers;
                    }
                    action("Month Changes")
                    {
                        RunObject = Report "Month Changes";
                    }
                    /*action("Earnings Report")
                    {
                        RunObject = Report Earnings;
                    }
                    action("Salary Statistics")
                    {
                        Caption = 'Salary Statistics - Detailed';
                        RunObject = Report "Payroll-Statistics";
                    }
                    action("Salary Statistics - Summarized")
                    {
                        RunObject = Report "Payroll-Statistics Summarized";
                    }
                    action("Payroll Bank Advice")
                    {
                        Caption = 'Payroll Bank Advice';
                        //RunObject = Report "Payroll Bank Advice";
                        RunObject = Report "Payroll Bank Advice - Simp";
                    }
                    action("Payroll Variance Report")
                    {
                        Caption = 'Payroll Variance Report';
                        RunObject = Report "Payroll Variance Report";
                    }
                    action("Deductions Report")
                    {
                        Caption = 'Deductions Report';
                        RunObject = Report Deductionss;
                    }
                    action("Employees With less than 1/3")
                    {
                        Caption = 'Employees With less than 1/3';
                        RunObject = Report "Employees With less than 1/3";
                    }
                    /*action("Payroll-Statistics")
                    {
                        Caption = 'Salary Statistics';
                        RunObject = Report "Payroll-Statistics";
                    }*/
                }
                /*group("Statutory Reports")
                {
                    Caption = 'Statutory Reports';
                    Image = Balance;
                    Visible = false;
                    action("Helb Report")
                    {
                        Caption = 'Helb Report';
                        RunObject = Report "Helb Report";
                    }
                    action("NHIF Report")
                    {
                        Caption = 'NHIF Report';
                        RunObject = Report NHIF;
                    }
                    action("NSSF Reporting")
                    {
                        Caption = 'NSSF Reporting';
                        RunObject = Report "NSSF Reporting";
                    }
                    action("NITA Reporting")
                    {
                        Caption = 'NITA Reporting';
                        RunObject = Report "New NITA Reporting.";
                    }
                }*/
                group("Annual Reports")
                {
                    Caption = 'Annual Reports';
                    Image = Balance;
                    Visible = false;
                    action("P9A Report")
                    {
                        Image = "Report";
                        RunObject = Report "P9A Report";
                    }
                    action("Payslip Report")
                    {
                        Image = "Report";
                        RunObject = Report "New Payslip";
                    }
                    action("P9A (HOSP) Report")
                    {
                        Image = "Report";
                        RunObject = Report "P9A (HOSP) Report";
                    }
                    action(P10A)
                    {
                        Image = "Report";
                        RunObject = Report P10A;
                    }
                    action(P10)
                    {
                        Image = "Report";
                        RunObject = Report P10;
                    }
                    action("P10 Return Itax")
                    {
                        Image = "Report";
                        RunObject = Report "P10 Return Itax";
                    }
                    action("P10 Return Itax Version 2")
                    {
                        Image = "Report";
                        RunObject = Report "P10 Return Itax Ver2";
                    }
                    action(P10B)
                    {
                        Image = "Report";
                        RunObject = Report P10B;
                    }
                }
                group("Summary Reports")
                {
                    Caption = 'Summary Report';
                    Image = Balance;
                    Visible = false;
                    action("Salaries Summary")
                    {
                        Caption = 'Salaries Summary';
                        RunObject = Report "Salaries Summary";
                    }
                }
            }
            group("Self Service")
            {
                Caption = 'Self Service';
            }
        }
        area(sections)
        {
            group(Action81)
            {
                Caption = 'Company Information';
                Image = LotInfo;
                action(Calendar)
                {
                    RunObject = Page "HR Calendar List";
                }
                action("Company Activities")
                {
                    RunObject = Page "Employee Presents";
                }
                action("Rules & Regulations")
                {
                    RunObject = Page "Rules & Regulations";
                }
                action("Responsibility Centers")
                {
                    ApplicationArea = Suite;
                    Caption = 'Departments';
                    RunObject = Page "Responsibility Center List";
                }
                action(Sections1)
                {
                    Caption = 'Sections';
                    ApplicationArea = Suite;
                    RunObject = Page "Sub Responsibility Center";
                }
                action("Sub Sections")
                {
                    ApplicationArea = Suite;
                    RunObject = Page "Sub Sections";
                }
                action(Stations)
                {
                    ApplicationArea = Suite;
                    RunObject = Page Stations;
                }
            }
            group(Establishment)
            {
                Caption = 'Establishment';
                Image = Administration;
                action(Positions)
                {
                    RunObject = Page "Company Job List";
                }
                /*action("Program Positions")
                {
                    RunObject = Page "Department Job Positions";
                }*/
                action("Job Specifications")
                {
                    RunObject = Page "Job Specification List";
                }
                action("Job Responsibilities")
                {
                    RunObject = Page "Job Responsibilties List";
                }
            }
            group(Recruitment)
            {
                Caption = 'Recruitment';
                Image = Worksheets;
                action("Screening Questions")
                {
                    RunObject = Page "Recruitment Screening Question";
                }
                action("Recruitment Needs")
                {
                    RunObject = Page "Recruitment Needs";
                }
                action("Pending Recruitment Needs")
                {
                    RunObject = Page "Pending Recruitment Needs";
                }
                action("Approved Recruitment Needs")
                {
                    RunObject = Page "Approved Recruitment Needs";
                }
                /*action("Approved Recruitment Needs")
                {
                    RunObject = Page Advertisements;
                    Visible = false;
                }*/
                action("Open Job Adverts")
                {
                    RunObject = Page "Open Job Adverts";
                }
                action("Closed Job Adverts")
                {
                    RunObject = Page "Closed Job Adverts";
                }
                action("Applicant Profiles")
                {
                    RunObject = Page "Applicants List";
                }
                action("Talent Pools")
                {
                    RunObject = Page "Talent Pools";
                }
                action("Job Application Lists")
                {
                    //Caption = '';
                    RunObject = Page "Job Applications List";
                }
                /*action("Shortlisting(Manual)")
                {
                    RunObject = Page "Manual Shortlisting List";
                    Visible = false;
                }*/
                action("Shortlisted Applicants")
                {
                    RunObject = Page "Shortlisted Applicants List";
                }
                action("Failed Shortlisting")
                {
                    RunObject = Page "Failed Shortlisting List";
                }
                action("Passed First Interview")
                {
                    RunObject = Page "Passed First Interview List";
                }
                action("Failed First Interview")
                {
                    RunObject = Page "Failed First Interview List";
                }
                action("Passed Due Diligence")
                {
                    RunObject = Page "Passed Due Diligence List";
                }
                action("Failed Due Diligence")
                {
                    RunObject = Page "Failed Due Diligence List";
                }
                action("Passed Second Interview")
                {
                    RunObject = Page "Passed Second Interview List";
                }
                action("Failed Second Interview")
                {
                    RunObject = Page "Failed Second Interview List";
                }
                /*action("Shortlisted Job Applications")
                {
                    RunObject = Page "Short Listed Job Applications";
                }
                action("Post Interview Job Applications")
                {
                    RunObject = Page "Post Interview Job Application";
                }*/
                action("Completed Job Adverts")
                {
                    RunObject = Page "Closed Job Applications";
                }
                action("Applicant Attachments")
                {
                    RunObject = Page "Applicant Attachments";
                    Visible = false;
                }
            }
            group("Employee Manager")
            {
                Caption = 'Employee Manager';
                Image = HumanResources;
                group("Employee Changes")
                {
                    action("Open Requests")
                    {
                        RunObject = Page "Employee Change Requests";
                        RunPageView = where("Change Approval Status" = const(Open));
                    }
                    action("Pending Approval")
                    {
                        RunObject = Page "Employee Change Requests";
                        RunPageView = where("Change Approval Status" = const("Pending Approval"));
                    }
                    action("Rejected Requests")
                    {
                        RunObject = Page "Employee Change Requests";
                        RunPageView = where("Change Approval Status" = const(Rejected));
                    }
                    action("Approved Changes")
                    {
                        RunObject = Page "Employee Change Requests";
                        RunPageView = where("Change Approval Status" = const(Approved));
                    }
                }
                action("All Employees")
                {
                    RunObject = Page "HR Employee List";
                }
                action(" Employee list All data")
                {
                    RunObject = Page "HR Employee list All data";
                }
                action("Active Employees")
                {
                    RunObject = Page "Employee List";
                }
                action("Inactive Employees")
                {
                    RunObject = Page "Employee List";
                    RunPageView = where(Status = const(Inactive));
                }
                action("Employees On Locum")
                {
                    RunObject = Page "HR Employee List-On Contract";
                }
                action(Interns)
                {
                    RunObject = Page "HR Employee List-Interns";
                }
                action("Employee Transfers")
                {
                    RunObject = Page "Employee Transfer list";
                }
                /*action("Employee Timesheets")
                {
                    RunObject = Page "Employee Timesheet list";
                    Visible = false;
                }*/
                action("Exit Interviews")
                {
                    RunObject = Page "Job Exit Interview List";
                }
                action("Exit Reasons")
                {
                    RunObject = Page "Job Exit Reason List";
                }
            }
            group("Employee Disciplinary")
            {
                Caption = 'Employee Disciplinary';
                Image = ProductDesign;
                Visible = false;
                action("New Cases")
                {
                    RunObject = Page "Disciplinary Cases";
                }
                action("Ongoing Cases")
                {
                    RunObject = Page "Ongoing Cases";
                }
                action("Committee Disciplinary Cases")
                {
                    RunObject = Page "Comm Disciplinary Cases";
                }
                action("CEO Disciplinary Cases")
                {
                    RunObject = Page "Ceo Disciplinary Cases";
                }
                action("Board Disciplinary Cases")
                {
                    RunObject = Page "Board Disciplinary Cases";
                }
                action("Appealed Cases")
                {
                    RunObject = Page "Appealed Cases";
                }
                action("Closed Cases")
                {
                    RunObject = Page "Closed Cases";
                }
                action("Court Cases")
                {
                    RunObject = Page "Court Cases";
                }
                action("Offense Type Setup")
                {
                    RunObject = Page "Disciplinary Offenses";
                }
                action("Disciplinary Actions")
                {
                    RunObject = Page "Disciplinary Actions";
                }
                action("Discipline Levels")
                {
                    RunObject = Page "Levels of Discipline List";
                }
            }
        }
        area(reporting)
        {
        }
    }
}