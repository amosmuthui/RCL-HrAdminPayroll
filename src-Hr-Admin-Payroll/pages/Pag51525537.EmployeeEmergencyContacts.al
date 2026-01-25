page 51525537 "Employee Emergency Contacts"
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
                Enabled = true;
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
                CaptionClass = Text19067221;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            part(KPA; "Emergency Contacts")
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
        Text19067221: Label 'Emergency Contacts';
}