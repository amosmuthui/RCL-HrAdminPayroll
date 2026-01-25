report 51525341 "Employees mid year status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/Employeesmidyearstatus.rdlc';

    dataset
    {
        dataitem("Mid Year Appraisal"; "Mid Year Appraisal")
        {
            column(CompPic; CompInfo.Picture)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            column(Company_Address; Company.Address)
            {
            }
            column(Company_Address_2; Company."Address 2")
            {
            }
            column(Company_Phone_No; Company."Phone No.")
            {
            }
            column(Company_Fax_No; Company."Fax No.")
            {
            }
            column(Company_Picture; Company.Picture)
            {
            }
            column(Company_Email; Company."E-Mail")
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(No_MidYearAppraisal; "Mid Year Appraisal".No)
            {
            }
            column(StaffNo_MidYearAppraisal; "Mid Year Appraisal"."Staff No")
            {
            }
            column(StaffName_MidYearAppraisal; "Mid Year Appraisal"."Staff Name")
            {
            }
            column(Directorate_MidYearAppraisal; "Mid Year Appraisal".Directorate)
            {
            }
            column(Department_MidYearAppraisal; "Mid Year Appraisal".Department)
            {
            }
            column(Period_MidYearAppraisal; "Mid Year Appraisal".Period)
            {
            }
            column(CreatedOn_MidYearAppraisal; "Mid Year Appraisal"."Created On")
            {
            }
            column(CreatedBy_MidYearAppraisal; "Mid Year Appraisal"."Created By")
            {
            }
            column(Supervisor_MidYearAppraisal; "Mid Year Appraisal".Supervisor)
            {
            }
            column(SupervisorName_MidYearAppraisal; "Mid Year Appraisal"."Supervisor Name")
            {
            }
            column(PeriodDesc_MidYearAppraisal; "Mid Year Appraisal"."Period Desc")
            {
            }
            column(Designation_MidYearAppraisal; "Mid Year Appraisal".Designation)
            {
            }
            column(SenttoSupervisor_MidYearAppraisal; "Mid Year Appraisal"."Sent to Supervisor")
            {
            }
            column(ApprovedBySupervisor_MidYearAppraisal; "Mid Year Appraisal"."Approved By Supervisor")
            {
            }
            column(EmployeeComments_MidYearAppraisal; "Mid Year Appraisal"."Employee Comments")
            {
            }
            column(SupervisorComments_MidYearAppraisal; "Mid Year Appraisal"."Supervisor Comments")
            {
            }
            column(Date_MidYearAppraisal; "Mid Year Appraisal".Date)
            {
            }
            column(Status_MidYearAppraisal; "Mid Year Appraisal".Status)
            {
            }
            column(DateTimeSentForApproval_MidYearAppraisal; "Mid Year Appraisal"."Date-Time Sent For Approval")
            {
            }
            column(DateTimeApproved_MidYearAppraisal; "Mid Year Appraisal"."Date-Time Approved")
            {
            }
            column(SupervisorRejectionComments_MidYearAppraisal; "Mid Year Appraisal"."Supervisor Rejection Comments")
            {
            }
            column(Status; StatusFilter)
            {
            }
            column(ContractType; ContractType)
            {
            }
            column(JobTitle; JobTitle)
            {
            }
            column(Department; Department)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ContractType);
                Clear(JobTitle);
                Clear(Department);
                Clear(IsMarked);
                Employees.Reset;
                Employees.SetFilter("No.", "Staff No");
                if Employees.FindFirst then begin
                    ContractType := Employees."Contract Type";
                    JobTitle := Employees."Job Title";
                    Department := Employees."Global Dimension 2 Code";
                    ContractType := Employees."Contract Type";
                end;

                if EmployeeStatus then begin
                    if ("Mid Year Appraisal"."Sent to Supervisor" = false) and ("Mid Year Appraisal"."Approved By Supervisor" = false) then
                        IsMarked := true;
                end;
                if ApprovedStatus then begin
                    if ("Mid Year Appraisal"."Sent to Supervisor" = true) and ("Mid Year Appraisal"."Approved By Supervisor" = true) then
                        IsMarked := true;
                end;
                if SuperVisorStatus then begin
                    if ("Mid Year Appraisal"."Sent to Supervisor" = true) and ("Mid Year Appraisal"."Approved By Supervisor" = false) then
                        IsMarked := true;
                end;

                if (not SuperVisorStatus) and (not EmployeeStatus) and (not EmployeeStatus) then
                    IsMarked := true;

                if not IsMarked then
                    CurrReport.Skip;

                if (not "Sent to Supervisor") and (not "Approved By Supervisor") then
                    StatusFilter := StatusFilter::Employee;
                if ("Sent to Supervisor") and (not "Approved By Supervisor") then
                    StatusFilter := StatusFilter::Supervisor;
                if ("Sent to Supervisor") and ("Approved By Supervisor") then
                    StatusFilter := StatusFilter::Approved;
            end;

            trigger OnPreDataItem()
            begin
                Company.Get;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(StatusFilter)
                {
                    field(Employee; EmployeeStatus)
                    {
                        Caption = 'Employee';
                        MultiLine = true;
                    }
                    field(SuperVisor; SuperVisorStatus)
                    {
                    }
                    field(Approved; ApprovedStatus)
                    {
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        Employees: Record Employee;
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        Company: Record "Company Information";
        SupervisorName: Text;
        ContractType: Text;
        Status: Option ,Employee,Supervisor,Approved;
        StatusFilter: Option ,Employee,Supervisor,Approved;
        JobTitle: Text;
        EmployeeStatus: Boolean;
        SuperVisorStatus: Boolean;
        ApprovedStatus: Boolean;
        Department: Text;
        StaffTargetObjectives: Record "Staff Target Objectives";
        IsMarked: Boolean;
        CompanyJobsRec: Record "Company Jobs";
}