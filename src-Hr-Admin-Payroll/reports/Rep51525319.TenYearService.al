report 51525319 "Ten Year Service"
{
    ApplicationArea = All;
    Caption = 'Ten Years of Service';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/TenYearService.rdlc';
    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.") WHERE("Date Of Join" = filter('<>0D'));
            RequestFilterFields = "No.", "Payroll Country";


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
            column(FirstName; "First Name")
            {
            }
            column(MiddleName; "Middle Name")
            {
            }
            column(LastName; "Last Name")
            {
            }
            column(AssignedGrossPay; "Assigned Gross Pay")
            {
            }
            column("PayrollCountry"; "Payroll Country")
            {
            }
            column(ContractualAmountType; "Contractual Amount Type")
            {
            }
            column(ContractualAmountCurrency; "Contractual Amount Currency")
            {
            }
            column(DateOfJoin; Format("Date Of Join", 0, '<Day,2>-<Month Text,3>-<year4>'))
            {
            }
            column(StartDate; UpperCase(Format(StartDate, 0, '<Day,2>-<Month Text>-<year4>')))
            {
            }
            column(EndDate; UpperCase(Format(EndDate, 0, '<Day,2>-<Month Text>-<year4>')))
            {
            }
            column(YearsInService; YearsInService)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;

                LastDate := Employee."Date Of Leaving";
                if (LastDate = 0D) or (Employee.Status = Employee.Status::Active) then
                    LastDate := EndDate;

                if (Employee.Status = Employee.Status::Inactive) then begin
                    if (LastDate < StartDate) then
                        CurrReport.Skip()
                    else begin
                        if (Employee."Date Of Leaving" <> 0D) then
                            if ((CalcDate('-10Y', Employee."Date Of Leaving")) < Employee."Date Of Join") then
                                CurrReport.Skip();
                    end;
                end;
                YearsInService := Format(HRDates.DetermineAge(Employee."Date Of Join", LastDate));

                /*if EarliestJoinDate1 = 0D then
                    EarliestJoinDate1 := CalcDate('-10Y', StartDate);
                if EarliestJoinDate2 = 0D then
                    EarliestJoinDate2 := CalcDate('-10Y', EndDate);

                if (EarliestJoinDate1 <> 0D) and (EarliestJoinDate2 <> 0D) and (StartDate <> 0D) and (EndDate <> 0D) and (Employee."Date Of Join" <> 0D) then begin
                    //if ((StartDate <= Employee."Date Of Join") and (EndDate >= Employee."Date Of Join") and (CalcDate('-10Y', EndDate) >= Employee."Date Of Join")) then
                    if ((EarliestJoinDate1 <= Employee."Date Of Join") and (EarliestJoinDate2 >= Employee."Date Of Join") and (CalcDate('-10Y', LastDate) >= Employee."Date Of Join")) then begin
                        if Employee."Date Of Leaving" = 0D then
                            LastDate := EndDate;
                        YearsInService := Format(HRDates.DetermineAge(Employee."Date Of Join", LastDate));
                    end
                    else
                        CurrReport.Skip();
                end else
                    CurrReport.Skip();*/

            end;

            trigger OnPreDataItem()
            begin
                if StartDate = 0D then
                    Error('You must select a start date!');
                if EndDate = 0D then
                    EndDate := CalcDate('CM', StartDate);
                EarliestJoinDate1 := CalcDate('-10Y', StartDate);
                EarliestJoinDate2 := CalcDate('-10Y', EndDate);
                Employee.SetFilter("Date Of Join", '%1..%2', EarliestJoinDate1, EarliestJoinDate2);
                CompanyInformation.Get;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                /*field("Payroll Period"; PayrollPeriod)
                {
                    TableRelation = "Payroll Period";
                }*/
                field("Start Date"; StartDate)
                {
                }
                field("End Date"; EndDate)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
        trigger OnOpenPage()
        begin
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                PayrollPeriod := Periods."Starting Date";
            StartDate := PayrollPeriod;
            EndDate := CalcDate('CM', StartDate);
        end;
    }
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        Movement: Record "Internal Employement History";
        PayrollPeriod: Date;
        StartDate: Date;
        EndDate: Date;
        Periods: Record "Payroll Period";
        PrevPeriod: Date;
        AssignmentMatrix: Record "Assignment Matrix";
        AssignmentMatrix2: Record "Assignment Matrix";
        YearsInService: Text[100];
        HRDates: Codeunit "HR Dates";
        EarliestJoinDate1: Date;
        EarliestJoinDate2: Date;
        LastDate: Date;
}