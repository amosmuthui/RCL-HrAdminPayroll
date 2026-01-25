report 51525315 "Gender Report"
{
    ApplicationArea = All;
    Caption = 'Gender Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/reports/layouts/GenderReport.rdlc';
    dataset
    {
        dataitem(CountryRegion; "Country/Region")
        {
            RequestFilterFields = Code;

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
            column(Code; "Code")
            {
            }
            column(Name; Name)
            {
            }
            column(Males; Males)
            {
            }
            column(Females; Females)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;

                Males := 0;
                Females := 0;

                EmployeeRec.Reset();
                EmployeeRec.SetRange("Workstation Country", Code);
                if EmployeeRec.FindSet() then
                    repeat
                        if EmployeeRec.Gender = EmployeeRec.Gender::Male then
                            Males += 1;
                        if EmployeeRec.Gender = EmployeeRec.Gender::Female then
                            Females += 1;
                    until EmployeeRec.Next() = 0;

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
            area(content)
            {
                group(GroupName)
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
    }
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        Males: Integer;
        Females: Integer;
        EmployeeRec: Record Employee;
}