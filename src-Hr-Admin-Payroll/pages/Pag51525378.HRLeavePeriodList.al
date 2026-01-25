page 51525378 "HR Leave Period List"
{
    ApplicationArea = All;
    //CardPageID = HRUser;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "HR Leave Periods";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Code"; Rec."Period Code")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("End Date"; Rec."End Date")
                { }
                field("Period Description"; Rec."Period Description")
                {
                }
                field(Closed; Rec.Closed)
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control5; Outlook)
            {
            }
            systempart(Control4; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Create Year")
            {
                Caption = '&Create Year';
                Ellipsis = true;
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = Process;
                //RunObject = Report Report51525066;
                Visible = false;
            }
            /*action("C&lose Year")
            {
                Caption = 'C&lose Year';
                Image = CloseYear;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Codeunit "HR Leave Year - Close";
                Visible = false;
            }*/
            action("Close Period")
            {
                Caption = 'Close Period';
                Image = ClosePeriod;
                Promoted = true;

                trigger OnAction()
                var
                    controlaccount: Code[50];
                    conversionrate: Decimal;
                    customeraccount: Code[50];
                    batchName: Code[50];
                    templateName: Code[50];
                    GenJnlLine: Record "Gen. Journal Line";
                    LineNo: Integer;
                    MaxCarryForwardDays: Decimal;
                begin
                    if Confirm(Txt003, true) = false then exit;

                    LeavePeriods.Reset;
                    LeavePeriods.SetRange(LeavePeriods.Closed, false);
                    if LeavePeriods.Find('-') then begin
                        DateNewPeriod := CalcDate('1Y', LeavePeriods."Starting Date");
                        //just to sort something for WB - specifically
                        if LeavePeriods."Starting Date" = 20231001D then
                            DateNewPeriod := 20250101D;
                        intNewYear := Date2DMY(DateNewPeriod, 3);
                        PeriodName := Txt001 + ' ' + Format(intNewYear);

                        //Close Period
                        LeavePeriods.Closed := true;
                        LeavePeriods."Date Time Closed" := CurrentDateTime;
                        LeavePeriods."Closed By" := UserId;
                        LeavePeriods.Modify;

                        //Mark Ledger Entries for that Period as Closed
                        LeaveLedgerEntries.Reset;
                        LeaveLedgerEntries.SetRange(LeaveLedgerEntries."Leave Period", LeavePeriods."Period Code");
                        if LeaveLedgerEntries.FindSet then begin
                            repeat
                                LeaveLedgerEntries.Closed := true;
                                LeaveLedgerEntries.Modify;
                            until LeaveLedgerEntries.Next = 0;
                        end;

                        //NextYearx := CalcDate('<1Y>', DateNewPeriod);
                        //NextYear := Date2DMY(NextYearx, 3);

                        //Create New Period
                        with NewLeavePeriods do begin
                            Init;
                            "Starting Date" := DateNewPeriod;
                            "Period Code" := Format(intNewYear);// + '-' + Format(NextYear);
                            Validate("Starting Date");
                            "Period Description" := PeriodName;
                            Closed := false;
                            Insert;

                        end;

                        //Carry Forward Leave Balances
                        HRJournalBatch.Reset;
                        HRSetup.Get;
                        HRSetup.TestField(HRSetup."Default Leave Posting Template");
                        HRSetup.TestField(HRSetup."Positive Leave Posting Batch");

                        HRJournalBatch.Get(HRSetup."Default Leave Posting Template", HRSetup."Positive Leave Posting Batch");

                        //Check whether Journal Line has any entries
                        HRJournalLine.Reset;
                        HRJournalLine.SetRange(HRJournalLine."Journal Template Name", HRSetup."Default Leave Posting Template");
                        HRJournalLine.SetRange(HRJournalLine."Journal Batch Name", HRSetup."Positive Leave Posting Batch");
                        if HRJournalLine.Find('-') then
                            HRJournalLine.DeleteAll;

                        "LineNo." := 0;

                        MaxCarryForwardDays := 0;
                        //Get Maximum Days to Carry Over
                        LeaveTypes.Reset;
                        LeaveTypes.SetRange(LeaveTypes."Annual Leave", true);
                        if not LeaveTypes.Find('-') then
                            Error(Txt006)
                        else begin
                            if LeaveTypes.Balance = LeaveTypes.Balance::"Carry Forward" then
                                MaxCarryForwardDays := LeaveTypes."Max Carry Forward Days";


                            //Get employees whose balances to carry over
                            Employees.Reset;
                            Employees.SetRange(Employees.Status, Employees.Status::Active);
                            if Employees.Find('-') then begin
                                HRSetup.Get;
                                repeat
                                    LeaveBalance := 0;
                                    DaystoCarryOver := 0;
                                    LeaveLedgerEntries2.Reset;
                                    LeaveLedgerEntries2.SetRange(LeaveLedgerEntries2."Leave Period", LeavePeriods."Period Code");
                                    LeaveLedgerEntries2.SetRange(LeaveLedgerEntries2."Staff No.", Employees."No.");
                                    LeaveLedgerEntries2.SetFilter(LeaveLedgerEntries2."Leave Type", 'ANNUAL|CARRY FORWARD|CF');
                                    if LeaveLedgerEntries2.FindSet then begin
                                        LeaveLedgerEntries2.CalcSums(LeaveLedgerEntries2."No. of days");
                                        LeaveBalance := LeaveLedgerEntries2."No. of days";//+ LeaveBalance;

                                        //Get Maximum Days to Carry Over
                                        if LeaveBalance > MaxCarryForwardDays then
                                            DaystoCarryOver := MaxCarryForwardDays
                                        else
                                            DaystoCarryOver := LeaveBalance;

                                    end;


                                    //Insert carry foward entries for the maximum defined period
                                    //if HRSetup.ExcessLeave = HRSetup.ExcessLeave::"Carry forward" then begin
                                    if LeaveTypes.Balance = LeaveTypes.Balance::"Carry Forward" then begin
                                        //Populate Journal Lines
                                        "LineNo." := "LineNo." + 1000;

                                        HRJournalLine.Init;
                                        HRJournalLine."Journal Template Name" := HRSetup."Default Leave Posting Template";
                                        HRJournalLine."Journal Batch Name" := HRSetup."Positive Leave Posting Batch";
                                        HRJournalLine."Line No." := "LineNo.";
                                        HRJournalLine."Leave Period" := Format(intNewYear);// + '/' + Format(NextYear);//
                                        HRJournalLine."Document No." := NewLeavePeriods."Period Code" + Txt005;
                                        HRJournalLine."Staff No." := Employees."No.";
                                        HRJournalLine.Validate(HRJournalLine."Staff No.");
                                        HRJournalLine."Posting Date" := Today;
                                        HRJournalLine."Leave Entry Type" := HRJournalLine."Leave Entry Type"::Reimbursement;
                                        HRJournalLine."Leave Approval Date" := Today;
                                        HRJournalLine.Description := NewLeavePeriods."Period Code" + ' ' + Txt004;
                                        HRJournalLine."Leave Type" := 'CARRY FORWARD';//LeaveTypes.Code;
                                        HRJournalLine."No. of Days" := DaystoCarryOver;

                                        if HRJournalLine."No. of Days" <> 0 then
                                            HRJournalLine.Insert(true);
                                    end else
                                        //if HRSetup.ExcessLeave = HRSetup.ExcessLeave::"Convet to Kshs" then begin
                                        if LeaveTypes.Balance = LeaveTypes.Balance::"Convert to Cash" then begin
                                            controlaccount := HRSetup."Control account";

                                            GenJnlLine.Reset;
                                            GenJnlLine.SetRange(GenJnlLine."Journal Template Name", templateName);
                                            GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", batchName);
                                            GenJnlLine.DeleteAll;


                                            LineNo := LineNo + 1000;
                                            GenJnlLine.Init;
                                            GenJnlLine."Journal Template Name" := templateName;
                                            GenJnlLine."Journal Batch Name" := batchName;
                                            GenJnlLine."Line No." := LineNo;
                                            GenJnlLine."Source Code" := 'PAYMENTJNL';
                                            GenJnlLine."Posting Date" := Today;
                                            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                                            GenJnlLine."Document No." := Employees."No." + ' ' + NewLeavePeriods."Period Code";
                                            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                                            GenJnlLine."Account No." := customeraccount;
                                            GenJnlLine.Validate(GenJnlLine."Account No.");
                                            GenJnlLine.Description := 'Leave carry forward: ' + customeraccount;
                                            GenJnlLine.Amount := HRSetup.conversionRation * DaystoCarryOver;
                                            GenJnlLine.Validate(GenJnlLine.Amount);
                                            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                                            GenJnlLine."Bal. Account No." := controlaccount;
                                            GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                                            if GenJnlLine.Amount <> 0 then
                                                GenJnlLine.Insert;

                                        end;

                                    //Employees."Leave Period":= FORMAT(intNewYear)+'-'+FORMAT(NextYear);;
                                    Employees."Allowance Collected" := false;
                                    Employees.Modify;

                                until Employees.Next = 0;

                                //Post Journal
                                HRJournalLine.Reset;
                                HRJournalLine.SetRange("Journal Template Name", HRSetup."Default Leave Posting Template");
                                HRJournalLine.SetRange("Journal Batch Name", HRSetup."Positive Leave Posting Batch");
                                if HRJournalLine.Find('-') then begin
                                    CODEUNIT.Run(CODEUNIT::"HR Leave Jnl.-Post", HRJournalLine);
                                end;

                            end;
                        end;

                    end else
                        Error(Txt002);
                end;
            }
        }
    }

    var
        LeavePeriods: Record "HR Leave Periods";
        DateNewPeriod: Date;
        intNewYear: Integer;
        PeriodName: Text[50];
        Txt001: Label 'Leave';
        Txt002: Label 'There is no open period to close';
        NewLeavePeriods: Record "HR Leave Periods";
        Txt003: Label 'Closing the open Leave period will create a new period and carry over days to this new period. Do you want to continue?';
        LeaveLedgerEntries: Record "HR Leave Ledger Entries";
        Employees: Record Employee;
        LeaveLedgerEntries2: Record "HR Leave Ledger Entries";
        LeaveBalance: Decimal;
        LeaveTypes: Record "Leave Types";
        DaystoCarryOver: Decimal;
        HRJournalBatch: Record "HR Leave Journal Batch";
        HRSetup: Record "Human Resources Setup";
        HRJournalLine: Record "HR Leave Journal Line";
        "LineNo.": Integer;
        Txt004: Label 'Reimbursement';
        Txt005: Label 'Reimb';
        Txt006: Label 'You must have at least one Leave Type marked as "Annual Leave".';
        NextYear: Integer;
        NextYearx: Date;
}