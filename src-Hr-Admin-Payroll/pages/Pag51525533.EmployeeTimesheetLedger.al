page 51525533 "Employee Timesheet Ledger"
{
    ApplicationArea = All;
    Editable = true;
    PageType = ListPart;
    SourceTable = "Employee Timesheet Ledger";
    SourceTableView = SORTING(Date)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Day Type"; Rec."Day Type")
                {
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    Editable = false;
                }
                field(Day; Rec.Day)
                {
                }
                field(Hours; Rec.Hours)
                {
                }
                field("Non-Working Day"; Rec."Non-Working Day")
                {
                    Editable = false;
                }
                field("TS  No"; Rec."TS  No")
                {
                }
                field("Employee No."; Rec."Employee No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}