report 51525302 "Staff Leave Awaiting Approval"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/StaffLeaveAwaitingApproval.rdlc';

    dataset
    {
        dataitem("Employee Leave Application"; "Employee Leave Application")
        {
            DataItemTableView = WHERE(Status = FILTER("Pending Approval"));
            column(EmpNo; "Employee Leave Application"."Employee No")
            {
            }
            column(DayaApplied; "Employee Leave Application"."Days Applied")
            {
            }
            column(StartDate; "Employee Leave Application"."Start Date")
            {
            }
            column(EndDate; "Employee Leave Application"."End Date")
            {
            }
            column(LeaveStatus; "Employee Leave Application"."Leave Status")
            {
            }
            column(Taken; "Employee Leave Application".Taken)
            {
            }
            column(EmployeeName; "Employee Leave Application"."Employee Name")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(ApprovedDays; "Employee Leave Application"."Approved Days")
            {
            }
            column(ApprovedStartDate; "Employee Leave Application"."Approved Start Date")
            {
            }
            column(ApprovedEndDate; "Employee Leave Application"."Approved End Date")
            {
            }
            column(LeaveCode; "Employee Leave Application"."Leave Type")
            {
            }
            column(Approver_EmployeeLeaveApplication; "Employee Leave Application".Approver)
            {
            }

            trigger OnAfterGetRecord()
            begin
                i := i + 1;
                if i > 1 then
                    Clear(CompanyInfo.Picture);
            end;

            trigger OnPreDataItem()
            begin
                i := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        i: Integer;
}