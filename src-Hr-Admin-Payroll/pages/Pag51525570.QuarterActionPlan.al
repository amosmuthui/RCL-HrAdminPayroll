page 51525570 "Quarter Action Plan"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "MidYear Appraisal Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Objective Code"; Rec."Objective Code")
                { }
                field("Items/Description"; Rec."Items/Description")
                {
                }
                field("Agreed Support"; Rec."Agreed Support")
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