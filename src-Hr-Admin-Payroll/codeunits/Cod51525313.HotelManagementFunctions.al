codeunit 51525313 "Hotel Management Functions"
{

    var
        Hotels: Record Hotels;
        AirtimeAllocationsRpt: Report "Airtime Allocations";

        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        HrSetup: Record "Human Resources Setup";
        SecondaryEmailRecipients: Record "Secondary Email Recipients";
        emailbody: Text;
        emailhdr: Text;
        HotelBookingRequests: Record "Hotel Booking Requests";
        HotelBookingRequestFilter: Record "Hotel Booking Requests";
        Window: Dialog;

    procedure SendReservationEmail(RequestNo: Code[20]; Action: Option Reserve,Cancel)
    var
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        OutStr: OutStream;
        inStr: InStream;
    begin
        HrSetup.Get();
        if HotelBookingRequests.Get(RequestNo) then begin
            if not Hotels.Get(HotelBookingRequests."No.") then
                Error('Hotel not found');
            if (Hotels."Contact Person Name" = '') or (Hotels."Contact Person E-Mail" = '') then
                Error('Kindly define the hotel''s contact person and their E-Mail address!');

            HotelBookingRequests.CalcFields("No. of Travelers");
            emailhdr := 'Hotel Reservation - ' + HotelBookingRequests."No.";
            emailbody := 'Dear ' + Hotels."Contact Person Name" + ',<br><br>';
            emailbody := emailbody + 'Please make a reservation for <strong>' + Format(HotelBookingRequests."No. of Travelers") + '</strong> persons from date <strong>' + Format(HotelBookingRequests."Check-in Date") + '</strong> to date <strong>' + Format(HotelBookingRequests."Check-out Date") + '</strong>.';
            emailbody := emailbody + ' Kindly check the attached document for more details.';
            if Action = Action::Cancel then begin
                emailhdr := 'Hotel Reservation - ' + HotelBookingRequests."No." + ' - Cancellation';
                emailbody := 'Dear ' + Hotels."Contact Person Name" + ',<br><br>';
                emailbody := emailbody + 'Please cancel the reservation that was made earlier from date <strong>' + Format(HotelBookingRequests."Check-in Date") + '</strong> to date <strong>' + Format(HotelBookingRequests."Check-out Date") + '</strong>.';
                emailbody := emailbody + ' Kindly check the attached document for more details about the reservation.';
            end;
            emailbody := emailbody + '<p>If you have any concerns or clarifications kindly reach out to us via <b>' + HrSetup."Hotel Mgmt E-Mail" + '</b>. <p>';
            emailbody := emailbody + 'Kind Regards<br><br>';

            EmailMessage.Create(Hotels."Contact Person E-Mail", emailhdr, emailbody, true);

            HotelBookingRequestFilter.SetRange("No.", RequestNo);
            TempBlob.CreateOutStream(OutStr, TEXTENCODING::UTF8);
            RecRef.GetTable(HotelBookingRequestFilter);
            REPORT.SAVEAS(REPORT::"Hotel Reservations", '', REPORTFORMAT::Pdf, OutStr, RecRef);
            TempBlob.CreateInStream(inStr);
            EmailMessage.AddAttachment(HotelBookingRequests."No." + ' - Hotel Reservation.pdf', 'application/pdf', inStr);

            if HrSetup."Hotel Mgmt E-Mail" <> '' then
                EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, HrSetup."Hotel Mgmt E-Mail");
            SecondaryEmailRecipients.Reset();
            SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Hotel Mgmt Notifications");
            SecondaryEmailRecipients.SetFilter("E-mail", '<>%1', '');
            if SecondaryEmailRecipients.FindSet() then
                repeat
                    Window.update(1, SecondaryEmailRecipients.Name);
                    if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::"Send to" then
                        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::"To", DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                    if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::cc then
                        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                    if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::bcc then
                        EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Bcc, DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                until SecondaryEmailRecipients.next() = 0;

            if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
                HotelBookingRequests."Reservation Email Sent" := true;
                HotelBookingRequests.Modify();
                if Action = Action::Reserve then
                    Message('Reservation sent successfully!\Remember to mark this request as reserved as soon as you get confirmation from the hotel.')
                else
                    Message('Reservation cancellation email sent successfully!\Remember to mark this request as cancelled as soon as you get confirmation from the hotel.');
            end else
                Error('There was an error. Please try again or contact the Administrator!');
        end;
    end;

    var
        Emp: Record Employee;

    procedure UpdateReservationStatus(RequestNo: Code[20]; Action: Option Reserve,Cancel)
    var
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        OutStr: OutStream;
        inStr: InStream;
    begin
        if HotelBookingRequests.Get(RequestNo) then begin
            if Emp.Get(HotelBookingRequests."Requested By Emp No.") and (Emp."Company E-Mail" <> '') then begin
                emailbody := 'Dear ' + HotelBookingRequests."Requested By Emp Name" + ',<br><br>';
                emailhdr := 'Hotel Reservation - ' + HotelBookingRequests."No." + ' - Reserved';
                emailbody := emailbody + 'Your hotel booking request number <strong>' + Format(HotelBookingRequests."No.") + '</strong> has been reserved from date <strong>' + Format(HotelBookingRequests."Check-in Date") + '</strong> to date <strong>' + Format(HotelBookingRequests."Check-out Date") + '</strong>.';
                emailbody := emailbody + ' Kindly prepare accordingly.';
                if Action = Action::Cancel then begin
                    emailbody := 'Dear ' + HotelBookingRequests."Requested By Emp Name" + ',<br><br>';
                    emailhdr := 'Hotel Reservation - ' + HotelBookingRequests."No." + ' - Cancelled';
                    emailbody := emailbody + 'Your hotel reservation number <strong>' + Format(HotelBookingRequests."No.") + '</strong> has been cancelled.';
                end;
                emailbody := emailbody + '<p>If you have any concerns or clarifications kindly reach out to <b>' + HrSetup."Hotel Mgmt E-Mail" + '</b>. <p>';
                emailbody := emailbody + 'Kind Regards<br><br>';

                EmailMessage.Create(Emp."Company E-Mail", emailhdr, emailbody, true);

                if HrSetup."Hotel Mgmt E-Mail" <> '' then
                    EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, HrSetup."Hotel Mgmt E-Mail");
                SecondaryEmailRecipients.Reset();
                SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Hotel Mgmt Notifications");
                SecondaryEmailRecipients.SetFilter("E-mail", '<>%1', '');
                if SecondaryEmailRecipients.FindSet() then
                    repeat
                        Window.update(1, SecondaryEmailRecipients.Name);
                        if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::"Send to" then
                            EmailMessage.AddRecipient(Enum::"Email Recipient Type"::"To", DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                        if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::cc then
                            EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                        if SecondaryEmailRecipients.Category = SecondaryEmailRecipients.Category::bcc then
                            EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Bcc, DelChr(SecondaryEmailRecipients."E-mail", '<>'));
                    until SecondaryEmailRecipients.next() = 0;

                if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then begin
                    if Action = Action::Reserve then
                        HotelBookingRequests."Reservation Status" := HotelBookingRequests."Reservation Status"::Reserved
                    else
                        HotelBookingRequests."Reservation Status" := HotelBookingRequests."Reservation Status"::Cancelled;
                    HotelBookingRequests.Modify();
                    Message('Reservation status updated successfully!');
                end else
                    Error('There was an error. Please try again or contact the Administrator!');
            end;
        end;
    end;
}
