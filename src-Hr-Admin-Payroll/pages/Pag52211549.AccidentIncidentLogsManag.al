page 52211549 "Accident / Incident Logs Manag"
{
    ApplicationArea = All;
    Caption = 'Accident / Incident Logs Manag';
    PageType = Card;
    SourceTable = "Accident / Incident Logs Manag";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Document Number"; Rec."Document Number")
                {
                    ToolTip = 'Specifies the value of the Document Number field.', Comment = '%';
                }
                field("Reporting Party "; Rec."Reporting Party ")
                {
                    ToolTip = 'Specifies the value of the Reporting Party field.', Comment = '%';
                }
                field("Reporting Party Name"; Rec."Reporting Party Name")
                {
                    ToolTip = 'Specifies the value of the Reporting Party Name field.', Comment = '%';
                }
                field("Location of Incident"; Rec."Location of Incident")
                {
                    ToolTip = 'Specifies the value of the Location of Incident field.', Comment = '%';
                }
                field("Date of Incident"; Rec."Date of Incident")
                {
                    ToolTip = 'Specifies the value of the Date of Incident field.', Comment = '%';
                }
                field("Time of Incident"; Rec."Time of Incident")
                {
                    ToolTip = 'Specifies the value of the Time of Incident field.', Comment = '%';
                }
                field("Incident Description"; Rec."Incident Description")
                {
                    ToolTip = 'Specifies the value of the Incident Description field.', Comment = '%';
                }
                field("Corrective Action Taken"; Rec."Corrective Action Taken")
                {

                }
                field("Follow-up or investigations"; Rec."Follow-up or investigations")
                {

                }
            }
            part("Accident / Incident Logs Kines"; "Accident / Incident Logs Lines")
            {
                SubPageLink = "Doc. No." = FIELD("Document Number");
            }
        }
    }
}
