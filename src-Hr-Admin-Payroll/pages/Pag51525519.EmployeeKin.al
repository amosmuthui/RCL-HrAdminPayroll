page 51525519 "Employee Kin"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = Employee;
    SourceTableView = WHERE(Status = CONST(Active));

    layout
    {
        area(content)
        {
            group(Genera)
            {
                Caption = 'Genera';
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
                CaptionClass = Text19079240;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            part(KPA; "Employee Kin Lines")
            {
                SubPageLink = "Employee Code" = FIELD("No.");
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
        Text19079240: Label 'Next Of Kin';
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
}