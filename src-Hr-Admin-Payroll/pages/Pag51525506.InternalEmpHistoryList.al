page 51525506 "Internal Emp. History List"
{
    ApplicationArea = All;
    Caption = 'Staff Movement List';
    PageType = ListPart;
    SourceTable = "Internal Employement History";
    CardPageId = "Internal Emp. History Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Change Type field.';
                }
                field("First Date"; Rec."First Date")
                {
                    ToolTip = 'Specifies the value of the First Date field.';
                }
                field("Last Date"; Rec."Last Date")
                {
                    ToolTip = 'Specifies the value of the Last Date field.';
                }
                field("Workstation Country"; Rec."Workstation Country")
                {
                    ToolTip = 'Specifies the value of the Workstation Country field.';
                }
                field("Payroll Country"; Rec."Payroll Country")
                {
                    ToolTip = 'Specifies the value of the Payroll Country field.';
                }
                field("Payroll Currency"; Rec."Payroll Currency")
                { }
                field("Contractual Amount Type"; Rec."Contractual Amount Type")
                {
                    Visible = CanEditPaymentInfo;
                }
                field("Contractual Amount Currency"; Rec."Contractual Amount Currency")
                {
                    Visible = CanEditPaymentInfo;
                }
                field("Contractual Amount Value"; Rec."Contractual Amount Value")
                {
                    Visible = CanEditPaymentInfo;
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Terminal Dues"; Rec."Terminal Dues")
                { }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        MovementFieldsEditable := true;
        MovementFieldsTooltip := '';

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
        MovementFieldsEditable := CanEditCard;

        //If has movement entries with one being current, then update these fields there so make them uneditable here
        /*if (Rec."No." <> '') and (CanEditCard) then begin
            MovementRec.Reset();
            MovementRec.SetRange("Emp No.", Rec."No.");
            MovementRec.SetRange(Status, MovementRec.Status::Current);
            if MovementRec.FindFirst() then begin
                MovementFieldsEditable := false;
                MovementFieldsTooltip := 'Update the field on the current/new movement list';
            end;
        end;*/
    end;

    var
        MovementRec: Record "Internal Employement History";
        MovementFieldsEditable: Boolean;
        MovementFieldsTooltip: Text;
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        CanEditPaymentInfo: Boolean;
        CanEditLeaveInfo: Boolean;
}