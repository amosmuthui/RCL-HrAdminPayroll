page 51525528 "Succession Requirements"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "HR Company or Other Training";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Need Source"; Rec."Need Source")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Competency; Rec.Competency)
                {
                }
                field("Date of re-assessment"; Rec."Date of re-assessment")
                {
                }
                field(Approved; Rec.Approved)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}