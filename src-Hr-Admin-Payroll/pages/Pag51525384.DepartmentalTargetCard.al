page 51525384 "Departmental Target Card"
{
    ApplicationArea = All;
    Caption = 'Departmental Target Card';
    PageType = Card;
    SourceTable = "WB Departmental Targets";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.';
                }
                field("Main Objective Code"; Rec."Main Objective Code")
                {
                    ToolTip = 'Specifies the value of the Main Objective Code field.';
                }
                field("Main Objective Description"; Rec."Main Objective Description")
                {
                    ToolTip = 'Specifies the value of the Main Objective Description field.';
                }
                field(Theme; Rec.Theme)
                {
                    ToolTip = 'Specifies the value of the Theme field.';
                }
                field("Success Measure"; Rec."Success Measure")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Success Measure field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.';
                }
                field("Departmental Objective"; Rec."Departmental Objective")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Departmental Objective field.';
                }
                field("Specific Action Plan"; Rec."Specific Action Plan")
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Specific Action Plan field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Due Date Description"; Rec."Due Date Description")
                {
                    ToolTip = 'Specifies the value of the Due Date Description field.';
                }
            }
        }
    }


    trigger OnNewRecord(BelowxRec: Boolean)
    var
    begin
        HrAppraissalPeriods.Reset();
        HrAppraissalPeriods.SetRange(Open, true);
        if HrAppraissalPeriods.FindFirst() then
            Rec.Period := HrAppraissalPeriods.Code
        else
            Error('There are no open periods!');

        EmpRec.Reset();
        EmpRec.SetRange("User ID", UserId);
        EmpRec.SetFilter("Responsibility Center", '<>%1', '');
        if EmpRec.FindFirst() then begin
            Rec."Department Code" := EmpRec."Responsibility Center";
            Rec."Department Name" := EmpRec."Responsibility Center Name";
            Rec.Validate("Department Code");
        end else
            Error('Kindly ask the HR department to update your employee card with a user ID and department!');
    end;

    var
        HrAppraissalPeriods: Record "HR Appraisal Periods";
        EmpRec: Record Employee;
}