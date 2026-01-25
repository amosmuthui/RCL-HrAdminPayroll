page 51525393 "Staff Appraisal Lists"
{
    ApplicationArea = All;
    CardPageID = "Staff Appraisal Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Staff Appraisal Header";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                }
                field("Staff No"; Rec."Staff No")
                {
                }
                field("Staff Name"; Rec."Staff Name")
                {
                }
                field(Department; Rec.Department)
                {
                }
                field(Period; Rec.Period)
                {
                }
                field("Period Desc"; Rec."Period Desc")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Evaluation Scale")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Appraisal Remarks";
            }
        }

    }
}