page 52211524 "Airtime Requests"
{
    ApplicationArea = All;
    Caption = 'Airtime Requests';
    PageType = List;
    SourceTable = "Airtime Requests";
    UsageCategory = Lists;
    CardPageId = "Airtime Request Card";
    Editable = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.', Comment = '%';
                }
                field("Emp Name"; Rec."Emp Name")
                {
                    ToolTip = 'Specifies the value of the Emp Name field.', Comment = '%';
                }
                field("Position Title"; Rec."Position Title")
                {
                    ToolTip = 'Specifies the value of the Position Title field.', Comment = '%';
                }
                field("Dept Name"; Rec."Dept Name")
                {
                    ToolTip = 'Specifies the value of the Dept Name field.', Comment = '%';
                }
                field("Job Category"; Rec."Job Category")
                {
                    ToolTip = 'Specifies the value of the Job Category field.', Comment = '%';
                }
                field("Applicable Amount"; Rec."Applicable Amount")
                {
                    ToolTip = 'Specifies the value of the Applicable Amount field.', Comment = '%';
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ToolTip = 'Specifies the value of the Applied Amount field.', Comment = '%';
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Approved Amount field.', Comment = '%';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.', Comment = '%';
                }
            }
        }
    }
}
