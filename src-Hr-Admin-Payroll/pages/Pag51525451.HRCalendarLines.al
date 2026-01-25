page 51525451 "HR Calendar Lines"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "HR Calendar List";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = true;
                ShowCaption = false;
                field(Date; Rec.Date)
                {
                }
                field(Day; Rec.Day)
                {
                }
                field("Non Working"; Rec."Non Working")
                {
                    Editable = true;
                }
                field(Reason; Rec.Reason)
                {
                }
            }
        }
    }

    actions
    {
    }
}