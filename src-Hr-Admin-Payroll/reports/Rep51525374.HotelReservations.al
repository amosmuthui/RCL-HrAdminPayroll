report 51525374 "Hotel Reservations"
{
    ApplicationArea = All;
    Caption = 'Hotel Reservations';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/HotelReservation.rdlc';
    dataset
    {
        dataitem(HotelBookingRequests; "Hotel Booking Requests")
        {
            RequestFilterHeading = 'Requests';
            RequestFilterFields = "No.", "Hotel Code", "Requested By Emp No.";
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
            column(No; "No.")
            {
            }
            column(RequestedByEmpNo; "Requested By Emp No.")
            {
            }
            column(RequestedByEmpName; "Requested By Emp Name")
            {
            }
            column(Country; "Country Name")
            {
            }
            column(HotelCode; "Hotel Code")
            {
            }
            column(HotelName; "Hotel Name")
            {
            }
            column(CheckinDate; Format("Check-in Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(CheckoutDate; Format("Check-out Date", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }

            dataitem("Hotel Booking Lines"; "Hotel Booking Lines")
            {
                RequestFilterHeading = 'Traveller Details';
                RequestFilterFields = "Traveler Category", "Traveler No.";
                DataItemLink = "Request No." = field("No.");

                column(Traveler_Category; "Traveler Category")
                { }
                column(Traveler_No_; "Traveler No.")
                { }
                column(Name; Name)
                { }
                column(Phone_No_; "Phone No.")
                { }
                column(Special_Requirements; "Special Requirements")
                { }
            }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then begin
                    CompanyInformation.CalcFields(Picture);
                    ReportTitle := 'HOTEL RESERVATION DETAILS';
                end
            end;


            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
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

    trigger OnInitReport()
    begin
        DesiredCurrency := '';
        if GenLedgerSetup.Get() then
            DesiredCurrency := GenLedgerSetup."LCY Code";

    end;

    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        ReportTitle: Text;
        DesiredCurrency: Code[100];
        GenLedgerSetup: Record "General Ledger Setup";
}
