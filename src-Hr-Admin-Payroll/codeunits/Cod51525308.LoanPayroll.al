codeunit 51525308 "Loan-Payroll"
{
    trigger OnRun()
    begin
    end;

    var
        AmountRemaining: Decimal;
        TaxableAmount: Decimal;
        TaxCode: Code[20];
        IncomeTax: Decimal;
        GrossTaxCharged: Decimal;
        relief: Decimal;
        PayPeriod: Record "Payroll Period";
        BeginDate: Date;
        BasicSalary: Decimal;
        CompRec: Record "Human Resources Setup";
        HseLimit: Decimal;
        Emp: Record Employee;
        retirecontribution: Decimal;
        ExcessRetirement: Decimal;
        PAYE: Decimal;
        TaxablePay: Decimal;
        EmpRec: Record Employee;
        BfMpr: Decimal;
        CfMpr: Decimal;
        GrossPay: Decimal;
        TotalBenefits: Decimal;
        RetireCont: Decimal;
        TotalQuarters: Decimal;
        LowInterestBenefits: Decimal;
        Netpay: Decimal;
        Earnings: Record Earnings;
        TerminalDues: Decimal;
        Earn: Record Earnings;
        TaxTable: Record "Brackets Lines";
        Ded: Record Deductions;
        i: Integer;
        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        Text065: Label 'AND // text0028 removed the AND';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        mine: Text[30];
        DisabilityRelief: Decimal;
        AssignmentMatrixRec: Record "Assignment Matrix";
        PensionAdd: Decimal;
        AddBack: Decimal;
        Posting: Record "Staff Posting Group";
        Empl: Record Employee;
        GratuityAmount: Decimal;
        PayrollSetup: Record "Payroll Setup";
        HrSetup: Record "Human Resources Setup";
        EmployeeNssfContribution: Decimal;
        DeductionsT: Record Deductions;
        PensionReliefAmt: Decimal;


    procedure GetTaxBracket(var TaxableAmount: Decimal; var TaxCountry: Code[30]) GetTaxBracket: Decimal
    var
        TaxTable: Record "Brackets Lines";
        TotalTax: Decimal;
        Tax: Decimal;
        EndTax: Boolean;
        Deduction: Record Deductions;
        BracketHeader: Record "Bracket Tables";
        PreviousUpperLimit: Decimal;
    begin
        /*CompRec.Get;
        TaxCode := CompRec."Tax Table";*/
        TaxCode := '';

        Deduction.reset;
        Deduction.setrange("PAYE Code", true);
        Deduction.SetRange(Country, TaxCountry);
        if Deduction.findfirst then
            TaxCode := Deduction."Deduction Table";

        //If it's on a graduating scale then proceed with below
        BracketHeader.reset;
        BracketHeader.setrange("Bracket Code", TaxCode);
        BracketHeader.setrange(Country, TaxCountry);
        if BracketHeader.findfirst then begin
            if BracketHeader.Type = BracketHeader.Type::"Graduating Scale" then begin
                //MESSAGE('Total Tax %1 TaxCode %2 Taxable Pay %3', FORMAT(TotalTax), TaxCode, Format(TaxableAmount));
                AmountRemaining := TaxableAmount;
                PreviousUpperLimit := 0;

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
                                //TotalTax := TotalTax + Tax;
                            end
                            else begin
                                //Deducted 1 here and got the xact figures just chek incase this may have issues
                                //Only the amount in the last Tax band had issues.
                                AmountRemaining := AmountRemaining - PreviousUpperLimit;//TaxTable."Lower Limit";
                                Tax := AmountRemaining * TaxTable.Percentage / 100;
                                EndTax := true;
                                //TotalTax := TotalTax + Tax;
                            end;
                        end;
                        //If there's anything extra
                        if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::Deduct then
                            Tax := Tax - TaxTable."Extra Amount Value";
                        if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::"Add" then
                            Tax := Tax + TaxTable."Extra Amount Value";
                        if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::Multiply then
                            Tax := Tax * TaxTable."Extra Amount Value";

                        TotalTax := TotalTax + Tax;
                        PreviousUpperLimit := TaxTable."Upper Limit";
                    until (TaxTable.Next = 0) or EndTax = true;
                end;
            end;

            if BracketHeader.Type = BracketHeader.Type::"Fixed" then begin
                //Cases where the PAYE table is fixed
                TaxTable.Reset;
                TaxTable.SetRange("Table Code", TaxCode);
                if TaxTable.Find('-') then begin
                    repeat
                        if (TaxTable."Lower Limit" <= TaxableAmount) and (TaxTable."Upper Limit" >= TaxableAmount) then begin
                            if TaxTable.Percentage <> 0 then
                                TotalTax := TaxableAmount * TaxTable.Percentage / 100;
                            if TaxTable.Amount <> 0 then
                                TotalTax := TaxTable.Amount;
                            //Message('Band %1 | Taxable %2 | Totaltax %3', TaxTable."Tax Band", TaxableAmount, TotalTax);

                            //If there's anything extra
                            if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::Deduct then
                                TotalTax := TotalTax - TaxTable."Extra Amount Value";
                            if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::"Add" then
                                TotalTax := TotalTax + TaxTable."Extra Amount Value";
                            if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::Multiply then
                                TotalTax := TotalTax * TaxTable."Extra Amount Value";
                            //MESSAGE('-> Total Tax %1', TotalTax);
                        end;
                    until TaxTable.Next = 0;
                end;
            end;
        end;
        TotalTax := TotalTax;

        //TotalTax := Round(TotalTax, 0.5, '>');//,'<' //Don't round here, we'll use payroll setup

        IncomeTax := -TotalTax;
        //MESSAGE('Total Tax %1', FORMAT(TotalTax));
        //GetTaxBracket:=ROUND(TotalTax,1,'<');
        GetTaxBracket := TotalTax;
    end;


    procedure GetNonTaxTableDeduction(TotalAllowance: Decimal; var TaxCountry: Code[30]; DeductionCode: Code[30]; TblCode: Code[50]; NssfTier: Integer) TotalDeduction: Decimal
    var
        TaxTable: Record "Brackets Lines";
        TaxTable1: Record "Brackets Lines";
        TotalTax: Decimal;
        Tax: Decimal;
        EndTax: Boolean;
        Deduction: Record Deductions;
        BracketHeader: Record "Bracket Tables";
        TableCode: Code[100];
        Tier1Limit: Decimal;
        EarningsRec: Record Earnings;
        PreviousUpperLimit: Decimal;
    begin
        if TblCode <> '' then
            TableCode := TblCode
        else begin
            TableCode := '';
            Deduction.reset;
            Deduction.setrange(Code, DeductionCode);
            Deduction.SetRange(Country, TaxCountry);
            if Deduction.findfirst then
                TableCode := Deduction."Deduction Table";

            //Accommodate earnings
            if TableCode = '' then begin
                EarningsRec.reset;
                EarningsRec.setrange(Code, DeductionCode);
                EarningsRec.SetRange(Country, TaxCountry);
                if EarningsRec.findfirst then
                    TableCode := EarningsRec."Earning Table";
            end;
        end;
        //Message('TableCode %1', TableCode);

        //If it's on a graduating scale then proceed with below
        BracketHeader.reset();
        BracketHeader.setrange("Bracket Code", TableCode);
        BracketHeader.setrange(Country, TaxCountry);
        if BracketHeader.findfirst then begin
            if BracketHeader.Type = BracketHeader.Type::"Graduating Scale" then begin
                AmountRemaining := TotalAllowance;
                PreviousUpperLimit := 0;

                EndTax := false;
                TaxTable.Reset;
                TaxTable.SetRange("Table Code", TableCode);
                if TaxTable.Find('-') then begin
                    repeat
                        if AmountRemaining <= 0 then
                            EndTax := true
                        else begin
                            if Round((TotalAllowance), 0.01) >= TaxTable."Upper Limit" then begin
                                Tax := (TaxTable."Taxable Amount" * TaxTable.Percentage / 100);
                                //Tax:=ROUND(Tax,0.01);
                                //TotalTax := TotalTax + Tax;
                            end
                            else begin
                                //Deducted 1 here and got the xact figures just chek incase this may have issues
                                //Only the amount in the last Tax band had issues.
                                AmountRemaining := AmountRemaining - PreviousUpperLimit;//TaxTable."Lower Limit";
                                Tax := AmountRemaining * TaxTable.Percentage / 100;
                                EndTax := true;
                                //TotalTax := TotalTax + Tax;
                            end;
                        end;
                        //If there's anything extra
                        if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::Deduct then
                            Tax := Tax - TaxTable."Extra Amount Value";
                        if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::"Add" then
                            Tax := Tax + TaxTable."Extra Amount Value";
                        if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::Multiply then
                            Tax := Tax * TaxTable."Extra Amount Value";

                        TotalTax := TotalTax + Tax;
                        PreviousUpperLimit := TaxTable."Upper Limit";
                    until (TaxTable.Next = 0) or EndTax = true;
                end;
            end;

            if BracketHeader.Type = BracketHeader.Type::"Fixed" then begin
                //Message('2. TotalAllowance %1', TotalAllowance);
                //Cases where the PAYE table is fixed
                TaxTable.Reset;
                TaxTable.SetRange("Table Code", TableCode);
                if TaxTable.Find('-') then begin
                    repeat
                        if NssfTier <> 0 then begin //is NSSF
                            //Tier 1
                            if (TaxTable."Tier No." = 1) and (NssfTier = 1) then begin
                                if TotalAllowance <= TaxTable."Taxable Amount" then begin
                                    TotalTax := (TaxTable.Percentage / 100) * TotalAllowance;
                                end else begin
                                    TotalTax := TaxTable.Amount;
                                end;
                            end;
                            //Tier 2
                            if (TaxTable."Tier No." = 2) and (NssfTier = 2) then begin
                                Tier1Limit := 7000;
                                TaxTable1.Reset;
                                TaxTable1.SetRange("Table Code", TableCode);
                                TaxTable1.SetRange("Tier No.", 1);
                                if TaxTable1.FindFirst() then
                                    Tier1Limit := TaxTable1."Upper Limit";

                                AmountRemaining := TotalAllowance - Tier1Limit;
                                if AmountRemaining <= TaxTable."Taxable Amount" then begin
                                    TotalTax := (TaxTable.Percentage / 100) * AmountRemaining;
                                end else begin
                                    TotalTax := TaxTable.Amount;
                                    AmountRemaining := 0;
                                end;
                            end;
                        end else begin
                            if (TaxTable."Lower Limit" <= TotalAllowance) and (TaxTable."Upper Limit" >= TotalAllowance) then begin
                                if TaxTable.Percentage <> 0 then
                                    TotalTax := TotalAllowance * TaxTable.Percentage / 100;
                                if TaxTable.Amount <> 0 then
                                    TotalTax := TaxTable.Amount;
                                //Message('TotalTax %1', TotalTax);

                                //If there's anything extra
                                if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::Deduct then
                                    TotalTax := TotalTax - TaxTable."Extra Amount Value";
                                if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::"Add" then
                                    TotalTax := TotalTax + TaxTable."Extra Amount Value";
                                if TaxTable."Extra Amount Formula" = TaxTable."Extra Amount Formula"::Multiply then
                                    TotalTax := TotalTax * TaxTable."Extra Amount Value";
                            end;
                        end;
                    until TaxTable.Next = 0;
                end;
            end;
        end;
        TotalTax := TotalTax;
        TotalDeduction := TotalTax;
    end;


    procedure GetPayPeriod()
    begin
        PayPeriod.SetRange(PayPeriod."Close Pay", false);
        if PayPeriod.Find('-') then begin
            //PayPeriodtext:=PayPeriod.Name;
            BeginDate := PayPeriod."Starting Date";
        end;
    end;


    procedure CalculateTaxableAmount(var EmployeeNo: Code[20]; var DateSpecified: Date; var FinalTax: Decimal; var TaxableAmountNew: Decimal; var RetirementCont: Decimal; var EmpCountry: Code[50]; var SpecialTransportAllowanceTaxableIncome: Decimal; var IsGivenSpecialTransportAllowance: Boolean; var SpecialTransportAllowancePAYE: Decimal)
    var
        Assignmatrix: Record "Assignment Matrix";
        EmpRec: Record Employee;
        EarnRec: Record Earnings;
        InsuranceRelief: Decimal;
        PersonalRelief: Decimal;
        HRSetup: Record "Human Resources Setup";
        Assignmatrix7: Record "Assignment Matrix";
        Bracketrec: Record "Brackets Lines";
        MortgageRelief: Decimal;
        GAmount: Decimal;
        PensionLimitAmount: Decimal;
        OtherDeductibles: Decimal;
    begin
        CfMpr := 0;
        FinalTax := 0;
        i := 0;
        TaxableAmount := 0;
        RetirementCont := 0;
        InsuranceRelief := 0;
        PersonalRelief := 0;
        ExcessRetirement := 0;
        PensionAdd := 0;
        AddBack := 0;
        GratuityAmount := 0;
        SpecialTransportAllowanceTaxableIncome := 0;
        //Get payroll period
        GetPayPeriod;
        //PayrollSetup.Get(1);
        PensionLimitAmount := 0;
        OtherDeductibles := 0;
        HrSetup.Get;
        if DateSpecified = 0D then
            Error('Pay period must be specified for this report');

        // Taxable Amount
        EmpRec.Reset;
        EmpRec.SetRange(EmpRec."No.", EmployeeNo);
        EmpRec.SetRange("Pay Period Filter", DateSpecified);
        if EmpRec.Find('-') then begin
            EmpRec."Payroll Country" := EmpCountry;
            if (EmpRec."Pays tax" = true) or (EmpRec.Disabled) then begin

                //get the pension limit set on the paye code of this country's deductions
                Ded.Reset;
                Ded.SetRange(Ded."PAYE Code", true);
                Ded.SetRange(Country, EmpRec."Payroll Country");
                if Ded.findfirst then
                    PensionLimitAmount := Ded."Pension Limit Amount";
                /*
              //Get Taxable amount from assigment matrix
              AssignmentMatrixRec.RESET;
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec."Employee No",EmployeeNo);
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec."Payroll Period",DateSpecified);
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec.Taxable,TRUE);
              IF AssignmentMatrixRec.FINDFIRST THEN
                REPEAT
                  TaxableAmount:=TaxableAmount+AssignmentMatrixRec.Amount;
                  UNTIL AssignmentMatrixRec.NEXT=0;
                */
                EmpRec.CalcFields(EmpRec."Total Allowances", "Tax Deductible Amount", "Relief Amount", "Taxable Allowance");
                //TaxableAmount:=EmpRec."Total Allowances";// -ABS(EmpRec."Relief Amount");
                //We are using staff movement data, so I'll calculate taxable allowance manually down there
                //=>TaxableAmount := EmpRec."Taxable Allowance";
                //MESSAGE(FORMAT(TaxableAmount));
                //MESSAGE('TotAll = %1, Taxable=%2',EmpRec."Total Allowances",EmpRec."Taxable Allowance");
                Ded.Reset;
                Ded.SetRange(Ded."Tax deductible", true);
                Ded.SetRange(Country, EmpRec."Payroll Country");
                if Ded.Find('-') then begin
                    repeat

                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Deduction);
                        Assignmatrix.SetRange(Assignmatrix.Code, Ded.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        //Assignmatrix.SetRange("Tax Deductible", true);
                        if Assignmatrix.Find('-') then begin
                            /*
                            IF Ded."Pension Limit Amount">0 THEN BEGIN
                                  IF ABS(Assignmatrix.Amount)>Ded."Pension Limit Amount" THEN
                                      RetirementCont:=ABS(RetirementCont)+Ded."Pension Limit Amount"
                                  ELSE
                                      RetirementCont:=ABS(RetirementCont)+ABS(Assignmatrix.Amount);
                            END;
                            */
                            //MESSAGE('MatrixAmount%1',Assignmatrix.Amount);
                            if Ded."Pension Scheme" then begin
                                if Assignmatrix.Amount <> 0 then begin
                                    RetirementCont := Abs(RetirementCont) + Abs(Assignmatrix.Amount);
                                end;
                                //Employer contribution Pension
                                if Ded."Employer Contibution Taxed" = true then begin
                                    ExcessRetirement := ExcessRetirement + Abs(Assignmatrix."Employer Amount");
                                end;
                            end else begin
                                OtherDeductibles += Abs(Assignmatrix.Amount);
                                if Ded."Is Statutory" then
                                    SpecialTransportAllowanceTaxableIncome -= Abs(Assignmatrix.Amount);
                            end;
                        end;
                    until Ded.Next = 0;
                end;

                //Tax deductible tax earnings (tax reliefs like that of Ghana)
                EarnRec.Reset;
                //EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Tax Relief");
                EarnRec.SetRange("Reduces Taxable Amt", true);
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if (EarnRec.Find('-')) then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        if Assignmatrix.Find('-') then begin
                            OtherDeductibles := OtherDeductibles + Assignmatrix.Amount;
                            if EarnRec."Is Statutory" then
                                SpecialTransportAllowanceTaxableIncome -= Abs(Assignmatrix.Amount);
                        end;
                    until EarnRec.Next = 0;
                end;

                //Deduct other deductibles without limits
                //Message('TaxableAmount %1 | RetirementCont %2 | OtherDeductibles %3 | PensionLimitAmount %4', TaxableAmount, RetirementCont, OtherDeductibles, PensionLimitAmount);
                TaxableAmount := TaxableAmount - OtherDeductibles;

                HRSetup.Get;
                if RetirementCont > PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                    RetirementCont := PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                    if RetirementCont <> 0 then begin
                        TaxableAmount := TaxableAmount - RetirementCont;
                        SpecialTransportAllowanceTaxableIncome -= RetirementCont;
                    end;
                    if ExcessRetirement > 0 then
                        TaxableAmount := TaxableAmount + ExcessRetirement;
                end;
                PensionAdd := 0;
                if RetirementCont < PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                    PensionAdd := ExcessRetirement + RetirementCont;
                    if PensionAdd > PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin

                        AddBack := PensionAdd - PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                        TaxableAmount := TaxableAmount + AddBack - PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                    end;
                    if PensionAdd <= PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                        TaxableAmount := TaxableAmount - PensionAdd;//Subtract changed to Addition//Engineer
                                                                    //PensionAdd:=0;
                    end;
                    //TaxableAmount:=TaxableAmount+PensionAdd;
                end;
                //MESSAGE('Pension Add = %1', PensionAdd);
                //MESSAGE('TaxableAmount = %1', TaxableAmount);


                //Taxable Non-Cash Benefits //But for the sake of the movement logic, compute all allowances here
                EarnRec.Reset;
                //=>EarnRec.SetRange("Non-Cash Benefit", true);
                EarnRec.SetRange(Taxable, true);
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        //if/*(((EarnRec."Non-Cash Benefit" = true) and*/ (EarnRec.Taxable = true) then//) OR (EarnRec."Normal Earning" = true)) then
                        //begin
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        Assignmatrix.SetRange("Exclude from Payroll", false);
                        if Assignmatrix.Find('-') then begin
                            TaxableAmount := TaxableAmount + Assignmatrix.Amount;
                            if EarnRec."Is Statutory" then
                                SpecialTransportAllowanceTaxableIncome += Abs(Assignmatrix.Amount);
                        end;
                    //end;
                    until EarnRec.Next = 0;
                end;
                //MESSAGE('TaxableAmount = %1', TaxableAmount);
                /*
           //Taxable other Earnings //Leave encashment gratuity accrued
                 EarnRec.RESET;
                 EarnRec.SETRANGE(Gratuity,FALSE);
                 EarnRec.SETFILTER(Code,'<>E10');//FIX This
                 EarnRec.SETRANGE("Basic Salary Code",FALSE);
                 EarnRec.SETRANGE(Taxable,TRUE);
                 IF EarnRec.FIND('-') THEN BEGIN
                 REPEAT
                   Assignmatrix.RESET;
                   Assignmatrix.SETRANGE(Assignmatrix."Payroll Period",DateSpecified);
                   Assignmatrix.SETRANGE(Type,Assignmatrix.Type::Payment);
                   Assignmatrix.SETRANGE(Assignmatrix.Code,EarnRec.Code);
                   Assignmatrix.SETRANGE(Assignmatrix."Employee No",EmployeeNo);
                   IF Assignmatrix.FIND('-') THEN
                   TaxableAmount:=TaxableAmount+Assignmatrix.Amount;
                 UNTIL EarnRec.NEXT=0;
                END;
                */

                //Telephone Allowance <<Taxable percentage added to taxable amount>>
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Telephone Allowance");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        Assignmatrix.SetRange("Exclude from Payroll", false);
                        if Assignmatrix.Find('-') then begin
                            if EarnRec."Taxable Percentage" <> 0 then
                                TaxableAmount := TaxableAmount + (Assignmatrix.Amount * (EarnRec."Taxable Percentage" / 100));
                        end;
                    until EarnRec.Next = 0;
                end;

                // Low Interest Benefits
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Low Interest");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        Assignmatrix.SetRange("Exclude from Payroll", false);
                        if Assignmatrix.Find('-') then
                            TaxableAmount := TaxableAmount + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;

                //Disability Relief JK
                DisabilityRelief := 0;
                /*EarnRec.RESET;
                EarnRec.SETCURRENTKEY(EarnRec."Earning Type");
                EarnRec.SETRANGE(EarnRec."Earning Type",EarnRec."Earning Type"::"Disability Relief");
                IF EarnRec.FIND('-') THEN BEGIN
                 REPEAT
                  Assignmatrix.RESET;
                  Assignmatrix.SETRANGE(Assignmatrix."Payroll Period",DateSpecified);
                  Assignmatrix.SETRANGE(Type,Assignmatrix.Type::Payment);
                  Assignmatrix.SETRANGE(Assignmatrix.Code,EarnRec.Code);
                  Assignmatrix.SETRANGE(Assignmatrix."Employee No",EmployeeNo);
                  IF Assignmatrix.FIND('-') THEN BEGIN
                  DisabilityRelief:=Assignmatrix.Amount;
                  TaxableAmount:=TaxableAmount-EarnRec."Maximum Limit";
                  END;
                  UNTIL EarnRec.NEXT=0;
                END;*/
                //23/2/23 Updated disability/exemption relief
                DisabilityRelief := 0;
                if EmpRec.Disabled then
                    DisabilityRelief := HrSetup."Max Tax Exemption Amount";// PayrollSetup."Max Tax Exemption Amount";
                TaxableAmount := TaxableAmount - DisabilityRelief;
                SpecialTransportAllowanceTaxableIncome -= Abs(DisabilityRelief);

                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec.Gratuity, true);
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        Assignmatrix.SetRange("Exclude from Payroll", false);
                        if Assignmatrix.Find('-') then begin
                            GratuityAmount += Assignmatrix.Amount;
                            /*
                             IF EarnRec."Max Taxable Amount" < Assignmatrix.Amount THEN
                             TaxableAmount:=TaxableAmount-EarnRec."Max Taxable Amount"
                             ELSE
                             TaxableAmount:=TaxableAmount-Assignmatrix.Amount;*/
                        end;
                    until EarnRec.Next = 0;
                end;

                /*GAmount := 0;
                EarnRec.Reset;
                //EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                EarnRec.SETRANGE(EarnRec.Gratuity,TRUE);
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Assignmatrix."Non-Cash Benefit", false);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        if Assignmatrix.Find('-') then begin
                            GAmount += Assignmatrix.Amount;
                            //
                             IF EarnRec."Max Taxable Amount" < Assignmatrix.Amount THEN
                             TaxableAmount:=TaxableAmount-EarnRec."Max Taxable Amount"
                             ELSE
                             TaxableAmount:=TaxableAmount-Assignmatrix.Amount;//
                        end;
                    until EarnRec.Next = 0;
                end;*/


                //MESSAGE('Grat %1 taxableA %2 GAmount %3 Diff %4', GratuityAmount, TaxableAmount, GAmount, GAmount - TaxableAmount);

                //FRED 24/2/23 - Get employee NSSF
                EmployeeNssfContribution := 0; //Already catered for by pension deductions up there
                                               /*DeductionsT.Reset;
                                               DeductionsT.SetRange(DeductionsT."NSSF Deduction", true);
                                               DeductionsT.SetRange(Country, EmpRec."Payroll Country");
                                               if DeductionsT.FindFirst then begin
                                                   repeat
                                                       Assignmatrix.Reset;
                                                       Assignmatrix.SetRange("Payroll Period", DateSpecified);
                                                       Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                                                       Assignmatrix.SetRange(Code, DeductionsT.Code);
                                                       if Assignmatrix.FindSet then begin
                                                           repeat
                                                               EmployeeNssfContribution += Abs(Assignmatrix.Amount);
                                                           //MESSAGE('Amt = %1',Assignmatrix.Amount);
                                                           until Assignmatrix.Next = 0;
                                                       end;
                                                   until DeductionsT.Next = 0;
                                               end;*/

                //check here
                /*PensionReliefAmt := GratuityAmount + EmployeeNssfContribution;
                //MESSAGE('%1 = %2 = %3 = %4',GAmount,TaxableAmount,HRSetup."Pension Limit Amount",GratuityAmount);
                if GAmount - TaxableAmount <> PensionLimitAmount/*HRSetup."Pension Limit Amount"// then begin
                    if //GratuityAmount//PensionReliefAmt > PensionLimitAmount/*HRSetup."Pension Limit Amount"// then begin
                        //GratuityAmount//
                        PensionReliefAmt := PensionLimitAmount//HRSetup."Pension Limit Amount"//;
                        if //GratuityAmount//PensionReliefAmt <> 0 then
                            TaxableAmount := TaxableAmount -//GratuityAmount//PensionReliefAmt;
                    end;
                    if //GratuityAmount//PensionReliefAmt < PensionLimitAmount/*HRSetup."Pension Limit Amount"// then begin
                        TaxableAmount := TaxableAmount -//GratuityAmount//PensionReliefAmt;
                    end;
                end;*/
                //ERROR('Last G Taxable%1',TaxableAmount);

                // Mortgage Relief
                MortgageRelief := 0;
                EarnRec.Reset;
                //EarnRec.SetCurrentKey(EarnRec."Earning Type");
                // EarnRec.SETFILTER(EarnRec."Calculation Method",'<>%1',EarnRec."Calculation Method"::"% of Salary Recovery");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Owner Occupier");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        Assignmatrix.SetRange("Exclude from Payroll", false);
                        if Assignmatrix.Find('-') then
                            MortgageRelief := MortgageRelief + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;

                //MESSAGE('Contrib = %1', EmployeeNssfContribution);

                //TaxableAmount:=TaxableAmount-(MortgageRelief+200);//parameterize this 200
                TaxableAmount := TaxableAmount - (MortgageRelief/*+EmployeeNssfContribution*/);
                TaxableAmountNew := TaxableAmount;
                SpecialTransportAllowanceTaxableIncome -= Abs(MortgageRelief);
                //MESSAGE('Taxable income = %1, Mortgage relief=%2', TaxableAmount, MortgageRelief);

                if (IsGivenSpecialTransportAllowance) then begin

                    Posting.Reset;
                    Posting.SetRange(Code, EmpRec."Posting Group");
                    if Posting.FindFirst then begin
                        if ((Posting."Seconded Employees" = false) and (EmpRec."Secondment Amount" = 0)) then
                            SpecialTransportAllowancePAYE := GetTaxBracket(SpecialTransportAllowanceTaxableIncome, EmpRec."Payroll Country");
                        if ((Posting."Seconded Employees" = true) and (EmpRec."Secondment Amount" = 0)) then
                            SpecialTransportAllowancePAYE := GetTaxBracket(SpecialTransportAllowanceTaxableIncome, EmpRec."Payroll Country");
                        if (((Posting."Seconded Employees" = true) and (EmpRec."Secondment Amount" <> 0))) or (EmpRec."Is Seconded") then begin
                            SpecialTransportAllowancePAYE := (SpecialTransportAllowanceTaxableIncome - EmpRec."Secondment Amount") * (/*PayrollSetup."PAYE Flat Rate (%)"*/HrSetup."PAYE Flat Rate (%)" / 100);//(Posting."Tax Percentage"/100);
                        end;
                    end else
                        SpecialTransportAllowancePAYE := GetTaxBracket(SpecialTransportAllowanceTaxableIncome, EmpRec."Payroll Country");
                end;

                // Get PAYE
                /*Empl.Reset;
                Empl.SetRange("No.", EmployeeNo);
                if Empl.FindFirst then begin*/
                Posting.Reset;
                Posting.SetRange(Code, EmpRec."Posting Group");
                if Posting.FindFirst then begin
                    if ((Posting."Seconded Employees" = false) and (EmpRec."Secondment Amount" = 0)) then
                        FinalTax := GetTaxBracket(TaxableAmount, EmpRec."Payroll Country");
                    if ((Posting."Seconded Employees" = true) and (EmpRec."Secondment Amount" = 0)) then
                        FinalTax := GetTaxBracket(TaxableAmount, EmpRec."Payroll Country");
                    if (((Posting."Seconded Employees" = true) and (EmpRec."Secondment Amount" <> 0))) or (EmpRec."Is Seconded") then begin
                        FinalTax := (TaxableAmount - EmpRec."Secondment Amount") * (/*PayrollSetup."PAYE Flat Rate (%)"*/HrSetup."PAYE Flat Rate (%)" / 100);//(Posting."Tax Percentage"/100);
                    end;
                end else
                    FinalTax := GetTaxBracket(TaxableAmount, EmpRec."Payroll Country");
                //end;

                //Message('FinalTax %1 TaxableAmount %2', FinalTax, TaxableAmount);
                InsuranceRelief := 0;
                // Calculate insurance relief;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Insurance Relief");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        if Assignmatrix.Find('-') then
                            InsuranceRelief := InsuranceRelief + Assignmatrix.Amount
                        else
                            InsuranceRelief := 0;
                    until EarnRec.Next = 0;
                end;




                // Personal Relief
                PersonalRelief := 0;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                // EarnRec.SETFILTER(EarnRec."Calculation Method",'<>%1',EarnRec."Calculation Method"::"% of Salary Recovery");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Tax Relief");
                EarnRec.SetRange("Reduces Tax", true);
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if (EarnRec.Find('-')) and (not EmpRec."Is Seconded") then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        Assignmatrix.SetRange("Exclude from Payroll", false);
                        if Assignmatrix.Find('-') then
                            PersonalRelief := PersonalRelief + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;


                //Message('PersonalRelief %1 InsuranceRelief %2', PersonalRelief, InsuranceRelief);

                FinalTax := FinalTax - (PersonalRelief + InsuranceRelief);
                SpecialTransportAllowancePAYE := SpecialTransportAllowancePAYE - (PersonalRelief + InsuranceRelief);
                if SpecialTransportAllowancePAYE < 0 then
                    SpecialTransportAllowancePAYE := 0;

                //Message('FinalTax %1 TaxableAmount %2', FinalTax, TaxableAmount);

                if FinalTax < 0 then
                    FinalTax := 0;
            end else begin
                TaxableAmountNew := 0;

                FinalTax := 0;
            end;
        end;
        //MESSAGE('Tax %1',FinalTax);
        //FinalTax := Round(FinalTax, 0.01, '>');/Don't round here, we'll use payroll setup
        EmpRec.Reset;
        EmpRec.SetRange(EmpRec."No.", EmployeeNo);
        EmpRec.SetRange("Pay Period Filter", DateSpecified);
        EmpRec.SetRange(EmpRec."Posting Group", 'BOARD');
        if EmpRec.Find('-') then begin
            if (EmpRec."Pays tax" = true) or (EmpRec.Disabled) then begin

                EmpRec.CalcFields(EmpRec."Taxable Allowance", "Tax Deductible Amount", "Relief Amount");
                TaxableAmount := EmpRec."Taxable Allowance" - Abs(EmpRec."Relief Amount");
                FinalTax := 0.3 * TaxableAmount;
            end;
        end;
        //============================================================================================================================

    end;


    procedure GetUserGroup(var UserIDs: Code[10]; var PGroup: Code[20])
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserIDs) then begin
            // PGroup:=UserSetup."Payroll Group";
            //IF PGroup='' THEN
            // ERROR('Dont have payroll permission');
        end;
    end;


    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;
        end;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        AddToNoText(NoText, NoTextIndex, PrintExponent, '');
        //FORMAT(No * 100) + '/100');

        if CurrencyCode <> '' then
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;


    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;


    procedure PayrollRounding(var Amount: Decimal) PayrollRounding: Decimal
    var
        HRsetup: Record "Human Resources Setup";
        amt: Decimal;
        DecPosistion: Integer;
        Decvalue: Text[30];
        amttext: Text[30];
        Wholeamt: Text[30];
        Stringlen: Integer;
        Decplace: Integer;
        holdamt: Text[30];
        FirstNoText: Text[30];
        SecNoText: Text[30];
        FirstNo: Integer;
        SecNo: Integer;
        Amttoround: Decimal;
    begin
        Evaluate(amttext, Format(Amount));
        DecPosistion := StrPos(amttext, '.');
        Stringlen := StrLen(amttext);

        if DecPosistion > 0 then begin
            Wholeamt := CopyStr(amttext, 1, DecPosistion - 1);

            Decplace := Stringlen - DecPosistion;
            Decvalue := CopyStr(amttext, DecPosistion + 1, 2);
            if StrLen(Decvalue) = 1 then
                holdamt := Decvalue + '0';
            if StrLen(Decvalue) > 1 then begin
                FirstNoText := CopyStr(Decvalue, 1, 1);
                SecNoText := CopyStr(Decvalue, 2, 1);
                Evaluate(SecNo, Format(SecNoText));
                if SecNo >= 5 then
                    holdamt := FirstNoText + '5'
                else
                    holdamt := FirstNoText + '0'

            end;
            amttext := Wholeamt + '.' + holdamt;
            Evaluate(Amttoround, Format(amttext));
        end else begin
            Evaluate(amttext, Format(Amount));
            Evaluate(Amttoround, Format(amttext));
        end;


        Amount := Amttoround;
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


    procedure CalculateTaxableAmountPWD(var EmployeeNo: Code[20]; var DateSpecified: Date; var FinalTax: Decimal; var TaxableAmountNew: Decimal; var RetirementCont: Decimal)
    var
        Assignmatrix: Record "Assignment Matrix";
        EmpRec: Record Employee;
        EarnRec: Record Earnings;
        InsuranceRelief: Decimal;
        PersonalRelief: Decimal;
        HRSetup: Record "Human Resources Setup";
        Assignmatrix7: Record "Assignment Matrix";
        Bracketrec: Record "Brackets Lines";
        Exemption: Record "PAYE Employee Exemption";
        PensionLimitAmount: Decimal;
        OtherDeductibles: Decimal;
    begin
        CfMpr := 0;
        FinalTax := 0;
        i := 0;
        TaxableAmount := 0;
        RetirementCont := 0;
        InsuranceRelief := 0;
        PersonalRelief := 0;
        ExcessRetirement := 0;
        PensionAdd := 0;
        AddBack := 0;
        PensionLimitAmount := 0;
        OtherDeductibles := 0;
        //Get payroll period
        GetPayPeriod;
        if DateSpecified = 0D then
            Error('Pay period must be specified for this report');
        // Taxable Amount
        EmpRec.Reset;
        EmpRec.SetRange(EmpRec."No.", EmployeeNo);
        EmpRec.SetRange("Pay Period Filter", DateSpecified);
        if EmpRec.Find('-') then begin
            if (EmpRec."Pays tax" = false) or (EmpRec.Disabled) then begin
                //get the pension limit set on the paye code of this country's deductions
                Ded.Reset;
                Ded.SetRange(Ded."PAYE Code", true);
                Ded.SetRange(Country, EmpRec."Payroll Country");
                if Ded.findfirst then
                    PensionLimitAmount := Ded."Pension Limit Amount";
                /*
              //Get Taxable amount from assigment matrix
              AssignmentMatrixRec.RESET;
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec."Employee No",EmployeeNo);
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec."Payroll Period",DateSpecified);
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec.Taxable,TRUE);
              IF AssignmentMatrixRec.FINDFIRST THEN
                REPEAT
                  TaxableAmount:=TaxableAmount+AssignmentMatrixRec.Amount;
                  UNTIL AssignmentMatrixRec.NEXT=0;
                */
                EmpRec.CalcFields(EmpRec."Total Allowances", "Tax Deductible Amount", "Relief Amount", "Taxable Allowance");
                //TaxableAmount:=EmpRec."Total Allowances";// -ABS(EmpRec."Relief Amount");
                Exemption.Get(EmpRec."No.");
                TaxableAmount := EmpRec."Taxable Allowance" - Exemption."Amount Exempted";
                Ded.Reset;
                Ded.SetRange(Ded."Tax deductible", true);
                Ded.SetRange(Country, EmpRec."Payroll Country");
                if Ded.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Deduction);
                        Assignmatrix.SetRange(Assignmatrix.Code, Ded.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        //Assignmatrix.SetRange("Tax Deductible", true);
                        if Assignmatrix.Find('-') then begin
                            /*
                            IF Ded."Pension Limit Amount">0 THEN BEGIN
                                  IF ABS(Assignmatrix.Amount)>Ded."Pension Limit Amount" THEN
                                      RetirementCont:=ABS(RetirementCont)+Ded."Pension Limit Amount"
                                  ELSE
                                      RetirementCont:=ABS(RetirementCont)+ABS(Assignmatrix.Amount);
                            END;
                            */

                            if Ded."Pension Scheme" then begin
                                if Assignmatrix.Amount <> 0 then begin
                                    RetirementCont := Abs(RetirementCont) + Abs(Assignmatrix.Amount);
                                end;
                                //Employer contribution Pension
                                if Ded."Employer Contibution Taxed" = true then begin
                                    ExcessRetirement := ExcessRetirement + Abs(Assignmatrix."Employer Amount");
                                end;
                            end else
                                OtherDeductibles += Abs(Assignmatrix.Amount);
                        end;
                    until Ded.Next = 0;
                end;

                //Deduct other deductibles without limits
                TaxableAmount := TaxableAmount - OtherDeductibles;



                //MESSAGE('Taxable1%1Retire%2',TaxableAmount,RetirementCont);
                HRSetup.Get;
                if RetirementCont > PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                    RetirementCont := PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                    if RetirementCont <> 0 then
                        TaxableAmount := TaxableAmount - RetirementCont;
                    if ExcessRetirement > 0 then
                        TaxableAmount := TaxableAmount + ExcessRetirement;
                    //MESSAGE('Taxable2%1Retire%2',TaxableAmount,RetirementCont);
                end;
                PensionAdd := 0;
                if RetirementCont < PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                    PensionAdd := RetirementCont;//+ExcessRetirement;
                    if PensionAdd > PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                        //PensionAdd:=PensionAdd-HRSetup."Pension Limit Amount";
                        AddBack := PensionAdd - PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                        TaxableAmount := TaxableAmount + AddBack - PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                    end;
                    if PensionAdd <= PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                        TaxableAmount := TaxableAmount - PensionAdd;//Subtract changed to Addition//Engineer
                                                                    //PensionAdd:=0;
                                                                    //MESSAGE('Taxable3%1Retire%2Excess%3',TaxableAmount,PensionAdd,ExcessRetirement);
                    end;
                    //TaxableAmount:=TaxableAmount+PensionAdd;
                end;
                //  MESSAGE('Taxable%1',TaxableAmount);
                //IF EmpRec."Home Ownership Status"=EmpRec."Home Ownership Status"::"Owner Occupier" THEN
                // BEGIN
                // Get owner Occuper From Earning Table
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Owner Occupier");
                EarnRec.setrange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then begin
                            TaxableAmount := TaxableAmount - Assignmatrix.Amount;
                        end;
                    until EarnRec.Next = 0;
                    // END;
                end;

                //Taxable Non-Cash Benefits
                EarnRec.Reset;
                EarnRec.SetRange("Non-Cash Benefit", true);
                EarnRec.SetRange(Taxable, true);
                EarnRec.setrange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            TaxableAmount := TaxableAmount + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;


                //Telephone Allowance <<Taxable percentage added to taxable amount>>
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Telephone Allowance");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then begin
                            if EarnRec."Taxable Percentage" <> 0 then
                                TaxableAmount := TaxableAmount + (Assignmatrix.Amount * (EarnRec."Taxable Percentage" / 100));
                        end;
                    until EarnRec.Next = 0;
                end;

                // Low Interest Benefits
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Low Interest");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            TaxableAmount := TaxableAmount + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;

                //Disability Relief JK
                DisabilityRelief := 0;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Disability Relief");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then begin
                            DisabilityRelief := Assignmatrix.Amount;
                            TaxableAmount := TaxableAmount - EarnRec."Maximum Limit";
                        end;
                    until EarnRec.Next = 0;
                end;


                // TaxableAmount:=162973;
                //MESSAGE('Taxable%1Insurance%2',TaxableAmount,InsuranceRelief);
                TaxableAmountNew := TaxableAmount;


                // Get PAYE
                Empl.Reset;
                Empl.SetRange("No.", EmployeeNo);
                if Empl.FindFirst then begin
                    Posting.Reset;
                    Posting.SetRange(Code, Empl."Posting Group");
                    if Posting.FindFirst then begin
                        if ((Posting."Seconded Employees" = false) and (Empl."Secondment Amount" = 0)) then
                            FinalTax := GetTaxBracket(TaxableAmount, Empl."Payroll Country");
                        if ((Posting."Seconded Employees" = true) and (Empl."Secondment Amount" = 0)) then
                            FinalTax := GetTaxBracket(TaxableAmount, Empl."Payroll Country");
                        if ((Posting."Seconded Employees" = true) and (Empl."Secondment Amount" <> 0)) then begin
                            FinalTax := (TaxableAmount - Empl."Secondment Amount") * (Posting."Tax Percentage" / 100);
                        end;
                    end else //Just in case we don't have the posting group
                        FinalTax := GetTaxBracket(TaxableAmount, Empl."Payroll Country");
                end;
                //MESSAGE('FinalTax%1',FinalTax);
                InsuranceRelief := 0;
                // Calculate insurance relief;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Insurance Relief");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            InsuranceRelief := InsuranceRelief + Assignmatrix.Amount
                        else
                            InsuranceRelief := 0;
                    until EarnRec.Next = 0;
                end;


                // Personal Relief
                PersonalRelief := 0;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                // EarnRec.SETFILTER(EarnRec."Calculation Method",'<>%1',EarnRec."Calculation Method"::"% of Salary Recovery");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Tax Relief");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            PersonalRelief := PersonalRelief + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;
                //MESSAGE('Relief%1Final%2',PersonalRelief,FinalTax);

                FinalTax := FinalTax - (PersonalRelief + InsuranceRelief);

                // MESSAGE('Relief%1Final%2PersonalRelief%3',PersonalRelief,FinalTax,PersonalRelief);
                if FinalTax < 0 then
                    FinalTax := 0;
            end else begin
                TaxableAmountNew := 0;

                FinalTax := 0;
            end;
        end;
        //MESSAGE('Tax %1',FinalTax);
        //FinalTax := Round(FinalTax, 1, '>');/+Don't round here, we'll use payroll setup
        EmpRec.Reset;
        EmpRec.SetRange(EmpRec."No.", EmployeeNo);
        EmpRec.SetRange("Pay Period Filter", DateSpecified);
        EmpRec.SetRange(EmpRec."Posting Group", 'BOARD');
        if EmpRec.Find('-') then begin
            if (EmpRec."Pays tax" = true) or (EmpRec.Disabled) then begin

                EmpRec.CalcFields(EmpRec."Taxable Allowance", "Tax Deductible Amount", "Relief Amount");
                TaxableAmount := EmpRec."Taxable Allowance" - Abs(EmpRec."Relief Amount");
                FinalTax := 0.3 * TaxableAmount;
            end;
        end;
        //============================================================================================================================

    end;


    procedure CalculateTaxableAmountPAYEExempt(var EmployeeNo: Code[20]; var DateSpecified: Date; var FinalTax: Decimal; var TaxableAmountNew: Decimal; var RetirementCont: Decimal)
    var
        Assignmatrix: Record "Assignment Matrix";
        EmpRec: Record Employee;
        EarnRec: Record Earnings;
        InsuranceRelief: Decimal;
        PersonalRelief: Decimal;
        HRSetup: Record "Human Resources Setup";
        Assignmatrix7: Record "Assignment Matrix";
        Bracketrec: Record "Brackets Lines";
        MortgageRelief: Decimal;
        PensionLimitAmount: Decimal;
        OtherDeductibles: Decimal;
    begin
        CfMpr := 0;
        FinalTax := 0;
        i := 0;
        TaxableAmount := 0;
        RetirementCont := 0;
        InsuranceRelief := 0;
        PersonalRelief := 0;
        ExcessRetirement := 0;
        PensionAdd := 0;
        AddBack := 0;
        GratuityAmount := 0;
        PensionLimitAmount := 0;
        OtherDeductibles := 0;
        //Get payroll period
        GetPayPeriod;
        if DateSpecified = 0D then
            Error('Pay period must be specified for this report');

        // Taxable Amount
        EmpRec.Reset;
        EmpRec.SetRange(EmpRec."No.", EmployeeNo);
        EmpRec.SetRange("Pay Period Filter", DateSpecified);
        if EmpRec.Find('-') then begin
            if (EmpRec."Pays tax" = true) or (EmpRec.Disabled) then begin
                //get the pension limit set on the paye code of this country's deductions
                Ded.Reset;
                Ded.SetRange(Ded."PAYE Code", true);
                Ded.SetRange(Country, EmpRec."Payroll Country");
                if Ded.findfirst then
                    PensionLimitAmount := Ded."Pension Limit Amount";
                /*
              //Get Taxable amount from assigment matrix
              AssignmentMatrixRec.RESET;
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec."Employee No",EmployeeNo);
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec."Payroll Period",DateSpecified);
              AssignmentMatrixRec.SETRANGE(AssignmentMatrixRec.Taxable,TRUE);
              IF AssignmentMatrixRec.FINDFIRST THEN
                REPEAT
                  TaxableAmount:=TaxableAmount+AssignmentMatrixRec.Amount;
                  UNTIL AssignmentMatrixRec.NEXT=0;
                */
                EmpRec.CalcFields(EmpRec."Total Allowances", "Tax Deductible Amount", "Relief Amount", "Taxable Allowance");
                //TaxableAmount:=EmpRec."Total Allowances";// -ABS(EmpRec."Relief Amount");
                TaxableAmount := EmpRec."Taxable Allowance";
                //MESSAGE(FORMAT(TaxableAmount));
                Ded.Reset;
                Ded.SetRange(Ded."Tax deductible", true);
                Ded.SetRange(Country, EmpRec."Payroll Country");
                if Ded.Find('-') then begin
                    repeat

                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Deduction);
                        Assignmatrix.SetRange(Assignmatrix.Code, Ded.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        Assignmatrix.SetRange(Country, EmpRec."Payroll Country");
                        //Assignmatrix.SetRange("Tax Deductible", true);
                        if Assignmatrix.Find('-') then begin
                            /*
                            IF Ded."Pension Limit Amount">0 THEN BEGIN
                                  IF ABS(Assignmatrix.Amount)>Ded."Pension Limit Amount" THEN
                                      RetirementCont:=ABS(RetirementCont)+Ded."Pension Limit Amount"
                                  ELSE
                                      RetirementCont:=ABS(RetirementCont)+ABS(Assignmatrix.Amount);
                            END;
                            */
                            //MESSAGE('MatrixAmount%1',Assignmatrix.Amount);
                            if Ded."Pension Scheme" then begin
                                if Assignmatrix.Amount <> 0 then begin
                                    RetirementCont := Abs(RetirementCont) + Abs(Assignmatrix.Amount);
                                end;
                                //Employer contribution Pension
                                if Ded."Employer Contibution Taxed" = true then begin
                                    ExcessRetirement := ExcessRetirement + Abs(Assignmatrix."Employer Amount");
                                end;
                            end else
                                OtherDeductibles += Abs(Assignmatrix.Amount);
                        end;
                    until Ded.Next = 0;
                end;

                //Deduct other deductibles without limits
                TaxableAmount := TaxableAmount - OtherDeductibles;

                HRSetup.Get;
                if RetirementCont > PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                    RetirementCont := PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                    if RetirementCont <> 0 then
                        TaxableAmount := TaxableAmount - RetirementCont;
                    if ExcessRetirement > 0 then
                        TaxableAmount := TaxableAmount + ExcessRetirement;
                end;
                PensionAdd := 0;
                if RetirementCont < PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                    PensionAdd := ExcessRetirement + RetirementCont;
                    if PensionAdd > PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin

                        AddBack := PensionAdd - PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                        TaxableAmount := TaxableAmount + AddBack - PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                    end;
                    if PensionAdd <= PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                        TaxableAmount := TaxableAmount - PensionAdd;//Subtract changed to Addition//Engineer
                                                                    //PensionAdd:=0;
                    end;
                    //TaxableAmount:=TaxableAmount+PensionAdd;
                end;


                //Taxable Non-Cash Benefits
                EarnRec.Reset;
                EarnRec.SetRange("Non-Cash Benefit", true);
                EarnRec.SetRange(Taxable, true);
                EarnRec.setrange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            TaxableAmount := TaxableAmount + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;

                //Taxable other Earnings //Leave encashment gratuity accrued
                EarnRec.Reset;
                EarnRec.SetRange(Gratuity, false);
                EarnRec.SetRange("Basic Salary Code", false);
                EarnRec.SetRange(Taxable, true);
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            TaxableAmount := TaxableAmount + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;


                //Telephone Allowance <<Taxable percentage added to taxable amount>>
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Telephone Allowance");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then begin
                            if EarnRec."Taxable Percentage" <> 0 then
                                TaxableAmount := TaxableAmount + (Assignmatrix.Amount * (EarnRec."Taxable Percentage" / 100));
                        end;
                    until EarnRec.Next = 0;
                end;

                // Low Interest Benefits
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Low Interest");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            TaxableAmount := TaxableAmount + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;

                //Disability Relief JK
                DisabilityRelief := 0;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Disability Relief");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then begin
                            DisabilityRelief := Assignmatrix.Amount;
                            TaxableAmount := TaxableAmount - EarnRec."Maximum Limit";
                        end;
                    until EarnRec.Next = 0;
                end;

                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec.Gratuity, true);
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then begin
                            GratuityAmount += Assignmatrix.Amount;
                            /*
                             IF EarnRec."Max Taxable Amount" < Assignmatrix.Amount THEN
                             TaxableAmount:=TaxableAmount-EarnRec."Max Taxable Amount"
                             ELSE
                             TaxableAmount:=TaxableAmount-Assignmatrix.Amount;*/
                        end;
                    until EarnRec.Next = 0;
                end;
                //ERROR('Grat %1 taxableA%2',GratuityAmount,TaxableAmount);

                if GratuityAmount > PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                    GratuityAmount := PensionLimitAmount/*HRSetup."Pension Limit Amount"*/;
                    if GratuityAmount <> 0 then
                        TaxableAmount := TaxableAmount - GratuityAmount;
                end;
                if GratuityAmount < PensionLimitAmount/*HRSetup."Pension Limit Amount"*/ then begin
                    TaxableAmount := TaxableAmount - GratuityAmount;
                end;

                // Mortgage Relief
                MortgageRelief := 0;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                // EarnRec.SETFILTER(EarnRec."Calculation Method",'<>%1',EarnRec."Calculation Method"::"% of Salary Recovery");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Owner Occupier");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            MortgageRelief := MortgageRelief + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;
                TaxableAmount := TaxableAmount - (MortgageRelief + 200);//parameterize this 200
                TaxableAmountNew := TaxableAmount;
                //MESSAGE('Taxable%1',TaxableAmount);
                // Get PAYE
                Empl.Reset;
                Empl.SetRange("No.", EmployeeNo);
                if Empl.FindFirst then begin
                    Posting.Reset;
                    Posting.SetRange(Code, Empl."Posting Group");
                    if Posting.FindFirst then begin
                        if ((Posting."Seconded Employees" = false) and (Empl."Secondment Amount" = 0)) then
                            FinalTax := GetTaxBracket(TaxableAmount, Empl."Payroll Country");
                        if ((Posting."Seconded Employees" = true) and (Empl."Secondment Amount" = 0)) then
                            FinalTax := GetTaxBracket(TaxableAmount, Empl."Payroll Country");
                        if ((Posting."Seconded Employees" = true) and (Empl."Secondment Amount" <> 0)) then begin
                            FinalTax := (TaxableAmount - Empl."Secondment Amount") * (Posting."Tax Percentage" / 100);
                        end;
                    end;
                end;
                InsuranceRelief := 0;
                // Calculate insurance relief;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Insurance Relief");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            InsuranceRelief := InsuranceRelief + Assignmatrix.Amount
                        else
                            InsuranceRelief := 0;
                    until EarnRec.Next = 0;
                end;




                // Personal Relief
                PersonalRelief := 0;
                EarnRec.Reset;
                EarnRec.SetCurrentKey(EarnRec."Earning Type");
                // EarnRec.SETFILTER(EarnRec."Calculation Method",'<>%1',EarnRec."Calculation Method"::"% of Salary Recovery");
                EarnRec.SetRange(EarnRec."Earning Type", EarnRec."Earning Type"::"Tax Relief");
                EarnRec.SetRange(Country, EmpRec."Payroll Country");
                if EarnRec.Find('-') then begin
                    repeat
                        Assignmatrix.Reset;
                        Assignmatrix.SetRange(Assignmatrix."Payroll Period", DateSpecified);
                        Assignmatrix.SetRange(Type, Assignmatrix.Type::Payment);
                        Assignmatrix.SetRange(Assignmatrix.Code, EarnRec.Code);
                        Assignmatrix.SetRange(Assignmatrix."Employee No", EmployeeNo);
                        if Assignmatrix.Find('-') then
                            PersonalRelief := PersonalRelief + Assignmatrix.Amount;
                    until EarnRec.Next = 0;
                end;

                FinalTax := FinalTax - (PersonalRelief + InsuranceRelief);

                if FinalTax < 0 then
                    FinalTax := 0;
            end else begin
                TaxableAmountNew := 0;

                FinalTax := 0;
            end;
        end;
        //MESSAGE('Tax %1',FinalTax);
        //FinalTax := Round(FinalTax, 0.01, '>');/Don't round here, we'll use payroll setup
        EmpRec.Reset;
        EmpRec.SetRange(EmpRec."No.", EmployeeNo);
        EmpRec.SetRange("Pay Period Filter", DateSpecified);
        EmpRec.SetRange(EmpRec."Posting Group", 'BOARD');
        if EmpRec.Find('-') then begin
            if (EmpRec."Pays tax" = true) or (EmpRec.Disabled) then begin

                EmpRec.CalcFields(EmpRec."Taxable Allowance", "Tax Deductible Amount", "Relief Amount");
                TaxableAmount := EmpRec."Taxable Allowance" - Abs(EmpRec."Relief Amount");
                FinalTax := 0.3 * TaxableAmount;
            end;
        end;
        //============================================================================================================================

    end;
}