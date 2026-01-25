page 51525534 "Timesheet Tasks Undertaken"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "TImesheet Tasks Undertaken";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Task Undertaken"; Rec."Task Undertaken")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field(Hours; Rec.Hours)
                {
                }
            }
        }
    }

    actions
    {
    }
}