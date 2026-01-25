page 51525531 "Staff Timesheet"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    CardPageID = "Staff Timesheet Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    ShowFilter = false;
    SourceTable = "Employee Timesheet Lines";
    SourceTableView = WHERE("Approval Status" = FILTER(Employee));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("List of Key Tasks Undertaken"; Rec."List of Key Tasks Undertaken")
                {
                }
                field(Category; Rec.Category)
                {
                    Editable = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Directorate Name"; Rec."Directorate Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Department; Rec.Department)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Location; Rec.Location)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Hours Worked"; Rec."Hours Worked")
                {
                }
                field("Total Days Worked"; Rec."Total Days Worked")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Employee Timesheet Ledger")
            {
                Image = LedgerBook;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Employee Timesheet Ledger";
                RunPageLink = "TS  No" = FIELD("TS  No"),
                              "Line No." = FIELD("Line No.");
            }
        }
    }
}