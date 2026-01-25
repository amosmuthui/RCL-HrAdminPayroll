page 51525590 "HR Appraisal Dept. Obj. Setup"
{
    ApplicationArea = All;
    Caption = 'HR Appraisal Departmental Objectives Setup';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "HR Appraisal Dept. Obj. Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Perspective Type"; Rec."Perspective Type")
                {
                }
                field("Perspective Description"; Rec."Perspective Description")
                {
                    Editable = false;
                }
                field("Objective Code"; Rec."Objective Code")
                {
                }
                field("Objective Description"; Rec."Objective Description")
                {
                }
                field("Department Code"; Rec."Department Code")
                {
                    Editable = false;
                }
                field("Department Name"; Rec."Department Name")
                {
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000003; Notes)
            {
            }
        }
    }

    actions
    {
    }
}