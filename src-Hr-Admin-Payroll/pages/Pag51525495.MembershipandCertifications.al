page 51525495 "Membership and Certifications"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Professional Membership Info";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field("Line No"; Rec."Line No")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Body; Rec.Body)
                {
                    Caption = 'Proffessional Body';
                }
                field("Body Name"; Rec."Body Name")
                {
                    Caption = 'Name';
                }
                field(Level; Rec.Level)
                {
                    Visible = false;
                }
                field("Level Name"; Rec."Level Name")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}