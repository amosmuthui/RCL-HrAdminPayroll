report 51525318 "Maternity Leave Report"
{
    ApplicationArea = All;
    Caption = 'Maternity Leave Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/MaternityLeaveReport.rdlc';
    dataset
    {
        dataitem(EmployeeLeaveApplication; "Employee Leave Application")
        {
            RequestFilterFields = "Application No", "Employee No";
            DataItemTableView = where("Leave Type" = const('MATERNITY'), Status = filter(Released));

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
            column(ApplicationNo; "Application No")
            {
            }
            column(EmployeeNo; "Employee No")
            {
            }
            column(EmployeeName; "Employee Name")
            {
            }
            column(StartDate; Format("Start Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(EndDate; Format("End Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(ApprovedDays; "Approved Days")
            {
            }
            column(ResumptionDate; Format("Resumption Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(DepartmentCode; "Department Code")
            {
            }
            column(DepartmentName; "Department Name")
            {
            }
            column(ReportTitle; 'MATERNITY LEAVE REPORT FOR ' + UpperCase(Format(PayrollPeriod, 0, '<Month Text> <Year4>')))
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
                if PayrollPeriod <> 0D then begin
                    FilterText := '';
                    //If starts this month
                    LeaveApps.SetFilter("Start Date", '%1..%2', PayrollPeriod);
                    LeaveApps.SetFilter("Leave Type", 'MATERNITY');
                    LeaveApps.SetRange(Status, LeaveApps.Status::Released);
                    if LeaveApps.FindSet() then
                        repeat
                            if FilterText = '' then
                                FilterText := LeaveApps."Application No"
                            else
                                FilterText := FilterText + '|' + LeaveApps."Application No";
                        until LeaveApps.Next() = 0;

                    //If ends this month - maternity leave cannot start and end the same month, so we don't expect repetitions 
                    LeaveApps.SetFilter("End Date", '%1..%2', PayrollPeriod);
                    LeaveApps.SetFilter("Leave Type", 'MATERNITY');
                    LeaveApps.SetRange(Status, LeaveApps.Status::Released);
                    if LeaveApps.FindSet() then
                        repeat
                            if FilterText = '' then
                                FilterText := LeaveApps."Application No"
                            else
                                FilterText := FilterText + '|' + LeaveApps."Application No";
                        until LeaveApps.Next() = 0;

                    if FilterText <> '' then
                        EmployeeLeaveApplication.SetFilter("Application No", FilterText);
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Payroll Period"; PayrollPeriod)
                {
                    TableRelation = "Payroll Period";
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
        trigger OnOpenPage()
        begin
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                PayrollPeriod := Periods."Starting Date";
        end;
    }
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        PayrollPeriod: Date;
        Periods: Record "Payroll Period";
        FilterText: Text;
        LeaveApps: Record "Employee Leave Application";
}