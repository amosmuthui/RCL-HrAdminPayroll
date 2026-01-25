page 51525405 "Pending Training Requests"
{
    ApplicationArea = All;
    Caption = 'Pending Training Requests';
    PageType = List;
    SourceTable = "Training Request";
    UsageCategory = Lists;
    CardPageId = "Training Request";
    SourceTableView = where(Status = const("Pending Approval"));
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Request No."; Rec."Request No.")
                {
                    ToolTip = 'Specifies the value of the Request No. field.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ToolTip = 'Specifies the value of the Request Date field.';
                }
                /*field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }*/
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Planned Start Date"; Rec."Planned Start Date")
                {
                    ToolTip = 'Specifies the value of the Planned Start Date field.';
                }
                field("Planned End Date"; Rec."Planned End Date")
                {
                    ToolTip = 'Specifies the value of the Planned End Date field.';
                }
            }
        }
    }
}