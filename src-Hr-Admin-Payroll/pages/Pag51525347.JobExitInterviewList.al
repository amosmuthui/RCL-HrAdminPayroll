page 51525347 "Job Exit Interview List"
{
    ApplicationArea = All;
    CardPageID = "Job Exit Interview Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Exit Interview";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field("Employee No."; Rec."Employee No.")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field(Position; Rec.Position)
                {
                }
                field(Supervisor; Rec.Supervisor)
                {
                }
                field("Date of Join"; Rec."Date of Join")
                {
                }
                field("Termination Date"; Rec."Termination Date")
                {
                }
                field("Future Re-Employment"; Rec."Future Re-Employment")
                {
                }
                field("Leaving could have prevented"; Rec."Leaving could have prevented")
                {
                }
            }
        }
    }

    actions
    {
    }
}