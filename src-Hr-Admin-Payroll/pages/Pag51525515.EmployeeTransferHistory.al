page 51525515 "Employee Transfer History"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Employee Transfer Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transfer Type"; Rec."Transfer Type")
                {
                    Visible = true;
                }
                field("Employee No."; Rec."Employee No.")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                }
                field("Current Category"; Rec."Current Category")
                {
                }
                field("New Category"; Rec."New Category")
                {
                }
                field("Current Job Title Code"; Rec."Current Job Title Code")
                {
                }
                field("Current Job Title"; Rec."Current Job Title")
                {
                }
                field("New Job Title Code"; Rec."New Job Title Code")
                {
                }
                field("New Job Title"; Rec."New Job Title")
                {
                }
                field("Current Directorate"; Rec."Current Directorate")
                {
                }
                field("Current Directorate Name"; Rec."Current Directorate Name")
                {
                }
                field("Current Department"; Rec."Current Department")
                {
                }
                field("New Directorate"; Rec."New Directorate")
                {
                }
                field("New Directorate Name"; Rec."New Directorate Name")
                {
                }
                field("New Department"; Rec."New Department")
                {
                    Caption = 'New Department';
                }
                field("Current Location Code"; Rec."Current Location Code")
                {
                }
                field("Current Location"; Rec."Current Location")
                {
                }
                field("New Location Code"; Rec."New Location Code")
                {
                }
                field("New Location"; Rec."New Location")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Date Of Current Appointment"; Rec."Date Of Current Appointment")
                {
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                }
                field(Remark; Rec.Remark)
                {
                }
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
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
}