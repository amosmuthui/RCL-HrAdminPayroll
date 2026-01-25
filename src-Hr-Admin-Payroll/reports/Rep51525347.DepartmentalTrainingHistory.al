report 51525347 "Departmental Training History"
{
    ApplicationArea = All;
    Caption = 'Departmental Training History';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/DepartmentalTrainingHistory.rdlc';
    dataset
    {
        dataitem(TrainingScheduleLines; "Training Schedule Lines")
        {
            RequestFilterHeading = 'Departmental Training History';
            DataItemTableView = SORTING("End Date") where(Status = const(Done));
            RequestFilterFields = "Department Code", "Training No.", "End Date", "Renew By", "Trainer Name";

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
            column(LineNo; "Line No.")
            {
            }
            column(ScheduleNo; "Schedule No.")
            {
            }
            column(EmpNo; "Emp No.")
            {
            }
            column(EmployeeName; "Employee Name")
            {
            }
            column(Section; Section)
            {
            }
            column(JobTitle; "Job Title")
            {
            }
            column(DepartmentCode; "Department Code")
            {
            }
            column(Frequency; Frequency)
            {
            }
            column(TrainerName; "Trainer Name")
            {
            }
            column(StartDate; Format("Start Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(EndDate; Format("End Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(TrainingTitle; "Training Title")
            {
            }
            column(TrainingNo; "Training No.")
            {
            }
            column(RenewBy; Format("Renew By", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(CertificateSerialNo; "Certificate Serial No.")
            {
            }
            column(Department_Name; "Department Name")
            { }
            column(E_Mail; "E-Mail")
            { }
            column(IsRenewable; IsRenewable)
            { }
            column(Renewed; Renewed)
            { }
            column(ReportFilters; ReportFilters)
            { }
            column(CustomExecutionTime; CustomExecutionTime)
            { }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;

                IsRenewable := 'No';
                Renewed := '';
                if TrainingScheduleLines.Frequency <> '' then begin
                    IsRenewable := 'Yes';
                    updateParticipantType();
                    Renewed := 'No';
                    if Type = Type::Refresher then
                        Renewed := 'Yes';

                    //if same course was done last time (-Frequency) then it has been renewed.
                    /*TrainingScheduleLines.CalcFields("Training No.");
                    PrevScheduleLine.Reset();
                    PrevScheduleLine.SetFilter("Schedule No.", '<>%1', "Schedule No.");
                    PrevScheduleLine.SetRange("Emp No.", "Emp No.");
                    PrevScheduleLine.SetRange("Training No.", "Training No.");
                    PrevScheduleLine.SetFilter("Start Date", '<=%1', "Start Date");
                    if PrevScheduleLine.FindFirst() then
                        Renewed := 'Yes'
                    else
                        Renewed := 'No';*/
                end;

                //if "Certificate Serial No." = '' then
                //"Certificate Serial No." := "Schedule No." + '/' + Format("Line No.");
            end;



            trigger OnPreDataItem()
            begin
                ReportFilters := 'Filters: ' + TrainingScheduleLines.GetFilters;
                CustomExecutionTime := 'Printed On: ' + Format(CurrentDateTime, 0, '<Day,2> <Month Text,3> <Year4> <Hours12,2>:<Minutes,2> <AM/PM>');

                /*if (IncludePending) or (IncludingPostponed) then begin
                    if (IncludePending) or (not IncludingPostponed) then
                        TrainingScheduleLines.SetFilter(Status, '%1|%2|%3', TrainingScheduleLines.Status::Pending, TrainingScheduleLines.Status::Done, TrainingScheduleLines.Status::Ongoing);
                    if (not IncludePending) or (IncludingPostponed) then
                        TrainingScheduleLines.SetFilter(Status, '%1|%2|%3', TrainingScheduleLines.Status::Postponed, TrainingScheduleLines.Status::Done, TrainingScheduleLines.Status::Ongoing);
                    //If both are included then no need for filters            
                end else
                    TrainingScheduleLines.SetFilter(Status, '%1|%2', TrainingScheduleLines.Status::Done, TrainingScheduleLines.Status::Ongoing);*/
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Include Pending Classes"; IncludePending)
                {
                    Visible = false;
                }
                field("Include Postponed Classes"; IncludingPostponed)
                {
                    Visible = false;
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
        IncludePending: Boolean;
        IncludingPostponed: Boolean;
        IsRenewable: Text[10];
        Renewed: Text[10];
        PrevScheduleLine: Record "Training Schedule Lines";
        ReportFilters: Text;
        CustomExecutionTime: Text;
}