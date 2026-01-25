table 51525317 "Assignment Matrix"
{
    DataCaptionFields = "Employee No", Description;
    DrillDownPageID = "Payment & Deductions";
    LookupPageID = "Payment & Deductions";

    fields
    {
        field(1; "Employee No"; Code[30])
        {
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if Empl.Get("Employee No") then begin
                    if Empl."Posting Group" <> 'BOARD' then begin
                        // Empl.TESTFIELD("Global Dimension 1 Code");
                        // Empl.TESTFIELD("Global Dimension 2 Code");
                    end;
                    "Global Dimension 1 code" := Empl."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Empl."Global Dimension 2 Code";
                    "Posting Group Filter" := Empl."Posting Group";
                    // "Global Dimension 1 code":=Empl."Global Dimension 1 Code";
                    //"Salary Grade":=Empl."Salary Scheme Category";
                    "Salary Pointer" := Empl.Present;
                    "Basic Pay" := Empl."Basic Pay";
                    // "Posting Group Filter":=Empl."Posting Group";
                    // IF Empl."Posting Group"='' THEN
                    // ERROR('Assign  %1  %2 a posting group before assigning any earning or deduction',Empl."First Name",Empl."Last Name");
                end;
            end;
        }
        field(2; Type; Option)
        {
            NotBlank = false;
            OptionMembers = Payment,Deduction,"Saving Scheme",Loan,Informational;
        }
        field(3; "Code"; Code[20])
        {
            TableRelation = IF (Type = CONST(Payment)) Earnings
            ELSE
            IF (Type = CONST(Deduction)) Deductions
            ELSE
            IF (Type = CONST(Loan)) "Loan Application"."Loan No" WHERE("Employee No" = FIELD("Employee No"));

            trigger OnValidate()
            begin
                TestField("Employee No");
                "Is Flat Amount" := FnUpdateFormulaOnMatrix();
                if Empl.Get("Employee No") then begin
                    if (Empl.Status <> Empl.Status::Active) and (not "Overtime Allowance") then
                        Error('Can only assign Earnings and deductions to Active Employees, Employee %1', Empl."No.");
                end;
                Validate("Amount In FCY");
                "Inhouse instructor Allowance" := false;

                GetPayPeriod;
                "Payroll Period" := PayStartDate;
                "Pay Period" := PayPeriodText;
                "Next Period Entry" := false;

                if "Country Currency" = '' then begin
                    PayrollCountry.reset();
                    PayrollCountry.SetRange(Code, Country);
                    if PayrollCountry.FindFirst() then
                        "Country Currency" := PayrollCountry."Country Currency";
                end;
                //*********************Allowances Calculation rules etc***************
                case Type of
                    Type::Payment:
                        begin
                            //if Payments.Get(Code) then begin
                            Payments.Reset();
                            Payments.SetRange(Code, Code);
                            Payments.setrange(Country, Country);
                            if Payments.findfirst then begin
                                // check if blocked
                                if Payments.Block = true then
                                    Error(' Earning Blocked');
                                if ("Transaction Title" = '') or ("Transaction Title" <> Payments."Universal Title") then
                                    "Transaction Title" := Payments."Universal Title";
                                if ("Transaction Title" = 'SPECIAL TRANSPORT ALLOWANCE ARREAS') then
                                    "Special Transport Allowance" := true;
                                "Time Sheet" := Payments."Time Sheet";
                                Description := Payments.Description;
                                Frequency := Payments."Pay Type";
                                "Is Statutory" := Payments."Is Statutory";
                                "Tax Relief" := false;
                                if (Payments."Earning Type" = Payments."Earning Type"::"Tax Relief") and (Payments."Reduces Tax") then
                                    "Tax Relief" := true;
                                "Non-Cash Benefit" := Payments."Non-Cash Benefit";
                                Quarters := Payments.Quarters;
                                //Paydeduct:=Payments."End Date";
                                Taxable := Payments.Taxable;
                                Insurable := Payments."Is Insurable Earning";
                                "Exclude from Calculations" := Payments."Exclude from Calculations";
                                "Exclude from Payroll" := Payments."Exclude from Payroll";
                                "Overtime Allowance" := Payments.OverTime;
                                if "Overtime Allowance" then
                                    "Overtime Period" := "Payroll Period"
                                else
                                    "Overtime Period" := 0D;
                                "Transport Allowance" := Payments."Transport Allowance";
                                "Housing Allowance" := Payments."Housing Allowance";
                                "Is from Contractual Amount" := false;

                                if Payments."Universal Title" = 'IN-HOUSE INSTRUCTOR ALLOWANCE' then
                                    "Inhouse instructor Allowance" := true;

                                // MESSAGE('Taxable=%1',Taxable);
                                "Tax Deductible" := Payments."Reduces Tax" or Payments."Reduces Taxable Amt";
                                if Payments."Pay Type" = Payments."Pay Type"::Recurring then
                                    "Next Period Entry" := true;

                                "Basic Salary Code" := Payments."Basic Salary Code";
                                "Basic Pay Arrears" := Payments."Basic Pay Arrears";


                                if Payments."Earning Type" = Payments."Earning Type"::"Normal Earning" then
                                    "Normal Earnings" := true
                                else
                                    "Normal Earnings" := false;



                                if (Payments."Calculation Method" = Payments."Calculation Method"::"Flat amount") and (Payments."Flat Amount" <> 0) then
                                    Amount := Payments."Flat Amount";


                                if Payments."Calculation Method" = Payments."Calculation Method"::"% of Basic pay" then begin
                                    if Empl.Get("Employee No") then begin
                                        Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                                        Empl.SetRange(Empl."Payroll Country Filter", Country);
                                        Empl.CalcFields(Basic, Empl."Basic Arrears", "Month Basic Pay");
                                        Amount := Payments.Percentage / 100 * (Empl.Basic - Empl."Basic Arrears");

                                        IF Empl."Month Basic Pay" > 0 then
                                            Amount := ((Payments.Percentage / 100) * (Empl."Month Basic Pay"));

                                        //Check For Limits
                                        if Payments."Minimum Limit" <> 0 then
                                            if Amount < Payments."Minimum Limit" then
                                                Amount := Payments."Minimum Limit";
                                        if Payments."Maximum Limit" <> 0 then
                                            if Amount > Payments."Maximum Limit" then
                                                Amount := Payments."Maximum Limit";
                                        Amount := PayrollRounding(Amount);//round
                                    end;
                                end;


                                if Payments."Calculation Method" = Payments."Calculation Method"::"% of Basic after tax" then begin
                                    if Empl.Get("Employee No") then begin
                                        HRSetup.Get;
                                        //=>if HRSetup."Company overtime hours" <> 0 then
                                        //=>Amount := ("No. of Units" * Empl."Hourly Rate" * Payments."Overtime Factor");//HRSetup."Company overtime hours";

                                        //Check For Limits
                                        if Payments."Minimum Limit" <> 0 then
                                            if Amount < Payments."Minimum Limit" then
                                                Amount := Payments."Minimum Limit";
                                        if Payments."Maximum Limit" <> 0 then
                                            if Amount > Payments."Maximum Limit" then
                                                Amount := Payments."Maximum Limit";

                                        Amount := PayrollRounding(Amount);//round
                                    end;
                                end;

                                if Payments."Calculation Method" = Payments."Calculation Method"::"Based on Hourly Rate" then begin
                                    if Empl.Get("Employee No") then begin
                                        Amount := "No. of Units" * Empl."Daily Rate";//*Payments."Overtime Factor";
                                        if Payments."Overtime Factor" <> 0 then
                                            Amount := "No. of Units" * Empl."Daily Rate" * Payments."Overtime Factor";

                                        //Check For Limits
                                        if Payments."Minimum Limit" <> 0 then
                                            if Amount < Payments."Minimum Limit" then
                                                Amount := Payments."Minimum Limit";
                                        if Payments."Maximum Limit" <> 0 then
                                            if Amount > Payments."Maximum Limit" then
                                                Amount := Payments."Maximum Limit";


                                        Amount := PayrollRounding(Amount);//round
                                    end;
                                end;

                                //insurance relief

                                if Payments."Calculation Method" = Payments."Calculation Method"::"% of Insurance Amount" then begin
                                    if Empl.Get("Employee No") then begin
                                        Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                                        Empl.SetRange(Empl."Payroll Country Filter", Country);
                                        Empl.CalcFields(Empl.Insurance);
                                        Amount := Abs((Payments.Percentage / 100) * (Empl.Insurance));

                                        //Check For Limits
                                        if Payments."Minimum Limit" <> 0 then
                                            if Amount < Payments."Minimum Limit" then
                                                Amount := Payments."Minimum Limit";
                                        if Payments."Maximum Limit" <> 0 then
                                            if Amount > Payments."Maximum Limit" then
                                                Amount := Payments."Maximum Limit";

                                        Amount := PayrollRounding(Amount);//round
                                                                          //MESSAGE('Amount %1',Amount);
                                    end;
                                end;

                                if Payments."Calculation Method" = Payments."Calculation Method"::"% of Gross pay" then begin
                                    ApplicablePercent := Payments.Percentage;
                                    "Is from Contractual Amount" := true;
                                    if Empl.Get("Employee No") then begin
                                        if (Payments."Housing Allowance") and (Empl."No Transport Allowance") then
                                            ApplicablePercent := Empl."Applicable House Allowance (%)";
                                        Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                                        Empl.SetRange(Empl."Payroll Country Filter", Country);
                                        Empl.CalcFields(Basic, Empl."Total Allowances", "Month Gross Pay");
                                        Amount := ((ApplicablePercent/*Payments.Percentage*/ / 100) * (Empl.Basic + Empl."Total Allowances"));

                                        IF Empl."Month Gross Pay" > 0 then
                                            Amount := ((ApplicablePercent/*Payments.Percentage*/ / 100) * (Empl."Month Gross Pay"));

                                        //Check For Limits
                                        if Payments."Minimum Limit" <> 0 then
                                            if Amount < Payments."Minimum Limit" then
                                                Amount := Payments."Minimum Limit";
                                        if Payments."Maximum Limit" <> 0 then
                                            if Amount > Payments."Maximum Limit" then
                                                Amount := Payments."Maximum Limit";


                                        Amount := PayrollRounding(Amount);//round
                                    end;
                                end;

                                if Payments."Calculation Method" = Payments."Calculation Method"::"% of Taxable income" then begin
                                    if Empl.Get("Employee No") then begin
                                        Empl.SetRange("Pay Period Filter", PayStartDate);
                                        Empl.CalcFields(Empl."Taxable Allowance");

                                        Amount := ((Payments.Percentage / 100) * (Empl."Basic Pay" + Empl."Taxable Allowance"));

                                        //Check For Limits
                                        if Payments."Minimum Limit" <> 0 then
                                            if Amount < Payments."Minimum Limit" then
                                                Amount := Payments."Minimum Limit";
                                        if Payments."Maximum Limit" <> 0 then
                                            if Amount > Payments."Maximum Limit" then
                                                Amount := Payments."Maximum Limit";

                                        Amount := PayrollRounding(Amount);//round
                                    end;
                                end;

                                if Payments."Reduces Tax" then
                                    Amount := PayrollRounding(Amount);//round

                            end;

                            if Payments."Calculation Method" = Payments."Calculation Method"::"% of Cost" then begin
                                if Empl.Get("Employee No") then begin
                                    Amount := Abs((Payments.Percentage / 100) * (Cost));
                                    Amount := PayrollRounding(Amount);//round
                                end;
                            end;

                        end;

                    //*********Deductions****************************************
                    Type::Deduction:
                        begin
                            "Is Loan Transaction" := false;
                            Deductions.Reset();
                            Deductions.SetRange(Code, Code);
                            Deductions.SetRange(Country, Country);
                            if Deductions.FindFirst() then begin
                                //if Deductions.Get(Code) then begin
                                if Deductions.Block = true then
                                    Error('Deduction Blocked');
                                if ("Transaction Title" = '') or ("Transaction Title" <> Deductions."Universal Title") then
                                    "Transaction Title" := Deductions."Universal Title";
                                Description := Deductions.Description;
                                "G/L Account" := Deductions."G/L Account";
                                "Tax Deductible" := Deductions."Tax deductible";
                                Retirement := Deductions."Pension Scheme";
                                Shares := Deductions.Shares;
                                Paye := Deductions."PAYE Code";
                                "Insurance Code" := Deductions."Insurance Code";
                                "Do Not Deduct" := Deductions."Do Not Deduct";
                                "Main Deduction Code" := Deductions."Main Deduction Code";
                                Frequency := Deductions.Type::Recurring;
                                "Is CBHI" := false;
                                "Maternity Leave Deduction" := false;
                                "Social Security Deduction" := false;
                                "Medical Insurance Deduction" := false;
                                "MMI Deduction" := false;
                                "Reduces Gross" := Deductions."Reduces Gross";
                                "Is Statutory" := Deductions."Is Statutory";
                                "Is from Contractual Amount" := false;
                                if Deductions."Universal Title" = 'CBHI' then //Hard-code for now
                                    "Is CBHI" := true;
                                if Deductions."Universal Title" = 'MATERNITY LEAVE DEDUCTION' then //Hard-code for now
                                    "Maternity Leave Deduction" := true;
                                if Deductions."Universal Title" = 'SOCIAL SECURITY' then //Hard-code for now
                                    "Social Security Deduction" := true;
                                if Deductions."Universal Title" = 'MEDICAL INSURANCE' then //Hard-code for now
                                    "Medical Insurance Deduction" := true;
                                if Deductions."Universal Title" = 'MMI' then //Hard-code for now
                                    "MMI Deduction" := true;



                                if Deductions.Type = Deductions.Type::Recurring then
                                    "Next Period Entry" := true;
                                if Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat Amount" then begin
                                    if Deductions."Flat Amount" <> 0 then
                                        Amount := Deductions."Flat Amount";
                                    /*else
                                        Amount := Amount;*/
                                    if Deductions."Flat Amount Employer" <> 0 then
                                        "Employer Amount" := Deductions."Flat Amount Employer";
                                    /*else
                                        "Employer Amount" := "Employer Amount";*/

                                    //If has loan transactions
                                    TotalLoanAmountinCountryCurrency := 0;
                                    LoanAmountToDeduct := 0;
                                    Loan.Reset();
                                    Loan.SetRange(Employee, Rec."Employee No");
                                    Loan.SetRange(Code, Code);
                                    Loan.SetRange(Country, Country);
                                    Loan.SetRange("Start Deducting", true);
                                    Loan.SetRange(Pause, false);
                                    Loan.SetRange(Suspend, false);
                                    Loan.SetRange(Cleared, false);
                                    if Loan.FindSet() then begin
                                        "Amount In FCY" := 0;
                                        PayrollCountry.reset();
                                        PayrollCountry.SetRange(Code, Country);
                                        if PayrollCountry.FindFirst() then
                                            "Country Currency" := PayrollCountry."Country Currency";
                                        "Earning Currency" := "Country Currency";
                                        repeat
                                            LoanRepayments.Reset();
                                            LoanRepayments.SetRange("Loan No.", Loan.No);
                                            LoanRepayments.SetRange("Payroll Period", "Payroll Period");
                                            LoanRepayments.SetRange(Closed, false);
                                            if LoanRepayments.Find('-') then
                                                LoanRepayments.DeleteAll();

                                            "Loan No." := Loan.No; //Unnecessary if we have multiple loans
                                            "Is Loan Transaction" := true;
                                            Loan.CalcFields(Loan."Cumm. Period Repayments");
                                            //"Amount In FCY" := Loan."Period Repayments";
                                            LoanAmountToDeduct := Loan."Loan Amount" - Loan."Cumm. Period Repayments" - Loan."Initial Paid Amount";
                                            if (LoanAmountToDeduct > Loan."Period Repayments") then
                                                LoanAmountToDeduct := Loan."Period Repayments";
                                            //Amount := Loan."Period Repayments";
                                            //"Earning Currency" := Loan."Deduction Currency";
                                            //"Country Currency" := Loan."Country Currency";
                                            //Choose exchange rate to use
                                            if ("Earning Currency" <> '') and ("Earning Currency" <> Loan."Deduction Currency") then begin
                                                if Loan."Exchange Rate Type" = Loan."Exchange Rate Type"::Current then
                                                    TotalLoanAmountinCountryCurrency += GetInDesiredCurrencyHere(Loan."Deduction Currency", "Country Currency", LoanAmountToDeduct, CalcDate('1M', "Payroll Period"))
                                                else
                                                    TotalLoanAmountinCountryCurrency += GetInDesiredCurrencyHere(Loan."Deduction Currency", "Country Currency", LoanAmountToDeduct, CalcDate('CM', Loan."Loan Date"));
                                            end else
                                                TotalLoanAmountinCountryCurrency += LoanAmountToDeduct;
                                            //"Period Repayment" := Abs("Amount In FCY") + "Interest Amount";
                                            //"Initial Amount" := Loan."Loan Amount";                                            

                                            LoanRepayments.Reset();
                                            LoanRepayments.SetRange("Loan No.", Loan.No);
                                            LoanRepayments.SetRange("Payroll Period", "Payroll Period");
                                            if LoanRepayments.FindFirst() then begin
                                                LoanRepayments."Amount Deducted" := LoanAmountToDeduct;
                                                LoanRepayments."Oustanding Balance" := Loan."Loan Amount" - Loan."Cumm. Period Repayments" - Loan."Initial Paid Amount" - LoanAmountToDeduct;
                                                LoanRepayments.Modify();
                                            end else begin
                                                LoanRepaymentInit.Reset();
                                                LoanRepaymentInit.Init();
                                                LoanRepaymentInit."Loan No." := Loan.No;
                                                LoanRepaymentInit."Payroll Period" := "Payroll Period";
                                                LoanRepaymentInit."Amount Deducted" := LoanAmountToDeduct;
                                                LoanRepaymentInit."Oustanding Balance" := Loan."Loan Amount" - Loan."Cumm. Period Repayments" - Loan."Initial Paid Amount" - LoanAmountToDeduct;
                                                LoanRepaymentInit.Insert();
                                            end;

                                        // MESSAGE('amount %1  Cul repayment %2',Amount,Loan."Cumm. Period Repayments1");
                                        //"Outstanding Amount" := Loan."Loan Amount" - Loan."Cumm. Period Repayments";
                                        //"Opening Balance" := "Outstanding Amount" - "Amount In FCY";
                                        //Loan."Opening Balance" := "Opening Balance";
                                        //Loan.Modify();
                                        //Validate(Amount);
                                        until Loan.Next() = 0;
                                        Amount := -Abs(TotalLoanAmountinCountryCurrency);
                                        Validate(Amount);
                                    end;

                                end;
                                if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Basic Pay" then begin
                                    if Empl.Get("Employee No") then begin
                                        Empl.SetRange(Empl."Pay Period Filter", PayStartDate);
                                        Empl.SetRange(Empl."Payroll Country Filter", Country);
                                        Empl.CalcFields(Basic, Empl."Basic Arrears", "Month Basic Pay");
                                        //Amount := Payments.Percentage / 100 * (Empl.Basic - Empl."Basic Arrears");
                                        Amount := ((Deductions.Percentage / 100) * (Empl."Month Basic Pay"));

                                        /*Amount := Deductions.Percentage / 100 * Empl.Basic;
                                        if "Voluntary Percentage" <> 0 then
                                            Amount := "Voluntary Percentage" / 100 * Empl.Basic;
                                        if (Deductions."PAYE Code" = true) then
                                            "Taxable amount" := Empl.Basic;*/
                                        // MESSAGE('NO ROUNDING AMOUNT=%1',Amount);

                                        Amount := PayrollRounding(Amount);//round

                                        /****"Employer Amount" := Deductions."Percentage Employer" / 100 * Empl."Month Basic Pay";
                                        "Employer Amount" := PayrollRounding("Employer Amount");//round
                                        CheckIfRatesInclusive("Employee No", "Payroll Period", Code, Amount, Country);
                                        if "Block Employee Contribution" = true then
                                            Amount := 0;
                                        if "Block Employer Contribution" = true then
                                            "Employer Amount" := 0;****/
                                        //pension amount may exceed the maximum limit but the additional amount is tax
                                        /*
                                        IF Deductions."Maximum Amount"<> 0 THEN BEGIN
                                        IF ABS(Amount) > Deductions."Maximum Amount" THEN
                                         Amount:=Deductions."Maximum Amount";
                                         "Employer Amount":=Deductions."Percentage Employer"/100*Empl.Basic;
                                         //Employer amount should not have maximum pension deduction
                                         {
                                           IF "Employer Amount">Deductions."Maximum Amount" THEN
                                      "Employer Amount":=Deductions."Maximum Amount";
                                         }
                                         */
                                        //end of Employer pension
                                        "Employer Amount" := PayrollRounding("Employer Amount");//round
                                        CheckIfRatesInclusive("Employee No", "Payroll Period", Code, "Employer Amount", Country);

                                    end;
                                end;

                                //Calculate CMFIU PAYE2
                                if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Contractual Gross Pay" then begin
                                    if Empl.Get("Employee No") then begin
                                        Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                                        Empl.SetRange(Empl."Payroll Country Filter", Country);
                                        Empl.CalcFields(Basic, Empl."Total Allowances", Empl."Month Gross Pay");
                                        Amount := ((Deductions.Percentage / 100) * (Empl."Total Allowances"));//Empl.Basic+

                                        "Taxable amount" := Empl."Total Allowances";
                                        "Is from Contractual Amount" := true;
                                        //  "Employer Amount":=PayrollRounding("Employer Amount");//round
                                        IF Empl."Month Gross Pay" > 0 then
                                            Amount := ((Deductions.Percentage / 100) * (Empl."Month Gross Pay"));
                                        Amount := PayrollRounding(Amount);//round
                                    end;
                                end;
                                /*if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Gross Less Transport" then begin
                                    if Empl.Get("Employee No") then begin
                                        Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                                        Empl.CalcFields(Basic, Empl."Total Allowances", Empl."Month Gross Pay", Empl."Gross pay", Empl."Month Transport Allowance");
                                        //Amount := ((Deductions.Percentage / 100) * (Empl."Total Allowances"));//Empl.Basic+

                                        //"Taxable amount" := Empl."Total Allowances";
                                        Amount := 0;
                                        //  "Employer Amount":=PayrollRounding("Employer Amount");//round
                                        IF (Empl."Gross pay" - Empl."Month Transport Allowance") > 0 then
                                            Amount := ((Deductions.Percentage / 100) * (Empl."Gross pay" - Empl."Month Transport Allowance"));
                                        Amount := PayrollRounding(Amount);//round
                                    end;
                                end;
                                if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Gross Less Stat Deductions" then begin
                                    if Empl.Get("Employee No") then begin
                                        Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                                        Empl.CalcFields(Basic, Empl."Total Allowances", Empl."Month Gross Pay", Empl."Gross pay", Empl."Month Statutory Deductions");

                                        //"Taxable amount" := Empl."Total Allowances";
                                        Amount := 0;
                                        //  "Employer Amount":=PayrollRounding("Employer Amount");//round
                                        IF (Empl."Gross pay" - Empl."Month Statutory Deductions") > 0 then
                                            Amount := ((Deductions.Percentage / 100) * (Empl."Gross pay" - Empl."Month Statutory Deductions"));
                                        Amount := PayrollRounding(Amount);//round
                                    end;
                                end;*/
                                //End Calculate CMFIU PAYE2
                                //Added by Jacob

                                // % of Secondment Amount
                                if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Secondment Basic" then begin
                                    if Empl.Get("Employee No") then begin
                                        Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                                        Empl.SetRange(Empl."Payroll Country Filter", Country);
                                        if Deductions.Percentage <> 0 then begin
                                            Amount := ((Deductions.Percentage / 100) * (Empl."Secondment Basic"));
                                            Amount := PayrollRounding(Amount);
                                        end;
                                        if Deductions."Percentage Employer" <> 0 then begin
                                            "Employer Amount" := (Deductions."Percentage Employer" / 100) * Empl."Secondment Basic";
                                            "Employer Amount" := PayrollRounding("Employer Amount");
                                        end;
                                    end;
                                end;

                                //Salary Recovery
                                SalaryRecoveryAmt := 0;
                                if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Salary Recovery" then begin
                                    if Empl.Get("Employee No") then begin
                                        Deductions.Reset;
                                        Deductions.SetRange(Deductions."Salary Recovery", true);
                                        if Deductions.Find('-') then begin
                                            SalarySteps.Reset;
                                            SalarySteps.SetRange(SalarySteps.Code, Deductions.Code);
                                            SalarySteps.SetRange(SalarySteps."Employee No", "Employee No");
                                            SalarySteps.SetRange(SalarySteps."Payroll Period", "Payroll Period");
                                            // SalarySteps.SETRANGE(SalarySteps."Employee No",LoanApp."Employee No");
                                            if SalarySteps.Find('-') then
                                                SalaryRecoveryAmt := SalarySteps.Amount;
                                            Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                                            Empl.SetRange(Empl."Payroll Country Filter", Country);
                                            // Empl.CALCFIELDS();
                                            Amount := ((Deductions.Percentage / 100) * SalaryRecoveryAmt);
                                            Amount := PayrollRounding(Amount);//round
                                        end;
                                    end;
                                end;
                                //end of salary recovery

                                if Deductions.CoinageRounding = true then begin
                                    //     HRSetup.GET();
                                    //     Maxlimit:=HRSetup."Pension Limit Amount";
                                    Retirement := Deductions.CoinageRounding;
                                    if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Basic Pay" then
                                        "Employer Amount" := Deductions."Percentage Employer" / 100 * Empl."Basic Pay"
                                    else
                                        "Employer Amount" := Deductions."Flat Amount";
                                    "Employer Amount" := PayrollRounding("Employer Amount");//round
                                end;

                                //  IF "Employer Amount" > Deductions."Maximum Amount" THEN
                                //     "Employer Amount":=Deductions."Maximum Amount";
                                Amount := PayrollRounding(Amount);//round
                                "Employer Amount" := PayrollRounding("Employer Amount");//round
                            end;

                            //added for Uganda requirements
                            // added by Lob vega
                            /*
                            IF Deductions."Calculation Method"=Deductions."Calculation Method"::"Based on Table" THEN BEGIN
                            IF Empl.GET("Employee No") THEN
                            BEGIN
                            Empl.CALCFIELDS(Empl."Total Allowances");
                            Amount:=((Deductions.Percentage/100)* (Empl."Basic Pay"+Empl."Total Allowances"));
                            "Employer Amount":=((Deductions.Percentage/100)*(Empl."Basic Pay"+Empl."Total Allowances"));
                             Amount:=PayrollRounding(Amount);
                            "Employer Amount":=PayrollRounding("Employer Amount");
                            END;
                            END;
                            */
                            //added for BM requirements
                            if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Basic Pay+Hse Allowance" then begin
                                if Empl.Get("Employee No") then begin
                                    //SalarySteps.GET(Empl."Salary Steps",SalarySteps.Level::"Level 1",Empl."Salary Scheme Category");
                                    //Amount:=((Deductions.Percentage/100)* (Empl."Basic Pay"+SalarySteps."House allowance"));
                                    //"Employer Amount":=((Deductions.Percentage/100)*(Empl."Working Days Per Year"+SalarySteps."House allowance"));
                                    Amount := PayrollRounding(Amount);
                                    "Employer Amount" := PayrollRounding("Employer Amount");
                                end;
                            end;
                            //
                            if Type = Type::Deduction then
                                Amount := -Amount;

                            //*******New Addition*******************
                            if Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Table" then begin
                                Empl.Reset;
                                Empl.SetRange(Empl."No.", "Employee No");
                                Empl.SetRange(Empl."Pay Period Filter", PayStartDate);
                                Empl.SetRange(Empl."Payroll Country Filter", Country);
                                Empl.CalcFields(Empl."Total Allowances", Empl.Basic);
                                // used gross pay new requirement for NHIF changed by Linus
                                // MESSAGE('Deduction Table');
                                //MESSAGE('TaxableAllowance%1',Empl."Total Allowances");
                                Amount := -(GetBracket(Deductions, Empl."Total Allowances", "Employee Tier I", "Employee Tier II"));
                                //IF Deductions."NSSF Deduction"=TRUE THEN
                                //  "Employer Amount":=(GetBracket(Deductions,Empl."Total Allowances","Employer Tier I","Employer Tier II")) ELSE
                                // "Employer Amount":=0;

                            end;

                            if Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Base Amount" then begin
                                Amount := Deductions.Percentage / 100 * Deductions."Base Amount";
                                Amount := PayrollRounding(Amount);
                                "Employer Amount" := Deductions."Percentage Employer" / 100 * Deductions."Base Amount";
                                "Employer Amount" := PayrollRounding("Employer Amount");

                            end;

                        end;

                    //IF (Type=Type::Loan) THEN BEGIN
                    Type::Loan:
                        begin
                            //ERROR('...9');
                            LoanApp.Reset;
                            LoanApp.SetRange(LoanApp."Loan No", Code);
                            LoanApp.SetRange(LoanApp."Employee No", "Employee No");
                            if LoanApp.Find('-') then begin
                                if LoanProductType.Get(LoanApp."Loan Product Type") then
                                    Description := LoanProductType.Description;
                                Amount := -LoanApp.Repayment;
                                Validate(Amount);
                            end;

                        end;
                end;
                //**********END**************************************************************************
                //MODIFY;//check this

            end;
        }
        field(5; "Effective Start Date"; Date)
        {

            trigger OnValidate()
            begin
                //FRED 1/6/23 - Cater for cases of future commencement date, if the allowance/deduction will not start this period, set period to blank
                if "Effective Start Date" <> 0D then begin
                    //Get current period
                    PayPeriodRec.Reset;
                    PayPeriodRec.SetCurrentKey("Starting Date");
                    PayPeriodRec.SetRange(PayPeriodRec."Close Pay", false);
                    PayPeriodRec.SetAscending("Starting Date", true);
                    if PayPeriodRec.FindFirst then begin
                        if (PayPeriodRec."Starting Date" <= "Effective Start Date") and ((CalcDate('1M', PayPeriodRec."Starting Date") - 1) >= "Effective Start Date") then begin
                            "Payroll Period" := PayPeriodRec."Starting Date";
                            Validate("Payroll Period");
                        end else
                            "Payroll Period" := 0D;
                    end;
                end;
            end;
        }
        field(6; "Effective End Date"; Date)
        {

            trigger OnValidate()
            begin
                if ("Effective Start Date" <> 0D) and (("Effective End Date" < "Effective Start Date")) then
                    Error('The effective end date cannot be earlier than the start date!');
            end;
        }
        field(7; "Payroll Period"; Date)
        {
            NotBlank = false;
            TableRelation = "Payroll Period"."Starting Date";
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                "Is Flat Amount" := FnUpdateFormulaOnMatrix();

                if PayPeriod.Get("Payroll Period") then
                    "Pay Period" := PayPeriod.Name;
            end;
        }
        field(8; Amount; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                "Is Flat Amount" := FnUpdateFormulaOnMatrix();
                /*if (Type = Type::Payment) then
                    Payments.Reset();
                Payments.SetRange(Code, Code);
                Payments.setrange(Country, Country);
                //if Payments.Get(Code) then begin
                if payments.findfirst then
                    //if Payments.Get(Code) then
                        if Payments."Reduces Tax" then begin
                        //Amount:=-Amount;
                    end;*/
                if (Type = Type::Payment) then
                    if Amount < 0 then
                        Error('Earning %1 for staff %2 of payroll country %3 is negative (%4). It should be positive!', Description, "Employee No", Country, Amount);

                if (Type = Type::Deduction) then
                    if (Amount > 0) then
                        Amount := -Amount;

                /*if (Type = Type::Deduction) then begin

                    Deductions.Reset();
                    Deductions.SetRange(Code, Code);
                    Deductions.setrange(Country, Country);
                    if Deductions.findfirst then begin
                        //if Deductions.Get(Code) then begin
                        if Deductions."Pension Arrears" = true then begin
                            //IF Empl.GET("Employee No") THEN BEGIN
                            // Empl.SETRANGE(Empl."Pay Period Filter",PayStartDate);

                            "Employer Amount" := 2 * Amount;
                            "Employer Amount" := PayrollRounding("Employer Amount");//round
                                                                                    //pension amount may exceed the maximum limit but the additional amount is tax
                                                                                    // END;
                        end;
                    end;
                end;*/
                // TESTFIELD(Closed,FALSE);
                //Added
                /*if "Loan Repay" = true then begin
                    if Loan.Get(Rec.Code, Rec."Employee No") then begin
                        Loan.CalcFields(Loan."Cumm. Period Repayments");
                        "Period Repayment" := Abs(Amount) + "Interest Amount";
                        "Initial Amount" := Loan."Loan Amount";
                        // MESSAGE('amount %1  Cul repayment %2',Amount,Loan."Cumm. Period Repayments1");
                        "Outstanding Amount" := Loan."Loan Amount" - Loan."Cumm. Period Repayments";
                    end;
                end;*/
                //Amount:=PayrollRounding(Amount);
                /*if "Manual Entry" then begin
                    if Empl.Get("Employee No") then begin
                        Empl.SetRange(Empl."Pay Period Filter", "Payroll Period");
                        Empl.SetRange(Empl."Payroll Country Filter", Country);
                        Empl.CalcFields(Empl."Total Allowances", Empl."Total Deductions");

                    end;
                end;*/
                /*
                IF NOT "Manual Entry" THEN
                BEGIN
                IF Empl.GET("Employee No") THEN
                BEGIN
                Empl.SETRANGE(Empl."Pay Period Filter","Payroll Period");
                Empl.CALCFIELDS(Empl."Total Allowances",Empl."Total Deductions");
                IF ((Empl."Total Allowances"+Empl."Total Deductions"))<ROUND((Empl."Total Allowances")*1/3,0.02) THEN
                MESSAGE('Assigning this deduction for Employee %1 will result in a less 1/3 Rule, A Third Gross Pay=%2 Total deductions=%3'
                ,"Employee No",ROUND((Empl."Total Allowances")*1/3,0.02),Empl."Total Deductions");
                
                END;
                END;
                */
                Amount := PayrollRounding(Amount);

            end;
        }
        field(9; Description; Text[80])
        {
            Editable = false;
            trigger OnValidate()
            begin
                //TESTFIELD(Closed,FALSE);
            end;
        }
        field(10; Taxable; Boolean)
        {

            trigger OnValidate()
            begin
                // TESTFIELD(Closed,FALSE);
            end;
        }
        field(11; "Tax Deductible"; Boolean)
        {

            trigger OnValidate()
            begin
                //TESTFIELD(Closed,FALSE);
            end;
        }
        field(12; Frequency; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(13; "Pay Period"; Text[30])
        {
        }
        field(14; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(15; "Basic Pay"; Decimal)
        {
        }
        field(16; "Employer Amount"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                //TESTFIELD(Closed,FALSE);
            end;
        }
        field(17; "Global Dimension 1 code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(18; "Next Period Entry"; Boolean)
        {
        }
        field(19; "Posting Group Filter"; Code[20])
        {
            TableRelation = "Dimension Value";

            trigger OnValidate()
            begin
                //TESTFIELD(Closed,FALSE);
            end;
        }
        field(20; "Initial Amount"; Decimal)
        {
        }
        field(21; "Outstanding Amount"; Decimal)
        {
        }
        field(22; "Loan Repay"; Boolean)
        {

            trigger OnValidate()
            begin
                // TESTFIELD(Closed,FALSE);
            end;
        }
        field(23; Closed; Boolean)
        {
            Editable = false;
        }
        field(24; "Salary Grade"; Code[20])
        {
        }
        field(25; "Tax Relief"; Boolean)
        {
        }
        field(26; "Interest Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                // TESTFIELD(Closed,FALSE);
            end;
        }
        field(27; "Period Repayment"; Decimal)
        {

            trigger OnValidate()
            begin
                // TESTFIELD(Closed,FALSE);
            end;
        }
        field(28; "Non-Cash Benefit"; Boolean)
        {

            trigger OnValidate()
            begin
                // TESTFIELD(Closed,FALSE);
            end;
        }
        field(29; Quarters; Boolean)
        {
        }
        field(30; "No. of Units"; Decimal)
        {

            trigger OnValidate()
            begin
                HRSetup.Get;
                if Type = Type::Payment then begin

                    Payments.Reset();
                    Payments.SetRange(Code, Code);
                    Payments.setrange(Country, Country);
                    //if Payments.Get(Code) then begin
                    if payments.findfirst then begin
                        if Payments."Calculation Method" = Payments."Calculation Method"::"% of Basic after tax" then begin
                            //if Empl.Get("Employee No") then
                            //=>if HRSetup."Company overtime hours" <> 0 then
                            //=>Amount := (Empl."Hourly Rate" * "No. of Units" * Payments."Overtime Factor");///HRSetup."Company overtime hours"
                        end;

                        if Payments."Calculation Method" = Payments."Calculation Method"::"Based on Hourly Rate" then begin
                            if Empl.Get("Employee No") then
                                Amount := "No. of Units" * Empl."Daily Rate";
                            if Payments."Overtime Factor" <> 0 then
                                Amount := "No. of Units" * Empl."Daily Rate" * Payments."Overtime Factor"

                        end;

                        if (Payments."Calculation Method" = Payments."Calculation Method"::"Flat amount") and ((Payments."Flat Amount" <> 0) or ("No. of Units" <> 0)) then begin
                            if Empl.Get("Employee No") then
                                Amount := "No. of Units" * Payments."Total Amount";
                        end;


                    end;
                end;

                //*****Deductions
                if Type = Type::Deduction then begin
                    Deductions.Reset();
                    Deductions.SetRange(Code, Code);
                    Deductions.setrange(Country, Country);
                    if Deductions.findfirst then begin
                        //if Deductions.Get(Code) then begin
                        if Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Hourly Rate" then begin
                            if Empl.Get("Employee No") then
                                Amount := -"No. of Units" * Empl."Hourly Rate"
                        end;

                        if Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Daily Rate " then begin
                            if Empl.Get("Employee No") then
                                Amount := -"No. of Units" * Empl."Daily Rate"
                        end;

                        if (Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat Amount") and ((Deductions."Flat Amount" <> 0) or ("No. of Units" <> 0)) then begin
                            if Empl.Get("Employee No") then
                                Amount := -"No. of Units" * Deductions."Flat Amount";
                        end;

                    end;
                end;
                //TESTFIELD(Closed,FALSE);
            end;
        }
        field(31; Section; Code[20])
        {
        }
        field(33; Retirement; Boolean)
        {

            trigger OnValidate()
            begin
                // TESTFIELD(Closed,FALSE);
            end;
        }
        field(34; CFPay; Boolean)
        {

            trigger OnValidate()
            begin
                // TESTFIELD(Closed,FALSE);
            end;
        }
        field(35; BFPay; Boolean)
        {

            trigger OnValidate()
            begin
                // TESTFIELD(Closed,FALSE);
            end;
        }
        field(36; "Opening Balance"; Decimal)
        {
        }
        field(37; DebitAcct; Code[20])
        {
        }
        field(38; CreditAcct; Code[20])
        {
        }
        field(39; Shares; Boolean)
        {
        }
        field(40; "Show on Report"; Boolean)
        {
        }
        field(41; "Earning/Deduction Type"; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(42; "Time Sheet"; Boolean)
        {
        }
        field(43; "Basic Salary Code"; Boolean)
        {
        }
        field(44; "Payroll Group"; Code[20])
        {
            TableRelation = "Employee Posting Group".Code;
        }
        field(45; Paye; Boolean)
        {
        }
        field(46; "Taxable amount"; Decimal)
        {
        }
        field(47; "Less Pension Contribution"; Decimal)
        {
        }
        field(48; "Monthly Personal Relief"; Decimal)
        {
        }
        field(49; "Normal Earnings"; Boolean)
        {
            Editable = false;
        }
        field(50; "Monthly Self Contribution"; Decimal)
        {
        }
        field(51; "Monthly Self Cummulative"; Decimal)
        {
        }
        field(52; "Company Monthly Contribution"; Decimal)
        {
        }
        field(53; "Company Cummulative"; Decimal)
        {
        }
        field(54; "Main Deduction Code"; Code[20])
        {
        }
        field(55; "Opening Balance Company"; Decimal)
        {
        }
        field(56; "Insurance Code"; Boolean)
        {
        }
        field(57; "Reference No"; Code[50])
        {
        }
        field(58; "Manual Entry"; Boolean)
        {
        }
        field(59; "Salary Pointer"; Code[20])
        {
        }
        field(60; "Employee Voluntary"; Decimal)
        {

            trigger OnValidate()
            begin
                Amount := -(Abs(Amount) + "Employee Voluntary");
            end;
        }
        field(61; "Employer Voluntary"; Decimal)
        {
        }
        field(62; "Loan Product Type"; Code[20])
        {
            TableRelation = "Loan Product Type".Code;
        }
        field(63; "June Paye"; Decimal)
        {
        }
        field(64; "June Taxable Amount"; Decimal)
        {
        }
        field(65; "June Paye Diff"; Decimal)
        {
        }
        field(66; "Gratuity PAYE"; Decimal)
        {

            trigger OnValidate()
            begin
                if Paye = true then
                    Rec.Modify;
            end;
        }
        field(67; "Basic Pay Arrears"; Boolean)
        {
        }
        field(68; "Policy No./Loan No."; Code[20])
        {
        }
        field(69; "Loan Balance"; Decimal)
        {
        }
        field(70; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(71; "Global Dimension 3 Code"; Code[20])
        {
        }
        field(72; Information; Boolean)
        {
        }
        field(73; Cost; Decimal)
        {

            trigger OnValidate()
            begin
                Validate(Code);
            end;
        }
        field(74; "Employee Tier I"; Decimal)
        {
        }
        field(75; "Employee Tier II"; Decimal)
        {
        }
        field(76; "Employer Tier I"; Decimal)
        {
        }
        field(77; "Employer Tier II"; Decimal)
        {
        }
        field(78; "Loan Interest"; Decimal)
        {
        }
        field(50000; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(50001; Balance; Decimal)
        {
        }
        field(50002; "Suspend Start Date"; Date)
        {
        }
        field(50003; "Suspend End Date"; Date)
        {
        }
        field(50004; Suspended; Boolean)
        {
        }
        field(50005; "Suspended Amount"; Decimal)
        {
        }
        field(50006; "Vol. amount"; Decimal)
        {
        }
        field(50007; "Emp Oustanding Balance"; Decimal)
        {
        }
        field(50008; "Imported Record"; Boolean)
        {
        }
        field(50009; "Amount  less interest"; Decimal)
        {
            CalcFormula = Sum("Loans transactions"."Period Repayments" WHERE(Employee = FIELD("Employee No"),
                                                                              Code = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(50010; "Top Up Share"; Decimal)
        {
        }
        field(60000; "Pension Updated?"; Boolean)
        {
        }
        field(60001; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
        }
        field(60002; "Block Employee Contribution"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60003; "Block Employer Contribution"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60004; "Voluntary Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60005; Relief; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60006; "Pay Type"; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(60007; "Do Not Deduct"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60008; Country; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                Validate("Code")
            end;
        }
        field(60009; "Transport Allowance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60010; "Gross Pay"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60011; "Is Statutory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60012; "Earning Currency"; Code[50])
        {
            TableRelation = "Currency";
            trigger OnValidate()
            begin
                Validate("Amount In FCY");
            end;
        }
        field(60013; "Country Currency"; Code[50])
        {
            Editable = false;
            TableRelation = "Currency";
        }
        field(60014; "Amount In FCY"; Decimal)
        {
            Caption = 'Amount (FCY)';
            //If amount is in another currency
            trigger OnValidate()
            var
                PayrollCountry: Record "Country/Region";
                localCurrencyCode: Code[50];
                GenLedgerSetup: Record "General Ledger Setup";
                CurrencyExchangeRate: Record "Currency Exchange Rate";
                CurrExchangeRateDate: Date;
                Fcy1ToLcyRate: Decimal;
                LcyToFcy2Rate: Decimal;
                ExchangeRate: Decimal;
                SkipEntry: Boolean;
            begin
                if "Amount In FCY" <> 0 then begin
                    Amount := "Amount In FCY";
                    "Is Flat Amount" := FnUpdateFormulaOnMatrix();
                    SkipEntry := false;
                    //Only applicable to flat amounts
                    //Country may change, so just keep fetching the country currency
                    //=>if "Country Currency" = '' then begin
                    PayrollCountry.reset();
                    PayrollCountry.SetRange(Code, Country);
                    if PayrollCountry.FindFirst() then
                        "Country Currency" := PayrollCountry."Country Currency";
                    //=>end;
                    if "Earning Currency" = '' then
                        "Earning Currency" := "Country Currency";

                    if (("Country Currency" <> '') and ("Earning Currency" <> '')) then begin
                        if (Type = Type::Payment) then begin
                            Payments.reset();
                            Payments.SetRange(Code, Code);
                            Payments.SetRange(Country, Country);
                            Payments.SetRange("Calculation Method", Payments."Calculation Method"::"Flat amount");
                            if not Payments.FindFirst() then
                                SkipEntry := true;//Error('This operation is only applicable to Flat Amount earnings!');
                        end;

                        if (Type = Type::Deduction) then begin
                            "Amount In FCY" := -ABS("Amount In FCY");
                            Deductions.reset();
                            Deductions.SetRange(Code, Code);
                            Deductions.SetRange(Country, Country);
                            Deductions.SetRange("Calculation Method", Payments."Calculation Method"::"Flat amount");
                            if not Payments.FindFirst() then
                                SkipEntry := true;// Error('This operation is only applicable to Flat Amount deductions!');
                        end;

                        if (not SkipEntry) and ("Earning Currency" <> '') then begin
                            if "Country Currency" = "Earning Currency" then
                                Amount := "Amount In FCY"
                            else begin
                                FnCalculateAmountFromExchangeRate(CalcDate('1M', "Payroll Period"));
                            end;
                        end;
                    end;
                end;
            end;
        }
        field(60015; "Is Flat Amount"; Boolean)
        {

        }
        field(60016; "Transaction Title"; Code[250])
        {
            TableRelation = "Payroll Universal Trans Codes".Title;
        }
        field(60017; "Is CBHI"; Boolean)
        {
            Editable = false;
        }
        field(60018; "Housing Allowance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60019; "Maternity Leave Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60020; "Social Security Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60021; "Medical Insurance Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60022; "MMI Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60023; "Emp Is Inactive"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60024; "Is Loan Transaction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60025; "Loan No."; Code[20])
        {
            TableRelation = "Loans transactions";
            Editable = false;
        }
        field(60026; "Amount Type"; Option)
        {
            OptionMembers = Gross,Net;

            trigger OnValidate()
            begin
                //if ("Amount Type" = Rec."Amount Type"::Net) and (Country <> 'EXPATRIATE') and (Country <> 'RWANDA') and (Country <> 'BURUNDI') and (Country <> 'GHANA') and (Country <> 'KENYA') and (Country <> 'UGANDA') and (Country <> 'TANZANIA') and (Country <> 'ZIMBABWE') then
                if ("Amount Type" = Rec."Amount Type"::Net) and (not (Country IN ['EXPATRIATE', 'RWANDA', 'BURUNDI', 'GHANA', 'KENYA', 'UGANDA', 'TANZANIA', 'ZIMBABWE',/*from 13/08/24*/'CABIN', 'BENIN', 'ZAMBIA', 'BRAZA', 'DUBAI', 'GABON', 'INDIA', 'QATAR', 'UK', 'CAMEROON', 'NIGERIA', 'S.AFRICA', 'CONSULTANT'])) then
                    Error('Currently the grossing up feature is only applicable to a few countries. %1 is not one of them!', Country);
            end;
        }
        field(60027; "Net Amount"; Decimal)
        {
        }
        field(60028; "Reduces Gross"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60029; "Loan Cleared"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60030; "Start Date"; Date)
        {
            trigger OnValidate()
            var
                PeriodEndDate: Date;
                PayTrans: Record "Assignment Matrix";
            begin
                if "Start Date" <> 0D then begin
                    if "End Date" = 0D then
                        "End Date" := CalcDate('CM', "Payroll Period");
                    if "Payroll Period" = 0D then
                        Error('Kindly enter the payroll period before proceeding!');
                    PeriodEndDate := CalcDate('CM', "Payroll Period");
                    if "Start Date" > PeriodEndDate then
                        Error('The start date must be within the current payoll month!');
                    if ("End Date" <> 0D) and ("End Date" < "Start Date") then
                        Error('The Start date cannot be later than the End Date!');
                    //If this transactions exists for last month, then start can only be restricted to this month
                    if "Start Date" < "Payroll Period" then begin
                        if "Start Date" < CalcDate('-1M', "Payroll Period") then
                            Error('Start date cannot be earlier than last month for %1 %2', Format(Type), Description);

                        PayTrans.Reset();
                        PayTrans.SetRange("Employee No", "Employee No");
                        PayTrans.SetRange("Payroll Period", CalcDate('-1M', "Payroll Period"));
                        PayTrans.SetRange(Country, Country);
                        PayTrans.SetRange(Code, Code);
                        if PayTrans.Find('-') then
                            Error('Employee %1 has the %2 for last month. The Start Date must, therefore, fall within this period!', "Employee No", Description);
                    end;
                    Validate("Full Month Amount");
                end;
            end;
        }
        field(60031; "End Date"; Date)
        {
            trigger OnValidate()
            var
                PeriodEndDate: Date;
            begin
                if "End Date" <> 0D then begin
                    if "Payroll Period" = 0D then
                        Error('Kindly enter the payroll period before proceeding!');
                    PeriodEndDate := CalcDate('CM', "Payroll Period");
                    if "End Date" > PeriodEndDate then
                        Error('The end date must be within the current payoll month!');
                    /*if ("Start Date" <> 0D) and ("End Date" < "Start Date") then
                        Error('The end date cannot be earlier than the Start Date!');*/

                    Validate("Full Month Amount");
                end;
            end;
        }
        field(60032; "Full Month Amount"; Decimal)
        {
            trigger OnValidate()
            var
                CurrMonthEnd: Date;
                CurrMonthStart: Date;
                ProratedAmount: Decimal;
                StartDate: Date;
                EndDate: Date;
                ProRatio: Decimal;

                LastMonthEnd: Date;
                LastMonthStart: Date;
                LastMonthStartDate: Date;
                LastMonthEndDate: Date;
                LastMonthProRatio: Decimal;
            begin
                if "Full Month Amount" <> 0 then begin
                    //Last Month and this month using their own ratios as number of days vary
                    LastMonthEnd := CalcDate('<CM>', CalcDate('-1M', "Payroll Period"));
                    LastMonthStart := CalcDate('-CM', CalcDate('-1M', "Payroll Period"));
                    CurrMonthEnd := CalcDate('<CM>', "Payroll Period");
                    CurrMonthStart := CalcDate('-CM', "Payroll Period");
                    LastMonthStartDate := LastMonthStart;
                    LastMonthEndDate := LastMonthEnd;
                    StartDate := CurrMonthStart;
                    EndDate := CurrMonthEnd;
                    if ("Start Date" <> 0D) then begin
                        StartDate := "Start Date";
                        if (StartDate >= LastMonthStart) and (StartDate <= LastMonthEnd) then begin
                            LastMonthStartDate := StartDate;
                            StartDate := CurrMonthStart;
                        end;
                    end;
                    if ("End Date" <> 0D) then begin
                        EndDate := "End Date";
                        if (EndDate >= LastMonthStart) and (EndDate <= LastMonthEnd) then begin
                            LastMonthEndDate := EndDate;
                            EndDate := CurrMonthEnd;
                        end;
                    end;

                    LastMonthProRatio := 0;
                    if ("Start Date" < "Payroll Period") or ("End Date" < "Payroll Period") then
                        LastMonthProRatio := ((LastMonthEndDate - LastMonthStartDate) + 1) / ((LastMonthEnd - LastMonthStart) + 1);
                    ProRatio := ((EndDate - StartDate) + 1) / ((CurrMonthEnd - CurrMonthStart) + 1);
                    if "End Date" < "Payroll Period" then
                        ProRatio := 0;
                    ProratedAmount := ("Full Month Amount" * LastMonthProRatio) + ("Full Month Amount" * ProRatio);

                    if "Amount Type" = Rec."Amount Type"::Net then
                        "Net Amount" := ProratedAmount;
                    if "Amount Type" = Rec."Amount Type"::Gross then begin
                        if "Earning Currency" <> '' then begin
                            "Amount In FCY" := ProratedAmount;
                            Validate("Amount In FCY");
                        end
                        else
                            Amount := ProratedAmount;
                    end;
                end;
            end;
        }
        field(60033; "Is from Contractual Amount"; Boolean)
        {
            Editable = false;
        }
        field(60034; Insurable; Boolean)
        {
            Editable = false;
        }
        field(60035; "Exclude from Calculations"; Boolean)
        {
        }
        field(60036; "Exclude from Payroll"; Boolean)
        {
        }
        field(60037; "Overtime Allowance"; Boolean)
        {
        }
        field(60038; "Overtime Hours (Sectors)"; Decimal)
        {
            trigger OnValidate()
            var
                TotalAmount: Decimal;
            begin
                if not "Overtime Allowance" then
                    Error('This is not an overtime allowance. It is %1', Description);
                if ("Overtime Hours" <> 0) or ("Overtime Minutes" <> 0) then begin
                    Empl.Reset();
                    Empl.SetRange("No.", "Employee No");
                    if Empl.FindFirst() then begin
                        "Emp Is Inactive" := false;
                        if (Empl.Status = Empl.Status::Inactive) or (Empl."Under Terminal Dues Processing") then
                            "Emp Is Inactive" := true;
                        if (Empl."Hourly Rate" = 0) or (Empl."Overtime Amount Currency" = '') then
                            Error('You must populate the overtime fields in the employee card for staff %1 before proceeding!', "Employee No");
                        "Overtime Amount Type" := Empl."Overtime Amount Type"; //Archive
                        "Overtime Amount Currency" := Empl."Overtime Amount Currency";
                        "Overtime Hourly Rate" := Empl."Hourly Rate";

                        TotalAmount := "Overtime Hours (Sectors)" * Empl."Hourly Rate";
                        "Earning Currency" := Empl."Overtime Amount Currency";
                        if Empl."Overtime Amount Type" = Empl."Overtime Amount Type"::Gross then begin
                            "Amount Type" := Rec."Amount Type"::Gross;
                            "Amount In FCY" := TotalAmount;
                        end else begin
                            "Amount Type" := Rec."Amount Type"::Net;
                            "Net Amount" := TotalAmount;
                        end;
                    end;
                end;
            end;
        }
        field(60039; "Overtime RSSB Pension"; Decimal)
        {
        }
        field(60040; "Overtime Maternity Leave"; Decimal)
        {
        }
        field(60041; "Overtime PAYE"; Decimal)
        {
        }
        field(60042; "Overtime CBHI"; Decimal)
        {
        }
        field(60043; "Overtime Net"; Decimal)
        {
        }
        field(60044; "Overtime Amount Type"; Option)
        {
            Caption = 'Amount Type';
            OptionMembers = Gross,Net;
            Editable = false;
        }
        field(60045; "Overtime Amount Currency"; Code[50])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(60046; "Overtime AC"; Text[50])
        {
            Caption = 'AC';
        }
        field(60047; "Overtime Hourly Rate"; Decimal)
        {
        }
        field(60048; "Overtime Hours"; Decimal)
        {
            trigger OnValidate()
            begin
                "Overtime Hours (Sectors)" := "Overtime Hours" + ("Overtime Minutes" / 60);
                Validate("Overtime Hours (Sectors)");
            end;
        }
        field(60049; "Overtime Minutes"; Decimal)
        {
            trigger OnValidate()
            begin
                "Overtime Hours (Sectors)" := "Overtime Hours" + ("Overtime Minutes" / 60);
                Validate("Overtime Hours (Sectors)");
            end;
        }

        field(60050; "Lumpsum PAYE"; Decimal)
        {

        }
        field(60051; "Overtime Period"; Date)
        {
            TableRelation = "Payroll Period"."Starting Date";
        }
        field(60052; "Show on Payslip"; Boolean)
        {
            CalcFormula = lookup(Deductions."Show on Payslip Information" WHERE(Country = FIELD(Country), Code = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(60053; "Statutory Net"; Decimal)
        { }
        field(60054; "Special Transport Allowance"; Boolean)
        { }
        field(60055; "Inhouse instructor Allowance"; Boolean)
        { }
        field(60056; "Allow temp staff activation"; Boolean)
        { }
        field(60057; "Statutory Gross"; Decimal)
        { }
        field(60058; "Statutory Deductions"; Decimal)
        { }
        field(60059; "Inhouse Allowance Processed"; Boolean)
        { }
        field(60060; "Lumpsum Social Security"; Decimal)
        {

        }
    }

    keys
    {
        key(PK; "Employee No", Type, "Code", "Payroll Period", "Reference No", Country, "Effective Start Date", "Overtime Period")
        {
            Clustered = true;
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key2; "Employee No", Taxable, "Tax Deductible", Retirement, "Non-Cash Benefit", "Tax Relief")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key3; Type, "Code", "Posting Group Filter")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key4; "Non-Cash Benefit")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key5; Quarters)
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key6; "Non-Cash Benefit", Taxable)
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key7; Type, Retirement)
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key8; "Global Dimension 1 code", "Payroll Period", "Code")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key9; "Employee No", Shares)
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key10; Closed, "Code", Type, "Employee No")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key11; "Show on Report")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key12; "Employee No", "Code", "Payroll Period", "Next Period Entry")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key13; "Opening Balance")
        {
        }
        key(Key14; "Global Dimension 1 code", "Payroll Period", Type, "Code")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key15; "Basic Salary Code", "Basic Pay Arrears")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount;
        }
        key(Key16; Paye)
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount, "Taxable amount", "Less Pension Contribution";
        }
        key(Key17; "Employee No", "Payroll Period", Type, "Non-Cash Benefit", "Normal Earnings")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount, "Taxable amount";
        }
        key(Key18; "Posting Group Filter")
        {
            SumIndexFields = "Employer Amount", "Interest Amount", "Period Repayment", "No. of Units", "Opening Balance", Amount, "Taxable amount";
        }
        key(Key19; "Payroll Period", Type, "Code")
        {
            SumIndexFields = Amount;
        }
        key(Key20; Type, "Employee No", "Payroll Period", "Insurance Code")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //IF Closed=TRUE THEN
        //ERROR('You are not allowed to delete already closed payroll entries.');
    end;

    trigger OnInsert()
    begin
        //FRED 1/6/23 - Cater for cases of future commencement date, if the allowance/deduction will not start this period, set period to blank
        if "Effective Start Date" <> 0D then begin
            //Get current period
            PayPeriodRec.Reset;
            PayPeriodRec.SetCurrentKey("Starting Date");
            PayPeriodRec.SetRange(PayPeriodRec."Close Pay", false);
            PayPeriodRec.SetAscending("Starting Date", true);
            if PayPeriodRec.FindFirst then begin
                if (PayPeriodRec."Starting Date" <= "Effective Start Date") and ((CalcDate('1M', PayPeriodRec."Starting Date") - 1) >= "Effective Start Date") then begin
                    "Payroll Period" := PayPeriodRec."Starting Date";
                    Validate("Payroll Period");
                end else
                    "Payroll Period" := 0D;
            end;
        end;
        "Is Flat Amount" := FnUpdateFormulaOnMatrix();

        //Consider limits
        if Type = Type::Deduction then begin
            Deductions.Reset();
            Deductions.SetRange(Code, Code);
            Deductions.SetRange(Country, Country);
            Deductions.SetFilter("Maximum Amount", '<>%1', 0);
            if Deductions.FindFirst() then begin
                if Abs(Amount) > abs(Deductions."Maximum Amount") then
                    Amount := abs(Deductions."Maximum Amount");
            end;
        end;
    end;

    trigger OnModify()
    begin
        //FRED 1/6/23 - Cater for cases of future commencement date, if the allowance/deduction will not start this period, set period to blank
        if "Effective Start Date" <> 0D then begin
            //Get current period
            PayPeriodRec.Reset;
            PayPeriodRec.SetCurrentKey("Starting Date");
            PayPeriodRec.SetRange(PayPeriodRec."Close Pay", false);
            PayPeriodRec.SetAscending("Starting Date", true);
            if PayPeriodRec.FindFirst then begin
                if (PayPeriodRec."Starting Date" <= "Effective Start Date") and ((CalcDate('1M', PayPeriodRec."Starting Date") - 1) >= "Effective Start Date") then begin
                    "Payroll Period" := PayPeriodRec."Starting Date";
                    Validate("Payroll Period");
                end else
                    "Payroll Period" := 0D;
            end;
        end;
        "Is Flat Amount" := FnUpdateFormulaOnMatrix();

        //Consider limits
        if Type = Type::Deduction then begin
            Deductions.Reset();
            Deductions.SetRange(Code, Code);
            Deductions.SetRange(Country, Country);
            Deductions.SetFilter("Maximum Amount", '<>%1', 0);
            if Deductions.FindFirst() then begin
                if Abs(Amount) > abs(Deductions."Maximum Amount") then
                    Amount := abs(Deductions."Maximum Amount");
            end;
        end;
    end;

    var
        Payments: Record Earnings;
        Deductions: Record Deductions;
        Paydeduct: Decimal;
        Empl: Record Employee;
        PayPeriod: Record "Payroll Period";
        Loan: Record "Loans transactions";
        PayStartDate: Date;
        PayPeriodText: Text[30];
        TableAmount: Decimal;
        Basic: Decimal;
        ReducedBal: Decimal;
        InterestAmt: Decimal;
        HRSetup: Record "Human Resources Setup";
        Maxlimit: Decimal;
        Benefits: Record "Brackets Lines";
        InterestDiff: Decimal;
        SalarySteps: Record "Assignment Matrix";
        LoanProductType: Record "Loan Product Type";
        LoanApp: Record "Loan Application";
        "reference no": Record "Assignment Matrix";
        LoanBalance: Decimal;
        TotalRepayment: Decimal;
        SalaryRecoveryAmt: Decimal;
        LoanTopUps: Record "Loan Top-up";
        TotalTopups: Decimal;
        BasicSalary: Decimal;
        Month: Date;
        Assignmatrix: Record "Assignment Matrix";
        BasicSalaryCode: Code[30];
        CurrExchRate: Record "Currency Exchange Rate";
        PayrolPeriod: Record "Payroll Period";
        BasicArrears: Decimal;
        PayPeriodRec: Record "Payroll Period";
        TotalLoanAmountinCountryCurrency: Decimal;
        LoanAmountToDeduct: Decimal;
        LoanRepayments: Record "Loan Repayments";
        LoanRepaymentInit: Record "Loan Repayments";
        PayrollCountry: Record "Country/Region";
        ApplicablePercent: Decimal;

    procedure GetPayPeriod()
    begin
        PayPeriod.SetRange(PayPeriod."Close Pay", false);
        if PayPeriod.FindFirst then
            PayStartDate := PayPeriod."Starting Date";
        PayPeriodText := PayPeriod.Name;
    end;

    procedure GetBracket(DeductionsRec: Record Deductions; BasicPay: Decimal; var TierI: Decimal; var TierII: Decimal) TotalAmt: Decimal
    var
        BracketTable: Record "Brackets Lines";
        BracketSource: Record "Bracket Tables";
        Loop: Boolean;
        PensionableAmt: Decimal;
        TableAmount: Decimal;
        i: Integer;
    begin
        TotalAmt := 0;
        TableAmount := 0;
        i := 0;
        if BracketSource.Get(DeductionsRec."Deduction Table") then;
        BracketTable.SetRange(BracketTable."Table Code", DeductionsRec."Deduction Table");
        BracketTable.SetRange(Institution, DeductionsRec."Institution Code");
        if BracketTable.Find('-') then begin
            case BracketSource.Type of
                BracketSource.Type::Fixed:
                    begin
                        repeat
                            if ((BasicPay >= BracketTable."Lower Limit") and (BasicPay <= BracketTable."Upper Limit")) then
                                TotalAmt := BracketTable.Amount;
                        until BracketTable.Next = 0;
                    end;

                BracketSource.Type::"Graduating Scale":
                    begin
                        PensionableAmt := BasicPay;
                        repeat
                            i := i + 1;
                            if BasicPay <= 0 then
                                Loop := true
                            else begin
                                if BasicPay >= BracketTable."Upper Limit" then begin
                                    TableAmount := (BracketTable."Taxable Amount" * BracketTable.Percentage / 100);
                                    if Deductions."Pension Scheme" then begin
                                        if i = 1 then
                                            TierI := TableAmount
                                        else
                                            TierII := TableAmount;
                                    end;
                                    TotalAmt := TotalAmt + TableAmount;
                                end
                                else begin
                                    PensionableAmt := PensionableAmt - BracketTable."Lower Limit";
                                    TableAmount := PensionableAmt * (BracketTable.Percentage / 100);
                                    Loop := true;
                                    if Deductions."Pension Scheme" then begin
                                        if i = 1 then
                                            TierI := TableAmount
                                        else
                                            TierII := TableAmount;
                                    end;
                                    TotalAmt := TotalAmt + TableAmount;
                                end;
                            end;
                        until (BracketTable.Next = 0) or Loop = true;
                    end;
            end;
        end;

        exit(TotalAmt);
        //ELSE
        //MESSAGE('The Brackets have not been defined');
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
        PaymentDeduction."Payroll Period" := PayStartDate;
        PaymentDeduction.Amount := ReducedBalance * InterestDiff;
        PaymentDeduction."Non-Cash Benefit" := true;
        PaymentDeduction.Taxable := true;
        //PaymentDeduction."Next Period Entry":=TRUE;
        allowances.Reset();
        allowances.SetRange(Code, BenefitCode);
        allowances.setrange(Country, Country);
        //if allowances.Get(BenefitCode) then
        if allowances.findfirst then
            PaymentDeduction.Description := allowances.Description;
        PaymentDeduction.Insert;
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

    procedure CheckIfRatesInclusive(EmpNo: Code[20]; PayPeriod: Date; DeductionCode: Code[20]; var DeductibleAmt: Decimal; country: Code[50])
    var
        DeductionsRec: Record Deductions;
        BracketTable: Record "Brackets Lines";
        BracketSource: Record "Bracket Tables";
        AssMatrix: Record "Assignment Matrix";
        i: Integer;
    begin
        DeductionsRec.Reset();
        DeductionsRec.SetRange(Code, Code);
        DeductionsRec.setrange(Country, country);
        if DeductionsRec.findfirst then begin
            //if DeductionsRec.Get(DeductionCode) then begin
            if DeductionsRec."Pension Scheme" then begin
                i := 0;
                DeductionsRec.Reset;
                DeductionsRec.SetRange("Calculation Method", DeductionsRec."Calculation Method"::"Based on Table");
                DeductionsRec.SetRange("Pension Scheme", true);
                DeductionsRec.setrange(Code, country);
                if DeductionsRec.Find('-') then begin
                    if BracketSource.Get(DeductionsRec."Deduction Table") then;
                    BracketTable.SetRange(BracketTable."Table Code", DeductionsRec."Deduction Table");
                    if BracketTable.Find('-') then
                        repeat
                            i := i + 1;
                            if BracketTable."Contribution Rates Inclusive" then begin
                                AssMatrix.Reset;
                                AssMatrix.SetRange("Employee No", EmpNo);
                                AssMatrix.SetRange("Payroll Period", PayPeriod);
                                AssMatrix.SetRange(Type, AssMatrix.Type::Deduction);
                                AssMatrix.SetRange(Code, DeductionsRec.Code);
                                if AssMatrix.Find('-') then begin
                                    if i = 1 then
                                        DeductibleAmt := DeductibleAmt - AssMatrix."Employee Tier I"
                                    else
                                        DeductibleAmt := DeductibleAmt - AssMatrix."Employee Tier II";
                                end;
                            end;
                        until
                         BracketTable.Next = 0;
                end;
            end;
        end;
    end;

    procedure FnCalculateArrearsPension(EmployeeNos: Code[10]; PeriodM: Date)
    var
        Payments: Record Earnings;
        AssMatrix: Record "Assignment Matrix";
        AsMatrix: Record "Assignment Matrix";
        PensionArrears: Decimal;
        EmpPensionArrears: Decimal;
        Deductions: Record Deductions;
    begin
        Payments.Reset;
        Payments.SetRange("Basic Pay Arrears", true);
        if Payments.FindFirst then begin
            AssMatrix.Reset;
            AssMatrix.SetRange(AssMatrix.Code, Payments.Code);
            AssMatrix.SetRange(AssMatrix."Payroll Period", PeriodM);
            AssMatrix.SetRange("Employee No", EmployeeNos);
            if AssMatrix.FindFirst then begin
                BasicArrears := AssMatrix.Amount;
                //MESSAGE('BasicAmount%1Employee%2',BasicArrears,EmployeeNos);

                Deductions.Reset;
                Deductions.SetRange(Deductions.Code, 'D23');
                if Deductions.FindFirst then begin
                    AsMatrix.Reset;
                    AsMatrix.SetRange(AsMatrix.Code, Deductions.Code);
                    AsMatrix.SetRange(AsMatrix."Payroll Period", PeriodM);
                    AsMatrix.SetRange("Employee No", EmployeeNos);
                    if AsMatrix.FindFirst then begin
                        AsMatrix.Validate(Code);
                        PensionArrears := -(BasicArrears * Deductions.Percentage / 100);
                        EmpPensionArrears := (BasicArrears * Deductions."Percentage Employer" / 100);
                        AsMatrix.Amount := AsMatrix.Amount + PensionArrears;
                        AsMatrix."Employer Amount" := AsMatrix."Employer Amount" + EmpPensionArrears;
                        //MESSAGE('BasicAmount%1Employee%2 PensionArrears%3EmployerPension%4',BasicArrears,EmployeeNos,PensionArrears,EmpPensionArrears);
                        AsMatrix.Modify;
                    end;
                end;
            end;
        end;
    end;

    procedure FnUpdateFormulaOnMatrix() IsFlatAmount: Boolean
    begin
        IsFlatAmount := false;
        if (Country <> '') and (Code <> '') then begin
            if Type = Type::Payment then begin
                Payments.Reset();
                Payments.SetRange(Country, Country);
                Payments.SetRange(Code, Code);
                //Payments.SetRange("Calculation Method", Payments."Calculation Method"::"Flat amount");
                if Payments.FindFirst() then begin
                    IF Payments."Universal Title" = '' THEN
                        ERROR('Earning of code %1 for country %2 must have a universal title!', Payments.Code, Payments.Country);
                    if Payments."Calculation Method" = Payments."Calculation Method"::"Flat amount" then
                        IsFlatAmount := true;
                    if ("Transaction Title" = '') or ("Transaction Title" <> Payments."Universal Title") then
                        "Transaction Title" := Payments."Universal Title";
                    if ("Transaction Title" = 'SPECIAL TRANSPORT ALLOWANCE ARREAS') then
                        "Special Transport Allowance" := true;
                    "Overtime Allowance" := Payments.OverTime;
                end;
            end;

            if Type = Type::Deduction then begin
                Deductions.Reset();
                Deductions.SetRange(Country, Country);
                Deductions.SetRange(Code, Code);
                //Deductions.SetRange("Calculation Method", Deductions."Calculation Method"::"Flat amount");
                if Deductions.FindFirst() then begin
                    IF Deductions."Universal Title" = '' THEN
                        ERROR('Deduction of code %1 for country %2 must have a universal title!', Deductions.Code, Deductions.Country);
                    if Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat amount" then
                        IsFlatAmount := true;
                    if ("Transaction Title" = '') or ("Transaction Title" <> Deductions."Universal Title") then
                        "Transaction Title" := Deductions."Universal Title";
                end;
            end;

        end;
        exit(IsFlatAmount);
    end;

    procedure FnCalculateAmountFromExchangeRate(ExchangeRateDate: Date)
    var
        PayrollCountry: Record "Country/Region";
        localCurrencyCode: Code[50];
        GenLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        ExchangeRate: Decimal;
        SkipEntry: Boolean;
    begin
        GenLedgerSetup.Get();
        localCurrencyCode := GenLedgerSetup."LCY Code";
        ExchangeRate := 1;
        if localCurrencyCode = '' then
            Error('The local currency code has not been specified in the General Ledger Setup!');
        CurrExchangeRateDate := ExchangeRateDate;
        Fcy1ToLcyRate := 0;
        LcyToFcy2Rate := 0;

        //We want to convert the currency from the earning currency to the country currency
        //1. Get the FCY1 to LCY rate
        /*if "Earning Currency" = localCurrencyCode then
            Fcy1ToLcyRate := 1
        else begin*/
        CurrencyExchangeRate.GetLastestExchangeRateCustom("Earning Currency", CurrExchangeRateDate, Fcy1ToLcyRate);
        if (CurrExchangeRateDate = 0D) then
            Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', "Earning Currency", localCurrencyCode);
        //end;

        //2. Get the LCY to FCY2 rate
        CurrencyExchangeRate.GetLastestExchangeRateCustom("Country Currency", CurrExchangeRateDate, LcyToFcy2Rate);
        if (CurrExchangeRateDate = 0D) then
            Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, "Country Currency");

        //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
        if LcyToFcy2Rate <> 0 then
            ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
        Amount := "Amount In FCY" * ExchangeRate;
    end;



    Procedure GetInDesiredCurrencyHere(EarningCountryCurrency: Code[50]; SelectedCountryCurrency: Code[50]; AmountToConvert: Decimal; PayDate: Date) ConvertedAmount: Decimal
    var
        PayrollCountry: Record "Country/Region";
        localCurrencyCode: Code[50];
        GenLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrExchangeRateDate: Date;
        Fcy1ToLcyRate: Decimal;
        LcyToFcy2Rate: Decimal;
        ExchangeRate: Decimal;
    begin
        if EarningCountryCurrency = '' then
            EarningCountryCurrency := SelectedCountryCurrency;

        ConvertedAmount := AmountToConvert;
        if SelectedCountryCurrency = EarningCountryCurrency then
            ConvertedAmount := AmountToConvert
        else begin
            CurrExchangeRateDate := PayDate;
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
            CurrencyExchangeRate.GetLastestExchangeRateCustom(SelectedCountryCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
            if (CurrExchangeRateDate = 0D) then
                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, SelectedCountryCurrency);

            //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
            if LcyToFcy2Rate <> 0 then
                ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
            ConvertedAmount := AmountToConvert * ExchangeRate;
        end;
        exit(ConvertedAmount);
    end;
}