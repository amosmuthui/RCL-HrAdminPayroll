codeunit 51525312 "Airtime Management Functions"
{
    trigger OnRun()
    begin
        CreateNewMonthBatchIfNotExists(); //Executed by job queue
    end;

    var
        AllocationPeriods: Record "Airtime Allocation Batches";
        AllocationPeriodInit: Record "Airtime Allocation Batches";
        AllocationPeriodsFilter: Record "Airtime Allocation Batches";
        AirtimeServiceProviders: Record "Airtime Service Providers";

    procedure CreateNewMonthBatchIfNotExists()
    begin
        if not CheckIfMonthAllocPeriodExists(Today) then
            CreateNewBatch(CalcDate('-CM', Today), true, true, true);
    end;

    procedure CheckIfMonthAllocPeriodExists(StartDate: Date): Boolean
    begin
        AllocationPeriods.Reset();
        AllocationPeriods.SetRange("Month Start Date", CalcDate('-CM', StartDate), CalcDate('CM', StartDate));
        if AllocationPeriods.FindFirst() then
            exit(true);
        exit(false);
    end;

    procedure CheckIfDayAllocPeriodExists(StartDate: Date): Boolean
    begin
        AllocationPeriods.Reset();
        AllocationPeriods.SetRange("Month Start Date", StartDate);
        if AllocationPeriods.FindFirst() then
            exit(true);
        exit(false);
    end;

    procedure CreateNewBatch(StartDate: Date; NewMonth: Boolean; RefreshAllocations: Boolean; SendNotification: Boolean)
    begin
        if not AllocationPeriods.Get(StartDate) then begin
            AllocationPeriodInit.Reset();
            AllocationPeriodInit.Init();
            AllocationPeriodInit.Validate("Month Start Date", StartDate);
            if not NewMonth then
                NewMonth := not CheckIfMonthAllocPeriodExists(StartDate);
            AllocationPeriodInit."New Month" := NewMonth;

            AirtimeServiceProviders.Reset();
            AirtimeServiceProviders.SetRange(Default, true);
            if AirtimeServiceProviders.FindFirst() then
                AllocationPeriodInit."Service Provider" := AirtimeServiceProviders.Code;

            AllocationPeriodInit.Insert();
        end;

        if RefreshAllocations then
            RefreshAllocations(StartDate);

        if SendNotification then begin
            Commit(); //In case an email error occurs.
            SendNewAirtimePeriodNotification(StartDate);
        end;
    end;

    procedure AddToBatch(StartDate: Date; var AirtimeRequest: Record "Airtime Requests")
    begin
        if AllocationPeriods.Get(StartDate) then begin
            if AirtimeAllocations.Get(StartDate, AirtimeRequest."Emp No.") then begin
                if AirtimeAllocations."Airtime Amount" = 0 then begin
                    AirtimeAllocations.Validate("Emp No.", Emp."No.");
                    AirtimeAllocations.Modify();
                end;
            end else begin
                AirtimeAllocationinit.Init();
                AirtimeAllocationinit.Period := StartDate;
                AirtimeAllocationinit.Validate("Emp No.", AirtimeRequest."Emp No.");
                if AirtimeRequest."Approved Amount" = 0 then
                    AirtimeRequest."Approved Amount" := AirtimeRequest."Applied Amount";
                AirtimeAllocationinit."Airtime Amount" := AirtimeRequest."Approved Amount";
                if AirtimeAllocationinit."Airtime Amount" <> 0 then begin
                    AirtimeAllocationinit.Insert();
                    AirtimeRequest.Processed := true;
                    AirtimeRequest.Modify();
                    Message('Added successfully');
                end else
                    Error('Airtime amount shoudl not be 0!');
            end;
        end;
    end;

    var
        AirtimeAllocations: Record "Airtime Allocations";
        AirtimeAllocationinit: Record "Airtime Allocations";
        Emp: Record Employee;
        Window: Dialog;

    procedure RefreshAllocations(StartDate: Date)
    var
        AllActiveEmps: Integer;
        ProcessedEmps: Integer;
    begin
        ProcessedEmps := 0;
        Emp.Reset();
        Emp.SetRange(Status, Emp.Status::Active);
        Emp.SetFilter("Job Category", '<>%1', '');
        Emp.SetRange("Ineligible for Airtime", false);
        if Emp.FindSet() then begin
            AllActiveEmps := Emp.Count();
            Window.Open('Processing employee: #1######');

            repeat
                ProcessedEmps += 1;
                if AirtimeAllocations.Get(StartDate, Emp."No.") then begin
                    if AirtimeAllocations."Airtime Amount" = 0 then begin
                        AirtimeAllocations.Validate("Emp No.", Emp."No.");
                        AirtimeAllocations.Modify();
                    end;
                end else begin
                    AirtimeAllocationinit.Init();
                    AirtimeAllocationinit.Period := StartDate;
                    AirtimeAllocationinit.Validate("Emp No.", Emp."No.");
                    if AirtimeAllocationinit."Airtime Amount" <> 0 then
                        AirtimeAllocationinit.Insert();
                end;
                Window.Update(1, Format(ProcessedEmps) + ' of ' + Format(AllActiveEmps));
            until Emp.Next() = 0;
            Window.Close();
        end;
    end;

    procedure CreateDateSelection() SelectedDate: Date
    var
        ApplicableDaysDict: Dictionary of [Integer, Integer];
        ApplicableDatesSelectionList: Text;
        SelectedOption: Integer;
        i: Integer;
        OptionNo: Integer;
        LastDay: Integer;
        ThisDate: Date;
    begin
        SelectedDate := 0D;
        SelectedOption := 0;
        ApplicableDatesSelectionList := '';
        Clear(ApplicableDaysDict);
        LastDay := Date2DMY(CalcDate('CM', Today), 1);
        OptionNo := 0;

        for i := 1 to LastDay do begin
            ThisDate := DMY2Date(i, Date2DMY(Today, 2), Date2DMY(Today, 3));
            if not CheckIfDayAllocPeriodExists(ThisDate) then begin
                if ApplicableDatesSelectionList = '' then
                    ApplicableDatesSelectionList := Format(i)
                else
                    ApplicableDatesSelectionList += ',' + Format(i);

                OptionNo += 1;
                ApplicableDaysDict.Add(OptionNo, i);
            end;
        end;

        if ApplicableDatesSelectionList = '' then
            Error('All days of the month have been exhausted!');

        SelectedOption := StrMenu(ApplicableDatesSelectionList, 1, 'Select day of month');
        if SelectedOption = 0 then
            Error('Invalid selection!');

        if ApplicableDaysDict.ContainsKey(SelectedOption) then begin
            ApplicableDaysDict.Get(SelectedOption, i);
            SelectedDate := DMY2Date(i, Date2DMY(Today, 2), Date2DMY(Today, 3));
        end else
            Error('Invalid option!');
    end;

    var
        ServiceProviders: Record "Airtime Service Providers";
        AirtimeAllocationsRpt: Report "Airtime Allocations";

    procedure SendToVendor(StartDate: Date)
    var
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        OutStr: OutStream;
        inStr: InStream;
    begin
        HrSetup.Get();
        if AllocationPeriods.Get(StartDate) then begin
            if not ServiceProviders.Get(AllocationPeriods."Service Provider") then
                Error('Service Provider not found!');
            if ServiceProviders."E-Mail" = '' then
                Error('Please provide the E-Mail address for service provider %1 - %2', ServiceProviders.Code, ServiceProviders.Name);

            emailhdr := AllocationPeriods."Doc No" + '- ' + AllocationPeriods.Description + ' Airtime Allocation';
            emailbody := 'Dear ' + ServiceProviders.Name + ',<br><br>';
            emailbody := emailbody + 'Please find attached the airtime allocation list batch <strong>' + AllocationPeriods."Doc No" + '</strong>.';
            emailbody := emailbody + ' Kindly go ahead and recharge the airtime to the staff then update us when done.';
            emailbody := emailbody + '<p>If you have any concerns or clarifications kindly reach out to us via <b>' + HrSetup."Airtime Mgmt E-Mail" + '</b>. <p>';
            emailbody := emailbody + 'Kind Regards<br><br>';

            EmailMessage.Create(ServiceProviders."E-Mail", emailhdr, emailbody, true);

            AllocationPeriodsFilter.SetRange("Month Start Date", StartDate);
            TempBlob.CreateOutStream(OutStr, TEXTENCODING::UTF8);
            RecRef.GetTable(AllocationPeriodsFilter);
            REPORT.SAVEAS(REPORT::"Airtime Allocations", '', REPORTFORMAT::Pdf, OutStr, RecRef);
            TempBlob.CreateInStream(inStr);
            EmailMessage.AddAttachment(AllocationPeriods."Doc No" + ' Airtime Allocation.pdf', 'application/pdf', inStr);

            EmailMessage.AddRecipient(Enum::"Email Recipient Type"::Cc, HrSetup."Airtime Mgmt E-Mail");//CC the others
            SecondaryEmailRecipients.Reset();
            SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Airtime Notifications");
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
                AllocationPeriods."Sent to Vendor" := true;
                AllocationPeriods."Sent to Vendor By" := UserId;
                AllocationPeriods."DateTime Sent to Vendor" := CurrentDateTime;
                AllocationPeriods.Closed := true;
                AllocationPeriods.Modify();

                AirtimeAllocations.Reset();
                AirtimeAllocations.SetRange(Period, AllocationPeriods."Month Start Date");
                AirtimeAllocations.ModifyAll("Sent to Vendor", true);
                Message('Batch sent successfully!');
            end else
                Error('There was an error. Please try again or contact the Administrator!');
        end;
    end;

    var

        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        HrSetup: Record "Human Resources Setup";
        SecondaryEmailRecipients: Record "Secondary Email Recipients";
        emailbody: Text;
        emailhdr: Text;

    procedure SendNewAirtimePeriodNotification(StartDate: Date)
    var
        Body: Text;
    begin
        if HrSetup.Get() and (HrSetup."Airtime Mgmt E-Mail" <> '') then begin
            Body := 'Greetings,<br>';
            Body += 'The airtime allocation batch for this month has been created.<br>';
            Body += 'Please login to the ERP to review and send it for approval.<br><br>.';
            Body += 'Best Regards.';

            EmailMessage.Create(HrSetup."Airtime Mgmt E-Mail", Format(StartDate, 0, '<Month Text> <Year4>') + 'Airtime Allocation', Body, true);

            //CC the others
            SecondaryEmailRecipients.Reset();
            SecondaryEmailRecipients.SetRange("Document Type", SecondaryEmailRecipients."Document Type"::"Airtime Notifications");
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

            EmailMessage.AppendToBody('<br><br><em>This is a system generated email. Please do not reply.</em>');
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        end;
    end;

}
