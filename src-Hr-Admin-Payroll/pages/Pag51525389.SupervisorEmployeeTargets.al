page 51525389 "Supervisor Employee Targets"
{
    ApplicationArea = All;
    Caption = 'Targets Pending Approval';
    CardPageID = "Staff Targets Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Staff Target Objectives";
    SourceTableView = WHERE("Sent to Supervisor" = FILTER(true),
                            "Approved By Supervisor" = FILTER(false));
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
        if UserSetup.Get(UserId) then begin
        end;
        Rec.SetFilter(Supervisor, UserSetup."Employee No.");
    end;

    var
        UserSetup: Record "User Setup";
}