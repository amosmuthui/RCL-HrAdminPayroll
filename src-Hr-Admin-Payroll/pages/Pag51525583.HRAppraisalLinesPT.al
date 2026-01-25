page 51525583 "HR Appraisal Lines - PT"
{
    ApplicationArea = All;
    Caption = 'HR Appraisal Lines - Performance Targets';
    PageType = ListPart;
    SourceTable = "HR Appraisal Lines - PT";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Perspective; Rec.Perspective)
                {
                }
                field(Objective; Rec.Objective)
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
                }
                field(Activity; Rec.Activity)
                {
                    Editable = false;
                }
                field("Agreed Performance Targets"; Rec."Agreed Performance Targets")
                {
                    Caption = 'Target';
                    Editable = false;
                }
                field("Target Score"; Rec."Target Score")
                {
                }
                label("|")
                {
                    Editable = false;
                    ShowCaption = true;
                }
                field("Self Assesment"; Rec."Self Assesment")
                {
                    Caption = 'Mid-Year Self Appraisal Score';
                }
                field("Appraisee Comments"; Rec."Appraisee Comments")
                {
                    ShowMandatory = true;
                }
                field("Supervisor-Assesment"; Rec."Supervisor-Assesment")
                {
                    Caption = 'Mid-Year Supervisor Score';
                }
                field("Supervisors Score"; Rec."Supervisors Score")
                {
                    Caption = 'Supervisors Comments';
                    Editable = SupervisorAssementEditable;
                }
                field("Agreed-Assesment Results"; Rec."Agreed-Assesment Results")
                {
                    Caption = 'Mid-Year Agreed Score';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Agreed Score"; Rec."Agreed Score")
                {
                    Caption = 'Mid-Year Comments';
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Supervisor Comments"; Rec."Supervisor Comments")
                {
                    Caption = 'Mid-Year Supervisor Comments';
                }
                label("||")
                {
                    Editable = false;
                    ShowCaption = true;
                }
                field("End Year Self Score"; Rec."End Year Self Score")
                {
                    Caption = 'End-Year Self Appraisal Score';
                }
                field("EndYear Self Comments"; Rec."EndYear Self Comments")
                {
                }
                field("End Year Supervisor Score"; Rec."End Year Supervisor Score")
                {
                }
                field("EndYear Supervisor Comments"; Rec."EndYear Supervisor Comments")
                {
                }
                field("End Year Assessment"; Rec."End Year Assessment")
                {
                    Caption = 'End-Year Agreed Score';
                }
                field("End Year Score"; Rec."End Year Score")
                {
                    Caption = 'End Year Assessment Comments';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //SupervisorAssementEditable:=fn_ToggleVisibilityEndMidYear();
        //SelfAssesmentEditable:=fn_ToggleVisibilityEndMidYear();

        //EndYearMidYearEditable:=fn_ToggleVisibilityTargetSettingApproval();
    end;

    var
        SelfAssesmentEditable: Boolean;
        SupervisorAssementEditable: Boolean;
        EndYearMidYearEditable: Boolean;

    local procedure fn_ToggleVisibilityEndMidYear(): Boolean
    var
        HRAppraisalHeader: Record "HR Appraisal Header";
    begin
        HRAppraisalHeader.Reset();
        HRAppraisalHeader.SetRange("No.", Rec."Appraisal No.");
        if HRAppraisalHeader.FindFirst() then begin
            case HRAppraisalHeader."Appraisal Stage" of
                HRAppraisalHeader."Appraisal Stage"::"Mid Year Review":
                    exit(false);
                HRAppraisalHeader."Appraisal Stage"::"End Year Evaluation":
                    exit(false);
            /*HRAppraisalHeader."Appraisal Stage"::"2":
                exit(true);
            HRAppraisalHeader."Appraisal Stage"::"3":
                exit(true);*/
            end;
        end;
    end;

    local procedure fn_ToggleVisibilityTargetSettingApproval(): Boolean
    var
        HRAppraisalHeader: Record "HR Appraisal Header";
    begin
        HRAppraisalHeader.Reset();
        HRAppraisalHeader.SetRange("No.", Rec."Appraisal No.");
        if HRAppraisalHeader.FindFirst() then begin
            case HRAppraisalHeader."Appraisal Stage" of
                HRAppraisalHeader."Appraisal Stage"::"Mid Year Review":
                    exit(true);
                HRAppraisalHeader."Appraisal Stage"::"End Year Evaluation":
                    exit(true);
            /*HRAppraisalHeader."Appraisal Stage"::"2":
                exit(false);
            HRAppraisalHeader."Appraisal Stage"::"3":
                exit(false);*/

            end;
        end;
    end;
}