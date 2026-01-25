page 51525383 "WB Departmental Targets"
{
    ApplicationArea = All;
    CardPageId = "Departmental Target Card";
    Caption = 'Departmental Targets';
    PageType = List;
    SourceTable = "WB Departmental Targets";
    UsageCategory = Lists;
    SourceTableView = SORTING(No) ORDER(ascending);
    Editable = true;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                    ToolTip = 'Specifies the value of the Departmental Objective field.';
                }
                field("Success Measure"; Rec."Success Measure")
                {
                    ToolTip = 'Specifies the value of the Success Measure field.';
                }
                field("Specific Action Plan"; Rec."Specific Action Plan")
                {
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
}