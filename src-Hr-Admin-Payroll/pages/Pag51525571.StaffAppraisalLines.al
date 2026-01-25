page 51525571 "Staff Appraisal Lines"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Staff Appraisal Lines";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Theme; Rec.Theme)
                {
                    Visible = false;
                }
                field("Objective Code"; Rec."Objective Code")
                {
                    Editable = false;
                }
                field(Objective; Rec.Objective)
                {
                }
                field("Success Measure"; Rec."Success Measure")
                {
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    Editable = false;
                }
                field(Rate; Rec.Rate)
                {
                    Visible = true;
                }
                field("Employees Remarks"; Rec."Employees Remarks")
                {
                    Visible = true;
                }
                field("Supervisor Remarks"; Rec."Supervisor Remarks")
                {
                }
                field("Supervisor Rate"; Rec."Supervisor Rate")
                {
                }
                field("Section Rating"; Rec."Section Rating")
                {
                    Editable = true;
                }
                field("Remark Id"; Rec."Remark Id")
                {
                    Caption = 'Evaluation Scale';
                }
                field(Remarks; Rec.Remarks)
                {
                    Caption = 'Evaluation Remark';
                }
            }
        }
    }

    actions
    {
    }
}