page 51525547 "Employee Supervisor Exp Rating"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Supervisor Experience Rating";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Exit Interview Code"; Rec."Exit Interview Code")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                }
                field(Rating; Rec.Rating)
                {
                }
            }
        }
    }

    actions
    {
    }
}