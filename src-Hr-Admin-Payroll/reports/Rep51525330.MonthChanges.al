report 51525330 "Month Changes"
{
    ApplicationArea = All;
    Caption = 'Month Changes';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/Month Changes.rdlc';
    dataset
    {
        dataitem(EmpMovement; "Internal Employement History")
        {
            DataItemTableView = SORTING("No.");// WHERE(Status = CONST(Active));
            RequestFilterFields = "No.", "Emp No.", Type;


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
            column(No; "Emp No.")
            {
            }
            column(EmpName; EmpName)
            {
            }
            column(DateOfJoin; Format("First Date", 0, '<Day,2>-<Month Text>-<year4>')/*"Date Of Join"*/)
            {
            }
            column(PayPeriod; uppercase(Format(PayrollPeriod, 0, '<Month Text>-<year4>')))
            {
            }
            column(From; From)
            { }
            column("To"; "To")
            { }
            column(ChangeType; ChangeType)
            { }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;
                //FirstDate := 0D;

                EmpRec.Reset();
                EmpRec.SetRange("No.", "Emp No.");
                if EmpRec.FindFirst() then
                    EmpName := EmpRec.FullName();

                ChangeType := Format(EmpMovement.Type);
                if (EmpMovement.Type = EmpMovement.Type::"August 2023") or (EmpMovement.Type = EmpMovement.Type::Initial) then
                    ChangeType := 'New Comer';
                if (EmpMovement.Type = EmpMovement.Type::Country) or (EmpMovement.Type = EmpMovement.Type::"Department/Section") or (EmpMovement.Type = EmpMovement.Type::Station) then
                    ChangeType := Format(EmpMovement.Type) + ' Transfer';

                //PrevPeriod := CalcDate('-1M', PayrollPeriod);
                /*Movement.Reset();
                Movement.SetRange("Emp No.", Employee."No.");
                Movement.SetFilter("First Date", '%1..%2', PrevPeriodPayrollPeriod, CalcDate('<CM>', PayrollPeriod));
                Movement.SetRange("Type", Movement."Type"::Initial);
                if Movement.FindFirst() then begin
                    FirstDate := Movement."First Date";

                    //If the person was paid last month, skip them
                    AssignmentMatrix.Reset();
                    AssignmentMatrix.SetRange("Employee No", Employee."No.");
                    AssignmentMatrix.SetRange("Payroll Period", PrevPeriod);
                    if AssignmentMatrix.FindFirst() then
                        CurrReport.Skip()
                    else begin
                        //If they were not paid last month but still this month they have NOT been paid, skip (this way, if you join in Nov 27th you'll only appear in Dec, not in both Nov and Dec)
                        AssignmentMatrix2.Reset();
                        AssignmentMatrix2.SetRange("Employee No", Employee."No.");
                        AssignmentMatrix2.SetRange("Payroll Period", PayrollPeriod);
                        if not AssignmentMatrix2.FindFirst() then
                            CurrReport.Skip()
                    end;
                end else
                CurrReport.Skip();*/

            end;

            trigger OnPreDataItem()
            begin
                if PayrollPeriod = 0D then
                    Error('You must select the payroll month!');
                EmpMovement.SetFilter("First Date", '%1..%2', PayrollPeriod, CalcDate('<CM>', PayrollPeriod));
                //if AllChanges then
                //EmpMovement.SetFilter(Type, '%1|%2|%3|%4|%5|%6|%7|%8', EmpMovement.Type::"August 2023", EmpMovement.Type::Country, EmpMovement.Type::Demotion, EmpMovement.Type::"Department/Section", EmpMovement.Type::Initial, EmpMovement.Type::Promotion, EmpMovement.Type::"Salary Adjustment", EmpMovement.Type::Station);
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
                /*field("Show All Changes"; AllChanges)
                {
                }*/
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
        FirstDate: Date;
        Periods: Record "Payroll Period";
        PrevPeriod: Date;
        AssignmentMatrix: Record "Assignment Matrix";
        AssignmentMatrix2: Record "Assignment Matrix";
        From: Text;
        "To": Text;
        ChangeType: Text;
        EmpName: Text;
        EmpRec: Record Employee;
        AllChanges: Boolean;
}