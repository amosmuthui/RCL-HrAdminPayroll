page 51525525 "Document Link"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Document Link";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field("Document Description"; Rec."Document Description")
                {
                }
                field(Attachement; Rec.Attachement)
                {
                }
            }
        }
    }

    actions
    {
    }

    procedure GetDocument() Document: Text[200]
    begin
        Document := Rec."Document Description";
    end;
}