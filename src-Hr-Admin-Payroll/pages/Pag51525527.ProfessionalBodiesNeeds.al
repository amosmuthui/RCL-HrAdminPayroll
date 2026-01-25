page 51525527 "Professional Bodies Needs"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Job Professional Need";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Professional Body"; Rec."Professional Body")
                {
                }
                field("Body Name"; Rec."Body Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}