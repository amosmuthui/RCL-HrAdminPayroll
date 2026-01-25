page 51525345 "Employee Transfer list"
{
    ApplicationArea = All;
    CardPageID = "Employee Transfer Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Employee Transfer Header";
    SourceTableView = WHERE(Status = FILTER(Open | "Pending Approval"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                { }
                field("Date Created"; Rec."Date Created")
                {
                }
                field("Effective Transfer Date"; Rec."Effective Transfer Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}