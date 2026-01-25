page 52211539 "Room Booking Card"
{
    ApplicationArea = All;
    Caption = 'Room Booking Card';
    PageType = Card;
    SourceTable = "Room Booking Requests";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Requested By Emp No."; Rec."Requested By Emp No.")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp No. field.', Comment = '%';
                }
                field("Requested By Emp Name"; Rec."Requested By Emp Name")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp Name field.', Comment = '%';
                }
                field("Room No."; Rec."Room No.")
                {
                    ToolTip = 'Specifies the value of the Room No. field.', Comment = '%';
                }
                field("Name/Tag"; Rec."Name/Tag")
                {
                    ToolTip = 'Specifies the value of the Name/Tag field.', Comment = '%';
                }
                field("From DateTime"; Rec."From DateTime")
                { }
                field("To DateTime"; Rec."To DateTime")
                { }
                field("Intended Users Description"; Rec."Intended Users Description")
                {
                    ToolTip = 'Specifies the value of the Intended Users Description field.', Comment = '%';
                    MultiLine = true;
                }
                field("No. of Users"; Rec."No. of Users")
                {
                    ToolTip = 'Specifies the value of the No. of Users field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                    MultiLine = true;
                }
                field("Approval Status"; Rec."Approval Status")
                { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RoomDetails)
            {
                Caption = 'Room Details';
                Image = ViewDetails;
                Enabled = Rec."Room No." <> '';

                trigger OnAction()
                var
                    Rooms: Record Rooms;
                begin
                    Rooms.Reset;
                    Rooms.SetRange("No.", Rec."Room No.");
                    if Rooms.Find('-') then begin
                        Page.Run(Page::"Room Card");
                    end;
                end;
            }
            action("Send Approval Request")
            {
                Image = Approve;

                trigger OnAction()
                begin
                    Rec.TestField("From DateTime");
                    Rec.TestField("To DateTime");
                    Rec.TestField("Room No.");
                    Rec.TestField(Purpose);

                    VarVariant := Rec;

                    if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
                        Error('Document Status has to be open');
                    if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                        CustomApprovals.OnSendDocForApproval(VarVariant);

                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;

                trigger OnAction()
                begin
                    if Rec."Approval Status" <> Rec."Approval Status"::Released then begin
                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);
                    end;
                    // ApprovalsMgmt.OnCancelPVApprovalRequest(Rec);
                end;
            }
            action("Approval Entries")
            {
                Image = Approvals;
                RunPageMode = View;

                trigger OnAction()
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
                end;
            }
        }


        area(Promoted)
        {
            group(Home)
            {
                actionref("RoomDetailsPromoted"; RoomDetails) { }
            }
            group(Approval)
            {
                actionref("Send Approval Request Promoted"; "Send Approval Request") { }
                actionref("Cancel Approval Request Promoted"; "Cancel Approval Request") { }
                actionref("Approval Entries Promoted"; "Approval Entries") { }
            }
        }
    }
    var
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";

    trigger OnOpenPage()
    begin
        if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
            CurrPage.Editable(false);
    end;
}
