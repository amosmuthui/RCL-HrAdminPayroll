page 51525599 "Airtime Allocations"
{
    ApplicationArea = All;
    Caption = 'Airtime Allocations';
    PageType = ListPart;
    SourceTable = "Airtime Allocations";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.', Comment = '%';
                }
                field("Emp Name"; Rec."Emp Name")
                {
                    ToolTip = 'Specifies the value of the Emp Name field.', Comment = '%';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.', Comment = '%';
                }
                field("Airtime Amount"; Rec."Airtime Amount")
                {
                    ToolTip = 'Specifies the value of the Airtime Amount field.', Comment = '%';
                }
                field("Position Title"; Rec."Position Title")
                {
                    ToolTip = 'Specifies the value of the Position Title field.', Comment = '%';
                }
                field("Dept Name"; Rec."Dept Name")
                {
                    ToolTip = 'Specifies the value of the Dept Name field.', Comment = '%';
                }
            }
        }
    }
}
