page 51525516 "Appointment Checklist"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Appointment Checklist";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Item; Rec.Item)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Signed; Rec.Signed)
                {
                }
            }
        }
    }

    actions
    {
    }
}