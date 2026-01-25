page 52211529 "Hotel Booking Request"
{
    ApplicationArea = All;
    Caption = 'Hotel Booking Request';
    PageType = Card;
    SourceTable = "Hotel Booking Requests";

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
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.', Comment = '%';
                }
                field("Country Name"; Rec."Country Name")
                { }
                field("Hotel Code"; Rec."Hotel Code")
                {
                    ToolTip = 'Specifies the value of the Hotel Code field.', Comment = '%';
                }
                field("Hotel Name"; Rec."Hotel Name")
                {
                    ToolTip = 'Specifies the value of the Hotel Name field.', Comment = '%';
                }
                field("Check-in Date"; Rec."Check-in Date")
                {
                    ToolTip = 'Specifies the value of the Check-in Date field.', Comment = '%';
                }
                field("Check-out Date"; Rec."Check-out Date")
                {
                    ToolTip = 'Specifies the value of the Check-out Date field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                    MultiLine = true;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("Reservation Status"; Rec."Reservation Status")
                {
                    ToolTip = 'Specifies the value of the Reservation Status field.', Comment = '%';
                }
            }
            part(Travellers; "Hotel Booking Lines")
            {
                SubPageLink = "Request No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ReservationReport)
            {
                Caption = 'Reservation Details';
                Image = DepositSlip;

                trigger OnAction()
                var
                    HotelBookingRequests: Record "Hotel Booking Requests";
                begin
                    HotelBookingRequests.Reset;
                    HotelBookingRequests.SetRange("No.", Rec."No.");
                    if HotelBookingRequests.Find('-') then begin
                        REPORT.Run(Report::"Hotel Reservations", true, true, HotelBookingRequests);
                    end;
                end;
            }
            action("Send Approval Request")
            {
                Image = Approve;

                trigger OnAction()
                begin
                    Rec.TestField("Hotel Code");
                    Rec.TestField("Country Code");
                    Rec.TestField("Check-in Date");
                    Rec.TestField("Check-out Date");
                    Rec.CalcFields("No. of Travelers");
                    if Rec."No. of Travelers" = 0 then
                        Error('There must be at least one traveller!');

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


            action("Send Reservation Email")
            {
                Image = SendEmailPDF;
                ApplicationArea = All;
                Caption = 'Send Reservation Email';

                trigger OnAction()
                begin
                    if Rec."Approval Status" <> Rec."Approval Status"::Released then
                        Error('The request must be approved first!');
                    if Confirm('Are you sure you want to send the reservation request to the hotel?') then begin
                        HotelManagementFunctions.SendReservationEmail(Rec."No.", 0);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Mark as Reserved")
            {
                Image = Reserve;
                ApplicationArea = All;
                Caption = 'Mark as Reserved';


                trigger OnAction()
                begin
                    if Rec."Approval Status" <> Rec."Approval Status"::Released then
                        Error('The request must be approved first!');
                    if Confirm('Are you sure this request has been reserved?') then begin
                        HotelManagementFunctions.UpdateReservationStatus(Rec."No.", 0);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Send Reservation Cancellation")
            {
                Image = SendEmailPDFNoAttach;
                ApplicationArea = All;
                Caption = 'Send Reservation Cancellation';

                trigger OnAction()
                begin
                    if Rec."Approval Status" <> Rec."Approval Status"::Released then
                        Error('The request must be approved first!');
                    if Confirm('Are you sure you want to cancel this reservation?') then begin
                        HotelManagementFunctions.SendReservationEmail(Rec."No.", 1);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Mark as Cancelled")
            {
                Image = CancelAttachment;
                ApplicationArea = All;
                Caption = 'Mark as Cancelled';

                trigger OnAction()
                begin
                    if Rec."Approval Status" <> Rec."Approval Status"::Released then
                        Error('The request must be approved first!');
                    if Confirm('Are you sure this reservation has been cancelled?') then begin
                        HotelManagementFunctions.UpdateReservationStatus(Rec."No.", 1);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }


        area(Promoted)
        {
            group(Home)
            {
                actionref("ReservationReportPromoted"; ReservationReport) { }
            }
            group(Approval)
            {
                actionref("Send Approval Request Promoted"; "Send Approval Request") { }
                actionref("Cancel Approval Request Promoted"; "Cancel Approval Request") { }
                actionref("Approval Entries Promoted"; "Approval Entries") { }
            }
            group(Reservation)
            {
                actionref("Send Reservation Email Promoted"; "Send Reservation Email") { }
                actionref("Mark as Reserved Promoted"; "Mark as Reserved") { }
                actionref("Send Reservation Cancellation Promoted"; "Send Reservation Cancellation") { }
                actionref("Mark as Cancelled Promoted"; "Mark as Cancelled") { }
            }
        }
    }

    var
        HotelManagementFunctions: Codeunit "Hotel Management Functions";
        VarVariant: Variant;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";

    trigger OnOpenPage()
    begin
        if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
            CurrPage.Editable(false);
    end;
}
