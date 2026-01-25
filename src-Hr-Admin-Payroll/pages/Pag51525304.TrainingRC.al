page 51525304 "Training R.C"
{
    ApplicationArea = All;
    Caption = 'Training Dashboard';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control8; "Common Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control7; "Training Cues")
            {
            }
            part(Control6; "Power BI Embedded Report Part")
            {
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
            }
        }
    }

    actions
    {
        area(embedding)
        {

            action("Training Master Plan 1")
            {
                Caption = 'Courses';
                RunObject = Page "Training Master Plan";
            }
            action("Training Requests 1")
            {
                Caption = 'Training Requests';
                RunObject = Page "Training List";
            }
            action("Pending Training Requests 1")
            {
                Caption = 'Pending Training Requests';
                RunObject = Page "Pending Training Requests";
            }
            action("Approved Training Requests 1")
            {
                Caption = 'Approved Training Requests';
                RunObject = Page "Approved Training Requests";
            }
            action("External Trainers 1")
            {
                Caption = 'External Instructors';
                RunObject = Page "External Trainers";
            }
            action("Training Schedules 1")
            {
                Caption = 'Classes';
                RunObject = Page "Training Schedules";
            }
            action("Ongoing Trainings 1")
            {
                Caption = 'Ongoing Trainings';
                RunObject = Page "Ongoing Trainings";
            }
            action("Completed Trainings 1")
            {
                Caption = 'Completed Trainings';
                RunObject = Page "Completed Trainings";
            }
            action("Training Allowance Batches")
            {
                Caption = 'Training Allowance Batches';
                RunObject = Page "Training Allowance Batches";
            }
            action("Events History")
            {
                Caption = 'Events History';
                RunObject = Page "Training Events History";
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
            group(Action85)
            {
                Caption = 'Company Information';
                action("Company Information")
                {
                    RunObject = Page "Company Information";
                }
            }
            group("Reports")
            {
                Caption = 'Reports';
                action("Training Report")
                {
                    Caption = 'Training Report';
                    RunObject = Report "Training Report";
                }
                action("Monthly Training Report")
                {
                    Caption = 'Monthly Training Report';
                    RunObject = Report "Monthly Training Report";
                }
                action("Individual Training History")
                {
                    Caption = 'Individual Training History';
                    RunObject = Report "Individual Training History";
                }
                action("Departmental Training History")
                {
                    Caption = 'Departmental Training History';
                    RunObject = Report "Departmental Training History";
                }
                action("Instructor Allowance Report")
                {
                    Caption = 'Instructor Allowance Report';
                    RunObject = Report "Instructor Allowance";
                }
            }
        }
        area(sections)
        {
            group(Training)
            {
                Caption = 'Training';
                Image = FiledPosted;
                action("Training Master Plan")
                {
                    Caption = 'Courses';
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
                action("External Trainers")
                {
                    Caption = 'External Instructors';
                    RunObject = Page "External Trainers";
                }
                action("Training Schedules")
                {
                    Caption = 'Classes';
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

                action("Training Allowance Batches 1")
                {
                    Caption = 'Training Allowance Batches';
                    RunObject = Page "Training Allowance Batches";
                }
                action("Events History 1")
                {
                    Caption = 'Events History';
                    RunObject = Page "Training Events History";
                }
            }

        }
        area(reporting)
        {
        }
    }
}