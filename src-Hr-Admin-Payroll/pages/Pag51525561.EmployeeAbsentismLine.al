page 51525561 "Employee Absentism Line"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
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
                field("Absent From"; Rec."Absent From")
                {
                }
                field("Absent To"; Rec."Absent To")
                {
                }
                field("No. of  Days Absent"; Rec."No. of  Days Absent")
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