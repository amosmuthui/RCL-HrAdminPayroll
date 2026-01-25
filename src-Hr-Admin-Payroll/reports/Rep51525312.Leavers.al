report 51525312 Leavers
{
    ApplicationArea = All;
    Caption = 'Leavers';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/Leavers.rdlc';
    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");// WHERE(Status = CONST(Inactive));
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
            column(ContractualAmountType; "Contractual Amount Type")
            {
            }
            column(ContractualAmountCurrency; "Contractual Amount Currency")
            {
            }
            column(DateOfLeaving; Format(EffectiveDate, 0, '<Day,2>-<Month Text>-<year4>')/*"Date Of Join"*/)
            {
            }
            column(PayPeriod; UpperCase(Format(PayrollPeriod, 0, '<Month Text>-<year4>')))
            {
            }
            column(InactiveStatus; InactiveStatus)
            { }
            column(Job_Title; "Job Title")
            { }
            column(Department; Department)
            { }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;
                EffectiveDate := 0D;
                Department := '';

                if PayrollPeriod <= 20250501D then begin //Up to May 2025
                    Movement.Reset();
                    Movement.SetRange("Emp No.", Employee."No.");
                    Movement.SetRange(Status, Movement.Status::Current);
                    Movement.SetFilter("Last Date", '%1..%2', /*PayrollPeriod*/PrevPeriod, CalcDate('<CM>', PrevPeriod/*PayrollPeriod*/)); //You are a leaver this month if you were last paid last month
                    if Movement.FindLast() then begin
                        Department := Movement."Department Name";
                        if Department = '' then
                            Department := Movement."Dept Code";
                        EffectiveDate := Movement."Last Date";
                        InactiveStatus := Employee."Cause of Inactivity";
                    end else
                        CurrReport.Skip();
                end;

                //if PayrollPeriod = 20250601D then begin //June 2025
                if PayrollPeriod >= 20250601D then begin //June 2025 ++
                    Movement.Reset();
                    Movement.SetRange("Emp No.", Employee."No.");
                    Movement.SetRange(Status, Movement.Status::Current);
                    Movement.SetFilter("Last Date", '%1..%2', PrevPeriod, CalcDate('<CM>', PayrollPeriod)); //Left either in May or June
                    if Movement.FindLast() then begin
                        Department := Movement."Department Name";
                        if Department = '' then
                            Department := Movement."Dept Code";
                        EffectiveDate := Movement."Last Date";
                        InactiveStatus := Employee."Cause of Inactivity";

                        //If you were paid anything this month, you'll appear next month
                        Assignmatrix.RESET;
                        Assignmatrix.SETRANGE("Employee No", Employee."No.");
                        Assignmatrix.SETRANGE("Payroll Period", PayrollPeriod);
                        Assignmatrix.SetRange("Exclude from Payroll", false);
                        if Assignmatrix.FindFirst() then
                            CurrReport.Skip();

                        if EffectiveDate < PayrollPeriod then begin
                            //If they left last month and they were not paid anything that month, then we already reported them last month
                            Assignmatrix.RESET;
                            Assignmatrix.SETRANGE("Employee No", Employee."No.");
                            Assignmatrix.SETRANGE("Payroll Period", PrevPeriod);
                            Assignmatrix.SetRange("Exclude from Payroll", false);
                            if not Assignmatrix.FindFirst() then
                                if (Movement."Payroll Country" <> 'RISHWORTH') then//Except rishworth, not paid in system
                                    CurrReport.Skip();
                        end;

                    end else
                        CurrReport.Skip();
                end;

                /*if PayrollPeriod >= 20250701D then begin //July 2025 going forwward
                    Movement.Reset();
                    Movement.SetRange("Emp No.", Employee."No.");
                    Movement.SetRange(Status, Movement.Status::Current);
                    Movement.SetFilter("Last Date", '%1..%2', PayrollPeriod, CalcDate('<CM>', PayrollPeriod)); //Only people who left that month
                    if Movement.FindLast() then begin
                        Department := Movement."Department Name";
                        if Department = '' then
                            Department := Movement."Dept Code";
                        EffectiveDate := Movement."Last Date";
                        InactiveStatus := Employee."Cause of Inactivity";
                    end else
                        CurrReport.Skip();
                end;*/

            end;

            trigger OnPreDataItem()
            begin
                if PayrollPeriod = 0D then
                    Error('You must select the payroll period!');
                PrevPeriod := CalcDate('-1M', PayrollPeriod);
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
                field("Payroll Period"; PayrollPeriod)
                {
                    TableRelation = "Payroll Period";
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
        end;
    }
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        Movement: Record "Internal Employement History";
        PayrollPeriod: Date;
        EffectiveDate: Date;
        InactiveStatus: Text[250];
        Periods: Record "Payroll Period";
        PrevPeriod: Date;
        Department: Text;
        Assignmatrix: Record "Assignment Matrix";
}