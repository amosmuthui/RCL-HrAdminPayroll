page 51525542 "Medical Info"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Medical History";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Description; Rec.Description)
                {
                }
                field(Results; Rec.Results)
                {
                }
                field(Date; Rec.Date)
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