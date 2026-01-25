page 52211550 "Accident / Incident Logs List"
{
    ApplicationArea = All;
    Caption = 'Accident / Incident Logs List';
    PageType = List;
    SourceTable = "Accident / Incident Logs Manag";
    CardPageId = "Accident / Incident Logs Manag";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document Number"; Rec."Document Number")
                {
                    ToolTip = 'Specifies the value of the Document Number field.', Comment = '%';
                }
                field("Incident Description"; Rec."Incident Description")
                {
                    ToolTip = 'Specifies the value of the Incident Description field.', Comment = '%';
                }
                field("Date of Incident"; Rec."Date of Incident")
                {
                    ToolTip = 'Specifies the value of the Date of Incident field.', Comment = '%';
                }
                field("Location of Incident"; Rec."Location of Incident")
                {
                    ToolTip = 'Specifies the value of the Location of Incident field.', Comment = '%';
                }
            }
        }
    }
}
