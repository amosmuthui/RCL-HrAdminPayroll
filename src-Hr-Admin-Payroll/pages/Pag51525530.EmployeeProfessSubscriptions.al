page 51525530 "Employee Profess Subscriptions"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Employee Professional Bodies";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Employee; Rec.Employee)
                {
                }
                field("Proffesional Body"; Rec."Proffesional Body")
                {
                }
                field("Professional Body Name"; Rec."Professional Body Name")
                {
                    Editable = false;
                }
                field("Date of Join"; Rec."Date of Join")
                {
                }
                field("Annual Fee"; Rec."Annual Fee")
                {
                }
                field("Date of Leaving"; Rec."Date of Leaving")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}