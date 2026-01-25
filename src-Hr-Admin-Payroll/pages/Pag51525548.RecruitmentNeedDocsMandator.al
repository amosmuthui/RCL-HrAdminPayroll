page 51525548 "Recruitment Need Docs Mandator"
{
    ApplicationArea = All;
    Caption = 'Mandatory Documents';
    PageType = ListPart;
    SourceTable = "Recruitment Mandatory Docs";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Recruitment Need Code"; Rec."Recruitment Need Code")
                {
                }
                field("Document No"; Rec."Document No")
                {
                }
                field("Document Name"; Rec."Document Name")
                {
                }
                field("Document Desciption"; Rec."Document Desciption")
                {
                }
                field(Mandatory; Rec.Mandatory)
                {
                }
            }
        }
    }

    actions
    {
    }
}