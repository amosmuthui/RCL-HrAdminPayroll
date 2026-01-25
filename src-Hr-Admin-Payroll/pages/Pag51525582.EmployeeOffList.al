page 51525582 "Employee Off List"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Holidays_Off Days";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Employee No."; Rec."Employee No.")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Leave Type"; Rec."Leave Type")
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("No. of Days"; Rec."No. of Days")
                {
                }
                field("Reason for Off"; Rec."Reason for Off")
                {
                }
                field("Approved to Work"; Rec."Approved to Work")
                {
                }
            }
        }
    }

    actions
    {
    }
}