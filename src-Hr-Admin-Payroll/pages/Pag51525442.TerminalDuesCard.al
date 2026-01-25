page 51525442 "Terminal Dues Card"
{
    ApplicationArea = All;
    Caption = 'Terminal Dues Card';
    PageType = Card;
    SourceTable = "Terminal Dues Header";
    PromotedActionCategories = 'New,Process,Report,Approval Request';

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
                field("WB No."; Rec."WB No.")
                {
                    ToolTip = 'Specifies the value of the WB No. field.', Comment = '%';
                }
                field("Full Name"; Rec."Full Name")
                {
                    ToolTip = 'Specifies the value of the Full Name field.', Comment = '%';
                }
                field(Position; Rec.Position)
                {
                    ToolTip = 'Specifies the value of the Position field.', Comment = '%';
                }
                field("RSSB No."; Rec."RSSB No.")
                {
                    ToolTip = 'Specifies the value of the RSSB No. field.', Comment = '%';
                }
                field(Bank; Rec.Bank)
                {
                    ToolTip = 'Specifies the value of the Bank field.', Comment = '%';
                }
                field("Bank Account No."; Rec."Bank Account No.")
                { }
                field("Swift Code"; Rec."Swift Code")
                { }
                field("Payroll Country"; Rec."Payroll Country")
                { }
                field("Payroll Currency"; Rec."Payroll Currency")
                { }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.', Comment = '%';
                }
                field("Join Date"; Rec."Join Date")
                {
                    ToolTip = 'Specifies the value of the Join Date field.', Comment = '%';
                }
                field("Exit Date"; Rec."Exit Date")
                {
                    ToolTip = 'Specifies the value of the Exit Date field.', Comment = '%';
                }
                field("Separation Reason"; Rec."Separation Reason")
                {
                    ToolTip = 'Specifies the value of the Separation Reason field.', Comment = '%';
                }
                field("Notice Period"; Rec."Notice Period")
                { }
                field("Notice Given"; Rec."Notice Given")
                { }
                field("Notice Days Given"; Rec."Notice Days Given")
                { }
                field("Date Processed"; Rec."Date Processed")
                { }
                field("Fixed Processing Date"; Rec."Fixed Processing Date")
                { }
                group(Exclude)
                {
                    Caption = 'Exclude mileage and accommodation allowances from untaken leave days amount computation';
                    field("Exclude Mileage &Accommodation"; Rec."Exclude Mileage &Accommodation")
                    {
                        Caption = 'Exclude';
                    }
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Created On"; Rec."Created On")
                {
                    ToolTip = 'Specifies the value of the Created On field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
            }

            group("USD Exchange Rate")
            {
                field("Exchange Rate"; Rec."Exchange Rate")
                { }
            }
            group("Final Contractual Amount")
            {
                field("Contractual Amount Type"; Rec."Contractual Amount Type")
                { }
                field("Contractual Amount Currency"; Rec."Contractual Amount Currency")
                { }
                field("Contractual Amount"; Rec."Contractual Amount")
                { }
                field("Gross Salary"; Rec."Gross Salary")
                {
                    Editable = false;
                }
                field("Period Processed"; Rec."Period Processed")
                {
                    Visible = true;
                    Editable = false;
                }
                field("Final Month of Service"; Rec."Final Month of Service")
                { }
                field("Days in Month"; Rec."Days in Month")
                { }
                field("Total Final Dues"; Rec."Total Final Dues")
                {
                    Editable = false;
                }
                field("Taxable Final Dues"; Rec."Taxable Final Dues")
                {
                    Editable = false;
                }
                field("Total Deductions"; Rec."Total Deductions")
                {
                    Editable = false;
                }
                field(Balance; Rec.Balance)
                {
                    Editable = false;
                }
            }
            group("Entitled To")
            {
                field("Unpaid Worked Days"; Rec."Unpaid Worked Days")
                {
                    ToolTip = 'Specifies the value of the Unpaid Worked Days field.', Comment = '%';
                }
                field("Untaken Leave Days"; Rec."Untaken Leave Days")
                {
                    ToolTip = 'Specifies the value of the Untaken Leave Days field.', Comment = '%';
                }
                field("Total Entitled Days"; Rec.GetTotalEntitledDays)
                { }
            }
            part("Additional Entitled To"; "Additional Entitled To")
            {
                SubPageLink = "Header No." = FIELD("No.");
            }
            part("Salary Structure"; "Terminal Dues Salary Structure")
            {
                SubPageLink = "Header No." = FIELD("No.");
            }
            part("Lines"; "Terminal Dues Lines")
            {
                SubPageLink = "Header No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TDReport)
            {
                Caption = 'FD Report';
                Image = DepositSlip;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                    periodrec: Record "Payroll Period";
                    AssMatrix: Record "Assignment Matrix";
                    AssMatrix1: Record "Assignment Matrix";
                    AssMatrix2: Record "Assignment Matrix";
                    LastPeriod: Date;
                    FinalDuesRec: Record "Terminal Dues Header";
                begin
                    FinalDuesRec.Reset;
                    FinalDuesRec.SetRange("No.", Rec."No.");
                    if FinalDuesRec.Find('-') then begin
                        REPORT.Run(Report::"Final Dues Report", true, true, FinalDuesRec);
                    end;
                end;
            }
            action("FD Run")
            {
                Caption = 'Process Dues';
                Image = PaymentPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = ((Rec."Approval Status" = Rec."Approval Status"::Open) or (Rec."Approval Status" = Rec."Approval Status"::Rejected));

                trigger OnAction()
                var
                    periodrec: Record "Payroll Period";
                    PayProcessHeader: Record "Payroll Processing Header";
                    PayrollRunReport: Report "Payroll Run";
                begin
                    //if Rec.GetTotalEntitledDays <= 0 then
                    //Error('You can only proceed with the total entied days are greater than 0. Now the total is %1', Rec.GetTotalEntitledDays);

                    if Rec."Exchange Rate" = 0 then begin
                        if Rec."Date Processed" = 0D then
                            Rec."Date Processed" := Today;
                        Rec."Exchange Rate" := GetInDesiredCurrency(Rec."Payroll Currency", 'USD', 0, Rec."Date Processed");
                        //"Exchange Rate" := 1;
                        if Rec."Exchange Rate" < 1 then
                            Rec."Exchange Rate" := 1 / Rec."Exchange Rate";
                    end;
                    ExchangeRate := Rec."Exchange Rate";
                    AssingmentMatrix.Reset();
                    AssingmentMatrix.SetRange("Employee No", Rec."WB No.");
                    AssingmentMatrix.SetRange("Payroll Period", periodrec."Starting Date");
                    AssingmentMatrix.SetRange("Exclude from Payroll", false);
                    AssingmentMatrix.SetRange("Exclude from Calculations", false);
                    if AssingmentMatrix.FindFirst() then
                        Error('This staff has payroll transactions for this month/period. You cannot process ' + Format(Rec.Type) + ' in the same period with normal payroll for an employee!');

                    if not Confirm('Are you sure you want to process ' + Format(Rec.Type) + ' ? Existing transaction records will be overwritten.') then
                        Error('Process terminated successfully!');

                    periodrec.Reset;
                    periodrec.SetRange(periodrec.Closed, false);
                    if periodrec.FindLast then begin

                        EmpRec.Reset();
                        EmpRec.SetRange("No.", Rec."WB No.");
                        if EmpRec.FindFirst() then begin
                            if EmpRec.Status <> EmpRec.Status::Inactive then
                                Error('You can only process  ' + Format(Rec.Type) + ' for inactive staff!');
                            EmpRec.Status := EmpRec.Status::Active; //Temporarily
                            EmpRec."Under Terminal Dues Processing" := true;
                            EmpRec.Modify();
                        end;

                        TempContAmountCurrency := '';
                        TempPayrollCurrency := '';
                        TempContAmountCurrency := '';
                        TempFirstDate := 0D;
                        TempLastDate := 0D;
                        TempContAmountVal := 0;
                        if Rec."Exit Date" = 0D then
                            Error('You must specify the exit date!');
                        MonthFirstDate := CalcDate('-CM', periodrec."Starting Date");
                        MonthLastDate := CalcDate('CM', periodrec."Starting Date");
                        if (not Rec."Fixed Processing Date") or (Rec."Date Processed" = 0D) then
                            Rec."Date Processed" := Today;
                        //NoOfDays := (MonthLastDate - MonthFirstDate) + 1;
                        Rec.Validate("Final Month");
                        NoOfDays := Rec."Days in Month";
                        EmpMovement.Reset();
                        EmpMovement.SetRange("Emp No.", Rec."WB No.");
                        EmpMovement.SetRange(Status, EmpMovement.Status::Current);
                        if EmpMovement.FindFirst() then begin
                            TempPayrollCurrency := EmpMovement."Payroll Currency";
                            TempPayCountry := EmpMovement."Payroll Country";
                            TempContAmountCurrency := EmpMovement."Contractual Amount Currency";
                            TempContAmountType := EmpMovement."Contractual Amount Type";
                            TempContAmountVal := EmpMovement."Contractual Amount Value";
                            TempFirstDate := EmpMovement."First Date";
                            TempLastDate := EmpMovement."Last Date";

                            EmpMovement."Payroll Country" := Rec."Payroll Country";
                            EmpMovement."Payroll Currency" := Rec."Payroll Currency";
                            EmpMovement."Contractual Amount Type" := Rec."Contractual Amount Type";
                            EmpMovement."Contractual Amount Currency" := Rec."Contractual Amount Currency";
                            EmpMovement."Contractual Amount Value" := Rec."Contractual Amount";
                            EmpMovement."First Date" := MonthFirstDate;
                            EmpMovement."Last Date" := MonthLastDate;
                            EmpMovement.Modify();
                        end;

                        //Compute payroll for full month to create salary structure
                        EmpRec.Reset();
                        EmpRec.SETRANGE(EmpRec."No.", Rec."WB No.");
                        EmpRec.SetRange("Payroll Country", Rec."Payroll Country");
                        PayrollRunReport.SETTABLEVIEW(EmpRec);//Set the dataitem filters
                        PayrollRunReport.SetReportFilter(periodrec."Starting Date", Rec."WB No.");//Set the request page filters
                        //PayrollRunReport.RUN;
                        PayrollRunReport.UseRequestPage := false; // Run without showing the request page
                        PayrollRunReport.RunModal();

                        TerminalDuesLines.Reset();
                        TerminalDuesLines.SetRange("Header No.", Rec."No.");
                        TerminalDuesLines.SetRange("System Entry", true);
                        if TerminalDuesLines.Find('-') then
                            TerminalDuesLines.DeleteAll();


                        DesiredCurrency := Rec."Payroll Currency";
                        Rec."Period Processed" := periodrec."Starting Date";
                        //Perform currency exchange for any existing lines
                        TerminalDuesLines.Reset();
                        TerminalDuesLines.SetRange("Header No.", Rec."No.");
                        if TerminalDuesLines.FindSet() then
                            repeat
                                //ExchangeRate := GetInDesiredCurrency(TerminalDuesLines.Currency, DesiredCurrency, 0, Rec."Date Processed");
                                if TerminalDuesLines."Amount (FCY)" = 0 then
                                    TerminalDuesLines."Amount (FCY)" := TerminalDuesLines.Amount;
                                TerminalDuesLines."Payroll Currency" := Rec."Payroll Currency";
                                if TerminalDuesLines.Currency = 'USD' then
                                    TerminalDuesLines.Amount := TerminalDuesLines."Amount (FCY)" * ExchangeRate;
                                if (TerminalDuesLines.Currency <> 'USD') and (TerminalDuesLines.Currency <> Rec."Payroll Currency") then
                                    TerminalDuesLines.Amount := TerminalDuesLines."Amount (FCY)" * GetInDesiredCurrency(TerminalDuesLines.Currency, Rec."Payroll Currency", 0, Rec."Date Processed");
                                if TerminalDuesLines."Trans Type" = TerminalDuesLines."Trans Type"::Deduction then begin
                                    TerminalDuesLines."Amount (FCY)" := -Abs(TerminalDuesLines."Amount (FCY)");
                                    TerminalDuesLines.Amount := -Abs(TerminalDuesLines.Amount);
                                end;
                                TerminalDuesLines."Period Processed" := Rec."Period Processed";
                                TerminalDuesLines.Modify();
                            until TerminalDuesLines.Next() = 0;

                        SalaryStructure.Reset();
                        SalaryStructure.SetRange("Header No.", Rec."No.");
                        SalaryStructure.SetRange("System Entry", true);
                        if SalaryStructure.Find('-') then
                            SalaryStructure.DeleteAll();

                        LineNo := 0;
                        SalaryStructure.Reset();
                        SalaryStructure.SetCurrentKey("Line No.");
                        SalaryStructure.SetAscending("Line No.", true);
                        if SalaryStructure.FindLast() then
                            LineNo := SalaryStructure."Line No.";

                        //Pick the 30-day payroll transactions to now create the salary structure
                        AssingmentMatrix.Reset();
                        AssingmentMatrix.SetRange("Employee No", Rec."WB No.");
                        AssingmentMatrix.SetRange("Payroll Period", periodrec."Starting Date");
                        AssingmentMatrix.SetRange("Non-Cash Benefit", false);
                        AssingmentMatrix.SetRange("Tax Relief", false);
                        AssingmentMatrix.SetRange(Type, AssingmentMatrix.Type::Payment);
                        AssingmentMatrix.SetRange("Exclude from Payroll", false);
                        if AssingmentMatrix.FindSet() then
                            repeat
                                LineNo += 1;
                                SalaryStructure.Reset();
                                SalaryStructure.Init();
                                SalaryStructure."Header No." := Rec."No.";
                                SalaryStructure."Line No." := LineNo;
                                SalaryStructure.Currency := Rec."Payroll Currency";
                                SalaryStructure."Amount (FCY)" := AssingmentMatrix.Amount;
                                SalaryStructure.Amount := AssingmentMatrix.Amount;
                                SalaryStructure.Description := AssingmentMatrix.Description;
                                SalaryStructure."Is Basic" := AssingmentMatrix."Basic Salary Code";
                                SalaryStructure."Is House" := AssingmentMatrix."Housing Allowance";
                                SalaryStructure."Is Transport" := AssingmentMatrix."Transport Allowance";
                                SalaryStructure."Period Processed" := Rec."Period Processed";
                                SalaryStructure."System Entry" := true;
                                SalaryStructure."Payroll Currency" := Rec."Payroll Currency";
                                SalaryStructure.Insert(true)
                            until AssingmentMatrix.Next() = 0;

                        //We have the salary structure, now let us list the unpaid working days amounts
                        LineNo := 0;
                        TerminalDuesLines.Reset();
                        TerminalDuesLines.SetCurrentKey("Line No.");
                        TerminalDuesLines.SetAscending("Line No.", true);
                        if TerminalDuesLines.FindLast() then
                            LineNo := TerminalDuesLines."Line No.";


                        MileagePlusAccommodation := 0;
                        SalaryStructure.Reset();
                        SalaryStructure.SetCurrentKey("System Entry");
                        SalaryStructure.SetAscending("System Entry", false);
                        SalaryStructure.SetRange("Header No.", Rec."No.");
                        if SalaryStructure.FindSet() then
                            repeat
                                if SalaryStructure."Amount (FCY)" = 0 then
                                    SalaryStructure."Amount (FCY)" := SalaryStructure.Amount;
                                if SalaryStructure.Currency = '' then
                                    SalaryStructure.Currency := Rec."Payroll Currency";
                                // := GetInDesiredCurrency(SalaryStructure.Currency, DesiredCurrency, 0, Rec."Date Processed");
                                if SalaryStructure.Currency = 'USD' then
                                    SalaryStructure.Amount := SalaryStructure."Amount (FCY)" * ExchangeRate
                                else if (SalaryStructure.Currency <> 'USD') and (SalaryStructure.Currency <> Rec."Payroll Currency") then
                                    SalaryStructure.Amount := SalaryStructure."Amount (FCY)" * GetInDesiredCurrency(SalaryStructure.Currency, Rec."Payroll Currency", 0, Rec."Date Processed")
                                else
                                    SalaryStructure.Amount := SalaryStructure."Amount (FCY)";
                                //Message('Desc %1 | Curr %2 | DesCurr %3 | EchangeRate %4 | AmtFCY %5 | Amt %6', SalaryStructure.Description, SalaryStructure.Currency, DesiredCurrency, ExchangeRate, SalaryStructure."Amount (FCY)", SalaryStructure.Amount);
                                SalaryStructure."Period Processed" := Rec."Period Processed";
                                SalaryStructure."Payroll Currency" := Rec."Payroll Currency";
                                if (StrPos(UpperCase(SalaryStructure.Description), 'MILEAGE') <> 0) or (StrPos(UpperCase(SalaryStructure.Description), 'ACCOMODATION') <> 0) or (StrPos(UpperCase(SalaryStructure.Description), 'ACCOMMODATION') <> 0) then
                                    MileagePlusAccommodation += SalaryStructure.Amount;
                                LineNo += 1;
                                WorkingAmount := (SalaryStructure.Amount / NoOfDays) * Rec."Unpaid Worked Days";
                                Descr := Format(Rec."Unpaid Worked Days") + ' day(s)'' ' + SalaryStructure.Description + ' for ' + Rec."Final Month of Service";
                                if Rec."Unpaid Worked Days" <> 0 then
                                    InsertTerminalDueLine(LineNo, true, true,/*SalaryStructure.Currency*/Rec."Payroll Currency", Descr, WorkingAmount, SalaryStructure."Is Basic", SalaryStructure."Is Transport", SalaryStructure."Is House");
                                SalaryStructure.Modify();
                            until SalaryStructure.Next() = 0;

                        Rec.CalcFields("Gross Salary");
                        //Add unpaid leave days
                        if Rec."Untaken Leave Days" <> 0 then begin
                            LineNo += 1;
                            WorkingAmount := (Rec."Gross Salary" / /*NoOfDays*/30) * Rec."Untaken Leave Days";
                            if Rec."Exclude Mileage &Accommodation" then begin
                                WorkingAmount := ((Rec."Gross Salary" - MileagePlusAccommodation) / 30) * Rec."Untaken Leave Days";
                            end;
                            Descr := Format(Rec."Untaken Leave Days") + ' day(s) of untaken leave';
                            InsertTerminalDueLine(LineNo, true, true, Rec."Payroll Currency", Descr, WorkingAmount, false, false, false);
                        end;

                        //Let's add the dynamic entitled tos
                        AdditionalEntitledTos.Reset();
                        AdditionalEntitledTos.SetRange("Header No.", Rec."No.");
                        if AdditionalEntitledTos.FindSet() then
                            repeat
                                LineNo += 1;
                                WorkingAmount := 0;
                                if AdditionalEntitledTos."Divide By" = AdditionalEntitledTos."Divide By"::"Actual Month Days" then
                                    WorkingAmount := (Rec."Gross Salary" / NoOfDays) * AdditionalEntitledTos."No. of Days";
                                if AdditionalEntitledTos."Divide By" = AdditionalEntitledTos."Divide By"::"30 Days" then
                                    WorkingAmount := (Rec."Gross Salary" / 30) * AdditionalEntitledTos."No. of Days";
                                Descr := Format(AdditionalEntitledTos."No. of Days") + ' days'' ' + AdditionalEntitledTos.Description;
                                IsEarningTrans := false;
                                if AdditionalEntitledTos.Action = AdditionalEntitledTos.Action::Add then
                                    IsEarningTrans := true;
                                InsertTerminalDueLine(LineNo, IsEarningTrans, true, Rec."Payroll Currency", Descr, WorkingAmount, true, true, true);
                            until AdditionalEntitledTos.Next() = 0;

                        //Compute deductions now - just manually one by one - PAYE for all, then specific for RWANDA, CABIN, EXPAT
                        Rec.CalcFields("Taxable Final Dues");
                        Rec."Total Social Security" := 0;
                        if (Rec."Gross Salary" <> 0) and (Rec."Taxable Final Dues" > 0) then begin

                            //PAYE = Taxable final dues * 30% | for all
                            LineNo += 1;
                            //ExchangeRate := GetInDesiredCurrency(Rec."Payroll Currency", 'RWF', 0, Rec."Date Processed");
                            TaxableAmountInRwf := 1 * Rec."Taxable Final Dues";
                            PayablePAYE := GetPaye.GetTaxBracket(TaxableAmountInRwf, Rec."Payroll Country"); //check limit
                            //if TaxableAmountInRwf >= 60000 then begin //The 60k should be in RWF
                            if (PayablePAYE > 0) then begin
                                WorkingAmount := Rec."Taxable Final Dues" * (30 / 100);
                                Paye := WorkingAmount;
                                Descr := 'PAYE';
                                InsertTerminalDueLine(LineNo, false, false, Rec."Payroll Currency", Descr, WorkingAmount, false, false, false);
                            end;


                            //The rest now
                            if Rec."Payroll Country" in ['RWANDA', 'CABIN', 'EXPATRIATE'] then begin
                                Rec.CalcFields("Total Basic", "Total House", "Total Transport");
                                //SocialSecurity := (Rec."Taxable Final Dues" - Rec."Total Transport") * (3 / 100);
                                SocialSecurity := Rec."Taxable Final Dues" * (6 / 100);
                                Rec."Total Social Security" := SocialSecurity;
                                Cbhi := (Rec."Taxable Final Dues" - SocialSecurity - Paye) * (0.5 / 100);
                                LineNo += 1;
                                InsertTerminalDueLine(LineNo, false, false, Rec."Payroll Currency", 'Social Security', SocialSecurity, false, false, false);
                                LineNo += 1;
                                InsertTerminalDueLine(LineNo, false, false, Rec."Payroll Currency", 'CBHI', Cbhi, false, false, false);

                                //SocialSecurity := (Rec."Taxable Final Dues" - Rec."Total Transport") * (5 / 100); //Before Jan 2025
                                SocialSecurity := Rec."Taxable Final Dues" * (6 / 100);
                                //For Employer
                                LineNo += 1;
                                InsertTerminalDueLine(LineNo, false, false, Rec."Payroll Currency", 'Social Security Employer', SocialSecurity, false, false, false);
                                LineNo += 1;
                                //OccupationalHazard := (Rec."Taxable Final Dues" - Rec."Total Transport") * (2 / 100);                                
                                OccupationalHazard := (Rec."Taxable Final Dues" - (Rec."Taxable Final Dues" * (34 / 100))) * (2 / 100);
                                Rec."Total Social Security" := Rec."Total Social Security" + SocialSecurity + OccupationalHazard;
                                InsertTerminalDueLine(LineNo, false, false, Rec."Payroll Currency", 'Occupational Hazard Employer', OccupationalHazard, false, false, false);
                            end;

                        end;

                        //Revert stuff
                        EmpRec.Reset();
                        EmpRec.SetRange("No.", Rec."WB No.");
                        if EmpRec.FindFirst() then begin
                            EmpRec.Status := EmpRec.Status::Inactive;
                            EmpRec."Under Terminal Dues Processing" := false;
                            EmpRec.Modify();
                        end;

                        EmpMovement.Reset();
                        EmpMovement.SetRange("Emp No.", Rec."WB No.");
                        EmpMovement.SetRange(Status, EmpMovement.Status::Current);
                        if EmpMovement.FindFirst() then begin
                            EmpMovement."Payroll Country" := TempPayCountry;
                            EmpMovement."Payroll Currency" := TempPayrollCurrency;
                            EmpMovement."Contractual Amount Type" := TempContAmountType;
                            EmpMovement."Contractual Amount Currency" := TempContAmountCurrency;
                            EmpMovement."Contractual Amount Value" := TempContAmountVal;
                            EmpMovement."First Date" := TempFirstDate;
                            EmpMovement."Last Date" := TempLastDate;
                            EmpMovement.Modify();
                        end;

                        AssingmentMatrix.Reset();
                        AssingmentMatrix.SetRange("Employee No", Rec."WB No.");
                        AssingmentMatrix.SetRange("Payroll Period", periodrec."Starting Date");
                        if AssingmentMatrix.Find('-') then
                            AssingmentMatrix.DeleteAll();

                        PeriodPrevailingMovements.Reset();
                        PeriodPrevailingMovements.SetRange("Emp No.", Rec."WB No.");
                        PeriodPrevailingMovements.SetRange("Payroll Period", periodrec."Starting Date");
                        PeriodPrevailingMovements.DeleteAll();

                        CausesOfInactivity.Reset();
                        CausesOfInactivity.SetRange("Emp No.", Rec."WB No.");
                        CausesOfInactivity.SetRange("Payroll Period", periodrec."Starting Date");
                        CausesOfInactivity.DeleteAll();

                        EmpPeriodBankDetails.Reset();
                        EmpPeriodBankDetails.SetRange("Emp No.", Rec."WB No.");
                        EmpPeriodBankDetails.SetRange("Payroll Period", periodrec."Starting Date");
                        EmpPeriodBankDetails.DeleteAll();

                        ExtraPayrollBanks.Reset();
                        ExtraPayrollBanks.SetRange("Payroll Period", periodrec."Starting Date");
                        ExtraPayrollBanks.SetRange("Emp No.", Rec."WB No.");

                        Message(Format(Rec.Type) + '  processed successfully!');
                    end;

                end;
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
            action(EmpCard)
            {
                Caption = 'Employee Card';
                Image = User;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                var
                begin
                    if Rec."WB No." = '' then
                        Error('Employee not selected!');

                    EmpRec.Reset();
                    EmpRec.SetRange("No.", Rec."WB No.");
                    if EmpRec.Find('-') then
                        Page.Run(PAGE::"Employee Card", EmpRec);
                end;
            }
            action("Send Approval Request")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                //PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.TestField("WB No.");

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
                Promoted = true;
                PromotedCategory = Category4;
                //PromotedIsBig = true;

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
                Promoted = true;
                PromotedCategory = Category4;
                //PromotedIsBig = true;
                RunPageMode = View;

                trigger OnAction()
                begin
                    ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId)
                end;
            }
        }

    }
    var
        EmpRec: Record Employee;
        AssingmentMatrix: Record "Assignment Matrix";
        TerminalDuesLines: Record "Terminal Dues Lines";
        TerminalDuesLinesInit: Record "Terminal Dues Lines";
        LineNo: Integer;
        SalaryStructure: Record "Terminal Dues Salary Structure";
        AdditionalEntitledTos: Record "Additional Entitled To";
        WorkingAmount: Decimal;
        SocialSecurity: Decimal;
        OccupationalHazard: Decimal;
        Paye: Decimal;
        Cbhi: Decimal;
        BasicAmt: Decimal;
        HouseAmt: Decimal;
        TransportAmt: Decimal;
        Descr: Text[250];
        ExtraPayrollBanks: Record "Extra Payroll Banks";
        PeriodPrevailingMovements: Record "Period Prevailing Movement";
        CausesOfInactivity: Record "Period Causes of Inactivity";
        EmpPeriodBankDetails: Record "Employee Period Bank Details";
        EmpMovement: Record "Internal Employement History";
        TempContAmountType: Option "Gross Pay","Basic Pay","Net Pay";
        TempContAmountVal: Decimal;
        TempContAmountCurrency: Code[50];
        TempPayrollCurrency: Code[50];
        TempPayCountry: Code[200];
        TempFirstDate: Date;
        TempLastDate: Date;
        MonthFirstDate: Date;
        MonthLastDate: Date;
        NoOfDays: Integer;
        IsEarningTrans: Boolean;
        DesiredCurrency: Code[50];
        localCurrencyCode: Code[50];
        GenLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        ExchangeRate: Decimal;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovals: Codeunit "Custom Approvals Mgmt HR";
        VarVariant: Variant;
        TaxableAmountInRwf: Decimal;
        MileagePlusAccommodation: Decimal;
        GetPaye: Codeunit "Loan-Payroll";
        PayablePAYE: Decimal;

    procedure InsertTerminalDueLine(LnNo: Integer; IsEarning: Boolean; taxable: Boolean; Currency: Code[30]; Description: Text[250]; Amt: Decimal; IsBasic: Boolean; IsTransport: Boolean; IsHouse: Boolean);
    begin
        TerminalDuesLinesInit.Reset();
        TerminalDuesLinesInit.Init();
        TerminalDuesLinesInit."Header No." := Rec."No.";
        TerminalDuesLinesInit."Line No." := LnNo;
        TerminalDuesLinesInit."Trans Type" := TerminalDuesLinesInit."Trans Type"::Earning;
        if not IsEarning then begin
            TerminalDuesLinesInit."Trans Type" := TerminalDuesLinesInit."Trans Type"::Deduction;
            Amt := -Abs(Amt);
        end;
        TerminalDuesLinesInit.Description := Description;
        if StrPos(Description, 'Employer') <> 0 then begin
            if Description = 'Social Security Employer' then
                TerminalDuesLinesInit.Description := 'Social Security - Employer';
            if Description = 'Occupational Hazard Employer' then
                TerminalDuesLinesInit.Description := 'Occupational Hazard Contribution - Employer';
            TerminalDuesLinesInit."Trans Type" := TerminalDuesLinesInit."Trans Type"::Employer;
            Amt := Abs(Amt);
        end;
        TerminalDuesLinesInit.Currency := Currency;
        TerminalDuesLinesInit."Payroll Currency" := Rec."Payroll Currency";
        TerminalDuesLinesInit."Amount (FCY)" := Amt;
        TerminalDuesLinesInit.Amount := Amt;
        TerminalDuesLinesInit."Period Processed" := Rec."Period Processed";
        TerminalDuesLinesInit."System Entry" := true;
        TerminalDuesLinesInit."Is Basic" := IsBasic;
        TerminalDuesLinesInit."Is House" := IsHouse;
        TerminalDuesLinesInit."Is Transport" := IsTransport;
        TerminalDuesLinesInit.Taxable := taxable;
        TerminalDuesLinesInit.Insert();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Final Dues";
    end;

    trigger OnOpenPage()
    begin
        GenLedgerSetup.Get();
        localCurrencyCode := GenLedgerSetup."LCY Code";
        ExchangeRate := 1;
        DesiredCurrency := localCurrencyCode;
        if localCurrencyCode = '' then
            Error('The local currency code has not been specified in the General Ledger Setup!');

        if Rec."Exchange Rate" = 0 then begin
            if Rec."Date Processed" = 0D then
                Rec."Date Processed" := Today;
            Rec."Exchange Rate" := GetInDesiredCurrency(Rec."Payroll Currency", 'USD', 0, Rec."Date Processed");
            if Rec."Exchange Rate" = 0 then
                Rec."Exchange Rate" := 1;
            if Rec."Exchange Rate" < 1 then
                Rec."Exchange Rate" := 1 / Rec."Exchange Rate";
        end;

        CurrPage.Editable(true);
        if (Rec."Approval Status" <> Rec."Approval Status"::Open) and (Rec."Approval Status" <> Rec."Approval Status"::Rejected) then
            CurrPage.Editable(false);

    end;

    Procedure GetInDesiredCurrency(EarningCountryCurrency: Code[50]; SelectedCountryCurrency: Code[50]; AmountToConvert: Decimal; ExchangeRateDateVar: Date) /*ConvertedAmount*/ExchRate: Decimal
    begin
        //if DesiredCurrency = '' then
        DesiredCurrency := SelectedCountryCurrency;
        /*if EarningCountryCurrency = '' then
            EarningCountryCurrency := SelectedCountryCurrency;*/

        //ConvertedAmount := AmountToConvert;
        ExchRate := 1;
        if DesiredCurrency = EarningCountryCurrency then
            ExchRate := 1//ConvertedAmount := AmountToConvert
        else begin
            CurrExchangeRateDate := CalcDate('CM', ExchangeRateDateVar);
            Fcy1ToLcyRate := 0;
            LcyToFcy2Rate := 0;

            //We want to convert the currency from the earning currency to the desired currency
            //1. Get the FCY1 to LCY rate
            /*if "Earning Currency" = localCurrencyCode then
                Fcy1ToLcyRate := 1
            else begin*/
            CurrencyExchangeRate.GetLastestExchangeRateCustom(EarningCountryCurrency, CurrExchangeRateDate, Fcy1ToLcyRate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', EarningCountryCurrency, localCurrencyCode);
            //end;

            //2. Get the LCY to FCY2 rate
            CurrencyExchangeRate.GetLastestExchangeRateCustom(DesiredCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, DesiredCurrency);

            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
            if LcyToFcy2Rate <> 0 then
                ExchRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
        end;
        exit(/*ConvertedAmount*/ExchRate);
    end;
}