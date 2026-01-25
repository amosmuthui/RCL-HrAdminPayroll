page 51525529 "Separtion Lines"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Separation Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Description"; Rec."Item Description")
                {
                }
                field(Cleared; Rec.Cleared)
                {
                }
                field("Cleared Date"; Rec."Cleared Date")
                {
                }
                field("Department Code"; Rec."Department Code")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }
}