report 51525345 "Monthly Training Report"
{
    ApplicationArea = All;
    Caption = 'Monthly Training Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/MonthlyTrainingReport.rdlc';
    dataset
    {
        dataitem(CompanyInfo; "Training Schedules")
        {

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
            column(TotalClasses; TotalClasses)
            {
            }
            column(TotalOutsourcedClasses; TotalOutsourcedClasses)
            {
            }
            column(ReportTitle; ReportTitle)
            { }
            column(TotalStaffTrainedThroughOutsourcedClasses; TotalStaffTrainedThroughOutsourcedClasses)
            { }
            column(TotalStaffTrained; TotalStaffTrained)
            { }
            column(TotalInhouseInstructors; TotalInhouseInstructors)
            { }
            column(TotalInhouseInstructorsCost; TotalInhouseInstructorsCost)
            { }
            column(TrainingFacilityCosts; TrainingFacilityCosts)
            { }
            column(TotalLunchAtHeadOffice; TotalLunchAtHeadOffice)
            { }
            column(TotalTrainingCosts; TotalTrainingCosts)
            { }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;

                TotalClasses := 0;
                TotalOutsourcedClasses := 0;
                TotalStaffTrainedThroughOutsourcedClasses := 0;
                TotalStaffTrained := 0;
                TotalInhouseInstructors := 0;
                TotalInhouseInstructorsCost := 0;
                TrainingFacilityCosts := 0;
                TotalLunchAtHeadOffice := 0;
                TotalTrainingCosts := 0;

                EndDate := CalcDate('CM', StartDate);
                Classes.Reset();
                Classes.SetFilter("Start Date", '%1..%2', StartDate, EndDate);
                Classes.SetFilter(Status, '%1|%1', Classes.Status::Done, Classes.Status::Ongoing);
                if Classes.FindSet() then
                    repeat
                        Classes.CalcFields("Participants Count");
                        TotalClasses += 1;
                        TotalStaffTrained += Classes."Participants Count";

                        AdditionalInstructors.Reset();
                        AdditionalInstructors.SetRange("Class No.", Classes."No.");
                        AdditionalInstructors.SetFilter("No.", '<>%1', '');
                        if AdditionalInstructors.FindSet() then
                            repeat
                                if AdditionalInstructors.Category = AdditionalInstructors.Category::Internal then begin
                                    TotalInhouseInstructors += 1;
                                    TotalInhouseInstructorsCost += AdditionalInstructors.Allowance;
                                end;
                            until AdditionalInstructors.Next() = 0;

                        if Classes."Trainer Category" = Classes."Trainer Category"::Supplier then begin
                            TotalOutsourcedClasses += 1;
                            TotalStaffTrainedThroughOutsourcedClasses += Classes."Participants Count";
                        end;
                        if Classes."Trainer Category" = Classes."Trainer Category"::Internal then begin
                            TotalInhouseInstructors += 1;
                            TotalInhouseInstructorsCost += Classes."Instructor Allowance";
                        end;
                        TrainingFacilityCosts += Classes."Facility Costs";
                        TotalLunchAtHeadOffice += Classes."Head office Lunch";

                        TotalTrainingCosts += (Classes."Instructor Allowance" + Classes."Head office Lunch" + Classes."Facility Costs");
                    until Classes.Next() = 0;
            end;

            trigger OnPreDataItem()
            begin
                ReportTitle := '';
                CompanyInformation.Get;

                if (StartDate = 0D) then
                    Error('You must select the month start date;');

                ReportTitle := 'TRAINING REPORT - ' + UpperCase(Format(StartDate, 0, '<Month Text> <Year4>'));
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Month Start Date"; StartDate)
                {
                }
                field("To Date"; EndDate)
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
        StartDate: Date;
        EndDate: Date;
        Category: Option External,"Internal","Internal and External";
        ReportTitle: Text;
        AllOtherCosts: Decimal;
        TotalCosts: Decimal;
        Classes: Record "Training Schedules";
        TotalClasses: Integer;
        TotalOutsourcedClasses: Integer;
        TotalStaffTrainedThroughOutsourcedClasses: Integer;
        TotalStaffTrained: Integer;
        TotalInhouseInstructors: Integer;
        TotalInhouseInstructorsCost: Decimal;
        TrainingFacilityCosts: Decimal;
        TotalLunchAtHeadOffice: Decimal;
        TotalTrainingCosts: Decimal;
        Participants: Record "Training Schedule Lines";
        AdditionalInstructors: Record "Additional Instructors";

}