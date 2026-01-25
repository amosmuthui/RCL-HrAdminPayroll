page 51525382 "Performance Objectives"
{
    ApplicationArea = All;
    Caption = 'Organizational Targets';
    PageType = List;
    SourceTable = "Performance Objectives";
    SourceTableView = SORTING(No) ORDER(descending);
    UsageCategory = Lists;
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
                { }
                field(Theme; Rec.Theme)
                {
                    ToolTip = 'Specifies the value of the Theme field.';
                }
                field("Objective Description"; Rec."Objective Description")
                {
                    ToolTip = 'Specifies the value of the Objective Description field.';
                }
                field("Success Measure"; Rec."Success Measure")
                {
                    ToolTip = 'Specifies the value of the Success Measure field.';
                }
                field("Specific Action Plan"; Rec."Specific Action Plan")
                {
                    ToolTip = 'Specifies the value of the Specific Action Plan field.';
                }
            }
        }
    }
}