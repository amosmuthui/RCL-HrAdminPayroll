report 51525369 "Staff Targets Count"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/StaffTargetsCount.rdlc';

    dataset
    {
        dataitem("Staff Target Objectives"; "Staff Target Objectives")
        {
            RequestFilterFields = No, "Staff No", Period;
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
            column(logo; Company.Picture)
            {
            }
            column(ApprovalStatus; ApprovalStatus)
            {
            }
            column(i; i)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not CompanyDataCaptured then
                    CompanyDataCaptured := true
                else
                    Clear(Company.Picture);

                ApprovalStatus := 'Open';
                if ("Staff Target Objectives"."Sent to Supervisor") and (not "Staff Target Objectives"."Approved By Supervisor") then
                    ApprovalStatus := 'Pending Approval';
                if "Staff Target Objectives"."Approved By Supervisor" then
                    ApprovalStatus := 'Approved';
                i := 1;
            end;

            trigger OnPreDataItem()
            begin
                Company.Reset;
                Company.CalcFields(Picture);

                if SelectedApprovalStatus = SelectedApprovalStatus::Open then begin
                    "Staff Target Objectives".SetRange("Sent to Supervisor", false);
                    "Staff Target Objectives".SetRange("Approved By Supervisor", false);
                end;
                if SelectedApprovalStatus = SelectedApprovalStatus::"Pending Approval" then begin
                    "Staff Target Objectives".SetRange("Sent to Supervisor", true);
                    "Staff Target Objectives".SetRange("Approved By Supervisor", false);
                end;
                if SelectedApprovalStatus = SelectedApprovalStatus::Approved then begin
                    "Staff Target Objectives".SetRange("Approved By Supervisor", true);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SelectedApprovalStatus; SelectedApprovalStatus)
                {
                    Caption = 'Select Status';
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

    var
        Company: Record "Company Information";
        CompanyDataCaptured: Boolean;
        ApprovalStatus: Text[20];
        i: Integer;
        SelectedApprovalStatus: Option All,Open,"Pending Approval",Approved;
}