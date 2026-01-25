page 51525539 "Misc. Article Info."
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = Employee;
    SourceTableView = WHERE(Status = CONST(Active));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No."; Rec."No.")
                {
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field(Initials; Rec.Initials)
                {
                }
                field("ID Number"; Rec."ID Number")
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(Position; Rec.Position)
                {
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                }
            }
            label(Control1000000030)
            {
                CaptionClass = Text19041242;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            part(KPA; "M. Article Information")
            {
                SubPageLink = "Employee No." = FIELD("No.");
            }
        }
    }

    actions
    {
    }

    var
        KPACode: Code[20];
        Text19041242: Label 'Misc. Article Information';
}