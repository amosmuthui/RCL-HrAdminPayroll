page 51525568 "Quarter Agenda"
{
    ApplicationArea = All;
    Caption = 'Appraisal Lines';
    PageType = ListPart;
    SourceTable = "MidYear Appraisal Lines";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Objective Code"; Rec."Objective Code")
                {
                    Editable = false;
                }
                field("Items/Description"; Rec."Items/Description")
                {
                }
                field("Success Measure"; Rec."Success Measure")
                {
                }
                field("Staff Comments"; Rec."Staff Comments")
                {
                    Caption = 'Achievements';
                }
                field("Supervisor Comments"; Rec."Supervisor Comments")
                {
                }
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