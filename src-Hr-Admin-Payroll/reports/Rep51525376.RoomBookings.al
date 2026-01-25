report 51525376 "Room Bookings"
{
    ApplicationArea = All;
    Caption = 'Room Bookings';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/RoomBookings.rdlc';
    dataset
    {
        dataitem(RoomBookingRequests; "Room Booking Requests")
        {
            RequestFilterFields = "No.", "Room No.", "From DateTime", "To DateTime";
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyPIN; CompanyInformation."P.I.N")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyAddress2; CompanyInformation."Address 2")
            {
            }
            column(ComapnyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(ReportTitle; ReportTitle)
            {
            }
            column(FiltersText; FiltersText)
            { }
            column(No; "No.")
            {
            }
            column(RoomNo; "Room No.")
            {
            }
            column(NameTag; "Name/Tag")
            {
            }
            column(FromDateTime; Format("From DateTime", 0, '<Day,2> <Month Text,3> <Year4> <Hours12,2>:<Minutes,2> <AM/PM>'))
            {
            }
            column(ToDateTime; Format("To DateTime", 0, '<Day,2> <Month Text,3> <Year4> <Hours12,2>:<Minutes,2> <AM/PM>'))
            {
            }
            column(NoofUsers; "No. of Users")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }
            column(RequestedByEmpName; "Requested By Emp Name")
            {
            }
            column(IntendedUsersDescription; "Intended Users Description")
            {
            }
            column(Purpose; Purpose)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then begin
                    CompanyInformation.CalcFields(Picture);
                    ReportTitle := 'ROOM BOOKINGS';
                end
            end;


            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
                FiltersText := RoomBookingRequests.GetFilters;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        ReportTitle: Text;
        FiltersText: Text;
}
