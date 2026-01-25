report 51525368 "Close Pay period"
{
    //       // Used for previous loan handling
    //         //  IF Loan.GET(PaymentDed.Code,PaymentDed."Employee No") THEN
    //         //    BEGIN

    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Assignment Matrix"; "Assignment Matrix")
        {

            trigger OnPostDataItem()
            var
                SalaryIncrement: Codeunit "Effect Annual Basic Incre";
                PayProcessingHeader: Record "Payroll Processing Header";
                PayProcessingHeaderInit: Record "Payroll Processing Header";
            begin
                //ERROR('PayperiodStart..%1StartingDate..%2',PayperiodStart,StartingDate);
                if PayperiodStart <> StartingDate then
                    Error('Cannot Close this Pay period Without Closing the preceding ones')
                else begin
                    if PayPeriod.Get(StartingDate) then begin

                        PayPeriod."Close Pay" := true;
                        PayPeriod.Closed := true;
                        PayPeriod."Closed By" := UserId;
                        PayPeriod."Closed on Date" := CurrentDateTime;
                        // PayPeriod.CreateLeaveEntitlment(PayPeriod);
                        PayPeriod.Modify;
                        //Message('The period has been closed');
                    end;
                end;

                // Go thru assignment matrix for loans and validate code
                NewPeriod := CalcDate('1M', PayperiodStart);
                /*Loan.Reset;
                Loan.SetRange("Start Deducting", true);
                Loan.SetRange("Stop/Pause", false);
                Loan.SetRange(Cleared, false);
                if Loan.Find('-') then begin
                    repeat
                        AssMatrix.Reset;
                        AssMatrix.SetRange(AssMatrix."Payroll Period", NewPeriod);
                        AssMatrix.SetRange(Code, Loan.Code);
                        AssMatrix.SetRange("Is Loan Transaction", true);
                        if AssMatrix.Find('-') then begin
                            repeat
                                if EmpRec.Get(AssMatrix."Employee No") then begin
                                    if (EmpRec.Status = EmpRec.Status::Active) and (Loan.Employee = AssMatrix."Employee No") then
                                        AssMatrix.Validate(Code);
                                    AssMatrix.Modify
                                end;
                            until AssMatrix.Next = 0;
                        end;
                    until Loan.Next = 0;
                end;*/

                //Create the new period
                PayPeriod.Reset();
                PayPeriod.Init();
                PayPeriod."Starting Date" := NewPeriod;
                PayPeriod.Name := Format(NewPeriod, 0, '<Month Text> <Year4>');
                PayPeriod.Insert();

                //Close prev training batch and create the new one                
                UpdateTrainingAllowanceBatches(PayperiodStart); //"Training Allowance Batches"

                //Create the new pay period processing card here
                PayProcessingHeader.Reset();
                PayProcessingHeader.SetRange("Payroll Period", NewPeriod);
                if not PayProcessingHeader.FindFirst() then begin
                    PayProcessingHeaderInit.Reset();
                    PayProcessingHeaderInit.Init();
                    PayProcessingHeaderInit."Payroll Period" := NewPeriod;
                    //PayProcessingHeaderInit."User ID" := UserId();
                    PayProcessingHeaderInit.Insert(true);
                end;

                //Mark old as posted
                PayProcessingHeader.Reset();
                PayProcessingHeader.SetRange("Payroll Period", PayperiodStart);
                if PayProcessingHeader.FindFirst() then begin
                    PayProcessingHeader.Status := PayProcessingHeader.Status::Posted;
                    PayProcessingHeader.Modify;
                end;



                Message('The %1 period has been closed and %2 created successfully!', Format(PayperiodStart, 0, '<Month Text> <Year4>'), Format(NewPeriod, 0, '<Month Text> <Year4>'));

                //Run Salary Increment
                //SalaryIncrement.RUN;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        payrollperiod: Record "Payroll Period";
        TrainingAllowanceBatches: Record "Training Allowance Batches";
        TrainingAllowanceBatchPage: Page "Training Allowance Batches";
    begin
        TrainingAllowanceBatches.Reset();
        TrainingAllowanceBatches.SetRange("Payroll Period", PayperiodStart);
        TrainingAllowanceBatches.SetRange(Status, TrainingAllowanceBatches.Status::"Sent to Payroll");
        if TrainingAllowanceBatches.FindFirst() then begin
            Error('A training instructor allowance batch was sent to payroll for processing but wasn''t processed yet it should be processed within this period.\Kindly go back to process payroll and accept the prompt when asked whether to process the training allowance batch.');
        end;

        if not Confirm('Please backup up before closing current period! OK to Proceed?') then
            Error('The period has not been closed');

        //PayrollRun.RUN;
        //  Error('%1..', PayperiodStart);
        DeducePayPeriod;
        ClosePeriodTrans;
        deactivateEmployees(PayperiodStart);
        CreateNewEntries(PayperiodStart);
        UpdateSalaryPointers(PayperiodStart);
        //  Error('%1..', PayperiodStart);
    end;

    var
        Proceed: Boolean;
        CurrentPeriodEnd: Date;
        DaysAdded: Code[10];
        PayPeriod: Record "Payroll Period";
        StartingDate: Date;
        PayperiodStart: Date;
        LoansUpdate: Boolean;
        PayHistory: Record "Employee Ledger Entry";
        EmpRec: Record Employee;
        TaxableAmount: Decimal;
        RightBracket: Boolean;
        AmountRemaining: Decimal;
        IncomeTax: Decimal;
        NetPay: Decimal;
        Loan: Record "Loans transactions";
        ReducedBal: Decimal;
        InterestAmt: Decimal;
        CompRec: Record "Human Resources Setup";
        HseLimit: Decimal;
        ExcessRetirement: Decimal;
        relief: Decimal;
        Outstanding: Decimal;
        CreateRec: Boolean;
        benefits: Record Earnings;
        deductions: Record Deductions;
        InterestDiff: Decimal;
        Rounding: Boolean;
        PD: Record "Assignment Matrix";
        Pay: Record Earnings;
        Ded: Record Deductions;
        TaxCode: Code[10];
        CfAmount: Decimal;
        TempAmount: Decimal;
        EmpRec1: Record Employee;
        Emprec2: Record Employee;
        NewPeriod: Date;
        AssMatrix: Record "Assignment Matrix";
        PayrollRun: Report "Payroll Run";
        Schedule: Record "Repayment Schedule";
        Window: Dialog;
        EmployeeName: Text[200];
        //GetGroup: Codeunit PayrollRounding;
        GroupCode: Code[20];
        CUser: Code[20];
        LoanApplicationForm: Record "Loan Application";
        Discontinue: Boolean;
        PayrollApp: Record "Payroll Approval";
        RemainingAmountOfRunningBalance: Decimal;
        EmpPeriodBankDetails: Record "Employee Period Bank Details";
        EmpPeriodBankDetailsCheck: Record "Employee Period Bank Details";
        EmpPeriodBankDetailsInit: Record "Employee Period Bank Details";
        ExtraPayrollBanks: Record "Extra Payroll Banks";
        ExtraPayrollBanksCheck: Record "Extra Payroll Banks";
        ExtraPayrollBanksInit: Record "Extra Payroll Banks";
        TransportAllowanceBanks: Record "Transport Allowance Banks";
        TransportAllowanceBanksCheck: Record "Transport Allowance Banks";
        TransportAllowanceBanksInit: Record "Transport Allowance Banks";
        PayrollVarianceComments: Record "Payroll Variance Comments";


    procedure GetCurrentPeriod(var Payperiod: Record "Payroll Period")
    begin

        CurrentPeriodEnd := Payperiod."Starting Date";
        StartingDate := CurrentPeriodEnd;
        CurrentPeriodEnd := CalcDate('CM', CurrentPeriodEnd);

        //Error('1..%1..%2',CurrentPeriodEnd,StartingDate);
    end;


    procedure DeducePayPeriod()
    var
        PayPeriodRec: Record "Payroll Period";
    begin
        PayPeriodRec.Reset;
        PayPeriodRec.SetRange(PayPeriodRec."Close Pay", false);
        PayPeriodRec.SetFilter(PayPeriodRec."Starting Date", '<>%1', 0D);
        if PayPeriodRec.Find('-') then begin
            PayperiodStart := PayPeriodRec."Starting Date";
            if not Confirm('Are you sure you want to close ' + Format(PayperiodStart, 0, '<Month Text> <Year4>') + '? Click OK to Proceed.') then
                Error('The period has not been closed');
            PayrollApp.Reset;
            PayrollApp.SetRange("Payroll Period", PayPeriodRec."Starting Date");
            if PayrollApp.FindFirst then begin
                if PayrollApp.Status <> PayrollApp.Status::Approved then
                    Error('You cannot close the payroll period before it is approved');
            end;
            GetCurrentPeriod(PayPeriodRec);
        end;
        //ERROR('1...%1',PayperiodStart);
    end;


    procedure ClosePeriodTrans()
    var
        EarnDeduct: Record "Assignment Matrix";
        LoanRepayments: Record "Loan Repayments";
        TotalRemainingAmount: Decimal;
        EarningsRec: Record Earnings;
        DeductionsRec: Record Deductions;
    begin
        // Error('%1',PayperiodStart);
        EarnDeduct.Reset;
        EarnDeduct.SetRange(EarnDeduct."Payroll Period", PayperiodStart);
        if EarnDeduct.Find('-') then
            repeat
                /*if EarnDeduct."Transaction Title" = '' then //Update for all
                begin*/
                if EarnDeduct.Type = EarnDeduct.Type::Payment then begin
                    EarningsRec.Reset();
                    EarningsRec.SetRange(Country, EarnDeduct.Country);
                    EarningsRec.SetRange(Code, EarnDeduct.Code);
                    if EarningsRec.FindFirst() then
                        EarnDeduct."Transaction Title" := EarningsRec."Universal Title";
                end;
                if EarnDeduct.Type = EarnDeduct.Type::Deduction then begin
                    DeductionsRec.Reset();
                    DeductionsRec.SetRange(Country, EarnDeduct.Country);
                    DeductionsRec.SetRange(Code, EarnDeduct.Code);
                    if DeductionsRec.FindFirst() then
                        EarnDeduct."Transaction Title" := DeductionsRec."Universal Title";
                end;
                if EarnDeduct."Transaction Title" = '' then
                    Error('Some transactions have blank titles. You cannot proceed that way. Kindly rerun payroll or contact the administrator before proceeding');
                //end;

                EarnDeduct.Closed := true;
                EarnDeduct."Payroll Period" := PayperiodStart;

                if EarnDeduct."Is Loan Transaction" then begin
                    TotalRemainingAmount := 0;
                    Loan.Reset;
                    Loan.SetRange(Employee, EarnDeduct."Employee No");
                    Loan.SetRange(Code, EarnDeduct.Code);
                    Loan.SetRange(Country, EarnDeduct.Country);
                    Loan.SetRange("Start Deducting", true);
                    Loan.SetRange(Pause, false);
                    Loan.SetRange(Suspend, false);
                    Loan.SetRange(Cleared, false);
                    if Loan.FindSet() then begin
                        repeat
                            LoanRepayments.Reset();
                            LoanRepayments.SetRange("Loan No.", Loan.No);
                            LoanRepayments.SetRange("Payroll Period", PayperiodStart);
                            if LoanRepayments.FindFirst() then begin
                                LoanRepayments.Closed := true;
                                LoanRepayments.Modify();
                            end;
                            Loan.CalcFields("Amount Paid");
                            if (Loan."Amount Paid" + Loan."Initial Paid Amount") >= Loan."Loan Amount" then
                                Loan.Cleared := true;
                            TotalRemainingAmount += (Loan."Loan Amount" - Loan."Amount Paid" + Loan."Initial Paid Amount");
                            /*if not ((Loan.Cleared = false) and (Loan."Start Deducting" = true) and (Loan."Stop/Pause" = false)) then
                                EarnDeduct."Loan Cleared" := true; //Skip entry*/
                            Loan.Modify();
                        until Loan.Next() = 0;
                        if TotalRemainingAmount <= 0 then
                            EarnDeduct."Loan Cleared" := true; //Skip entry
                    end;
                end;
                EarnDeduct.Modify;
            until EarnDeduct.Next = 0;

        //Close variance comments
        PayrollVarianceComments.Reset();
        PayrollVarianceComments.SetRange("Payroll Period", PayperiodStart);
        PayrollVarianceComments.ModifyAll(Closed, true);

        //----------------------------------------------------
        PayPeriod.Reset;
        PayPeriod.SetFilter(PayPeriod."Starting Date", '%1', PayperiodStart);
        if PayPeriod.FindSet then begin
            PayPeriod.Closed := true;
            PayPeriod."Closed By" := UserId;
            PayPeriod."Closed on Date" := CurrentDateTime;
            //:=TODAY;
            PayPeriod.Modify;
        end;
        //----------------------------------------------------
    end;


    procedure CreateNewEntries(var CurrPeriodStat: Date)
    var
        PaymentDed: Record "Assignment Matrix";
        AssignMatrix: Record "Assignment Matrix";
        LoanRepayments: Record "Loan Repayments";
        TotalRemainingAmount: Decimal;
    begin
        /*This function creates new entries for the next Payroll period which are accessible and editable
        by the user of the Payroll. It should ideally create new entries if the EmpRec is ACTIVE*/

        //MESSAGE('%1',CurrPeriodStat);
        NewPeriod := CalcDate('1M', PayperiodStart);
        Window.Open('Creating Next period entries ##############################1', EmployeeName);
        PaymentDed.Reset;
        PaymentDed.SetRange(PaymentDed."Payroll Period", PayperiodStart);
        PaymentDed.SetRange(PaymentDed."Next Period Entry", true);
        //PaymentDed.SetRange("Emp Is Inactive", false); //Only move for the active ones
        //PaymentDed.SetFilter(PaymentDed.Frequency, '%1', PaymentDed.Frequency::Recurring); //overdone
        if PaymentDed.Find('-') then begin
            repeat
                //FRED 1/6/23 - If the effective end date of a transaction is earlier than the start of the new period, drop it
                if (PaymentDed."Effective End Date" = 0D) or (PaymentDed."Effective End Date" > NewPeriod) then begin
                    CreateRec := true;
                    AssignMatrix.Init;
                    AssignMatrix.TransferFields(PaymentDed);
                    AssignMatrix.Closed := false;
                    AssignMatrix."Employee No" := PaymentDed."Employee No";
                    AssignMatrix.Country := PaymentDed.Country;
                    AssignMatrix."Effective Start Date" := PaymentDed."Effective Start Date";
                    AssignMatrix."Is Flat Amount" := PaymentDed."Is Flat Amount";
                    AssignMatrix."Transport Allowance" := PaymentDed."Transport Allowance";
                    AssignMatrix."Gross Pay" := PaymentDed."Gross Pay";
                    AssignMatrix."Is Statutory" := PaymentDed."Is Statutory";
                    AssignMatrix."Earning Currency" := PaymentDed."Earning Currency";
                    AssignMatrix."Amount In FCY" := PaymentDed."Amount In FCY";
                    AssignMatrix."Country Currency" := PaymentDed."Country Currency";

                    AssignMatrix.Type := PaymentDed.Type;
                    AssignMatrix.Code := PaymentDed.Code;
                    AssignMatrix."Global Dimension 1 code" := PaymentDed."Global Dimension 1 code";
                    AssignMatrix."Global Dimension 2 Code" := PaymentDed."Global Dimension 2 Code";
                    AssignMatrix."Reference No" := PaymentDed."Reference No";
                    AssignMatrix.Retirement := PaymentDed.Retirement;
                    AssignMatrix."Payroll Period" := NewPeriod;//CALCDATE('1M',PayperiodStart);
                    AssignMatrix.Amount := PaymentDed.Amount;
                    AssignMatrix."Loan No." := PaymentDed."Loan No.";
                    AssignMatrix."Period Repayment" := PaymentDed."Period Repayment";
                    AssignMatrix."Is Loan Transaction" := PaymentDed."Is Loan Transaction";
                    //Mark cleared loans - if any
                    if AssignMatrix."Is Loan Transaction" then begin
                        if AssignMatrix."Loan Cleared" then
                            CreateRec := false
                        else
                            AssignMatrix.Validate(Code);
                        /*Loan.Reset;
                        //Loan.SetRange(No, PaymentDed."Loan No.");
                        if Loan.FindFirst() then begin
                            Loan.CalcFields("Amount Paid");
                            LoanRepayments.Reset();
                            LoanRepayments.SetRange("Loan No.", Loan.No);
                            LoanRepayments.SetRange("Payroll Period", PayperiodStart);
                            if LoanRepayments.FindFirst() then begin
                                LoanRepayments.Closed := true;
                                LoanRepayments.Modify();
                            end;
                            if (Loan."Amount Paid" + Loan."Initial Paid Amount") >= Loan."Loan Amount" then
                                Loan.Cleared := true;
                            if not ((Loan.Cleared = false) and (Loan."Start Deducting" = true) and (Loan."Stop/Pause" = false)) then
                                CreateRec := false; //Skip entry
                            Loan.Modify();
                        end;*/
                    end;

                    //FRED 1/6/23 - In cases of reducing balance
                    if PaymentDed."Opening Balance" <> 0 then begin
                        RemainingAmountOfRunningBalance := Abs(PaymentDed."Opening Balance") - Abs(PaymentDed.Amount);
                        if RemainingAmountOfRunningBalance = 0 then
                            CreateRec := false //Skip entry
                        else begin
                            if RemainingAmountOfRunningBalance >= Abs(PaymentDed.Amount) then
                                AssignMatrix.Amount := PaymentDed.Amount
                            else begin
                                if PaymentDed.Amount < 0 then //a -ve so a deduction
                                    AssignMatrix.Amount := -RemainingAmountOfRunningBalance
                                else
                                    AssignMatrix.Amount := RemainingAmountOfRunningBalance
                            end;
                        end;
                    end;

                    //Only move for the active ones
                    if PaymentDed."Emp Is Inactive" then
                        CreateRec := false;

                    AssignMatrix.Description := PaymentDed.Description;
                    AssignMatrix.Taxable := PaymentDed.Taxable;
                    AssignMatrix."Tax Deductible" := PaymentDed."Tax Deductible";
                    AssignMatrix.Frequency := PaymentDed.Frequency;
                    AssignMatrix."Pay Period" := PaymentDed."Pay Period";
                    AssignMatrix."Non-Cash Benefit" := PaymentDed."Non-Cash Benefit";
                    AssignMatrix.Quarters := PaymentDed.Quarters;
                    AssignMatrix."No. of Units" := PaymentDed."No. of Units";
                    AssignMatrix.Section := PaymentDed.Section;
                    AssignMatrix."Basic Pay" := PaymentDed."Basic Pay";
                    AssignMatrix."Salary Grade" := PaymentDed."Salary Grade";
                    AssignMatrix."Employer Amount" := PaymentDed."Employer Amount";
                    AssignMatrix."Global Dimension 1 code" := PaymentDed."Global Dimension 1 code";
                    AssignMatrix."Next Period Entry" := PaymentDed."Next Period Entry";
                    AssignMatrix."Posting Group Filter" := PaymentDed."Posting Group Filter";
                    AssignMatrix."Loan Repay" := PaymentDed."Loan Repay";
                    AssignMatrix.DebitAcct := PaymentDed.DebitAcct;
                    AssignMatrix.CreditAcct := PaymentDed.CreditAcct;
                    AssignMatrix."Basic Salary Code" := PaymentDed."Basic Salary Code";
                    AssignMatrix."Normal Earnings" := PaymentDed."Normal Earnings";
                    AssignMatrix."Start Date" := 0D;
                    AssignMatrix."End Date" := 0D;

                    AssignMatrix."Tax Relief" := PaymentDed."Tax Relief";

                    if PaymentDed."Global Dimension 1 code" = '' then begin
                        Emprec2.Reset;
                        if Emprec2.Get(PaymentDed."Employee No") then
                            AssignMatrix."Global Dimension 1 code" := Emprec2."Global Dimension 1 Code";
                    end;
                    //END EMM
                    EmpRec.Reset;
                    if EmpRec.Get(PaymentDed."Employee No") then begin
                        AssignMatrix."Payroll Group" := EmpRec."Posting Group";
                        Window.Update(1, EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name");

                        if (EmpRec.Status = EmpRec.Status::Active) and (CreateRec = true) then
                            if not AssignMatrix.Get(AssignMatrix."Employee No", AssignMatrix.Type, AssignMatrix.Code, AssignMatrix."Payroll Period", AssignMatrix."Reference No", AssignMatrix.Country, AssignMatrix."Effective Start Date") then
                                AssignMatrix.Insert;

                        //Copy emp bank records - if not exists
                        EmpPeriodBankDetailsCheck.Reset();
                        EmpPeriodBankDetailsCheck.SetRange("Emp No.", EmpRec."No.");
                        EmpPeriodBankDetailsCheck.SetRange("Payroll Period", NewPeriod);
                        if not EmpPeriodBankDetailsCheck.FindFirst() then begin
                            EmpPeriodBankDetails.Reset();
                            EmpPeriodBankDetails.SetRange("Emp No.", EmpRec."No.");
                            EmpPeriodBankDetails.SetRange("Payroll Period", PayperiodStart);
                            if /*not*/ EmpPeriodBankDetails.FindFirst() then begin
                                EmpPeriodBankDetailsInit.Reset();
                                EmpPeriodBankDetailsInit.Init();
                                EmpPeriodBankDetailsInit.TransferFields(EmpPeriodBankDetails);
                                EmpPeriodBankDetailsInit."Payroll Period" := NewPeriod;
                                /*EmpPeriodBankDetailsInit."Emp No." := EmpRec."No.";
                                EmpPeriodBankDetailsInit."Payroll Period" := PayperiodStart;
                                EmpPeriodBankDetailsInit."First Name" := EmpRec."First Name";
                                EmpPeriodBankDetailsInit."Middle Name" := EmpRec."Middle Name";
                                EmpPeriodBankDetailsInit."Last Name" := EmpRec."Last Name";
                                EmpPeriodBankDetailsInit."Bank Code" := EmpRec."Bank Code";
                                EmpPeriodBankDetailsInit."Bank Name" := EmpRec."Bank Name";
                                EmpPeriodBankDetailsInit."Bank Account No." := EmpRec."Bank Account No";
                                EmpPeriodBankDetailsInit."Branch Code" := EmpRec."Bank Branch Code";
                                EmpPeriodBankDetailsInit."Branch Name" := EmpRec."Bank Brach Name";
                                EmpPeriodBankDetailsInit."SWIFT Code" := EmpRec."SWIFT Code";
                                EmpPeriodBankDetailsInit.IBAN := EmpRec.IBAN;
                                EmpPeriodBankDetailsInit."Bank Country" := EmpRec."Payment/Bank Country";
                                EmpPeriodBankDetailsInit."Bank Currency" := EmpRec."Payment/Bank Currency";
                                EmpPeriodBankDetailsInit."Sort Code" := EmpRec."Sort Code";
                                EmpPeriodBankDetailsInit.Indicatif := EmpRec.Indicatif;
                                EmpPeriodBankDetailsInit."Code B.I.C." := EmpRec."Code B.I.C.";*/
                                EmpPeriodBankDetailsInit.Insert();
                            end;
                        end;
                        //Move also extra banks - if not exists
                        ExtraPayrollBanksCheck.Reset();
                        ExtraPayrollBanksCheck.SetRange("Payroll Period", NewPeriod);
                        ExtraPayrollBanksCheck.SetRange("Emp No.", EmpRec."No.");
                        if not ExtraPayrollBanksCheck.FindFirst() then begin
                            ExtraPayrollBanks.Reset();
                            ExtraPayrollBanks.SetRange("Payroll Period", PayperiodStart);
                            ExtraPayrollBanks.SetRange("Emp No.", EmpRec."No.");
                            if ExtraPayrollBanks.FindFirst() then begin
                                ExtraPayrollBanksInit.Reset();
                                ExtraPayrollBanksInit.Init();
                                ExtraPayrollBanksInit.TransferFields(ExtraPayrollBanks);
                                ExtraPayrollBanksInit."Payroll Period" := NewPeriod;
                                ExtraPayrollBanksInit.Insert();
                            end;
                        end;

                        TransportAllowanceBanksCheck.Reset();
                        TransportAllowanceBanksCheck.SetRange("Payroll Period", NewPeriod);
                        TransportAllowanceBanksCheck.SetRange("Emp No.", EmpRec."No.");
                        if not TransportAllowanceBanksCheck.FindFirst() then begin
                            TransportAllowanceBanks.Reset();
                            TransportAllowanceBanks.SetRange("Payroll Period", PayperiodStart);
                            TransportAllowanceBanks.SetRange("Emp No.", EmpRec."No.");
                            if TransportAllowanceBanks.FindFirst() then begin
                                TransportAllowanceBanksInit.Reset();
                                TransportAllowanceBanksInit.Init();
                                TransportAllowanceBanksInit.TransferFields(TransportAllowanceBanks);
                                TransportAllowanceBanksInit."Payroll Period" := NewPeriod;
                                TransportAllowanceBanksInit.Insert();
                            end;
                        end;
                    end;
                end;//close dates check
            until PaymentDed.Next = 0;
        end;

        //FRED 1/6/23 - If any entry with an effective start date is set to start this period, specify its payroll period
        PaymentDed.Reset;
        PaymentDed.SetRange(PaymentDed."Payroll Period", 0D);
        PaymentDed.SetFilter(PaymentDed."Effective Start Date", '%1..%2', NewPeriod, (CalcDate('1M', NewPeriod) - 1));
        if PaymentDed.Find('-') then begin
            repeat
                PaymentDed."Payroll Period" := NewPeriod;
                PaymentDed.Validate("Pay Period");
                PaymentDed.Modify;
            until PaymentDed.Next = 0;
        end;

        //Manage loans

        PaymentDed.Reset;
        PaymentDed.SetRange(PaymentDed."Payroll Period", NewPeriod);
        PaymentDed.SetRange(Type, PaymentDed.Type::Deduction);
        if PaymentDed.Find('-') then begin
            repeat
                LoanApplicationForm.Reset;
                LoanApplicationForm.SetRange(LoanApplicationForm."Deduction Code", PaymentDed.Code);
                LoanApplicationForm.SetRange(LoanApplicationForm."Loan No", PaymentDed."Reference No");
                if LoanApplicationForm.Find('-') then begin
                    LoanApplicationForm.SetRange(LoanApplicationForm."Date filter", 0D, PayperiodStart);
                    LoanApplicationForm.CalcFields(LoanApplicationForm."Total Repayment", LoanApplicationForm."Total Loan");

                    if LoanApplicationForm."Total Loan" <> 0 then begin
                        if (LoanApplicationForm."Total Loan" + LoanApplicationForm."Total Repayment") <= 0 then begin
                            Message('Loan %1 has expired', PaymentDed."Reference No");
                            PaymentDed.Delete;
                        end
                        else begin
                            if (LoanApplicationForm."Total Loan" + LoanApplicationForm."Total Repayment") < LoanApplicationForm.Repayment then begin

                                LoanApplicationForm.CalcFields(LoanApplicationForm."Total Repayment");

                                PaymentDed.Amount := -(LoanApplicationForm."Total Loan" + LoanApplicationForm."Total Repayment");
                                // PaymentDed."Next Period Entry":=FALSE;
                                PaymentDed.Modify;
                            end;

                        end;

                    end else begin
                        if (LoanApplicationForm."Approved Amount" + LoanApplicationForm."Total Repayment") <= 0 then begin
                            Message('Loan %1 has expired', PaymentDed."Reference No");
                            PaymentDed.Delete;
                        end
                        else begin
                            if (LoanApplicationForm."Approved Amount" + LoanApplicationForm."Total Repayment") < LoanApplicationForm.Repayment then begin

                                LoanApplicationForm.CalcFields(LoanApplicationForm."Total Repayment");

                                PaymentDed.Amount := -(LoanApplicationForm."Approved Amount" + LoanApplicationForm."Total Repayment");
                                // PaymentDed."Next Period Entry":=FALSE;
                                PaymentDed.Modify;
                            end;

                        end;
                    end;
                end;

            until PaymentDed.Next = 0;
        end;

        //Still part of loans but the one called loan transactions
        //Restart paused loans    
        Loan.Reset;
        Loan.SetRange("Start Deducting", true);
        Loan.SetRange(Pause, true);
        Loan.SetRange(Suspend, false);
        Loan.SetRange(Cleared, false);
        Loan.SetFilter("Loan Date", '<=%1', CalcDate('CM', NewPeriod)); //If start date is this month (Earlier than current month end)
        if Loan.FindSet() then begin
            repeat
                Loan.Pause := false;
                Loan.Modify();
            until Loan.Next() = 0;
        end;
    end;

    procedure deactivateEmployees(var CurrPeriod: Date)
    var
        EmpRecord: Record Employee;
        EmpMovement: Record "Internal Employement History";
        AssignM: Record "Assignment Matrix";
        CausesOfInactivity: Record "Period Causes of Inactivity";
        CausesOfInactivityInit: Record "Period Causes of Inactivity";
    begin
        EmpRecord.Reset();
        EmpRecord.SetRange(Status, EmpRecord.Status::Active);
        if EmpRecord.FindSet() then
            repeat
                EmpMovement.Reset();
                EmpMovement.SetRange("Emp No.", EmpRecord."No.");
                EmpMovement.SetRange(Status, EmpMovement.Status::Current);
                EmpMovement.SetFilter("Last Date", '<=%1', CalcDate('+1M', CurrPeriod));
                if EmpMovement.FindFirst() then begin
                    EmpRecord.Status := EmpRecord.Status::Inactive;
                    EmpRecord."MyID Eligibility" := false;
                    EmpRecord.Modify();

                    AssignM.Reset();
                    AssignM.SetRange("Payroll Period", CurrPeriod);
                    AssignM.SetRange("Employee No", EmpRecord."No.");
                    if AssignM.FindFirst() then begin
                        repeat
                            AssignM."Emp Is Inactive" := true;
                            AssignM.Modify();
                        until AssignM.Next() = 0;
                    end;
                    //Capture this period's causes of inactivity if present
                    CausesOfInactivity.Reset();
                    CausesOfInactivity.SetRange("Emp No.", EmpRecord."No.");
                    CausesOfInactivity.SetRange("Payroll Period", CurrPeriod);
                    CausesOfInactivity.DeleteAll();

                    EmpRecord.Validate("Cause of Inactivity Code");
                    CausesOfInactivityInit.Reset();
                    CausesOfInactivityInit.Init();
                    CausesOfInactivityInit."Emp No." := EmpRecord."No.";
                    CausesOfInactivityInit."Payroll Period" := CurrPeriod;
                    CausesOfInactivityInit."Cause of Inactivity" := EmpRecord."Cause of Inactivity";
                    if EmpRecord."Cause of Inactivity" = '' then
                        CausesOfInactivityInit."Cause of Inactivity" := 'End of term';
                    CausesOfInactivityInit.Insert();
                end;
            until EmpRecord.next() = 0;
    end;


    procedure Initialize()
    var
        InitEarnDeduct: Record "Assignment Matrix";
    begin

        InitEarnDeduct.SetRange(InitEarnDeduct.Closed, false);

        repeat
            InitEarnDeduct."Payroll Period" := PayperiodStart;
            InitEarnDeduct.Modify;
        until InitEarnDeduct.Next = 0;
    end;


    procedure GetTaxBracket(var TaxableAmount: Decimal)
    var
        TaxTable: Record Brackets;
        TotalTax: Decimal;
        Tax: Decimal;
        EndTax: Boolean;
    begin
        AmountRemaining := TaxableAmount;
        AmountRemaining := AmountRemaining;
        AmountRemaining := Round(AmountRemaining, 0.01);
        EndTax := false;

        TaxTable.SetRange("Table Code", TaxCode);

        if TaxTable.Find('-') then begin
            repeat
                if AmountRemaining <= 0 then
                    EndTax := true
                else begin
                    if Round((TaxableAmount), 0.01) > TaxTable."Upper Limit" then
                        Tax := TaxTable."Taxable Amount" * TaxTable.Percentage / 100
                    else begin
                        Tax := AmountRemaining * TaxTable.Percentage / 100;
                        TotalTax := TotalTax + Tax;
                        EndTax := true;
                    end;
                    if not EndTax then begin
                        AmountRemaining := AmountRemaining - TaxTable."Taxable Amount";
                        TotalTax := TotalTax + Tax;
                    end;
                end;
            until (TaxTable.Next = 0) or EndTax = true;
        end;
        TotalTax := TotalTax;
        IncomeTax := -TotalTax;
    end;


    procedure CreateLIBenefit(var Employee: Code[10]; var BenefitCode: Code[10]; var ReducedBalance: Decimal)
    var
        PaymentDeduction: Record "Assignment Matrix";
        Payrollmonths: Record "Payroll Period";
        allowances: Record Earnings;
    begin
        PaymentDeduction.Init;
        PaymentDeduction."Employee No" := Employee;
        PaymentDeduction.Code := BenefitCode;
        PaymentDeduction.Type := PaymentDeduction.Type::Payment;
        PaymentDeduction."Payroll Period" := CalcDate('1M', PayperiodStart);
        PaymentDeduction.Amount := ReducedBalance * InterestDiff;
        PaymentDeduction."Non-Cash Benefit" := true;
        PaymentDeduction.Taxable := true;
        //PaymentDeduction."Next Period Entry":=TRUE;
        if allowances.Get(BenefitCode) then
            PaymentDeduction.Description := allowances.Description;
        PaymentDeduction.Insert;
    end;


    procedure CoinageAnalysis(var NetPay: Decimal) NetPay1: Decimal
    var
        Index: Integer;
        Intex: Integer;
        AmountArray: array[15] of Decimal;
        NoOfUnitsArray: array[15] of Integer;
        MinAmount: Decimal;
    begin
    end;


    procedure UpdateSalaryPointers(var PayrollPeriod: Date)
    var
        Emp: Record Employee;
        RollingMonth: Integer;
    begin
        Emp.Reset;
        Emp.SetRange(Emp.Status, Emp.Status::Active);
        if Emp.Find('-') then begin
            repeat

                if Format(Date2DMY(NewPeriod, 2)) = Format(Emp."Incremental Month") then begin

                    if IncStr(Emp.Present) < Emp.Halt then begin
                        //MESSAGE('%1 %2',INCSTR(Emp.Present),Emp.Halt);
                        Emp.Previous := Emp.Present;
                        Emp.Present := IncStr(Emp.Present);
                        Emp.Modify;
                    end;
                end;

            until Emp.Next = 0;
        end;
    end;


    procedure CalculateRepaymentAmount(var EmpNo: Code[20]; var LoanNo: Code[20]; var LoanInterest: Decimal; LastPayment: Date) Repayment: Decimal
    var
        LoanApplication: Record "Loan Application";
        RepaymentSchedule: Record "Repayment Schedule";
        RepaymentAmnt: Decimal;
        Balance: Decimal;
        ReceiptsRec: Record "Non Payroll Receipts";
        NonPayrollReceipts: Decimal;
    begin


        Repayment := 0;
        LoanInterest := 0;
        //Get the loan being repaid
        LoanApplication.Reset;
        LoanApplication.SetRange(LoanApplication."Loan No", LoanNo);
        LoanApplication.SetRange(LoanApplication."Employee No", EmpNo);
        LoanApplication.SetRange("Date filter", 0D, LastPayment);
        if LoanApplication.FindFirst then begin
            if LoanApplication."Interest Calculation Method" <> LoanApplication."Interest Calculation Method"::"Reducing Balance" then begin

                LoanApplication.CalcFields("Total Repayment", Receipts);
                // MESSAGE('HAPA');

                Balance := LoanApplication."Approved Amount" - Abs(LoanApplication."Total Repayment") - Abs(LoanApplication.Receipts);

                Repayment := LoanApplication.Repayment;
                if Balance <= 0 then
                    Repayment := 0;
                exit(Repayment);
            end
            else begin
                //MESSAGE('KULE');
                /*
                RepaymentSchedule.RESET;
                RepaymentSchedule.SETRANGE(RepaymentSchedule."Loan No",LoanNo);
                RepaymentSchedule.SETRANGE(RepaymentSchedule."Employee No",EmpNo);
                RepaymentSchedule.SETRANGE("Repayment Date",CALCDATE('1M',PayperiodStart));
                 IF RepaymentSchedule.FINDFIRST THEN BEGIN
                    Repayment:=-RepaymentSchedule."Monthly Repayment";
                    Repayment:=PayrollRounding(Repayment);
                    EXIT(Repayment);
                 END;
                 */
                //Get Principal Repayment and subtract the interest on the balance
                LoanApplication.CalcFields("Total Repayment", Receipts);
                Balance := LoanApplication."Approved Amount" - Abs(LoanApplication."Total Repayment") - Abs(LoanApplication.Receipts);
                LoanInterest := (LoanApplication."Interest Rate" / 100 * Balance) / 12;
                LoanInterest := PayrollRounding(LoanInterest);
                Repayment := LoanApplication.Repayment;
                if Balance <= 0 then
                    Repayment := 0;
                exit(Repayment);
            end;
        end;

    end;

    procedure UpdateTrainingAllowanceBatches(currPeriod: Date)
    var
        TrainingAllowanceBatchRec: Record "Training Allowance Batches";
        TrainingAllowanceBatchPage: Page "Training Allowance Batches";
    begin
        TrainingAllowanceBatchRec.Reset();
        TrainingAllowanceBatchRec.SetRange("Payroll Period", currPeriod);
        if TrainingAllowanceBatchRec.FindFirst() then
            TrainingAllowanceBatchRec.ModifyAll(Status, TrainingAllowanceBatchRec.Status::Posted);

        TrainingAllowanceBatchPage.createNewBatch(false);
    end;

    procedure PayrollRounding(var Amount: Decimal) PayrollRounding: Decimal
    var
        HRsetup: Record "Human Resources Setup";
    begin


        HRsetup.Get;
        if HRsetup."Payroll Rounding Precision" = 0 then
            Error('You must specify the rounding precision under HR setup');

        if HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Nearest then
            PayrollRounding := Round(Amount, HRsetup."Payroll Rounding Precision", '=');

        if HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Up then
            PayrollRounding := Round(Amount, HRsetup."Payroll Rounding Precision", '>');

        if HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Down then
            PayrollRounding := Round(Amount, HRsetup."Payroll Rounding Precision", '<');
    end;
}