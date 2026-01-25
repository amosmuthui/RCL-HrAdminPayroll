page 51525303 "Leave and Performance R.C"
{
    ApplicationArea = All;
    Caption = 'Leave and Performance Management';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control8; "Common Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control7; "Leave & Performance Cues")
            {
            }
            part(Control6; "Power BI Embedded Report Part")
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
                    action("Monthly Leave Analysis")
                    {
                        Image = "Report";
                        RunObject = Report "Monthly Leave Analysis";
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
            group("Employee Manager")
            {
                Caption = 'Employee Manager';
                Image = HumanResources;
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

                action("Appraissal Periods")
                {
                    Caption = 'Appraissal Periods';
                    RunObject = Page "HR Appraisal Period List";
                }
                action("Evaluation Scale")
                {
                    RunObject = Page "Appraisal Remarks";
                }
                action("Performance Management Themes")
                {
                    Caption = 'Key Performance Areas';
                    RunObject = Page "Performance Management Themes";
                }
                action("Performance Objectives")
                {
                    Caption = 'Organizational Targets';
                    RunObject = Page "Performance Objectives";
                }
                action("Departmental Objectives")
                {
                    Caption = 'Departmental Targets';
                    RunObject = Page "WB Departmental Targets";
                }

                action("Performance Planning")
                {
                    Caption = 'Staff Targets';
                    RunObject = Page "Employee Targets";
                    RunPageView = WHERE("Sent to Supervisor" = CONST(false),
                                        "Approved By Supervisor" = CONST(false));
                }
                action("Performance Planning Approval")
                {
                    Caption = 'Targets Pending Approval';
                    RunObject = Page "Supervisor Employee Targets";
                    RunPageView = WHERE("Sent to Supervisor" = CONST(true), "Approved By Supervisor" = FILTER(false));
                }
                action("Approved Targets")
                {
                    RunObject = Page "Approved Employee Targets";
                }
                action("Mid Year Appraisal")
                {
                    Caption = 'Mid-Year Review';
                    RunObject = Page "Mid Year Appraisal";
                    RunPageView = where("Sent to Supervisor" = const(false), "Approved By Supervisor" = const(false));
                }
                action("Pending Mid Year Appraisal")
                {
                    Caption = 'Pending Mid-Year Reviews'; //'Mid-Period Review';
                    RunObject = Page "Mid Year Appraisal";
                    RunPageView = where("Sent to Supervisor" = const(true), "Approved By Supervisor" = const(false));
                }
                action("Approved Mid Year Appraisal")
                {
                    Caption = 'Approved Mid-Year Reviews'; //'Mid-Period Review';
                    RunObject = Page "Mid Year Appraisal";
                    RunPageView = where("Approved By Supervisor" = const(true));
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
                    Caption = 'End Year Appraisals';
                    RunObject = Page "Staff Appraisal Lists";
                    RunPageView = where("Sent to Supervisor" = const(false), "Approved By Supervisor" = const(false));
                }
                action(PendingAppraisals)
                {
                    Caption = 'Pending Appraisals';
                    RunObject = Page "Staff Appraisal Lists";
                    RunPageView = where("Sent to Supervisor" = const(true), "Approved By Supervisor" = const(false));
                }
                action(ApprovedAppraisals)
                {
                    Caption = 'Approved Appraisals';
                    RunObject = Page "Staff Appraisal Lists";
                    RunPageView = where("Approved By Supervisor" = const(true));
                }
            }
        }
        area(reporting)
        {

            group("Performance Management")
            {
                Caption = 'Performance Management';
                Image = LotInfo;
                action("Employees Target Setting  Status")
                {
                    Caption = 'Employees Target Setting  Status';
                    Image = Timesheet;
                    RunObject = Report "Employees target Status";
                }
                action("Employees Mid year status")
                {
                    Caption = 'Employees Mid year status';
                    RunObject = Report "Employees mid year status";
                }
                action("Staff Performance Planning")
                {
                    Caption = 'Employees Performance Planning';
                    RunObject = Report "Appraisal Report";
                }
                action("Staff MidYear Appraisal Report")
                {
                    Caption = 'Employees MidYear Appraisal Report';
                    RunObject = Report "Quarterly Checkin";
                }
            }
        }
    }
}