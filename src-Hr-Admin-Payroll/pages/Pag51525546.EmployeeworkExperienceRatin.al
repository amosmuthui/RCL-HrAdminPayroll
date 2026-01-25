page 51525546 "Employee work Experience Ratin"
{
    ApplicationArea = All;
    Caption = 'Employee work Experience Rating';
    PageType = ListPart;
    SourceTable = "Employee Experience Rating";

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