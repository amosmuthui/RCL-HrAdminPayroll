page 51525350 "Payrol Processing list"
{
    ApplicationArea = All;
    CardPageID = "Payroll Processing Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Payroll Processing Header";
    //SourceTableView = WHERE ("Close Payroll" = CONST (false));
    SourceTableView = sorting("Payroll Processing No") order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payroll Processing No"; Rec."Payroll Processing No")
                {
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Date Processed"; Rec."Date Processed")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}