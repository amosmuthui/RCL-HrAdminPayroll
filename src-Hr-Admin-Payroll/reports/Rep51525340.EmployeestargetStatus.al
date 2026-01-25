report 51525340 "Employees target Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/EmployeestargetStatus.rdlc';

    dataset
    {
        dataitem("Staff Target Objectives"; "Staff Target Objectives")
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
            column(No_StaffTargetObjectives; "Staff Target Objectives".No)
            {
            }
            column(StaffNo_StaffTargetObjectives; "Staff Target Objectives"."Staff No")
            {
            }
            column(StaffName_StaffTargetObjectives; "Staff Target Objectives"."Staff Name")
            {
            }
            column(Directorate_StaffTargetObjectives; "Staff Target Objectives".Directorate)
            {
            }
            column(Department_StaffTargetObjectives; "Staff Target Objectives".Department)
            {
            }
            column(Period_StaffTargetObjectives; "Staff Target Objectives".Period)
            {
            }
            column(CreatedOn_StaffTargetObjectives; "Staff Target Objectives"."Created On")
            {
            }
            column(CreatedBy_StaffTargetObjectives; "Staff Target Objectives"."Created By")
            {
            }
            column(Supervisor_StaffTargetObjectives; "Staff Target Objectives".Supervisor)
            {
            }
            column(SupervisorName_StaffTargetObjectives; "Staff Target Objectives"."Supervisor Name")
            {
            }
            column(PeriodDesc_StaffTargetObjectives; "Staff Target Objectives"."Period Desc")
            {
            }
            column(Designation_StaffTargetObjectives; "Staff Target Objectives".Designation)
            {
            }
            column(SenttoSupervisor_StaffTargetObjectives; "Staff Target Objectives"."Sent to Supervisor")
            {
            }
            column(ApprovedBySupervisor_StaffTargetObjectives; "Staff Target Objectives"."Approved By Supervisor")
            {
            }
            column(SupervisiorComment_StaffTargetObjectives; "Staff Target Objectives".SupervisiorComment)
            {
            }
            column(Status; Status)
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
                    if ("Staff Target Objectives"."Sent to Supervisor" = false) and ("Staff Target Objectives"."Approved By Supervisor" = false) then
                        //"Staff Target Objectives".MARK(TRUE);
                        IsMarked := true;
                end;
                if ApprovedStatus then begin
                    if ("Staff Target Objectives"."Sent to Supervisor" = true) and ("Staff Target Objectives"."Approved By Supervisor" = true) then
                        //"Staff Target Objectives".MARK(TRUE);
                        IsMarked := true;
                end;
                if SuperVisorStatus then begin
                    if ("Staff Target Objectives"."Sent to Supervisor" = true) and ("Staff Target Objectives"."Approved By Supervisor" = false) then
                        //"Staff Target Objectives".MARK(TRUE);
                        IsMarked := true;
                end;

                if (not SuperVisorStatus) and (not EmployeeStatus) and (not EmployeeStatus) then
                    IsMarked := true;

                if not IsMarked then
                    CurrReport.Skip;

                if (not "Sent to Supervisor") and (not "Approved By Supervisor") then
                    Status := Status::Employee;
                if ("Sent to Supervisor") and (not "Approved By Supervisor") then
                    Status := Status::Supervisor;
                if ("Sent to Supervisor") and ("Approved By Supervisor") then
                    Status := Status::Approved;

                //"Staff Target Objectives".MARKEDONLY
            end;

            trigger OnPostDataItem()
            begin
                "Staff Target Objectives".MarkedOnly(true);
            end;

            trigger OnPreDataItem()
            begin
                Company.Get;

                // IF EmployeeStatus THEN BEGIN
                //  "Staff Target Objectives".SETRANGE("Sent to Supervisor", FALSE);
                //  "Staff Target Objectives".SETRANGE("Approved By Supervisor", FALSE);
                // END;
                // IF ApprovedStatus THEN BEGIN
                //  "Staff Target Objectives".SETRANGE("Sent to Supervisor", TRUE);
                //  "Staff Target Objectives".SETRANGE("Approved By Supervisor", TRUE);
                // END;
                // IF SuperVisorStatus THEN BEGIN
                //  "Staff Target Objectives".SETRANGE("Sent to Supervisor", TRUE);
                //  "Staff Target Objectives".SETRANGE("Approved By Supervisor", FALSE);
                // END;
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
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        Company: Record "Company Information";
        SupervisorName: Text;
        ContractType: Text;
        Status: Option Employee,Supervisor,Approved;
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