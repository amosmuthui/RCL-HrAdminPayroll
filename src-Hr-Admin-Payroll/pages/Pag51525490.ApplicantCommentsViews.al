page 51525490 "Applicant Comments/Views"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    PageType = CardPart;
    SourceTable = "Applicant Comments/Views";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Applicant No"; Rec."Applicant No")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Views/Comments"; Rec."Views/Comments")
                {
                }
            }
        }
    }

    actions
    {
    }
}