page 51525559 "Employee Absence List"
{
    ApplicationArea = All;
    CardPageID = "Employee Absentism Card";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Employee Absentism";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Absent No."; Rec."Absent No.")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Absent From"; Rec."Absent From")
                {
                }
                field("Absent To"; Rec."Absent To")
                {
                }
                field("Absentism code"; Rec."Absentism code")
                {
                }
                field("No. of  Days Absent"; Rec."No. of  Days Absent")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Reason for Absentism"; Rec."Reason for Absentism")
                {
                }
                field(Penalty; Rec.Penalty)
                {
                }
            }
        }
    }

    actions
    {
    }
}