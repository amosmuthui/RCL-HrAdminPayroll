page 51525306 "New Employees"
{
    ApplicationArea = All;
    Caption = 'New Employees';
    PageType = ListPart;
    SourceTable = Employee;
    SourceTableView = where(Status = const(Active));
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the employee''s first name.';
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the employee''s middle name.';
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the employee''s last name.';
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                    ToolTip = 'Specifies the value of the Date Of Join field.';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the employee''s job title.';
                }
                field("Responsibility Center Name"; Rec."Responsibility Center Name")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center Name field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Date Of Join", '%1..%2', CalcDate('<-1M>', Today), Today);
    end;
}