report 51525342 "Appraisal Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/AppraisalReport.rdlc';

    dataset
    {
        dataitem("Staff Appraisal Header"; "Staff Appraisal Header")
        {
            RequestFilterFields = Period, "Staff No";
            column(No_StaffAppraisalHeader; "Staff Appraisal Header".No)
            {
            }
            column(StaffNo_StaffAppraisalHeader; "Staff Appraisal Header"."Staff No")
            {
            }
            column(StaffName_StaffAppraisalHeader; "Staff Appraisal Header"."Staff Name")
            {
            }
            column(Directorate_StaffAppraisalHeader; "Staff Appraisal Header".Directorate)
            {
            }
            column(Department_StaffAppraisalHeader; "Staff Appraisal Header".Department)
            {
            }
            column(Period_StaffAppraisalHeader; "Staff Appraisal Header".Period)
            {
            }
            column(CreatedOn_StaffAppraisalHeader; "Staff Appraisal Header"."Created On")
            {
            }
            column(CreatedBy_StaffAppraisalHeader; "Staff Appraisal Header"."Created By")
            {
            }
            column(Supervisor_StaffAppraisalHeader; "Staff Appraisal Header".Supervisor)
            {
            }
            column(SupervisorName_StaffAppraisalHeader; "Staff Appraisal Header"."Supervisor Name")
            {
            }
            column(PeriodDesc_StaffAppraisalHeader; "Staff Appraisal Header"."Period Desc")
            {
            }
            column(Designation_StaffAppraisalHeader; "Staff Appraisal Header".Designation)
            {
            }
            column(SenttoSupervisor_StaffAppraisalHeader; "Staff Appraisal Header"."Sent to Supervisor")
            {
            }
            column(ApprovedBySupervisor_StaffAppraisalHeader; "Staff Appraisal Header"."Approved By Supervisor")
            {
            }
            column(Type_StaffAppraisalHeader; "Staff Appraisal Header".Type)
            {
            }
            column(CompName; CompInfo.Name)
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
            column(SupervisorJobTitle; SupervisorJobTitle)
            {
            }
            column(SupervisorLocation; SupervisorLocation)
            {
            }
            column(SupervisorDept; SupervisorDept)
            {
            }
            column(ObjectivesSectionRatingTotal; ObjectivesSectionRatingTotal)
            {
            }
            column(Section1Score; Section1Score)
            {
            }
            column(ManagementSectionRatingTotal; ManagementSectionRatingTotal)
            {
            }
            column(KnowledgeSectionRatingTotal; KnowledgeSectionRatingTotal)
            {
            }
            column(ProblemSectionRatingTotal; ProblemSectionRatingTotal)
            {
            }
            column(CommsSectionRatingTotal; CommsSectionRatingTotal)
            {
            }
            column(Section2Score; Section2Score)
            {
            }
            column(Overall_Score___; "Staff Appraisal Header"."Overall Score(%)")
            { }
            dataitem("Staff Appraisal Lines"; "Staff Appraisal Lines")
            {
                DataItemLink = "Doc No" = FIELD(No), "Staff No" = FIELD("Staff No");
                column(DocNo_StaffAppraisalLines; "Staff Appraisal Lines"."Doc No")
                {
                }
                column(EntryNo_StaffAppraisalLines; "Staff Appraisal Lines"."Entry No")
                {
                }
                column(Type_StaffAppraisalLines; "Staff Appraisal Lines".Type)
                {
                }
                column(Rate_StaffAppraisalLines; "Staff Appraisal Lines".Rate)
                {
                }
                column(Remarks_StaffAppraisalLines; "Staff Appraisal Lines".Remarks)
                {
                }
                column(ObjectiveCode_StaffAppraisalLines; "Staff Appraisal Lines"."Objective Code")
                {
                }
                column(Objective_StaffAppraisalLines; "Staff Appraisal Lines".Objective)
                {
                }
                column(Employees_Remarks_StaffAppraisalLines; "Employees Remarks")
                { }
                column(SupervisorRemarks_StaffAppraisalLines; "Staff Appraisal Lines"."Supervisor Remarks")
                {
                }
                column(SupervisorRate_StaffAppraisalLines; "Staff Appraisal Lines"."Supervisor Rate")
                {
                }
                column(StaffNo_StaffAppraisalLines; "Staff Appraisal Lines"."Staff No")
                {
                }
                column(SuccessMeasure_StaffAppraisalLines; "Staff Appraisal Lines"."Success Measure")
                {
                }
                column(DueDate_StaffAppraisalLines; "Staff Appraisal Lines"."Due Date")
                {
                }
                column(SectionRating_StaffAppraisalLines; "Staff Appraisal Lines"."Section Rating")
                {
                }
                column(AppraiseeRemarks_StaffAppraisalLines; "Staff Appraisal Lines"."Appraisee Remarks")
                {
                }
                column(AppraiseeRate_StaffAppraisalLines; "Staff Appraisal Lines"."Appraisee Rate")
                {
                }
                column(Peer1Feedback_StaffAppraisalLines; "Staff Appraisal Lines"."Peer 1 Feedback")
                {
                }
                column(Peer2Feedback_StaffAppraisalLines; "Staff Appraisal Lines"."Peer 2 Feedback")
                {
                }
                column(Peer3Feedback_StaffAppraisalLines; "Staff Appraisal Lines"."Peer 3 Feedback")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // IF "Staff Appraisal Lines".Type = "Staff Appraisal Lines".Type::Objectives THEN
                    //  ObjectivesSectionRatingTotal := ObjectivesSectionRatingTotal + "Staff Appraisal Lines"."Section Rating";

                    // IF "Staff Appraisal Lines".Type = "Staff Appraisal Lines".Type::"Management Leadership" THEN
                    //  ManagementSectionRatingTotal := ManagementSectionRatingTotal + "Staff Appraisal Lines"."Section Rating";
                    //
                    // IF "Staff Appraisal Lines".Type = "Staff Appraisal Lines".Type::"Job Knowledge" THEN
                    //  KnowledgeSectionRatingTotal := KnowledgeSectionRatingTotal + "Staff Appraisal Lines"."Section Rating";
                    //
                    // IF "Staff Appraisal Lines".Type = "Staff Appraisal Lines".Type::"Problem Solving" THEN
                    //  ProblemSectionRatingTotal := ProblemSectionRatingTotal + "Staff Appraisal Lines"."Section Rating";
                    //
                    // IF "Staff Appraisal Lines".Type = "Staff Appraisal Lines".Type::"Communication and Teamwork" THEN
                    //  CommsSectionRatingTotal := CommsSectionRatingTotal + "Staff Appraisal Lines"."Section Rating";

                    //Section1Score := (ObjectivesSectionRatingTotal/15)*50;
                    //Section2Score := ((ManagementSectionRatingTotal+KnowledgeSectionRatingTotal+ProblemSectionRatingTotal+CommsSectionRatingTotal)/20)*50;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SupervisorJobTitle := '';
                SupervisorLocation := '';
                SupervisorDept := '';

                EmpUserSetup.Reset;
                EmpUserSetup.SetRange("Employee No.", "Staff Appraisal Header"."Staff No");
                if "Staff Appraisal Header"."Sent to Supervisor" then begin
                    if EmpUserSetup.FindFirst then
                        EmpUserSetup.CalcFields(Signature);
                end;

                if "Staff Appraisal Header"."Sent to Supervisor" and "Staff Appraisal Header"."Approved By Supervisor" then begin
                    SupervisorUserSetup.Reset;
                    SupervisorUserSetup.SetRange("Employee No.", "Staff Appraisal Header".Supervisor);
                    if SupervisorUserSetup.FindFirst then
                        SupervisorUserSetup.CalcFields(Signature);
                end;

                Employee.Reset;
                //Employee.SETFILTER("No.",'%1|%2',"Staff Appraisal Header"."Staff No","Staff Appraisal Header".Supervisor);
                Employee.SetRange("No.", "Staff Appraisal Header".Supervisor);
                if Employee.FindSet then begin
                    //REPEAT
                    /*IF Employee."No." = "Staff Appraisal Header"."Staff No" THEN
                      EmployeeJobTitle := Employee."Job Title";*/
                    if Employee."No." = "Staff Appraisal Header".Supervisor then begin
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

                StaffAppraisalLinesCounter := 0;
                StaffAppraisalLines.Reset;
                StaffAppraisalLines.SetRange("Doc No", "Staff Appraisal Header".No);
                StaffAppraisalLines.SetRange("Staff No", "Staff Appraisal Header"."Staff No");
                if StaffAppraisalLines.FindFirst then begin
                    if StaffAppraisalLines.Type = StaffAppraisalLines.Type::Objectives then
                        ObjectivesSectionRatingTotal := ObjectivesSectionRatingTotal + StaffAppraisalLines."Section Rating";

                    if StaffAppraisalLines.Type = StaffAppraisalLines.Type::"Management Leadership" then
                        ManagementSectionRatingTotal := ManagementSectionRatingTotal + StaffAppraisalLines."Section Rating";

                    if StaffAppraisalLines.Type = StaffAppraisalLines.Type::"Job Knowledge" then
                        KnowledgeSectionRatingTotal := KnowledgeSectionRatingTotal + StaffAppraisalLines."Section Rating";

                    if StaffAppraisalLines.Type = StaffAppraisalLines.Type::"Problem Solving" then
                        ProblemSectionRatingTotal := ProblemSectionRatingTotal + StaffAppraisalLines."Section Rating";

                    if StaffAppraisalLines.Type = StaffAppraisalLines.Type::"Communication and Teamwork" then
                        CommsSectionRatingTotal := CommsSectionRatingTotal + StaffAppraisalLines."Section Rating";

                    StaffAppraisalLinesCounter += 1;
                end;

                if StaffAppraisalLinesCounter = 0 then
                    StaffAppraisalLinesCounter := 1;

                Section1Score := (ObjectivesSectionRatingTotal / StaffAppraisalLinesCounter) * 50;
                Section2Score := ((ManagementSectionRatingTotal + KnowledgeSectionRatingTotal + ProblemSectionRatingTotal + CommsSectionRatingTotal) / StaffAppraisalLinesCounter) * 50;

            end;

            trigger OnPreDataItem()
            begin
                ObjectivesSectionRatingTotal := 0;
                ManagementSectionRatingTotal := 0;
                KnowledgeSectionRatingTotal := 0;
                ProblemSectionRatingTotal := 0;
                CommsSectionRatingTotal := 0;
                Section1Score := 0;
                Section2Score := 0;
            end;
        }
        dataitem("Appraisal Remarks"; "Appraisal Remarks")
        {
            column(Entry_No; "Entry No")
            { }
            column(Remarks; Remarks)
            { }
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
        CompInfo.Reset;
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        SupervisorJobTitle: Text[50];
        Employee: Record Employee;
        SupervisorLocation: Text[100];
        Locations: Record Location;
        SupervisorDept: Text[50];
        DimVal: Record "Dimension Value";
        EmpUserSetup: Record "User Setup";
        SupervisorUserSetup: Record "User Setup";
        ObjectivesSectionRatingTotal: Decimal;
        ManagementSectionRatingTotal: Decimal;
        KnowledgeSectionRatingTotal: Decimal;
        ProblemSectionRatingTotal: Decimal;
        CommsSectionRatingTotal: Decimal;
        Section1Score: Decimal;
        Section2Score: Decimal;
        StaffAppraisalLines: Record "Staff Appraisal Lines";
        StaffAppraisalLinesCounter: Integer;
}