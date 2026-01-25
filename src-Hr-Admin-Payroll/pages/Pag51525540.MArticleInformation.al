page 51525540 "M. Article Information"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Misc. Article Information";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Misc. Article Code"; Rec."Misc. Article Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("In Use"; Rec."In Use")
                {
                }
                field("Serial No."; Rec."Serial No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}