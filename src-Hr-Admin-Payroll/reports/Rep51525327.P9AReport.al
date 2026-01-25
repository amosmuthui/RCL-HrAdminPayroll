report 51525327 "P9A Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/P9AReport.rdlc';
    UseRequestPage = true;

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.") ORDER(Ascending);
            RequestFilterFields = "No.", "Global Dimension 1 Code";
            column(First_Name________Middle_Name_; "First Name" + ' ' + "Middle Name")
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Company_Name; Company.Name)
            {
            }
            column(Company_Pin; Company."Company P.I.N")
            {
            }
            column(V30__; '30%')
            {
            }
            column(Actual_; 'Actual')
            {
            }
            column(Fixed_; 'Fixed')
            {
            }
            column(Employee__PIN_Number_; "PIN Number")
            {
            }
            column(FORMAT_StringDate_0___year4___; Format(StringDate, 0, '<year4>'))
            {
            }
            column(CoPin; CoPin)
            {
            }
            column(Employee_Employee__No__; Employee."No.")
            {
            }
            column(Employers_Name_Caption; Employers_Name_CaptionLbl)
            {
            }
            column(Employee_s_Main_Name_Caption; Employee_s_Main_Name_CaptionLbl)
            {
            }
            column(Employee_s_Other_Names_Caption; Employee_s_Other_Names_CaptionLbl)
            {
            }
            column(Employers_PIN_Caption; Employers_PIN_CaptionLbl)
            {
            }
            column(Employee_s_PIN_Caption; Employee_s_PIN_CaptionLbl)
            {
            }
            column(MonthCaption; MonthCaptionLbl)
            {
            }
            column(Gross_SalaryCaption; Gross_SalaryCaptionLbl)
            {
            }
            column(BenefitsCaption; BenefitsCaptionLbl)
            {
            }
            column(QuartersCaption; QuartersCaptionLbl)
            {
            }
            column(Total_A_B_CCaption; Total_A_B_CCaptionLbl)
            {
            }
            column(Defined_Contribution_Retr__SchemeCaption; Defined_Contribution_Retr__SchemeCaptionLbl)
            {
            }
            column(Taxable_AmountCaption; Taxable_AmountCaptionLbl)
            {
            }
            column(Personal_ReliefCaption; Personal_ReliefCaptionLbl)
            {
            }
            column(P_A_Y_E_TAXCaption; P_A_Y_E_TAXCaptionLbl)
            {
            }
            column(KENYA_REVENUE_AUTHORITYCaption; KENYA_REVENUE_AUTHORITYCaptionLbl)
            {
            }
            column(INCOME_TAX_DEPARTMENTCaption; INCOME_TAX_DEPARTMENTCaptionLbl)
            {
            }
            column(INCOME_TAX_DEDUCTION_CARD_YEAR_Caption; INCOME_TAX_DEDUCTION_CARD_YEAR_CaptionLbl)
            {
            }
            column(Tax_ChargedCaption; Tax_ChargedCaptionLbl)
            {
            }
            column(Owner_OccupiedCaption; Owner_OccupiedCaptionLbl)
            {
            }
            column(Retr__Contribution__Caption; Retr__Contribution__CaptionLbl)
            {
            }
            column(ACaption; ACaptionLbl)
            {
            }
            column(BCaption; BCaptionLbl)
            {
            }
            column(CCaption; CCaptionLbl)
            {
            }
            column(DCaption; DCaptionLbl)
            {
            }
            column(F__Standard_Amount_Caption; F__Standard_Amount_CaptionLbl)
            {
            }
            column(G___Lowest_of_E_F_Caption; G___Lowest_of_E_F_CaptionLbl)
            {
            }
            column(HCaption; HCaptionLbl)
            {
            }
            column(JCaption; JCaptionLbl)
            {
            }
            column(KCaption; KCaptionLbl)
            {
            }
            column(LCaption; LCaptionLbl)
            {
            }
            column(MCaption; MCaptionLbl)
            {
            }
            column(ECaption; ECaptionLbl)
            {
            }
            column(IMPORTANT; IMPORTANT)
            {
            }
            column(UseP9A_a; "UseP9A(a)")
            {
            }
            column(UseP9A_b; "UseP9A(b)")
            {
            }
            column(Two_a; "2(a)")
            {
            }
            column(Two_b_1; "2(b)(i)")
            {
            }
            column(Two_b_2; "2(b)(ii)")
            {
            }
            column(CompletionByEmployerLbl; CompletionByEmployerLbl)
            {
            }
            column(Use_P9A_1; "1_Use_P9A")
            {
            }
            column(b_Attach; b_Attach)
            {
            }
            column(InterestCaption; InterestCaptionLbl)
            {
            }
            column(Column_D_GCaption; Column_D_GCaptionLbl)
            {
            }
            column(Occupied_InterestCaption; Occupied_InterestCaptionLbl)
            {
            }
            column(Non_CashCaption; Non_CashCaptionLbl)
            {
            }
            column(Value_OfCaption; Value_OfCaptionLbl)
            {
            }
            column(Personal_File_No_Caption; Personal_File_No_CaptionLbl)
            {
            }
            column(Insurance_ReliefCaption; Insurance_ReliefCaptionLbl)
            {
            }
            dataitem("Payroll Period"; "Payroll Period")
            {
                DataItemTableView = SORTING("Starting Date") ORDER(Ascending);
                column(Payroll_PeriodX1_Name; Name)
                {
                }
                column(BenefitsVar; BenefitsVar)
                {
                }
                column(QuartersVar; QuartersVar)
                {
                }
                column(RetirementVar; RetirementVar)
                {
                }
                column(TaxableAmount1; TaxableAmount)
                {
                }
                column(Relief; Relief)
                {
                }
                column(InsuranceRelief; InsuranceRelief)
                {
                }
                column(ABS_Employee__Cumm__PAYE__; Abs(Employee."Cumm. PAYE"))
                {
                }
                column(PensionLimit; PensionLimit)
                {
                }
                column(Employee__Total_Allowances_; grosspay)
                {
                }
                column(Employee__Taxable_Allowance__Employee__Cumm__Basic_Pay__BenefitsVar_QuartersVar; grosspay + BenefitsVar + QuartersVar)
                {
                }
                column(ABS_Employee__Cumm__PAYE___Relief_InsuranceRelief; Abs(Employee."Cumm. PAYE") + Relief + InsuranceRelief)
                {
                }
                column(ABS_OccupierVar_; Abs(OccupierVar))
                {
                }
                column(V30PerPension_; "30PerPension")
                {
                }
                column(ABS_DefinedContrMin__ABS_OccupierVar_; Abs(DefinedContrMin) + Abs(OccupierVar))
                {
                }
                column(TotBasic; TotBasic)
                {
                }
                column(TotalBenefits; TotalBenefits)
                {
                }
                column(TotQuarter; TotQuarter)
                {
                }
                column(TotGross; TotGross)
                {
                }
                column(V30PerPension__Control188; "30PerPension")
                {
                }
                column(ABS_RetirementVar_; Abs(RetirementVar))
                {
                }
                column(TaxableAmount_Control196; TaxableAmount)
                {
                }
                column(ABS_Employee__Cumm__PAYE___Relief_InsuranceRelief_Control198; Abs(Employee."Cumm. PAYE") + Relief + InsuranceRelief)
                {
                }
                column(Relief_Control200; Relief)
                {
                }
                column(InsuranceRelief_Control202; InsuranceRelief)
                {
                }
                column(ABS_Employee__Cumm__PAYE___Control204; Abs(Employee."Cumm. PAYE"))
                {
                }
                column(OccupierVar; OccupierVar)
                {
                }
                column(TaxableAmount; TaxableAmount2)
                {
                }
                column(TotRet; TotRet)
                {
                }
                column(ABS_Employee__Cumm__PAYE___Control164; Abs(Employee."Cumm. PAYE"))
                {
                }
                column(TaxableAmount_Control166; TaxableAmount)
                {
                }
                column(P9A_; 'P9A')
                {
                }
                column(PensionLimit_Control1000000000; PensionLimit)
                {
                }
                column(CERTIFICATE_OF_PAY_AND_TAXCaption; CERTIFICATE_OF_PAY_AND_TAXCaptionLbl)
                {
                }
                column(DataItem137; NAME___________________________Lbl)
                {
                }
                column(DataItem138; ADDRESS________________________Lbl)
                {
                }
                column(DataItem139; SIGNATURE___________Lbl)
                {
                }
                column(DataItem140; DATE___STAMP___________________Lbl)
                {
                }
                column(NAMES_OF_MORTGAGE_FINANCIAL_INSTITUTIONCaption; NAMES_OF_MORTGAGE_FINANCIAL_INSTITUTIONCaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(DataItem146; L_R__NO__OF_OWNER_OCCUPIED_HOUSE___________CapLbl)
                {
                }
                column(DataItem147; DATE_OF_OCCUPATION_____CapLbl)
                {
                }
                column(TOTALSCaption; TOTALSCaptionLbl)
                {
                }
                column(V1__Date_employee_commenced_if_during_the_year_______________________________________________Caption; V1__Date_employee_commenced_if_during_the_year_______________________________________________CaptionLbl)
                {
                }
                column(Name_and_address_of_old_employer__________________________________________________________________Caption; Name_and_address_of_old_employer__________________________________________________________________CaptionLbl)
                {
                }
                column(DataItem33; V2__Date_left_if_during_CaptionLbl)
                {
                }
                column(Name_and_address_of_new_employer_________________________________________________________________Caption; Name_and_address_of_new_employer_________________________________________________________________CaptionLbl)
                {
                }
                column(V3__Where_housing_is_provided_State_monthly_rent______________________________________________Caption; V3__Where_housing_is_provided_State_monthly_rent______________________________________________CaptionLbl)
                {
                }
                column(DataItem37; V4__Where_any_of_the_pay_relates_Lbl)
                {
                }
                column(YearCaption; YearCaptionLbl)
                {
                }
                column(Amount_Kenya_Pounds_Caption; Amount_Kenya_Pounds_CaptionLbl)
                {
                }
                column(Tax__Shs_Caption; Tax__Shs_CaptionLbl)
                {
                }
                column(Reference_No________________________________________________________Caption; Reference_No________________________________________________________CaptionLbl)
                {
                }
                column(TOTAL_TAX__COL_M__KshsCaption; TOTAL_TAX__COL_M__KshsCaptionLbl)
                {
                }
                column(TOTAL_CHARGEABLE_PAY__COL_H__KshsCaption; TOTAL_CHARGEABLE_PAY__COL_H__KshsCaptionLbl)
                {
                }
                column(Payroll_PeriodX1_Starting_Date; "Starting Date")
                {
                }
                column(Payroll_PeriodX1_P_A_Y_E; "P.A.Y.E")
                {
                }

                trigger OnAfterGetRecord()
                var
                    Earn2: Record Earnings;
                    Assignmatrix: Record "Assignment Matrix";
                begin
                    //============================================================================
                    Employee."Total Allowances" := 0;

                    Earn2.Reset;
                    Earn2.SetRange(Earn2."Earning Type", Earn2."Earning Type"::"Normal Earning");
                    Earn2.SetRange(Earn2."Non-Cash Benefit", false);
                    if Earn2.Find('-') then begin
                        repeat
                            // message('...%1',Earn2.Code);
                            Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", "Payroll Period"."Starting Date");
                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Payment);
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Code, Earn2.Code);
                            if Assignmatrix.Find('-') then begin
                                repeat
                                    Employee."Total Allowances" := Employee."Total Allowances" + Round(Assignmatrix.Amount, 0.01); //message('%1',ROUND(AssignMatrix.Amount,0.01));
                                until Assignmatrix.Next = 0;
                            end;
                        until Earn2.Next = 0;
                    end;
                    //message('%1..%2',Employee."Total Allowances","Payroll Period"."Starting Date");
                    grosspay := Employee."Total Allowances" - Employee."Secondment Amount";
                    //=============================================================================
                    //30PerPension
                    //===================================non cash benefits=========================================by MIKE

                    //================================ 30PerPension============================================
                    "30PerPension" := 0;

                    Earn2.Reset;
                    Earn2.SetRange(Earn2."Earning Type", Earn2."Earning Type"::"Normal Earning");
                    Earn2.SetRange("Basic Salary Code", true);
                    Earn2.SetRange(Earn2."Non-Cash Benefit", false);
                    if Earn2.Find('-') then begin
                        repeat
                            // message('...%1',Earn2.Code);
                            Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", "Payroll Period"."Starting Date");
                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Payment);
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Code, Earn2.Code);
                            if Assignmatrix.Find('-') then begin
                                repeat
                                    "30PerPension" := Round(((30 / 100) * Assignmatrix.Amount), 0.01); //message('%1',ROUND(AssignMatrix.Amount,0.01));
                                until Assignmatrix.Next = 0;
                            end;
                        until Earn2.Next = 0;
                    end;
                    //message('%1..%2',Employee."Total Allowances","Payroll Period"."Starting Date");
                    grosspay := Employee."Total Allowances";
                    //=============================================================================
                    /*
                       noncashbenefit:=0;
                       Earn2.RESET;
                       Earn2.SETRANGE(Earn2."Earning Type",Earn2."Earning Type"::"Normal Earning");
                       Earn2.SETRANGE(Earn2."Non-Cash Benefit",TRUE);
                       IF Earn2.FIND('-') THEN BEGIN REPEAT
                              // message('...%1',Earn2.Code);
                               Assignmatrix.RESET;
                               Assignmatrix.SETRANGE(Assignmatrix."Payroll Period","Payroll Period"."Starting Date");
                               Assignmatrix.SETRANGE(Assignmatrix.Type,Assignmatrix.Type::Payment);
                               Assignmatrix.SETRANGE(Assignmatrix."Employee No",Employee."No.");
                               Assignmatrix.SETRANGE(Code,Earn2.Code);
                               Assignmatrix.SETRANGE(Taxable,TRUE);
                               IF Assignmatrix.FIND('-') THEN BEGIN    REPEAT
                               //  MESSAGE('tell me %1.....%2',Assignmatrix.Description,Assignmatrix."Payroll Period");
                                   noncashbenefit:=noncashbenefit+ROUND(Assignmatrix.Amount,0.01); //message('%1',ROUND(AssignMatrix.Amount,0.01));
                               UNTIL Assignmatrix.NEXT=0;
                               END;
                        UNTIL Earn2.NEXT=0;
                        END;
                       // MESSAGE('%1..%2',noncashbenefit,"Payroll Period"."Starting Date");
                       // noncashbenefit:=noncashbenefit;
                        BenefitsVar:=noncashbenefit;
                        //grosspay:=grosspay+(BenefitsVar+QuartersVar);

                    //================================== end non cash benefits===========================================
                    */
                    noncashbenefit := 0;
                    Earn2.Reset;
                    Earn2.SetRange(Earn2."Earning Type", Earn2."Earning Type"::"Normal Earning");
                    Earn2.SetRange(Earn2."Non-Cash Benefit", true);
                    if Earn2.Find('-') then begin
                        repeat
                            // message('...%1',Earn2.Code);
                            Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", "Payroll Period"."Starting Date");
                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Payment);
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Code, Earn2.Code);
                            Assignmatrix.SetRange(Taxable, true);
                            if Assignmatrix.Find('-') then begin
                                repeat
                                    //  MESSAGE('tell me %1.....%2',Assignmatrix.Description,Assignmatrix."Payroll Period");
                                    noncashbenefit := noncashbenefit + Round(Assignmatrix.Amount, 0.01); //message('%1',ROUND(AssignMatrix.Amount,0.01));
                                until Assignmatrix.Next = 0;
                            end;
                        until Earn2.Next = 0;
                    end;
                    // MESSAGE('%1..%2',noncashbenefit,"Payroll Period"."Starting Date");
                    // noncashbenefit:=noncashbenefit;
                    BenefitsVar := noncashbenefit;
                    //grosspay:=grosspay+(BenefitsVar+QuartersVar);
                    //================================== end non cash benefits===========================================
                    //===================================Get Owner Occupier=========================================by MIKE
                    OwnerOccupier := 0;
                    Earn2.Reset;
                    Earn2.SetRange(Earn2."Earning Type", Earn2."Earning Type"::"Owner Occupier");
                    Earn2.SetRange(Earn2."Non-Cash Benefit", true);
                    if Earn2.Find('-') then begin
                        repeat
                            // message('...%1',Earn2.Code);
                            Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", "Payroll Period"."Starting Date");
                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Payment);
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Code, Earn2.Code);
                            //  Assignmatrix.SETRANGE(Taxable,TRUE);
                            if Assignmatrix.Find('-') then begin
                                repeat
                                    // MESSAGE('tell me %1.....%2',Assignmatrix.Description,Assignmatrix."Payroll Period");
                                    OwnerOccupier := OwnerOccupier + Round(Assignmatrix.Amount, 0.01); //message('%1',ROUND(AssignMatrix.Amount,0.01));
                                until Assignmatrix.Next = 0;
                            end;
                        until Earn2.Next = 0;
                    end;
                    // MESSAGE('%1..%2',noncashbenefit,"Payroll Period"."Starting Date");
                    // noncashbenefit:=noncashbenefit;
                    OccupierVar := OwnerOccupier;
                    //================================== end Get Owner Occupier===========================================
                    TaxableAmount := 0;
                    //"30PerPension":=0;
                    PensionLimit := 0;
                    RetirementVar := 0;
                    OccupierVar := 0;
                    TaxableAmount := 0;
                    InsuranceRelief := 0;
                    IncomeTax := 0;
                    Relief := 0;
                    if Employee."Pays tax" then begin
                        Employee.SetRange("Pay Period Filter", "Starting Date");
                        Employee.CalcFields("Taxable Allowance", "Tax Deductible Amount", "Total Allowances", Employee."Cumm. PAYE");
                        Employee.CalcFields(Employee."Taxable Allowance", "Tax Deductible Amount", Employee."Taxable Income");
                        Employee.CalcFields("Total Allowances", "Total Deductions", Employee."Retirement Contribution");
                        Employee.CalcFields("Total Savings", BfMpr);
                        Employee.CalcFields(Basic, "Retirement Contribution", "Home Savings");
                        Employee.CalcFields("Cumulative Quarters", "Benefits-Non Cash", "Owner Occupier");
                    end;

                    //"30PerPension":=30/100* Employee."Taxable Allowance";

                    RetirementVar := Abs(Employee."Retirement Contribution");

                    HRSetup.Get;
                    //HRSetup.TESTFIELD(HRSetup."Owner occupier interest");
                    PensionLimit := HRSetup."Pension Limit Amount";
                    // Employee.CALCFIELDS("Taxable Allowance","Retirement Contribution");
                    Earn.Reset;
                    Earn.SetCurrentKey(Earn."Earning Type");
                    //Earn.SETRANGE(Earn.Code,HRSetup."Owner occupier interest");
                    Earn.SetRange(Earn."Earning Type", Earn."Earning Type"::"Owner Occupier");
                    if Earn.Find('-') then begin
                        AssMatrix.Reset;
                        AssMatrix.SetRange(AssMatrix.Type, AssMatrix.Type::Payment);
                        AssMatrix.SetRange(AssMatrix."Employee No", Employee."No.");
                        AssMatrix.SetRange(AssMatrix."Payroll Period", "Starting Date");
                        AssMatrix.SetRange(Code, Earn.Code);
                        if AssMatrix.Find('-') then
                            OwnerOccupierAmt := AssMatrix.Amount;
                        // OccupierVar:=OwnerOccupierAmt;

                    end;

                    // Get Owner Occupier
                    //END;

                    //GetPaye.CalculateTaxableAmount(Employee."No.", "Payroll Period"."Starting Date",IncomeTax,TaxableAmount,RetirementVar);

                    //TaxableAmount:=Employee."Taxable Allowance"+Employee."Retirement Contribution"- OwnerOccupierAmt;
                    OccupierVar := OwnerOccupierAmt;
                    /*
                    Earn.RESET;
                    Earn.SETCURRENTKEY(Earn."Earning Type");
                    Earn.SETRANGE(Earn."Earning Type",Earn."Earning Type"::"Owner Occupier");
                    IF Earn.FIND('-') THEN BEGIN
                      AssMatrix.RESET;
                      AssMatrix.SETRANGE(AssMatrix.Type,AssMatrix.Type::Payment);
                      AssMatrix.SETRANGE(AssMatrix."Employee No",Employee."No.");
                      AssMatrix.SETRANGE(AssMatrix."Payroll Period","Starting Date");
                      AssMatrix.SETRANGE(Code,Earn.Code);
                      IF AssMatrix.FIND('-') THEN
                       OccupierVar:=OwnerOccupierAmt;
                    END;
                       */
                    // Get Personal Relief

                    Earn.Reset;
                    Earn.SetCurrentKey(Earn."Earning Type");
                    Earn.SetRange(Earn."Earning Type", Earn."Earning Type"::"Tax Relief");
                    if Earn.Find('-') then begin
                        AssMatrix.Reset;
                        AssMatrix.SetRange(AssMatrix.Type, AssMatrix.Type::Payment);
                        AssMatrix.SetRange(AssMatrix."Employee No", Employee."No.");
                        AssMatrix.SetRange(AssMatrix."Payroll Period", "Starting Date");
                        AssMatrix.SetRange(Code, Earn.Code);
                        if AssMatrix.Find('-') then
                            Relief := AssMatrix.Amount;
                    end;

                    // Get Insurance Relief

                    Earn.Reset;
                    Earn.SetCurrentKey(Earn."Earning Type");
                    Earn.SetRange(Earn."Earning Type", Earn."Earning Type"::"Insurance Relief");
                    if Earn.Find('-') then begin
                        AssMatrix.Reset;
                        AssMatrix.SetRange(AssMatrix.Type, AssMatrix.Type::Payment);
                        AssMatrix.SetRange(AssMatrix."Employee No", Employee."No.");
                        AssMatrix.SetRange(AssMatrix."Payroll Period", "Starting Date");
                        AssMatrix.SetRange(Code, Earn.Code);
                        if AssMatrix.Find('-') then
                            InsuranceRelief := AssMatrix.Amount;
                    end;

                    /*****Calculate the totals*******************************/
                    TaxableAmount2 := 0;
                    TotBasic := TotBasic + Employee."Total Allowances";
                    //TotNonQuarter:=TotQuarter+Employee."Total Allowances";
                    //TotQuarter:=TotQuarter+QuartersVar;
                    TotGross := TotGross + Employee."Cumm. Basic Pay" + Employee."Taxable Allowance" + QuartersVar + BenefitsVar;
                    TotPercentage := TotPercentage + ((30 / 100) * (Employee."Cumm. Basic Pay" + Employee."Total Allowances" + QuartersVar + BenefitsVar));
                    TotActual := TotActual + RetirementVar;
                    TotFixed := TotFixed + PensionLimit;
                    TotTaxable := TotTaxable + TaxableAmount;
                    TotTax := TotTax + IncomeTax;
                    TotRelief := TotRelief + Relief;
                    TotPAYE := TotPAYE + PAYE;
                    grandPAYE := grandPAYE + PAYE;
                    TotOcc := TotOcc + Abs(OccupierVar);
                    //TotRet:=TotRet+ABS(DefinedContrMin)+ABS(OccupierVar);
                    TaxablePound := TaxableAmount / 20;
                    TaxablePound := Round(TaxablePound, 1, '<');
                    TotPound := TotPound + TaxablePound;
                    TotalBenefits := TotalBenefits + BenefitsVar;
                    DefinedContrMin := RetirementVar;
                    if DefinedContrMin > 20000 then
                        DefinedContrMin := 20000;
                    NoOfMonths := NoOfMonths + 1;
                    TotRet := TotRet + Abs(DefinedContrMin) + Abs(OccupierVar);
                    TaxableAmount2 := ((grosspay + BenefitsVar) - (Abs(DefinedContrMin) + Abs(OccupierVar)));
                    //MESSAGE('G %1 ',TaxableAmount2);
                    //=====================================RetirementVar
                    RetirementVar := 0;

                    DeductionsX1.Reset;
                    DeductionsX1.SetRange("Pension Scheme", true);
                    if DeductionsX1.Find('-') then begin
                        repeat
                            Assignmatrix.Reset;
                            Assignmatrix.SetRange(Assignmatrix."Payroll Period", "Payroll Period"."Starting Date");
                            Assignmatrix.SetRange(Assignmatrix.Type, Assignmatrix.Type::Deduction);
                            Assignmatrix.SetRange(Assignmatrix."Employee No", Employee."No.");
                            Assignmatrix.SetRange(Code, DeductionsX1.Code);
                            if Assignmatrix.Find('-') then begin
                                repeat
                                    RetirementVar := RetirementVar + Abs(Assignmatrix.Amount);
                                until Assignmatrix.Next = 0;
                            end;
                        until DeductionsX1.Next = 0;
                    end;
                    /* Earn2.RESET;
                        Earn2.SETRANGE(Earn2."Earning Type",Earn2."Earning Type"::"Normal Earning");
                        Earn2.SETRANGE("Basic Salary Code",TRUE);
                        Earn2.SETRANGE(Earn2."Non-Cash Benefit",FALSE);
                        IF Earn2.FIND('-') THEN BEGIN REPEAT
                               // message('...%1',Earn2.Code);
                                Assignmatrix.RESET;
                                Assignmatrix.SETRANGE(Assignmatrix."Payroll Period","Payroll Period"."Starting Date");
                                Assignmatrix.SETRANGE(Assignmatrix.Type,Assignmatrix.Type::Payment);
                                Assignmatrix.SETRANGE(Assignmatrix."Employee No",Employee."No.");
                                Assignmatrix.SETRANGE(Code,Earn2.Code);
                                IF Assignmatrix.FIND('-') THEN BEGIN    REPEAT
                                IF  DeductionsX1.GET('004') THEN
                                RetirementVar:=ROUND(((DeductionsX1.Percentage/100)*Assignmatrix.Amount),0.01); //message('%1',ROUND(AssignMatrix.Amount,0.01));
                                UNTIL Assignmatrix.NEXT=0;
                                END;
                         UNTIL Earn2.NEXT=0;
                         END;
                         */
                    //====PENSION
                    /*
                      IF  DeductionsX1.GET('004') THEN
                       Assignmatrix.RESET;
                      Assignmatrix.SETRANGE(Assignmatrix."Payroll Period","Payroll Period"."Starting Date");
                      Assignmatrix.SETRANGE(Assignmatrix.Type,Assignmatrix.Type::Deduction);
                      Assignmatrix.SETRANGE(Assignmatrix."Employee No",Employee."No.");
                      Assignmatrix.SETRANGE(Code,DeductionsX1.Code);
                      IF Assignmatrix.FIND('-') THEN BEGIN
                      RetirementVar:=ROUND(ABS(Assignmatrix.Amount),0.01);
                      END;
                      //====NSSF
                     IF DeductionsX1.GET('003') THEN
                      Assignmatrix.RESET;
                      Assignmatrix.SETRANGE(Assignmatrix."Payroll Period","Payroll Period"."Starting Date");
                      Assignmatrix.SETRANGE(Assignmatrix.Type,Assignmatrix.Type::Deduction);
                      Assignmatrix.SETRANGE(Assignmatrix."Employee No",Employee."No.");
                      Assignmatrix.SETRANGE(Code,DeductionsX1.Code);
                      IF Assignmatrix.FIND('-') THEN BEGIN
                      RetirementVar:=RetirementVar+ROUND(ABS(Assignmatrix.Amount),0.01);
                      END;
                      */
                    //=================================end RetirementVar

                end;

                trigger OnPreDataItem()
                begin
                    "Payroll Period".SetRange("Payroll Period"."Starting Date", StringDate, EndDate);
                    CurrReport.CreateTotals(Employee."Total Allowances", BenefitsVar, QuartersVar, "30PerPension", PensionLimit, RetirementVar, OccupierVar)
                    ;
                    CurrReport.CreateTotals(TaxableAmount, Employee."Cumm. PAYE", InsuranceRelief, Relief);
                    //error('%1',Employee."No.");
                end;
            }
            dataitem(Earnings; Earnings)
            {
                DataItemLink = "Employee Filter" = FIELD("No.");
                DataItemTableView = SORTING(Code);
                column(EarningsX1_Description; Description)
                {
                }
                column(EarningsX1__Total_Amount_; "Total Amount")
                {
                }
                column(EarningsX1_Counter; Counter)
                {
                }
                column(EarningsX1__Flat_Amount_; "Flat Amount")
                {
                }
                column(Numb; Numb)
                {
                }
                column(EmployeeBenefits; EmployeeBenefits)
                {
                }
                column(P9A__Control113; 'P9A')
                {
                }
                column(ITEMCaption; ITEMCaptionLbl)
                {
                }
                column(NO_Caption; NO_CaptionLbl)
                {
                }
                column(RATECaption; RATECaptionLbl)
                {
                }
                column(NO__OF_MONTHSCaption; NO__OF_MONTHSCaptionLbl)
                {
                }
                column(TOTAL_AMOUNT_K__shs_Caption; TOTAL_AMOUNT_K__shs_CaptionLbl)
                {
                }
                column(CALCULATION_OF_BENEFITSCaption; CALCULATION_OF_BENEFITSCaptionLbl)
                {
                }
                column(XCaption; XCaptionLbl)
                {
                }
                column(TOTAL_BENEFIT_IN_YEARCaption; TOTAL_BENEFIT_IN_YEARCaptionLbl)
                {
                }
                column(DataItem171; Where_actual_cost_is_higher_than_CaptionLbl)
                {
                }
                column(LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_Caption; LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_CaptionLbl)
                {
                }
                column(DataItem173; EMPLOYERS_LOAN____Kshs__________Lbl)
                {
                }
                column(DataItem174; MONTHLY_BENEFIT_________Lbl)
                {
                }
                column(MOTOR_CARSCaption; MOTOR_CARSCaptionLbl)
                {
                }
                column(Upto_1500cCaption; Upto_1500cCaptionLbl)
                {
                }
                column(V1501cc_1750ccCaption; V1501cc_1750ccCaptionLbl)
                {
                }
                column(V1751cc_2000cCaption; V1751cc_2000cCaptionLbl)
                {
                }
                column(Over_3000cCaption; Over_3000cCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control209; EmptyStringCaption_Control209Lbl)
                {
                }
                column(EmptyStringCaption_Control210; EmptyStringCaption_Control210Lbl)
                {
                }
                column(EmptyStringCaption_Control211; EmptyStringCaption_Control211Lbl)
                {
                }
                column(EmptyStringCaption_Control213; EmptyStringCaption_Control213Lbl)
                {
                }
                column(If_this_amount_does_not_agree_with_total_of_Col__b_overleaf__attach_explanation_Caption; If_this_amount_does_not_agree_with_total_of_Col__b_overleaf__attach_explanation_CaptionLbl)
                {
                }
                column(FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO_APPENDIX_5_OF_EMPLOYERS_GUIDE_Caption; FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO_APPENDIX_5_OF_EMPLOYERS_GUIDE_CaptionLbl)
                {
                }
                column(DataItem216; CAR_BENEFIT___The_higher_the_amount_of_the_monthly__CaptiLbl)
                {
                }
                column(PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___Caption; PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
                {
                }
                column(V2001cc_3000ccCaption; V2001cc_3000ccCaptionLbl)
                {
                }
                column(V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___Caption; V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
                {
                }
                column(V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___Caption; V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
                {
                }
                column(EmptyStringCaption_Control224; EmptyStringCaption_Control224Lbl)
                {
                }
                column(KshsCaption; KshsCaptionLbl)
                {
                }
                column(EarningsX1_Code; Code)
                {
                }
                column(EarningsX1_Employee_Filter; "Employee Filter")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Earnings.CalcFields(Earnings."Total Amount", Earnings.Counter, Earnings.NoOfUnits);
                    EmployeeBenefits := EmployeeBenefits + Earnings."Total Amount";

                    if Earnings.Counter <> 0 then
                        Numb := Earnings.NoOfUnits / Earnings.Counter;
                end;

                trigger OnPostDataItem()
                begin
                    EmployeeBenefits := 0;
                end;

                trigger OnPreDataItem()
                begin
                    Earnings.SetRange(Earnings."Non-Cash Benefit", true);
                    Earnings.SetRange(Earnings.Taxable, true);
                    Earnings.SetRange("Pay Period Filter", StringDate, EndDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotBasic := 0;
                TotNonQuarter := 0;
                TotQuarter := 0;
                TotGross := 0;
                TotPercentage := 0;
                TotActual := 0;
                TotFixed := 0;
                TotTaxable := 0;
                TotTax := 0;
                TotRelief := 0;
                TotPAYE := 0;
                NoOfMonths := 0;
                TotalBenefits := 0;
                TotOcc := 0;
                TotRet := 0;
                TotPound := 0;
                grandPAYE := 0;
                "Total Quarters" := 0;
                Company.Get;
                CoPin := Company."Giro No.";
            end;

            trigger OnPreDataItem()
            begin
                if (StringDate = 0D) or (EndDate = 0D) then
                    Error('Please specify the correct period on the option of the request form');

                Employee.SetFilter("Home Ownership Status", '<>%1', Employee."Home Ownership Status"::"Home Savings");
                CUser := UserId;
                //GetGroup.GetUserGroup(CUser,GroupCode);
                //SETRANGE(Employee."Posting Group",GroupCode);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Period)
                {
                }
                field("Month StartDate"; StringDate)
                {
                    StyleExpr = FALSE;
                    TableRelation = "Payroll Period";
                }
                field("Month EndDate"; EndDate)
                {
                    StyleExpr = FALSE;
                    TableRelation = "Payroll Period";
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

    var
        TaxableAmount: Decimal;
        AmountRemaining: Decimal;
        IncomeTax: Decimal;
        TotBasic: Decimal;
        TotNonQuarter: Decimal;
        TotQuarter: Decimal;
        TotGross: Decimal;
        TotPercentage: Decimal;
        TotActual: Decimal;
        TotFixed: Decimal;
        TotTaxable: Decimal;
        TotTax: Decimal;
        TotRelief: Decimal;
        TotPAYE: Decimal;
        TaxablePound: Decimal;
        TotPound: Decimal;
        TotalBenefits: Decimal;
        EmployeeBenefits: Decimal;
        NoOfMonths: Integer;
        NoOfUnits: Integer;
        Numb: Decimal;
        DefinedContrMin: Decimal;
        HRSetup: Record "Human Resources Setup";
        ExcessRetirement: Decimal;
        HseLimit: Decimal;
        BenefitsVar: Decimal;
        QuartersVar: Decimal;
        OccupierVar: Decimal;
        RetirementVar: Decimal;
        PensionLimit: Decimal;
        Relief: Decimal;
        PAYE: Decimal;
        StringDate: Date;
        EndDate: Date;
        TotOcc: Decimal;
        TotRet: Decimal;
        Company: Record "Company Information";
        CoPin: Text[30];
        grandPAYE: Decimal;
        TaxCode: Code[10];
        retirecontribution: Decimal;
        CompRec: Record "Human Resources Setup";
        "30PerPension": Decimal;
        Earn: Record Earnings;
        AssMatrix: Record "Assignment Matrix";
        InsuranceRelief: Decimal;
        //GetGroup: Codeunit PayrollRounding;
        GroupCode: Code[20];
        CUser: Code[30];
        Employers_Name_CaptionLbl: Label 'Employers Name:';
        Employee_s_Main_Name_CaptionLbl: Label 'Employee''s Main Name:';
        Employee_s_Other_Names_CaptionLbl: Label 'Employee''s Other Names:';
        Employers_PIN_CaptionLbl: Label 'Employers PIN:';
        Employee_s_PIN_CaptionLbl: Label 'Employee''s PIN:';
        MonthCaptionLbl: Label 'Month';
        Gross_SalaryCaptionLbl: Label 'Gross Salary';
        BenefitsCaptionLbl: Label 'Benefits';
        QuartersCaptionLbl: Label 'Quarters';
        Total_A_B_CCaptionLbl: Label 'Total A+B+C';
        Defined_Contribution_Retr__SchemeCaptionLbl: Label 'Defined Contribution Retr. Scheme';
        Taxable_AmountCaptionLbl: Label 'Taxable Amount';
        Personal_ReliefCaptionLbl: Label 'Personal Relief';
        P_A_Y_E_TAXCaptionLbl: Label 'P.A.Y.E TAX';
        KENYA_REVENUE_AUTHORITYCaptionLbl: Label 'KENYA REVENUE AUTHORITY';
        INCOME_TAX_DEPARTMENTCaptionLbl: Label 'INCOME TAX DEPARTMENT';
        INCOME_TAX_DEDUCTION_CARD_YEAR_CaptionLbl: Label 'INCOME TAX DEDUCTION CARD YEAR:';
        Tax_ChargedCaptionLbl: Label 'Tax Charged';
        Owner_OccupiedCaptionLbl: Label 'Owner Occupied';
        Retr__Contribution__CaptionLbl: Label 'Retr. Contribution &';
        ACaptionLbl: Label 'A';
        BCaptionLbl: Label 'B';
        CCaptionLbl: Label 'C';
        DCaptionLbl: Label 'D';
        F__Standard_Amount_CaptionLbl: Label 'F (Standard Amount)';
        G___Lowest_of_E_F_CaptionLbl: Label 'G  (Lowest of E+F)';
        HCaptionLbl: Label 'H';
        JCaptionLbl: Label 'J';
        KCaptionLbl: Label 'K';
        LCaptionLbl: Label 'L';
        MCaptionLbl: Label 'M';
        ECaptionLbl: Label 'E';
        InterestCaptionLbl: Label ' Interest';
        Column_D_GCaptionLbl: Label 'Column D-G';
        Occupied_InterestCaptionLbl: Label ' Occupied Interest';
        Non_CashCaptionLbl: Label 'Non-Cash';
        Value_OfCaptionLbl: Label 'Value Of';
        Personal_File_No_CaptionLbl: Label 'Personal File No.';
        Insurance_ReliefCaptionLbl: Label 'Insurance Relief';
        CERTIFICATE_OF_PAY_AND_TAXCaptionLbl: Label 'CERTIFICATE OF PAY AND TAX';
        NAME___________________________Lbl: Label 'NAME            ....................................................................................................................................';
        ADDRESS________________________Lbl: Label 'ADDRESS     .....................................................................................................................................';
        SIGNATURE___________Lbl: Label 'SIGNATURE   ....................................................................................................................................';
        DATE___STAMP___________________Lbl: Label 'DATE & STAMP   ....................................................................................................................................';
        NAMES_OF_MORTGAGE_FINANCIAL_INSTITUTIONCaptionLbl: Label 'NAMES OF MORTGAGE FINANCIAL INSTITUTION ADVANCING MORTGAGE LOAN';
        EmptyStringCaptionLbl: Label '.....................................................................................................................................................';
        L_R__NO__OF_OWNER_OCCUPIED_HOUSE___________CapLbl: Label 'L.R. NO. OF OWNER OCCUPIED PROPERTY ............................................';
        DATE_OF_OCCUPATION_____CapLbl: Label 'DATE OF OCCUPATION OF HOUSE ...............................';
        TOTALSCaptionLbl: Label 'TOTALS';
        V1__Date_employee_commenced_if_during_the_year_______________________________________________CaptionLbl: Label '(1) Date employee commenced if during the year...............................................';
        Name_and_address_of_old_employer__________________________________________________________________CaptionLbl: Label '      Name and address of old employer..................................................................';
        V2__Date_left_if_during_CaptionLbl: Label '(2) Date left if during the year....................................................................................';
        Name_and_address_of_new_employer_________________________________________________________________CaptionLbl: Label '     Name and address of new employer.................................................................';
        V3__Where_housing_is_provided_State_monthly_rent______________________________________________CaptionLbl: Label '(3) Where housing is provided,State monthly rent..............................................';
        V4__Where_any_of_the_pay_relates_Lbl: Label '(4) Where any of the pay relates to a period other than this year e.g gratuity, give details....................................................................';
        YearCaptionLbl: Label 'Year';
        Amount_Kenya_Pounds_CaptionLbl: Label 'Amount(Kenya Pounds)';
        Tax__Shs_CaptionLbl: Label 'Tax (Shs)';
        Reference_No________________________________________________________CaptionLbl: Label 'Reference No:  .....................................................';
        TOTAL_TAX__COL_M__KshsCaptionLbl: Label 'TOTAL TAX (COL M) Kshs';
        TOTAL_CHARGEABLE_PAY__COL_H__KshsCaptionLbl: Label 'TOTAL CHARGEABLE PAY (COL H) Kshs';
        ITEMCaptionLbl: Label 'ITEM';
        NO_CaptionLbl: Label 'NO.';
        RATECaptionLbl: Label 'RATE';
        NO__OF_MONTHSCaptionLbl: Label 'NO. OF MONTHS';
        TOTAL_AMOUNT_K__shs_CaptionLbl: Label 'TOTAL AMOUNT K. shs.';
        CALCULATION_OF_BENEFITSCaptionLbl: Label 'CALCULATION OF BENEFITS';
        XCaptionLbl: Label 'X';
        TOTAL_BENEFIT_IN_YEARCaptionLbl: Label 'TOTAL BENEFIT IN YEAR';
        Where_actual_cost_is_higher_than_CaptionLbl: Label '* Where actual cost is higher than given monthly rates of benefits then the actual cost is brought to charge in full';
        LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_CaptionLbl: Label 'LOW INTERES RATE BELOW PRESCRIBED RATE OF (15%) PER CENT.';
        EMPLOYERS_LOAN____Kshs__________Lbl: Label 'EMPLOYERS LOAN   =Kshs..........................@............% RATE          RATE DIFFERENCE    (PRESCRIBED RARE - EMPLOYERS RATE)  =    15%  -   ..........%  =   ........%';
        MONTHLY_BENEFIT_________Lbl: Label 'MONTHLY BENEFIT            (RATE DIFFERENCE X LOAN)/12    =      .................................%     X        Kshs. ......................../12   = Kshs...............................';
        MOTOR_CARSCaptionLbl: Label 'MOTOR CARS';
        Upto_1500cCaptionLbl: Label 'Upto 1500c';
        V1501cc_1750ccCaptionLbl: Label '1501cc-1750cc';
        V1751cc_2000cCaptionLbl: Label '1751cc-2000c';
        Over_3000cCaptionLbl: Label 'Over 3000c';
        EmptyStringCaption_Control209Lbl: Label '=';
        EmptyStringCaption_Control210Lbl: Label '=';
        EmptyStringCaption_Control211Lbl: Label '=';
        EmptyStringCaption_Control213Lbl: Label '=';
        If_this_amount_does_not_agree_with_total_of_Col__b_overleaf__attach_explanation_CaptionLbl: Label 'If this amount does not agree with total of Col. b overleaf, attach explanation.';
        FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO_APPENDIX_5_OF_EMPLOYERS_GUIDE_CaptionLbl: Label 'FOR PICK-UPS, PANEL VANS AND LAND-ROVERS REFER TO APPENDIX 5 OF EMPLOYERS GUIDE.';
        CAR_BENEFIT___The_higher_the_amount_of_the_monthly__CaptiLbl: Label 'CAR BENEFIT - The higher the amount of the monthly rate or the prescribed  rate of benefits is to be brought to charge:-';
        PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label 'PRESCRIBED RATE : 1996 - 1% per month of the initial cost of the vehicle   ';
        V2001cc_3000ccCaptionLbl: Label '2001cc-3000cc';
        V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label '1997 - 1.5% per month of the initial cost of the vehicle   ';
        V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label '1998 et seq. - 2.0% per month of the initial cost of the vehicle   ';
        EmptyStringCaption_Control224Lbl: Label '=';
        KshsCaptionLbl: Label 'Kshs';
        OwnerOccupierAmt: Decimal;
        //GetPaye: Codeunit PayrollRounding;
        IMPORTANT: Label 'IMPORTANT';
        "UseP9A(a)": Label '(a)  For all liable Employees and where director/ employees receives benefits in addition to cash emoluments.';
        "UseP9A(b)": Label '(b)  Where an Employee is eligible to deduction on owner occupier interest and the total interest payable in the year is K.shs. 300,000/= and above.';
        "2(a)": Label '2 (a) Deductible interest in respect of any month must be standard K.shs. 25,000.00/= except for December where the amount shall be K.shs. 25,000.00/=';
        "2(b)(i)": Label '(i) Photostat copy of preceding year''s certificate or confirmation of current Year''s borrowing. If applicable form financial institution.';
        "2(b)(ii)": Label '(ii) The DECLARATION duly signed by the Employees to form P9A';
        CompletionByEmployerLbl: Label 'To be completed by Employer at end of year';
        "1_Use_P9A": Label '1. Use P9A ';
        b_Attach: Label '(b) Attach ';
        grosspay: Decimal;
        noncashbenefit: Decimal;
        OwnerOccupier: Decimal;
        DeductionsX1: Record Deductions;
        TaxableAmount2: Decimal;

    procedure GetTaxBracket(var TaxableAmount: Decimal)
    var
        TaxTable: Record Brackets;
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
        if not Employee."Pays tax" then
            IncomeTax := 0;
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