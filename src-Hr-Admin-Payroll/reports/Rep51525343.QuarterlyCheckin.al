report 51525343 "Quarterly Checkin"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/QuarterlyCheckin.rdlc';
    Caption = 'Mid Year Checkin';

    dataset
    {
        dataitem("Mid Year Appraisal"; "Mid Year Appraisal")
        {
            RequestFilterFields = Period, "Staff No";
            column(DateTimeSentForApproval_MidYearAppraisal; "Mid Year Appraisal"."Date-Time Sent For Approval")
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
            column(Date_MidYearAppraisal; "Mid Year Appraisal".Date)
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
            column(CompName; CompInfo.Name)
            {
            }
            column(DateTimeApproved_MidYearAppraisal; "Mid Year Appraisal"."Date-Time Approved")
            {
            }
            column(CompPict; CompInfo.Picture)
            {
            }
            column(EmployeeSignature; EmpUserSetup.Signature)
            {
            }
            column(SupervisorSignature; SupervisorUserSetup.Signature)
            {
            }
            column(EmployeeJobTitle; EmployeeJobTitle)
            {
            }
            column(SupervisorJobTitle; SupervisorJobTitle)
            {
            }
            column(SupervisorLocation; SupervisorLocation)
            {
            }
            column(SupervisorDept; SupervisorDept)
            {
            }
            dataitem("MidYear Appraisal Lines"; "MidYear Appraisal Lines")
            {
                DataItemLink = "Doc No" = FIELD(No);
                column(DocNo_MidYearAppraisalLines; "MidYear Appraisal Lines"."Doc No")
                {
                }
                column(EntryNo_MidYearAppraisalLines; "MidYear Appraisal Lines"."Entry No")
                {
                }
                column(Type_MidYearAppraisalLines; "MidYear Appraisal Lines".Type)
                {
                }
                column(SectionNo_MidYearAppraisalLines; "MidYear Appraisal Lines"."Section No")
                {
                }
                column(ItemsDescription_MidYearAppraisalLines; "MidYear Appraisal Lines"."Items/Description")
                {
                }
                column(StaffComments_MidYearAppraisalLines; "MidYear Appraisal Lines"."Staff Comments")
                {
                }
                column(SuccessMeasure_MidYearAppraisalLines; "MidYear Appraisal Lines"."Success Measure")
                {
                }
                column(SupervisorComments_MidYearAppraisalLines; "MidYear Appraisal Lines"."Supervisor Comments")
                {
                }
                column(BigDescriptionPlanText; BigDescriptionPlanText)
                {
                }
                column(BigSuccessMeasurePlanText; BigSuccessMeasurePlanText)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //MESSAGE('%1',"Mid Year Appraisal"."Supervisor Comments");
                    Clear(BigDescriptionPlanText);
                    CalcFields("Big Items/Description");
                    if "Big Items/Description".HasValue then begin
                        "Big Items/Description".CreateInStream(Streamin);
                        Streamin.Read(BigDescriptionPlanText);
                        // MESSAGE(BigSpecificActionPlanText);
                    end;

                    Clear(BigSuccessMeasurePlanText);
                    CalcFields("Big Success Measure");
                    if "Big Success Measure".HasValue then begin
                        "Big Success Measure".CreateInStream(Streamin2);
                        Streamin2.Read(BigSuccessMeasurePlanText);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                EmpUserSetup.Reset;
                EmpUserSetup.SetRange("Employee No.", "Mid Year Appraisal"."Staff No");
                if EmpUserSetup.FindFirst then
                    EmpUserSetup.CalcFields(Signature);

                SupervisorUserSetup.Reset;
                SupervisorUserSetup.SetRange("Employee No.", "Mid Year Appraisal".Supervisor);
                if SupervisorUserSetup.FindFirst then begin
                    SupervisorUserSetup.CalcFields(Signature);

                    Employee.Reset;
                    //Employee.SETFILTER("No.",'%1|%2',"Staff Appraisal Header"."Staff No","Staff Appraisal Header".Supervisor);
                    Employee.SetRange("No.", "Mid Year Appraisal".Supervisor);
                    if Employee.FindFirst/*.FINDSET*/ then begin
                        //REPEAT
                        /*IF Employee."No." = "Staff Appraisal Header"."Staff No" THEN
                          EmployeeJobTitle := Employee."Job Title";*/
                        if Employee."No." = "Mid Year Appraisal".Supervisor then begin
                            SupervisorJobTitle := Employee."Job Title";

                            Locations.Reset;
                            Locations.SetRange(Code, Employee."Location Code");
                            if Locations.FindFirst then
                                SupervisorLocation := Locations.Name;

                            DimVal.Reset;
                            DimVal.SetRange(Code, Employee."Global Dimension 2 Code");
                            if DimVal.FindFirst then
                                SupervisorDept := DimVal.Name;
                        end;
                        //UNTIL Employee.NEXT = 0;
                    end;
                end;

                EmployeeJobTitle := '';
                SupervisorJobTitle := ''; //AssessorDepartment := '';
                Employee.Reset;
                Employee.SetFilter("No.", '%1|%2', "Mid Year Appraisal"."Staff No", "Mid Year Appraisal".Supervisor);
                if Employee.FindSet then begin
                    repeat
                        if Employee."No." = "Mid Year Appraisal"."Staff No" then
                            EmployeeJobTitle := Employee."Job Title";
                        if Employee."No." = "Mid Year Appraisal".Supervisor then
                            SupervisorJobTitle := Employee."Job Title";
                    until Employee.Next = 0;
                end;

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

    trigger OnInitReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        EmpUserSetup: Record "User Setup";
        SupervisorUserSetup: Record "User Setup";
        EmployeeJobTitle: Text[50];
        SupervisorJobTitle: Text[50];
        Employee: Record Employee;
        Locations: Record Location;
        SupervisorDept: Text[50];
        DimVal: Record "Dimension Value";
        SupervisorLocation: Text[100];
        BigDescriptionPlanText: Text;
        BigSuccessMeasurePlanText: Text;
        Streamin: InStream;
        Streamin2: InStream;
}