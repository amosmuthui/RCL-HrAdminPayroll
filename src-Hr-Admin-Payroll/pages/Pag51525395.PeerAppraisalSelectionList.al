page 51525395 "Peer Appraisal Selection List"
{
    ApplicationArea = All;
    CardPageID = "Peer Appraiser Selection Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Peer Appraisal Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Period; Rec.Period)
                {
                }
                field("Staff No"; Rec."Staff No")
                {
                }
                field("Peer Appraiser 1"; Rec."Peer Appraiser 1")
                {
                }
                field("Peer Appraiser 2"; Rec."Peer Appraiser 2")
                {
                }
                field("Peer Appraiser 3"; Rec."Peer Appraiser 3")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Created On"; Rec."Created On")
                {
                }
                field(Supervisor; Rec.Supervisor)
                {
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}