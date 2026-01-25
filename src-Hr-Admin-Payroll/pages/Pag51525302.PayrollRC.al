page 51525302 "Payroll R.C"
{
    ApplicationArea = All;
    Caption = 'Payroll Dashboard';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control8; "Common Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control7; "Payroll Cues")
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
            action("All Employees 1")
            {
                Caption = 'All Employees';
                ApplicationArea = Basic, Suite;
                //RunObject = Page "All Employee List";
                RunObject = Page "Employee List";
            }
            action("Active Employees 1")
            {
                Caption = 'Active Employees';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Employee List";
                RunPageView = where(Status = const(Active));
            }
            action("Inactive Employees 1")
            {
                Caption = 'Inactive Employees';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Employee List";
                RunPageView = where(Status = const(Inactive));
            }
            action("Payrol Processing list 1")
            {
                Caption = 'Payrol Processing list';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Payrol Processing list";
            }
            action("Payroll Periods")
            {
                ApplicationArea = Basic, Suite;
                RunObject = Page "Pay Periods";
            }
            action("Earnings")
            {
                ApplicationArea = Basic, Suite;
                RunObject = Page Earnings;
            }
            action("Deductions")
            {
                ApplicationArea = Basic, Suite;
                RunObject = Page Deductions;
            }
            action("Bracket Tables 1")
            {
                Caption = 'Bracket Tables';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Bracket Tables";
            }
            action("Salary Scales List 1")
            {
                Caption = 'Salary Grades';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Salary Scales List";
            }
            action("Scale Benefits 1")
            {
                Caption = 'Salary Notches';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Scale Benefits";
            }
            action("Countries 1")
            {
                Caption = 'Countries';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Countries/Regions";
            }
            action("Currencies 1")
            {
                Caption = 'Currencies';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Currencies";
            }
            action("Social Grades 1")
            {
                Caption = 'Social Grades';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Social Grades";
            }
            action("Employee Period Bank Details 1")
            {
                Caption = 'Employee Period Bank Details';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Employee Period Bank Details";
            }
            action("Open Installment Deductions 1")
            {
                Caption = 'Open Installment Deductions';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Loan transaction";
            }
            action("Active Installment Deductions 1")
            {
                Caption = 'Active Installment Deductions';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Active Loan transaction";
            }
            action("Paused Installment Deductions 1")
            {
                Caption = 'Paused Installment Deductions';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Paused Loan transaction";
            }
            action("Suspended Installment Deductions 1")
            {
                Caption = 'Suspended Installment Deductions';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Suspended Loan transaction";
            }
            action("Cleared Installment Deductions 1")
            {
                Caption = 'Cleared Installment Deductions';
                ApplicationArea = Basic, Suite;
                RunObject = Page "Cleared Loan transaction";
            }
            action("Training Allowance Batches 1")
            {
                Caption = 'Training Allowance Batches';
                RunObject = Page "Training Allowance Batches";
                RunPageView = where(Status = filter(<> Open));
            }
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
                    /*action("Employees With less than 1/3")
                    {
                        Caption = 'Employees With less than 1/3';
                        RunObject = Report "Employees With less than 1/3";
                        Visible = false;
                    }*/
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
                    action("Monthly Payroll Summary")
                    {
                        RunObject = Report "Monthly Payroll Summary";
                    }
                    action("Detailed MP Report")
                    {
                        RunObject = Report "Detailed Monthly Payroll Stat";
                    }
                    action("Lump Sum Report")
                    {
                        RunObject = Report "Lumpsum Report";
                    }
                    action("Overtime Report")
                    {
                        RunObject = Report "Overtime Report";
                    }
                    action("Inhouse Instructor Allowance")
                    {
                        RunObject = Report "Instructor Allowance";
                    }
                    action("Special Transport Allowance Report")
                    {
                        RunObject = Report "Special Transport Allowance";
                    }
                    action("Special Transport Bank Report")
                    {
                        RunObject = Report "TransAllowance Bank Advice";
                    }


                    /*action("Payroll-Statistics")
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
                    action("Payslip Report")
                    {
                        Image = "Report";
                        RunObject = Report "New Payslip";
                        Visible = false;
                    }
                    action("P9A (HOSP) Report")
                    {
                        Image = "Report";
                        RunObject = Report "P9A (HOSP) Report";
                        Visible = false;
                    }
                    action(P10A)
                    {
                        Image = "Report";
                        RunObject = Report P10A;
                        Visible = false;
                    }
                    action(P10)
                    {
                        Image = "Report";
                        RunObject = Report P10;
                        Visible = false;
                    }
                    action("P10 Return Itax")
                    {
                        Image = "Report";
                        RunObject = Report "P10 Return Itax";
                        Visible = false;
                    }
                    action("P10 Return Itax Version 2")
                    {
                        Image = "Report";
                        RunObject = Report "P10 Return Itax Ver2";
                        Visible = false;
                    }
                    action(P10B)
                    {
                        Image = "Report";
                        RunObject = Report P10B;
                        Visible = false;
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
            group(Payroll)
            {
                Caption = 'Payroll';
                Image = FiledPosted;
                action("All Employees")
                {
                    RunObject = Page "Employee List";
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
                action("Payrol Processing list")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payrol Processing list";
                }
                action("Pay Periods")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Pay Periods";
                }
                action("Earnings List")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page Earnings;
                }
                action("Deductions List")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page Deductions;
                }
                action("Bracket Tables")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Bracket Tables";
                }
                action("Salary Scales List")
                {
                    Caption = 'Salary Grades';
                    RunObject = Page "Salary Scales List";
                }
                action("Scale Benefits")
                {
                    Caption = 'Salary Notches';
                    RunObject = Page "Scale Benefits";
                }
                action("Countries")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Countries/Regions";
                }
                action("Currencies")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Currencies";
                }
                action("Social Grades")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Social Grades";
                }
                action("Employee Period Bank Details")
                {
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Employee Period Bank Details";
                }
                action("Open Installment Deductions")
                {
                    Caption = 'Open Installment Deductions';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Loan transaction";
                }
                action("Active Installment Deductions")
                {
                    Caption = 'Active Installment Deductions';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Active Loan transaction";
                }
                action("Paused Installment Deductions")
                {
                    Caption = 'Paused Installment Deductions';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Paused Loan transaction";
                }
                action("Suspended Installment Deductions")
                {
                    Caption = 'Suspended Installment Deductions';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Suspended Loan transaction";
                }
                action("Cleared Installment Deductions")
                {
                    Caption = 'Cleared Installment Deductions';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Cleared Loan transaction";
                }

                action("Training Allowance Batches")
                {
                    Caption = 'Training Allowance Batches';
                    RunObject = Page "Training Allowance Batches";
                    RunPageView = where(Status = filter(<> Open));
                }
            }
            group("Terminal Dues")
            {
                Caption = 'Terminal Dues';
                Image = FiledPosted;
                action("Open Terminal Dues")
                {
                    RunObject = Page "Open Terminal Dues";
                }
                action("Pending Terminal Dues")
                {
                    RunObject = Page "Pending Terminal Dues";
                }
                action("Approved Terminal Dues")
                {
                    RunObject = Page "Approved Terminal Dues";
                }
            }
            group("Retirement Benefits")
            {
                Caption = 'Retirement Benefits';
                Image = FiledPosted;
                action("Open Retirement Benefits")
                {
                    RunObject = Page "Open Retirement Benefits";
                }
                action("Pending Retirement Benefits")
                {
                    RunObject = Page "Pending Retirement Benefits";
                }
                action("Approved Retirement Benefits")
                {
                    RunObject = Page "Approved Retirement Benefits";
                }
            }
        }
        area(reporting)
        {
        }
    }
}