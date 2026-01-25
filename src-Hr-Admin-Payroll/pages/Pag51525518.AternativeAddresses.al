page 51525518 "Aternative Addresses"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Alternative Address";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Name 2"; Rec."Name 2")
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Fax No."; Rec."Fax No.")
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(County; Rec.County)
                {
                }
                field(Comment; Rec.Comment)
                {
                }
            }
        }
    }

    actions
    {
    }
}