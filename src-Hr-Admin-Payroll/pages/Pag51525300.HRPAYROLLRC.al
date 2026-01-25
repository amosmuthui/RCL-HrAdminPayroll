page 51525300 "HR& PAYROLL R.C"
{
    ApplicationArea = All;
    Caption = 'HR ROLE CENTER';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control8; "Common Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control7; "HR Cues")
            {
            }
            part(Control6; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control4; "New Employees")
            {
                ApplicationArea = Basic, Suite;
            }
            systempart(Control2; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control3; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = R;
                ApplicationArea = Suite;
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
                Visible = false;
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
            group("Leave Management")
            {
                Caption = 'Leave Management';
                action("Leave Journal")
                {
                    Image = Journal;
                    RunObject = Page "HR Leave Journal Lines";
                }
                group("Leave Reports")
                {
                    Image = LotInfo;
                    action("Leave Balances")
                    {
                        Image = Balance;
                        RunObject = Report "HR Leave Balances";
                    }
                    action("Hr Leave Balances")
                    {
                        Image = "Report";
                        RunObject = Report "HR Leave Balances";
                    }
                    action("Hr Leave Balances All")
                    {
                        Image = "Report";
                        RunObject = Report "HR Leave Balances All";
                    }
                    action("Staff leave awaiting approval")
                    {
                        Image = "Report";
                        RunObject = Report "Staff Leave Awaiting Approval";
                    }
                    action("Individual leave analysis")
                    {
                        Image = "Report";
                        RunObject = Report "Individual Leave Analysis";
                    }
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
                Caption = 'Payroll Reports';
                group("Management Reports")
                {
                    Caption = 'Management Reports';
                    Image = Balance;
                    action("Earnings Report")
                    {
                        RunObject = Report Earnings;
                    }
                    action("Deductions Report")
                    {
                        Caption = 'Deductions Report';
                        RunObject = Report Deductionss;
                    }
                    action("Employer Deductions")
                    {
                        Caption = 'Employer Contributions';
                        RunObject = Report "Employer Contributions";
                    }
                    action("Salary Statistics")
                    {
                        Caption = 'Salary Statistics - Detailed';
                        RunObject = Report "Detailed Payroll Statistics";//"Payroll-Statistics";
                    }
                    action("Salary Statistics - Summarized")
                    {
                        RunObject = Report "Payroll-Statistics Summarized";
                    }
                    action("Payroll Bank Advice")
                    {
                        Caption = 'Bank Pay Report';
                        //RunObject = Report "Payroll Bank Advice";
                        RunObject = Report "Payroll Bank Advice - Simp";
                    }
                    action("Payroll Variance Report")
                    {
                        Caption = 'Payroll Variance Report';
                        RunObject = Report "Payroll Variance Report";
                    }
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
                    action("Country Payroll Summary Report")
                    {
                        RunObject = Report "Payroll Summary Report";
                    }
                    action("Gender Report")
                    {
                        RunObject = Report "Gender Report";
                    }
                    action("Employee Gross")
                    {
                        Caption = 'Cost Center Report';
                        RunObject = Report "Employee Gross";
                    }
                    action("Departmental Status Report")
                    {
                        Caption = 'Departmental Status Report';
                        RunObject = Report "Departmental Status Report";
                    }
                    action("Maternity Leave Report")
                    {
                        RunObject = Report "Maternity Leave Report";
                    }
                    action("Ten Year Service")
                    {
                        RunObject = Report "Ten Year Service";
                    }
                    /*action("Employees With less than 1/3")
                    {
                        Caption = 'Employees With less than 1/3';
                        RunObject = Report "Employees With less than 1/3";
                    }
                    action("Payroll-Statistics")
                    {
                        Caption = 'Salary Statistics';
                        RunObject = Report "Payroll-Statistics";
                    }*/
                }
                group("Statutory Reports")
                {
                    Caption = 'Statutory Reports';
                    Image = Balance;
                    action("CBHI Annexture")
                    {
                        RunObject = Report "CBHI Annexture";
                    }
                    action("Medical Annexture")
                    {
                        RunObject = Report "Medical Annexture";
                    }
                    action("Maternity Annexture")
                    {
                        RunObject = Report "Maternity Annexture";
                    }
                    action("Pension Monthly Annexture")
                    {
                        RunObject = Report "Pension Monthly Annexture";
                    }
                    action("MMI Report")
                    {
                        RunObject = Report "MMI Report";
                    }
                    action("PAYE Returns")
                    {
                        RunObject = Report "PAYE Returns";
                    }
                    action("New PAYE Annexture")
                    {
                        RunObject = Report "New PAYE Annexture";
                    }
                }
                group("Annual Reports")
                {
                    Caption = 'Annual Reports';
                    Image = Balance;
                    action("P9A Report")
                    {
                        Image = "Report";
                        RunObject = Report "P9A Report";
                        Visible = false;
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
                action("Recruitment Needs")
                {
                    RunObject = Page "Recruitment Needs";
                }
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
                action("Job Application Lists")
                {
                    //Caption = '';
                    RunObject = Page "Job Applications List";
                }
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
                /*action("Closed Job Adverts")
                {
                    RunObject = Page "Closed Job Applications";
                }*/
                action("Applicant Attachments")
                {
                    RunObject = Page "Applicant Attachments";
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
                    RunPageView = where(Status = const(Active));
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
                Visible = true;
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
            group(Payroll)
            {
                Caption = 'Payroll';
                Image = FiledPosted;
                action("Employee List")
                {
                    RunObject = Page "Employee List";
                }
                action("Payrol Processing list")
                {
                    RunObject = Page "Payrol Processing list";
                }
                action("Pay Periods")
                {
                    RunObject = Page "Pay Periods";
                }
                action("Earnings List")
                {
                    RunObject = Page Earnings;
                }
                action("Deductions List")
                {
                    RunObject = Page Deductions;
                }
                action("Bracket Tables")
                {
                    RunObject = Page "Bracket Tables";
                }
                action("Countries")
                {
                    RunObject = Page "Countries/Regions";
                }
                action("Currencies")
                {
                    RunObject = Page "Currencies";
                }
                action("Social Grades")
                {
                    RunObject = Page "Social Grades";
                }
            }
            group("Time and Attendance")
            {
                Caption = 'Time and Attendance';
                action("Time & Attendance")
                {
                    RunObject = Page "Attendance Ledger List";
                }

            }

            group("Leave Manager")
            {
                Caption = 'Leave Manager';
                Image = Ledger;
                action("Employee Leave Balances")
                {
                    RunObject = Page "Employee Leave Balances";
                }
                action("Leave Applications")
                {
                    RunObject = Page "Leave Applications List";
                }
                action("Leave Recalls")
                {
                    RunObject = Page "Leave Recalls List";
                }
                action("Leave Periods")
                {
                    RunObject = Page "HR Leave Period List";
                }
                action("Leave Types")
                {
                    RunObject = Page "Leave Types Setup";
                }
            }
            group(Action77)
            {
                Caption = 'Performance Management';
                Image = AnalysisView;
                action("Performance Management Themes")
                {
                    Caption = 'Key Performance Areas';
                    RunObject = Page "Performance Management Themes";
                }
                action("Performance Objectives")
                {
                    RunObject = Page "Performance Objectives";
                }
                action("Departmental Objectives")
                {
                    RunObject = Page "WB Departmental Targets";
                }
                action("Evaluation Scale")
                {
                    RunObject = Page "Appraisal Remarks";
                }

                action("Appraissal Periods")
                {
                    Caption = 'Appraissal Periods';
                    RunObject = Page "HR Appraisal Period List";
                }
                action("Performance Planning")
                {
                    Caption = 'Target Setting';
                    RunObject = Page "Employee Targets";
                    RunPageView = WHERE("Sent to Supervisor" = CONST(false),
                                        "Approved By Supervisor" = CONST(false));
                }
                action("Performance Planning Approval")
                {
                    Caption = 'Targets Pending Approval';
                    RunObject = Page "Supervisor Employee Targets";
                    RunPageView = WHERE("Sent to Supervisor" = CONST(true));
                }
                action("Approved Targets")
                {
                    RunObject = Page "Approved Employee Targets";
                }
                action("Mid Year Appraisal")
                {
                    Caption = 'Mid-Period Review';
                    RunObject = Page "Mid Year Appraisal";
                }
                action("Peer Appraisal Selection")
                {
                    RunObject = Page "Peer Appraisal Selection List";
                    Visible = false;
                }
                action("Peer Review")
                {
                    RunObject = Page "First Peer Review";
                    Visible = false;
                }
                action(Appraisals)
                {
                    Caption = 'Apprissals';
                    RunObject = Page "Staff Appraisal Lists";
                }
            }
            /*group("Resource Planning  & TimeSheets")
            {
                Caption = 'Resource Planning  & TimeSheets';
                Image = ResourcePlanning;
                Visible = false;
                action("Employee Timesheet list")
                {
                    RunObject = Page "Employee Timesheet list";
                }
                action("Approved Employee Timesheet")
                {
                    RunObject = Page "Approved Employee Timesheet";
                }
            }*/
            group(Training)
            {
                Caption = 'Training';
                Image = FiledPosted;
                action("Training Master Plan")
                {
                    RunObject = Page "Training Master Plan";
                }
                action("Training Requests")
                {
                    RunObject = Page "Training List";
                }
                action("Pending Training Requests")
                {
                    RunObject = Page "Pending Training Requests";
                }
                action("Approved Training Requests")
                {
                    RunObject = Page "Approved Training Requests";
                }
                action("Training Schedules")
                {
                    RunObject = Page "Training Schedules";
                }
                action("Ongoing Trainings")
                {
                    RunObject = Page "Ongoing Trainings";
                }
                action("Completed Trainings")
                {
                    RunObject = Page "Completed Trainings";
                }
            }
            group(Memo)
            {
                Caption = 'Memo';
                action("Memo List")
                {
                    RunObject = Page "Memo List";
                }
                action("Posted Memo List")
                {
                    RunObject = Page "Posted Memo List";
                }
            }
            group("Medical Claim")
            {
                Caption = 'Medical Claims';
                action("Medical Claims")
                {
                    RunObject = Page "Claim List";
                }
                action("Posted Medical Claims")
                {
                    RunObject = Page "Posted Claims List";
                }
            }

            group(Travel)
            {
                Caption = 'Travel';


                action("Travelling Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Travelling Request';
                    RunObject = Page "Travelling Request Lines";
                }
                action("Posted Travelling Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Travelling Request';
                    RunObject = Page "Posted Travelling Requests";
                }
                action("Employee Travel Request")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employee Travel Request';
                    RunObject = Page "Employee Travel Request";
                    Visible = false;
                }

                action("Accident / Incident Logs")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Accident / Incident Logs';
                    RunObject = Page "Accident / Incident Logs List";
                }
                action("My Shifts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'My Shifts';
                    RunObject = Page "My Shifts";
                }
            }



            group("Shift Management")
            {
                Caption = 'Shift Management';
                action("Shift Lines")
                {
                    RunObject = Page "Shift List";
                    Caption = 'Shift List';
                }
                action("Posted Shift Lines")
                {
                    RunObject = Page "Shift Posted";
                    Caption = 'Posted Shift List';
                }
                action("Shift Meal Orders")
                {
                    RunObject = Page "Meal Order Setup";
                }

            }

        }
        area(reporting)
        {
            /*group("TimeSheet Management")
            {
                Caption = 'TimeSheet Management';
                Image = LotInfo;
                Visible = false;
                action("Staff Timesheet")
                {
                    Image = Timesheet;
                    RunObject = Report "Employee Timesheet Report";
                }
                action("Timesheet Report")
                {
                    Caption = 'Timesheet Report';
                    RunObject = Report "Employee Timesheet Ver2";
                }
            }*/
        }
    }
}