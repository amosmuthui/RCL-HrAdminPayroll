report 51525332 "P9A (HOSP) Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/P9AHOSPReport.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code";
            column(Employee__First_Name_; "First Name")
            {
            }
            column(Employee__Middle_Name_; "Middle Name")
            {
            }
            column(Employee__Last_Name_; "Last Name")
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(Employee__P_I_N_; "P.I.N")
            {
            }
            column(P9A_; 'P9A')
            {
            }
            column(FORMAT_StringDate_0___year4___; Format(StringDate, 0, '<year4>'))
            {
            }
            column(CoPin; CoPin)
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
            column(KENYA_REVENUE_AUTHORITYCaption; KENYA_REVENUE_AUTHORITYCaptionLbl)
            {
            }
            column(INCOME_TAX_DEPARTMENTCaption; INCOME_TAX_DEPARTMENTCaptionLbl)
            {
            }
            column(INCOME_TAX_DEDUCTION_CARD_YEAR_Caption; INCOME_TAX_DEDUCTION_CARD_YEAR_CaptionLbl)
            {
            }
            column(MonthCaption; MonthCaptionLbl)
            {
            }
            column(Basic_SalaryCaption; Basic_SalaryCaptionLbl)
            {
            }
            column(BenefitsCaption; BenefitsCaptionLbl)
            {
            }
            column(Non_CashCaption; Non_CashCaptionLbl)
            {
            }
            column(QuartersCaption; QuartersCaptionLbl)
            {
            }
            column(Value_OfCaption; Value_OfCaptionLbl)
            {
            }
            column(Total_A_B_CCaption; Total_A_B_CCaptionLbl)
            {
            }
            column(Defined_Contribution_Retr__SchemeCaption; Defined_Contribution_Retr__SchemeCaptionLbl)
            {
            }
            column(ECaption; ECaptionLbl)
            {
            }
            column(Savings_PlanCaption; Savings_PlanCaptionLbl)
            {
            }
            column(Amount_DepositedCaption; Amount_DepositedCaptionLbl)
            {
            }
            column(Retr__Contribution__Caption; Retr__Contribution__CaptionLbl)
            {
            }
            column(Savings_PlanCaption_Control78; Savings_PlanCaption_Control78Lbl)
            {
            }
            column(Taxable_AmountCaption; Taxable_AmountCaptionLbl)
            {
            }
            column(Column_D_GCaption; Column_D_GCaptionLbl)
            {
            }
            column(Round__H_Caption; Round__H_CaptionLbl)
            {
            }
            column(K_PoundsCaption; K_PoundsCaptionLbl)
            {
            }
            column(Tax_On_JCaption; Tax_On_JCaptionLbl)
            {
            }
            column(ReliefCaption; ReliefCaptionLbl)
            {
            }
            column(MonthlyCaption; MonthlyCaptionLbl)
            {
            }
            column(P_A_Y_E_TAXCaption; P_A_Y_E_TAXCaptionLbl)
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
            column(F_Caption; F_CaptionLbl)
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
            column(Employee_No_; "No.")
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
                column(Employee__Total_Allowances__Employee__Cumm__Basic_Pay__BenefitsVar_QuartersVar; Employee."Total Allowances" + Employee."Cumm. Basic Pay" + BenefitsVar + QuartersVar)
                {
                }
                column(RetirementVar; RetirementVar)
                {
                }
                column(TaxableAmount; TaxableAmount)
                {
                }
                column(ABS_IncomeTax_; Abs(IncomeTax))
                {
                }
                column(Relief; Relief)
                {
                }
                column(ABS_PAYE_; Abs(PAYE))
                {
                }
                column(PensionLimit; PensionLimit)
                {
                }
                column(Employee__Cumm__Basic_Pay__Employee__Total_Allowances_; Employee."Cumm. Basic Pay" + Employee."Total Allowances")
                {
                }
                column(TaxablePound; TaxablePound)
                {
                }
                column(ABS_OccupierVar_; Abs(OccupierVar))
                {
                }
                column(Employee__Total_Allowances__Employee__Cumm__Basic_Pay__BenefitsVar_QuartersVar__30_100; (Employee."Total Allowances" + Employee."Cumm. Basic Pay" + BenefitsVar + QuartersVar) * 30 / 100)
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
                column(TotPercentage; TotPercentage)
                {
                }
                column(ABS_TotActual_; Abs(TotActual))
                {
                }
                column(TotFixed; TotFixed)
                {
                }
                column(TotTaxable; TotTaxable)
                {
                }
                column(TotPound; TotPound)
                {
                }
                column(ABS_TotTax_; Abs(TotTax))
                {
                }
                column(TotRelief; TotRelief)
                {
                }
                column(ABS_TotPAYE_; Abs(TotPAYE))
                {
                }
                column(TotOcc; TotOcc)
                {
                }
                column(TotRet; TotRet)
                {
                }
                column(ABS_TotPAYE__Control164; Abs(TotPAYE))
                {
                }
                column(ABS_TotTax__Control166; Abs(TotTax))
                {
                }
                column(P9A_HOSP__; 'P9A(HOSP)')
                {
                }
                column(NAMES_OF_MORTGAGE_FINANCIAL_INSTITUTIONCaption; NAMES_OF_MORTGAGE_FINANCIAL_INSTITUTIONCaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(DataItem146; L_R__NO__OF_OWNER_OCCUPIED_HOUSE___________________________________________________CapLbl)
                {
                }
                column(DataItem147; DATE_OF_OCCUPATION________________________________________________________________CapLbl)
                {
                }
                column(TOTALSCaption; TOTALSCaptionLbl)
                {
                }
                column(DataItem37; V4__Where_any_of_the_pay_relates_to_a_period_other_than_this_Lbl)
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
                column(Approved________________________________________________________Caption; Approved________________________________________________________CaptionLbl)
                {
                }
                column(TOTAL_TAX__COL_M__KshsCaption; TOTAL_TAX__COL_M__KshsCaptionLbl)
                {
                }
                column(TOTAL_CHARGEABLE_PAY__COL_J__K_PoundsCaption; TOTAL_CHARGEABLE_PAY__COL_J__K_PoundsCaptionLbl)
                {
                }
                column(V1__Date_employee_commenced_if_during_the_year_______________________________________________Caption; V1__Date_employee_commenced_if_during_the_year_______________________________________________CaptionLbl)
                {
                }
                column(Name_and_address_of_old_employer__________________________________________________________________Caption; Name_and_address_of_old_employer__________________________________________________________________CaptionLbl)
                {
                }
                column(DataItem34; V2__Date_left_if_during_the_year___________________CaptionLbl)
                {
                }
                column(Name_and_address_of_new_employer_________________________________________________________________Caption; Name_and_address_of_new_employer_________________________________________________________________CaptionLbl)
                {
                }
                column(V3__Where_housing_is_provided_State_monthly_rent______________________________________________Caption; V3__Where_housing_is_provided_State_monthly_rent______________________________________________CaptionLbl)
                {
                }
                column(CERTIFICATE_OF_PAY_AND_TAXCaption; CERTIFICATE_OF_PAY_AND_TAXCaptionLbl)
                {
                }
                column(DataItem137; NAME_______________________________________________________________________________Lbl)
                {
                }
                column(DataItem138; ADDRESS_____________________________________________________________________________Lbl)
                {
                }
                column(DataItem139; SIGNATURE________Lbl)
                {
                }
                column(DataItem140; DATE___STAMP______________Lbl)
                {
                }
                column(Payroll_PeriodX1_Starting_Date; "Starting Date")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TaxableAmount := 0;
                    if "Payroll Period"."Close Pay" then begin
                        Employee.SetRange("Pay Period Filter", "Starting Date");
                        Employee.CalcFields("Taxable Allowance", "Tax Deductible Amount", "Total Allowances");
                        Employee.CalcFields("Taxable Allowance", "Tax Deductible Amount");
                        Employee.CalcFields("Total Allowances", "Total Deductions");
                        Employee.CalcFields("Total Savings", BfMpr);
                        Employee.CalcFields("Cumm. Basic Pay", "Retirement Contribution", "Home Savings");
                        Employee.CalcFields("Cumulative Quarters", "Benefits-Non Cash", "Owner Occupier");
                    end;
                    Relief := Employee."Tax Relief Amount";

                    TaxableAmount := Employee."Cumm. Basic Pay" + Employee."Taxable Allowance";
                    if Employee."Housed by Employer" then begin
                        with Employee do
                            case Housing of
                                Housing::Ordinary:
                                    Employee."Total Quarters" := 0.15 * TaxableAmount;
                                Housing::Directors:
                                    Employee."Total Quarters" := 0.15 * TaxableAmount;
                                Housing::Agricultural:
                                    Employee."Total Quarters" := 0.1 * TaxableAmount;
                            end;
                    end;


                    HRSetup.Get;
                    HseLimit := HRSetup."Housing Earned Limit";
                    TaxCode := HRSetup."Tax Table";
                    if ((TaxableAmount > HseLimit) and (Employee."Total Quarters" > 0)) then begin
                        if Employee."Employer Rent" then
                            if Employee."House Rent" > Employee."Total Quarters" then
                                Employee."Total Quarters" := Employee."House Rent"
                            else
                                Employee."Total Quarters" := Employee."Total Quarters"
                        else
                            Employee."Total Quarters" := Employee."Total Quarters" - Employee."House Rent";
                    end;

                    TaxableAmount := TaxableAmount + Employee."Cumulative Quarters" + Employee."Tax Deductible Amount";
                    HRSetup.Get;
                    PensionLimit := HRSetup."Pension Limit Amount";
                    Employee."Total Quarters" := Round(Employee."Total Quarters", 0.1, '>');
                    //Checking for Pension Limit to allow for tax

                    Employee."Retirement Contribution" := -Employee."Retirement Contribution";
                    if Employee."Retirement Contribution" > HRSetup."Pension Limit Amount" then begin
                        ExcessRetirement := Employee."Retirement Contribution" - HRSetup."Pension Limit Amount";
                        TaxableAmount := TaxableAmount + Employee."Total Quarters" + Employee."Tax Deductible Amount" +
                    ExcessRetirement
                    end;
                    //END----Checking for pension Limit

                    if "Payroll Period"."Close Pay" then begin
                        QuartersVar := Round(Employee."Cumulative Quarters", 0.1, '>');
                        BenefitsVar := Employee."Benefits-Non Cash";
                        OccupierVar := Employee."Home Savings";
                        RetirementVar := Employee."Retirement Contribution";
                    end
                    else begin
                        QuartersVar := 0;
                        BenefitsVar := 0;
                        OccupierVar := 0;
                        RetirementVar := 0;
                        Employee."Cumm. Basic Pay" := 0;
                        Employee."Total Allowances" := 0;
                        TaxableAmount := 0;
                        TaxablePound := 0;
                        PensionLimit := 0;
                        Relief := 0;
                    end;

                    TaxableAmount := Round(TaxableAmount, 1, '>');
                    if TaxableAmount = 0 then begin
                        Relief := 0;
                        PensionLimit := 0;
                    end;

                    GetTaxBracket(TaxableAmount);
                    if (Format("Starting Date", 0, '<month>')) <> '1' then begin
                        Employee.SetRange("Pay Period Filter", CalcDate('-1M', "Starting Date"));
                        Employee.CalcFields(BfMpr);
                        PAYE := IncomeTax + Relief + Employee.BfMpr;
                        Employee.SetRange("Pay Period Filter", "Starting Date");
                    end
                    else
                        PAYE := IncomeTax + Relief;
                    if PAYE > 0 then
                        PAYE := 0;

                    /*****Calculate the totals*******************************/
                    TotBasic := TotBasic + Employee."Cumm. Basic Pay" + Employee."Total Allowances";
                    TotNonQuarter := TotQuarter + Employee."Total Allowances";
                    TotQuarter := TotQuarter + QuartersVar;
                    TotGross := TotGross + Employee."Cumm. Basic Pay" + Employee."Total Allowances" + QuartersVar + BenefitsVar;
                    TotPercentage := TotPercentage + ((30 / 100) * (Employee."Cumm. Basic Pay" + Employee."Total Allowances" +
                 QuartersVar
                    + BenefitsVar));
                    TotActual := TotActual + RetirementVar;
                    TotFixed := TotFixed + PensionLimit;
                    TotTaxable := TotTaxable + TaxableAmount;
                    TotTax := TotTax + IncomeTax;
                    TotRelief := TotRelief + Relief;
                    TotPAYE := TotPAYE + PAYE;
                    TotOcc := TotOcc + Abs(OccupierVar);
                    TotRet := TotRet + Abs(DefinedContrMin) + Abs(OccupierVar);
                    TaxablePound := TaxableAmount / 20;
                    TaxablePound := Round(TaxablePound, 1, '<');
                    TotPound := TotPound + TaxablePound;
                    TotalBenefits := TotalBenefits + BenefitsVar;
                    DefinedContrMin := RetirementVar;
                    NoOfMonths := NoOfMonths + 1;

                end;

                trigger OnPreDataItem()
                begin
                    "Payroll Period".SetRange("Payroll Period"."Starting Date", StringDate, EndDate);
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
                column(P9A_HOSP___Control221; 'P9A(HOSP)')
                {
                }
                column(APPENDIX_1BCaption; APPENDIX_1BCaptionLbl)
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
                column(TOTAL_BENEFITS_IN_YEARCaption; TOTAL_BENEFITS_IN_YEARCaptionLbl)
                {
                }
                column(DataItem171; Where_actual_cost_is_higher_than_Lbl)
                {
                }
                column(LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_Caption; LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_CaptionLbl)
                {
                }
                column(DataItem173; EMPLOYERS_LOAN____Kshs__RATE__Lbl)
                {
                }
                column(DataItem174; MONTHLY_BENEFIT____RATE_DIF_Lbl)
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
                column(V2001cc_3000ccCaption; V2001cc_3000ccCaptionLbl)
                {
                }
                column(Over_3000cCaption; Over_3000cCaptionLbl)
                {
                }
                column(EmptyStringCaption_Control210; EmptyStringCaption_Control210Lbl)
                {
                }
                column(EmptyStringCaption_Control211; EmptyStringCaption_Control211Lbl)
                {
                }
                column(EmptyStringCaption_Control212; EmptyStringCaption_Control212Lbl)
                {
                }
                column(EmptyStringCaption_Control213; EmptyStringCaption_Control213Lbl)
                {
                }
                column(EmptyStringCaption_Control214; EmptyStringCaption_Control214Lbl)
                {
                }
                column(FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO_APPENDIX_5_OF_EMPLOYERS_GUIDE_Caption; FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO_APPENDIX_5_OF_EMPLOYERS_GUIDE_CaptionLbl)
                {
                }
                column(If_this_amount_does_not_agree_with_total_of_Col__b_overleaf__attach_explanation_Caption; If_this_amount_does_not_agree_with_total_of_Col__b_overleaf__attach_explanation_CaptionLbl)
                {
                }
                column(DataItem217; CAR_BENEFIT___The_higher_the_amount_of_the_monthly_rate_or_the_prescribed__CaptiLbl)
                {
                }
                column(PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___Caption; PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
                {
                }
                column(V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___Caption; V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
                {
                }
                column(V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___Caption; V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl)
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
                "Total Quarters" := 0;


                Company.Get;
                CoPin := Company."Company P.I.N";
            end;

            trigger OnPreDataItem()
            begin
                if (StringDate = 0D) or (EndDate = 0D) then
                    Error('Please specify the correct period on the option of the request form');
                Employee.SetRange("Home Ownership Status", Employee."Home Ownership Status"::"Home Savings");
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
                    field("Month StartDate"; StringDate)
                    {
                        StyleExpr = FALSE;
                    }
                    field("Month EndDate"; EndDate)
                    {
                        StyleExpr = FALSE;
                    }
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
        TotOcc: Decimal;
        TotRet: Decimal;
        Company: Record "Company Information";
        CoPin: Text[30];
        TaxCode: Code[10];
        EndDate: Date;
        //GetGroup: Codeunit "Payment- Post";
        GroupCode: Code[20];
        CUser: Code[20];
        Employers_Name_CaptionLbl: Label 'Employers Name:';
        Employee_s_Main_Name_CaptionLbl: Label 'Employee''s Main Name:';
        Employee_s_Other_Names_CaptionLbl: Label 'Employee''s Other Names:';
        Employers_PIN_CaptionLbl: Label 'Employers PIN:';
        Employee_s_PIN_CaptionLbl: Label 'Employee''s PIN:';
        KENYA_REVENUE_AUTHORITYCaptionLbl: Label 'KENYA REVENUE AUTHORITY';
        INCOME_TAX_DEPARTMENTCaptionLbl: Label 'INCOME TAX DEPARTMENT';
        INCOME_TAX_DEDUCTION_CARD_YEAR_CaptionLbl: Label 'INCOME TAX DEDUCTION CARD YEAR:';
        MonthCaptionLbl: Label 'Month';
        Basic_SalaryCaptionLbl: Label 'Basic Salary';
        BenefitsCaptionLbl: Label 'Benefits';
        Non_CashCaptionLbl: Label 'Non-Cash';
        QuartersCaptionLbl: Label 'Quarters';
        Value_OfCaptionLbl: Label 'Value Of';
        Total_A_B_CCaptionLbl: Label 'Total A+B+C';
        Defined_Contribution_Retr__SchemeCaptionLbl: Label 'Defined Contribution Retr. Scheme';
        ECaptionLbl: Label 'E';
        Savings_PlanCaptionLbl: Label 'Savings Plan';
        Amount_DepositedCaptionLbl: Label 'Amount Deposited';
        Retr__Contribution__CaptionLbl: Label 'Retr. Contribution &';
        Savings_PlanCaption_Control78Lbl: Label 'Savings Plan';
        Taxable_AmountCaptionLbl: Label 'Taxable Amount';
        Column_D_GCaptionLbl: Label 'Column D-G';
        Round__H_CaptionLbl: Label 'Round (H)';
        K_PoundsCaptionLbl: Label 'K Pounds';
        Tax_On_JCaptionLbl: Label 'Tax On J';
        ReliefCaptionLbl: Label 'Relief';
        MonthlyCaptionLbl: Label ' Monthly';
        P_A_Y_E_TAXCaptionLbl: Label 'P.A.Y.E TAX';
        ACaptionLbl: Label 'A';
        BCaptionLbl: Label 'B';
        CCaptionLbl: Label 'C';
        DCaptionLbl: Label 'D';
        F_CaptionLbl: Label 'F ';
        G___Lowest_of_E_F_CaptionLbl: Label 'G  (Lowest of E+F)';
        HCaptionLbl: Label 'H';
        JCaptionLbl: Label 'J';
        KCaptionLbl: Label 'K';
        LCaptionLbl: Label 'L';
        MCaptionLbl: Label 'M';
        NAMES_OF_MORTGAGE_FINANCIAL_INSTITUTIONCaptionLbl: Label 'NAMES OF MORTGAGE FINANCIAL INSTITUTION';
        EmptyStringCaptionLbl: Label '.....................................................................................................................';
        L_R__NO__OF_OWNER_OCCUPIED_HOUSE___________________________________________________CapLbl: Label 'L.R. NO. OF OWNER OCCUPIED HOUSE .........................................................................................';
        DATE_OF_OCCUPATION________________________________________________________________CapLbl: Label 'DATE OF OCCUPATION .......................................................................................................';
        TOTALSCaptionLbl: Label 'TOTALS';
        V4__Where_any_of_the_pay_relates_to_a_period_other_than_this_Lbl: Label '(4) Where any of the pay relates to a period other than this year e.g gratuity, give details....................................................................';
        YearCaptionLbl: Label 'Year';
        Amount_Kenya_Pounds_CaptionLbl: Label 'Amount(Kenya Pounds)';
        Tax__Shs_CaptionLbl: Label 'Tax (Shs)';
        Approved________________________________________________________CaptionLbl: Label 'Approved:  .....................................................';
        TOTAL_TAX__COL_M__KshsCaptionLbl: Label 'TOTAL TAX (COL M) Kshs';
        TOTAL_CHARGEABLE_PAY__COL_J__K_PoundsCaptionLbl: Label 'TOTAL CHARGEABLE PAY (COL J) K.Pounds';
        V1__Date_employee_commenced_if_during_the_year_______________________________________________CaptionLbl: Label '(1) Date employee commenced if during the year...............................................';
        Name_and_address_of_old_employer__________________________________________________________________CaptionLbl: Label '      Name and address of old employer..................................................................';
        V2__Date_left_if_during_the_year___________________CaptionLbl: Label '(2) Date left if during the year....................................................................................';
        Name_and_address_of_new_employer_________________________________________________________________CaptionLbl: Label '     Name and address of new employer.................................................................';
        V3__Where_housing_is_provided_State_monthly_rent______________________________________________CaptionLbl: Label '(3) Where housing is provided,State monthly rent..............................................';
        CERTIFICATE_OF_PAY_AND_TAXCaptionLbl: Label 'CERTIFICATE OF PAY AND TAX';
        NAME_______________________________________________________________________________Lbl: Label 'NAME            ....................................................................................................';
        ADDRESS_____________________________________________________________________________Lbl: Label 'ADDRESS     .....................................................................................................';
        SIGNATURE________Lbl: Label 'SIGNATURE   ....................................................................................................';
        DATE___STAMP______________Lbl: Label 'DATE & STAMP   ....................................................................................................';
        APPENDIX_1BCaptionLbl: Label 'APPENDIX 1B';
        ITEMCaptionLbl: Label 'ITEM';
        NO_CaptionLbl: Label 'NO.';
        RATECaptionLbl: Label 'RATE';
        NO__OF_MONTHSCaptionLbl: Label 'NO. OF MONTHS';
        TOTAL_AMOUNT_K__shs_CaptionLbl: Label 'TOTAL AMOUNT K. shs.';
        CALCULATION_OF_BENEFITSCaptionLbl: Label 'CALCULATION OF BENEFITS';
        TOTAL_BENEFITS_IN_YEARCaptionLbl: Label 'TOTAL BENEFITS IN YEAR';
        Where_actual_cost_is_higher_than_Lbl: Label '* Where actual cost is higher than given monthly rates of benefits then the actual cost is brought to charge in full';
        LOW_INTERES_RATE_BELOW_PRESCRIBED_RATE_OF__15___PER_CENT_CaptionLbl: Label 'LOW INTERES RATE BELOW PRESCRIBED RATE OF (15%) PER CENT.';
        EMPLOYERS_LOAN____Kshs__RATE__Lbl: Label 'EMPLOYERS LOAN   =Kshs..........................@............% RATE          RATE DIFFERENCE    (PRESCRIBED RARE - EMPLOYERS RATE)  =    15%  -   ..........%  =   ........%';
        MONTHLY_BENEFIT____RATE_DIF_Lbl: Label 'MONTHLY BENEFIT            (RATE DIFFERENCE X LOAN)/12    =      .................................%     X        Kshs. ......................../12   = Kshs...............................';
        MOTOR_CARSCaptionLbl: Label 'MOTOR CARS';
        Upto_1500cCaptionLbl: Label 'Upto 1500c';
        V1501cc_1750ccCaptionLbl: Label '1501cc-1750cc';
        V1751cc_2000cCaptionLbl: Label '1751cc-2000c';
        V2001cc_3000ccCaptionLbl: Label '2001cc-3000cc';
        Over_3000cCaptionLbl: Label 'Over 3000c';
        EmptyStringCaption_Control210Lbl: Label '=';
        EmptyStringCaption_Control211Lbl: Label '=';
        EmptyStringCaption_Control212Lbl: Label '=';
        EmptyStringCaption_Control213Lbl: Label '=';
        EmptyStringCaption_Control214Lbl: Label '=';
        FOR_PICK_UPS__PANEL_VANS_AND_LAND_ROVERS_REFER_TO_APPENDIX_5_OF_EMPLOYERS_GUIDE_CaptionLbl: Label 'FOR PICK-UPS, PANEL VANS AND LAND-ROVERS REFER TO APPENDIX 5 OF EMPLOYERS GUIDE.';
        If_this_amount_does_not_agree_with_total_of_Col__b_overleaf__attach_explanation_CaptionLbl: Label 'If this amount does not agree with total of Col. b overleaf, attach explanation.';
        CAR_BENEFIT___The_higher_the_amount_of_the_monthly_rate_or_the_prescribed__CaptiLbl: Label 'CAR BENEFIT - The higher the amount of the monthly rate or the prescribed  rate of benefits is to be brought to charge:-';
        PRESCRIBED_RATE___1996___1__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label 'PRESCRIBED RATE : 1996 - 1% per month of the initial cost of the vehicle   ';
        V1997___1_5__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label '1997 - 1.5% per month of the initial cost of the vehicle   ';
        V1998_et_seq____2_0__per_month_of_the_initial_cost_of_the_vehicle___CaptionLbl: Label '1998 et seq. - 2.0% per month of the initial cost of the vehicle   ';

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