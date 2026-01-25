page 51525596 "HR Admin Role Center"
{
    ApplicationArea = All;
    Caption = 'HR Admin Role Center';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Control8; "Common Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control7; "HR Admin Cues")
            {
            }
            part(Control6; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        area(embedding)
        {
            action("Job Categories")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Job Categories';
                RunObject = Page "Job Categories";
            }
            action("Employee List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employee List';
                RunObject = Page "HR Employee List";
            }
            action("Airtime Service Providers")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Airtime Service Providers';
                RunObject = Page "Airtime Service Providers";
            }
            action("Hotels")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Hotels';
                RunObject = Page Hotels;
            }
            action("Refreshment Types")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Refreshment Types';
                RunObject = Page "Refreshment Types";
            }
            action("Rooms")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Rooms';
                RunObject = Page Rooms;
            }
            action("Letter Templates")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Letter Templates';
                RunObject = Page "Letter Templates";
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
            group("Reports")
            {
                Caption = 'Admin Reports';
                group("Airtime Reports")
                {
                    Caption = 'Airtime Management Reports';
                    Image = Balance;
                    action("Airtime Allocations")
                    {
                        RunObject = Report "Airtime Allocations";
                    }
                }
                group("Room Reports")
                {
                    Caption = 'Room Management Reports';
                    Image = Balance;
                    action("Room Bookings")
                    {
                        RunObject = Report "Room Bookings";
                    }
                }
            }
        }

        area(sections)
        {
            group("Airtime Management")
            {
                Caption = 'Airtime Management';
                Image = AnalysisView;

                action("Job Categories1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Job Categories';
                    RunObject = Page "Job Categories";
                }
                action("Employee List1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Employee List';
                    RunObject = Page "HR Employee List";
                }
                action("Airtime Service Providers1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Airtime Service Providers';
                    RunObject = Page "Airtime Service Providers";
                }
                group("Airtime Allocation Batches - Group")
                {
                    Caption = 'Airtime Allocation Batches';
                    action("All Batches")
                    {
                        Caption = 'All';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Allocation Batches";
                    }
                    action("Open Batches")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Allocation Batches";
                        RunPageView = where("Approval Status" = filter(Open | Rejected));
                    }
                    action("Pending Batches")
                    {
                        Caption = 'Pending Approval';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Allocation Batches";
                        RunPageView = where("Approval Status" = filter("Pending Approval"));
                    }
                    action("Approved Batches")
                    {
                        Caption = 'Approved';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Allocation Batches";
                        RunPageView = where("Approval Status" = filter(Released));
                    }
                    action("Processed Batches")
                    {
                        Caption = 'Processed'; //Sent to vendor
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Allocation Batches";
                        RunPageView = where("Sent to Vendor" = const(true));
                    }
                }
                group("Airtime Requests")
                {
                    Caption = 'Airtime Requests';
                    action("All Request")
                    {
                        Caption = 'All';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Requests";
                    }
                    action("Open Requests")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Requests";
                        RunPageView = where("Approval Status" = filter(Open | Rejected));
                    }
                    action("Pending Requests")
                    {
                        Caption = 'Pending Approval';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Requests";
                        RunPageView = where("Approval Status" = filter("Pending Approval"));
                    }
                    action("Approved Requests")
                    {
                        Caption = 'Approved';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Requests";
                        RunPageView = where("Approval Status" = filter(Released));
                    }
                    action("Processed Requests")
                    {
                        Caption = 'Processed'; //Sent to vendor
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Airtime Requests";
                        RunPageView = where(Processed = const(true));
                    }
                }
            }

            group("Hotel & Booking")
            {
                Caption = 'Hotel & Booking';
                Image = AnalysisView;

                action("Hotels1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Hotels';
                    RunObject = Page "Hotels";
                }
                group("Booking Requests")
                {
                    Caption = 'Booking Requests';
                    action("All Bookings")
                    {
                        Caption = 'All';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Hotel Booking Requests";
                    }
                    action("Open Bookings")
                    {
                        Caption = 'Open';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Hotel Booking Requests";
                        RunPageView = where("Approval Status" = filter(Open | Rejected));
                    }
                    action("Pending Bookings")
                    {
                        Caption = 'Pending Approval';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Hotel Booking Requests";
                        RunPageView = where("Approval Status" = filter("Pending Approval"));
                    }
                    action("Approved Bookings")
                    {
                        Caption = 'Approved';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Hotel Booking Requests";
                        RunPageView = where("Approval Status" = filter(Released));
                    }
                }
                group("Reservations")
                {
                    Caption = 'Hotel Reservations';
                    action("All Reservations")
                    {
                        Caption = 'All';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Hotel Booking Requests";
                        RunPageView = where("Approval Status" = filter(Released));
                    }
                    action("Reserved")
                    {
                        Caption = 'Reserved';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Hotel Booking Requests";
                        RunPageView = where("Approval Status" = filter(Released), "Reservation Status" = const(Reserved));
                    }
                    action("Cancelled")
                    {
                        Caption = 'Cancelled';
                        ApplicationArea = Basic, Suite;
                        RunObject = Page "Hotel Booking Requests";
                        RunPageView = where("Approval Status" = filter(Released), "Reservation Status" = const(Cancelled));
                    }
                }
            }

            group("Refreshment Management")
            {

                action("Refreshment Types1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Refreshment Types';
                    RunObject = Page "Refreshment Types";
                }
                action("Refreshment Requests")
                {
                    Caption = 'Refreshment Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Refreshment Requests";
                }
                action("Open Refreshment Requests")
                {
                    Caption = 'Open Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Refreshment Requests";
                    RunPageView = where("Approval Status" = filter(Open | Rejected));
                }
                action("Pending Refreshment Requests")
                {
                    Caption = 'Pending Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Refreshment Requests";
                    RunPageView = where("Approval Status" = filter("Pending Approval"));
                }
                action("Approved Refreshment Requests")
                {
                    Caption = 'Approved Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Refreshment Requests";
                    RunPageView = where("Approval Status" = filter(Released));
                }
            }

            group("Room Management")
            {
                action("Rooms1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Rooms';
                    RunObject = Page "Rooms";
                }
                action("Room Booking Requests")
                {
                    Caption = 'Booking Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Room Booking Requests";
                }
                action("Open Room Requests")
                {
                    Caption = 'Open Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Room Booking Requests";
                    RunPageView = where("Approval Status" = filter(Open | Rejected));
                }
                action("Pending Room Requests")
                {
                    Caption = 'Pending Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Room Booking Requests";
                    RunPageView = where("Approval Status" = filter("Pending Approval"));
                }
                action("Approved Room Requests")
                {
                    Caption = 'Approved Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Room Booking Requests";
                    RunPageView = where("Approval Status" = filter(Released));
                }
            }

            group("Visa Application")
            {
                action("Letter Templates1")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Letter Templates';
                    RunObject = Page "Letter Templates";
                }
                action("Recommendation Letters")
                {
                    Caption = 'Recommendation Letters';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Recommendation Letters";
                }
                action("All Requisition Fees Requests")
                {
                    Caption = 'Requisition Fees Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Requisition Fees Requests";
                }
                action("Open Requisition Fees Requests")
                {
                    Caption = 'Open Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Requisition Fees Requests";
                    RunPageView = where("Approval Status" = filter(Open | Rejected));
                }
                action("Pending Requisition Fees Requests")
                {
                    Caption = 'Pending Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Requisition Fees Requests";
                    RunPageView = where("Approval Status" = filter("Pending Approval"));
                }
                action("Approved Requisition Fees Requests")
                {
                    Caption = 'Approved Requests';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Requisition Fees Requests";
                    RunPageView = where("Approval Status" = filter(Released));
                }
            }
        }
    }
}
