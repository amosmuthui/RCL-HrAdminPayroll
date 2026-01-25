page 51525412 "Completed Trainings"
{
    ApplicationArea = All;
    Caption = 'Completed Trainings';
    PageType = List;
    SourceTable = "Training Schedules";
    UsageCategory = Lists;
    SourceTableView = Where(Status = const(Done));
    CardPageId = "Training Schedule Card";
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(Position; Rec.Position)
                {
                    ToolTip = 'Specifies the value of the Position ID field.';
                }
                field(Department; Rec.Department)
                { }
                field("Training Title"; Rec."Training Title")
                {
                    ToolTip = 'Specifies the value of the Training Title field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
            }
        }
    }
}