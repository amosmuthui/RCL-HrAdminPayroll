page 51525429 "Training Allowance Entries"
{
    ApplicationArea = All;
    Caption = 'Training Allowance Entries';
    PageType = List;
    SourceTable = "Training Allowance Entries";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field("Class No."; Rec."Class No.")
                {
                    ToolTip = 'Specifies the value of the Class No. field.', Comment = '%';
                }
                field("Instructor No."; Rec."Instructor No.")
                {
                    ToolTip = 'Specifies the value of the Instructor No. field.', Comment = '%';
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ToolTip = 'Specifies the value of the Instructor Name field.', Comment = '%';
                }
                field(Allowance; Rec.Allowance)
                {
                    ToolTip = 'Specifies the value of the Allowance (RWF) field.', Comment = '%';
                }
                field("Class Title"; Rec."Class Title")
                {
                    ToolTip = 'Specifies the value of the Class Title field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                { }
                /*field("Processing Comments"; Rec."Processing Comments")
                { }*/
            }
        }
    }
}