page 51525541 "Employee Medical Information"
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
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = false;
                    Enabled = true;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Editable = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    Editable = false;
                    Enabled = true;
                }
                field(Initials; Rec.Initials)
                {
                    Editable = false;
                }
                field("ID Number"; Rec."ID Number")
                {
                    Editable = false;
                }
                field(Gender; Rec.Gender)
                {
                    Editable = false;
                }
                field(Position; Rec.Position)
                {
                    Editable = false;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    Editable = false;
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                    Editable = false;
                }
            }
            label(Control1000000030)
            {
                CaptionClass = Text19004863;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            part(KPA; "Medical Info")
            {
            }
        }
    }

    actions
    {
    }

    var
        KPACode: Code[20];
        Text19004863: Label 'Medical Info.';
}