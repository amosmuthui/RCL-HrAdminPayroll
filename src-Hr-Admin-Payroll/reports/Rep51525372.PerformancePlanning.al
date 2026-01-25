report 51525372 "Performance Planning"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/PerformancePlanning.rdlc';

    dataset
    {
        dataitem("Staff Target Objectives"; "Staff Target Objectives")
        {
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
            column(CompName; CompInfo.Name)
            {
            }
            column(CompPict; CompInfo.Picture)
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
            column(EmployeeSignature; EmpUserSetup.Signature)
            {
            }
            column(SupervisorSignature; SupervisorUserSetup.Signature)
            {
            }
            column(SupervisorJobTitle; SupervisorJobTitle)
            {
            }
            column(ApprovedBySupervisor; "Staff Target Objectives"."Approved By Supervisor")
            {
            }
            column(SenttoSupervisor; "Staff Target Objectives"."Sent to Supervisor")
            {
            }
            column(SupervisorLocation; SupervisorLocation)
            {
            }
            column(SupervisorDept; SupervisorDept)
            {
            }
            column(DateTime_Submitted; "DateTime Submitted")
            { }
            column(DateTime_Approved; "DateTime Approved")
            { }
            dataitem("Staff Target Lines"; "Staff Target Lines")
            {
                DataItemLink = "Doc No" = FIELD(No);//, //"Staff No" = FIELD("Staff No"), Period = FIELD(Period);
                column(No_StaffTargetLines; "Staff Target Lines".No)
                {
                }
                column(ObjectiveCode_StaffTargetLines; "Staff Target Lines"."Objective Code")
                {
                }
                column(Objective_StaffTargetLines; "Staff Target Lines".Objective)
                {
                }
                column(SuccessMeasure_StaffTargetLines; "Staff Target Lines"."Success Measure")
                {
                }
                column(DueDate_StaffTargetLines; "Staff Target Lines"."Due Date")
                {
                }
                column(StaffNo_StaffTargetLines; "Staff Target Lines"."Staff No")
                {
                }
                column(DocNo_StaffTargetLines; "Staff Target Lines"."Doc No")
                {
                }
                column(Period_StaffTargetLines; "Staff Target Lines".Period)
                {
                }
                column(SpecificActionPlan_StaffTargetLines; "Staff Target Lines"."Specific Action Plan")
                {
                }
                column(DueDateDescription_StaffTargetLines; "Staff Target Lines"."Due Date Description")
                {
                }
                column(BigSpecificActionPlanText; BigSpecificActionPlanText)
                {
                }
                column(BigSuccessMeasurePlanText; BigSuccessMeasurePlanText)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //Read text
                    Clear(BigSpecificActionPlanText);
                    CalcFields("Big Specific Action Plan");
                    if "Big Specific Action Plan".HasValue then begin
                        "Big Specific Action Plan".CreateInStream(Streamin);
                        Streamin.Read(BigSpecificActionPlanText);
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
                EmpUserSetup.SetRange("Employee No.", "Staff Target Objectives"."Staff No");
                if EmpUserSetup.FindFirst then begin

                    EmpUserSetup.CalcFields(Signature);
                    // ERROR('%1',EmpUserSetup.Signature.HASVALUE);
                    /*BEGIN
                      IF "Staff Target Objectives"."Sent to Supervisor" THEN
                      EmpUserSetup.CALCFIELDS(Signature);
                    END;*/
                end;
                SupervisorUserSetup.Reset;
                SupervisorUserSetup.SetRange("Employee No.", "Staff Target Objectives".Supervisor);
                if SupervisorUserSetup.FindFirst() then begin
                    SupervisorUserSetup.CalcFields(Signature);

                    Employee.Reset;
                    //Employee.SETFILTER("No.",'%1|%2',"Staff Appraisal Header"."Staff No","Staff Appraisal Header".Supervisor);
                    Employee.SetRange("No.", "Staff Target Objectives".Supervisor);
                    if Employee.FindFirst/*.FINDSET*/ then begin
                        //REPEAT
                        /*IF Employee."No." = "Staff Appraisal Header"."Staff No" THEN
                          EmployeeJobTitle := Employee."Job Title";*/
                        if Employee."No." = "Staff Target Objectives".Supervisor then begin
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
        SupervisorJobTitle: Text[50];
        Employee: Record Employee;
        SupervisorLocation: Text[100];
        Locations: Record Location;
        SupervisorDept: Text[50];
        DimVal: Record "Dimension Value";
        Streamin: InStream;
        BigSpecificActionPlanText: Text;
        BigSuccessMeasurePlanText: Text;
        Streamin2: InStream;
        HrLeavePeriods: Record "HR Appraisal Periods";
}