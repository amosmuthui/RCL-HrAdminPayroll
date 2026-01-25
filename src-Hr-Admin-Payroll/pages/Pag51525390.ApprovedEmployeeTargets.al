page 51525390 "Approved Employee Targets"
{
    ApplicationArea = All;
    CardPageID = "Staff Targets Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Staff Target Objectives";
    SourceTableView = WHERE("Approved By Supervisor" = FILTER(true));
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                }
                field("Staff No"; Rec."Staff No")
                {
                }
                field("Staff Name"; Rec."Staff Name")
                {
                }
                field(Directorate; Rec.Directorate)
                {
                }
                field(Department; Rec.Department)
                {
                }
                field(Period; Rec.Period)
                {
                }
                field("Created On"; Rec."Created On")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field(Supervisor; Rec.Supervisor)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        Rec.SetFilter("Created By", UserId);
    end;
}