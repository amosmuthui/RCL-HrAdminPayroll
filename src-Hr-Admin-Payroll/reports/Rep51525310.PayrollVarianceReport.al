report 51525310 "Payroll Variance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/PayrollVarianceReport.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = WHERE(Board = CONST(false));//, Status = CONST(Active));
            RequestFilterFields = "No.";//, "Payroll Country";
            column(No_Employee; Employee."No.")
            {
            }
            column(Name; Employee."Last Name" + ' ' + Employee."Middle Name" + ' ' + Employee."First Name")
            {
            }
            column(DateA; UpperCase(Format(DateSpecified, 0, '<month text> <year4>')))
            {
            }
            column(SumA; SumMonthA)
            {
            }
            column(DateB; UpperCase(Format(PreviousMonth, 0, '<month text> <year4>')))
            {
            }
            column(SumB; SumMonthB)
            {
            }
            column(CompName; Comp.Name)
            {
            }
            column(CompAddress; Comp.Address)
            {
            }
            column(CompCity; Comp.City)
            {
            }
            column(CompPicture; Comp.Picture)
            {
            }
            column(No; Serial)
            {
            }
            column(Variance; /*NewPayslipReport.ChckRound(Format(*/Round(Difference, RoundValue))
            {
            }
            column(GrossA; /*NewPayslipReport.ChckRound(Format(*/Round(GrossA, RoundValue))
            {
            }
            column(GrossB; /*NewPayslipReport.ChckRound(Format(*/Round(GrossB, RoundValue))
            {
            }
            column(GrossVariance; /*NewPayslipReport.ChckRound(Format(*/Round(GrossVariance, RoundValue))
            {
            }
            column(PercentVariance; Format(Round(PercentVariance, 0.01)) + '%')
            { }
            column(VarName1; VarianceName[1])
            {
            }
            column(VarName2; VarianceName[2])
            {
            }
            column(VarName3; VarianceName[3])
            {
            }
            column(VarName4; VarianceName[4])
            {
            }
            column(VarName5; VarianceName[5])
            {
            }
            column(VarName6; VarianceName[6])
            {
            }
            column(VarName7; VarianceName[7])
            {
            }
            column(VarName8; VarianceName[8])
            {
            }
            column(VarName9; VarianceName[9])
            {
            }
            column(VarName10; VarianceName[10])
            {
            }
            column(VarName11; VarianceName[11])
            {
            }
            column(VarName12; VarianceName[12])
            {
            }
            column(VarName13; VarianceName[13])
            {
            }
            column(VarName14; VarianceName[14])
            {
            }
            column(VarName15; VarianceName[15])
            {
            }
            column(VarAmount1; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[1]), RoundValue))
            {
            }
            column(VarAmount2; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[2]), RoundValue))
            {
            }
            column(VarAmount3; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[3]), RoundValue))
            {
            }
            column(VarAmount4; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[4]), RoundValue))
            {
            }
            column(VarAmount5; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[5]), RoundValue))
            {
            }
            column(VarAmount6; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[6]), RoundValue))
            {
            }
            column(VarAmount7; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[7]), RoundValue))
            {
            }
            column(VarAmount8; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[8]), RoundValue))
            {
            }
            column(VarAmount9; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[9]), RoundValue))
            {
            }
            column(VarAmount10; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[10]), RoundValue))
            {
            }
            column(VarAmount11; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[11]), RoundValue))
            {
            }
            column(VarAmount12; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[12]), RoundValue))
            {
            }
            column(VarAmount13; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[13]), RoundValue))
            {
            }
            column(VarAmount14; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[14]), RoundValue))
            {
            }
            column(VarAmount15; /*NewPayslipReport.ChckRound(Format(*/Round(ABS(VarianceAmount[15]), RoundValue))
            {
            }
            column(Payroll_Country; SelectedPayrollCountry/*Employee."Payroll Country"*/)
            { }
            column(Comments; Comments)
            { }
            column(PeriodTitle; /*UpperCase(SelectedPayrollCountry + ' FROM ' + Format(PreviousMonth, 0, '<Month Text> <Year4>') + ' TO ' + Format(DateSpecified, 0, '<Month Text> <Year4>'))*/'') // + ' (' + CountryCurrency + ')'
            { }
            column(SelectedCountryCurrency; SelectedCountryCurrency)
            { }
            column(ReportTitle; ReportTitle)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TransAmount := 0;
                TransAmountPrev := 0;
                TransAmountFcy := 0;
                TransAmountPrevFcy := 0;
                SelectedCountryCurrency := CountryCurrency;
                if SelectedCountryCurrency = '' then begin
                    Countries.Reset();
                    Countries.SetRange(Code, SelectedPayrollCountry);
                    if Countries.FindFirst() then
                        SelectedCountryCurrency := Countries."Country Currency";
                end;
                /*if Employee.GetFilter("Payroll Country") = '' then
                    Error('You must select the payroll country!');*/


                SumMonthA := 0;
                GrossA := 0;
                TerminalDues := false;
                BelongsToThisTDCountry := false;
                CurrentMovementLastDate := 0D;
                PrevPeriod := CalcDate('-1M', DateSpecified);
                Movement.Reset();
                Movement.SetRange("Emp No.", Employee."No.");
                Movement.SetRange("Payroll Country", SelectedPayrollCountry);
                Movement.SetRange(Status, Movement.Status::Current);
                Movement.SetFilter("Last Date", '>=%1', PrevPeriod);
                if Movement.FindFirst() then begin
                    Employee."Terminal Dues" := Movement."Terminal Dues";
                    CurrentMovementLastDate := Movement."Last Date";
                    BelongsToThisTDCountry := true;
                end;

                Comments := '';
                TheresSomeDifferenceInEarnings := false;
                HasSomePartialSalary := false;
                HasPrevPeriodTrans := false;
                HasCurrPeriodTrans := false;
                CurrentEarningsCount := 0;
                PreviousEarningsCount := 0;
                PrevContractualAmountCurency := '';
                PrevContractualAmountVal := 0;
                CurrContractualAmountCurency := '';
                CurrContractualAmountVal := 0;
                PrevPayrollCurency := '';
                CurrPayrollCurency := '';

                SumMonthB := 0;
                GrossB := 0;
                PreviousMonth := CalcDate('<-1M>', DateSpecified);
                LastMonthText := Format(PreviousMonth, 0, '<Month Text>');
                ThisMonthText := Format(DateSpecified, 0, '<Month Text>');

                if not TitleCaptured then begin
                    PayrollTitle := 'PAYROLL VARIANCE REPORT FOR ' + UpperCase(SelectedPayrollCountry);
                    if SelectedPayrollCountry = 'CABIN' then
                        PayrollTitle := 'ALLOWANCES VARIANCE REPORT FOR CABIN MARSHALLS';
                    ReportTitle := PayrollTitle + ' FROM ' + UpperCase(Format(PreviousMonth, 0, '<Month Text> <Year4>') + ' TO ' + Format(DateSpecified, 0, '<Month Text> <Year4>')) + ' IN ' + SelectedCountryCurrency;
                    TitleCaptured := true;
                end;

                //CURRENT
                Amatrix.Reset;
                Amatrix.SetRange(Amatrix."Employee No", Employee."No.");
                Amatrix.SetRange(Amatrix."Payroll Period", DateSpecified);
                Amatrix.SetRange(Amatrix."Non-Cash Benefit", false);
                Amatrix.SetRange(Amatrix.Type, Amatrix.Type::Payment);
                Amatrix.SetRange(Country, /*Employee."Payroll Country"*/SelectedPayrollCountry);
                Amatrix.SetRange("Exclude from Payroll", false);
                if Amatrix.FindSet then begin
                    repeat
                        HasCurrPeriodTrans := true;
                        CurrentEarningsCount += 1;
                        TransAmount := Round(ABS(Amatrix.Amount), RoundValue);
                        //Amatrix.CalcSums(Amount);
                        SumMonthA += TransAmount;
                        if not Amatrix."Reduces Gross" then
                            GrossA += TransAmount;
                        //Check if this earning was there last month
                        Asmatrix.Reset;
                        Asmatrix.SetRange(Asmatrix."Employee No", Employee."No.");
                        Asmatrix.SetRange(Asmatrix."Payroll Period", PreviousMonth);
                        Asmatrix.SetRange(Asmatrix."Non-Cash Benefit", false);
                        Asmatrix.SetRange(Asmatrix.Country, SelectedPayrollCountry);
                        Asmatrix.SetRange(Type, Asmatrix.Type::Payment);
                        Asmatrix.SetRange(Code, Amatrix.Code);
                        Asmatrix.SetRange("Exclude from Payroll", false);
                        if not Asmatrix.FindFirst() then begin
                            if Comments = '' then
                                Comments := 'Got ' + Amatrix.Description // if not found, say it was added this year
                            else begin
                                if StrPos(Comments, 'Exchange Rate') <> 0 then //If exchange rate existed as a variance cause and now we have other reasons, remove exchange rate
                                    Comments := DELSTR(Comments, STRPOS(Comments, 'Exchange Rate'), STRLEN('Exchange Rate'));

                                if Comments = '' then
                                    Comments := 'Got ' + Amatrix.Description
                                else
                                    Comments := Comments + ', Got ' + Amatrix.Description;
                            end;
                        end else begin
                            TransAmountPrev := Round(ABS(Asmatrix.Amount), RoundValue);
                            TransAmountFcy := Round(ABS(Amatrix."Amount In FCY"), RoundValue);
                            TransAmountPrevFcy := Round(ABS(Asmatrix."Amount In FCY"), RoundValue);

                            if ((TransAmountFcy <> 0) and (TransAmountFcy = TransAmountPrevFcy)) and (TransAmount <> 0) and (TransAmountPrev <> 0) and (TransAmount <> TransAmountPrev) /*and (StrPos(Comments, 'change') = 0)*/ then begin
                                if StrPos(Comments, 'Exchange Rate') = 0 then //Exchange rate should only appear once
                                    begin
                                    if Comments = '' then
                                        Comments := 'Exchange Rate';
                                    /*else //If there are other variance reasons, ignore exchange rate
                                        Comments := Comments + ', Exchange Rate';*/
                                end;
                            end
                            else begin
                                //Existed, check if amount changed
                                if TransAmount <> TransAmountPrev then begin
                                    TheresSomeDifferenceInEarnings := true;
                                    //if this earning is a percentage of contractual amount, then capture it as exchange rate then if we have a main change it'll be captured in movement
                                    if (Amatrix."Is from Contractual Amount") or (TransAmountFcy = TransAmountPrevFcy) then begin
                                        if StrPos(Comments, 'Exchange Rate') = 0 then //Exchange rate should only appear once
                                            begin
                                            if Comments = '' then
                                                Comments := 'Exchange Rate';
                                            /*else //If there are other variance reasons, ignore exchange rate
                                                Comments := Comments + ', Exchange Rate';*/
                                        end;
                                    end else begin
                                        if Comments = '' then
                                            Comments := 'Change in ' + Amatrix.Description // if not found, say it was added this month
                                        else begin
                                            if StrPos(Comments, 'Exchange Rate') <> 0 then //If exchange rate existed as a variance cause and now we have other reasons, remove exchange rate
                                                Comments := DELSTR(Comments, STRPOS(Comments, 'Exchange Rate'), STRLEN('Exchange Rate'));

                                            if Comments = '' then
                                                Comments := 'Change in ' + Amatrix.Description
                                            else
                                                Comments := Comments + ', ' + 'Change in ' + Amatrix.Description;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                    until Amatrix.Next() = 0;
                end;

                if GrossA = 0 then begin
                    PeriodMovement.Reset();
                    PeriodMovement.SetRange("Emp No.", Employee."No.");
                    PeriodMovement.SetRange("Payroll Period", DateSpecified);
                    PeriodMovement.SetRange("Payroll Country", SelectedPayrollCountry);
                    if PeriodMovement.FindFirst() then begin
                        TerminalDues := PeriodMovement."Terminal Dues";

                        if (Employee."Terminal Dues") and (not TerminalDues) then begin
                            if CurrentMovementLastDate >= DateSpecified then begin
                                TerminalDues := true;
                                PeriodMovement."Terminal Dues" := TerminalDues;
                                PeriodMovement.Modify();
                            end;
                        end;
                    end;
                end;

                ThisMonthDeductionsThatReduceGross := 0;
                Amatrix.Reset;
                Amatrix.SetRange(Amatrix."Employee No", Employee."No.");
                Amatrix.SetRange(Amatrix."Payroll Period", DateSpecified);
                Amatrix.SetRange(Amatrix."Non-Cash Benefit", false);
                Amatrix.SetRange(Amatrix."Reduces Gross", true);
                Amatrix.SetRange(Amatrix.Type, Amatrix.Type::Deduction);
                Amatrix.SetRange(Country, /*Employee."Payroll Country"*/SelectedPayrollCountry);
                Amatrix.SetRange("Exclude from Payroll", false);
                if Amatrix.FindSet then
                    repeat
                        ThisMonthDeductionsThatReduceGross += Round(ABS(Amatrix.Amount), RoundValue);
                    until Amatrix.Next() = 0;
                GrossA := GrossA - ThisMonthDeductionsThatReduceGross;
                SumMonthA := SumMonthA - ThisMonthDeductionsThatReduceGross;

                /*Asmatrix.Reset;
                Asmatrix.SetRange(Asmatrix."Employee No", Employee."No.");
                Asmatrix.SetRange(Asmatrix."Payroll Period", DateSpecified);
                Asmatrix.SetRange(Asmatrix."Non-Cash Benefit", false);
                Asmatrix.SetRange(Asmatrix.Type, Asmatrix.Type::Payment);
                Asmatrix.SetRange(Country, /*Employee."Payroll Country"/SelectedPayrollCountry);
                Asmatrix.SetRange("Reduces Gross", false);
                if Asmatrix.FindSet then begin
                    Asmatrix.CalcSums(Amount);
                    GrossA := Asmatrix.Amount;
                end;*/

                //PREVIOUS
                Amatrix.Reset;
                Amatrix.SetRange(Amatrix."Employee No", Employee."No.");
                Amatrix.SetRange(Amatrix."Payroll Period", PreviousMonth);
                Amatrix.SetRange(Amatrix."Non-Cash Benefit", false);
                Amatrix.SetRange(Amatrix.Country, SelectedPayrollCountry);
                Amatrix.SetRange(Amatrix.Type, Amatrix.Type::Payment);
                Amatrix.SetRange("Exclude from Payroll", false);
                if Amatrix.FindSet() then begin
                    repeat
                        HasPrevPeriodTrans := true;
                        PreviousEarningsCount += 1;
                        TransAmountPrev := Round(ABS(Amatrix.Amount), RoundValue);
                        SumMonthB += TransAmountPrev;
                        if not Amatrix."Reduces Gross" then
                            GrossB += TransAmountPrev;

                        //We see what was last month and not now
                        Asmatrix.Reset;
                        Asmatrix.SetRange(Asmatrix."Employee No", Employee."No.");
                        Asmatrix.SetRange(Asmatrix."Payroll Period", DateSpecified);
                        Asmatrix.SetRange(Asmatrix."Non-Cash Benefit", false);
                        Asmatrix.SetRange(Asmatrix.Country, SelectedPayrollCountry);
                        Asmatrix.SetRange(Code, Amatrix.Code);
                        Asmatrix.SetRange(Type, Asmatrix.Type::Payment);
                        Asmatrix.SetRange("Exclude from Payroll", false);
                        if not Asmatrix.FindFirst() then begin
                            if Comments = '' then
                                Comments := Amatrix.Description + ' removed' // if not found, say it was removed this month
                            else begin
                                if StrPos(Comments, 'Exchange Rate') <> 0 then //If exchange rate existed as a variance cause and now we have other reasons, remove exchange rate
                                    Comments := DELSTR(Comments, STRPOS(Comments, 'Exchange Rate'), STRLEN('Exchange Rate'));
                                if Comments = '' then
                                    Comments := Amatrix.Description + ' removed' // if not found, say it was removed this month
                                else
                                    Comments := Comments + ', ' + Amatrix.Description + ' removed';
                            end;
                        end; //No else, if it existed we've already captured it up there
                    until Amatrix.Next() = 0;
                end;

                if (GrossB = 0) and (not TerminalDues) then begin
                    PeriodMovement.Reset();
                    PeriodMovement.SetRange("Emp No.", Employee."No.");
                    PeriodMovement.SetRange("Payroll Period", PreviousMonth);
                    PeriodMovement.SetRange("Payroll Country", SelectedPayrollCountry);
                    if PeriodMovement.FindFirst() then begin
                        TerminalDues := PeriodMovement."Terminal Dues";

                        if (Employee."Terminal Dues") and (not TerminalDues) then begin
                            if CurrentMovementLastDate >= PreviousMonth then begin
                                TerminalDues := true;
                                PeriodMovement."Terminal Dues" := TerminalDues;
                                PeriodMovement.Modify();
                            end;
                        end;
                    end;
                end;

                LastMonthDeductionsThatReduceGross := 0;
                Amatrix.Reset;
                Amatrix.SetRange(Amatrix."Employee No", Employee."No.");
                Amatrix.SetRange(Amatrix."Payroll Period", PreviousMonth);
                Amatrix.SetRange(Amatrix."Non-Cash Benefit", false);
                Amatrix.SetRange(Amatrix."Reduces Gross", true);
                Amatrix.SetRange(Amatrix.Type, Amatrix.Type::Deduction);
                Amatrix.SetRange(Country, /*Employee."Payroll Country"*/SelectedPayrollCountry);
                Amatrix.SetRange("Exclude from Payroll", false);
                if Amatrix.FindSet then
                    repeat
                        LastMonthDeductionsThatReduceGross += Round(ABS(Amatrix.Amount), RoundValue);
                    until Amatrix.Next() = 0;
                GrossB := GrossB - LastMonthDeductionsThatReduceGross;
                SumMonthB := SumMonthB - LastMonthDeductionsThatReduceGross;

                //Cater for deductions that reduce gross - mainly overpayment deductions
                OverpaymentDeductionComment := '';
                if (ThisMonthDeductionsThatReduceGross <> 0) and (LastMonthDeductionsThatReduceGross = 0) then
                    OverpaymentDeductionComment := 'Was overpaid in ' + LastMonthText + ' and the amount recovered in ' + ThisMonthText;
                if (ThisMonthDeductionsThatReduceGross = 0) and (LastMonthDeductionsThatReduceGross <> 0) then
                    OverpaymentDeductionComment := 'Had an overpayment recovery in ' + LastMonthText;

                if OverpaymentDeductionComment <> '' then begin
                    if Comments = '' then
                        Comments := OverpaymentDeductionComment
                    else begin
                        if StrPos(Comments, 'Exchange Rate') <> 0 then //If exchange rate existed as a variance cause and now we have other reasons, remove exchange rate
                            Comments := DELSTR(Comments, STRPOS(Comments, 'Exchange Rate'), STRLEN('Exchange Rate'));
                        if Comments = '' then
                            Comments := OverpaymentDeductionComment
                        else
                            Comments := Comments + ', ' + OverpaymentDeductionComment;
                    end;
                end;

                /*Asmatrix.Reset;
                Asmatrix.SetRange(Asmatrix."Employee No", Employee."No.");
                Asmatrix.SetRange(Asmatrix."Payroll Period", PreviousMonth);
                Asmatrix.SetRange(Asmatrix."Non-Cash Benefit", false);
                Asmatrix.SetRange(Asmatrix.Type, Asmatrix.Type::Payment);
                Asmatrix.SetRange(Asmatrix.Country, /*Employee."Payroll Country"/SelectedPayrollCountry);
                Asmatrix.SetRange("Reduces Gross", false);
                if Asmatrix.FindSet then begin
                    Asmatrix.CalcSums(Amount);
                    GrossB := Asmatrix.Amount;
                    /repeat
                        GrossB += Round(GetInDesiredCurrency(Asmatrix."Country Currency", Asmatrix.Country, ABS(Asmatrix.Amount)));
                    until Asmatrix.next() = 0;/
                end;*/

                Difference := 0;
                Difference := SumMonthA - SumMonthB;

                GrossVariance := 0;
                GrossVariance := GrossA - GrossB;

                i := 0;

                Clear(VarianceName);
                Clear(VarianceAmount);

                if (Employee."Terminal Dues") and (not TerminalDues) and (BelongsToThisTDCountry) then //if no movement was created
                    TerminalDues := true;

                if DateSpecified < 20250601D then //Only applies from June 2025 going forward
                    TerminalDues := false;

                if (DateSpecified > 20250601D) and (TerminalDues) then
                    if (CurrentMovementLastDate < DateSpecified) and ((GrossA + GrossB) = 0) then
                        TerminalDues := false;

                if (GrossA = 0) and (GrossB = 0) and (not TerminalDues) then
                    CurrReport.Skip();

                if GrossA = 0 then
                    PercentVariance := -100;
                if GrossB = 0 then
                    PercentVariance := 100;
                if (GrossA <> 0) and (GrossB <> 0) then
                    PercentVariance := ((GrossA - GrossB) / GrossA) * 100;//((GrossA - GrossB) / GrossB) * 100;

                //If this guy is inactive now, and the last date is in last period, and they don't have a movement for last period, create it
                if (Employee.Status = Employee.Status::Inactive) and (Employee."Cause of Inactivity Code" <> '') then begin
                    Movement.Reset();
                    Movement.SetRange("Emp No.", Employee."No.");
                    Movement.SetFilter("Last Date", '<=%1', CalcDate('<CM>', PreviousMonth));
                    Movement.SetRange(Status, Movement.Status::Current);
                    if Movement.FindLast() then begin
                        CausesOfInactivity.Reset();
                        CausesOfInactivity.SetRange("Emp No.", Employee."No.");
                        CausesOfInactivity.SetRange("Payroll Period", PreviousMonth);
                        if not CausesOfInactivity.FindFirst() then begin
                            CausesOfInactivityInit.Reset();
                            CausesOfInactivityInit.Init();
                            CausesOfInactivityInit."Emp No." := Employee."No.";
                            CausesOfInactivityInit."Payroll Period" := PreviousMonth;
                            CausesOfInactivityInit."Cause of Inactivity" := Employee."Cause of Inactivity";
                            CausesOfInactivityInit.Insert();
                        end;

                        //Also update those titled End of term
                        CausesOfInactivity.Reset();
                        CausesOfInactivity.SetRange("Emp No.", Employee."No.");
                        CausesOfInactivity.SetRange("Payroll Period", PreviousMonth);
                        CausesOfInactivity.SetRange("Cause of Inactivity", 'End of term');
                        if CausesOfInactivity.FindFirst() then begin
                            CausesOfInactivity."Cause of Inactivity" := Employee."Cause of Inactivity";
                            CausesOfInactivity.Modify();
                        end;
                    end;
                end;


                /*if Difference = 0 then
                    CurrReport.Skip()
                else begin*/
                PayrollVarianceComments.Reset();
                PayrollVarianceComments.SetRange("Emp No.", Employee."No.");
                PayrollVarianceComments.SetRange("Payroll Period", DateSpecified);
                PayrollVarianceComments.SetFilter(Comment, '<>%1', '');
                if PayrollVarianceComments.FindFirst() then
                    Comments := PayrollVarianceComments.Comment
                else begin
                    //If they joined sometime last month so they got partial salary then and full now, or left this month
                    PeriodMovement.Reset();
                    PeriodMovement.SetRange("Emp No.", Employee."No.");
                    PeriodMovement.SetRange("Payroll Period", DateSpecified);
                    if PeriodMovement.FindFirst() then //This was the current movement of the time
                        begin
                        //Joined last month, so partial then and full now
                        if /*--(PeriodMovement.Type = PeriodMovement.Type::Initial) and--*/ (PeriodMovement."First Date" > PreviousMonth) and (PeriodMovement."First Date" < DateSpecified) and (PeriodMovement."Last Date" >= CalcDate('CM', DateSpecified)) and (HasCurrPeriodTrans) and (HasPrevPeriodTrans) then
                            Comments := 'Got a partial salary in ' + LastMonthText + ' and full salary in ' + ThisMonthText;
                        //Leaving this month, so partial now but full then
                        if (PeriodMovement."First Date" <= PreviousMonth) and (PeriodMovement."First Date" < DateSpecified) and (PeriodMovement."Last Date" < CalcDate('CM', DateSpecified)) and (HasCurrPeriodTrans) and (HasPrevPeriodTrans) then
                            Comments := 'Got a full salary in ' + LastMonthText + ' and partial salary in ' + ThisMonthText;
                        //Partial last month and partial this month
                        if /*--(PeriodMovement.Type = PeriodMovement.Type::Initial) and--*/ (PeriodMovement."First Date" > PreviousMonth) and (PeriodMovement."First Date" < DateSpecified) and (PeriodMovement."Last Date" < CalcDate('CM', DateSpecified)) and (HasCurrPeriodTrans) and (HasPrevPeriodTrans) then
                            Comments := 'Got a partial salary both in ' + LastMonthText + ' and in ' + ThisMonthText + ', but different amounts';
                        //if had some partial pay
                        if StrPos(Comments, 'partial salary') <> 0 then
                            HasSomePartialSalary := true;
                        CurrContractualAmountCurency := PeriodMovement."Contractual Amount Currency";
                        CurrContractualAmountVal := PeriodMovement."Contractual Amount Value";
                        CurrPayrollCurency := PeriodMovement."Payroll Currency";
                    end;

                    Movement.Reset();
                    Movement.SetRange("Emp No.", Employee."No.");
                    Movement.SetFilter("First Date", '<=%1', CalcDate('<CM>', PreviousMonth)/*PreviousMonth*/);
                    Movement.SetFilter("Last Date", '>=%1', CalcDate('<CM>', PreviousMonth) /*PreviousMonth*/);
                    Movement.SetFilter(Status, '%1|%2', Movement.Status::Current, Movement.Status::Past); //The latest movement of that month
                    if Movement.FindLast() then begin
                        PrevContractualAmountCurency := Movement."Contractual Amount Currency";
                        PrevContractualAmountVal := Movement."Contractual Amount Value";
                        PrevPayrollCurency := Movement."Payroll Currency";

                        if (Movement.Type = Movement.Type::Initial) and (HasCurrPeriodTrans) and (not HasPrevPeriodTrans) then
                            Comments := 'Joined in ' + LastMonthText + ' but got paid in ' + ThisMonthText + ' with arrears';
                    end;

                    //If the number of earnings did not change, but some figures changed, we may want to see if it is because of exchange rate differences in contractual amount - if the contractual amount had a different currency
                    if (CurrentEarningsCount = PreviousEarningsCount) and (TheresSomeDifferenceInEarnings) and (PrevPayrollCurency <> PrevContractualAmountCurency) and (CurrContractualAmountCurency <> CurrPayrollCurency) and (PrevContractualAmountVal = CurrContractualAmountVal) and (not HasSomePartialSalary) then begin
                        Comments := 'Exchange Rate';
                    end;

                    modified := false;
                    Movement.Reset();
                    Movement.SetRange("Emp No.", Employee."No.");
                    //Only consider movements that started a day after the beginning of last period,  otherwise there should be no effect in salary ==> Vacated on 21/11/24
                    Movement.SetFilter("First Date", '%1..%2', DateSpecified/*CalcDate('<1D>', PrevPeriod)*/, CalcDate('<CM>', DateSpecified));
                    if Movement.FindLast() then begin
                        /*Comments := Movement.Remarks;
                        if Comments = '' then begin*/
                        if (Movement."Job Title" = '') or (Movement."Department Name" = '') or (Movement."Section Title" = '') then begin
                            Movement.Validate("Position Code");
                            Movement.Validate("Dept Code");
                            Movement.Validate("Section Code");
                            modified := true;
                        end;
                        // and (Movement."First Date" >= DateSpecified)

                        if (Movement.Type = Movement.Type::Initial) or (Movement.Type = Movement.Type::"August 2023") then
                            Comments := 'New Staff as ' + Movement."Job Title"
                        else if (Movement.Type = Movement.Type::"Department/Section") or (Movement.Type = Movement.Type::Station) then begin
                            Comments := 'Transferred from ';//'Transfer/change in ' + Format(Movement.Type)

                            PrevMovement.Reset();
                            PrevMovement.SetRange("Emp No.", Employee."No.");
                            PrevMovement.SetRange(Status, PrevMovement.Status::Past);//The most recent movement
                            if PrevMovement.FindLast() then begin
                                if (Movement.Type = Movement.Type::"Department/Section") then
                                    if PrevMovement."Dept Code" <> Movement."Dept Code" then
                                        Comments := Comments + PrevMovement."Department Name" + ' to ' + Movement."Department Name"
                                    else if PrevMovement."Section Code" <> Movement."Section Code" then
                                        Comments := Comments + PrevMovement."Department Name" + ' to ' + Movement."Department Name"
                                    else
                                        Comments := 'Transfer/change in ' + Format(Movement.Type);
                                if (Movement.Type = Movement.Type::Station) then
                                    Comments := Comments + PrevMovement."Section Title" + ' to ' + Movement."Section Title";
                            end;
                        end
                        else if Movement.Type = Movement.Type::Promotion then
                            Comments := 'Got promoted to ' + Movement."Job Title"
                        else if Movement.Type = Movement.Type::Demotion then
                            Comments := 'Got demoted'// to ' + Movement."Job Title";
                        else if Movement.Type = Movement.Type::Country then
                            Comments := 'Transferred to ' + Movement."Payroll Country" //
                        else if Movement.Type = Movement.Type::Seniority then
                            Comments := 'Got seniority increment'
                        else if Movement.Type = Movement.Type::"Salary Adjustment" then
                            Comments := 'Got a salary adjustment'
                        else if Movement.Type = Movement.Type::"Salary Alignment" then
                            Comments := 'Got a salary alignment'
                        else if (Movement.Type = Movement.Type::"New Appointment") then
                            Comments := 'New appointment to ' + Movement."Job Title"
                        else
                            Comments := format(Movement.Type);// to ' + Format(Movement."Contractual Amount Value") + '(' + Movement."Contractual Amount Currency" + ')';
                        //end;
                        Movement.Modify();
                    end;

                    //If joined last month but first salary is this month (not paid last month)
                    //if Comments = '' then begin
                    //Remove this for now, let's work with the above having expanded date to cover last month
                    /**PrevPeriod := CalcDate('-1M', DateSpecified);
                    Movement.Reset();
                    Movement.SetRange("Emp No.", Employee."No.");
                    Movement.SetFilter("First Date", '%1..%2', PrevPeriod, CalcDate('<CM>', PrevPeriod));
                    Movement.SetRange("Type", Movement."Type"::Initial);
                    if Movement.FindFirst() then begin
                        AssignmentMatrix.Reset();
                        AssignmentMatrix.SetRange("Employee No", Employee."No.");
                        AssignmentMatrix.SetRange("Payroll Period", PrevPeriod);
                        if not AssignmentMatrix.FindFirst() then
                            if Comments = '' then
                                Comments := 'New Staff as ' + Movement."Job Title";
                        /*else
                            Comments := Comments + ' New Staff as ' + Movement."Job Title";/
                end;*/
                    ///end;

                    //if Comments = '' then begin
                    /*Movement.Reset();
                    Movement.SetRange("Emp No.", Employee."No.");
                    Movement.SetFilter("Last Date", '<=%1', CalcDate('<CM>', DateSpecified));
                    if Movement.FindLast() then begin
                        if Comments = '' then
                            Comments := Employee."Cause of Inactivity";
                        /else
                            Comments := Comments + ', ' + Employee."Cause of Inactivity";/
                        //end;
                    end;*/

                    CausesOfInactivity.Reset();
                    CausesOfInactivity.SetRange("Emp No.", Employee."No.");
                    CausesOfInactivity.SetRange("Payroll Period", DateSpecified);
                    CausesOfInactivity.SetFilter("Cause of Inactivity", '<>%1', '');
                    if CausesOfInactivity.FindFirst() then
                        Comments := CausesOfInactivity."Cause of Inactivity"

                    /*if Comments = ''*/
                    else //If the cause of inactivity falls last period
                        begin
                        CausesOfInactivity.Reset();
                        CausesOfInactivity.SetRange("Emp No.", Employee."No.");
                        CausesOfInactivity.SetRange("Payroll Period", PreviousMonth);
                        CausesOfInactivity.SetFilter("Cause of Inactivity", '<>%1', '');
                        if CausesOfInactivity.FindFirst() then
                            Comments := CausesOfInactivity."Cause of Inactivity";
                    end;
                end;
                if (PercentVariance = 0) and (Comments = '') then
                    Comments := 'No change';

                /*Earnings.Reset;
                Earnings.SetRange(Earnings."Non-Cash Benefit", false);
                Earnings.SetRange(Country, Employee."Payroll Country");
                if Earnings.FindSet then begin
                    repeat
                        CurrEarning := 0;
                        PrevEarning := 0;

                        Asmatrix.Reset;
                        Asmatrix.SetRange(Asmatrix."Employee No", Employee."No.");
                        Asmatrix.SetRange(Asmatrix."Payroll Period", DateSpecified);
                        Asmatrix.SetRange(Asmatrix."Non-Cash Benefit", false);
                        Asmatrix.SetRange(Asmatrix.Type, Asmatrix.Type::Payment);
                        Asmatrix.SetRange(Asmatrix.Code, Earnings.Code);
                        if Asmatrix.FindSet then begin
                            CurrEarning := Asmatrix.Amount;
                        end;

                        AsmatrixP.Reset;
                        AsmatrixP.SetRange(AsmatrixP."Employee No", Employee."No.");
                        AsmatrixP.SetRange(AsmatrixP."Payroll Period", PreviousMonth);
                        AsmatrixP.SetRange(AsmatrixP."Non-Cash Benefit", false);
                        AsmatrixP.SetRange(AsmatrixP.Type, AsmatrixP.Type::Payment);
                        Asmatrix.SetRange(Asmatrix.Code, Earnings.Code);
                        Asmatrix.SetRange(Country, Employee."Payroll Country");
                        if AsmatrixP.FindSet then begin
                            PrevEarning := AsmatrixP.Amount;
                        end;

                        //MESSAGE('%1 :: CurrEarning %2 - PrevEarning %3 = %4',Earnings.Description,CurrEarning,PrevEarning,(CurrEarning-PrevEarning));

                        if (CurrEarning - PrevEarning) <> 0 then begin
                            i += 1;
                            VarianceName[i] := Earnings.Description;
                            VarianceAmount[i] := CurrEarning - PrevEarning;
                        end;

                    until Earnings.Next = 0;
                end;*/
            end;

            trigger OnPreDataItem()
            begin
                Serial := 0;
                if SelectedPayrollCountry = '' then
                    Error('You must select the payroll country!');

                if (not CanEditPaymentInfo) and (DateSpecified = CurrentPeriod) then
                    Error('Payroll for this period is still being processed. Kindly try again later!');

                RoundValue := 1;
                Countries.Reset();
                Countries.SetRange(Code, SelectedPayrollCountry);
                if Countries.FindFirst() then
                    CountryCurrency := Countries."Country Currency";
                if CountryCurrency = 'USD' then
                    RoundValue := 0.01;

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
                    TableRelation = "Payroll Period"."Starting Date";// WHERE(Closed = FILTER(false));
                }
                field("Payroll Country"; SelectedPayrollCountry)
                {
                    Tablerelation = "Country/Region";
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                DateSpecified := Periods."Starting Date";

            CurrentPeriod := DateSpecified;
            RoundValue := 1;

            Countries.Reset();
            Countries.SetRange(Code, SelectedPayrollCountry);
            if Countries.FindFirst() then
                CountryCurrency := Countries."Country Currency";
            if CountryCurrency = 'USD' then
                RoundValue := 0.01;

            CanEditPaymentInfo := false;
            UserSetup.Reset();
            UserSetup.SetRange("User ID", UserId);
            if UserSetup.FindFirst() then
                CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Comp.Get();
        Comp.CalcFields(Picture);
    end;

    procedure SetReportFilter(InitialCountry: Code[50]; periodFilter: Date)
    begin
        SelectedPayrollCountry := InitialCountry;

        Periods.Reset();
        //Periods.SetRange(Closed, false);
        Periods.SetFilter("Starting Date", '%1', periodFilter);
        if Periods.FindFirst() then
            DateSpecified := Periods."Starting Date";
        RoundValue := 1;

        Countries.Reset();
        Countries.SetRange(Code, SelectedPayrollCountry);
        if Countries.FindFirst() then
            CountryCurrency := Countries."Country Currency";
        if CountryCurrency = 'USD' then
            RoundValue := 0.01;
    end;

    var
        DateSpecified: Date;
        PrevPeriod: Date;
        AssignmentMatrix: Record "Assignment Matrix";
        Amatrix: Record "Assignment Matrix";
        SumMonthA: Decimal;
        PreviousMonth: Date;
        SumMonthB: Decimal;
        Comp: Record "Company Information";
        Serial: Integer;
        Difference: Decimal;
        GrossA: Decimal;
        GrossB: Decimal;
        Asmatrix: Record "Assignment Matrix";
        GrossVariance: Decimal;
        PercentVariance: Decimal;
        VarianceAmount: array[20] of Decimal;
        VarianceName: array[20] of Text;
        Earnings: Record Earnings;
        AsmatrixP: Record "Assignment Matrix";
        i: Integer;
        CurrEarning: Decimal;
        PrevEarning: Decimal;
        Periods: Record "Payroll Period";
        Comments: Text[400];
        TransAmount: Decimal;
        TransAmountPrev: Decimal;
        TransAmountFcy: Decimal;
        TransAmountPrevFcy: Decimal;
        PayrollVarianceComments: Record "Payroll Variance Comments";
        Movement: Record "Internal Employement History";
        PrevMovement: Record "Internal Employement History";
        PeriodMovement: Record "Period Prevailing Movement";
        CausesOfInactivity: Record "Period Causes of Inactivity";
        CausesOfInactivityInit: Record "Period Causes of Inactivity";
        SelectedPayrollCountry: Code[100];
        NewPayslipReport: Report "New Payslip";
        RoundValue: Decimal;
        CountryCurrency: Code[50];
        SelectedCountryCurrency: Code[50];
        Countries: Record "Country/Region";
        PayrollCountry: Record "Country/Region";
        TheresSomeDifferenceInEarnings: Boolean;
        PreviousEarningsCount: Integer;
        CurrentEarningsCount: Integer;
        PrevContractualAmountCurency: Code[100];
        PrevContractualAmountVal: Decimal;
        CurrContractualAmountCurency: Code[100];
        CurrContractualAmountVal: Decimal;
        PrevPayrollCurency: Code[100];
        CurrPayrollCurency: Code[100];
        HasSomePartialSalary: Boolean;
        HasPrevPeriodTrans: Boolean;
        HasCurrPeriodTrans: Boolean;
        UserSetup: Record "User Setup";
        CanEditPaymentInfo: Boolean;
        CurrentPeriod: Date;
        modified: Boolean;
        LastMonthText: Text[50];
        ThisMonthText: Text[50];
        LastMonthDeductionsThatReduceGross: Decimal;
        ThisMonthDeductionsThatReduceGross: Decimal;
        OverpaymentDeductionComment: Text;
        ReportTitle: Text[250];
        PayrollTitle: Text[100];
        TitleCaptured: Boolean;
        TerminalDues: Boolean;
        BelongsToThisTDCountry: Boolean;
        CurrentMovementLastDate: Date;

}