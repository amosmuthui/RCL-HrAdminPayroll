page 52211562 "Memo Lines"
{
    ApplicationArea = All;
    Caption = 'Memo Lines';
    PageType = ListPart;
    SourceTable = "Memo Lines";
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
                field("Activity Description"; Rec."Activity Description")
                {
                    ToolTip = 'Specifies the value of the Activity Description field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field(Venue; Rec.Venue)
                {

                }
            }
        }
    }
}
