report 51525317 "Departmental Status Report"
{
    ApplicationArea = All;
    Caption = 'Departmental Status Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/DepartmentalStatusReport.rdlc';
    dataset
    {
        dataitem(PeriodDepartmentSections; "Period Department Sections")
        {
            RequestFilterFields = "Payroll Period", "Section Code", "Department Code";


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
            column(SectionCode; "Section Code")
            {
            }
            column(SectionName; "Section Name")
            {
            }
            column(DepartmentCode; "Department Code")
            {
            }
            column(DepartmentName; "Department Name")
            {
            }
            column(PayrollPeriod; "Payroll Period")
            {
            }
            column(SectionTotal; SectionTotal)
            {
            }
            column(ReportTitle; UpperCase('STAFF STATUS REPORT FOR ' + Format("Payroll Period", 0, '<Month Text> <Year4>')))
            {
            }
            column(LocalExpats; LocalExpats)
            {
            }
            column(Others; Others)
            {
            }
            column(Combined; Combined)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;

                SectionTotal := 0;
                LocalExpats := 0;
                Others := 0;
                Combined := 0;
                PeriodMovements.Reset();
                PeriodMovements.SetRange("Payroll Period", PeriodDepartmentSections."Payroll Period");
                PeriodMovements.SetRange("Section Code", PeriodDepartmentSections."Section Code");
                PeriodMovements.SetRange("Dept Code", PeriodDepartmentSections."Department Code");
                if PeriodMovements.FindSet() then
                    repeat
                        SectionTotal += 1;//PeriodMovements.Count;
                        Combined += 1;
                        if (PeriodMovements."Payroll Country" = 'RWANDA') or (PeriodMovements."Payroll Country" = 'EXPATRIATE') then
                            LocalExpats += 1
                        else
                            Others += 1;
                    until PeriodMovements.Next() = 0;
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
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        PeriodMovements: Record "Period Prevailing Movement";
        SectionTotal: Integer;
        LocalExpats: Integer;
        Others: Integer;
        Combined: Integer;
}
