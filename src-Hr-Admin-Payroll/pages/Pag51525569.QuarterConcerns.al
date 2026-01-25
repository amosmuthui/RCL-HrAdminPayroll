page 51525569 "Quarter Concerns"
{
    ApplicationArea = All;
    //Caption = 'Concerns Raised';
    PageType = ListPart;
    SourceTable = "MidYear Appraisal Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Objective Code"; Rec."Objective Code")
                {
                }
                field("Items/Description"; Rec."Items/Description")
                {
                }
                field("Concern Raised"; Rec."Concern Raised")
                { }
                field("Proposed Resolution"; Rec."Proposed Resolution")
                { }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.setCriticalFields();
    end;
}