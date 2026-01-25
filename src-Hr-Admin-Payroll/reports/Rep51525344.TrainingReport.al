report 51525344 "Training Report"
{
    ApplicationArea = All;
    Caption = 'Training Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/TrainingReport.rdlc';
    dataset
    {
        dataitem(TrainingSchedules; "Training Schedules")
        {
            DataItemTableView = SORTING("No.") where(Status = filter(Done | Ongoing));
            RequestFilterFields = "No.", "Trainer No.", "Training No.";

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
            column(No; "No.")
            {
            }
            column(TrainingNo; "Training No.")
            {
            }
            column(TrainingTitle; "Training Title")
            {
            }
            column(TrainingDescription; "Training Description")
            {
            }
            column(StartDate; Format("Start Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(EndDate; "End Date")
            {
            }
            column(Status; Status)
            {
            }
            column(TrainerNo; "Trainer No.")
            {
            }
            column(TrainerName; "Trainer Name")
            {
            }
            column(TrainerCategory; "Trainer Category")
            {
            }
            column(TrainingLocation; "Training Location")
            {
            }
            column(InstructorAllowance; "Instructor Allowance")
            {
            }
            column(FacilityCosts; "Facility Costs")
            {
            }
            column(CertificatesIssued; "Certificates Issued?")
            {
            }
            column(FacilityLunch; "Facility Lunch")
            {
            }
            column(HeadofficeLunch; "Head office Lunch")
            {
            }
            column(OtherCosts; "Other Costs")
            {
            }
            column(ReportTitle; ReportTitle)
            { }
            column(AllOtherCosts; AllOtherCosts)
            { }
            column(TotalCosts; TotalCosts)
            { }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;

                TrainingSchedules.CalcFields("Add. Instructor Allowances");
                "Instructor Allowance" += "Add. Instructor Allowances";
                AllOtherCosts := "Facility Costs" + "Facility Lunch" + "Head office Lunch" + "Other Costs";
                TotalCosts := AllOtherCosts + "Instructor Allowance";
            end;

            trigger OnPreDataItem()
            begin
                ReportTitle := '';
                CompanyInformation.Get;

                if Category = Category::External then begin
                    TrainingSchedules.SetRange("Trainer Category", TrainingSchedules."Trainer Category"::Supplier);
                    ReportTitle := 'EXTERNAL';
                end else if Category = Category::"Internal" then begin
                    TrainingSchedules.SetRange("Trainer Category", TrainingSchedules."Trainer Category"::Internal);
                    ReportTitle := 'IN-HOUSE';
                end else
                    ReportTitle := '';
                ReportTitle := ' TRAINING REPORT';

                if (StartDate <> 0D) and (EndDate <> 0D) then begin
                    TrainingSchedules.SetFilter("Start Date", '%1..%2', StartDate, EndDate);
                    ReportTitle := ReportTitle + ' ' + UpperCase(Format(StartDate, 0, '<Day,2> <Month Text> <Year4>')) + ' - ' + UpperCase(Format(EndDate, 0, '<Day,2> <Month Text> <Year4>'));
                    if (StartDate > EndDate) then
                        Error('From date should be later than start date!');
                end else begin
                    if (StartDate <> 0D) then begin
                        TrainingSchedules.SetRange("Start Date", StartDate);
                        if EndDate = 0D then
                            ReportTitle := ReportTitle + ' ' + UpperCase(Format(StartDate, 0, '<Day,2> <Month Text> <Year4>'));
                    end;
                    if (EndDate <> 0D) then begin
                        TrainingSchedules.SetRange("Start Date", EndDate);
                        if StartDate = 0D then
                            ReportTitle := ReportTitle + ' ' + UpperCase(Format(EndDate, 0, '<Day,2> <Month Text> <Year4>'));
                    end;
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
                field("From Date"; StartDate)
                {
                }
                field("To Date"; EndDate)
                {
                }
                field(Category; Category)
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
        StartDate: Date;
        EndDate: Date;
        Category: Option External,"Internal","Internal and External";
        ReportTitle: Text;
        AllOtherCosts: Decimal;
        TotalCosts: Decimal;
        AdditionalInstructors: Record "Additional Instructors";
}