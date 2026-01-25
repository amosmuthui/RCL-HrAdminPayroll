page 51525573 "Staff Supervisor Comments"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Staff Appraisal Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Supervisor Remarks"; Rec."Supervisor Remarks")
                {
                    Caption = 'Remarks';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Supervisor Comments";
    end;
}