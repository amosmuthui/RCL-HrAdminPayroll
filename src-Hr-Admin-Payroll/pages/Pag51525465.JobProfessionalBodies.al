page 51525465 "Job Professional Bodies"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Job Professional Bodies";

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
            }
        }
    }

    actions
    {
    }
}