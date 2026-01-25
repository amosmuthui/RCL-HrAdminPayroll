page 51525391 "Mid Year Appraisal"
{
    ApplicationArea = All;
    CardPageID = "Quarterly Appraisal Card";
    Caption = 'Mid-Period Review';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Mid Year Appraisal";
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
                field(Supervisor; Rec.Supervisor)
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
    }

    trigger OnInit()
    begin
        Rec.SetFilter("Created By", UserId);
    end;
}