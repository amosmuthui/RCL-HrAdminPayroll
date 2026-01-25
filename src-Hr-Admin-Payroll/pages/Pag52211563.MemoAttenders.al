page 52211563 "Memo Attenders"
{
    ApplicationArea = All;
    Caption = 'Memo Attenders';
    PageType = ListPart;
    SourceTable = "Memo Attenders";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Doc No"; Rec."Doc No")
                {
                    ToolTip = 'Specifies the value of the Doc No field.', Comment = '%';
                    Visible = false;
                }
                field("Line No"; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.', Comment = '%';
                    Visible = false;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
            }
        }
    }
}
