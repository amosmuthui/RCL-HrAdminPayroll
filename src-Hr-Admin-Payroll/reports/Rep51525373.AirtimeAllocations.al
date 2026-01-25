report 51525373 "Airtime Allocations"
{
    ApplicationArea = All;
    Caption = 'Airtime Allocations';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/AirtimeAllocations.rdlc';
    dataset
    {
        dataitem(AirtimeAllocationPeriods; "Airtime Allocation Batches")
        {
            RequestFilterHeading = 'Batches';
            RequestFilterFields = "Month Start Date";
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
            column(MonthStartDate; "Month Start Date")
            {
            }
            column(Doc_No; "Doc No")
            { }
            column(Description; Description)
            {
            }
            column(ServiceProvider; "Service Provider")
            {
            }
            column(ApprovalStatus; "Approval Status")
            {
            }

            dataitem("Airtime Allocations"; "Airtime Allocations")
            {
                RequestFilterHeading = 'Allocations';
                RequestFilterFields = "Emp No.", "Dept Code", "Position Code", "Job Category";
                DataItemLink = Period = field("Month Start Date");

                column(Emp_No_; "Emp No.")
                { }
                column(Emp_Name; "Emp Name")
                { }
                column(Phone_No_; "Phone No.")
                { }
                column(Airtime_Amount; "Airtime Amount")
                { }
            }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then begin
                    CompanyInformation.CalcFields(Picture);
                    ReportTitle := 'AIRTIME ALLOCATION LIST FOR ' + UpperCase(Description) + ' IN ' + DesiredCurrency;
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
