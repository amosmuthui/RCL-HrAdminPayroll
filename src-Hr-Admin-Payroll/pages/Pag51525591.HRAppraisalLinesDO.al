page 51525591 "HR Appraisal Lines - DO"
{
    ApplicationArea = All;
    Caption = 'HR Appraisal Lines - Dept. Objectives';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "HR Appraisal Lines - DO";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appraisal No."; Rec."Appraisal No.")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Perspective Code"; Rec."Perspective Code")
                {
                }
                field("Objective Description"; Rec."Objective Description")
                {
                    Editable = false;
                    Enabled = false;
                }
                field("Performance Measure/Indicator"; Rec."Performance Measure/Indicator")
                {
                }
                field(Activity; Rec.Activity)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PerformanceTargets)
            {
                Image = TaskList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Message('Performance Targets here');
                end;
            }
        }
    }

    var
        HRApprDeptObj: Record "HR Appraisal Dept. Obj. Setup";
}