page 51525450 "HR Non Working Days & Dates"
{
    ApplicationArea = All;
    Caption = 'HR Non Working Dates';
    PageType = ListPart;
    SourceTable = "HR Non Working Days & Dates";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                ShowCaption = false;
                field(Date; Rec.Date)
                {
                }
                field(Reason; Rec.Reason)
                {
                }
                field(Recurring; Rec.Recurring)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        DayOfWeek_Visible: Boolean;
        DateVisible: Boolean;
        //HRCalendar: Record "Overtime Template";
        ReasonVisible: Boolean;
}