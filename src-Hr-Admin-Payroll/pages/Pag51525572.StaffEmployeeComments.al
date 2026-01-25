page 51525572 "Staff Employee Comments"
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
                field(Remarks; Rec."Employees Remarks")
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
        Rec.Type := Rec.Type::"Employee Comments";
    end;
}