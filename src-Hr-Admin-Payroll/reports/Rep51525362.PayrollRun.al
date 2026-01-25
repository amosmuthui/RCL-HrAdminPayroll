report 51525362 "Payroll Run"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.") WHERE(Status = FILTER(Active), Board = FILTER(false));
            RequestFilterFields = "No.", "Payroll Country";

            trigger OnAfterGetRecord()
            var
                LoanApp: Record "Loan Application";
                LoanTrans: Record "Loans transactions";
                Loans: Record "Loan Product Type";
                LoanTopup: Record "Loan Top-up";
                OpenBal: Decimal;
                LoanInterest: Decimal;
                bracketrec: Record "Brackets Lines";
                assignmentmat: Record "Assignment Matrix";
                Emps: Record Employee;
                InsuranceAmount: Decimal;
                AssignedGrossAmountConverted: Decimal;
                //localCurrencyCode: Code[50];
                //GenLedgerSetup: Record "General Ledger Setup";
                CurrencyExchangeRate: Record "Currency Exchange Rate";
                CurrExchangeRateDate: Date;
                Fcy1ToLcyRate: Decimal;
                LcyToFcy2Rate: Decimal;
                ExchangeRate: Decimal;
                EmpMovement: Record "Internal Employement History";//Staff Movement
                EmpMovementRec: Record "Internal Employement History";
                PrevailingChange: Code[200];
                PreviousPayrollCountry: Code[50];
                PrevailingContAmount: Decimal;
                LineNumber: Integer;
                PrevPeriod: Date;
                TempCountryCurrency: Code[50];
            begin
                gvIsTerminalDuesProcessing := Employee."Under Terminal Dues Processing";
                gvRetirementBenefitsProcessing := Employee."Retirement Benefits Comp.";
                //Here we should now start looping through employment history records
                //Remove any and all calculated transactions before we start the work - this will help remove those that we don't need
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange("Is Flat Amount", false);
                Assignmatrix.DELETEALL;

                //Delete loan transactions so we can recalculate
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange("Is Loan Transaction", true);
                Assignmatrix.DELETEALL;

                //Delete all blocked transactions
                Deductions.Reset();
                Deductions.SetRange(Block, true);
                if Deductions.FindSet() then
                    repeat
                        Assignmatrix.Reset();
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Deduction);
                        Assignmatrix.SetRange(Code, Deductions.Code);
                        Assignmatrix.SetRange("Payroll Period", Month);
                        Assignmatrix.SetRange("Employee No", Employee."No.");
                        if Assignmatrix.find('-') then
                            Assignmatrix.DeleteAll();
                    until Deductions.next() = 0;

                Earnings.Reset();
                Earnings.SetRange(Block, true);
                if Earnings.FindSet() then
                    repeat
                        Assignmatrix.Reset();
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Code, Earnings.Code);
                        Assignmatrix.SetRange("Payroll Period", Month);
                        Assignmatrix.SetRange("Employee No", Employee."No.");
                        if Assignmatrix.find('-') then
                            Assignmatrix.DeleteAll();
                    until Deductions.next() = 0;

                //Validate overtime transaction to update the relevant fields
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange("Overtime Allowance", true);
                if Assignmatrix.FindSet() then
                    repeat
                        //If no sectors just delete it or at least ignore this validation
                        if (Assignmatrix."Overtime Hours" <> 0) or (Assignmatrix."Overtime Minutes" <> 0) then begin
                            Assignmatrix."Allow temp staff activation" := true;
                            Assignmatrix.Validate("Overtime Hours (Sectors)");
                            Assignmatrix.Modify();
                        end else
                            Assignmatrix.Delete(); //Just delete if these are not provided
                    until Assignmatrix.Next() = 0;

                //Lie to the system that in-house instructor allowance is an overtime allowance to joy-ride on the same treatment - we remove it hapo chini
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange("Inhouse instructor Allowance", true);
                Assignmatrix.SetRange("Inhouse Allowance Processed", false);
                if Assignmatrix.FindSet() then
                    repeat
                        Assignmatrix."Allow temp staff activation" := true;
                        Assignmatrix."Overtime Allowance" := true;
                        if Assignmatrix."Net Amount" = 0 then //Fixes an issue from 09/2025
                            Assignmatrix."Net Amount" := Assignmatrix.Amount;
                        Assignmatrix.Modify();
                    until Assignmatrix.Next() = 0;

                /*GenLedgerSetup.Get();
                localCurrencyCode := '';
                localCurrencyCode := GenLedgerSetup."LCY Code";
                if localCurrencyCode = '' then
                    Error('The local currency code has not been specified in the General Ledger Setup!');*/

                //Now start working
                ProcessedEmpCountriesFilter := '';
                PrevailingChange := '';
                PrevailingContAmount := 0;


                //If this is the current movement, copy it to the prevailing movement table
                EmpMovement.Reset();
                EmpMovement.SetRange("Emp No.", Employee."No.");
                EmpMovement.SetRange(Status, EmpMovement.Status::Current);
                if EmpMovement.FindFirst() then begin
                    if EmpMovement."Last Date" = 0D then
                        EmpMovement.Validate("First Date");
                    //Warn if current entry's terminal dues button is checked yet last date is beyond this month
                    if (EmpMovement."Terminal Dues") and (EmpMovement."Last Date" > CalcDate('CM', Month)) then
                        Error('You cannot check the Terminal Dues field where last date is beyond this month. It is only used when last date (date of leaving) is within the current month.\Kindly check ' + Employee."No." + ' - ' + Employee.FullName() + '!');

                    PeriodPrevailingMovements.Reset();
                    PeriodPrevailingMovements.SetRange("Emp No.", Employee."No.");
                    PeriodPrevailingMovements.SetRange("Payroll Period", Month);
                    PeriodPrevailingMovements.DeleteAll();

                    PeriodPrevailingMovementInit.Reset();
                    PeriodPrevailingMovementInit.Init();
                    PeriodPrevailingMovementInit."Payroll Period" := Month;
                    PeriodPrevailingMovementInit.TransferFields(EmpMovement);
                    PeriodPrevailingMovementInit.Insert();
                end;
                //Capture this period's causes of inactivity if present
                CausesOfInactivity.Reset();
                CausesOfInactivity.SetRange("Emp No.", Employee."No.");
                CausesOfInactivity.SetRange("Payroll Period", Month);
                CausesOfInactivity.DeleteAll();

                Employee.Validate("Cause of Inactivity Code");
                if Employee."Cause of Inactivity" <> '' then begin
                    CausesOfInactivityInit.Reset();
                    CausesOfInactivityInit.Init();
                    CausesOfInactivityInit."Emp No." := Employee."No.";
                    CausesOfInactivityInit."Payroll Period" := Month;
                    CausesOfInactivityInit."Cause of Inactivity" := Employee."Cause of Inactivity";
                    CausesOfInactivityInit.Insert();
                end;

                EmpMovement.Reset();
                EmpMovement.SetRange("Emp No.", Employee."No.");
                if Employee."Under Terminal Dues Processing" then
                    EmpMovement.SetRange(Status, EmpMovement.Status::Current)
                else begin
                    EmpMovement.SetFilter(Status, '<>%1', EmpMovement.Status::Pending);
                    EmpMovement.SetFilter("First Date", '<=%1', CalcDate('<CM>', Month));//As long as first date is earlier than the end of this month
                    EmpMovement.SetFilter("Last Date", '>=%1', Month);//Last date must be greater than or equal to start date of this period
                    EmpMovement.SetRange("Terminal Dues", false); //Skip those on terminal dues for now.
                    //EmpMovement.SetFilter(Type, '%1|%2|%3', EmpMovement.Type::"August 2023", EmpMovement.Type::Initial, EmpMovement.Type::Country);//For now deal only with situations where country changed - later include positions
                end;
                if EmpMovement.FindSet() then begin
                    repeat
                        //close it later down there. For now make employee details consider this
                        Employee."Date Of Join" := EmpMovement."First Date";
                        Employee."Date Of Leaving" := EmpMovement."Last Date";
                        Employee."Payroll Country" := EmpMovement."Payroll Country";

                        if EmpMovement."Payroll Country" = '' then
                            Error('You must define the Payroll Country in Employee %1''s movement entries.', Employee."No.");

                        TempCountryCurrency := '';
                        Countries.Reset();
                        Countries.SetRange(Code, EmpMovement."Payroll Country");
                        if Countries.FindFirst() then
                            TempCountryCurrency := Countries."Country Currency";
                        if TempCountryCurrency = '' then
                            Error('You must define the currency for country %1 in employee %2''s movement list.', EmpMovement."Payroll Country", Employee."No.");

                        if (EmpMovement."Payroll Currency" = '') and (Employee."Payroll Currency" <> '') then
                            EmpMovement."Payroll Currency" := Employee."Payroll Currency";
                        Employee."Payroll Currency" := EmpMovement."Payroll Currency";
                        if Employee."Payroll Currency" /*= ''*/ <> TempCountryCurrency then begin
                            /*Countries.Reset();
                            Countries.SetRange(Code, EmpMovement."Payroll Country");
                            if Countries.FindFirst() then begin*/
                            Employee."Payroll Currency" := TempCountryCurrency; //Countries."Country Currency";
                            EmpMovement."Payroll Currency" := TempCountryCurrency; //Countries."Country Currency";
                            //end;
                        end;
                        Employee."Contractual Amount Type" := EmpMovement."Contractual Amount Type";
                        Employee."Contractual Amount Currency" := EmpMovement."Contractual Amount Currency";
                        Employee."Assigned Gross Pay" := EmpMovement."Contractual Amount Value";
                        Employee."No Transport Allowance" := EmpMovement."No Transport Allowance";
                        Employee."Applicable House Allowance (%)" := EmpMovement."Applicable House Allowance (%)";
                        Employee."Apply Paye Multiplier" := EmpMovement."Apply Paye Multiplier";
                        Employee."Paye Multiplier" := EmpMovement."Paye Multiplier";
                        GrossPayRwf := 0;

                        if (EmpMovement.Type in [EmpMovement.Type::"August 2023", EmpMovement.Type::Initial]) and (PrevailingChange <> 'INITIAL') then begin
                            PrevailingChange := 'INITIAL';
                            PrevailingContAmount := 0;
                        end;

                        if PreviousPayrollCountry = '' then
                            PreviousPayrollCountry := EmpMovement."Payroll Country";
                        if ((EmpMovement.Type in [EmpMovement.Type::Country]) or (PreviousPayrollCountry <> EmpMovement."Payroll Country")) and (PrevailingChange <> 'COUNTRY' + EmpMovement."Payroll Country") then begin
                            PrevailingChange := 'COUNTRY' + EmpMovement."Payroll Country";
                            PrevailingContAmount := 0;
                        end;
                        PreviousPayrollCountry := EmpMovement."Payroll Country";

                        if (PrevailingChange = '') then begin
                            PrevailingChange := 'INITIAL';
                            PrevailingContAmount := 0;
                        end;

                        //Message('start');
                        //If Date of leaving is Past & the Employee is Inactive Clear his Payroll Info======
                        //FRED 19/4/23 - If contract end date is set, use it as date of leaving - without necessarily updating the employee table
                        if (Employee."Contract End Date" <> 0D) and (Employee."Date Of Leaving" = 0D) then
                            Employee."Date Of Leaving" := Employee."Contract End Date";

                        if (Employee."Date Of Leaving" <> 0D) and (EmpMovement.Status = EmpMovement.Status::Current) and (not Employee."Under Terminal Dues Processing") then begin
                            if Employee."Date Of Leaving" < Month then begin
                                conftxt := 'Please Note that Employee No: ' + Employee."No." + '- ' + Employee."First Name" + ' ' + Employee."Last Name" + ' \has a Date of Leaving that is ' + Format(Employee."Date Of Leaving") + ' which is Past as Compared to this';
                                conftxt := conftxt + ' Payroll Period-' + Format(Month) + '\Do you want to Clear their Payroll Information for this Month?';
                                conf := Confirm(conftxt);
                                if Format(conftxt) = 'Yes' then begin
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetFilter("Payroll Period", '%1', Month);
                                    Assignmatrix.SetFilter("Employee No", Employee."No.");
                                    Assignmatrix.SetRange("Allow temp staff activation", false);
                                    if Assignmatrix.FindSet then
                                        repeat
                                            Assignmatrix.Delete;
                                        until Assignmatrix.Next = 0;
                                end;
                            end;
                        end;


                        //==========================================================================Update Basic Pay
                        //22/3/23 - For employees with daily rates, set the total amount here as the basic pay
                        CurrMonthEnd := CalcDate('<CM>', Month);
                        CurrMonthStart := CalcDate('-CM', Month);
                        if (Employee."Date Of Leaving" < CurrMonthEnd) and (Employee."Under Terminal Dues Processing") then
                            Employee."Date Of Leaving" := CurrMonthEnd;

                        //24/4/23
                        if (Employee."Contract Start Date" > Employee."Date Of Join") and (Employee."Contract Type" <> 'PERMANENT') then
                            Employee."Date Of Join" := Employee."Contract Start Date";

                        //if Apply Daily Rates
                        if Employee."Apply Daily Rates" then
                            CurrMonthStart := Employee."Date Of Join";

                        //24/4/23
                        if (Employee."Contract End Date" <> 0D) and (Employee."Date Of Leaving" = 0D) then
                            Employee."Date Of Leaving" := Employee."Contract End Date";

                        if Employee."Date Of Leaving" <> 0D then begin
                            if Employee."Date Of Leaving" < CurrMonthEnd then
                                CurrMonthEnd := Employee."Date Of Leaving";
                        end;

                        CurrMonthDays := CurrMonthEnd - CurrMonthStart;
                        CurrMonthDays := CurrMonthDays + 1;
                        NonWorkingDays := 0;

                        if (Employee."Date Of Join" <> 0D) and (Employee."Apply Daily Rates") then begin
                            HRCalendarList.Reset;
                            //HRCalendarList.SETRANGE(HRCalendarList.Date,CurrMonthStart,Emp."Date Of Join");
                            HRCalendarList.SetRange(HRCalendarList.Date, CurrMonthStart, CurrMonthEnd);
                            HRCalendarList.SetRange(HRCalendarList."Non Working", true);
                            if not Employee."Apply Daily Rates" then
                                HRCalendarList.SetFilter(Reason, 'Saturday|Sunday');
                            if HRCalendarList.FindSet then begin
                                NonWorkingDays := HRCalendarList.Count;
                            end;


                            //ERROR('CurrMonthDays = '+FORMAT(CurrMonthDays)+'-NonWorkingDays='+FORMAT(NonWorkingDays) + 'Basic = '+ FORMAT(Employee."Basic Pay"));
                            //ERROR('%1',NonWorkingDays);
                            //ERROR('%1',ROUND(CurrMonthDays-NonWorkingDays));
                            Employee."Basic Pay" := Round((CurrMonthDays - NonWorkingDays) * (Employee."Daily Rate"), 0.01, '=');
                            Employee."Assigned Gross Pay" := Round((CurrMonthDays - NonWorkingDays) * (Employee."Daily Rate"), 0.01, '=');
                            //ERROR('here '+FORMAT(Employee."Basic Pay"));
                            //->Employee.Modify;
                            //->Commit;
                        end;

                        //Contractual Amount Currency conversions
                        AssignedGrossAmountConverted := Employee."Assigned Gross Pay";
                        CurrExchangeRateDate := CalcDate('1M', Month);
                        Fcy1ToLcyRate := 0;
                        LcyToFcy2Rate := 0;
                        ExchangeRate := 1;
                        LastEmployeeNo := Employee."No.";
                        LastPayrollCountry := Employee."Payroll Country";
                        LastCurrencyCode := Employee."Payroll Currency";

                        if (Employee."Payroll Currency" = '') then
                            Error('You must set the payroll currency for employee No. %1', Employee."No.");

                        //If expatriate and contract is in NET USD, get the gross USD
                        //if ((Employee."Payroll Country" = 'EXPATRIATE') OR (Employee."Payroll Country" = 'RWANDA') OR (Employee."Payroll Country" = 'BURUNDI') OR (Employee."Payroll Country" = 'GHANA') OR (Employee."Payroll Country" = 'KENYA') OR (Employee."Payroll Country" = 'UGANDA') OR (Employee."Payroll Country" = 'TANZANIA') OR (Employee."Payroll Country" = 'ZIMBABWE')) /*and (EmpMovement."Contractual Amount Type" = EmpMovement."Contractual Amount Type"::"Net Pay")/and (EmpMovement."Contractual Amount Currency" = 'USD')*/ then
                        if (Employee."Payroll Country" IN ['EXPATRIATE', 'RWANDA', 'BURUNDI', 'GHANA', 'KENYA', 'UGANDA', 'TANZANIA', 'ZIMBABWE',/*from 13/08/24*/'CABIN', 'BENIN', 'ZAMBIA', 'BRAZA', 'DUBAI', 'GABON', 'INDIA', 'QATAR', 'UK', 'CAMEROON', 'NIGERIA', 'S.AFRICA', 'CONSULTANT']) then
                            AssignedGrossAmountConverted := FnGrossUpContractualAmount(Employee, EmpMovement/*,AssignedGrossAmountConverted*/, Month)
                        else begin
                            if ((Employee."Contractual Amount Currency" <> '') and (Employee."Contractual Amount Currency" <> Employee."Payroll Currency")) then begin

                                /*GenLedgerSetup.Get();
                                localCurrencyCode := GenLedgerSetup."LCY Code";
                                if localCurrencyCode = '' then
                                    Error('The local currency code has not been specified in the General Ledger Setup!');*/
                                //The target is the payroll currency, so if the payroll currency is local, then we just convert to local
                                if (Employee."Payroll Currency" = localCurrencyCode) then begin
                                    CurrencyExchangeRate.GetLastestExchangeRateCustom(Employee."Contractual Amount Currency", CurrExchangeRateDate, ExchangeRate);
                                    if (CurrExchangeRateDate = 0D) then
                                        Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', Employee."Contractual Amount Currency", localCurrencyCode);
                                end else begin
                                    //If they want to change from FCY1 to FCY2 but now they need to pass through LCY
                                    if (Employee."Payroll Currency" <> localCurrencyCode) then begin
                                        //1. Get the FCY1 to LCY rate
                                        CurrencyExchangeRate.GetLastestExchangeRateCustom(Employee."Contractual Amount Currency", CurrExchangeRateDate, Fcy1ToLcyRate);
                                        if (CurrExchangeRateDate = 0D) then
                                            Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', Employee."Contractual Amount Currency", localCurrencyCode);

                                        //2. Get the LCY to FCY2 rate
                                        CurrencyExchangeRate.GetLastestExchangeRateCustom(Employee."Payroll Currency", CurrExchangeRateDate, LcyToFcy2Rate);
                                        if (CurrExchangeRateDate = 0D) then
                                            Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, Employee."Payroll Currency");

                                        //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
                                        if LcyToFcy2Rate = 0 then
                                            LcyToFcy2Rate := 1;
                                        ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
                                    end;
                                end;
                            end;
                            AssignedGrossAmountConverted := Employee."Assigned Gross Pay" * ExchangeRate;
                        end;

                        //Message('here');
                        if Employee."Date Of Leaving" < Employee."Date Of Join" then
                            Error('The date of leaving %1 is earlier than date of join %2 for employee %3', Employee."Date Of Leaving", Employee."Date Of Join", Employee."No.");

                        //Have that contractual amount prorated here, so that we can use the correct figure going forward
                        GrossPayRwf := FnProratePay(Employee."No.", Month, Employee."Date Of Join", Employee."Date Of Leaving", Employee."Payroll Country", AssignedGrossAmountConverted, Employee."Apply Daily Rates", Employee."Daily Rate"/*Employee."Assigned Gross Pay"*/);
                        PrevailingContAmount += GrossPayRwf;

                        //If person joined last month and has was not paid any salary, consider prorating that as well
                        PrevPeriod := CalcDate('-1M', Month);
                        EmpMovementRec.Reset();
                        EmpMovementRec.SetRange("Emp No.", Employee."No.");
                        EmpMovementRec.SetRange(Status, EmpMovementRec.Status::Current);
                        EmpMovementRec.SetFilter("First Date", '%1..%2', CalcDate('<-CM>', PrevPeriod), CalcDate('<CM>', PrevPeriod));//Joined last month
                        EmpMovementRec.SetRange("Terminal Dues", false); //Skip those on terminal dues for now.
                        EmpMovementRec.SetFilter(Type, '%1|%2', EmpMovementRec.Type::"August 2023", EmpMovementRec.Type::Initial);
                        if (EmpMovementRec.FindFirst()) and (not Employee."Under Terminal Dues Processing") then begin
                            //Check if they got paid anything last month
                            Assignmatrix.RESET;
                            Assignmatrix.SETRANGE("Employee No", Employee."No.");
                            Assignmatrix.SETRANGE("Payroll Period", PrevPeriod);
                            if not Assignmatrix.FindFirst() then begin
                                //They were not paid siet, prorate and add to contractual - maybe confirm with the user
                                if confirm('Staff ' + Employee."No." + ' - ' + Employee."First Name" + ' ' + Employee."Last Name" + ' joined last month on ' + format(EmpMovementRec."First Date") + ' and was not paid any salary.\ Do you want to prorate and combine their last month salary with the current?') then begin
                                    GrossPayRwf := FnProratePay(Employee."No.", PrevPeriod, EmpMovementRec."First Date", EmpMovementRec."Last Date", Employee."Payroll Country", AssignedGrossAmountConverted, Employee."Apply Daily Rates", Employee."Daily Rate"/*Employee."Assigned Gross Pay"*/);
                                    PrevailingContAmount += GrossPayRwf;
                                end;
                            end;
                        end;

                        //Create the temp table entries
                        TempEmpMovement.Reset();
                        TempEmpMovement.SetRange("Emp No.", Employee."No.");
                        TempEmpMovement.SetRange("Change Type", PrevailingChange);
                        if TempEmpMovement.FindFirst() then begin
                            TempEmpMovement."First Date" := EmpMovement."First Date";
                            TempEmpMovement."Last Date" := EmpMovement."Last Date";
                            TempEmpMovement."Payroll Country" := EmpMovement."Payroll Country";
                            TempEmpMovement."Payroll Currency" := EmpMovement."Payroll Currency";
                            TempEmpMovement."Contractual Amount Type" := EmpMovement."Contractual Amount Type";
                            TempEmpMovement."Contractual Amount Currency" := Employee."Payroll Currency";
                            TempEmpMovement."Contractual Amount Value" := PrevailingContAmount;//EmpMovement."Contractual Amount Value";
                            TempEmpMovement."No Transport Allowance" := EmpMovement."No Transport Allowance";
                            TempEmpMovement."Applicable House Allowance (%)" := EmpMovement."Applicable House Allowance (%)";
                            TempEmpMovement."Apply Paye Multiplier" := EmpMovement."Apply Paye Multiplier";
                            TempEmpMovement."Paye Multiplier" := EmpMovement."Paye Multiplier";
                            TempEmpMovement.Modify();
                        end else begin
                            TempEmpMovementInit.Reset();
                            TempEmpMovementInit.Init();
                            TempEmpMovementInit."First Date" := EmpMovement."First Date";
                            TempEmpMovementInit."Last Date" := EmpMovement."Last Date";
                            TempEmpMovementInit."Payroll Country" := EmpMovement."Payroll Country";
                            TempEmpMovementInit."Payroll Currency" := EmpMovement."Payroll Currency";
                            TempEmpMovementInit."Contractual Amount Type" := EmpMovement."Contractual Amount Type";
                            TempEmpMovementInit."Contractual Amount Currency" := Employee."Payroll Currency";
                            TempEmpMovementInit."Contractual Amount Value" := PrevailingContAmount;//EmpMovement."Contractual Amount Value";
                            TempEmpMovementInit."No Transport Allowance" := EmpMovement."No Transport Allowance";
                            TempEmpMovementInit."Applicable House Allowance (%)" := EmpMovement."Applicable House Allowance (%)";
                            TempEmpMovementInit."Apply Paye Multiplier" := EmpMovement."Apply Paye Multiplier";
                            TempEmpMovementInit."Paye Multiplier" := EmpMovement."Paye Multiplier";
                            TempEmpMovementInit."Change Type" := PrevailingChange;
                            TempEmpMovementInit."Emp No." := Employee."No.";
                            TempEmpMovementInit.Insert();
                        end;
                    until EmpMovement.Next() = 0;
                end;


                //Above code is repeated so that we only end up with a loop representing the targeted number of payslips


                TempEmpMovement.Reset();
                TempEmpMovement.SetRange("Emp No.", Employee."No.");
                //TempEmpMovement.SetFilter(Status, '<>%1', EmpMovement.Status::Pending);
                //TempEmpMovement.SetFilter("First Date", '<=%1', CalcDate('<CM>', Month));//As long as first date is earlier than the end of this month
                //TempEmpMovement.SetFilter("Last Date", '>=%1', Month);//Last date must be greater than or equal to start date of this period
                //TempEmpMovement.SetFilter(Type, '%1|%2|%3', EmpMovement.Type::"August 2023", EmpMovement.Type::Initial, EmpMovement.Type::Country);//For now deal only with situations where country changed - later include positions
                if TempEmpMovement.FindFirst() then begin
                    repeat
                        //close it later down there. For now make employee details consider this
                        Employee."Date Of Join" := TempEmpMovement."First Date";
                        Employee."Date Of Leaving" := TempEmpMovement."Last Date";
                        Employee."Payroll Country" := TempEmpMovement."Payroll Country";
                        Employee."Payroll Currency" := TempEmpMovement."Payroll Currency";
                        Employee."Contractual Amount Type" := TempEmpMovement."Contractual Amount Type";
                        Employee."Contractual Amount Currency" := TempEmpMovement."Contractual Amount Currency";
                        Employee."Assigned Gross Pay" := TempEmpMovement."Contractual Amount Value";
                        Employee."No Transport Allowance" := TempEmpMovement."No Transport Allowance";
                        Employee."Applicable House Allowance (%)" := TempEmpMovement."Applicable House Allowance (%)";
                        Employee."Apply Paye Multiplier" := TempEmpMovement."Apply Paye Multiplier";
                        Employee."Paye Multiplier" := TempEmpMovement."Paye Multiplier";
                        GrossPayRwf := TempEmpMovement."Contractual Amount Value";

                        if (TempEmpMovement."Payroll Country" <> '') and (StrPos(ProcessedEmpCountriesFilter, TempEmpMovement."Payroll Country") = 0) then begin
                            if ProcessedEmpCountriesFilter = '' then
                                ProcessedEmpCountriesFilter += '<>' + TempEmpMovement."Payroll Country"
                            else
                                ProcessedEmpCountriesFilter += '&<>' + TempEmpMovement."Payroll Country";
                        end;

                        if Employee."Payroll Currency" = '' then
                            Error('You must populate the Payroll Currency for Employee %1!', Employee."No.");

                        SportFacilitationAllowance := 0;
                        IsGivenSpecialTransportAllowance := false;
                        SpecialTransportAllowanceGross := 0;
                        SpecialTransportAllowanceStatutoryDeductions := 0;
                        Clear(NoRepeatDeductions);
                        SpecialTransportAllowancePAYE := 0;
                        Employee.CalcFields("Given Transport Allowance");
                        if Employee."Given Transport Allowance" then begin
                            IsGivenSpecialTransportAllowance := true;
                            //Get transport allowance to reduce from the statutory net
                            /*Assignmatrix.RESET;
                            Assignmatrix.SETRANGE("Employee No", Employee."No.");
                            Assignmatrix.SETRANGE("Payroll Period", Month);
                            Assignmatrix.SetRange("Transaction Title", 'SPORT FACILITATION ALLOWANCE');
                            if Assignmatrix.FindFirst() then begin
                                Assignmatrix.Validate(Amount);
                                SportFacilitationAllowance := ABS(GetInDesiredCurrency('RWF', Employee."Payroll Currency", Assignmatrix.Amount, Month, Employee));
                            end;*/
                        end;

                        BasicSalaryCode := '';
                        ContractualAmountCode := '';
                        ContractualAmountGoesToMatrix := false;
                        Earnings.Reset;
                        Earnings.SetRange(Country, Employee."Payroll Country");
                        //Earnings.SetRange("Basic Salary Code", true);
                        Earnings.setrange("Is Contractual Amount", true);
                        Earnings.SetRange(Block, false);
                        if (Earnings.findfirst) AND (GrossPayRwf <> 0) then begin
                            BasicSalaryCode := Earnings.code;
                            ContractualAmountCode := Earnings.code;
                            ContractualAmountGoesToMatrix := Earnings."Goes to Matrix";

                            /*Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                            Assignmatrix.SetRange(Code, /*BasicSalaryCode/ContractualAmountCode);
                            Assignmatrix.SetRange(Country, Employee."Payroll Country");
                            if not Assignmatrix.FindFirst then begin*/
                            Assignmatrix.reset;
                            Assignmatrix.Init;
                            Assignmatrix."Employee No" := Employee."No.";
                            Assignmatrix.Type := Assignmatrix.Type::Payment;
                            Assignmatrix.Country := Employee."Payroll Country";
                            Assignmatrix.Code := ContractualAmountCode;
                            Assignmatrix."Country Currency" := Employee."Payroll Currency";
                            Assignmatrix.Validate(Code, /*BasicSalaryCode*/ContractualAmountCode);
                            Assignmatrix."Payroll Period" := Month;
                            Assignmatrix."Gross Pay" := false;
                            Assignmatrix."Basic Salary Code" := false;
                            if (Employee."Contractual Amount Type" = Employee."Contractual Amount Type"::"Gross Pay") OR ((Employee."Contractual Amount Type" = Employee."Contractual Amount Type"::"Net Pay")) then
                                Assignmatrix."Gross Pay" := true;
                            if Employee."Contractual Amount Type" = Employee."Contractual Amount Type"::"Basic Pay" then
                                Assignmatrix."Basic Salary Code" := true;
                            if Earnings."Basic Salary Code" then
                                Assignmatrix."Basic Salary Code" := true;
                            //Assignmatrix.Validate(Amount, Employee."Assigned Gross Pay"/*"Basic Pay"*/);
                            Assignmatrix.Amount := GrossPayRwf;//AssignedGrossAmountConverted;//Employee."Assigned Gross Pay";
                            Assignmatrix.validate(Amount);
                            //Message('Contractual amount = %1',Assignmatrix.Amount);
                            Assignmatrix."Country Currency" := Employee."Payroll Currency";
                            Assignmatrix.Description := Earnings.Description;//format(Employee."Contractual Amount Type");//'Basic Pay';
                            Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                            Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                            //if (Employee."Payroll Country" <> 'GHANA') and (Employee."Payroll Country" <> 'BURUNDI') and (Employee."Payroll Country" <> 'KENYA') and (Employee."Payroll Country" <> 'ZIMBABWE') then
                            if not Assignmatrix.Insert then Assignmatrix.modify;
                            /*end else
                            //IF {NOT} Assignmatrix.FINDSET THEN
                            begin
                                //Assignmatrix.DELETEALL;

                                /*Assignmatrix.INIT;
                                Assignmatrix."Employee No":=Employee."No.";/
                                Assignmatrix.Type := Assignmatrix.Type::Payment;
                                //Assignmatrix.VALIDATE(Code,BasicSalaryCode);
                                //Assignmatrix."Payroll Period":=Month;
                                //ERROR('Basic %1',Employee."Basic Pay");
                                Assignmatrix.Validate(Amount, Employee."Assigned Gross Pay"/*"Basic Pay"/);
                                Assignmatrix.Description := format(Employee."Contractual Amount Type");//'Basic Pay';
                                Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                Assignmatrix.Country := Employee."Payroll Country";
                                /*IF NOT Assignmatrix.INSERT THEN/
                                Assignmatrix.Modify;
                            end;*/
                        end;

                        InsuranceReliefCode := '';
                        Earnings.Reset;
                        Earnings.SetRange("Insurance Relief", true);
                        Earnings.SetRange(Country, Employee."Payroll Country");
                        Earnings.SetRange(Block, false);
                        if Earnings.findfirst then
                            InsuranceReliefCode := Earnings.code;


                        //==========================================================================Update Insurance Relief
                        /*Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                        Assignmatrix.SetRange(Assignmatrix.Code, InsuranceReliefCode);
                        if Assignmatrix.FindSet then begin
                            Assignmatrix.DeleteAll;
                        end;*/


                        /*Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                        Assignmatrix.SetRange(Assignmatrix.Code, InsuranceReliefCode);
                        if not Assignmatrix.FindFirst then begin*/

                        if InsuranceReliefCode <> '' then begin
                            Assignmatrix.Init;
                            Assignmatrix."Employee No" := Employee."No.";
                            Assignmatrix.Type := Assignmatrix.Type::Payment;
                            Assignmatrix.Validate(Code, InsuranceReliefCode);
                            Assignmatrix."Payroll Period" := Month;
                            Assignmatrix.Description := 'Insurance Relief';
                            Assignmatrix."Country Currency" := Employee."Payroll Currency";
                            Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                            Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                            Assignmatrix.Country := Employee."Payroll Country";
                            if not Assignmatrix.Insert then Assignmatrix.modify;
                        end;

                        //==================================================================================
                        //Check the Balances and stop if the Amounts are zero.



                        /*Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                        Assignmatrix.SetRange(Assignmatrix.Code, 'E02');
                        if (not Assignmatrix.FindSet) and (not Employee."Is Seconded") then begin
                            Assignmatrix.Init;
                            Assignmatrix."Employee No" := Employee."No.";
                            Assignmatrix.Type := Assignmatrix.Type::Payment;
                            Assignmatrix.Validate(Code, 'E02');
                            Assignmatrix."Payroll Period" := Month;
                            //Assignmatrix.Description:='Insurance Relief';
                            Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                            Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                            Assignmatrix.Insert;
                        end;*/


                        if Employee."Secondment Amount" <> 0 then begin

                            Secondd.Reset;
                            Secondd.SetRange("Employee No", Employee."No.");
                            Secondd.SetRange("Payroll Period", Month);
                            if Secondd.Find('-') then begin
                                Secondd."Secondment Amount" := Employee."Secondment Amount";
                                Secondd."Secondment Basic" := Employee."Secondment Basic";
                                //MESSAGE('Secondment Modify %1 Month %2',Employee."Secondment Amount",Month);
                                Secondd.Modify;
                            end else begin
                                Secondd.Init;
                                Secondd."Employee No" := Employee."No.";
                                Secondd."Payroll Period" := Month;
                                Secondd."Secondment Amount" := Employee."Secondment Amount";
                                Secondd."Secondment Basic" := Employee."Secondment Basic";
                                // MESSAGE('Secondment Insert %1 Month %2',Employee."Secondment Amount",Month);
                                Secondd.Insert;
                            end;
                        end;

                        ClosingBal := 0;

                        Deductions.Reset;
                        Deductions.SetRange(Deductions.Shares, true);
                        //Deductions.SETRANGE(Deductions.Code,
                        Deductions.SetRange(Country, Employee."Payroll Country");
                        Deductions.SetRange(Block, false);
                        if Deductions.Find('-') then begin
                            repeat
                                Assignmatrix.Reset;
                                Assignmatrix.SetRange("Employee No", "No.");
                                Assignmatrix.SetRange(Code, Deductions.Code);
                                Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                if Assignmatrix.Find('-') then begin

                                    Assignmatrix7.Reset;
                                    //Assignmatrix7.INIT;
                                    Assignmatrix7.SetFilter(Assignmatrix7."Employee No", "No.");
                                    Assignmatrix7.SetFilter(Assignmatrix7.Code, Deductions.Code);
                                    Assignmatrix7."Country Currency" := Employee."Payroll Currency";
                                    Assignmatrix7.SetFilter(Assignmatrix7."Payroll Period", '%1', CalcDate('-1M', Month));
                                    if Assignmatrix7.FindSet then begin
                                        Assignmatrix.Country := Employee."Payroll Country";
                                        Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                        Assignmatrix.Description := Deductions.Description;
                                        Assignmatrix."Outstanding Amount" := Abs(Assignmatrix7."Outstanding Amount") + Abs(Assignmatrix.Amount);
                                        Assignmatrix.validate(Amount);
                                        Assignmatrix.Modify;
                                    end;

                                end;

                            until Deductions.Next = 0;
                        end;

                        Deductions.Reset;
                        Deductions.SetRange(Deductions.Loan, true);
                        Deductions.setrange(Country, Employee."Payroll Country");
                        Deductions.SetRange(Block, false);
                        if Deductions.Find('-') then begin
                            repeat
                                Assignmatrix.Reset;
                                Assignmatrix.SetRange("Employee No", Employee."No.");
                                Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Deduction);
                                Assignmatrix.SetRange(Code, Deductions.Code);
                                Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                if Assignmatrix.Find('-') then begin
                                    LoanApps.Reset;
                                    LoanApps.SetRange("Loan No", Assignmatrix."Reference No");
                                    LoanApps.SetRange("Stop Loan", false); //To ensure only Live Loans are Deducted
                                    if LoanApps.Find('-') then begin
                                        REPAREC.SetRange(REPAREC."Employee No", Assignmatrix."Employee No");
                                        REPAREC.SetRange(REPAREC."Repayment Date", Assignmatrix."Payroll Period");
                                        REPAREC.SetRange(REPAREC."Loan No", Assignmatrix."Reference No");
                                        if REPAREC.Find('-') then begin
                                            Assignmatrix."Outstanding Amount" := REPAREC."Remaining Debt";
                                            Assignmatrix."Interest Amount" := Abs(REPAREC."Monthly Interest");
                                            Assignmatrix."Amount  less interest" := Abs(REPAREC."Principal Repayment");
                                            if LoanApps."Interest Calculation Method" = LoanApps."Interest Calculation Method"::"Sacco Reducing Balance" then
                                                Assignmatrix.Amount := -REPAREC."Principal Repayment" else
                                                Assignmatrix.Amount := 0 - Abs(REPAREC."Monthly Repayment");
                                            if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                                Assignmatrix.Amount := Deductions."Maximum Amount";
                                            Assignmatrix.validate(Amount);
                                            Assignmatrix.Modify;
                                            if ((REPAREC."Monthly Interest" <> 0) and (LoanApps."Interest Deduction Code" <> '')) then begin
                                                Assignmatrix7.Reset;
                                                Assignmatrix7.SetRange("Employee No", Assignmatrix."Employee No");
                                                Assignmatrix7.SetRange(Type, Assignmatrix7.Type::Deduction);
                                                Assignmatrix7.SetRange(Code, LoanApps."Interest Deduction Code");
                                                Assignmatrix7.SetRange("Payroll Period", Assignmatrix."Payroll Period");
                                                if Assignmatrix7.Find('-') then begin
                                                    Assignmatrix7.Amount := -REPAREC."Monthly Interest";
                                                    if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix7.Amount) > abs(Deductions."Maximum Amount"))) then
                                                        Assignmatrix7.Amount := Deductions."Maximum Amount";
                                                    Assignmatrix7."Country Currency" := Employee."Payroll Currency";
                                                    Assignmatrix7.validate(Amount);
                                                    Assignmatrix7.Modify;
                                                end else begin
                                                    Assignmatrix7.Init;
                                                    Assignmatrix7."Employee No" := Employee."No.";
                                                    Assignmatrix7.Country := Employee."Payroll Country";
                                                    Assignmatrix7.Validate("Employee No");
                                                    Assignmatrix.Description := Deductions.Description;
                                                    Assignmatrix7.Type := Assignmatrix7.Type::Deduction;
                                                    Assignmatrix7.Code := LoanApps."Interest Deduction Code";
                                                    Assignmatrix7."Country Currency" := Employee."Payroll Currency";
                                                    Assignmatrix7."Payroll Period" := Month;
                                                    Assignmatrix7.Validate(Code);
                                                    Assignmatrix7.Amount := -REPAREC."Monthly Interest";
                                                    if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix7.Amount) > abs(Deductions."Maximum Amount"))) then
                                                        Assignmatrix7.Amount := Deductions."Maximum Amount";
                                                    Assignmatrix7."Country Currency" := Employee."Payroll Currency";
                                                    Assignmatrix7.Validate(Amount);
                                                    Assignmatrix7.Insert;

                                                end;
                                            end;
                                        end;

                                    end;
                                    RepaymentAmt := Assignmatrix.Amount;
                                    LoanApps.Reset;
                                    LoanApps.SetRange(LoanApps."Employee No", Assignmatrix."Employee No");
                                    LoanApps.SetRange(LoanApps."Loan No", Assignmatrix."Reference No");
                                    LoanApps.SetRange(LoanApps."Loan Product Type", Assignmatrix.Code);
                                    if LoanApps.Find('-') then begin
                                    end;
                                end;
                            until Deductions.Next = 0;
                        end;

                        //Annual Increament
                        IncrMonth := Format(Employee."Incremental Month");
                        if IncrMonth = Format(Month, 0, '<Month Text>') then begin
                            if Employee."Salary Changed" = false then begin
                                if SalaryScale.Get(Employee."Salary Scale") then begin
                                    if SalaryScale."Maximum Pointer" <> Employee.Present then begin
                                        Employee.Previous := Employee.Present;
                                        Employee.Present := IncStr(Employee.Present);
                                        Employee."Salary Changed" := true;
                                        //Pause for now due to using of emp movement
                                        //->Employee.Modify;
                                    end;
                                end;
                            end;
                        end else begin
                            Employee."Salary Changed" := false;
                            //=>Employee.Modify;
                        end;


                        //Assign earnings from scale pointers
                        /********************* Pause a bit for now
                        Earnings.Reset;
                        Earnings.SetRange(Earnings."Applies to All", true);
                        Earnings.setrange(Country, Employee."Payroll Country");
                        //Earnings.SetRange("Basic Salary Code", true);
                        Earnings.SetRange("Is Contractual Amount", true);
                        if Earnings.Find('-') then begin
                            repeat
                                //BasicSalaryCode := Earnings.Code;

                                if ScaleBenefits.Get(Employee."Salary Scale", Employee.Present, ///BasicSalaryCode//ContractualAmountCode///) then begin

                            Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix.Code, ContractualAmountCode);
                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Payment);
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                            Assignmatrix.SetRange(Country, Employee."Payroll Country");
                            if Assignmatrix.Find('-') then begin
                                Assignmatrix.Amount := ScaleBenefits.Amount;
                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                Assignmatrix.Modify;
                            end
                            else begin
                                // MESSAGE('%1%2',MonthTxt,MonthTxt1);
                                Assignmatrix.Init;
                                Assignmatrix."Employee No" := Employee."No.";
                                Assignmatrix.Type := Assignmatrix.Type::Payment;
                                Assignmatrix.Code := ContractualAmountCode;//BasicSalaryCode;
                                Assignmatrix.Validate(Assignmatrix.Code);
                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                Assignmatrix."Payroll Period" := Month;
                                Assignmatrix.Description := Earnings.Description;
                                Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                Assignmatrix.Amount := ScaleBenefits.Amount;
                                Assignmatrix."Manual Entry" := false;
                                Assignmatrix.Country := Employee."Payroll Country";
                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                Assignmatrix.Insert;
                                //ERROR('EmpNo %3 Erning1%1 AMount%2',BasicSalaryCode,ScaleBenefits.Amount,Assignmatrix."Employee No");
                            end;
                        end;
                    until Earnings.Next = 0;
                end;*/
                        /*
                        //Assign Earnings in a defined month
                        MonthTxt:='';
                        MonthTxt1:='';
                        MonthTxt:=FORMAT(Month,0,'<Month Text>');
                        Earnings.RESET;
                        Earnings.SETRANGE("Defined Month",TRUE);
                        IF Earnings.FIND('-') THEN BEGIN
                          REPEAT
                            MonthTxt1:=FORMAT(Earnings.Month);
                         //MESSAGE('%1%2  Month %3 Code %4',MonthTxt,MonthTxt1,Month,Earnings.Code);
                            IF MonthTxt=MonthTxt1 THEN BEGIN
                              Assignmatrix.RESET;
                              Assignmatrix.SETRANGE(Assignmatrix.Code,Earnings.Code);
                              Assignmatrix.SETRANGE(Assignmatrix.Type,Assignmatrix.Type::Payment);
                              Assignmatrix.SETRANGE(Assignmatrix."Employee No",Employee."No.");
                              Assignmatrix.SETRANGE(Assignmatrix."Payroll Period",Month);
                              IF Assignmatrix.FIND('-') THEN BEGIN
                               //ERROR('%2 Relief2 %1 Month %3',Earnings.Description,Employee."No.",Month);
                                Assignmatrix.VALIDATE(Code);
                              ERROR('Erningggg%1Amount%2',Assignmatrix.Code,Assignmatrix.Amount);
                                Assignmatrix.MODIFY;
                                END ELSE BEGIN
                                  //MESSAGE('Relief1%1 Amount %2',Earnings.Description,Assignmatrix.Amount);
                                  Assignmatrix.INIT;
                                  Assignmatrix."Employee No":=Employee."No.";
                                  Assignmatrix.VALIDATE("Employee No");
                                  Assignmatrix.Type:=Assignmatrix.Type::Payment;
                                  Assignmatrix."Payroll Period":=Month;
                                  Assignmatrix.Code:=Earnings.Code;
                                  Assignmatrix.VALIDATE(Assignmatrix.Code);
                                  Assignmatrix."Global Dimension 1 code":=Employee."Global Dimension 1 Code";
                                  Assignmatrix."Global Dimension 2 Code":=Employee."Global Dimension 2 Code";
                                  Assignmatrix."Manual Entry":=FALSE;
                                  Assignmatrix.INSERT;

                                  END;
                                  //ERROR('%2 Relief2 %1 Month %3',Earnings.Description,Employee."No.",Month);
                                  //MESSAGE('Relief1%1 Amount %2',Earnings.Description,Assignmatrix.Amount);
                              END;
                            UNTIL Earnings.NEXT=0;
                          END;
                        */

                        /* //FRED 22/5/23 - Moved to the end of the process so that the prorated basic pay may be used
                        IF Employee."Earns Gratuity" = TRUE THEN BEGIN
                        Assignmatrix.RESET;
                        Assignmatrix.SETRANGE(Assignmatrix."Employee No",Employee."No.");
                        Assignmatrix.SETRANGE(Assignmatrix."Payroll Period",Month);
                        Assignmatrix.SETRANGE(Assignmatrix.Code,'E04');
                        IF NOT Assignmatrix.FINDSET THEN
                          BEGIN
                            Assignmatrix.INIT;
                            Assignmatrix."Employee No":=Employee."No.";
                            Assignmatrix.Type:=Assignmatrix.Type::Payment;
                            Assignmatrix.VALIDATE(Code,'E04');
                            Assignmatrix."Payroll Period":=Month;
                            //Assignmatrix.Description:='Insurance Relief';
                            Assignmatrix."Global Dimension 1 code":=Employee."Global Dimension 1 Code";
                            Assignmatrix."Global Dimension 2 Code":=Employee."Global Dimension 2 Code";
                            Assignmatrix.INSERT;
                          END;
                        END;
                        */


                        //For RwandAir we work with Gross then compute the rest
                        //check if basic pay for the month exists else insert
                        GrossPayCode := '';
                        ///GrossPayRwf := AssignedGrossAmountConverted;//Employee."Assigned Gross Pay";
                        BasicSalaryRwf := 0;
                        TransportAllowanceRwf := 0;
                        Earnings.Reset;
                        //Earnings.SetRange("Gross Pay", true);
                        Earnings.SetRange(Country, Employee."Payroll Country");
                        Earnings.SetRange("Exclude from Payroll", false);
                        Earnings.SetRange(Block, false);
                        //If country is rwanda, or starts with gross
                        if Earnings.FindFirst then begin
                            repeat
                                /*Assignmatrix.Reset;
                                Assignmatrix.SetRange("Employee No", Employee."No.");
                                Assignmatrix.SetRange(Code, Earnings.Code);
                                Assignmatrix.SetRange("Payroll Period", Month);
                                *NOT/ Assignmatrix.Find('-') then begin*/
                                //We already capture this
                                /*if Earnings."Gross Pay" = true then begin
                                    GrossPayCode := Earnings.Code;

                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Payment;//Basic Salary
                                    Assignmatrix.Code := Earnings.Code;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix."Gross Pay" := true;
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Description := Earnings.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    //MESSAGE('Emp %3 1 Basic %1 ass mat %2 Gross pay %4', Employee."Basic Pay", Assignmatrix.Amount, Employee."No.", Employee."Assigned Gross Pay");
                                    Assignmatrix.Amount := Employee."Assigned Gross Pay";
                                    Assignmatrix."Manual Entry" := false;
                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                end;*/

                                //Calculate also the basic and transport allowances first so that the rest can be based on these
                                if (Earnings."Basic Salary Code" = true) and (Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Gross pay") then begin
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Payment;
                                    Assignmatrix.Code := Earnings.Code;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    Assignmatrix."Basic Salary Code" := true;
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix."Transport Allowance" := false;
                                    Assignmatrix.Description := Earnings.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    //BasicSalaryRwf := Earnings.Percentage / 100 * GrossPayRwf;
                                    //MESSAGE('2 Emp %3 1 Basic %1 ass mat %2 Gross pay %4', BasicSalaryRwf, Assignmatrix.Amount, Employee."No.", Employee."Assigned Gross Pay");
                                    //Assignmatrix.Amount := BasicSalaryRwf;
                                    Assignmatrix."Manual Entry" := false;
                                    Assignmatrix."Is from Contractual Amount" := true;
                                    //Assignmatrix.INSERT;
                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                end;

                                if (Earnings."Transport Allowance" = true) and (Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Gross pay") and (not Employee."No Transport Allowance") then begin
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Payment;
                                    Assignmatrix.Code := Earnings.Code;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix."Transport Allowance" := true;
                                    Assignmatrix.Description := Earnings.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    //Message('Transport allowance 1 = %1', Assignmatrix.Amount);
                                    //TransportAllowanceRwf := Earnings.Percentage / 100 * GrossPayRwf;
                                    //MESSAGE('3 Emp %3 1 Basic %1 ass mat %2 Gross pay %4', TransportAllowanceRwf, Assignmatrix.Amount, Employee."No.", Employee."Assigned Gross Pay");
                                    //Assignmatrix.Amount := TransportAllowanceRwf;
                                    Assignmatrix."Manual Entry" := false;
                                    Assignmatrix."Is from Contractual Amount" := true;
                                    //Assignmatrix.INSERT;
                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                end;


                                //Housing

                                if (Earnings."Housing Allowance" = true) and (Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Gross pay") then begin
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Payment;
                                    Assignmatrix.Code := Earnings.Code;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    if (Employee."No Transport Allowance") then begin
                                        Assignmatrix.Amount := (Employee."Applicable House Allowance (%)" / 100) * GrossPayRwf;
                                        Assignmatrix.validate(Amount);
                                    end;
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix."Housing Allowance" := true;
                                    Assignmatrix.Description := Earnings.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    //Message('Transport allowance 1 = %1', Assignmatrix.Amount);
                                    //TransportAllowanceRwf := Earnings.Percentage / 100 * GrossPayRwf;
                                    //MESSAGE('3 Emp %3 1 Basic %1 ass mat %2 Gross pay %4', TransportAllowanceRwf, Assignmatrix.Amount, Employee."No.", Employee."Assigned Gross Pay");
                                    //Assignmatrix.Amount := TransportAllowanceRwf;
                                    Assignmatrix."Manual Entry" := false;
                                    Assignmatrix."Is from Contractual Amount" := true;
                                    //Assignmatrix.INSERT;
                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                end;
                            until Earnings.next = 0;
                        end;

                        //Now insert/modify the rest of the earnings that depend on the above
                        Earnings.Reset;
                        //Earnings.SetRange("Gross Pay", true);
                        Earnings.SetRange(Country, Employee."Payroll Country");
                        //if Employee."Payroll Country" = 'RWANDA' THEN begin //Hardcode Rwanda for now
                        Earnings.Setrange("Gross Pay", false);
                        Earnings.Setrange("Basic Salary Code", false);
                        Earnings.SetRange("Exclude from Payroll", false);
                        Earnings.SetRange(Block, false);
                        //Earnings.Setrange("Transport Allowance", false);
                        //end;
                        if Earnings.findfirst then begin
                            repeat
                                //First skip if it touches on transport and then same has been handled up there
                                if not (((Earnings."Transport Allowance" = true) or (Earnings."Housing Allowance" = true)) and (Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Gross pay") and (Employee."No Transport Allowance")) then begin
                                    //Skip it, if calculation method is flat amount and the value is not set in earnings - that means this is a manual entry
                                    if not ((Earnings."Calculation Method" = Earnings."Calculation Method"::"Flat amount") and (Earnings."Flat Amount" = 0)) then begin
                                        Assignmatrix.Init;
                                        Assignmatrix."Employee No" := Employee."No.";
                                        Assignmatrix.Type := Assignmatrix.Type::Payment;
                                        Assignmatrix.Country := Employee."Payroll Country";
                                        Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                        Assignmatrix.Code := Earnings.Code;
                                        /*if (Earnings."Calculation Method" = Earnings."Calculation Method"::"Flat amount") and (Earnings."Applies to All") and (Earnings."Flat Amount" <> 0) then
                                            Assignmatrix.Amount := Earnings."Flat Amount"
                                        else
                                            */
                                        //message('Earning = %1, Amount = %2, Emp = %3', Earnings.Code, Assignmatrix.Amount, Employee."No.");
                                        Assignmatrix.Validate(Assignmatrix.Code);
                                        Assignmatrix."Payroll Period" := Month;
                                        Assignmatrix.Description := Earnings.Description;
                                        Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                        Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                        Assignmatrix."Manual Entry" := false;
                                        //Assignmatrix.INSERT;
                                        if not Assignmatrix.Insert then Assignmatrix.Modify;
                                    end;
                                end;
                            until Earnings.next = 0;
                        end;


                        //Same case for deductions - except those that are computed as a percent of gross pay less stat deductions
                        Deductions.Reset;
                        Deductions.SetRange(Country, Employee."Payroll Country");
                        Deductions.SetFilter("Calculation Method", '<>%1|<>%2|<>%3|<>%4|<>%5', Deductions."Calculation Method"::"% of Gross Less Stat Deductions", Deductions."Calculation Method"::"% of Gross Less Transport", Deductions."Calculation Method"::"% of Actual Gross Pay", Deductions."Calculation Method"::"% of PAYE", Deductions."Calculation Method"::"% of Insurable Earnings");
                        Deductions.SetRange(Block, false);
                        if Deductions.findfirst then begin
                            repeat
                                //Skip it, if calculation method is flat amount and the value is not set in deductions - that means this is a manual entry
                                if not ((Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat amount") and (Deductions."Flat Amount" = 0)) then begin
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix."Is Statutory" := Deductions."Is Statutory";
                                    Assignmatrix.Code := Deductions.Code;
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Description := Deductions.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    Assignmatrix."Manual Entry" := false;
                                    //Assignmatrix.INSERT;
                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                end;

                                //If has loan transaction
                                if (Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat amount") then begin
                                    LoanTrans.Reset();
                                    LoanTrans.SetRange(Employee, Employee."No.");
                                    LoanTrans.SetRange(Code, Deductions.Code);
                                    LoanTrans.SetRange(Country, Deductions.Country);
                                    LoanTrans.SetRange("Start Deducting", true);
                                    LoanTrans.SetRange(Pause, false);
                                    LoanTrans.SetRange(Suspend, false);
                                    LoanTrans.SetRange(Cleared, false);
                                    if LoanTrans.FindFirst() then begin
                                        Assignmatrix.Init;
                                        Assignmatrix."Employee No" := Employee."No.";
                                        Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                        Assignmatrix.Country := Employee."Payroll Country";
                                        Assignmatrix."Is Statutory" := Deductions."Is Statutory";
                                        Assignmatrix.Code := Deductions.Code;
                                        Assignmatrix.Validate(Assignmatrix.Code);
                                        Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                        Assignmatrix."Payroll Period" := Month;
                                        Assignmatrix.Description := Deductions.Description;
                                        Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                        Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                        Assignmatrix."Manual Entry" := true;
                                        //Assignmatrix.INSERT;
                                        if not Assignmatrix.Insert then Assignmatrix.Modify;
                                    end;
                                end;
                            until Deductions.next = 0;
                        end;

                        //check if basic pay for the month exists else insert
                        /*Earnings.Reset;
                        Earnings.SetRange("Basic Salary Code", true);
                        if Earnings.FindFirst then begin
                            Assignmatrix.Reset;
                            Assignmatrix.SetRange("Employee No", Employee."No.");
                            Assignmatrix.SetRange(Code, Earnings.Code);
                            Assignmatrix.SetRange("Payroll Period", Month);
                            if /*NOT/ Assignmatrix.Find('-') then begin
                                Assignmatrix.Init;
                                Assignmatrix."Employee No" := Employee."No.";
                                Assignmatrix.Type := Assignmatrix.Type::Payment;//Basic Salary
                                Assignmatrix.Code := Earnings.Code;
                                Assignmatrix.Validate(Assignmatrix.Code);
                                Assignmatrix."Payroll Period" := Month;
                                Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                //MESSAGE('Emp %3 1 Basic %1 ass mat %2',Employee."Basic Pay",Assignmatrix.Amount,Employee."No.");
                                Assignmatrix.Amount := Employee."Basic Pay";
                                Assignmatrix."Manual Entry" := false;
                                //Assignmatrix.INSERT;
                                if not Assignmatrix.Insert then Assignmatrix.Modify;

                            end;
                        end;*/

                        // Remove Blocked Assignments
                        BlockedAs.Reset;
                        BlockedAs.SetRange("Employee No", Employee."No.");
                        BlockedAs.SetRange(Block, true);
                        if BlockedAs.Find('-') then begin
                            repeat
                                Assignmatrix.Reset;
                                Assignmatrix.SetRange(Assignmatrix.Code, BlockedAs.Code);
                                if BlockedAs.Type = BlockedAs.Type::Payment then
                                    Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Payment);
                                if BlockedAs.Type = BlockedAs.Type::Deduction then
                                    Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Deduction);
                                Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                if Assignmatrix.Find('-') then begin
                                    Assignmatrix.Delete;
                                end;
                            until BlockedAs.Next = 0;
                        end;

                        // Delete all Previous PAYE
                        Deductions.Reset;
                        Deductions.SetRange(Deductions."PAYE Code", true);
                        Deductions.SetRange(Country, Employee."Payroll Country");
                        Deductions.SetRange(Block, false);
                        if Deductions.Find('-') then begin

                            Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix.Code, Deductions.Code);
                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Deduction);
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                            Assignmatrix.Setrange(Country, Employee."Payroll Country");
                            Assignmatrix.DeleteAll;
                        end;

                        // validate assigment matrix code incase basic salary change and update calculation based on basic salary
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month); //ERROR('%1**',Month);
                        Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Deduction);
                        if Assignmatrix.Find('-') then begin
                            repeat
                                /*/if Assignmatrix.Code <> 'P01' then begin
                                if Assignmatrix.Type = Assignmatrix.Type::Payment then begin
                                    if Earnings.Get(Assignmatrix.Code) then begin
                                        if (Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Basic pay") or
                                          (Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Basic after tax") or
                                          (Earnings."Calculation Method" = Earnings."Calculation Method"::"Based on Hourly Rate") or
                                          (Earnings."Earning Type" = Earnings."Earning Type"::"Tax Relief") or
                                          (Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Loan Amount") then begin
                                            /*IF Assignmatrix.Code = 'E04' THEN
                                              ERROR('Gratuity = '+FORMAT(Assignmatrix.Amount));/////
                                            Assignmatrix.Validate(Code);
                                            Assignmatrix.Amount := (Assignmatrix.Amount);
                                            /*IF Assignmatrix.Code = 'E04' THEN
                                              ERROR('Gratuity! = '+FORMAT(Assignmatrix.Amount));/////
                                            Assignmatrix.Modify;
                                        end else begin
                                            //=================for other allowances from SRC====================MIKE
                                            if ScaleBenefits.Get(Employee."Salary Scale", Employee.Present, Assignmatrix.Code) then begin
                                                Assignmatrix.Amount := ScaleBenefits.Amount;
                                                Assignmatrix.Modify;
                                            end;
                                            //=======================end for other allowances=============
                                        //end;
                                    end;
                                end;*/


                                if Assignmatrix.Retirement = false then begin
                                    if Assignmatrix.Type = Assignmatrix.Type::Deduction then begin
                                        if Deductions.Get(Assignmatrix.Code) then begin
                                            if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Basic Pay") or
                                                (Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Hourly Rate") or
                                                (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Secondment Basic") or
                                                (Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Table") or
                                                (Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Daily Rate ") then begin
                                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                                Assignmatrix.Validate(Code);
                                                //Validate Amount FCY
                                                if Assignmatrix."Amount In FCY"/*."Earning Currency"*/ <> 0 then begin
                                                    Assignmatrix.Validate("Amount In FCY"/*"Earning Currency"*/);
                                                    //Assignmatrix.Modify();
                                                end;
                                                Assignmatrix.Amount := (Assignmatrix.Amount);
                                                if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                                    Assignmatrix.Amount := Deductions."Maximum Amount";
                                                if Assignmatrix."Employee Voluntary" <> 0 then
                                                    Assignmatrix.Validate("Employee Voluntary");
                                                Assignmatrix.Modify;
                                            end

                                        end;
                                    end;
                                end;

                                if Assignmatrix.Retirement = true then begin
                                    if Assignmatrix.Type = Assignmatrix.Type::Deduction then begin
                                        if Deductions.Get(Assignmatrix.Code) then begin
                                            if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Basic Pay") or
                                              (Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Hourly Rate") or
                                               (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Secondment Basic") or
                                               (Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Table") or
                                               (Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat Amount") or
                                              (Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Daily Rate ") then begin
                                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                                Assignmatrix.Validate(Code);
                                                // MESSAGE(FORMAT(Assignmatrix.Amount));
                                                Assignmatrix.Amount := (Assignmatrix.Amount);
                                                if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                                    Assignmatrix.Amount := Deductions."Maximum Amount";
                                                if Assignmatrix."Employee Voluntary" <> 0 then
                                                    Assignmatrix.Validate("Employee Voluntary");
                                                Assignmatrix.Modify;
                                            end;
                                        end;
                                    end;
                                end;

                            //end;

                            until Assignmatrix.Next = 0;

                        end;

                        //Validate Amount FCY
                        Deductions.Reset();
                        Deductions.SetRange("Calculation Method", Deductions."Calculation Method"::"Flat Amount");
                        Deductions.SetRange(Country, Employee."Payroll Country");
                        Deductions.SetRange(Block, false);
                        if Deductions.FindSet(true) then begin
                            repeat
                                Assignmatrix.Reset;
                                Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                Assignmatrix.SetRange(Assignmatrix.Code, Deductions.Code);
                                Assignmatrix.SetRange(Assignmatrix.Country, Employee."Payroll Country");
                                if Assignmatrix.findset then
                                    repeat
                                        Assignmatrix.Validate(Code);
                                        Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                        if (Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat amount") and (Assignmatrix."Full Month Amount" <> 0) then
                                            Assignmatrix.Validate("Start Date"/*"Full Month Amount"*/);
                                        if Assignmatrix."Amount In FCY" <> 0 then begin
                                            Assignmatrix.Validate("Amount In FCY");
                                        end;
                                        Assignmatrix.Modify();
                                    until Assignmatrix.Next() = 0;
                            until Deductions.Next() = 0;
                        end;

                        //PAYE calculation was here - moved it after NSSF for proper NSSF deduction to get Taxable Amount - FRED 24/2/23

                        /*Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix.Code, '869');
                        Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Deduction);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                        Assignmatrix.DeleteAll;*/

                        //==================================================================Calculate NHIF automatically

                        /*GrossPay := 0;
                        Earn.RESET;
                        Earn.SETRANGE(Earn."Earning Type",Earn."Earning Type"::"Normal Earning");
                        Earn.SETRANGE(Earn."Non-Cash Benefit",FALSE);
                        Earn.SETRANGE(Earn.Fringe,FALSE);
                        IF Earn.FIND('-') THEN BEGIN
                         REPEAT
                          Assignmatrix.RESET;
                          AssignMatrix.SETRANGE(AssignMatrix."Payroll Period",DateSpecified);
                          AssignMatrix.SETRANGE(Type,AssignMatrix.Type::Payment);
                          AssignMatrix.SETRANGE(AssignMatrix."Employee No",Employee."No.");
                         // AssignMatrix.SETRANGE(AssignMatrix."Basic Salary Code",FALSE);
                          AssignMatrix.SETRANGE(Code,Earn.Code);
                          IF AssignMatrix.FIND('-') THEN BEGIN
                           REPEAT
                            GrossPay:=GrossPay+AssignMatrix.Amount;
                           UNTIL AssignMatrix.NEXT=0;
                          END;
                         UNTIL Earn.NEXT=0;
                         END;*/

                        NHIFamount := 0;
                        //Get Allowance-taxable
                        EmpRec.Reset;
                        EmpRec.SetRange("No.", Employee."No.");
                        EmpRec.SetRange("Pay Period Filter", DateSpecified);
                        EmpRec.SetRange("Payroll Country Filter", Employee."Payroll Country");
                        if EmpRec.Find('-') then
                            EmpRec.CalcFields("Total Allowances", "Taxable Allowance");
                        //MESSAGE('allowance %1 DateSpecified%2',EmpRec."Total Allowances",DateSpecified);
                        TotalAllowance := EmpRec."Total Allowances";
                        //MESSAGE('Total Allowance = %1, Taxable income = %2, Gross = %3',TotalAllowance,EmpRec."Taxable Allowance",GrossPay);
                        //Get NHIF Code


                        //This can sort any deduction with a fixed table
                        DeductionsRec.Reset;
                        //DeductionsRec.SetRange(DeductionsRec."NHIF Deduction", true);
                        DeductionsRec.SetFilter("Deduction Table", '<>%1', '');
                        DeductionsRec.SetRange(Country, Employee."Payroll Country");
                        DeductionsRec.SetRange(DeductionsRec."PAYE Code", false);
                        DeductionsRec.SetRange(DeductionsRec."NSSF Deduction", false);
                        DeductionsRec.SetRange(Block, false);
                        if DeductionsRec.Findset then begin
                            repeat
                                NHIFCode := DeductionsRec.Code;
                                Assignmatrix.Reset;
                                Assignmatrix.SetRange("Payroll Period", Month);
                                Assignmatrix.SetRange(Assignmatrix."Employee No", EmpRec."No.");
                                Assignmatrix.SetRange(Code, DeductionsRec.Code);
                                if Assignmatrix.FindSet then
                                    Assignmatrix.DeleteAll;

                                //For fixed tables
                                BracketTablesRec.Reset;
                                BracketTablesRec.setrange(Country, Employee."Payroll Country");
                                //BracketTablesRec.SetRange(NHIF, true);
                                BracketTablesRec.setrange("Bracket Code", DeductionsRec."Deduction Table");
                                BracketTablesRec.setrange(Type, BracketTablesRec.Type::Fixed);
                                if BracketTablesRec.FindLast then begin
                                    //  MESSAGE('Here');
                                    BracketsX1.Reset;
                                    BracketsX1.SetRange("Table Code", BracketTablesRec."Bracket Code");
                                    if BracketsX1.FindFirst then
                                        repeat
                                            //MESSAGE('Here  nhif %1 TotalAllowance%2',BracketsX1.Amount,TotalAllowance);
                                            if (BracketsX1."Lower Limit" <= TotalAllowance) and (BracketsX1."Upper Limit" >= TotalAllowance) then begin
                                                Assignmatrix.Init;
                                                Assignmatrix."Employee No" := Employee."No.";
                                                Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                                Assignmatrix.Code := DeductionsRec.Code;
                                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                                Assignmatrix.Country := Employee."Payroll Country";
                                                Assignmatrix."Is Statutory" := DeductionsRec."Is Statutory";
                                                Assignmatrix.Validate(Code);
                                                Assignmatrix."Payroll Period" := Month;
                                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                                Assignmatrix.Amount := BracketsX1.Amount;
                                                if ((abs(DeductionsRec."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(DeductionsRec."Maximum Amount"))) then
                                                    Assignmatrix.Amount := DeductionsRec."Maximum Amount";
                                                NHIFamount += BracketsX1.Amount;
                                                Assignmatrix.Description := DeductionsRec.Description;
                                                Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                                Assignmatrix."Posting Group Filter" := Employee."Posting Group";
                                                Assignmatrix.Validate(Amount);
                                                if (Assignmatrix.Amount <> 0) and (not Employee."Is Seconded") then
                                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                            end;
                                        until BracketsX1.Next = 0;
                                end;

                            /*/For graduating tables
                            BracketTablesRec.Reset;
                            BracketTablesRec.setrange(Country, Employee."Payroll Country");
                            //BracketTablesRec.SetRange(NHIF, true);
                            BracketTablesRec.setrange("Bracket Code", DeductionsRec."Deduction Table");
                            BracketTablesRec.setrange(Type, BracketTablesRec.Type::"Graduating Scale");
                            if BracketTablesRec.FindLast then begin
                                //  MESSAGE('Here');
                                BracketsX1.Reset;
                                BracketsX1.SetRange("Table Code", BracketTablesRec."Bracket Code");
                                if BracketsX1.FindFirst then
                                    repeat
                                        //MESSAGE('Here  nhif %1 TotalAllowance%2',BracketsX1.Amount,TotalAllowance);
                                        if (BracketsX1."Lower Limit" <= TotalAllowance) and (BracketsX1."Upper Limit" >= TotalAllowance) then begin
                                            Assignmatrix.Init;
                                            Assignmatrix."Employee No" := Employee."No.";
                                            Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                            Assignmatrix.Code := DeductionsRec.Code;
                                            Assignmatrix.Country := Employee."Payroll Country";
                                            Assignmatrix.Validate(Code);
                                            Assignmatrix."Payroll Period" := Month;
                                            Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                            Assignmatrix.Amount := BracketsX1.Amount;
                                            NHIFamount += BracketsX1.Amount;
                                            Assignmatrix.Description := DeductionsRec.Description;
                                            Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                            Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                            Assignmatrix."Posting Group Filter" := Employee."Posting Group";
                                            Assignmatrix.Validate(Amount);
                                            if (Assignmatrix.Amount <> 0) and (not Employee."Is Seconded") then
                                                if not Assignmatrix.Insert then Assignmatrix.Modify;
                                        end;
                                    until BracketsX1.Next = 0;




                                    EndTax := false;
                                    TaxTable.Reset;
                                    TaxTable.SetRange("Table Code", TaxCode);
                                    if TaxTable.Find('-') then begin
                                        repeat

                                            if AmountRemaining <= 0 then
                                                EndTax := true

                                            else begin

                                                if Round((TaxableAmount), 0.01) >= TaxTable."Upper Limit" then begin

                                                    Tax := (TaxTable."Taxable Amount" * TaxTable.Percentage / 100);
                                                    //Tax:=ROUND(Tax,0.01);
                                                    TotalTax := TotalTax + Tax;

                                                end
                                                else begin
                                                    //Deducted 1 here and got the xact figures just chek incase this may have issues
                                                    //Only the amount in the last Tax band had issues.
                                                    AmountRemaining := AmountRemaining - TaxTable."Lower Limit";

                                                    Tax := AmountRemaining * TaxTable.Percentage / 100;

                                                    EndTax := true;
                                                    TotalTax := TotalTax + Tax;
                                                end;
                                            end;
                                        until (TaxTable.Next = 0) or EndTax = true;
                                    end;
                                    TotalTax := TotalTax;

                                    TotalTax := Round(TotalTax, 0.5, '>');
                                */



                            //end;
                            until DeductionsRec.next = 0;
                        end;


                        //FRED 22/2/23 Update insurance relief here - any aallowance that is based on insurance deduction
                        /*NHIFamount := 0;
                        Earnings.SetRange(Country, Employee."Payroll Country");
                        Earnings.setrange();
                        if Earnings.FindFirst then begin
                            repeat
                                Assignmatrix.Reset;
                                Assignmatrix.SetRange("Employee No", Employee."No.");
                                Assignmatrix.SetRange(Code, Earnings.Code);
                                Assignmatrix.SetRange("Payroll Period", Month);
                                *NOT/ Assignmatrix.Find('-') then begin/
                                if Earnings."Gross Pay" = true then begin
                                    GrossPayCode := Earnings.Code;

                        if NHIFamount > 0 then begin
                            Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                            Assignmatrix.SetRange(Assignmatrix.Code, InsuranceReliefCode);
                            if not Assignmatrix.FindFirst then begin
                                Assignmatrix.Amount := (InsuranceReliefRate / 100) * NHIFamount;
                                Assignmatrix.Modify;
                            end;
                        end;*/



                        //FnProratePay(Employee."No.", Month); //FRED 22/5/23 - Move this up, in case the prorated basic pay is to be used elsewhere
                        FnGetVoluntaryPension(Employee."No.", Month);
                        Assignmatrix.FnCalculateArrearsPension(Employee."No.", Month);



                        //**********************Auto Add Deductions ***********************************
                        Emps.Reset;
                        Emps.SetRange(Emps."No.", Employee."No.");
                        Emps.SetFilter(Emps.Status, '%1', Emps.Status::Active);
                        //Emps.SetRange("Payroll Country Filter", Employee."Payroll Country"); 
                        if Emps.FindFirst then begin

                            Employee.SetRange("Pay Period Filter", DateSpecified);
                            Employee.SetRange("Payroll Country Filter", Employee."Payroll Country");
                            Employee.CalcFields("Total Allowances");
                            TotalAllowance := Employee."Total Allowances";
                            DeductionsT.Reset;
                            DeductionsT.setrange(Country, Employee."Payroll Country");
                            DeductionsT.SetRange(DeductionsT."NSSF Deduction", true);
                            if (DeductionsT.FindFirst/*FINDLAST*/) and (not Employee."Is Seconded") then begin
                                //IF DeductionsT.FINDFIRST THEN BEGIN
                                //FRED 18/2/23 Implement NSSF using bracket tables
                                //Now we have multiple deductions (tiers) under NSSF
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange("Payroll Period", Month);
                                    Assignmatrix.SetRange(Assignmatrix."Employee No", EmpRec."No.");
                                    Assignmatrix.SetRange(Code, DeductionsT.Code);
                                    Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                                    if Assignmatrix.FindSet then
                                        Assignmatrix.DeleteAll;

                                    //MESSAGE('taxable = %1',TotalAllowance);
                                    RemainingAmount := 0;
                                    NssfAmount := 0;
                                    BracketTablesRec.Reset;
                                    BracketTablesRec.setrange(Country, Employee."Payroll Country");
                                    BracketTablesRec.SetRange(NSSF, true);
                                    if BracketTablesRec.FindLast then begin
                                        BracketsX1.Reset;
                                        BracketsX1.SetRange("Table Code", BracketTablesRec."Bracket Code");
                                        if BracketsX1.FindFirst then
                                            repeat
                                                Assignmatrix.Init;
                                                Assignmatrix."Employee No" := Employee."No.";
                                                Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                                Assignmatrix.Code := DeductionsT.Code;
                                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                                Assignmatrix.Country := Employee."Payroll Country";
                                                Assignmatrix."Is Statutory" := DeductionsT."Is Statutory";
                                                Assignmatrix.Validate(Code);
                                                Assignmatrix.Description := DeductionsT.Description;
                                                Assignmatrix."Payroll Period" := Month;
                                                //Tier 1
                                                if BracketsX1."Tier No." = 1 then begin
                                                    if TotalAllowance <= BracketsX1."Taxable Amount" then begin
                                                        NssfAmount := (BracketsX1.Percentage / 100) * TotalAllowance;
                                                    end else begin
                                                        NssfAmount := BracketsX1.Amount;//360
                                                        RemainingAmount := TotalAllowance - BracketsX1."Taxable Amount";
                                                    end;
                                                end;
                                                //Tier 2
                                                if BracketsX1."Tier No." = 2 then begin
                                                    //MESSAGE('0 Tier = %1, Rem amt=%2,nssf=%3,taxable=%4',BracketsX1."Tier No.",RemainingAmount,NssfAmount,BracketsX1."Taxable Amount");
                                                    if RemainingAmount <= BracketsX1."Taxable Amount" then begin
                                                        NssfAmount := (BracketsX1.Percentage / 100) * RemainingAmount; //MESSAGE('Tier = %1, Rem amt=%2,nssf=%3',BracketsX1."Tier No.",RemainingAmount,NssfAmount);
                                                    end else begin
                                                        NssfAmount := BracketsX1.Amount;//720
                                                        RemainingAmount := 0; //MESSAGE('2 Tier = %1, Rem amt=%2,nssf=%3',BracketsX1."Tier No.",RemainingAmount,NssfAmount);
                                                    end;
                                                end;

                                                if not (((DeductionsT."NSSF Tier" = DeductionsT."NSSF Tier"::"Tier 1") and (BracketsX1."Tier No." = 1)) or ((DeductionsT."NSSF Tier" = DeductionsT."NSSF Tier"::"Tier 2") and (BracketsX1."Tier No." = 2))) then
                                                    NssfAmount := 0;

                                                if ((abs(Deductions."Maximum Amount") > 0) and (abs(NssfAmount) > abs(Deductions."Maximum Amount"))) then
                                                    NssfAmount := Deductions."Maximum Amount";

                                                Assignmatrix.Amount := NssfAmount;
                                                Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                                Assignmatrix."Posting Group Filter" := Employee."Posting Group";
                                                Assignmatrix.Validate(Amount);
                                                Assignmatrix."Employer Amount" := Assignmatrix.Amount;
                                                if (Assignmatrix.Amount <> 0) then
                                                    Assignmatrix.Insert;
                                            until BracketsX1.Next = 0;
                                    end;
                                until DeductionsT.Next = 0;
                            end;


                            //FRED 17/8/23 - Compute housing levy
                            /*DeductionsT.Reset;
                            DeductionsT.setrange(Country, Employee."Payroll Country");
                            DeductionsT.SetRange(DeductionsT."Housing Levy", true);
                            DeductionsT.SetRange(Block, false);
                            if (DeductionsT.FindFirst) and (not Employee."Exempt from Housing Levy") //AND (NOT Employee."Skip Processing Housing Levy")// then begin
                                repeat
                                    if not (Employee."Skip Processing Housing Levy" and DeductionsT."Housing Levy Arrears") then begin
                                        Assignmatrix.Reset;
                                        Assignmatrix.SetRange("Payroll Period", Month);
                                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                        Assignmatrix.SetRange(Code, DeductionsT.Code);
                                        if Assignmatrix.FindSet then
                                            Assignmatrix.DeleteAll;

                                        GrossForHousing := 0;
                                        HousingLevyEmployee := 0;
                                        HousingLevyEmployer := 0;

                                        Earnings.Reset;
                                        Earnings.SetRange("Include in Housing Levy", true);
                                        Earnings.SetRange(Country, Employee."Payroll Country");
                                        Earnings.SetRange("Exclude from Payroll", false);
                                        if Earnings.FindSet then begin
                                            repeat
                                                //MESSAGE('Include in housing => '+FORMAT(Earnings.Code));
                                                Assignmatrix.Reset;
                                                Assignmatrix.SetRange("Payroll Period", Month);
                                                Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                                Assignmatrix.SetRange(Code, Earnings.Code);
                                                if Assignmatrix.FindFirst then
                                                    GrossForHousing += Assignmatrix.Amount;
                                            until Earnings.Next = 0;
                                        end;

                                        //MESSAGE('GrossForHousing => '+FORMAT(GrossForHousing));
                                        if GrossForHousing > 0 then begin
                                            HousingLevyEmployee := (DeductionsT.Percentage / 100) * GrossForHousing;
                                            HousingLevyEmployer := (DeductionsT."Percentage Employer" / 100) * GrossForHousing;

                                            Assignmatrix.Init;
                                            Assignmatrix."Employee No" := Employee."No.";
                                            Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                            Assignmatrix.Code := DeductionsT.Code;
                                            Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                            Assignmatrix.Country := Employee."Payroll Country";
                                            Assignmatrix."Is Statutory" := DeductionsT."Is Statutory";
                                            Assignmatrix.Validate(Code);
                                            Assignmatrix."Payroll Period" := Month;
                                            Assignmatrix.Amount := HousingLevyEmployee;
                                            if ((abs(DeductionsT."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(DeductionsT."Maximum Amount"))) then
                                                Assignmatrix.Amount := DeductionsT."Maximum Amount";
                                            Assignmatrix.Description := DeductionsT.Description;
                                            Assignmatrix."Employer Amount" := HousingLevyEmployer;
                                            Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                            Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                            Assignmatrix."Posting Group Filter" := Employee."Posting Group";
                                            Assignmatrix.Validate(Amount);
                                            if (Assignmatrix.Amount <> 0) then
                                                Assignmatrix.Insert;
                                        end;
                                    end;
                                until DeductionsT.Next = 0;
                            end;*/


                            //Move NHIF/Insurance computation deduction here
                            NHIFamount := 0;
                            Deductions.Reset;
                            Deductions.SetRange(Deductions."Insurance Code", true);
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.SetRange(Block, false);
                            if Deductions.findset then begin
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange("Employee No", Employee."No.");
                                    Assignmatrix.SetRange(Code, Deductions.Code);
                                    Assignmatrix.SetRange("Payroll Period", Month);
                                    if Assignmatrix.findset then
                                        repeat
                                            NHIFamount += ABS(Assignmatrix.Amount);
                                        UNTIL Assignmatrix.next = 0;
                                until Deductions.next = 0;
                            end;

                            Earnings.SetRange(Country, Employee."Payroll Country");
                            Earnings.SetRange(Block, false);
                            Earnings.setrange("Calculation Method", Earnings."Calculation Method"::"% of Insurance Amount");
                            if Earnings.FindFirst then begin
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Payment;
                                    Assignmatrix.Code := Earnings.Code;
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix.Validate(Code);
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Amount := (Earnings.Percentage / 100) * NHIFamount;
                                    Assignmatrix.Description := Earnings.Description;
                                    //Assignmatrix."Employer Amount" := HousingLevyEmployer;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    Assignmatrix."Posting Group Filter" := Employee."Posting Group";
                                    Assignmatrix.Validate(Amount);
                                    if not Assignmatrix.insert then Assignmatrix.Modify;
                                until Earnings.next = 0;
                            end;


                            //Moved PAYE computation firther down
                            /*else
                                Error('Must specify Paye Code under deductions');*/

                            //FRED 25/9/23 - Find out what we were trying to achieve here
                            /*DeductionsX.Reset;
                            DeductionsX.SetRange(Country, Employee."Payroll Country");
                            DeductionsX.SetRange(DeductionsX."Normal Deduction", true);
                            if DeductionsX.FindFirst then begin
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange("Payroll Period", Month);
                                    Assignmatrix.SetRange(Assignmatrix."Employee No", EmpRec."No.");
                                    Assignmatrix.SetRange(Code, DeductionsX.Code);
                                    if Assignmatrix.FindSet then
                                        Assignmatrix.DeleteAll;

                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix.Code := DeductionsX.Code;
                                    Assignmatrix.Validate(Code);
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Description := DeductionsX.Description;
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    //Assignmatrix.Paye:=DeductionsX."Tax deductible";
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    Assignmatrix."Posting Group Filter" := Employee."Posting Group";
                                    Assignmatrix."Insurance Code" := DeductionsX."Insurance Code";
                                    Assignmatrix."Do Not Deduct" := DeductionsX."Do Not Deduct";
                                    Assignmatrix.Validate(Amount);
                                    if (Assignmatrix.Amount <> 0) then
                                        Assignmatrix.Insert;
                                until DeductionsX.Next = 0;
                            end;
                        end;*/

                            FnUpdateVoluntaryInsurance(Employee."No.", Month);
                            //***********************End Deductions**********************************



                            Principalamount := 0;
                            fringestart := 0D;
                            Installments := 0;
                            InterestAmount := 0;
                            Principamount := 0;
                            Principal2 := 0;
                            Mortgage := false;
                            Mortgageamt := 0;
                            LoanApplication.Reset;
                            LoanApplication.SetRange(LoanApplication."Employee No", "No.");
                            LoanApplication.SetRange("Stop Loan", false);
                            if LoanApplication.Find('-') then begin
                                repeat
                                    if LoanType.Get(LoanApplication."Loan Product Type") then begin
                                        if LoanType."Fringe Benefit Code" <> '' then begin
                                            Principalamount := LoanApplication."Approved Amount";
                                            fringestart := LoanApplication."Issued Date";
                                            Installments := LoanApplication.Instalment;
                                            Numerator := (LoanType."Interest Rate" / 12 / 100);
                                            Denominator := (1 - Power((1 + (LoanType."Interest Rate" / 12 / 100)), -Installments));
                                            Repayment := Round((Numerator / Denominator) * Principalamount, 0.05, '>');
                                            if Installments <= 0 then
                                                Error('Instalment Amount must be specified');
                                            months := 0;
                                            while fringestart <= Month do begin
                                                Principamount := Round((Principalamount / 100 / 12 * LoanType."Interest Rate"), 0.05, '>');
                                                Principal2 := Repayment - Principamount;
                                                Principalamount := Principalamount - Principal2;
                                                fringestart := CalcDate('1M', fringestart);
                                                months := months + 1;

                                            end;
                                            //check mortgage
                                            if LoanType.Mortgage <> '' then begin
                                                Mortgageamt := Principamount;
                                            end;
                                            //=================end check mortgage

                                            MarketIntRateRec.Reset;
                                            MarketIntRateRec.SetFilter("Start Date", '<=%1', Month);
                                            MarketIntRateRec.SetFilter("End Date", '>=%1', Month);
                                            if MarketIntRateRec.Find('-') then begin
                                                MarketIntRate := MarketIntRateRec.Intrest;
                                                InterestRate := LoanType."Interest Rate";
                                                // InterestRate:=ROUND(InterestRate,0.01);
                                                Taxpercentage := MarketIntRateRec."Tax Percentage";
                                            end
                                            else
                                                Error('Market Interest Rates have not been setup for the period including %1', Month);

                                            //calculating the fringe benefit

                                            Fringebal := 0;
                                            FringeAmount := 0;
                                            FringeAmountT := 0;
                                            Fringebal := (Principalamount);
                                            FringeAmount := Round((((MarketIntRate - InterestRate) / 100) / 12) * Fringebal, 0.05);
                                            NumeratorF := ((MarketIntRate) / 12 / 100);
                                            DenominatorF := (1 - Power((1 + ((MarketIntRate - InterestRate) / 12 / 100)), -Installments));
                                            RepaymentF := Round((NumeratorF / DenominatorF) * Fringebal, 0.01, '>');
                                            FringeAmountT := Round((Taxpercentage / 100) * FringeAmount, 0.01);

                                            Assmatrix.Init;
                                            Assmatrix."Employee No" := Employee."No.";
                                            Assmatrix.Type := Assmatrix.Type::Payment;
                                            Assmatrix."Reference No" := LoanApplication."Loan No";
                                            Assmatrix.Code := LoanType."Fringe Benefit Code";
                                            Assmatrix."Payroll Period" := Month;//LoanApplication."Issued Date";
                                            Assmatrix."Country Currency" := Employee."Payroll Currency";

                                            Earnings.Reset;
                                            Earnings.SetRange(Earnings.Code, LoanType."Fringe Benefit Code");
                                            Earnings.SetRange("Exclude from Payroll", false);
                                            if Earnings.Find('-') then
                                                Assmatrix.Description := Earnings.Description;
                                            Assmatrix."Payroll Group" := Employee."Posting Group";
                                            Assmatrix.Amount := FringeAmount;
                                            Assmatrix."Employer Amount" := FringeAmountT;
                                            Assmatrix."Next Period Entry" := true;
                                            Assmatrix.Validate(Assmatrix.Amount);
                                            if not Assmatrix.Get(Assmatrix."Employee No", Assmatrix.Type, Assmatrix.Code, Assmatrix."Payroll Period", Assmatrix."Reference No")
                                            then
                                                if Assignmatrix.Amount <> 0 then
                                                    Assmatrix.Insert
                                                else
                                                    if Assignmatrix.Amount <> 0 then
                                                        Assmatrix.Modify;

                                            Assignmatrix.Reset;
                                            Assignmatrix.SetRange(Assignmatrix.Code, LoanType."Fringe Benefit Code");
                                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Payment);
                                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                            if Assignmatrix.FindFirst then begin
                                                Assignmatrix.Amount := FringeAmount;
                                                Assignmatrix."Employer Amount" := FringeAmountT;
                                                Assmatrix.Validate(Assmatrix.Amount, Assignmatrix."Employer Amount");
                                                Assignmatrix.Modify;
                                            end else begin
                                                Earnings.Reset;
                                                Earnings.SetRange("Exclude from Payroll", false);
                                                Earnings.SetRange(Earnings.Code, LoanType."Fringe Benefit Code");
                                                if Earnings.Find('-') then
                                                    Assignmatrix.Description := Earnings.Description;
                                                Assignmatrix."Payroll Group" := Employee."Posting Group";
                                                Assignmatrix.Amount := FringeAmount;
                                                Assmatrix."Employer Amount" := FringeAmountT;
                                                Assignmatrix."Next Period Entry" := true;
                                                Assignmatrix.Validate(Assignmatrix.Amount, Assignmatrix."Employer Amount");
                                                Assignmatrix.Insert;
                                            end;
                                        end;
                                    end;
                                until LoanApplication.Next = 0;
                            end;
                            //=============================================================FRINGE BENEFIT CALCULATION
                            //==========================================MORTGAGE RELIEF
                            //Get mortgage code
                            MortgageCode := '';
                            EarningsRec.Reset;
                            EarningsRec.setrange(Country, Employee."Payroll Country");
                            EarningsRec.SetRange("Exclude from Payroll", false);
                            EarningsRec.SetRange(Block, false);
                            EarningsRec.SetRange("Earning Type", EarningsRec."Earning Type"::"Owner Occupier");
                            if EarningsRec.FindLast then
                                MortgageCode := EarningsRec.Code;

                            Assignmatrix.Reset;
                            Assignmatrix.Country := Employee."Payroll Country";
                            Assignmatrix.SetRange(Assignmatrix.Code, MortgageCode);
                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Payment);
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                            if Assignmatrix.FindFirst then begin
                                if Mortgageamt <> 0 then begin
                                    if Earnings."Flat Amount" > Mortgageamt then begin
                                        Assignmatrix.Amount := Mortgageamt;
                                    end else begin
                                        Assignmatrix.Amount := Assignmatrix.Amount;
                                    end;
                                end;
                                Assignmatrix.Description := Earnings.Description;
                                Assignmatrix.Modify;
                            end;
                            //==========================================MORTGAGE RELIEF
                            /*//check if relief for the month exists else insert
                            Assignmatrix.RESET;
                            Assignmatrix.SETRANGE("Employee No", Employee."No.");
                            Assignmatrix.SETRANGE(Code, InsuranceReliefCode);
                            Assignmatrix.SETRANGE("Payroll Period", Month);
                            IF Assignmatrix.FIND('-') THEN BEGIN
                              Assignmatrix.Amount:=0;
                              Assignmatrix.MODIFY;
                              END;
                            Earnings.RESET;
                            Earnings.SETRANGE("Insurance Code",TRUE);
                            IF Earnings.FIND('-') THEN BEGIN
                              REPEAT
                                Assignmatrix.RESET;
                                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                                Assignmatrix.SETRANGE(Code, InsuranceReliefCode);
                                Assignmatrix.SETRANGE("Payroll Period", Month);
                                IF Assignmatrix.FIND('-') THEN BEGIN
                                  IF Earnings."Flat Amount" <> 0 THEN BEGIN
                                        Assignmatrix.Amount:=Earnings."Flat Amount"+Assignmatrix.Amount;
                                      END;
                                      IF Earnings."Flat Amount" = 0 THEN BEGIN
                                        //get insurance relief
                                          Assignmatrix7.RESET;
                                          Assignmatrix7.SETRANGE("Insurance Code", TRUE);
                                          Assignmatrix7.SETRANGE("Payroll Period", Month);
                                          Assignmatrix7.SETRANGE("Employee No", Employee."No.");
                                          Assignmatrix7.SETRANGE(Code, Earnings.Code);
                                          Assignmatrix7.SETRANGE(Type, Assignmatrix7.Type::Deduction);
                                          IF Assignmatrix7.FIND('-') THEN BEGIN
                                            //Assignmatrix7.CALCSUMS(Amount);
                                            InsuranceAmount:=(ABS(Assignmatrix7.Amount)*Earnings.Percentage)/100+Assignmatrix.Amount;
                                            IF InsuranceAmount > Earnings."Maximum Amount" THEN BEGIN
                                               Assignmatrix.Amount:=Earnings."Maximum Amount";
                                              END ELSE BEGIN
                                                Assignmatrix.Amount:=InsuranceAmount;
                                                END;
                                            END;
                                      END;
                                      Assignmatrix.MODIFY();
                                  END ELSE BEGIN
                                    Assignmatrix.INIT;
                                      Assignmatrix."Employee No":=Employee."No.";
                                      Assignmatrix.Type:=Assignmatrix.Type::Payment;
                                      Assignmatrix.Code:= InsuranceReliefCode;
                                      Assignmatrix.VALIDATE(Assignmatrix.Code);
                                      Assignmatrix."Payroll Period":=Month;
                                      Assignmatrix."Global Dimension 1 code":=Employee."Global Dimension 1 Code";
                                      Assignmatrix."Global Dimension 2 Code":=Employee."Global Dimension 2 Code";
                                      IF Earnings."Flat Amount" <> 0 THEN BEGIN
                                        Assignmatrix.Amount:=Earnings."Flat Amount";
                                      END;

                                      IF Earnings."Flat Amount" = 0 THEN BEGIN
                                        //get insurance relief
                                          Assignmatrix7.RESET;
                                          Assignmatrix7.SETRANGE("Insurance Code", TRUE);
                                          Assignmatrix7.SETRANGE("Payroll Period", Month);
                                          IF Assignmatrix7.FIND('-') THEN BEGIN
                                            Assignmatrix7.CALCSUMS(Amount);
                                            InsuranceAmount:=(ABS(Assignmatrix7.Amount)*Earnings.Percentage)/100;
                                            IF InsuranceAmount > Earnings."Maximum Amount" THEN BEGIN
                                               Assignmatrix.Amount:=Earnings."Maximum Amount";
                                              END ELSE BEGIN
                                                Assignmatrix.Amount:=InsuranceAmount;
                                                END;
                                            END;
                                      END;
                                      Assignmatrix."Manual Entry":=FALSE;
                                      IF Assignmatrix.Amount <> 0 THEN
                                      Assignmatrix.INSERT;
                                    END;
                                UNTIL Earnings.NEXT=0;
                              END;
                             */
                            /* //----Remove earnings with amount zero----
                            Assignmatrix.RESET;
                            Assignmatrix.SETRANGE(Assignmatrix."Employee No",Employee."No.");
                            Assignmatrix.SETRANGE(Assignmatrix.Type,Assignmatrix.Type::Payment);
                            Assignmatrix.SETRANGE(Assignmatrix."Payroll Period",Month);
                            Assignmatrix.SETRANGE(Assignmatrix.Amount,0);
                            Assignmatrix.SETRANGE(Assignmatrix.Code,'E06');
                            IF Assignmatrix.FINDSET THEN
                              BEGIN
                               // MESSAGE('Code %1 Amount %2',Assignmatrix.Code,Assignmatrix.Amount);
                                Assignmatrix.DELETEALL;
                              END;*/

                            //FRED 22/5/23 - Moved here with modifications, at the end of the process so that the prorated basic pay may be used
                            EarningsRec.Reset;
                            EarningsRec.setrange(Country, Employee."Payroll Country");
                            EarningsRec.SetRange("Exclude from Payroll", false);
                            EarningsRec.SetRange(Block, false);
                            EarningsRec.SetRange("Earning Type", EarningsRec."Earning Type"::Gratuity);
                            if EarningsRec.FindLast then begin
                                if Employee."Earns Gratuity" = true then begin
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                    Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                    Assignmatrix.SetRange(Assignmatrix.Code, EarningsRec.Code);
                                    if Assignmatrix.FindFirst then begin
                                        Assignmatrix."Employee No" := Employee."No.";
                                        Assignmatrix.Type := Assignmatrix.Type::Payment;
                                        Assignmatrix.Country := Employee."Payroll Country";
                                        Assignmatrix.Validate(Code, EarningsRec.Code);
                                        Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                        Assignmatrix."Payroll Period" := Month;
                                        Assignmatrix.Description := EarningsRec.Description;
                                        //Assignmatrix.Description:='Insurance Relief';
                                        Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                        Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                        Assignmatrix.Modify;
                                    end else begin
                                        Assignmatrix.Init;
                                        Assignmatrix."Employee No" := Employee."No.";
                                        Assignmatrix.Type := Assignmatrix.Type::Payment;
                                        Assignmatrix.Country := Employee."Payroll Country";
                                        Assignmatrix.Validate(Code, EarningsRec.Code);
                                        Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                        Assignmatrix."Payroll Period" := Month;
                                        Assignmatrix.Description := EarningsRec.Description;
                                        //Assignmatrix.Description:='Insurance Relief';
                                        Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                        Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                        Assignmatrix.Insert;
                                    end;
                                end;
                            end;

                            //Compute deductions that are a percentage of gross pay less statutory deductions and less transport
                            ComputedGrossPay := 0;
                            InsurableEarnings := 0;
                            SpecialTransportAllowanceInsurableEarnings := 0;
                            TransportAllowanceAmount := 0;
                            BasicSalaryAmount := 0;

                            EarningsRec.Reset;
                            EarningsRec.SetRange("Exclude from Payroll", false);
                            EarningsRec.setrange(Country, Employee."Payroll Country");
                            EarningsRec.SetRange("Non-Cash Benefit", false);
                            EarningsRec.SetRange(Fringe, false);
                            EarningsRec.SetRange(Block, false);
                            EarningsRec.SetRange("Reduces Tax", false);//Remove earnings that reduce tax - the reduce computed gross used for other calculations
                            if EarningsRec.findset then
                                repeat
                                    EarningCode := EarningsRec.Code;
                                    if ((EarningsRec."Is Contractual Amount") and (not EarningsRec."Goes to Matrix")) then
                                        EarningCode := '';

                                    if EarningCode <> '' then begin
                                        Assignmatrix.Reset;
                                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                        Assignmatrix.SetRange(Assignmatrix.Code, EarningCode);
                                        Assignmatrix.SetRange(Assignmatrix.Country, EarningsRec.Country);
                                        if Assignmatrix.findset then
                                            repeat
                                                ComputedGrossPay += Assignmatrix.Amount;
                                                if EarningsRec."Is Statutory" then
                                                    SpecialTransportAllowanceGross += Assignmatrix.Amount;
                                                if EarningsRec."Is Insurable Earning" then begin
                                                    InsurableEarnings += Assignmatrix.Amount;
                                                    if EarningsRec."Is Statutory" then
                                                        SpecialTransportAllowanceInsurableEarnings += Assignmatrix.Amount;
                                                end;
                                                if EarningsRec."Transport Allowance" then begin
                                                    //Message('Transport allowance 2a = %1, %2', Assignmatrix.Amount, EarningCode);
                                                    TransportAllowanceAmount += Assignmatrix.Amount;
                                                end;
                                                if EarningsRec."Basic Salary Code" then
                                                    BasicSalaryAmount += Assignmatrix.Amount;

                                                Assignmatrix.Validate(Code);
                                                if (EarningsRec."Calculation Method" = EarningsRec."Calculation Method"::"Flat amount") and (Assignmatrix."Full Month Amount" <> 0) then
                                                    Assignmatrix.Validate("Start Date"/*"Full Month Amount"*/);
                                                //Validate Amount FCY
                                                if Assignmatrix."Amount In FCY"/*."Earning Currency"*/ <> 0 then begin
                                                    Assignmatrix.Validate("Amount In FCY"/*"Earning Currency"*/);
                                                end;
                                                Assignmatrix.Modify();
                                            until Assignmatrix.next = 0;
                                    end;
                                until EarningsRec.next = 0;
                            //Message('Transport allowance 2b = %1', TransportAllowanceAmount);

                            //Earnings that should not be included as part of computed gross for calculation purposes
                            EarningsThatReduceGross := 0;
                            EarningsRec.Reset;
                            EarningsRec.SetRange("Exclude from Payroll", false);
                            EarningsRec.setrange(Country, Employee."Payroll Country");
                            EarningsRec.SetRange("Non-Cash Benefit", false);
                            EarningsRec.SetRange(Fringe, false);
                            EarningsRec.SetRange(Block, false);
                            EarningsRec.SetRange("Exclude from Calculations", true);//"Reduces Tax"
                            if EarningsRec.findset then
                                repeat
                                    EarningCode := EarningsRec.Code;
                                    if ((EarningsRec."Is Contractual Amount") and (not EarningsRec."Goes to Matrix")) then
                                        EarningCode := '';

                                    if EarningCode <> '' then begin
                                        Assignmatrix.Reset;
                                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                        Assignmatrix.SetRange(Assignmatrix.Code, EarningCode);
                                        Assignmatrix.SetRange(Assignmatrix.Country, EarningsRec.Country);
                                        if Assignmatrix.findset then
                                            repeat
                                                EarningsThatReduceGross += Assignmatrix.Amount;
                                                if EarningsRec."Is Statutory" then
                                                    SpecialTransportAllowanceGross -= Assignmatrix.Amount;
                                                if EarningsRec."Is Insurable Earning" then begin
                                                    InsurableEarnings += Assignmatrix.Amount;
                                                    if EarningsRec."Is Statutory" then
                                                        SpecialTransportAllowanceInsurableEarnings += Assignmatrix.Amount;
                                                end;
                                                if EarningsRec."Transport Allowance" then begin
                                                    //Message('Transport allowance 2a = %1, %2', Assignmatrix.Amount, EarningCode);
                                                    TransportAllowanceAmount += Assignmatrix.Amount;
                                                end;
                                                if EarningsRec."Basic Salary Code" then
                                                    BasicSalaryAmount += Assignmatrix.Amount;

                                                Assignmatrix.Validate(Code);
                                                if (EarningsRec."Calculation Method" = EarningsRec."Calculation Method"::"Flat amount") and (Assignmatrix."Full Month Amount" <> 0) then
                                                    Assignmatrix.Validate("Start Date"/*"Full Month Amount"*/);
                                                //Validate Amount FCY
                                                if Assignmatrix."Amount In FCY"/*."Earning Currency"*/ <> 0 then begin
                                                    Assignmatrix.Validate("Amount In FCY"/*"Earning Currency"*/);
                                                end;
                                                Assignmatrix.Modify();
                                            until Assignmatrix.next = 0;
                                    end;
                                until EarningsRec.next = 0;
                            //Update (reduce) the computed gross
                            ComputedGrossPay := ComputedGrossPay - EarningsThatReduceGross;

                            //Get deductions that reduce gross pay
                            DeductionsThatReduceGross := 0;
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.setrange("Reduces Gross", true);
                            Deductions.SetRange(Block, false);
                            if Deductions.findset then begin
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                    Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                    Assignmatrix.SetRange(Assignmatrix.Code, Deductions.Code);
                                    Assignmatrix.SetRange(Assignmatrix.Country, Deductions.Country);
                                    if Assignmatrix.findfirst then
                                        repeat
                                            DeductionsThatReduceGross += abs(Assignmatrix.Amount);
                                            if Deductions."Is Statutory" then
                                                SpecialTransportAllowanceGross -= Abs(Assignmatrix.Amount);
                                        until Assignmatrix.next = 0;
                                until Deductions.next = 0;
                            end;
                            //Update (reduce) the computed gross
                            ComputedGrossPay := ComputedGrossPay - DeductionsThatReduceGross;

                            //Do the percent of basic deduction here
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.SetRange(Block, false);
                            Deductions.SetRange("Calculation Method", Deductions."Calculation Method"::"% of Basic Pay");
                            if Deductions.findfirst then begin
                                repeat
                                    WorkingAmount := BasicSalaryAmount;
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix."Is Statutory" := Deductions."Is Statutory";
                                    Assignmatrix."Tax Deductible" := Deductions."Tax deductible";
                                    Assignmatrix.Code := Deductions.Code;
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    Assignmatrix.Amount := (Deductions.Percentage / 100) * WorkingAmount;
                                    if (IsGivenSpecialTransportAllowance) and (Deductions."Is Statutory") and ((not Deductions."Medical Insurance") or ((Deductions."Medical Insurance") and (((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal)) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))))) and (FnIncludeDeductionInSpecialTransAllowance(Deductions.Code, Deductions."Is Statutory")) then
                                        SpecialTransportAllowanceStatutoryDeductions += Abs(Assignmatrix.Amount);

                                    if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                        Assignmatrix.Amount := Deductions."Maximum Amount";

                                    Assignmatrix.validate(Amount);
                                    Assignmatrix."Employer Amount" := (Deductions."Percentage Employer" / 100) * WorkingAmount;
                                    Assignmatrix.validate("Employer Amount");
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Description := Deductions.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    Assignmatrix."Manual Entry" := false;
                                    //Assignmatrix.INSERT;
                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                until Deductions.next = 0;
                            end;

                            //Work on the medical deductions issue here                        
                            //If this is a medical deduction and it does not apply to this employee, skip it
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.SetRange("Medical Insurance", true);
                            Deductions.SetRange(Block, false);
                            if Deductions.FindSet() then
                                repeat
                                    if not ((((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal))) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))) then begin
                                        /*if not Assignmatrix.Insert then Assignmatrix.Modify;
                                    end else begin
                                        //Delete the other one*/
                                        Assignmatrix7.Reset();
                                        Assignmatrix7.SetRange("Employee No", Employee."No.");
                                        Assignmatrix7.SetRange(Country, Employee."Payroll Country");
                                        Assignmatrix7.SetRange(Code, Deductions.Code);
                                        Assignmatrix7.SetRange("Payroll Period", Month);
                                        Assignmatrix7.SetRange(Type, Assignmatrix7.Type::Deduction);
                                        if Assignmatrix7.FindFirst() then
                                            Assignmatrix7.DeleteAll();
                                    end;
                                until Deductions.Next() = 0;

                            //Exempt RWANDA Staff working in Ghana or Nigeria from Pension deduction
                            ExemptFromStaffPension := false;
                            if ((Employee."Payroll Country" = 'GHANA') or (Employee."Payroll Country" = 'NIGERIA')) and (Employee."Country/Region Code" = 'RWANDA') then begin
                                ExemptFromStaffPension := true;

                                Deductions.Reset;
                                Deductions.SetRange(Country, Employee."Payroll Country");
                                Deductions.SetRange("Pension Scheme", true);
                                Deductions.SetRange(Block, false);
                                if Deductions.FindSet() then
                                    repeat
                                        Assignmatrix.Reset;
                                        Assignmatrix.SetRange(Assignmatrix.Code, Deductions.Code);
                                        Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Deduction);
                                        Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                        Assignmatrix.Setrange(Country, Employee."Payroll Country");
                                        Assignmatrix.DeleteAll;
                                    until Deductions.Next() = 0;
                            end;

                            //For country like Nigeria, compute consolidated reliefs here | Zimbabwe as well
                            //1. Ensure pension is computed first
                            if not ExemptFromStaffPension then begin
                                Deductions.Reset;
                                Deductions.SetRange(Country, Employee."Payroll Country");
                                Deductions.SetRange("Pension Scheme", true);
                                Deductions.SetRange(Block, false);
                                Deductions.SetFilter("Calculation Method", '%1|%2', Deductions."Calculation Method"::"% of Actual Gross Pay", Deductions."Calculation Method"::"% of Insurable Earnings");
                                if Deductions.findfirst then begin
                                    repeat
                                        WorkingAmount := 0;
                                        Assignmatrix.Init;
                                        Assignmatrix."Employee No" := Employee."No.";
                                        Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                        Assignmatrix.Country := Employee."Payroll Country";
                                        Assignmatrix."Is Statutory" := Deductions."Is Statutory";
                                        Assignmatrix.Code := Deductions.Code;
                                        Assignmatrix.Validate(Assignmatrix.Code);
                                        Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                        if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Actual Gross Pay") then begin
                                            WorkingAmount := ComputedGrossPay;

                                            //Message('2a. %1 | %2', ComputedGrossPay, SportFacilitationAllowance);
                                            if (IsGivenSpecialTransportAllowance) and (Deductions."Is Statutory") and ((not Deductions."Medical Insurance") or ((Deductions."Medical Insurance") and (((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal)) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))))) and (FnIncludeDeductionInSpecialTransAllowance(Deductions.Code, Deductions."Is Statutory")) then
                                                SpecialTransportAllowanceStatutoryDeductions += (Deductions.Percentage / 100) * SpecialTransportAllowanceGross;
                                        end;
                                        if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Insurable Earnings") then begin
                                            WorkingAmount := InsurableEarnings;

                                            if (IsGivenSpecialTransportAllowance) and (Deductions."Is Statutory") and ((not Deductions."Medical Insurance") or ((Deductions."Medical Insurance") and (((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal)) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))))) and (FnIncludeDeductionInSpecialTransAllowance(Deductions.Code, Deductions."Is Statutory")) then
                                                SpecialTransportAllowanceStatutoryDeductions += (Deductions.Percentage / 100) * SpecialTransportAllowanceInsurableEarnings;
                                        end;

                                        Assignmatrix.Amount := (Deductions.Percentage / 100) * WorkingAmount;
                                        if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                            Assignmatrix.Amount := Deductions."Maximum Amount";
                                        Assignmatrix.validate(Amount);
                                        Assignmatrix."Employer Amount" := (Deductions."Percentage Employer" / 100) * WorkingAmount;
                                        if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix."Employer Amount") > abs(Deductions."Maximum Amount"))) then
                                            Assignmatrix."Employer Amount" := Deductions."Maximum Amount";
                                        Assignmatrix.validate("Employer Amount");
                                        Assignmatrix."Payroll Period" := Month;
                                        Assignmatrix.Description := Deductions.Description;
                                        Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                        Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                        Assignmatrix."Manual Entry" := false;
                                        //Assignmatrix.INSERT;
                                        if not Assignmatrix.Insert then Assignmatrix.Modify;
                                    until Deductions.next = 0;
                                end;
                            end;

                            DeductionsThatReduceTaxablePay := 0;
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.SetRange("Tax deductible", true);
                            Deductions.SetRange(Block, false);
                            if Deductions.FindSet() then
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                    Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                    Assignmatrix.SetRange(Assignmatrix.Code, Deductions.Code);
                                    Assignmatrix.SetRange(Assignmatrix.Country, Deductions.Country);
                                    if Assignmatrix.findfirst then
                                        repeat
                                            DeductionsThatReduceTaxablePay += abs(Assignmatrix.Amount);
                                        until Assignmatrix.next = 0;
                                until Deductions.Next() = 0;

                            //consolidated relief                           
                            EarningsRec.Reset;
                            EarningsRec.SetRange("Exclude from Payroll", false);
                            EarningsRec.setrange(Country, Employee."Payroll Country");
                            EarningsRec.SetRange("Non-Cash Benefit", true);
                            //EarningsRec.SetRange(Fringe, false);
                            EarningsRec.SetRange(Block, false);
                            EarningsRec.SetRange("Calculation Method", EarningsRec."Calculation Method"::"% of Actual Gross plus Constant Amount");
                            if EarningsRec.findset then
                                repeat
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Payment;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix."Tax Deductible" := EarningsRec."Reduces Tax";
                                    Assignmatrix.Code := EarningsRec.Code;
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    Assignmatrix.Amount := ((EarningsRec.Percentage / 100) * (ComputedGrossPay - DeductionsThatReduceTaxablePay)) + EarningsRec."Constant Amount";
                                    Assignmatrix.validate(Amount);
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Description := EarningsRec.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    Assignmatrix."Manual Entry" := false;
                                    //Assignmatrix.INSERT;
                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                until EarningsRec.next = 0;


                            //Work on the specific formula deductions now - those that can affect PAYE but are not affected by PAYE
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.SetRange(Block, false);
                            Deductions.SetFilter("Calculation Method", '%1|%2|%3', Deductions."Calculation Method"::"% of Gross Less Transport", Deductions."Calculation Method"::"% of Actual Gross Pay", Deductions."Calculation Method"::"% of Insurable Earnings");
                            if Deductions.findfirst then begin
                                repeat
                                    WorkingAmount := 0;
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix."Is Statutory" := Deductions."Is Statutory";
                                    Assignmatrix.Code := Deductions.Code;
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Gross Less Transport") then begin
                                        WorkingAmount := ComputedGrossPay - TransportAllowanceAmount;
                                        if (IsGivenSpecialTransportAllowance) and (Deductions."Is Statutory") and ((not Deductions."Medical Insurance") or ((Deductions."Medical Insurance") and (((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal)) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))))) and (FnIncludeDeductionInSpecialTransAllowance(Deductions.Code, Deductions."Is Statutory")) then
                                            SpecialTransportAllowanceStatutoryDeductions += (Deductions.Percentage / 100) * (SpecialTransportAllowanceGross - TransportAllowanceAmount);
                                        //Message('Computed Gross %1, Less Transport %2, Get %3, Multiply by %4 to get %5', ComputedGrossPay, TransportAllowanceAmount, WorkingAmount, Deductions.Percentage, ((Deductions.Percentage / 100) * WorkingAmount));
                                    end;
                                    /*if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Gross Less Stat Deductions") then begin
                                        WorkingAmount := ComputedGrossPay - StatutoryDeductions;
                                        //Message('Computed Gross %1, Less Stat Ded %2, Get %3, Multiply by %4 to get %5', ComputedGrossPay, StatutoryDeductions, WorkingAmount, Deductions.Percentage, ((Deductions.Percentage / 100) * WorkingAmount));
                                    end;*/
                                    if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Actual Gross Pay") then begin
                                        WorkingAmount := ComputedGrossPay;
                                        if (IsGivenSpecialTransportAllowance) and (Deductions."Is Statutory") and ((not Deductions."Medical Insurance") or ((Deductions."Medical Insurance") and (((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal)) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))))) and (FnIncludeDeductionInSpecialTransAllowance(Deductions.Code, Deductions."Is Statutory")) then
                                            SpecialTransportAllowanceStatutoryDeductions += (Deductions.Percentage / 100) * SpecialTransportAllowanceGross;
                                        //Message('Computed Gross %1, so working amount of %2, Multiply by %3 to get %4', ComputedGrossPay, WorkingAmount, Deductions.Percentage, ((Deductions.Percentage / 100) * WorkingAmount));
                                    end;
                                    if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Insurable Earnings") then begin
                                        WorkingAmount := InsurableEarnings;
                                        if (IsGivenSpecialTransportAllowance) and (Deductions."Is Statutory") and ((not Deductions."Medical Insurance") or ((Deductions."Medical Insurance") and (((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal)) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))))) and (FnIncludeDeductionInSpecialTransAllowance(Deductions.Code, Deductions."Is Statutory")) then
                                            SpecialTransportAllowanceStatutoryDeductions += (Deductions.Percentage / 100) * SpecialTransportAllowanceInsurableEarnings;
                                        //Message('Computed Gross %1, InsurableEarnings %2, work with %3, Multiply by %4 to get %5', ComputedGrossPay, InsurableEarnings, WorkingAmount, Deductions.Percentage, ((Deductions.Percentage / 100) * WorkingAmount));
                                    end;
                                    Assignmatrix.Amount := (Deductions.Percentage / 100) * WorkingAmount;

                                    if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                        Assignmatrix.Amount := Deductions."Maximum Amount";

                                    Assignmatrix.validate(Amount);
                                    Assignmatrix."Employer Amount" := (Deductions."Percentage Employer" / 100) * WorkingAmount;
                                    if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix."Employer Amount") > abs(Deductions."Maximum Amount"))) then
                                        Assignmatrix."Employer Amount" := Deductions."Maximum Amount";
                                    Assignmatrix.validate("Employer Amount");
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Description := Deductions.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    Assignmatrix."Manual Entry" := false;
                                    //Assignmatrix.INSERT;
                                    if not (Deductions."Pension Scheme" and ExemptFromStaffPension) then
                                        if not Assignmatrix.Insert then Assignmatrix.Modify;
                                until Deductions.next = 0;
                            end;


                            //24/2/23 FRED - Moved PAYE calculation here - after NSSF

                            /*FnProratePay(Employee."No.",Month);
                            FnGetVoluntaryPension(Employee."No.",Month);
                            Assignmatrix.FnCalculateArrearsPension(Employee."No.",Month);*/
                            //message('Processing tax 1');
                            Deductions.Reset;
                            Deductions.SetRange(Deductions."PAYE Code", true);
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.SetRange(Block, false);
                            if Deductions.Find('-') then begin
                                //message('Processing tax 2');                                
                                if (Employee."Pays tax" = true) or (Employee.Disabled) then begin
                                    //message('Processing tax 3');
                                    // IF Employee.Disabled=FALSE THEN
                                    GetPaye.CalculateTaxableAmount(Employee."No.", Month, IncomeTax, TaxableAmount, RetireCont, Employee."Payroll Country", SpecialTransportAllowanceTaxableIncome, IsGivenSpecialTransportAllowance, SpecialTransportAllowancePAYE)
                                end else begin
                                    GetPaye.CalculateTaxableAmount(Employee."No.", Month, IncomeTax, TaxableAmount, RetireCont, Employee."Payroll Country", SpecialTransportAllowanceTaxableIncome, IsGivenSpecialTransportAllowance, SpecialTransportAllowancePAYE);
                                    IncomeTax := 0;
                                end;
                                SpecialTransportAllowanceStatutoryDeductions += SpecialTransportAllowancePAYE;

                                //NIGERIA special -> Minimum PAYE
                                if Employee."Payroll Country" = 'NIGERIA' then begin
                                    OnePercentOfGross := 1 / 100 * TaxableAmount/*ComputedGrossPay*/;
                                    if OnePercentOfGross > abs(IncomeTax) then
                                        IncomeTax := OnePercentOfGross;
                                end;
                                //If we need to multiply the paye by some factor
                                if (Employee."Apply Paye Multiplier" = true) and (Employee."Paye Multiplier" <> 0) then
                                    IncomeTax := IncomeTax * Employee."Paye Multiplier";
                                //END;
                                //MESSAGE('IncomeTax %1 ,TaxableAmount %2 ,RetireCont %3', IncomeTax, TaxableAmount, RetireCont);
                                // INSERT PAYE
                                /*IF Employee.Disabled THEN
                                  TaxableAmount := TaxableAmount - ExemptedAmount;*/ //Tackled in the calculatetaxableamt fn
                                                                                     /*IF (Employee."Is Seconded") AND (TaxableAmount >= 0) THEN
                                                                                       IncomeTax := (PayeFlatRate/100) * TaxableAmount;*/ //MESSAGE('1. Taxable = %1, income tax = %2',TaxableAmount,IncomeTax);
                                if TaxableAmount < 0 then
                                    TaxableAmount := 0;
                                Assignmatrix.Init;
                                Assignmatrix."Employee No" := Employee."No.";
                                Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                Assignmatrix.Country := Employee."Payroll Country";
                                Assignmatrix."Is Statutory" := Deductions."Is Statutory";
                                Assignmatrix.Code := Deductions.Code;
                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                Assignmatrix.Validate(Code);
                                Assignmatrix."Payroll Period" := Month;
                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                //MESSAGE('Tax%1 Taxable Amount %2', IncomeTax, TaxableAmount);
                                if IncomeTax > 0 then
                                    IncomeTax := -IncomeTax;
                                Assignmatrix.Amount := IncomeTax;
                                if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                    Assignmatrix.Amount := Deductions."Maximum Amount";
                                Assignmatrix.Paye := true;
                                Assignmatrix."Taxable amount" := TaxableAmount;
                                Assignmatrix."Less Pension Contribution" := RetireCont;
                                Assignmatrix.Paye := true;
                                Assignmatrix.Description := Deductions.Description;
                                Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";

                                Assignmatrix."Posting Group Filter" := Employee."Posting Group";
                                Assignmatrix.Validate(Amount);
                                if (Assignmatrix."Taxable amount" <> 0) then
                                    Assignmatrix.Insert;
                            end;


                            PayeDeduction := 0;
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.setrange("PAYE Code", true);
                            Deductions.SetRange(Block, false);
                            if Deductions.findset then begin
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                    Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                    Assignmatrix.SetRange(Assignmatrix.Code, Deductions.Code);
                                    Assignmatrix.SetRange(Assignmatrix.Country, Deductions.Country);
                                    if Assignmatrix.findfirst then
                                        repeat
                                            PayeDeduction += abs(Assignmatrix.Amount);
                                        until Assignmatrix.next = 0;
                                until Deductions.next = 0;
                            end;
                            //Message('PAYE deduction = %1', PayeDeduction);

                            //Work on the specific formula deductions now - Those affected by PAYE
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.SetRange(Block, false);
                            Deductions.SetFilter("Calculation Method", '%1', Deductions."Calculation Method"::"% of PAYE");
                            if Deductions.findfirst then begin
                                repeat
                                    WorkingAmount := 0;
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix."Is Statutory" := Deductions."Is Statutory";
                                    Assignmatrix.Code := Deductions.Code;
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of PAYE") then begin
                                        WorkingAmount := PayeDeduction;

                                        if (IsGivenSpecialTransportAllowance) and (Deductions."Is Statutory") and ((not Deductions."Medical Insurance") or ((Deductions."Medical Insurance") and (((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal)) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))))) and (FnIncludeDeductionInSpecialTransAllowance(Deductions.Code, Deductions."Is Statutory")) then
                                            SpecialTransportAllowanceStatutoryDeductions += (Deductions.Percentage / 100) * SpecialTransportAllowancePAYE;
                                        //Message('Computed Gross %1, PayeDeduction %2, Work with %3, Multiply by %4 to get %5', ComputedGrossPay, PayeDeduction, WorkingAmount, Deductions.Percentage, ((Deductions.Percentage / 100) * WorkingAmount));
                                    end;
                                    Assignmatrix.Amount := (Deductions.Percentage / 100) * WorkingAmount;

                                    if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                        Assignmatrix.Amount := Deductions."Maximum Amount";

                                    Assignmatrix.validate(Amount);
                                    Assignmatrix."Employer Amount" := (Deductions."Percentage Employer" / 100) * WorkingAmount;
                                    if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix."Employer Amount") > abs(Deductions."Maximum Amount"))) then
                                        Assignmatrix."Employer Amount" := Deductions."Maximum Amount";
                                    Assignmatrix.validate("Employer Amount");
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Description := Deductions.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    Assignmatrix."Manual Entry" := false;
                                    //Assignmatrix.INSERT;
                                    if not (Deductions."Pension Scheme" and ExemptFromStaffPension) then
                                        if not Assignmatrix.Insert then Assignmatrix.Modify;
                                until Deductions.next = 0;
                            end;

                            //Capture the statutorydeduction-related calculation separately because some of the deductions above may be forming part of it
                            StatutoryDeductions := 0;
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.setrange("Is Statutory", true);
                            Deductions.SetFilter("Universal Title", '<>%1', 'CBHI');
                            Deductions.SetRange(Block, false);
                            if Deductions.findset then begin
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                    Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                    Assignmatrix.SetRange(Assignmatrix.Code, Deductions.Code);
                                    Assignmatrix.SetRange(Assignmatrix.Country, Deductions.Country);
                                    if Assignmatrix.findfirst then
                                        repeat
                                            StatutoryDeductions += abs(Assignmatrix.Amount);
                                        until Assignmatrix.next = 0;
                                until Deductions.next = 0;
                            end;
                            //Message('StatutoryDeductions 2 = %1', StatutoryDeductions);

                            //Work on the stat-ded-related deduction now
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.SetRange(Block, false);
                            //Deductions.SetRange("Calculation Method", Deductions."Calculation Method"::"% of Gross Less Stat Deductions");
                            Deductions.SetRange("Calculation Method", Deductions."Calculation Method"::"% of Gross Less Stat Deductions");
                            if Deductions.findfirst then begin
                                repeat
                                    WorkingAmount := 0;
                                    Assignmatrix.Init;
                                    Assignmatrix."Employee No" := Employee."No.";
                                    Assignmatrix.Type := Assignmatrix.Type::Deduction;
                                    Assignmatrix.Country := Employee."Payroll Country";
                                    Assignmatrix."Is Statutory" := Deductions."Is Statutory";
                                    Assignmatrix.Code := Deductions.Code;
                                    Assignmatrix.Validate(Assignmatrix.Code);
                                    Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                    ////if (Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Gross Less Stat Deductions") then begin
                                    WorkingAmount := ComputedGrossPay - StatutoryDeductions;
                                    //Message('Computed Gross %1, Less Stat Ded %2, Get %3, Multiply by %4 to get %5', ComputedGrossPay, StatutoryDeductions, WorkingAmount, Deductions.Percentage, ((Deductions.Percentage / 100) * WorkingAmount));
                                    ////end;
                                    Assignmatrix.Amount := (Deductions.Percentage / 100) * WorkingAmount;

                                    if ((abs(Deductions."Maximum Amount") > 0) and (abs(Assignmatrix.Amount) > abs(Deductions."Maximum Amount"))) then
                                        Assignmatrix.Amount := Deductions."Maximum Amount";

                                    if (IsGivenSpecialTransportAllowance) and (Deductions."Is Statutory") and ((not Deductions."Medical Insurance") or ((Deductions."Medical Insurance") and (((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::Normal) and (Employee."Medical Insurance" = Employee."Medical Insurance"::Normal)) or ((Deductions."Medical Insurance Category" = Deductions."Medical Insurance Category"::MMI) and (Employee."Medical Insurance" = Employee."Medical Insurance"::MMI))))) and (FnIncludeDeductionInSpecialTransAllowance(Deductions.Code, Deductions."Is Statutory")) then
                                        SpecialTransportAllowanceStatutoryDeductions += ((Deductions.Percentage / 100) * (SpecialTransportAllowanceGross - SpecialTransportAllowanceStatutoryDeductions));

                                    Assignmatrix.validate(Amount);
                                    Assignmatrix."Employer Amount" := (Deductions."Percentage Employer" / 100) * WorkingAmount;
                                    Assignmatrix.validate("Employer Amount");
                                    Assignmatrix."Payroll Period" := Month;
                                    Assignmatrix.Description := Deductions.Description;
                                    Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                    Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                    Assignmatrix."Manual Entry" := false;
                                    //Assignmatrix.INSERT;
                                    if not Assignmatrix.Insert then Assignmatrix.Modify;
                                until Deductions.next = 0;
                            end;

                            //Delete the contractual amount if it is not meant to go to matrix
                            if not ContractualAmountGoesToMatrix then begin
                                Assignmatrix.Reset;
                                Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                Assignmatrix.SetRange(Assignmatrix.Code, /*GrossPayCode*/ContractualAmountCode);
                                Assignmatrix.setrange(Country, Employee."Payroll Country");
                                Assignmatrix.deleteall;
                            end;
                            TotalDeductions := StatutoryDeductions;
                            Deductions.Reset;
                            Deductions.SetRange(Country, Employee."Payroll Country");
                            Deductions.setrange("Is Statutory", false);
                            Deductions.SetRange(Block, false);
                            if Deductions.findset then begin
                                repeat
                                    Assignmatrix.Reset;
                                    Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                                    Assignmatrix.SetRange(Assignmatrix."Payroll Period", Month);
                                    Assignmatrix.SetRange(Assignmatrix.Code, Deductions.Code);
                                    Assignmatrix.SetRange(Assignmatrix.Country, Deductions.Country);
                                    if Assignmatrix.findfirst then
                                        repeat
                                            TotalDeductions += abs(Assignmatrix.Amount);
                                        until Assignmatrix.next = 0;
                                until Deductions.next = 0;
                            end;
                            if (Employee."Under Terminal Dues Processing" = false) and (TotalDeductions > (ComputedGrossPay + EarningsThatReduceGross + DeductionsThatReduceGross)) then begin
                                conftxt := 'Please Note that Employee No: ' + Employee."No." + '- ' + Employee."First Name" + ' ' + Employee."Last Name" + ' \has a negative net pay for ';
                                conftxt := conftxt + ' Payroll Period -' + Format(Month) + '\Do you want to stop processing and sort it first?';
                                conf := Confirm(conftxt);
                                if Format(conf) = 'Yes' then begin
                                    Error('Process paused successfully. Fix the issue then run payroll again.');
                                end;
                            end;

                            ProcessedEmployeesCount += 1;
                            Window.Update(1, Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name");
                            Window.UPDATE(2, Format(ROUND(ProcessedEmployeesCount / AllActiveEmployeesCount * 100, 1)) + '%');

                        end;
                    until TempEmpMovement.Next() = 0;
                end else begin
                    //If it finds any existing records, it will delete
                    Assignmatrix.RESET();
                    Assignmatrix.SETRANGE("Employee No", Employee."No.");
                    Assignmatrix.SETRANGE("Payroll Period", Month);
                    if Assignmatrix.Find('-') then begin
                        conftxt := 'Please Note that Employee No: ' + Employee."No." + '- ' + Employee."First Name" + ' ' + Employee."Last Name" + ' \has a Last Date that is in the past compared to this';
                        conftxt := conftxt + ' Payroll Period-' + Format(Month) + '\Do you want to Clear their Payroll Information for this Month?';
                        conf := Confirm(conftxt);
                        if Format(conf) = 'Yes' then begin
                            Assignmatrix.DELETEALL();
                        end;
                    end;
                end;

                //Update transaction titles if missing
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange("Transaction Title", '');
                Assignmatrix.SetFilter(Amount, '<>%1', 0);
                if Assignmatrix.FindSet() then
                    repeat
                        if Assignmatrix."Housing Allowance" then //Don't touch no housing allowance people
                            Assignmatrix."Transaction Title" := 'HOUSING ALLOWANCE'
                        else
                            Assignmatrix.Validate(Code);
                        Assignmatrix.Modify();
                    until Assignmatrix.Next() = 0;


                //Perform Inhouse instructor Allowance computations here
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange("Inhouse instructor Allowance", true); //'IN-HOUSE INSTRUCTOR ALLOWANCE'
                Assignmatrix.SetRange("Inhouse Allowance Processed", false); //Don't process if already processed
                if Assignmatrix.FindSet() then
                    repeat
                        Assignmatrix.Validate(Amount);
                        //Let's hardcode stuff very first, improvements can be done later
                        Assignmatrix."Overtime Allowance" := false;
                        Assignmatrix."Exclude from Payroll" := true;
                        Assignmatrix."Taxable amount" := Assignmatrix.Amount;
                        Assignmatrix."Overtime RSSB Pension" := Assignmatrix."Taxable amount" * 0.06;
                        Assignmatrix."Overtime Maternity Leave" := Assignmatrix."Taxable amount" * 0.003;
                        Assignmatrix."Overtime PAYE" := Assignmatrix."Taxable amount" * 0.3;
                        if Assignmatrix."Amount Type" = Assignmatrix."Amount Type"::Gross then //If net just let it be
                            Assignmatrix."Overtime Net" := Assignmatrix."Taxable amount" - (Assignmatrix."Overtime RSSB Pension" + Assignmatrix."Overtime Maternity Leave" + Assignmatrix."Overtime PAYE");
                        Assignmatrix."Overtime CBHI" := Assignmatrix."Overtime Net" * 0.005;
                        Assignmatrix."Inhouse Allowance Processed" := true;
                        Assignmatrix.Modify();
                    until Assignmatrix.Next() = 0;

                //Perform overtime computations here
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange("Overtime Allowance", true);
                if Assignmatrix.FindSet() then
                    repeat
                        Assignmatrix.Validate(Amount);
                        //Let's hardcode stuff very first, improvements can be done later
                        Assignmatrix."Exclude from Payroll" := true;
                        Assignmatrix."Taxable amount" := Assignmatrix.Amount;
                        Assignmatrix."Overtime RSSB Pension" := Assignmatrix."Taxable amount" * 0.06;
                        Assignmatrix."Overtime Maternity Leave" := Assignmatrix."Taxable amount" * 0.003;
                        Assignmatrix."Overtime PAYE" := Assignmatrix."Taxable amount" * 0.3;
                        Assignmatrix."Overtime Net" := Assignmatrix."Net Amount";
                        if Assignmatrix."Amount Type" = Assignmatrix."Amount Type"::Gross then //If net just let it be
                            Assignmatrix."Overtime Net" := Assignmatrix."Taxable amount" - (Assignmatrix."Overtime RSSB Pension" + Assignmatrix."Overtime Maternity Leave" + Assignmatrix."Overtime PAYE");
                        Assignmatrix."Overtime CBHI" := Assignmatrix."Overtime Net" * 0.005;
                        Assignmatrix.Modify();
                    until Assignmatrix.Next() = 0;

                //Perform lumpsum computations here
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Employee No", Employee."No.");
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange("Transaction Title", 'LUMPSUM ALLOWANCE');
                if Assignmatrix.FindFirst() then begin
                    Assignmatrix.Validate(Amount);
                    //Let's hardcode stuff very first, improvements can be done later
                    Assignmatrix."Exclude from Payroll" := true;
                    Assignmatrix."Lumpsum PAYE" := Assignmatrix.Amount * 0.3;
                    Assignmatrix."Lumpsum Social Security" := Assignmatrix.Amount * 0.06;
                    Assignmatrix.Modify();
                end;


                //Delete any records of countries not applicable
                //if ProcessedEmpCountriesFilter <> '<>' then begin
                //Message('ProcessedEmpCountriesFilter %1', ProcessedEmpCountriesFilter);
                if ProcessedEmpCountriesFilter <> '' then begin
                    Assignmatrix.RESET();
                    Assignmatrix.SETRANGE("Employee No", Employee."No.");
                    Assignmatrix.SETRANGE("Payroll Period", Month);
                    Assignmatrix.SetFilter("Country", ProcessedEmpCountriesFilter);
                    Assignmatrix.DELETEALL;
                end;
                //This should be sorted up there on the confirm delete of inactive section
                /*if ProcessedEmpCountriesFilter = '' then begin
                    Assignmatrix.RESET();
                    Assignmatrix.SETRANGE("Employee No", Employee."No.");
                    Assignmatrix.SETRANGE("Payroll Period", Month);
                    //Assignmatrix.SetFilter("Country", ProcessedEmpCountriesFilter);
                    Assignmatrix.DELETEALL;
                end;*/

                //Update Special Transport Allowance here
                //Message('1');
                //Message('2');
                EarningsRec.Reset();
                EarningsRec.SetRange("Exclude from Payroll", true);
                EarningsRec.setrange(Country, Employee."Payroll Country");
                EarningsRec.SetRange(Block, false);
                EarningsRec.SetRange("Special Transport Allowance", true);
                EarningsRec.SetFilter("Universal Title", '<>%1', 'SPECIAL TRANSPORT ALLOWANCE ARREAS');
                if EarningsRec.FindFirst() then begin
                    //Message('3');
                    Assignmatrix.RESET();
                    Assignmatrix.SETRANGE("Employee No", Employee."No.");
                    Assignmatrix.SETRANGE("Payroll Period", Month);
                    Assignmatrix.SETRANGE(Code, EarningsRec.Code);
                    Assignmatrix.SetRange(Country, Employee."Payroll Country");
                    Assignmatrix.SetFilter("Transaction Title", '<>%1', 'SPECIAL TRANSPORT ALLOWANCE ARREAS');
                    Assignmatrix.DELETEALL;

                    Employee.CalcFields("Given Transport Allowance");
                    if Employee."Given Transport Allowance" then begin

                        StatutoryNet := SpecialTransportAllowanceGross - SpecialTransportAllowanceStatutoryDeductions;
                        //Message('A. StatutoryNet %1 | ComputedGrossPay: %2 | StatutoryDeductions %3 |  SportFacilitationAllowance %4', StatutoryNet, ComputedGrossPay, StatutoryDeductions, SportFacilitationAllowance);
                        SpecialTransportCutoffInPayrollCurrency := ABS(GetInDesiredCurrency('RWF', Employee."Payroll Currency", SpecialTransportCutoff, Month, Employee));
                        StatutoryNetRWF := ABS(GetInDesiredCurrency(Employee."Payroll Currency", 'RWF', StatutoryNet, Month, Employee));
                        //Message('ComputedGrossPay %1, StatutoryDeductions %2, StatutoryNet %3, StatutoryNetRWF %4, SpecialTransportCutoff %5, SpecialTransportCutoffInPayrollCurrency %6', ComputedGrossPay, StatutoryDeductions, StatutoryNet, StatutoryNetRWF, SpecialTransportCutoff, SpecialTransportCutoffInPayrollCurrency);

                        NoOfDaysInMonth := CalcDate('<CM>', Month) - CalcDate('-CM', Month);
                        NoOfDaysInMonth := NoOfDaysInMonth + 1;
                        MaternityWorkingDays := NoOfDaysInMonth;
                        Employee.StaffOnMaternityLeave(Month, MaternityWorkingDays);
                        //Message('MaternityWorkingDays %1', MaternityWorkingDays);
                        if (SpecialTransportCutoffInPayrollCurrency > 0) and (StatutoryNet < SpecialTransportCutoffInPayrollCurrency) and (MaternityWorkingDays > 0) then begin
                            SpecialTransportAllowanceRwf := abs(GetPaye.GetNonTaxTableDeduction(StatutoryNetRWF, Employee."Payroll Country", EarningsRec.Code, '', 0)); //The table is always in RWF
                            //Message('SpecialTransportAllowanceRwf %1', SpecialTransportAllowanceRwf);

                            if SpecialTransportAllowanceRwf <> 0 then begin
                                //Message('2. SpecialTransportAllowanceRwf %1', SpecialTransportAllowanceRwf);
                                SpecialTransportAllowanceRwf := SpecialTransportAllowanceRwf * (MaternityWorkingDays / NoOfDaysInMonth);
                                Assignmatrix.Init;
                                Assignmatrix."Employee No" := Employee."No.";
                                Assignmatrix.Type := Assignmatrix.Type::Payment;
                                Assignmatrix.Country := Employee."Payroll Country";
                                Assignmatrix."Tax Deductible" := EarningsRec."Reduces Tax";
                                Assignmatrix.Code := EarningsRec.Code;
                                Assignmatrix.Validate(Assignmatrix.Code);
                                Assignmatrix."Country Currency" := Employee."Payroll Currency";
                                Assignmatrix.Amount := ABS(GetInDesiredCurrency('RWF', Employee."Payroll Currency", SpecialTransportAllowanceRwf, Month, Employee));
                                Assignmatrix.validate(Amount);
                                Assignmatrix."Statutory Net" := StatutoryNet;
                                Assignmatrix."Statutory Gross" := SpecialTransportAllowanceGross;
                                Assignmatrix."Statutory Deductions" := SpecialTransportAllowanceStatutoryDeductions;
                                Assignmatrix."Special Transport Allowance" := true;
                                Assignmatrix."Payroll Period" := Month;
                                Assignmatrix.Description := EarningsRec.Description;
                                Assignmatrix."Global Dimension 1 code" := Employee."Global Dimension 1 Code";
                                Assignmatrix."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                                Assignmatrix."Manual Entry" := false;
                                Assignmatrix."Exclude from Payroll" := true;
                                if not Assignmatrix.Insert then Assignmatrix.Modify;
                            end;
                        end;
                    end;
                end;

                //Copy emp bank records
                EmpPeriodBankDetails.Reset();
                EmpPeriodBankDetails.SetRange("Emp No.", Employee."No.");
                EmpPeriodBankDetails.SetRange("Payroll Period", Month);
                EmpPeriodBankDetails.DeleteAll();

                EmpPeriodBankDetailsInit.Reset();
                EmpPeriodBankDetailsInit.Init();
                EmpPeriodBankDetailsInit."Emp No." := Employee."No.";
                EmpPeriodBankDetailsInit."Payroll Period" := Month;
                EmpPeriodBankDetailsInit."First Name" := Employee."First Name";
                EmpPeriodBankDetailsInit."Middle Name" := Employee."Middle Name";
                EmpPeriodBankDetailsInit."Last Name" := Employee."Last Name";
                EmpPeriodBankDetailsInit."Bank Code" := Employee."Bank Code";
                EmpPeriodBankDetailsInit."Bank Name" := Employee."Bank Name";
                EmpPeriodBankDetailsInit."Bank Account No." := Employee."Bank Account No";
                if EmpPeriodBankDetailsInit."Bank Account No." = '' then
                    EmpPeriodBankDetailsInit."Bank Account No." := Employee."Bank Account No.";
                EmpPeriodBankDetailsInit."Branch Code" := Employee."Bank Branch Code";
                EmpPeriodBankDetailsInit."Branch Name" := Employee."Bank Brach Name";
                EmpPeriodBankDetailsInit."SWIFT Code" := Employee."SWIFT Code";
                EmpPeriodBankDetailsInit.IBAN := Employee.IBAN;
                EmpPeriodBankDetailsInit."Bank Country" := Employee."Payment/Bank Country";
                EmpPeriodBankDetailsInit."Bank Currency" := Employee."Payment/Bank Currency";
                EmpPeriodBankDetailsInit."Sort Code" := Employee."Sort Code";
                EmpPeriodBankDetailsInit.Indicatif := Employee.Indicatif;
                EmpPeriodBankDetailsInit."Code B.I.C." := Employee."Code B.I.C.";
                EmpPeriodBankDetailsInit."Payroll Country" := Employee."Payroll Country";
                EmpPeriodBankDetailsInit.Insert();

                ExtraPayrollBanks.Reset();
                ExtraPayrollBanks.SetRange("Payroll Period", Month);
                ExtraPayrollBanks.SetRange("Emp No.", Employee."No.");
                if ExtraPayrollBanks.FindSet() then
                    repeat
                        EmpPeriodBankDetailsInit.Reset();
                        EmpPeriodBankDetailsInit.Init();
                        EmpPeriodBankDetailsInit."Emp No." := Employee."No.";
                        EmpPeriodBankDetailsInit."Payroll Period" := Month;
                        EmpPeriodBankDetailsInit."First Name" := Employee."First Name";
                        EmpPeriodBankDetailsInit."Middle Name" := Employee."Middle Name";
                        EmpPeriodBankDetailsInit."Last Name" := Employee."Last Name";
                        EmpPeriodBankDetailsInit."Bank Code" := ExtraPayrollBanks."Bank Code";
                        EmpPeriodBankDetailsInit."Bank Name" := ExtraPayrollBanks."Bank Name";
                        EmpPeriodBankDetailsInit."Bank Account No." := ExtraPayrollBanks."Bank Account No";
                        EmpPeriodBankDetailsInit."Branch Code" := ExtraPayrollBanks."Branch Code";
                        EmpPeriodBankDetailsInit."Branch Name" := ExtraPayrollBanks."Branch Name";
                        EmpPeriodBankDetailsInit."SWIFT Code" := ExtraPayrollBanks."SWIFT Code";
                        EmpPeriodBankDetailsInit.IBAN := ExtraPayrollBanks.IBAN;
                        EmpPeriodBankDetailsInit."Bank Country" := ExtraPayrollBanks."Bank Country";
                        EmpPeriodBankDetailsInit."Bank Currency" := ExtraPayrollBanks.Currency;
                        EmpPeriodBankDetailsInit."Sort Code" := ExtraPayrollBanks."Sort Code";
                        EmpPeriodBankDetailsInit.Indicatif := ExtraPayrollBanks.Indicatif;
                        EmpPeriodBankDetailsInit."Code B.I.C." := ExtraPayrollBanks."Code B.I.C.";
                        EmpPeriodBankDetailsInit.Amount := ExtraPayrollBanks.Amount;
                        EmpPeriodBankDetailsInit."Payroll Country" := Employee."Payroll Country";
                        EmpPeriodBankDetailsInit.Insert();
                    until ExtraPayrollBanks.Next() = 0;
            end;

            trigger OnPostDataItem()
            var
                IsTerminalDuesProcessing: Boolean;
                TrainingAllowanceBatches: Record "Training Allowance Batches";
                TrainingAllowanceBatchPage: Page "Training Allowance Batches";
            begin
                TempEmpMovement.reset();
                TempEmpMovement.DeleteAll();
                //Copy departmental records for this period
                PeriodDeptSections.Reset();
                PeriodDeptSections.SetRange("Payroll Period", Month);
                PeriodDeptSections.DeleteAll();

                //Deactivate the temporarily activated overtime staff
                //Temporarily activate any inactive staff with overtime allowance
                Assignmatrix.RESET;
                Assignmatrix.SETRANGE("Emp Is Inactive", true);
                Assignmatrix.SETRANGE("Payroll Period", Month);
                Assignmatrix.SetRange(/*"Overtime Allowance"*/"Allow temp staff activation", true);
                if Assignmatrix.FindSet() then
                    repeat
                        EmpRec.Reset();
                        EmpRec.SetRange("No.", Assignmatrix."Employee No");
                        if EmpRec.FindFirst() then begin
                            Assignmatrix7.Reset();
                            Assignmatrix7.SetRange("Employee No", Assignmatrix."Employee No");
                            Assignmatrix7.SetRange("Payroll Period", Month);
                            Assignmatrix7.SetRange(/*"Overtime Allowance"*/"Allow temp staff activation", false);
                            if Assignmatrix7.Find('-') then
                                Assignmatrix7.DeleteAll();

                            PeriodPrevailingMovements.Reset();
                            PeriodPrevailingMovements.SetRange("Emp No.", Assignmatrix."Employee No");
                            PeriodPrevailingMovements.SetRange("Payroll Period", Month);
                            PeriodPrevailingMovements.DeleteAll();

                            CausesOfInactivity.Reset();
                            CausesOfInactivity.SetRange("Emp No.", Assignmatrix."Employee No");
                            CausesOfInactivity.SetRange("Payroll Period", Month);
                            CausesOfInactivity.DeleteAll();

                            EmpPeriodBankDetails.Reset();
                            EmpPeriodBankDetails.SetRange("Emp No.", Assignmatrix."Employee No");
                            EmpPeriodBankDetails.SetRange("Payroll Period", Month);
                            EmpPeriodBankDetails.DeleteAll();

                            EmpRec."Under Terminal Dues Processing" := false;
                            EmpRec.Status := EmpRec.Status::Inactive;
                            EmpRec.Modify();
                        end;
                    until Assignmatrix.Next() = 0;


                Sections.Reset();
                if Sections.FindSet() then
                    repeat
                        PeriodDeptSectionsInit.Reset();
                        PeriodDeptSectionsInit.Init();
                        PeriodDeptSectionsInit."Payroll Period" := Month;
                        PeriodDeptSectionsInit."Section Code" := Sections.Code;
                        PeriodDeptSectionsInit."Section Name" := Sections.Description;
                        if PeriodDeptSectionsInit."Section Name" = '' then
                            PeriodDeptSectionsInit."Section Name" := Sections.Code;
                        PeriodDeptSectionsInit."Department Code" := Sections."Responsibility Center";

                        if Sections."Responsibility Center" <> '' then begin
                            Depts.Reset();
                            Depts.SetRange(Code, CopyStr(Sections."Responsibility Center", 1, 10));
                            if Depts.FindFirst() then begin
                                PeriodDeptSectionsInit."Department Name" := Depts.Name;
                                if PeriodDeptSectionsInit."Department Name" <> '' then
                                    PeriodDeptSectionsInit."Department Name" := Sections."Responsibility Center";
                            end;
                        end;
                        PeriodDeptSectionsInit.Insert();
                    until Sections.Next() = 0;

                //Send inhouse allowance processed update if all payrolls processed
                TrainingAllowanceBatches.Reset();
                TrainingAllowanceBatches.SetRange("Payroll Period", Month);
                TrainingAllowanceBatches.SetRange(Status, TrainingAllowanceBatches.Status::Processing);
                if TrainingAllowanceBatches.FindFirst() then begin
                    Assignmatrix.RESET;
                    Assignmatrix.SETRANGE("Payroll Period", Month);
                    Assignmatrix.SetRange("Inhouse instructor Allowance", true);
                    Assignmatrix.SetRange("Inhouse Allowance Processed", false);
                    if not Assignmatrix.FindFirst() then //all processed
                        TrainingAllowanceBatchPage.notifySenderBatchProcessed(Month);
                end;

                IsTerminalDuesProcessing := false;
                EmpRec.Reset();
                EmpRec.SETRANGE(EmpRec."No.", LastEmployeeNo);
                if EmpRec.FindFirst() then
                    IsTerminalDuesProcessing := EmpRec."Under Terminal Dues Processing";

                if (not IsTerminalDuesProcessing) then
                    Message('Payroll for %1 Employee(s) processed successfully! Press OK to generate a report of the output.', ProcessedEmployeesCount);
                Window.Close;
                if (ProcessedEmployeesCount = 1) and (not IsTerminalDuesProcessing) then begin
                    EmpRec.Reset();
                    EmpRec.SETRANGE(EmpRec."No.", LastEmployeeNo);
                    //EmpRec.SetRange("Payroll Country", LastPayrollCountry);
                    NewPayslipReport.SETTABLEVIEW(EmpRec);//Set the dataitem filters

                    PayPeriod.Reset();
                    PayPeriod.SetRange("Starting Date", Month);
                    if PayPeriod.Find('-') then
                        NewPayslipReport.SETTABLEVIEW(PayPeriod);

                    NewPayslipReport.SetReportFilter(LastEmployeeNo, Month, ''/*LastCurrencyCode*/);//Set the request page filters
                    commit();
                    NewPayslipReport.Run();

                    //NewPayslipReport.SetReportFilter(LastEmployeeNo, Month, LastCurrencyCode);
                    //NewPayslipReport.Run();
                    /*EmpRec.Reset;
                    EmpRec.SetRange(EmpRec."No.", LastEmployeeNo);
                    if EmpRec.Find('-') then begin
                        EmpRec.Setrange("Payroll Currency", LastCurrencyCode);
                        Commit();
                        REPORT.Run(51525117, true, true, EmpRec);
                    end;*/
                end;
                if (ProcessedEmployeesCount > 1) then begin
                    //PayrollStatisticReport.SetReportFilter(Month, LastPayrollCountry);
                    //PayrollStatisticReport.Run();
                    EmpRec.Reset;
                    EmpRec.SetRange(EmpRec."Pay Period Filter", Month);
                    if EmpRec.Find('-') then begin
                        PayrollStatisticReport.SetTableView(EmpRec);
                        PayrollStatisticReport.SetReportFilter(Month, LastPayrollCountry);
                        Commit();
                        PayrollStatisticReport.Run();
                        //EmpRec.Setrange("Payroll Country", LastPayrollCountry);

                        //REPORT.Run(51525082, true, true, EmpRec);
                    end;
                end;
            end;

            trigger OnPreDataItem()
            var
                TrainingAllowanceBatches: Record "Training Allowance Batches";
                TrainingAllowanceBatchPage: Page "Training Allowance Batches";
            begin
                //Window.Open('Calculating Payroll For ##############################1', EmployeeName);

                PayrollPeriod.SetRange(Closed, false);
                if PayrollPeriod.Find('-') then
                    Month := PayrollPeriod."Starting Date";
                LastMonth := CalcDate('-1M', Month);
                DateSpecified := Month;

                //Ensure instructor allowance is added here
                TrainingAllowanceBatches.Reset();
                TrainingAllowanceBatches.SetRange("Payroll Period", Month);
                TrainingAllowanceBatches.SetRange(Status, TrainingAllowanceBatches.Status::"Sent to Payroll");
                if TrainingAllowanceBatches.FindFirst() then begin
                    if Confirm('A training instructor allowance batch has been sent to payroll for processing. It should be processed within this period. Do you want to accept it now?') then
                        TrainingAllowanceBatchPage.addToPayroll(Month);
                end;

                Window.OPEN('Processing Payroll For ##############################1 \ Progress: #2###', EmployeeName, PercentProcessed);

                if HrSetup.Get then begin
                    ExemptedAmount := HrSetup."Max Tax Exemption Amount";
                    InsuranceReliefRate := HrSetup."Insurance Relief Rate (%)";
                    PayeFlatRate := HrSetup."PAYE Flat Rate (%)";
                    SpecialTransportCutoff := HrSetup."Special Transport Allowance";
                end else
                    Error('Payroll setup not found. You must configure the setup before proceeding!');

                //Delete all records of inactive employees
                EmpRec.Reset();
                EmpRec.SetRange(Status, EmpRec.Status::Inactive);
                if EmpRec.FindSet() then
                    repeat
                        //Set the causes of inactivity for all inactive staff whose last day in movement falls in or beyond this period
                        EmpMovement.Reset();
                        EmpMovement.SetRange("Emp No.", EmpRec."No.");
                        EmpMovement.SetRange(Status, EmpMovement.Status::Current);
                        //EmpMovement.SetFilter("Last Date", '>=%1', Month);//Last date is greater than or equal to start date of this period
                        //EmpMovement.SetRange("Terminal Dues", false); //Skip those on terminal dues for now.
                        if EmpMovement.FindFirst() then begin
                            if (EmpMovement."Last Date" < Month) or (EmpMovement."Terminal Dues") then begin
                                CausesOfInactivity.Reset();
                                CausesOfInactivity.SetRange("Emp No.", EmpRec."No.");
                                CausesOfInactivity.SetRange("Payroll Period", Month);
                                CausesOfInactivity.DeleteAll();

                                EmpRec.Validate("Cause of Inactivity Code");
                                if EmpRec."Cause of Inactivity" <> '' then begin
                                    CausesOfInactivityInit.Reset();
                                    CausesOfInactivityInit.Init();
                                    CausesOfInactivityInit."Emp No." := EmpRec."No.";
                                    CausesOfInactivityInit."Payroll Period" := Month;
                                    CausesOfInactivityInit."Cause of Inactivity" := EmpRec."Cause of Inactivity";
                                    CausesOfInactivityInit.Insert();
                                end;
                            end;
                        end else begin //only delete those who left last month and back or are terminal dues
                            Assignmatrix.Reset();
                            Assignmatrix.SetRange("Employee No", EmpRec."No.");
                            Assignmatrix.SetRange("Payroll Period", Month);
                            Assignmatrix.SetRange("Allow temp staff activation", false);
                            Assignmatrix.DeleteAll();
                        end;
                    until EmpRec.next() = 0;

                //We want to show progress bar
                AllActiveEmployeesCount := 0;
                EmpRec.reset;
                //EmpRec.SetRange(Status, EmpRec.Status::Active);
                EmpRec.CopyFilters(Employee);
                AllActiveEmployeesCount := EmpRec.count;
                ProcessedEmployeesCount := 0;

                //message('SelectedEmployeeNo = %1',SelectedEmployeeNo);

                if SelectedEmployeeNo <> '' then
                    Employee.SetFilter("No.", SelectedEmployeeNo);

                TempEmpMovement.reset();
                TempEmpMovement.DeleteAll();

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DateSpecified; DateSpecified)
                {
                    Caption = 'Pay Period';
                    TableRelation = "Payroll Period"."Starting Date" WHERE(Closed = FILTER(false));
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin

        PayrollPeriod.SetRange(Closed, false);
        if PayrollPeriod.FindFirst then
            Month := PayrollPeriod."Starting Date";
        LastMonth := CalcDate('-1M', Month);
        DateSpecified := Month;

        if PayPeriod.Get(DateSpecified) then
            PayPeriodtext := PayPeriod.Name;
        EndDate := CalcDate('1M', DateSpecified) - 1;
        CompRec.Get;
        TaxCode := CompRec."Tax Table";

        GenLedgerSetup.Get();
        localCurrencyCode := '';
        localCurrencyCode := GenLedgerSetup."LCY Code";
        if localCurrencyCode = '' then
            Error('The local currency code has not been specified in the General Ledger Setup!');

        //Temporarily activate any inactive staff with overtime allowance
        Assignmatrix.RESET;
        Assignmatrix.SETRANGE("Emp Is Inactive", true);
        Assignmatrix.SETRANGE("Payroll Period", Month);
        Assignmatrix.SetRange(/*"Overtime Allowance"*/"Allow temp staff activation", true);
        if Assignmatrix.FindSet() then
            repeat
                EmpRec.Reset();
                EmpRec.SetRange("No.", Assignmatrix."Employee No");
                if EmpRec.FindFirst() then begin
                    EmpRec."Under Terminal Dues Processing" := true; //Not true but just to give us unquestioned access
                    EmpRec.Status := EmpRec.Status::Active;
                    EmpRec.Modify();
                end;
            until Assignmatrix.Next() = 0;
    end;

    var
        Assignmatrix: Record "Assignment Matrix";
        Assignmatrix7: Record "Assignment Matrix";
        BeginDate: Date;
        DateSpecified: Date;
        BasicSalary: Decimal;
        TaxableAmount: Decimal;
        CompRec: Record "Human Resources Setup";
        HseLimit: Decimal;
        TaxCode: Code[10];
        retirecontribution: Decimal;
        ExcessRetirement: Decimal;
        GrossPay: Decimal;
        TotalBenefits: Decimal;
        TaxablePay: Decimal;
        RetireCont: Decimal;
        TotalQuarters: Decimal;
        IncomeTax: Decimal;
        relief: Decimal;
        EmpRec: Record Employee;
        NetPay: Decimal;
        NetPay1: Decimal;
        Index: Integer;
        Intex: Integer;
        AmountRemaining: Decimal;
        PayPeriod: Record "Payroll Period";
        DenomArray: array[1, 12] of Text[50];
        NoOfUnitsArray: array[1, 12] of Integer;
        AmountArray: array[1, 60] of Decimal;
        PayMode: Text[30];
        PayPeriodtext: Text[30];
        EndDate: Date;
        DaysinAmonth: Decimal;
        HoursInamonth: Decimal;
        Earnings: Record Earnings;
        CfMpr: Decimal;
        Deductions: Record Deductions;
        NormalOvertimeHours: Decimal;
        WeekendOvertime: Decimal;
        PayrollPeriod: Record "Payroll Period";
        Window: Dialog;
        EmployeeName: Text[230];
        PercentProcessed: Decimal;
        NoOfDays: Integer;
        Month: Date;
        GetPaye: Codeunit "Loan-Payroll";
        GetGroup: Codeunit "Loan-Payroll";
        GroupCode: Code[20];
        CUser: Code[20];
        ScalePointer: Record "Salary Pointers";
        SalaryScale: Record "Salary Scales";
        CurrentMonth: Integer;
        CurrentMonthtext: Text[30];
        //HseAllow: Record "House Allowance Matrix";
        Ded: Record Deductions;
        Assmatrix: Record "Assignment Matrix";
        LoanType: Record "Loan Product Type";
        LoanType1: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
        LoanBalance: Decimal;
        InterestAmt: Decimal;
        RefNo: Code[20];
        LastMonth: Date;
        NextPointer: Code[10];
        ScaleBenefits: Record "Scale Benefits";
        BasicSalaryCode: Code[30];
        LoanTopUp: Record "Loan Top-up";
        TotalTopUp: Decimal;
        RepSchedule: Record "Repayment Schedule";
        Informational: Boolean;
        ClosingBal: Decimal;
        RepaymentAmt: Decimal;
        REPAREC: Record "Repayment Schedule";
        conf: Boolean;
        conftxt: Text;
        BracketsX1: Record "Brackets Lines";
        NHIFamount: Decimal;
        MarketIntRateRec: Record "Market Intrest Rates";
        MarketIntRate: Decimal;
        InterestRate: Decimal;
        Taxpercentage: Decimal;
        Numerator: Decimal;
        Denominator: Decimal;
        Repayment: Decimal;
        NumeratorF: Decimal;
        DenominatorF: Decimal;
        RepaymentF: Decimal;
        Installments: Integer;
        fringestart: Date;
        months: Integer;
        LoopEndBool: Boolean;
        Principalamount: Decimal;
        Fringebal: Decimal;
        FringeAmount: Decimal;
        FringeAmountT: Decimal;
        InterestAmount: Decimal;
        Principamount: Decimal;
        Principal2: Decimal;
        Mortgage: Boolean;
        Mortgageamt: Decimal;
        LoanApps: Record "Loan Application";
        TotalAllowance: Decimal;
        BracketTablesRec: Record "Bracket Tables";
        EarningsRec: Record Earnings;
        MortgageCode: Code[10];
        DeductionsRec: Record Deductions;
        NHIFCode: Code[10];
        CountDaysofMonth: Integer;
        DaysWorked: Integer;
        IncrMonth: Text;
        MonthTxt: Text;
        MonthTxt1: Text;
        BlockedAs: Record "Block Assignment";
        Secondd: Record "Secondment Values";
        DeductionsT: Record Deductions;
        DeductionsX: Record Deductions;
        DeductionsS: Record Deductions;
        TermBasic: Decimal;
        Deductions2: Record Deductions;
        InsuranceRelief2: Decimal;
        InsuranceReliefBaseAmount2: Decimal;
        HRCalendarList: Record "HR Calendar List";
        NonWorkingDays: Integer;
        RemainingAmount: Decimal;
        NssfAmount: Decimal;
        ExemptedAmount: Decimal;
        PayrollSetup: Record "Payroll Setup";
        HrSetup: Record "Human Resources Setup";

        InsuranceReliefRate: Integer;
        PayeFlatRate: Integer;
        SpecialTransportCutoff: Decimal;
        SpecialTransportCutoffInPayrollCurrency: Decimal;
        SpecialTransportAllowanceRwf: Decimal;
        SpecialTransportAllowanceStatutoryDeductions: Decimal;
        SpecialTransportAllowancePAYE: Decimal;
        SpecialTransportAllowanceTaxableIncome: Decimal;
        Earn: Record Earnings;
        CurrMonthEnd: Date;
        CurrMonthStart: Date;
        CurrMonthDays: Integer;
        GrossForHousing: Decimal;
        HousingLevyEmployee: Decimal;
        HousingLevyEmployer: Decimal;
        InsuranceReliefCode: Code[30];
        GrossPayRwf: Decimal;
        BasicSalaryRwf: Decimal;
        TransportAllowanceRwf: Decimal;
        GrossPayCode: Code[30];
        ContractualAmountCode: Code[30];
        ContractualAmountGoesToMatrix: Boolean;
        StatutoryDeductions: Decimal;
        StatutoryNet: Decimal;
        MaternityWorkingDays: Integer;
        NoOfDaysInMonth: Integer;
        StatutoryNetRWF: Decimal;
        SportFacilitationAllowanceRwf: Decimal;
        SportFacilitationAllowance: Decimal;
        IsGivenSpecialTransportAllowance: Boolean;
        SpecialTransportAllowanceGross: Decimal;
        SpecialTransportAllowanceInsurableEarnings: Decimal;
        TotalDeductions: Decimal;
        GraduatedDeductionAmount: Decimal;
        TransportAllowanceAmount: Decimal;
        ComputedGrossPay: Decimal;
        ExemptFromStaffPension: Boolean;
        DeductionsThatReduceTaxablePay: Decimal;
        OnePercentOfGross: Decimal;
        DeductionsThatReduceGross: Decimal;
        EarningsThatReduceGross: Decimal;
        EarningCode: Code[20];
        WorkingAmount: Decimal;
        InsurableEarnings: Decimal;
        PayeDeduction: Decimal;
        AllActiveEmployeesCount: Integer;
        ProcessedEmployeesCount: Integer;
        NewPayslipReport: Report "New Payslip";
        PayrollStatisticReport: Report "Detailed Payroll Statistics";//"Payroll-Statistics";
        LastEmployeeNo: Code[50];
        LastCurrencyCode: Code[50];
        LastPayrollCountry: Code[50];
        SelectedEmployeeNo: Code[50];
        BasicSalaryAmount: Decimal;
        ProcessedEmpCountriesFilter: Text[250];
        TempEmpMovement: Record "Staff Movement Temp";
        TempEmpMovementInit: Record "Staff Movement Temp";
        EmpMovement: Record "Internal Employement History";//Staff Movement
        PeriodDeptSections: Record "Period Department Sections";
        PeriodDeptSectionsInit: Record "Period Department Sections";
        Sections: Record "Sub Responsibility Center";
        Depts: Record "Responsibility Center";
        localCurrencyCode: Code[50];
        GenLedgerSetup: Record "General Ledger Setup";
        EmpPeriodBankDetails: Record "Employee Period Bank Details";
        EmpPeriodBankDetailsInit: Record "Employee Period Bank Details";
        PeriodPrevailingMovements: Record "Period Prevailing Movement";
        PeriodPrevailingMovementInit: Record "Period Prevailing Movement";
        CausesOfInactivity: Record "Period Causes of Inactivity";
        CausesOfInactivityInit: Record "Period Causes of Inactivity";
        ExtraPayrollBanks: Record "Extra Payroll Banks";
        ExtraPayrollBanksInit: Record "Extra Payroll Banks";
        TransportAllowanceBanks: Record "Transport Allowance Banks";
        TransportAllowanceBanksInit: Record "Transport Allowance Banks";
        Countries: Record "Country/Region";
        NoRepeatDeductions: Dictionary of [Text, Boolean];
        gvIsTerminalDuesProcessing: Boolean;
        gvRetirementBenefitsProcessing: Boolean;



    procedure SetReportFilter(var selectedPeriod: Date; Var EmpNo: Code[50])
    begin
        DateSpecified := selectedPeriod;
        SelectedEmployeeNo := EmpNo;

    end;


    procedure GetTaxBracket(var TaxableAmount: Decimal)
    var
        TaxTable: Record "Brackets Lines";
        TotalTax: Decimal;
        Tax: Decimal;
        EndTax: Boolean;
    begin
        AmountRemaining := TaxableAmount;
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
        TotalTax := PayrollRounding(TotalTax);
        IncomeTax := -TotalTax;
        if not (Employee."Pays tax" or Employee.Disabled) then
            IncomeTax := 0;
    end;


    procedure GetPayPeriod()
    begin
        PayPeriod.SetRange(PayPeriod."Close Pay", false);
        if PayPeriod.Find('-') then begin
            PayPeriodtext := PayPeriod.Name;
            BeginDate := PayPeriod."Starting Date";
        end;
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


    procedure fnBasicPayProrated(strEmpCode: Code[20]; Month: Integer; Year: Integer; BasicSalary: Decimal; DaysWorked: Integer; DaysInMonth: Integer) ProratedAmt: Decimal
    begin
        ProratedAmt := Round((DaysWorked / DaysInMonth) * BasicSalary, 0.05, '<');
    end;


    procedure fnDaysInMonth(dtDate: Date) DaysInMonth: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin
        TodayDate := dtDate;

        Day := Date2DMY(TodayDate, 1);
        Expr1 := Format(-Day) + 'D+1D';
        FirstDay := CalcDate(Expr1, TodayDate);
        LastDate := CalcDate('1M-1D', FirstDay);

        SysDate.Reset;
        SysDate.SetRange(SysDate."Period Type", SysDate."Period Type"::Date);
        SysDate.SetRange(SysDate."Period Start", FirstDay, LastDate);
        // SysDate.SETFILTER(SysDate."Period No.",'1..5');
        if SysDate.Find('-') then
            DaysInMonth := SysDate.Count;
    end;


    procedure fnDaysWorked(dtDate: Date; IsTermination: Boolean) DaysWorked: Integer
    var
        Day: Integer;
        SysDate: Record Date;
        Expr1: Text[30];
        FirstDay: Date;
        LastDate: Date;
        TodayDate: Date;
    begin
        TodayDate := dtDate;

        Day := Date2DMY(TodayDate, 1);
        Expr1 := Format(-Day) + 'D+1D';
        FirstDay := CalcDate(Expr1, TodayDate);
        LastDate := CalcDate('1M-1D', FirstDay);

        SysDate.Reset;
        SysDate.SetRange(SysDate."Period Type", SysDate."Period Type"::Date);
        if not IsTermination then
            SysDate.SetRange(SysDate."Period Start", dtDate, LastDate)
        else
            SysDate.SetRange(SysDate."Period Start", FirstDay, dtDate);
        // SysDate.SETFILTER(SysDate."Period No.",'1..5');
        if SysDate.Find('-') then
            DaysWorked := SysDate.Count;
    end;

    local procedure FnGrossUpContractualAmount(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date) GrossedUpContractualAmountRwf: Decimal
    var
        NetAmountInRwf: Decimal;
        BasicPercent: Decimal;
        HousePercent: Decimal;
        TransportPercent: decimal;
        SocialSecurityPercent: decimal;
        MedicalPercent: decimal;
        MMIPercent: decimal;
        MaternityPercent: decimal;
        EarningsRec: Record Earnings;
        BasicPayAmtBif: Decimal;
        InssPercent: Decimal;
        DeductionsRec: Record Deductions;
        NetAmountInBif: Decimal;
        Assignmatrix: Record "Assignment Matrix";
        GrossAmountInCountryCurrency: Decimal;
        ExemptFromPension: Boolean;
        NetAmountInCcy: Decimal;
        InsuranceReliefPercent: Decimal;
        PersonalReliefAmt: Decimal;
        NhifDedCode: Code[100];
        HousingLevyPercent: Decimal;
        ShifPercent: Decimal;
        Nssf1Code: Code[100];
        Nssf2Code: Code[100];
        PensionLimit: Decimal;
        ConstantAmount: Decimal;
        ConsolidatedReliefPercent: Decimal;
        AidsPercent: Decimal;
        NssaLimit: Decimal;
        CountryCurrency: Code[100];
        SocialSecurityShouldLessTransport: Boolean;
        ExchangeRateDateToUse: Date;
        TerminalDuesHeader: Record "Terminal Dues Header";
    begin
        CountryCurrency := '';
        Countries.Reset();
        Countries.SetRange(Code, EmpMovementTable."Payroll Country");
        if Countries.FindFirst() then
            CountryCurrency := Countries."Country Currency";
        if CountryCurrency = '' then
            Error('Update the country currency for %1!', EmpMovementTable."Payroll Country");

        ExchangeRateDateToUse := PayDate;
        if EmpTable."Under Terminal Dues Processing" then begin
            TerminalDuesHeader.Reset();
            TerminalDuesHeader.SetRange("WB No.", EmpTable."No.");
            if TerminalDuesHeader.FindFirst() then
                ExchangeRateDateToUse := TerminalDuesHeader."Date Processed";
        end;

        if EmpMovementTable."Payroll Country" = 'BURUNDI' then begin
            BasicPayAmtBif := 0;
            InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            NetAmountInBif := 0;
            BasicPayAmtBif := 0;

            EarningsRec.Reset();
            EarningsRec.SetRange("Exclude from Payroll", false);
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange(Block, false);
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                until EarningsRec.Next() = 0;
            end;
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Pension Scheme", true);
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then //INSS
                        InssPercent := DeductionsRec.Percentage / 100;
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, /*'BIF'*/CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                //message('Burundi Net amount bif %1 from USD %2', NetAmountInBif, EmpMovementTable."Contractual Amount Value");
                BasicPayAmtBif := FnGrossUpTransactionBurundi(NetAmountInBif, 0, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                BasicPayAmtBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, /*'BIF'*/CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossBasicTransactionBurundi(BasicPayAmtBif, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent);
            end;
            //Insert the basic pay to earnings
            //MESSAGE('BasicPayAmtBif %1', BasicPayAmtBif);
            /*{EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Basic Salary Code", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Basic Salary Code" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := BasicPayAmtBif;
                Assignmatrix."Earning Currency" := 'BIF';
                Assignmatrix."Country Currency" := 'BIF';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                //Message('Inserted');
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;}*/
            GrossedUpContractualAmountRwf := BasicPayAmtBif;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceBurundi(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, BasicPayAmtBif, InssPercent, HousePercent, TransportPercent, ExchangeRateDateToUse);

        end else if EmpMovementTable."Payroll Country" = 'GHANA' then begin
            GrossAmountInCountryCurrency := 0;
            InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            NetAmountInBif := 0;
            ExemptFromPension := false;
            //Exempt RWANDA Staff working in Ghana from Pension deduction
            if (EmpTable."Payroll Country" = 'GHANA') and (EmpTable."Country/Region Code" = 'RWANDA') then
                ExemptFromPension := true;

            EarningsRec.Reset();
            EarningsRec.SetRange("Exclude from Payroll", false);
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange(Block, false);
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;

                until EarningsRec.Next() = 0;
                if HousePercent = 0 then
                    HousePercent := 10 / 100;
                if TransportPercent = 0 then
                    TransportPercent := 10 / 100;
                if BasicPercent = 0 then
                    BasicPercent := 80 / 100;
            end;
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Pension Scheme", true);
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then //INSS
                        InssPercent := DeductionsRec.Percentage / 100;
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'GHS', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionGhana(EmpTable, NetAmountInBif, BasicPercent, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, ExemptFromPension, PayDate);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'GHS', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossGrossTransactionGhana(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, BasicPercent, PayDate, ExemptFromPension);
            end;
            //Message('NetAmountInBif %1 | GrossAmountInCountryCurrency %2', NetAmountInBif, GrossAmountInCountryCurrency);
            //Insert the basic pay, housing, and transport to earnings
            /*{EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Basic Salary Code", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Basic Salary Code" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := BasicPercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'GHS';
                Assignmatrix."Country Currency" := 'GHS';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                //Message('Inserted');
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;
            EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Housing Allowance", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Housing Allowance" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := HousePercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'GHS';
                Assignmatrix."Country Currency" := 'GHS';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                //Message('Inserted');
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;
            EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Transport Allowance", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Transport Allowance" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := TransportPercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'GHS';
                Assignmatrix."Country Currency" := 'GHS';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                //Message('Inserted');
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;}*/
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceGhana(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, InssPercent, HousePercent, TransportPercent, BasicPercent, ExemptFromPension, ExchangeRateDateToUse);
        end else if EmpMovementTable."Payroll Country" = 'KENYA' then begin
            GrossAmountInCountryCurrency := 0;
            NetAmountInCcy := 0;
            InsuranceReliefPercent := 0;
            PersonalReliefAmt := 0;
            NhifDedCode := '';
            Nssf1Code := '';
            Nssf2Code := '';
            PensionLimit := 0;
            ShifPercent := 0;
            HousingLevyPercent := 0;

            EarningsRec.Reset();
            EarningsRec.SetRange("Exclude from Payroll", false);
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange(Block, false);
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Insurance Relief" then
                        InsuranceReliefPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Earning Type" = EarningsRec."Earning Type"::"Tax Relief" then
                        PersonalReliefAmt := EarningsRec."Flat Amount";
                until EarningsRec.Next() = 0;
                if InsuranceReliefPercent = 0 then
                    InsuranceReliefPercent := 15 / 100;
            end;
            //eg Housing levy
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange(Block, false);
            //DeductionsRec.SetRange("Pension Scheme", true);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if (DeductionsRec."NHIF Deduction") and (not DeductionsRec.Block) then
                        ShifPercent := DeductionsRec.Percentage / 100;//NhifDedCode := DeductionsRec.Code;
                    if DeductionsRec."PAYE Code" then
                        PensionLimit := DeductionsRec."Pension Limit Amount";
                    if DeductionsRec."Housing Levy" then
                        HousingLevyPercent := DeductionsRec.Percentage / 100;
                    if DeductionsRec."NSSF Tier" = DeductionsRec."NSSF Tier"::"Tier 1" then
                        Nssf1Code := DeductionsRec.Code;
                    if DeductionsRec."NSSF Tier" = DeductionsRec."NSSF Tier"::"Tier 2" then
                        Nssf2Code := DeductionsRec.Code;
                until DeductionsRec.Next() = 0;
            end;//

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInCcy := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'KES', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionKenya(EmpTable, NetAmountInCcy, PersonalReliefAmt, InsuranceReliefPercent, NhifDedCode, HousingLevyPercent, ShifPercent, Nssf1Code, Nssf2Code, PensionLimit, EmpMovementTable."Payroll Country", PayDate);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'KES', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInCcy := FnGetNetFromGrossTransactionKenya(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", PersonalReliefAmt, InsuranceReliefPercent, NhifDedCode, HousingLevyPercent, ShifPercent, Nssf1Code, Nssf2Code, PensionLimit, PayDate);
            end;
            //Insert the basic pay
            /*{EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Basic Salary Code", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Basic Salary Code" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := 1 * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'KES';
                Assignmatrix."Country Currency" := 'KES';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;}*/
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceKenya(EmpTable, EmpMovementTable, PayDate, NetAmountInCcy, GrossAmountInCountryCurrency, PersonalReliefAmt, InsuranceReliefPercent, NhifDedCode, HousingLevyPercent, ShifPercent, Nssf1Code, Nssf2Code, PensionLimit, ExchangeRateDateToUse);

        end else if EmpMovementTable."Payroll Country" = 'UGANDA' then begin
            GrossAmountInCountryCurrency := 0;
            InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            NetAmountInBif := 0;
            BasicPercent := 0;

            EarningsRec.Reset();
            EarningsRec.SetRange("Exclude from Payroll", false);
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange(Block, false);
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;

                until EarningsRec.Next() = 0;
                if HousePercent = 0 then
                    HousePercent := 10 / 100;
                if TransportPercent = 0 then
                    TransportPercent := 10 / 100;
                if BasicPercent = 0 then
                    BasicPercent := 80 / 100;
            end;
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Pension Scheme", true);
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then //INSS
                        InssPercent := DeductionsRec.Percentage / 100;
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'UGX', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionUganda(EmpTable, NetAmountInBif, BasicPercent, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, PayDate);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'UGX', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossGrossTransactionUganda(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, BasicPercent, PayDate);
            end;
            //Insert the basic pay, housing, and transport to earnings
            /*{EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Basic Salary Code", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Basic Salary Code" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := BasicPercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'UGX';
                Assignmatrix."Country Currency" := 'UGX';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                //Message('Inserted');
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;
            EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Housing Allowance", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Housing Allowance" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := HousePercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'UGX';
                Assignmatrix."Country Currency" := 'UGX';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                //Message('Inserted');
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;
            EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Transport Allowance", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Transport Allowance" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := TransportPercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'UGX';
                Assignmatrix."Country Currency" := 'UGX';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                //Message('Inserted');
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;}*/
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceUganda(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, InssPercent, HousePercent, TransportPercent, BasicPercent, ExchangeRateDateToUse);

        end else if EmpMovementTable."Payroll Country" = 'TANZANIA' then begin
            GrossAmountInCountryCurrency := 0;
            InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            NetAmountInBif := 0;
            BasicPercent := 0;

            EarningsRec.Reset();
            EarningsRec.SetRange("Exclude from Payroll", false);
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange(Block, false);
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;

                until EarningsRec.Next() = 0;
                if HousePercent = 0 then
                    HousePercent := 10 / 100;
                if TransportPercent = 0 then
                    TransportPercent := 10 / 100;
                if BasicPercent = 0 then
                    BasicPercent := 80 / 100;
            end;
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Pension Scheme", true);
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then //INSS
                        InssPercent := DeductionsRec.Percentage / 100;
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'TZS', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionTanzania(EmpTable, NetAmountInBif, BasicPercent, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, PayDate);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'TZS', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossGrossTransactionTanzania(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, BasicPercent, PayDate);
            end;
            //Insert the basic pay, housing, and transport to earnings
            /*{EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Basic Salary Code", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Basic Salary Code" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := BasicPercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'TZS';
                Assignmatrix."Country Currency" := 'TZS';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;
            EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Housing Allowance", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Housing Allowance" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := HousePercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'TZS';
                Assignmatrix."Country Currency" := 'TZS';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;
            EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Transport Allowance", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Transport Allowance" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := TransportPercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'TZS';
                Assignmatrix."Country Currency" := 'TZS';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;}*/
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceTanzania(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, InssPercent, HousePercent, TransportPercent, BasicPercent, ExchangeRateDateToUse);
        end else if EmpMovementTable."Payroll Country" = 'ZIMBABWE' then begin
            GrossAmountInCountryCurrency := 0;
            InssPercent := 0;
            AidsPercent := 0;
            NetAmountInBif := 0;
            BasicPercent := 0;
            NssaLimit := 0;

            EarningsRec.Reset();
            EarningsRec.SetRange("Exclude from Payroll", false);
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange(Block, false);
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Gross Pay" then
                        BasicPercent := EarningsRec.Percentage / 100;

                until EarningsRec.Next() = 0;
                if BasicPercent = 0 then
                    BasicPercent := 100 / 100;
            end;
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then //NSSA
                        begin
                        InssPercent := DeductionsRec.Percentage / 100;
                        NssaLimit := DeductionsRec."Maximum Amount";
                    end;
                    if DeductionsRec.Code = 'D02' then //AIDS Levy
                        AidsPercent := DeductionsRec.Percentage / 100;
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'USD', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionZimbabwe(EmpTable, NetAmountInBif, BasicPercent, EmpMovementTable."Payroll Country", InssPercent, AidsPercent, NssaLimit, PayDate);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'USD', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossGrossTransactionZimbabwe(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, AidsPercent, NssaLimit, BasicPercent);
            end;
            //Insert the gross pay
            /*{EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Gross Pay", true);
            if EarningsRec.FindFirst() then begin
                Assignmatrix.Init;
                Assignmatrix."Employee No" := EmpMovementTable."Emp No.";
                Assignmatrix."Basic Salary Code" := true;
                Assignmatrix.Type := Assignmatrix.Type::Payment;
                Assignmatrix.Code := EarningsRec.Code;
                Assignmatrix.Amount := BasicPercent * GrossAmountInCountryCurrency;
                Assignmatrix."Earning Currency" := 'USD';
                Assignmatrix."Country Currency" := 'USD';
                Assignmatrix.Validate(Code);
                Assignmatrix."Payroll Period" := Month;
                Assignmatrix.Description := EarningsRec.Description;
                Assignmatrix.Country := EmpMovementTable."Payroll Country";
                //Message('Inserted');
                if not Assignmatrix.Insert then Assignmatrix.modify;
            end;}*/
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceZimbabwe(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, InssPercent, AidsPercent, NssaLimit, ExchangeRateDateToUse);

        end else if EmpMovementTable."Payroll Country" = 'BENIN' then begin
            GrossAmountInCountryCurrency := 0;
            InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            NetAmountInBif := 0;
            BasicPercent := 0;

            /*EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;

                until EarningsRec.Next() = 0;
                if HousePercent = 0 then
                    HousePercent := 10 / 100;
                if TransportPercent = 0 then
                    TransportPercent := 10 / 100;
                if BasicPercent = 0 then
                    BasicPercent := 80 / 100;
            end;*/
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Pension Scheme", true);
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then //CNSS
                        InssPercent := DeductionsRec.Percentage / 100;
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionBenin(EmpTable, NetAmountInBif, BasicPercent, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, PayDate, CountryCurrency);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossGrossTransactionBenin(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, BasicPercent, PayDate, CountryCurrency);
            end;
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceBenin(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, InssPercent, HousePercent, TransportPercent, BasicPercent, CountryCurrency, ExchangeRateDateToUse);
        end else if EmpMovementTable."Payroll Country" = 'ZAMBIA' then begin
            GrossAmountInCountryCurrency := 0;
            InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            NetAmountInBif := 0;
            BasicPercent := 1;
            PensionLimit := 0;

            /*EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;

                until EarningsRec.Next() = 0;
                if HousePercent = 0 then
                    HousePercent := 10 / 100;
                if TransportPercent = 0 then
                    TransportPercent := 10 / 100;
                if BasicPercent = 0 then
                    BasicPercent := 80 / 100;
            end;*/
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Pension Scheme", true);
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then begin//INSS
                        InssPercent := DeductionsRec.Percentage / 100;
                        PensionLimit := DeductionsRec."Maximum Amount";
                    end
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionZambia(EmpTable, NetAmountInBif, BasicPercent, EmpMovementTable."Payroll Country", InssPercent, PensionLimit, TransportPercent, PayDate, CountryCurrency);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossGrossTransactionZambia(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, PensionLimit, TransportPercent, BasicPercent, PayDate, CountryCurrency);
            end;
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceZambia(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, InssPercent, PensionLimit, TransportPercent, BasicPercent, CountryCurrency, ExchangeRateDateToUse);

        end else if EmpMovementTable."Payroll Country" = 'NIGERIA' then begin
            GrossAmountInCountryCurrency := 0;
            InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            NetAmountInBif := 0;
            BasicPercent := 1;
            ConstantAmount := 0;
            ConsolidatedReliefPercent := 0;
            ExemptFromPension := false;
            //Exempt RWANDA Staff working in Nigeria from Pension deduction
            if (EmpTable."Payroll Country" = 'NIGERIA') and (EmpTable."Country/Region Code" = 'RWANDA') then
                ExemptFromPension := true;

            EarningsRec.Reset();
            EarningsRec.SetRange("Exclude from Payroll", false);
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange(Block, false);
            EarningsRec.SetRange("Calculation Method", EarningsRec."Calculation Method"::"% of Actual Gross plus Constant Amount");
            if EarningsRec.FindFirst() then begin
                repeat
                    /*if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;*/
                    //if (EarningsRec."Calculation Method" = EarningsRec."Calculation Method"::"% of Actual Gross plus Constant Amount") then begin
                    ConsolidatedReliefPercent := EarningsRec.Percentage / 100;
                    ConstantAmount := EarningsRec."Constant Amount";

                until EarningsRec.Next() = 0;
                /*if HousePercent = 0 then
                    HousePercent := 10 / 100;
                if TransportPercent = 0 then
                    TransportPercent := 10 / 100;
                if BasicPercent = 0 then
                    BasicPercent := 80 / 100;*/
            end;
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Pension Scheme", true);
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then//Pension Fund
                        InssPercent := DeductionsRec.Percentage / 100;
                /*if (DeductionsRec."Calculation Method" = DeductionsRec."Calculation Method"::"% of Actual Gross plus Constant Amount") then begin
                    ConsolidatedReliefPercent := DeductionsRec.Percentage / 100;
                    ConstantAmount := DeductionsRec."Constant Amount";
                end;*/
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionNigeria(EmpTable, NetAmountInBif, ExemptFromPension, EmpMovementTable."Payroll Country", InssPercent, ConstantAmount, ConsolidatedReliefPercent, PayDate, CountryCurrency);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossGrossTransactionNigeria(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, ConstantAmount, ConsolidatedReliefPercent, ExemptFromPension, PayDate, CountryCurrency);
            end;
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceNigeria(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, InssPercent, ConstantAmount, ConsolidatedReliefPercent, ExemptFromPension, CountryCurrency, ExchangeRateDateToUse);
        end else if EmpMovementTable."Payroll Country" = 'CONSULTANT' then begin
            GrossAmountInCountryCurrency := 0;
            InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            NetAmountInBif := 0;
            BasicPercent := 1;
            ConstantAmount := 0;
            ConsolidatedReliefPercent := 0;
            ExemptFromPension := false;

            /*EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange("Calculation Method", EarningsRec."Calculation Method"::"% of Actual Gross plus Constant Amount");
            if EarningsRec.FindFirst() then begin
                repeat
                    //if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;//
                    //if (EarningsRec."Calculation Method" = EarningsRec."Calculation Method"::"% of Actual Gross plus Constant Amount") then begin
                    ConsolidatedReliefPercent := EarningsRec.Percentage / 100;
                    ConstantAmount := EarningsRec."Constant Amount";

                until EarningsRec.Next() = 0;//
                //if HousePercent = 0 then
                    HousePercent := 10 / 100;
                if TransportPercent = 0 then
                    TransportPercent := 10 / 100;
                if BasicPercent = 0 then
                    BasicPercent := 80 / 100;//
            end;*/
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Is Statutory", true);
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    //if DeductionsRec."Pension Scheme" then//Pension Fund
                    InssPercent := DeductionsRec.Percentage / 100;
                /*if (DeductionsRec."Calculation Method" = DeductionsRec."Calculation Method"::"% of Actual Gross plus Constant Amount") then begin
                    ConsolidatedReliefPercent := DeductionsRec.Percentage / 100;
                    ConstantAmount := DeductionsRec."Constant Amount";
                end;*/
                until DeductionsRec.Next() = 0;
            end;

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := FnGrossUpTransactionConsultant(EmpTable, NetAmountInBif, ExemptFromPension, EmpMovementTable."Payroll Country", InssPercent, ConstantAmount, ConsolidatedReliefPercent, PayDate, CountryCurrency);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := FnGetNetFromGrossGrossTransactionConsultant(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, ConstantAmount, ConsolidatedReliefPercent, ExemptFromPension, PayDate, CountryCurrency);
            end;
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceConsultant(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, InssPercent, ConstantAmount, ConsolidatedReliefPercent, ExemptFromPension, CountryCurrency, ExchangeRateDateToUse);

        end else if EmpMovementTable."Payroll Country" IN ['BRAZA', 'DUBAI', 'GABON', 'INDIA', 'QATAR', 'UK', 'CAMEROON', 'S.AFRICA'] then begin
            GrossAmountInCountryCurrency := 0;
            NetAmountInBif := 0;
            /*InssPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            BasicPercent := 0;

            EarningsRec.Reset();
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;

                until EarningsRec.Next() = 0;
                if HousePercent = 0 then
                    HousePercent := 10 / 100;
                if TransportPercent = 0 then
                    TransportPercent := 10 / 100;
                if BasicPercent = 0 then
                    BasicPercent := 80 / 100;
            end;
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange("Pension Scheme", true);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec."Pension Scheme" then //INSS
                        InssPercent := DeductionsRec.Percentage / 100;
                until DeductionsRec.Next() = 0;
            end;*/

            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInBif := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossAmountInCountryCurrency := NetAmountInBif; //FnGrossUpTransactionUganda(EmpTable, NetAmountInBif, BasicPercent, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, PayDate);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossAmountInCountryCurrency := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, CountryCurrency, EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInBif := GrossAmountInCountryCurrency; //FnGetNetFromGrossGrossTransactionUganda(EmpTable, GrossAmountInCountryCurrency, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, BasicPercent, PayDate);
            end;
            GrossedUpContractualAmountRwf := GrossAmountInCountryCurrency;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceMultipleCountries(EmpTable, EmpMovementTable, PayDate, NetAmountInBif, GrossAmountInCountryCurrency, CountryCurrency);

        end else if EmpMovementTable."Payroll Country" in ['RWANDA', 'EXPATRIATE', 'CABIN'] then begin
            BasicPercent := 0;
            HousePercent := 0;
            TransportPercent := 0;
            SocialSecurityPercent := 0;
            MedicalPercent := 0;
            MMIPercent := 0;
            MaternityPercent := 0;

            EarningsRec.Reset();
            EarningsRec.SetRange("Exclude from Payroll", false);
            EarningsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            EarningsRec.SetRange(Block, false);
            if EarningsRec.FindFirst() then begin
                repeat
                    if EarningsRec."Basic Salary Code" then
                        BasicPercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Housing Allowance" then
                        HousePercent := EarningsRec.Percentage / 100;
                    if EarningsRec."Transport Allowance" then
                        TransportPercent := EarningsRec.Percentage / 100;
                until EarningsRec.Next() = 0;
            end;
            if EmpTable."No Transport Allowance" then begin
                HousePercent := HousePercent + TransportPercent; //EmpTable.applica;
                TransportPercent := 0;
            end;

            SocialSecurityShouldLessTransport := false;
            DeductionsRec.Reset();
            DeductionsRec.SetRange(Country, EmpMovementTable."Payroll Country");
            DeductionsRec.SetRange(Block, false);
            if DeductionsRec.FindFirst() then begin
                repeat
                    if DeductionsRec.Code = 'D02' then begin
                        SocialSecurityPercent := DeductionsRec.Percentage / 100;
                        SocialSecurityShouldLessTransport := DeductionsRec."Less Transport Allowance";
                    end;
                    if (DeductionsRec."Medical Insurance") and (DeductionsRec."Medical Insurance Category" = DeductionsRec."Medical Insurance Category"::Normal) then
                        MedicalPercent := DeductionsRec.Percentage / 100;
                    if (DeductionsRec."Medical Insurance") and (DeductionsRec."Medical Insurance Category" = DeductionsRec."Medical Insurance Category"::MMI) then
                        MMIPercent := DeductionsRec.Percentage / 100;
                    if DeductionsRec.Code = 'D04' then
                        MaternityPercent := DeductionsRec.Percentage / 100;
                until DeductionsRec.Next() = 0;
            end;
            if EmpTable."Medical Insurance" = EmpTable."Medical Insurance"::MMI then
                MedicalPercent := MMIPercent;


            if (EmpMovementTable."Contractual Amount Type" = EmpMovementTable."Contractual Amount Type"::"Net Pay") then begin
                NetAmountInRwf := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'RWF', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                GrossedUpContractualAmountRwf := FnGrossUpTransactionLocalExpat(NetAmountInRwf, 0, EmpMovementTable."Payroll Country", BasicPercent, HousePercent, TransportPercent, SocialSecurityPercent, MedicalPercent, MMIPercent, MaternityPercent, SocialSecurityShouldLessTransport);
            end else //if the contractual amount is in gross/basic so we just want to gross up the net allowances
                begin
                GrossedUpContractualAmountRwf := ABS(GetInDesiredCurrency(EmpMovementTable."Contractual Amount Currency"/*'USD'*/, 'RWF', EmpMovementTable."Contractual Amount Value", ExchangeRateDateToUse, EmpTable));
                NetAmountInRwf := FnGetNetFromGrossBasicTransactionLocalExpat(GrossedUpContractualAmountRwf, EmpMovementTable."Payroll Country", BasicPercent, HousePercent, TransportPercent, SocialSecurityPercent, MedicalPercent, MMIPercent, MaternityPercent, SocialSecurityShouldLessTransport);
            end;

            //Gross up any net allowances
            if EmpMovementTable.Status = EmpMovementTable.Status::Current then
                FnGrossUpNetAllowanceLocalExpat(EmpTable, EmpMovementTable, PayDate, NetAmountInRwf, GrossedUpContractualAmountRwf, BasicPercent, HousePercent, TransportPercent, SocialSecurityPercent, MedicalPercent, MMIPercent, MaternityPercent, SocialSecurityShouldLessTransport, ExchangeRateDateToUse);
        end;
    end;

    //== LOCAL/EXPAT
    local procedure FnGrossUpNetAllowanceLocalExpat(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountRwf: Decimal; GrossedUpContractualAmountRwf: Decimal; BasicPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; SocialSecurityPercent: Decimal; MedicalPercent: Decimal; MMIPercent: Decimal; MaternityPercent: Decimal; SocialSecurityShouldLessTransportAllowanceA: Boolean; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInRwf: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountRwf: Decimal;
        EarningCurrency: Code[20];
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInRwf := ABS(GetInDesiredCurrency(EarningCurrency, 'RWF', AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                //GrossedUpAmountRwf := FnXXXXGrossUpTransactionNetLocalExpat((NetAmountInRwf + NetContractualAmountRwf), GrossedUpContractualAmountRwf, EmpMovementTable."Payroll Country", BasicPercent, HousePercent, TransportPercent) - GrossedUpContractualAmountRwf;
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInRwf;
                    GrossedUpAmountRwf := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInRwf, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountRwf := FnGrossUpTransactionNetLocalExpat((NetAmountInRwf + NetContractualAmountRwf), NetAmountInRwf, GrossedUpContractualAmountRwf, EmpMovementTable."Payroll Country", BasicPercent, HousePercent, TransportPercent, AssMatrix.Taxable, AssMatrix."Exclude from Calculations", SocialSecurityPercent, MedicalPercent, MMIPercent, MaternityPercent, SocialSecurityShouldLessTransportAllowanceA);
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency('RWF', EarningCurrency, GrossedUpAmountRwf, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;

    local procedure FnGrossUpTransactionLocalExpat(OriginalNetAmountRwf: Decimal; GrossedUpContractualAmountRwf: Decimal; PayCountry: Code[100]; BasicPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; SocialSecurityPercent: Decimal; MedicalPercent: Decimal; MMIPercent: Decimal; MaternityPercent: Decimal; SocialSecurityShouldLessTransportAllowance: Boolean) GrossedUpAmountRwf: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetRwf: Decimal;
        Variance: Decimal;
        ContractualAmountRwf: Decimal;
        TaxableAmountVal: Decimal;
    begin
        GrossedUpAmountRwf := OriginalNetAmountRwf;
        Variance := NewNetRwf - OriginalNetAmountRwf;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountRwf += Increment;

            ContractualAmountRwf := GrossedUpAmountRwf;
            if GrossedUpContractualAmountRwf <> 0 then
                ContractualAmountRwf := GrossedUpContractualAmountRwf;
            BasicAllowance := BasicPercent * ContractualAmountRwf;//GrossedUpAmountRwf;
            HouseAllowance := HousePercent * ContractualAmountRwf;//GrossedUpAmountRwf;
            TransportAllowance := TransportPercent * ContractualAmountRwf;//GrossedUpAmountRwf;
            TaxableAmountVal := BasicAllowance + HouseAllowance + TransportAllowance;

            //PayeDed := (((GrossedUpAmountRwf - 200000) * 0.3) + 24000);
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, PayCountry);
            SocialSecurity := (GrossedUpAmountRwf - TransportAllowance) * SocialSecurityPercent;
            if not SocialSecurityShouldLessTransportAllowance then
                SocialSecurity := GrossedUpAmountRwf * SocialSecurityPercent;
            MaternityDeduction := (GrossedUpAmountRwf - TransportAllowance) * MaternityPercent;
            MedicalDeduction := 0;
            if PayCountry <> 'CABIN' then
                MedicalDeduction := BasicAllowance * MedicalPercent;
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                MaternityDeduction := 0;
                MedicalDeduction := 0;
                if gvRetirementBenefitsProcessing then
                    SocialSecurity := 0;
            end;
            NewNetRwf := GrossedUpAmountRwf - (PayeDed + SocialSecurity + MaternityDeduction + MedicalDeduction);

            Variance := NewNetRwf - OriginalNetAmountRwf;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN
                Variance := 0;
        END;
    end;

    local procedure FnGrossUpTransactionNetLocalExpat(OriginalNetAmountRwf: Decimal; AllowanceNetAmountRwf: Decimal; ContractualAmountRwf: Decimal; PayCountry: Code[100]; BasicPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; IsTaxable: Boolean; ExcludeFromCalculations: Boolean; SocialSecurityPercent: Decimal; MedicalPercent: Decimal; MMIPercent: Decimal; MaternityPercent: Decimal; SocialSecurityShouldLessTransportAllowance: Boolean) GrossedUpAmountRwf: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetRwf: Decimal;
        Variance: Decimal;
        TotalGross: Decimal;
        TaxableAmountVal: Decimal;
        ComputedGross: Decimal;

    begin
        GrossedUpAmountRwf := AllowanceNetAmountRwf;//OriginalNetAmountRwf;
        Variance := -1;//NewNetRwf - OriginalNetAmountRwf;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountRwf += Increment;

            //ContractualAmountRwf := GrossedUpAmountRwf;
            /*if GrossedUpContractualAmountRwf <> 0 then
                ContractualAmountRwf := GrossedUpContractualAmountRwf;*/
            BasicAllowance := BasicPercent * ContractualAmountRwf;//GrossedUpAmountRwf;
            HouseAllowance := HousePercent * ContractualAmountRwf;//GrossedUpAmountRwf;
            TransportAllowance := TransportPercent * ContractualAmountRwf;//GrossedUpAmountRwf;
            TotalGross := BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountRwf;
            ComputedGross := TotalGross;

            TaxableAmountVal := TotalGross;
            if not IsTaxable then
                TaxableAmountVal := TotalGross - GrossedUpAmountRwf;
            if ExcludeFromCalculations then
                ComputedGross := ComputedGross - GrossedUpAmountRwf;

            //PayeDed := (((TotalGross GrossedUpAmountRwf - 200000) * 0.3) + 24000);
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, PayCountry);
            SocialSecurity := (ComputedGross - TransportAllowance) * SocialSecurityPercent;
            if not SocialSecurityShouldLessTransportAllowance then
                SocialSecurity := ComputedGross * SocialSecurityPercent;
            MaternityDeduction := (ComputedGross - TransportAllowance) * MaternityPercent;
            MedicalDeduction := 0;
            if PayCountry <> 'CABIN' then
                MedicalDeduction := BasicAllowance * MedicalPercent;
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                MaternityDeduction := 0;
                MedicalDeduction := 0;
                if gvRetirementBenefitsProcessing then
                    SocialSecurity := 0;
            end;
            NewNetRwf := TotalGross - (PayeDed + SocialSecurity + MaternityDeduction + MedicalDeduction);

            Variance := NewNetRwf - OriginalNetAmountRwf;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN
                Variance := 0;
        END;
    end;

    local procedure FnGetNetFromGrossBasicTransactionLocalExpat(GrossedUpContractualAmountRwf: Decimal; PayCountry: Code[100]; BasicPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; SocialSecurityPercent: Decimal; MedicalPercent: Decimal; MMIPercent: Decimal; MaternityPercent: Decimal; SocialSecurityShouldLessTransportAllowance: Boolean) NetAmountRwf: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetRwf: Decimal;
        Variance: Decimal;
        ContractualAmountRwf: Decimal;
        GrossedUpAmountRwf: Decimal;
    begin
        NetAmountRwf := 0;
        GrossedUpAmountRwf := GrossedUpContractualAmountRwf;
        ContractualAmountRwf := GrossedUpAmountRwf;
        if GrossedUpContractualAmountRwf <> 0 then
            ContractualAmountRwf := GrossedUpContractualAmountRwf;
        BasicAllowance := BasicPercent * ContractualAmountRwf;//GrossedUpAmountRwf;
        HouseAllowance := HousePercent * ContractualAmountRwf;//GrossedUpAmountRwf;
        TransportAllowance := TransportPercent * ContractualAmountRwf;//GrossedUpAmountRwf;

        //PayeDed := (((GrossedUpAmountRwf - 200000) * 0.3) + 24000);
        PayeDed := GetPaye.GetTaxBracket(GrossedUpAmountRwf, PayCountry);
        SocialSecurity := (GrossedUpAmountRwf - TransportAllowance) * SocialSecurityPercent;
        if not SocialSecurityShouldLessTransportAllowance then
            SocialSecurity := GrossedUpAmountRwf * SocialSecurityPercent;
        MaternityDeduction := (GrossedUpAmountRwf - TransportAllowance) * MaternityPercent;
        MedicalDeduction := 0;
        if PayCountry <> 'CABIN' then
            MedicalDeduction := BasicAllowance * MedicalPercent;
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * GrossedUpAmountRwf;
            MaternityDeduction := 0;
            MedicalDeduction := 0;
            if gvRetirementBenefitsProcessing then
                SocialSecurity := 0;
        end;
        NetAmountRwf := GrossedUpAmountRwf - (PayeDed + SocialSecurity + MaternityDeduction + MedicalDeduction);
    end;


    //== BURUNDI ==
    local procedure FnGrossUpTransactionBurundi(OriginalNetAmountBif: Decimal; BasicAmountBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;

    begin
        BasicAllowance := 0;//OriginalNetAmountBif / 2;//Start somewhere
        GrossedUpAmountBif := BasicAllowance;
        Variance := NewNetBif - OriginalNetAmountBif;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            BasicAllowance += Increment;
            GrossedUpAmountBif := BasicAllowance;

            FamilyAllowance := 150;
            HouseAllowance := HousePercent * BasicAllowance;
            TransportAllowance := TransportPercent * BasicAllowance;

            InssDed := InssPercent * BasicAllowance;
            if InssDed > 18000 then
                InssDed := 18000;
            PayeDed := (((((BasicAllowance + FamilyAllowance) - InssDed) - 300000) * 0.3) + 30000);
            NewNetBif := (BasicAllowance + HouseAllowance + FamilyAllowance + TransportAllowance) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN
                Variance := 0;
        END;
    end;

    local procedure FnGetNetFromGrossBasicTransactionBurundi(BasicAmountBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal) NetAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;

    begin
        BasicAllowance := BasicAmountBif;
        NetAmountBif := 0;

        FamilyAllowance := 150;
        HouseAllowance := HousePercent * BasicAllowance;
        TransportAllowance := TransportPercent * BasicAllowance;

        InssDed := InssPercent * BasicAllowance;
        if InssDed > 18000 then
            InssDed := 18000;
        PayeDed := (((((BasicAllowance + FamilyAllowance) - InssDed) - 300000) * 0.3) + 30000);
        NetAmountBif := (BasicAllowance + HouseAllowance + FamilyAllowance + TransportAllowance) - (PayeDed + InssDed);
    end;


    local procedure FnGrossUpNetAllowanceBurundi(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; BasicPayAmtBif: Decimal; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, 'BIF', AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetBurundi((NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, BasicPayAmtBif, AssMatrix.Taxable, AssMatrix."Exclude from Calculations");
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency('BIF', EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;

    local procedure FnGrossUpTransactionNetBurundi(OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPayAmt: Decimal; IsTaxable: Boolean; ExcludeFromCalculations: Boolean) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        AmtToAddToTaxable: Decimal;

    begin
        BasicAllowance := BasicPayAmt;
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;//NewNetBif - OriginalNetAmountBif;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            FamilyAllowance := 150;
            HouseAllowance := HousePercent * BasicAllowance;
            TransportAllowance := TransportPercent * BasicAllowance;

            InssDed := InssPercent * BasicAllowance;
            if InssDed > 18000 then
                InssDed := 18000;

            AmtToAddToTaxable := GrossedUpAmountBif;
            if not IsTaxable then
                AmtToAddToTaxable := 0;
            PayeDed := (((((BasicAllowance + FamilyAllowance + AmtToAddToTaxable) - InssDed) - 300000) * 0.3) + 30000);
            NewNetBif := (BasicAllowance + HouseAllowance + FamilyAllowance + TransportAllowance + GrossedUpAmountBif) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN
                Variance := 0;
        END;
    end;

    //== GHANA ===
    local procedure FnGrossUpTransactionGhana(EmpRecTable: Record Employee; OriginalNetAmountBif: Decimal; BasicPercent: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; ExemptEmpFromPension: Boolean; PayrollDate: Date) GrossedUpAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NewNetBif := 0;
        GrossedUpAmountGhs := OriginalNetAmountBif;
        Variance := -1;//NewNetBif - OriginalNetAmountBif;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountGhs += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountGhs;
            HouseAllowance := HousePercent * GrossedUpAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);

            InssDed := InssPercent * BasicAllowance;
            if ExemptEmpFromPension then
                InssDed := 0;
            TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            //PayeDed := (((((BasicAllowance + FamilyAllowance) - InssDed) - 300000) * 0.3) + 30000);
            //GetPaye.CalculateTaxableAmount(EmpRecTable."No.", PayrollDate, PayeDed, TaxableAmountVal, RetireCont, EmpRecTable."Payroll Country");
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
            end;
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance + HouseAllowance + TransportAllowance) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
                //Message('PayeDed %1 | GrossedUpAmountGhs %2', PayeDed, GrossedUpAmountGhs);
            end;
        END;
    end;

    local procedure FnGetNetFromGrossGrossTransactionGhana(EmpRecTable: Record Employee; GrossAmountInGhs: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; PayrollDate: Date; ExemptEmpFromPension: Boolean) NetAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NetAmountGhs := 0;
        RetireCont := 0;

        BasicAllowance := BasicPercent * GrossAmountInGhs;
        HouseAllowance := HousePercent * GrossAmountInGhs;
        TransportAllowance := TransportPercent * GrossAmountInGhs;
        TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);

        InssDed := InssPercent * BasicAllowance;
        if ExemptEmpFromPension then
            InssDed := 0;
        TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
        //PayeDed := (((((BasicAllowance) - InssDed) - 300000) * 0.3) + 30000);
        //GetPaye.CalculateTaxableAmount(EmpRecTable."No.", PayrollDate, PayeDed, TaxableAmountVal, RetireCont, EmpRecTable."Payroll Country");
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * TaxableAmountVal;
            if gvRetirementBenefitsProcessing then
                InssDed := 0;
        end;
        NetAmountGhs := (BasicAllowance + HouseAllowance + TransportAllowance) - (PayeDed + InssDed);
    end;

    local procedure FnGrossUpTransactionNetGhana(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; GrossedUpContractualAmountGhs: Decimal; BasicPercent: Decimal; ExemptEmpFromPension: Boolean; IsTaxable: Boolean; ExcludeFromCalculations: Boolean) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        //Variance := NewNetBif - OriginalNetAmountBif; //This cause a big issue - makes variance big so a bigger figure is added to net allowance pap
        Variance := -1; //Start off with a small margin
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := BasicPercent * GrossedUpContractualAmountGhs;
            HouseAllowance := HousePercent * GrossedUpContractualAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif);

            InssDed := InssPercent * BasicAllowance;
            if ExemptEmpFromPension then
                InssDed := 0;
            if not IsTaxable then
                TaxableAmountVal := TaxableAmountVal - GrossedUpAmountBif;
            TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            //PayeDed := (((((BasicAllowance + FamilyAllowance + GrossedUpAmountBif) - InssDed) - 300000) * 0.3) + 30000);
            //GetPaye.CalculateTaxableAmount(EmpRecTable."No.", PayrollDate, PayeDed, TaxableAmountVal, RetireCont, EmpRecTable."Payroll Country");
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                //Message('PayeDed %1 | GrossedUpContractualAmountGhs %2 | GrossedUpAmountBif %3 | OriginalNetAmountBif %4 | AllowanceNetBif %5 | Variance %6 | NewNetBif %7 | InssDed %8 | BasicAllowance %9 | HouseAllowance %10 | TransportAllowance %11', PayeDed, GrossedUpContractualAmountGhs, GrossedUpAmountBif, OriginalNetAmountBif, AllowanceNetBif, Variance, NewNetBif, InssDed, BasicAllowance, HouseAllowance, TransportAllowance);
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpNetAllowanceGhana(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; GrossedUpContractualGhs: Decimal; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; ExemptEmpFromPension: Boolean; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, 'GHS', AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetGhana(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, GrossedUpContractualGhs, BasicPercent, ExemptEmpFromPension, AssMatrix.Taxable, AssMatrix."Exclude from Calculations");
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency('GHS', EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                //Message('Net allw usd %1 | net allw ghs %2 | net cont ghs %3 | gross cont ghs %4 | Gross allw ghs %5 | Gross usd %6', AssMatrix."Net Amount", NetAmountInBif, NetContractualAmountBif, GrossedUpContractualGhs, GrossedUpAmountBif, AssMatrix."Amount in FCY");
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;

    //============ KENYA ========

    local procedure FnGrossUpTransactionKenya(EmpRecTable: Record Employee; OriginalNetAmountKes: Decimal; PersonalReliefAmt: Decimal; InsuranceReliefPercent: Decimal; NhifDedCode: Code[100]; HousingLevyPercent: Decimal; ShifPercent: Decimal; Nssf1Code: Code[100]; Nssf2Code: Code[100]; PensionLimit: Decimal; PayCountry: Code[100]; PayrollDate: Date) GrossedUpAmountKes: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        PayeDed: Decimal;
        NhifDeduction: Decimal;
        HousingLevy: Decimal;
        NssfDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetKes: Decimal;
        Variance: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        InsuranceRelief: Decimal;
        PensionToDeduct: Decimal;

    begin
        NewNetKes := 0;
        GrossedUpAmountKes := OriginalNetAmountKes;
        Variance := -1;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountKes += Increment;

            BasicAllowance := 1 * GrossedUpAmountKes;

            NhifDeduction := ShifPercent * Abs(GrossedUpAmountKes); //SHIF //abs(GetPaye.GetNonTaxTableDeduction(BasicAllowance, EmpRecTable."Payroll Country", NhifDedCode, 0));
            NssfDeduction := abs(GetPaye.GetNonTaxTableDeduction(BasicAllowance, EmpRecTable."Payroll Country", Nssf1Code, '', 1));
            NssfDeduction := NssfDeduction + abs(GetPaye.GetNonTaxTableDeduction(BasicAllowance, EmpRecTable."Payroll Country", Nssf2Code, '', 2));
            HousingLevy := HousingLevyPercent * Abs(GrossedUpAmountKes);

            InsuranceRelief := InsuranceReliefPercent * NhifDeduction;
            PensionToDeduct := NssfDeduction;
            if (PensionLimit > 0) and (PensionToDeduct > PensionLimit) then
                PensionToDeduct := PensionLimit;
            //housing levy relief


            TaxableAmountVal := BasicAllowance - PensionToDeduct - HousingLevy - NhifDeduction;
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    NssfDeduction := 0;
            end;
            NewNetKes := (BasicAllowance + PersonalReliefAmt + InsuranceRelief) - (PayeDed + NhifDeduction + NssfDeduction + HousingLevy);

            Variance := NewNetKes - OriginalNetAmountKes;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGetNetFromGrossTransactionKenya(EmpRecTable: Record Employee; GrossAmountInKes: Decimal; PayCountry: Code[100]; PersonalReliefAmt: Decimal; InsuranceReliefPercent: Decimal; NhifDedCode: Code[100]; HousingLevyPercent: Decimal; ShifPercent: Decimal; Nssf1Code: Code[100]; Nssf2Code: Code[100]; PensionLimit: Decimal; PayrollDate: Date) NetAmountKes: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        PayeDed: Decimal;
        NhifDeduction: Decimal;
        HousingLevy: Decimal;
        NssfDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetKes: Decimal;
        Variance: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        InsuranceRelief: Decimal;
        PensionToDeduct: Decimal;

    begin
        NetAmountKes := 0;
        RetireCont := 0;

        BasicAllowance := 1 * GrossAmountInKes;

        NhifDeduction := ShifPercent * Abs(GrossAmountInKes); //SHIF //abs(GetPaye.GetNonTaxTableDeduction(BasicAllowance, EmpRecTable."Payroll Country", NhifDedCode, 0));
        NssfDeduction := abs(GetPaye.GetNonTaxTableDeduction(BasicAllowance, EmpRecTable."Payroll Country", Nssf1Code, '', 1));
        NssfDeduction := NssfDeduction + abs(GetPaye.GetNonTaxTableDeduction(BasicAllowance, EmpRecTable."Payroll Country", Nssf2Code, '', 2));
        HousingLevy := HousingLevyPercent * Abs(GrossAmountInKes);

        InsuranceRelief := InsuranceReliefPercent * NhifDeduction;
        PensionToDeduct := NssfDeduction;
        if (PensionLimit > 0) and (PensionToDeduct > PensionLimit) then
            PensionToDeduct := PensionLimit;
        //housing levy relief


        TaxableAmountVal := BasicAllowance - PensionToDeduct - HousingLevy - NhifDeduction;
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * TaxableAmountVal;
            if gvRetirementBenefitsProcessing then
                NssfDeduction := 0;
        end;
        NetAmountKes := (BasicAllowance + PersonalReliefAmt + InsuranceRelief) - (PayeDed + NhifDeduction + NssfDeduction + HousingLevy);
    end;

    local procedure FnGrossUpTransactionNetKenya(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountKes: Decimal; AllowanceNetKes: Decimal; GrossedUpContractualAmountKes: Decimal; PayCountry: Code[100]; PersonalReliefAmt: Decimal; InsuranceReliefPercent: Decimal; NhifDedCode: Code[100]; HousingLevyPercent: Decimal; ShifPercent: Decimal; Nssf1Code: Code[100]; Nssf2Code: Code[100]; PensionLimit: Decimal; isTaxable: Boolean; ExcludeFromCalculations: Boolean) GrossedUpAmountKes: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        PayeDed: Decimal;
        NhifDeduction: Decimal;
        HousingLevy: Decimal;
        NssfDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetKes: Decimal;
        Variance: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        InsuranceRelief: Decimal;
        PensionToDeduct: Decimal;
        TotalGross: Decimal;
        ComputedGross: Decimal;

    begin
        GrossedUpAmountKes := AllowanceNetKes;
        Variance := -1;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountKes += Increment;

            BasicAllowance := 1 * GrossedUpContractualAmountKes;
            TotalGross := BasicAllowance + GrossedUpAmountKes;

            ComputedGross := TotalGross;
            if ExcludeFromCalculations then
                ComputedGross := ComputedGross - GrossedUpAmountKes;

            NhifDeduction := ShifPercent * Abs(ComputedGross); //SHIF //abs(GetPaye.GetNonTaxTableDeduction(ComputedGross, EmpRecTable."Payroll Country", NhifDedCode, 0));
            NssfDeduction := abs(GetPaye.GetNonTaxTableDeduction(ComputedGross, EmpRecTable."Payroll Country", Nssf1Code, '', 1));
            NssfDeduction := NssfDeduction + abs(GetPaye.GetNonTaxTableDeduction(ComputedGross, EmpRecTable."Payroll Country", Nssf2Code, '', 2));
            HousingLevy := HousingLevyPercent * Abs(ComputedGross);

            InsuranceRelief := InsuranceReliefPercent * NhifDeduction;
            PensionToDeduct := NssfDeduction;
            if (PensionLimit > 0) and (PensionToDeduct > PensionLimit) then
                PensionToDeduct := PensionLimit;
            //housing levy relief


            TaxableAmountVal := BasicAllowance - PensionToDeduct - HousingLevy - NhifDeduction;
            if isTaxable then
                TaxableAmountVal := TaxableAmountVal + GrossedUpAmountKes;
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    NssfDeduction := 0;
            end;
            if PayeDed < InsuranceRelief then
                NewNetKes := (BasicAllowance + PersonalReliefAmt /*+ InsuranceRelief*/ + GrossedUpAmountKes) - (/*PayeDed +*/ NhifDeduction + NssfDeduction + HousingLevy)
            else
                NewNetKes := (BasicAllowance + PersonalReliefAmt + InsuranceRelief + GrossedUpAmountKes) - (PayeDed + NhifDeduction + NssfDeduction + HousingLevy);

            Variance := NewNetKes - OriginalNetAmountKes;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGrossUpNetAllowanceKenya(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountKes: Decimal; GrossedUpContractualKes: Decimal; PersonalReliefAmt: Decimal; InsuranceReliefPercent: Decimal; NhifDedCode: Code[100]; HousingLevyPercent: Decimal; ShifPercent: Decimal; Nssf1Code: Code[100]; Nssf2Code: Code[100]; PensionLimit: Decimal; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInKes: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountKes: Decimal;
        EarningCurrency: Code[20];
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInKes := ABS(GetInDesiredCurrency(EarningCurrency, 'KES', AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInKes;
                    GrossedUpAmountKes := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInKes, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountKes := FnGrossUpTransactionNetKenya(EmpTable, PayDate, (NetAmountInKes + NetContractualAmountKes), NetAmountInKes, GrossedUpContractualKes, EmpMovementTable."Payroll Country", PersonalReliefAmt, InsuranceReliefPercent, NhifDedCode, HousingLevyPercent, ShifPercent, Nssf1Code, Nssf2Code, PensionLimit, AssMatrix.Taxable, AssMatrix."Exclude from Calculations");
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency('KES', EarningCurrency, GrossedUpAmountKes, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;


    //== UGANDA ===
    local procedure FnGrossUpTransactionUganda(EmpRecTable: Record Employee; OriginalNetAmountBif: Decimal; BasicPercent: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; PayrollDate: Date) GrossedUpAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NewNetBif := 0;
        GrossedUpAmountGhs := OriginalNetAmountBif;
        Variance := -1;//NewNetBif - OriginalNetAmountBif;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountGhs += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountGhs;
            HouseAllowance := HousePercent * GrossedUpAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);

            InssDed := InssPercent * TaxableAmountVal;//% of actual gross
            //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance + HouseAllowance + TransportAllowance) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGetNetFromGrossGrossTransactionUganda(EmpRecTable: Record Employee; GrossAmountInGhs: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; PayrollDate: Date) NetAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NetAmountGhs := 0;
        RetireCont := 0;

        BasicAllowance := BasicPercent * GrossAmountInGhs;
        HouseAllowance := HousePercent * GrossAmountInGhs;
        TransportAllowance := TransportPercent * GrossAmountInGhs;
        TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);

        InssDed := InssPercent * TaxableAmountVal;
        //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * TaxableAmountVal;
            if gvRetirementBenefitsProcessing then
                InssDed := 0;
        end;
        NetAmountGhs := (BasicAllowance + HouseAllowance + TransportAllowance) - (PayeDed + InssDed);
    end;

    local procedure FnGrossUpTransactionNetUganda(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; GrossedUpContractualAmountGhs: Decimal; BasicPercent: Decimal; IsTaxable: Boolean; ExcludeFromCalculations: Boolean) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := BasicPercent * GrossedUpContractualAmountGhs;
            HouseAllowance := HousePercent * GrossedUpContractualAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif);

            InssDed := InssPercent * TaxableAmountVal;
            if ExcludeFromCalculations then
                InssDed := InssPercent * (TaxableAmountVal - GrossedUpAmountBif);
            if not IsTaxable then
                TaxableAmountVal := TaxableAmountVal - GrossedUpAmountBif;
            //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpNetAllowanceUganda(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; GrossedUpContractualGhs: Decimal; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, 'UGX', AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetUganda(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, GrossedUpContractualGhs, BasicPercent, AssMatrix.Taxable, AssMatrix."Exclude from Calculations");
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency('UGX', EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;

    //== TANZANIA ===
    local procedure FnGrossUpTransactionTanzania(EmpRecTable: Record Employee; OriginalNetAmountBif: Decimal; BasicPercent: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; PayrollDate: Date) GrossedUpAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NewNetBif := 0;
        GrossedUpAmountGhs := OriginalNetAmountBif;
        Variance := -1;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountGhs += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountGhs;
            HouseAllowance := HousePercent * GrossedUpAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);

            InssDed := InssPercent * TaxableAmountVal;//% of actual gross
            //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance + HouseAllowance + TransportAllowance) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGetNetFromGrossGrossTransactionTanzania(EmpRecTable: Record Employee; GrossAmountInGhs: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; PayrollDate: Date) NetAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NetAmountGhs := 0;
        RetireCont := 0;

        BasicAllowance := BasicPercent * GrossAmountInGhs;
        HouseAllowance := HousePercent * GrossAmountInGhs;
        TransportAllowance := TransportPercent * GrossAmountInGhs;
        TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);

        InssDed := InssPercent * TaxableAmountVal;
        //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * TaxableAmountVal;
            if gvRetirementBenefitsProcessing then
                InssDed := 0;
        end;
        NetAmountGhs := (BasicAllowance + HouseAllowance + TransportAllowance) - (PayeDed + InssDed);
    end;

    local procedure FnGrossUpTransactionNetTanzania(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; GrossedUpContractualAmountGhs: Decimal; BasicPercent: Decimal; IsTaxable: Boolean; ExcludeFromCalculations: Boolean) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := BasicPercent * GrossedUpContractualAmountGhs;
            HouseAllowance := HousePercent * GrossedUpContractualAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif);

            InssDed := InssPercent * TaxableAmountVal;
            if ExcludeFromCalculations then
                InssDed := InssPercent * (TaxableAmountVal - GrossedUpAmountBif);
            if not IsTaxable then
                TaxableAmountVal := TaxableAmountVal - GrossedUpAmountBif;
            //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpNetAllowanceTanzania(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; GrossedUpContractualGhs: Decimal; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, 'TZS', AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetTanzania(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, GrossedUpContractualGhs, BasicPercent, AssMatrix.Taxable, AssMatrix."Exclude from Calculations");
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency('TZS', EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;


    //== ZIMBABWE ===
    local procedure FnGrossUpTransactionZimbabwe(EmpRecTable: Record Employee; OriginalNetAmountBif: Decimal; BasicPercent: Decimal; PayCountry: Code[100]; InssPercent: Decimal; AidsPercent: Decimal; NssaLimit: Decimal; PayrollDate: Date) GrossedUpAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        AidsDeduction: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NewNetBif := 0;
        GrossedUpAmountGhs := OriginalNetAmountBif;
        Variance := -1;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountGhs += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountGhs;
            TaxableAmountVal := (BasicAllowance);

            InssDed := InssPercent * TaxableAmountVal;//% of insurable earnings
            if InssDed > NssaLimit then
                InssDed := NssaLimit;
            TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            AidsDeduction := AidsPercent * PayeDed; //% of PAYE
            NewNetBif := (BasicAllowance) - (PayeDed + InssDed + AidsDeduction);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGetNetFromGrossGrossTransactionZimbabwe(EmpRecTable: Record Employee; GrossAmountInGhs: Decimal; PayCountry: Code[100]; InssPercent: Decimal; AidsPercent: Decimal; NssaLimit: Decimal; BasicPercent: Decimal) NetAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        AidsDeduction: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NetAmountGhs := 0;
        RetireCont := 0;

        BasicAllowance := BasicPercent * GrossAmountInGhs;
        TaxableAmountVal := (BasicAllowance);

        InssDed := InssPercent * TaxableAmountVal;//% of insurable earnings
        if InssDed > NssaLimit then
            InssDed := NssaLimit;
        TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * TaxableAmountVal;
            if gvRetirementBenefitsProcessing then
                InssDed := 0;
        end;
        AidsDeduction := AidsPercent * PayeDed; //% of PAYE
        NetAmountGhs := (BasicAllowance) - (PayeDed + InssDed + AidsDeduction);
    end;

    local procedure FnGrossUpTransactionNetZimbabwe(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; AidsPercent: Decimal; NssaLimit: Decimal; GrossedUpContractualAmountGhs: Decimal; IsTaxable: Boolean; ExcludeFromCalculations: Boolean; IsInsurable: Boolean) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        AidsDeduction: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        InsurableAmount: Decimal;
        RetireCont: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;
        RetireCont := 0;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := 1 * GrossedUpContractualAmountGhs;
            InsurableAmount := BasicAllowance;
            TaxableAmountVal := BasicAllowance;
            if ExcludeFromCalculations then
                IsInsurable := false;

            if IsInsurable then
                InsurableAmount := InsurableAmount + GrossedUpAmountBif;

            InssDed := InssPercent * InsurableAmount;
            if InssDed > NssaLimit then
                InssDed := NssaLimit;

            if IsTaxable then
                TaxableAmountVal := TaxableAmountVal + GrossedUpAmountBif;
            TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            AidsDeduction := AidsPercent * PayeDed; //% of PAYE
            NewNetBif := (BasicAllowance + GrossedUpAmountBif) - (PayeDed + InssDed + AidsDeduction);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpNetAllowanceZimbabwe(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; GrossedUpContractualGhs: Decimal; InssPercent: Decimal; AidsPercent: Decimal; NssaLimit: Decimal; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, 'USD', AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetZimbabwe(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, AidsPercent, NssaLimit, GrossedUpContractualGhs, AssMatrix.Taxable, AssMatrix."Exclude from Calculations", AssMatrix.Insurable);
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency('USD', EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;


    //==== Many countries
    local procedure FnGrossUpNetAllowanceMultipleCountries(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmount: Decimal; GrossedUpContractual: Decimal; CountryCurrency: Code[100])
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                /*NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, CountryCurrency, AssMatrix."Net Amount", PayDate,EmpTable));
                GrossedUpAmountBif := NetAmountInBif;//FnGrossUpTransactionNetUganda(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, GrossedUpContractualGhs, BasicPercent, AssMatrix.Taxable, AssMatrix."Exclude from Calculations");
                AssMatrix."Amount in FCY" := GrossedUpAmountBif;//ABS(GetInDesiredCurrency(CountryCurrency, EarningCurrency, GrossedUpAmountBif, PayDate,EmpTable));*/
                AssMatrix."Earning Currency" := EarningCurrency;
                AssMatrix."Amount in FCY" := AssMatrix."Net Amount";//Since there are no formulas, the net amount becomes the gross amount in FCY
                AssMatrix.Validate("Amount in FCY");
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then
                    AssMatrix."Overtime Net" := AssMatrix."Net Amount";

                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;


    //== BENIN ===
    local procedure FnGrossUpTransactionBenin(EmpRecTable: Record Employee; OriginalNetAmountBif: Decimal; BasicPercent: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; PayrollDate: Date; CountryCurrency: Code[100]) GrossedUpAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NewNetBif := 0;
        GrossedUpAmountGhs := OriginalNetAmountBif;
        Variance := -1;//NewNetBif - OriginalNetAmountBif;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountGhs += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountGhs;
            TaxableAmountVal := BasicAllowance;
            /*HouseAllowance := HousePercent * GrossedUpAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);*/

            InssDed := InssPercent * TaxableAmountVal;//% of actual gross
            //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGetNetFromGrossGrossTransactionBenin(EmpRecTable: Record Employee; GrossAmountInGhs: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; PayrollDate: Date; CountryCurrency: Code[100]) NetAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NetAmountGhs := 0;
        RetireCont := 0;
        BasicPercent := 1;

        BasicAllowance := BasicPercent * GrossAmountInGhs;
        TaxableAmountVal := BasicAllowance;
        /*HouseAllowance := HousePercent * GrossAmountInGhs;
        TransportAllowance := TransportPercent * GrossAmountInGhs;
        TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);*/

        InssDed := InssPercent * TaxableAmountVal;
        //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * TaxableAmountVal;
            if gvRetirementBenefitsProcessing then
                InssDed := 0;
        end;
        NetAmountGhs := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/) - (PayeDed + InssDed);
    end;

    local procedure FnGrossUpTransactionNetBenin(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; GrossedUpContractualAmountGhs: Decimal; BasicPercent: Decimal; IsTaxable: Boolean; ExcludeFromCalculations: Boolean; CountryCurrency: Code[100]) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := BasicPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := BasicAllowance + GrossedUpAmountBif;
            /*HouseAllowance := HousePercent * GrossedUpContractualAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif);*/

            InssDed := InssPercent * TaxableAmountVal;
            if ExcludeFromCalculations then
                InssDed := InssPercent * (TaxableAmountVal - GrossedUpAmountBif);
            if not IsTaxable then
                TaxableAmountVal := TaxableAmountVal - GrossedUpAmountBif;
            //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/ + GrossedUpAmountBif) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpNetAllowanceBenin(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; GrossedUpContractualGhs: Decimal; InssPercent: Decimal; HousePercent: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; CountryCurrency: Code[100]; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, CountryCurrency, AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetBenin(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, HousePercent, TransportPercent, GrossedUpContractualGhs, BasicPercent, AssMatrix.Taxable, AssMatrix."Exclude from Calculations", CountryCurrency);
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency(CountryCurrency, EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;


    //== ZAMBIA ===
    local procedure FnGrossUpTransactionZambia(EmpRecTable: Record Employee; OriginalNetAmountBif: Decimal; BasicPercent: Decimal; PayCountry: Code[100]; InssPercent: Decimal; PensionLimit: Decimal; TransportPercent: Decimal; PayrollDate: Date; CountryCurrency: Code[100]) GrossedUpAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NewNetBif := 0;
        GrossedUpAmountGhs := OriginalNetAmountBif;
        Variance := -1;//NewNetBif - OriginalNetAmountBif;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountGhs += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountGhs;
            TaxableAmountVal := BasicAllowance;
            /*HouseAllowance := HousePercent * GrossedUpAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);*/

            InssDed := InssPercent * TaxableAmountVal;//% of actual gross
            if InssDed > PensionLimit then
                InssDed := PensionLimit;
            //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGetNetFromGrossGrossTransactionZambia(EmpRecTable: Record Employee; GrossAmountInGhs: Decimal; PayCountry: Code[100]; InssPercent: Decimal; PensionLimit: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; PayrollDate: Date; CountryCurrency: Code[100]) NetAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        NetAmountGhs := 0;
        RetireCont := 0;
        BasicPercent := 1;

        BasicAllowance := BasicPercent * GrossAmountInGhs;
        TaxableAmountVal := BasicAllowance;
        /*HouseAllowance := HousePercent * GrossAmountInGhs;
        TransportAllowance := TransportPercent * GrossAmountInGhs;
        TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);*/

        InssDed := InssPercent * TaxableAmountVal;
        if InssDed > PensionLimit then
            InssDed := PensionLimit;
        //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * TaxableAmountVal;
            if gvRetirementBenefitsProcessing then
                InssDed := 0;
        end;
        NetAmountGhs := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/) - (PayeDed + InssDed);
    end;

    local procedure FnGrossUpTransactionNetZambia(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; PensionLimit: Decimal; TransportPercent: Decimal; GrossedUpContractualAmountGhs: Decimal; BasicPercent: Decimal; IsTaxable: Boolean; ExcludeFromCalculations: Boolean; CountryCurrency: Code[100]) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := BasicPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := BasicAllowance + GrossedUpAmountBif;
            /*HouseAllowance := HousePercent * GrossedUpContractualAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif);*/

            InssDed := InssPercent * TaxableAmountVal;
            if ExcludeFromCalculations then
                InssDed := InssPercent * (TaxableAmountVal - GrossedUpAmountBif);
            if InssDed > PensionLimit then
                InssDed := PensionLimit;
            if not IsTaxable then
                TaxableAmountVal := TaxableAmountVal - GrossedUpAmountBif;
            //TaxableAmountVal := TaxableAmountVal - InssDed; //Reduces tax
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            NewNetBif := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/ + GrossedUpAmountBif) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpNetAllowanceZambia(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; GrossedUpContractualGhs: Decimal; InssPercent: Decimal; PensionLimit: Decimal; TransportPercent: Decimal; BasicPercent: Decimal; CountryCurrency: Code[100]; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, CountryCurrency, AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetZambia(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, PensionLimit, TransportPercent, GrossedUpContractualGhs, BasicPercent, AssMatrix.Taxable, AssMatrix."Exclude from Calculations", CountryCurrency);
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency(CountryCurrency, EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;



    //== NIGERIA ===
    local procedure FnGrossUpTransactionNigeria(EmpRecTable: Record Employee; OriginalNetAmountBif: Decimal; ExemptFromPension: Boolean; PayCountry: Code[100]; InssPercent: Decimal; ConstantAmount: Decimal; ConsolidatedReliefPercent: Decimal; PayrollDate: Date; CountryCurrency: Code[100]) GrossedUpAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        ConsolidatedReliefAmt: Decimal;
        OnePercentOfTaxable: Decimal;
        BasicPercent: Decimal;

    begin
        NewNetBif := 0;
        GrossedUpAmountGhs := OriginalNetAmountBif;
        Variance := -1;//NewNetBif - OriginalNetAmountBif;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountGhs += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountGhs;
            TaxableAmountVal := BasicAllowance;
            /*HouseAllowance := HousePercent * GrossedUpAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);*/

            InssDed := InssPercent * BasicAllowance;//% of actual gross
            if ExemptFromPension then
                InssDed := 0;
            ConsolidatedReliefAmt := (ConsolidatedReliefPercent * (BasicAllowance - InssDed)) + ConstantAmount;
            TaxableAmountVal := TaxableAmountVal - InssDed - ConsolidatedReliefAmt; //Reduces tax
            OnePercentOfTaxable := 1 / 100 * TaxableAmountVal;
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            if OnePercentOfTaxable > PayeDed then
                PayeDed := OnePercentOfTaxable;
            NewNetBif := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGetNetFromGrossGrossTransactionNigeria(EmpRecTable: Record Employee; GrossAmountInGhs: Decimal; PayCountry: Code[100]; InssPercent: Decimal; ConstantAmount: Decimal; ConsolidatedReliefPercent: Decimal; ExemptFromPension: Boolean; PayrollDate: Date; CountryCurrency: Code[100]) NetAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        ConsolidatedReliefAmt: Decimal;
        OnePercentOfTaxable: Decimal;
        BasicPercent: Decimal;

    begin
        NetAmountGhs := 0;
        RetireCont := 0;
        BasicPercent := 1;

        BasicAllowance := BasicPercent * GrossAmountInGhs;
        TaxableAmountVal := BasicAllowance;
        /*HouseAllowance := HousePercent * GrossAmountInGhs;
        TransportAllowance := TransportPercent * GrossAmountInGhs;
        TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);*/

        InssDed := InssPercent * BasicAllowance;//% of actual gross
        if ExemptFromPension then
            InssDed := 0;
        ConsolidatedReliefAmt := (ConsolidatedReliefPercent * (BasicAllowance - InssDed)) + ConstantAmount;
        TaxableAmountVal := TaxableAmountVal - InssDed - ConsolidatedReliefAmt; //Reduces tax
        OnePercentOfTaxable := 1 / 100 * TaxableAmountVal;
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if gvIsTerminalDuesProcessing then begin
            PayeDed := (30 / 100) * TaxableAmountVal;
            if gvRetirementBenefitsProcessing then
                InssDed := 0;
        end;
        if OnePercentOfTaxable > PayeDed then
            PayeDed := OnePercentOfTaxable;
        NetAmountGhs := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/) - (PayeDed + InssDed);
    end;

    local procedure FnGrossUpTransactionNetNigeria(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; ConstantAmount: Decimal; ConsolidatedReliefPercent: Decimal; GrossedUpContractualAmountGhs: Decimal; ExemptFromPension: Boolean; IsTaxable: Boolean; ExcludeFromCalculations: Boolean; CountryCurrency: Code[100]) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        ConsolidatedReliefAmt: Decimal;
        OnePercentOfTaxable: Decimal;
        BasicPercent: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := BasicPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := BasicAllowance + GrossedUpAmountBif;
            /*HouseAllowance := HousePercent * GrossedUpContractualAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif);*/

            InssDed := InssPercent * TaxableAmountVal;//% of actual gross
            if ExcludeFromCalculations then
                InssDed := InssPercent * (TaxableAmountVal - GrossedUpAmountBif);
            if ExemptFromPension then
                InssDed := 0;
            if not IsTaxable then
                TaxableAmountVal := TaxableAmountVal - GrossedUpAmountBif;
            ConsolidatedReliefAmt := (ConsolidatedReliefPercent * (TaxableAmountVal - InssDed)) + ConstantAmount;
            TaxableAmountVal := TaxableAmountVal - InssDed - ConsolidatedReliefAmt; //Reduces tax
            OnePercentOfTaxable := 1 / 100 * TaxableAmountVal;
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if gvIsTerminalDuesProcessing then begin
                PayeDed := (30 / 100) * TaxableAmountVal;
                if gvRetirementBenefitsProcessing then
                    InssDed := 0;
            end;
            if OnePercentOfTaxable > PayeDed then
                PayeDed := OnePercentOfTaxable;
            NewNetBif := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/ + GrossedUpAmountBif) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpNetAllowanceNigeria(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; GrossedUpContractualGhs: Decimal; InssPercent: Decimal; ConstantAmount: Decimal; ConsolidatedReliefPercent: Decimal; ExemptFromPension: Boolean; CountryCurrency: Code[100]; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
        BasicPercent: Decimal;
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, CountryCurrency, AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetNigeria(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, ConstantAmount, ConsolidatedReliefPercent, GrossedUpContractualGhs, ExemptFromPension, AssMatrix.Taxable, AssMatrix."Exclude from Calculations", CountryCurrency);
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency(CountryCurrency, EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;




    //== CONSULTANT ===
    local procedure FnGrossUpTransactionConsultant(EmpRecTable: Record Employee; OriginalNetAmountBif: Decimal; ExemptFromPension: Boolean; PayCountry: Code[100]; InssPercent: Decimal; ConstantAmount: Decimal; ConsolidatedReliefPercent: Decimal; PayrollDate: Date; CountryCurrency: Code[100]) GrossedUpAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        ConsolidatedReliefAmt: Decimal;
        OnePercentOfTaxable: Decimal;
        BasicPercent: Decimal;

    begin
        NewNetBif := 0;
        GrossedUpAmountGhs := OriginalNetAmountBif;
        Variance := -1;//NewNetBif - OriginalNetAmountBif;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountGhs += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountGhs;
            TaxableAmountVal := BasicAllowance;
            /*HouseAllowance := HousePercent * GrossedUpAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);*/

            InssDed := InssPercent * BasicAllowance;//% of actual gross
            if ExemptFromPension then
                InssDed := 0;
            PayeDed := 0;
            /*ConsolidatedReliefAmt := (ConsolidatedReliefPercent * (BasicAllowance - InssDed)) + ConstantAmount;
            TaxableAmountVal := TaxableAmountVal - InssDed - ConsolidatedReliefAmt; //Reduces tax
            OnePercentOfTaxable := 1 / 100 * TaxableAmountVal;
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if OnePercentOfTaxable > PayeDed then
                PayeDed := OnePercentOfTaxable;*/
            NewNetBif := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;

    local procedure FnGetNetFromGrossGrossTransactionConsultant(EmpRecTable: Record Employee; GrossAmountInGhs: Decimal; PayCountry: Code[100]; InssPercent: Decimal; ConstantAmount: Decimal; ConsolidatedReliefPercent: Decimal; ExemptFromPension: Boolean; PayrollDate: Date; CountryCurrency: Code[100]) NetAmountGhs: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        ConsolidatedReliefAmt: Decimal;
        OnePercentOfTaxable: Decimal;
        BasicPercent: Decimal;

    begin
        NetAmountGhs := 0;
        RetireCont := 0;
        BasicPercent := 1;

        BasicAllowance := BasicPercent * GrossAmountInGhs;
        TaxableAmountVal := BasicAllowance;
        /*HouseAllowance := HousePercent * GrossAmountInGhs;
        TransportAllowance := TransportPercent * GrossAmountInGhs;
        TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance);*/

        InssDed := InssPercent * BasicAllowance;//% of actual gross
        if ExemptFromPension then
            InssDed := 0;
        PayeDed := 0;
        /*ConsolidatedReliefAmt := (ConsolidatedReliefPercent * (BasicAllowance - InssDed)) + ConstantAmount;
        TaxableAmountVal := TaxableAmountVal - InssDed - ConsolidatedReliefAmt; //Reduces tax
        OnePercentOfTaxable := 1 / 100 * TaxableAmountVal;
        PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
        if OnePercentOfTaxable > PayeDed then
            PayeDed := OnePercentOfTaxable;*/
        NetAmountGhs := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/) - (PayeDed + InssDed);
    end;

    local procedure FnGrossUpTransactionNetConsultant(EmpRecTable: Record Employee; PayrollDate: Date; OriginalNetAmountBif: Decimal; AllowanceNetBif: Decimal; PayCountry: Code[100]; InssPercent: Decimal; ConstantAmount: Decimal; ConsolidatedReliefPercent: Decimal; GrossedUpContractualAmountGhs: Decimal; ExemptFromPension: Boolean; IsTaxable: Boolean; ExcludeFromCalculations: Boolean; CountryCurrency: Code[100]) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        ConsolidatedReliefAmt: Decimal;
        OnePercentOfTaxable: Decimal;
        BasicPercent: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := BasicPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := BasicAllowance + GrossedUpAmountBif;
            /*HouseAllowance := HousePercent * GrossedUpContractualAmountGhs;
            TransportAllowance := TransportPercent * GrossedUpContractualAmountGhs;
            TaxableAmountVal := (BasicAllowance + HouseAllowance + TransportAllowance + GrossedUpAmountBif);*/

            InssDed := InssPercent * TaxableAmountVal;//% of actual gross
            if ExcludeFromCalculations then
                InssDed := InssPercent * (TaxableAmountVal - GrossedUpAmountBif);
            if ExemptFromPension then
                InssDed := 0;
            if not IsTaxable then
                TaxableAmountVal := TaxableAmountVal - GrossedUpAmountBif;
            /*PayeDed := 0;
            ConsolidatedReliefAmt := (ConsolidatedReliefPercent * (TaxableAmountVal - InssDed)) + ConstantAmount;
            TaxableAmountVal := TaxableAmountVal - InssDed - ConsolidatedReliefAmt; //Reduces tax
            OnePercentOfTaxable := 1 / 100 * TaxableAmountVal;
            PayeDed := GetPaye.GetTaxBracket(TaxableAmountVal, EmpRecTable."Payroll Country");
            if OnePercentOfTaxable > PayeDed then
                PayeDed := OnePercentOfTaxable;*/
            NewNetBif := (BasicAllowance /*+ HouseAllowance + TransportAllowance*/ + GrossedUpAmountBif) - (PayeDed + InssDed);

            Variance := NewNetBif - OriginalNetAmountBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpTransactionOvertimeNet(EmpRecTable: Record Employee; AllowanceNetBif: Decimal; PayCountry: Code[100]) GrossedUpAmountBif: Decimal
    var
        Increment: Decimal;
        BasicAllowance: Decimal;
        HouseAllowance: Decimal;
        TransportAllowance: Decimal;
        PayeDed: Decimal;
        SocialSecurity: Decimal;
        MaternityDeduction: Decimal;
        MedicalDeduction: Decimal;
        NewNetBif: Decimal;
        Variance: Decimal;
        FamilyAllowance: Decimal;
        InssDed: Decimal;
        GrossAmountBif: Decimal;
        TaxableAmountVal: Decimal;
        RetireCont: Decimal;
        ConsolidatedReliefAmt: Decimal;
        OnePercentOfTaxable: Decimal;
        BasicPercent: Decimal;

    begin
        GrossedUpAmountBif := AllowanceNetBif;
        Variance := -1;
        RetireCont := 0;
        BasicPercent := 1;

        WHILE Variance <> 0.0 DO BEGIN
            Increment := 100000;//00;
            /*IF ABS(Variance) < 10000000 THEN
                Increment := 1000000;
            IF ABS(Variance) < 1000000 THEN
                Increment := 100000;*/
            IF ABS(Variance) < 100000 THEN
                Increment := 10000;
            IF ABS(Variance) < 10000 THEN
                Increment := 1000;
            IF ABS(Variance) < 1000 THEN
                Increment := 100;
            IF ABS(Variance) < 100 THEN
                Increment := 10;
            IF ABS(Variance) < 10 THEN
                Increment := 1;
            IF ABS(Variance) < 1 THEN
                Increment := 0.1;
            IF ABS(Variance) < 0.1 THEN
                Increment := 0.01;
            IF ABS(Variance) < 0.01 THEN
                Increment := 0.001;
            IF ABS(Variance) < 0.001 THEN
                Increment := 0.0001;

            GrossedUpAmountBif += Increment;

            BasicAllowance := BasicPercent * GrossedUpAmountBif;
            TaxableAmountVal := GrossedUpAmountBif;

            InssDed := 0.06 * TaxableAmountVal; //RSSB pension
            MaternityDeduction := 0.003 * TaxableAmountVal; //Maternity leave
            PayeDed := 0.3 * TaxableAmountVal; //PAYE

            NewNetBif := (GrossedUpAmountBif) - (PayeDed + InssDed + MaternityDeduction);

            Variance := NewNetBif - AllowanceNetBif;
            Variance := ROUND(Variance, 0.001, '<');
            IF Variance > 0 THEN begin
                Variance := 0;
            end;
        END;
    end;


    local procedure FnGrossUpNetAllowanceConsultant(EmpTable: Record Employee; EmpMovementTable: Record "Internal Employement History"; PayDate: Date; NetContractualAmountBif: Decimal; GrossedUpContractualGhs: Decimal; InssPercent: Decimal; ConstantAmount: Decimal; ConsolidatedReliefPercent: Decimal; ExemptFromPension: Boolean; CountryCurrency: Code[100]; ExchangeRateDateToUse: Date)
    var
        Increment: Decimal;
        NetAmountInBif: Decimal;
        AssMatrix: Record "Assignment Matrix";
        GrossedUpAmountBif: Decimal;
        EarningCurrency: Code[20];
        BasicPercent: Decimal;
    //NetCongratualAmountRwf: Decimal;
    begin
        //If we have any net allowances, convert them here
        AssMatrix.Reset();
        AssMatrix.SetRange(Country, EmpTable."Payroll Country");
        AssMatrix.SetRange("Employee No", EmpTable."No.");
        AssMatrix.SetRange("Payroll Period", PayDate);
        AssMatrix.SetRange("Amount Type", AssMatrix."Amount Type"::Net);
        AssMatrix.SetFilter("Net Amount", '<>%1', 0);
        if AssMatrix.FindSet() then
            repeat
                EarningCurrency := AssMatrix."Earning Currency";
                if EarningCurrency = '' then
                    EarningCurrency := 'USD';
                NetAmountInBif := ABS(GetInDesiredCurrency(EarningCurrency, CountryCurrency, AssMatrix."Net Amount", ExchangeRateDateToUse, EmpTable));
                AssMatrix."Overtime Net" := 0;
                if AssMatrix."Overtime Allowance" then begin
                    AssMatrix."Overtime Net" := NetAmountInBif;
                    GrossedUpAmountBif := FnGrossUpTransactionOvertimeNet(EmpTable, NetAmountInBif, EmpMovementTable."Payroll Country");
                end else
                    GrossedUpAmountBif := FnGrossUpTransactionNetConsultant(EmpTable, PayDate, (NetAmountInBif + NetContractualAmountBif), NetAmountInBif, EmpMovementTable."Payroll Country", InssPercent, ConstantAmount, ConsolidatedReliefPercent, GrossedUpContractualGhs, ExemptFromPension, AssMatrix.Taxable, AssMatrix."Exclude from Calculations", CountryCurrency);
                AssMatrix."Amount in FCY" := ABS(GetInDesiredCurrency(CountryCurrency, EarningCurrency, GrossedUpAmountBif, ExchangeRateDateToUse, EmpTable));
                AssMatrix.Validate("Amount in FCY");
                AssMatrix.Modify();
            until AssMatrix.Next() = 0;
    end;

    //==== END

    Procedure GetInDesiredCurrency(CurrentAmountCurrency: Code[50]; DesiredCurrency: Code[50]; AmountToConvert: Decimal; ExchRateDateVar: Date; EmpTableFinalDues: Record Employee) ConvertedAmount: Decimal
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        ExchangeRate: Decimal;
        TerminalDuesRec: Record "Terminal Dues Header";
    begin
        ConvertedAmount := AmountToConvert;
        if EmpTableFinalDues."Under Terminal Dues Processing" then begin
            TerminalDuesRec.Reset();
            TerminalDuesRec.SetRange("WB No.", EmpTableFinalDues."No.");
            if TerminalDuesRec.FindFirst() then begin
                if TerminalDuesRec."Exchange Rate" = 0 then
                    TerminalDuesRec."Exchange Rate" := 1;
                if (CurrentAmountCurrency <> 'USD') and (DesiredCurrency = 'USD') then
                    ConvertedAmount := AmountToConvert * (1 / TerminalDuesRec."Exchange Rate");
                if (CurrentAmountCurrency = 'USD') and (DesiredCurrency <> 'USD') then
                    ConvertedAmount := AmountToConvert * TerminalDuesRec."Exchange Rate";
            end;
        end else if (DesiredCurrency = CurrentAmountCurrency) or (CurrentAmountCurrency = '') then
                ConvertedAmount := AmountToConvert
        else begin
            CurrExchangeRateDate := CalcDate('CM', ExchRateDateVar); //CalcDate('1M', ExchRateDateVar);
            Fcy1ToLcyRate := 0;
            LcyToFcy2Rate := 0;

            //We want to convert the currency from the earning currency to the desired currency
            //1. Get the FCY1 to LCY rate
            /*if "Earning Currency" = localCurrencyCode then
                Fcy1ToLcyRate := 1
            else begin*/
            CurrencyExchangeRate.GetLastestExchangeRateCustom(CurrentAmountCurrency, CurrExchangeRateDate, Fcy1ToLcyRate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', CurrentAmountCurrency, localCurrencyCode);
            //end;

            //2. Get the LCY to FCY2 rate
            CurrencyExchangeRate.GetLastestExchangeRateCustom(DesiredCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, DesiredCurrency);

            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
            if LcyToFcy2Rate <> 0 then
                ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
            ConvertedAmount := AmountToConvert * ExchangeRate;
        end;
        exit(ConvertedAmount);
    end;


    local procedure FnProratePay(var EmployeeNo: Code[10]; var PayrollDate: Date; var FirstDate: Date; var LastDate: Date; var EmpCountry: Code[50]; var CurrAssignedGross: Decimal; var "Apply Daily Rates": Boolean; var "Daily Rate": Decimal) ProratedContractualAmount: Decimal
    var
        Emp: Record Employee;
        Benefits: Record "Scale Benefits";
        NoOfDays: Integer;
        CurrMonthEnd: Date;
        CurrMonthStart: Date;
        Assignment: Record "Assignment Matrix";
        AssignmentM: Record "Assignment Matrix";
        CurrMonthDays: Integer;
        ProratableEarnings: Record Earnings;
        AmountToProrate: Decimal;
    begin
        ProratedContractualAmount := CurrAssignedGross;
        AmountToProrate := CurrAssignedGross;
        //Joined MidMonth Snippet
        CurrMonthEnd := 0D;
        CurrMonthStart := 0D;
        CurrMonthDays := 0;
        NoOfDays := 0;
        NonWorkingDays := 0;

        //Simplifying the process
        CurrMonthEnd := CalcDate('<CM>', PayrollDate);
        CurrMonthStart := CalcDate('-CM', PayrollDate);
        CurrMonthDays := CurrMonthEnd - CurrMonthStart;
        CurrMonthDays := CurrMonthDays + 1;

        if FirstDate < CurrMonthStart then
            FirstDate := CurrMonthStart;
        if LastDate > CurrMonthEnd then
            LastDate := CurrMonthEnd;

        if LastDate < FirstDate then
            Error('The Last Date %1 is earlier than First Date %2 for staff %3. Kindly review!', LastDate, FirstDate, EmployeeNo);

        NoOfDays := (LastDate - FirstDate) + 1;
        if NoOfDays < CurrMonthDays then //it means the person worked less days this month
        begin
            if "Apply Daily Rates" then begin
                HRCalendarList.Reset;
                HRCalendarList.SetRange(HRCalendarList.Date, FirstDate, LastDate);
                HRCalendarList.SetRange(HRCalendarList."Non Working", true);
                /*if not Emp."Apply Daily Rates" then
                    HRCalendarList.SetFilter(Reason, 'Saturday|Sunday');*/
                if HRCalendarList.FindSet then begin
                    NonWorkingDays := HRCalendarList.Count;
                end;
                ProratedContractualAmount := Round((NoOfDays - NonWorkingDays) * ("Daily Rate"), 0.01, '=');
            end else
                ProratedContractualAmount := Round((NoOfDays / CurrMonthDays) * (AmountToProrate), 0.01, '=');

            /*ProratableEarnings.Reset;
            ProratableEarnings.SetRange(Country, EmpCountry);
            ProratableEarnings.setrange(Proratable, true);
            ProratableEarnings.SetRange("Is Contractual Amount", true);
            if ProratableEarnings.findset then begin
                repeat
                    AssignmentM.Reset;
                    AssignmentM.SetRange(AssignmentM."Employee No", EmployeeNo);
                    AssignmentM.SetRange(AssignmentM."Payroll Period", PayrollDate);
                    AssignmentM.SetRange(AssignmentM.Country, EmpCountry);
                    AssignmentM.SetRange(AssignmentM.Type, AssignmentM.Type::Payment);
                    AssignmentM.SetRange(AssignmentM.Code, ProratableEarnings.Code);
                    //AssignmentM.SetRange(AssignmentM.Taxable, true);
                    if AssignmentM.Find('-') then begin
                        repeat
                            if "Apply Daily Rates" then
                                AssignmentM.Amount := Round((NoOfDays - NonWorkingDays) * ("Daily Rate"), 0.01, '=');

                            AssignmentM.Amount := Round((NoOfDays / CurrMonthDays) * (AmountToProrate), 0.01, '=');
                            ProratedContractualAmount := AssignmentM.Amount;
                            AssignmentM.Modify;
                        until AssignmentM.Next = 0;
                    end;
                until ProratableEarnings.next = 0;*/
        end;
        //end;
        /*
        if Emp.Get(EmployeeNo) then begin

            //Now that we are working with staff movement
            Emp."Date Of Join" := FirstDate;
            Emp."Date Of Leaving" := LastDate;

            Emp."Payroll Country" := EmpCountry;
            Emp."Assigned Gross Pay" := CurrAssignedGross;

            //ERROR('here date='+FORMAT(Emp."Contract Start Date"));
            //IF Emp."Contract Start Date" > CALCDATE('-CM',PayrollDate) THEN BEGIN
            if Emp."Contract Start Date" > Emp."Date Of Join" then
                Emp."Date Of Join" := Emp."Contract Start Date";
            //END;
            //FRED 19/4/23 - If contract end date is set, use it as date of leaving - without necessarily updating the employee table
            if (Emp."Contract End Date" <> 0D) and (Emp."Date Of Leaving" = 0D) then
                Emp."Date Of Leaving" := Emp."Contract End Date";

            CurrMonthEnd := CalcDate('<CM>', PayrollDate);
            CurrMonthStart := CalcDate('-CM', PayrollDate);
            CurrMonthDays := CurrMonthEnd - CurrMonthStart;
            CurrMonthDays := CurrMonthDays + 1;

            //24/4/23
            if Emp."Date Of Leaving" <> 0D then begin
                if Emp."Date Of Leaving" < CurrMonthEnd then
                    CurrMonthEnd := Emp."Date Of Leaving";
                if Emp."Date Of Leaving" > CurrMonthEnd then
                    Emp."Date Of Leaving" := CurrMonthEnd;
            end;

            //ERROR('here start date='+FORMAT(Emp."Date Of Join")+' end date='+FORMAT(CurrMonthEnd));
            
            if Emp."Date Of Join" <> 0D then begin

                //MESSAGE('NoOfDays%1CurrDays%2Doj%3CME%4Diff%5Days%6',NoOfDays,CurrMonthDays,Emp."Date Of Join",CurrMonthEnd,CurrMonthEnd-Emp."Date Of Join",CurrMonthEnd-CurrMonthStart);
                if (CurrMonthEnd - Emp."Date Of Join") <= (CurrMonthEnd - CurrMonthStart) then begin
                    //MESSAGE('NoofDaysWorked %1,Months Days %2',(CurrMonthEnd-Emp."Date Of Join"),(CurrMonthEnd-CurrMonthStart));
                    NoOfDays := 0;
                    NoOfDays := (CurrMonthEnd - Emp."Date Of Join") + 1;
                    //MESSAGE('NoDays%1 Month%2',NoOfDays,CurrMonthEnd);

                    ProratableEarnings.Reset;
                    ProratableEarnings.SetRange(Country, Emp."Payroll Country");
                    ProratableEarnings.setrange(Proratable, true);
                    if ProratableEarnings.findset then begin
                        repeat
                            /*AmountToProrate := Emp."Basic Pay";
                            if ProratableEarnings."Gross Pay" then///
                            AmountToProrate := Emp."Assigned Gross Pay";
                            AssignmentM.Reset;
                            AssignmentM.SetRange(AssignmentM."Employee No", EmployeeNo);
                            AssignmentM.SetRange(AssignmentM."Payroll Period", PayrollDate);
                            AssignmentM.SetRange(AssignmentM.Country, Emp."Payroll Country");
                            AssignmentM.SetRange(Type, AssignmentM.Type::Payment);
                            AssignmentM.SetRange(Code, ProratableEarnings.Code);
                            //AssignmentM.SetRange(AssignmentM.Taxable, true);
                            if AssignmentM.Find('-') then begin
                                repeat

                                    HRCalendarList.Reset;
                                    //HRCalendarList.SETRANGE(HRCalendarList.Date,CurrMonthStart,Emp."Date Of Join");
                                    HRCalendarList.SetRange(HRCalendarList.Date, Emp."Date Of Join", CurrMonthEnd);
                                    HRCalendarList.SetRange(HRCalendarList."Non Working", true);
                                    //IF Emp."Contract Type" <> 'LOCUM' THEN
                                    if not Emp."Apply Daily Rates" then
                                        HRCalendarList.SetFilter(Reason, 'Saturday|Sunday');
                                    if HRCalendarList.FindSet then begin
                                        NonWorkingDays := HRCalendarList.Count;
                                    end;
                                    //AssignmentM.Amount:=ROUND((NoOfDays/CurrMonthDays*AssignmentM.Amount),0.01,'=');
                                    //AssignmentM.Amount := Round((NoOfDays - NonWorkingDays) * ((Emp."Basic Pay" * 12) / 260), 0.01, '=');
                                    AssignmentM.Amount := Round((NoOfDays / CurrMonthDays) * (AmountToProrate), 0.01, '=');
                                    //MESSAGE('NoDays=%1 Join/start date=%2 MonthEnd=%3 NonWorkingDays=%4 Amt=%5 EmpBasic=%6',NoOfDays,Emp."Date Of Join",CurrMonthEnd,NonWorkingDays,AssignmentM.Amount,Emp."Basic Pay");

                                    if Emp."Apply Daily Rates" then begin
                                        AssignmentM.Amount := Round((NoOfDays - NonWorkingDays) * (Emp."Daily Rate"), 0.01, '=');
                                        //ERROR(FORMAT(AssignmentM.Amount));
                                    end;
                                    ProratedContractualAmount := AssignmentM.Amount;

                                    //AssignmentM.Amount:=ROUND((NoOfDays)*((Emp."Basic Pay"*12)/260),0.01,'=');
                                    AssignmentM.Modify;
                                until AssignmentM.Next = 0;
                            end;
                        until ProratableEarnings.next = 0;
                    end;
                end;
            end;

            //ERROR('Stop %1',Emp."Date Of Leaving");
            //Resigned/Termination Snippet
            if Emp."Date Of Leaving" <> 0D then begin
                //ERROR('Stop %1',Emp."Date Of Leaving");
                //ERROR('CurrMonthStart='+FORMAT(CurrMonthStart)+' CurrMonthEnd='+FORMAT(CurrMonthEnd)+' | '+FORMAT(Emp."Date Of Leaving"-CurrMonthStart)+'->'+FORMAT(CurrMonthEnd-CurrMonthStart));
                if (Emp."Date Of Leaving" - CurrMonthStart) <= (CurrMonthEnd - CurrMonthStart) then begin
                    NoOfDays := 0;
                    NoOfDays := Emp."Date Of Leaving" - CurrMonthStart;
                    if (Emp."Date Of Join" <> 0D) and (Emp."Date Of Join" > CurrMonthStart) then
                        NoOfDays := Emp."Date Of Leaving" - Emp."Date Of Join";
                    NoOfDays := NoOfDays + 1;

                    ProratableEarnings.Reset;
                    ProratableEarnings.SetRange(Country, Emp."Payroll Country");
                    ProratableEarnings.setrange(Proratable, true);
                    if ProratableEarnings.findset then begin
                        repeat
                            /*AmountToProrate := Emp."Basic Pay";
                            if ProratableEarnings."Gross Pay" then///
                            AmountToProrate := Emp."Assigned Gross Pay";
                            Assignment.Reset;
                            Assignment.SetRange(Assignment."Employee No", EmployeeNo);
                            Assignment.SetRange(Assignment."Payroll Period", PayrollDate);
                            //Assignment.SetRange(Assignment.Taxable, true);
                            Assignment.SetRange(Assignment.Country, Emp."Payroll Country");
                            //Assignment.SETFILTER(Assignment.Code,'<>%1 & <>%2','23','10');
                            //Only process basic pay
                            Assignment.SetRange(Assignment.Code, ProratableEarnings.Code);
                            Assignment.SetRange(Type, Assignment.Type::Payment);
                            if Assignment.Find('-') then begin
                                repeat

                                    HRCalendarList.Reset;
                                    HRCalendarList.SetRange(HRCalendarList.Date, CurrMonthStart, Emp."Date Of Leaving");
                                    HRCalendarList.SetRange(HRCalendarList."Non Working", true);
                                    //HRCalendarList.SETFILTER(HRCalendarList.Day,'%1|%2','Saturday','Sunday'); FRED 19/4/23 - Any non-working, regardless of the reason
                                    if not Emp."Apply Daily Rates" then
                                        HRCalendarList.SetFilter(Reason, 'Saturday|Sunday');
                                    if HRCalendarList.FindSet then begin
                                        NonWorkingDays := HRCalendarList.Count;
                                    end;

                                    //Assignment.Amount:=ROUND((NoOfDays/CurrMonthDays*Assignment.Amount),0.01,'=');
                                    //Assignment.Amount := Round((NoOfDays - NonWorkingDays) * ((AmountToProrate * 12) / 260), 0.01, '=');
                                    Assignment.Amount := Round((NoOfDays / CurrMonthDays) * (AmountToProrate), 0.01, '=');
                                    //ERROR('NoOfDays = '+FORMAT(NoOfDays)+'-NonWorkingDays='+FORMAT(NonWorkingDays)+' -Basic='+FORMAT(ROUND((NoOfDays-NonWorkingDays)*(Emp."Basic Pay"),0.01,'=')));
                                    //ERROR('Basic Amount = '+FORMAT(Assignment.Amount));
                                    if Emp."Apply Daily Rates" then begin
                                        //ERROR('NoOfDays = '+FORMAT(NoOfDays)+'-NonWorkingDays='+FORMAT(NonWorkingDays)+' -Basic='+FORMAT(ROUND((NoOfDays-NonWorkingDays)*(Emp."Daily Rate"),0.01,'=')));
                                        Assignment.Amount := Round((NoOfDays - NonWorkingDays) * (Emp."Daily Rate"), 0.01, '=');
                                    end;

                                    ProratedContractualAmount := Assignment.Amount;

                                    Assignment.Modify;
                                until Assignment.Next = 0;
                            end;
                        until ProratableEarnings.next = 0;
                    end;
                end;
            end;
        end;
        */

        //=>FnGetDisciplinaryCase(EmployeeNo, PayrollDate);
        //=>FnGetNewPension(EmployeeNo, PayrollDate);
    end;

    local procedure FnGetNewPension(var EmployeeNo: Code[40]; var PeriodDate: Date)
    var
        Assignments: Record "Assignment Matrix";
        Assignment: Record "Assignment Matrix";
        Deduction: Record Deductions;
    begin
        //Get new pension Deduction Kitui
        Assignments.Reset;
        Assignments.SetRange(Assignments.Code, 'D23');
        Assignments.SetRange(Assignments."Payroll Period", PeriodDate);
        Assignments.SetRange(Assignments."Employee No", EmployeeNo);
        if Assignments.FindFirst then begin
            Assignments.Validate(Assignments.Code);
            Assignments.Modify;
        end;
    end;

    local procedure FnGetDisciplinaryCase(var EmployeeNo: Code[40]; var PeriodDate: Date)
    var
        Assignments: Record "Assignment Matrix";
        Assignment: Record "Assignment Matrix";
        Deduction: Record Deductions;
        EmpX: Record Employee;
        Assignmentsx: Record "Assignment Matrix";
    begin
        if EmpX.Get(EmployeeNo) then begin
            if EmpX."Disciplinary Actions" <> EmpX."Disciplinary Actions"::None then begin
                //MESSAGE(FORMAT(EmpX."No."));
                Assignments.Reset;
                Assignments.SetRange(Assignments."Employee No", EmployeeNo);
                Assignments.SetRange(Assignments."Payroll Period", PeriodDate);
                Assignments.SetRange(Assignments.Taxable, true);
                Assignments.SetFilter(Assignments.Code, '<>%1 & <>%2', '01', '02');
                if Assignments.FindSet then
                    Assignments.DeleteAll;

                Assignmentsx.Reset;
                Assignmentsx.SetRange(Assignmentsx."Employee No", EmployeeNo);
                Assignmentsx.SetRange(Assignmentsx.Taxable, true);
                Assignmentsx.SetRange(Assignmentsx."Payroll Period", PeriodDate);
                Assignmentsx.SetRange(Assignmentsx.Code, '01');
                if Assignmentsx.FindFirst then begin
                    repeat
                        Assignmentsx.Amount := Assignmentsx.Amount / 2;
                        Assignmentsx.Modify;
                    until Assignmentsx.Next = 0;
                end;
            end;
        end;
    end;

    local procedure FnGetVoluntaryPension(var EmployeeNo: Code[40]; var PeriodDate: Date)
    var
        Assignments: Record "Assignment Matrix";
        Assignment: Record "Assignment Matrix";
        Deduction: Record Deductions;
        EmpX: Record Employee;
        Assignmentsx: Record "Assignment Matrix";
    begin
        Assignmentsx.Reset;
        Assignmentsx.SetRange(Assignmentsx."Employee No", EmployeeNo);
        Assignmentsx.SetRange(Assignmentsx."Payroll Period", PeriodDate);
        Assignmentsx.SetRange(Assignmentsx.Code, 'D26');
        if Assignmentsx.FindFirst then begin
            repeat
                //MESSAGE(FORMAT(Assignmentsx.Amount));
                if Assignmentsx.Amount > 0 then begin
                    Assignmentsx.Amount := Assignmentsx.Amount * -1;
                    //MESSAGE(FORMAT(Assignmentsx.Amount));
                    Assignmentsx.Modify;
                end;
            until Assignmentsx.Next = 0;
        end;
    end;

    local procedure FnUpdateVoluntaryInsurance(EmpNo: Code[20]; MonthX: Date)
    var
        AssMat: Record "Assignment Matrix";
    begin
        /*AssMat.Reset;
        AssMat.SetRange(AssMat."Employee No", EmpNo);
        AssMat.SetRange(AssMat."Payroll Period", MonthX);
        AssMat.SetRange(AssMat.Code, 'D14');
        if AssMat.Find('-') then begin
            repeat
                //ERROR('%1 insurance ,%2',AssMat.Code,AssMat."Insurance Code");
                AssMat."Insurance Code" := true;
                AssMat."Do Not Deduct" := true;
                AssMat.Modify;
            // ERROR('Code %1 insurance %2, DnD %3',AssMat.Code,AssMat."Insurance Code",AssMat."Do Not Deduct");
            until AssMat.Next = 0;
        end;*/
    end;

    procedure FnIncludeDeductionInSpecialTransAllowance(DedCode: Code[20]; IsStatutory: Boolean): Boolean
    begin
        /*if not IsStatutory then
            exit(false);*/
        /*if DedCode = 'CBHI' then
            exit(false);*/

        if not NoRepeatDeductions.ContainsKey(DedCode) then begin
            NoRepeatDeductions.Add(DedCode, true);
            exit(true);
        end;
        exit(false);
    end;

}

