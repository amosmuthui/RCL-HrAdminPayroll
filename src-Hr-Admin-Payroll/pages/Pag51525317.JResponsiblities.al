page 51525317 "J. Responsiblities"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Company Jobs";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Job Description"; Rec."Job Description")
                {
                }
            }
            label(Control1000000006)
            {
                CaptionClass = Text19035248;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            part(KPA; "Job Responsiblities")
            {
                SubPageLink = "Job ID" = FIELD("Job ID");
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
        Text19035248: Label 'Key Responsibilities';
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
}