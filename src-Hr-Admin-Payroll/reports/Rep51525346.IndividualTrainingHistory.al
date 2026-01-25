report 51525346 "Individual Training History"
{
    ApplicationArea = All;
    Caption = 'Individual Training History';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/IndividualTrainingHistory.rdlc';
    dataset
    {
        dataitem(TrainingScheduleLines; "Training Schedule Lines")
        {
            RequestFilterHeading = 'Individual Training History';
            DataItemTableView = SORTING("End Date") where(Status = const(Done));
            RequestFilterFields = "Emp No.", "End Date", "Training No.", "Renew By", "Trainer Name";

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
                if TrainingScheduleLines.Frequency <> '' then
                    IsRenewable := 'Yes';

                AdditionalInstructors.Reset();
                AdditionalInstructors.SetRange("Class No.", TrainingScheduleLines."Schedule No.");
                AdditionalInstructors.SetFilter("No.", '<>%1', '');
                if AdditionalInstructors.FindSet() then
                    repeat
                        if "Trainer Name" = '' then
                            "Trainer Name" := AdditionalInstructors.Name
                        else
                            "Trainer Name" += ', ' + AdditionalInstructors.Name;
                    until AdditionalInstructors.Next() = 0;

                /*if "Certificate Serial No." = '' then
                    "Certificate Serial No." := "Schedule No." + '/' + Format("Line No.");*/
            end;



            trigger OnPreDataItem()
            begin
                if TrainingScheduleLines.GetFilter("Emp No.") = '' then
                    Error('You must select at least one participant using the "Emp No." filter!');
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
        ReportFilters: Text;
        CustomExecutionTime: Text;
        AdditionalInstructors: Record "Additional Instructors";
}