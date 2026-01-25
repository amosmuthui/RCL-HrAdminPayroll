page 51525511 "Emp Qualification"
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
                CaptionClass = Text19020326;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            part(KPA; "Employee Qualification")
            {
                SubPageLink = "Employee No." = FIELD("No.");
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CanEditCard := false;
        CanEditPaymentInfo := false;
        CanEditLeaveInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then begin
            CanEditCard := UserSetup."Can Edit Emp Card";
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
            CanEditLeaveInfo := UserSetup."Can Edit Leave Entitlement";
        end;
        CurrPage.Editable(true);
        if (CanEditCard = false) and (CanEditLeaveInfo = false) then
            CurrPage.Editable(false);
    end;

    var
        KPACode: Code[20];
        Text19020326: Label 'Qualification';
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
}