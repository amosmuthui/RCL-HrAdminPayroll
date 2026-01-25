page 51525387 "Employee Targets"
{
    ApplicationArea = All;
    Caption = 'Staff Targets';
    CardPageID = "Staff Targets Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Staff Target Objectives";
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
                field("Department Name"; Rec."Department Name")
                {
                }
                field(Section; Rec.Section)
                {
                }
                field(Period; Rec.Period)
                {
                }
                field("Created On"; Rec."Created On")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                }
                field("Sent to Supervisor"; Rec."Sent to Supervisor")
                {
                    Editable = false;
                }
                field("Approved By Supervisor"; Rec."Approved By Supervisor")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Staff Targets Report")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Report "Staff Targets Count";
            }
        }
    }

    trigger OnInit()
    begin
        //SetFilter("Created By", UserId);
    end;
}