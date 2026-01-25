report 51525378 NewPayslip2
{
    // ArrEarnings[1,1]
    // ArrEarningsAmt[1,1]
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/NewPayslip2.rdlc';


    dataset
    {
        dataitem(PayrollPeriodTable; "Payroll Period")
        {
            RequestFilterFields = "Starting Date";

            column(Starting_Date; "Starting Date")
            { }

            dataitem(Employee; Employee)
            {
                DataItemLink = "Pay Period Filter" = field("Starting Date");
                DataItemTableView = SORTING("Global Dimension 1 Code") ORDER(Ascending);
                RequestFilterFields = "No.";///*, "Payroll Country"*/, Position;
                column(Addr_1__1_; Addr[1] [1])
                {
                }
                column(Addr_1__2_; Addr[1] [2])
                {
                }
                column(AddrCapt1_3; AddrCapt[1] [3])
                {
                }
                column(AddrCapt1_4; AddrCapt[1] [4])
                {
                }
                column(AddrCapt1_5; AddrCapt[1] [5])
                {
                }
                column(AddrCapt1_6; AddrCapt[1] [6])
                {
                }
                column(AddrCapt1_7; AddrCapt[1] [7])
                {
                }
                column(AddrCapt1_8; AddrCapt[1] [8])
                {
                }
                column(AddrCapt1_9; AddrCapt[1] [9])
                {
                }
                column(AddrCapt1_10; AddrCapt[1] [10])
                {
                }
                column(AddrCapt1_11; AddrCapt[1] [11])
                {
                }
                column(AddrCapt1_12; AddrCapt[1] [12])
                {
                }
                column(AddrCapt1_13; AddrCapt[1] [13])
                {
                }
                column(AddrCapt1_14; AddrCapt[1] [14])
                {
                }
                column(AddrCapt1_15; AddrCapt[1] [15])
                {
                }
                column(AddrCapt1_16; AddrCapt[1] [16])
                {
                }
                column(Addr_1__3; Addr[1] [3])
                {
                }
                column(Addr_1__4; Addr[1] [4])
                {
                }
                column(Addr_1__5; Addr[1] [5])
                {
                }
                column(Addr_1__6; Addr[1] [6])
                {
                }
                column(Addr_1__7; Addr[1] [7])
                {
                }
                column(Addr_1__8; Addr[1] [8])
                {
                }
                column(Addr_1__9; Addr[1] [9])
                {
                }
                column(Addr_1__10; Addr[1] [10])
                {
                }
                column(Addr_1__11; Addr[1] [11])
                {
                }
                column(Addr_1__12; Addr[1] [12])
                {
                }
                column(Addr_1__13; Addr[1] [13])
                {
                }
                column(Addr_1__14; Addr[1] [14])
                {
                }
                column(Addr_1__15; Addr[1] [15])
                {
                }
                column(Addr_1__16; Addr[1] [16])
                {
                }
                column(DeptArr_1_1_; DeptArr[1, 1])
                {
                }
                column(CampArr_1_1_; CampArr[1, 1])
                {
                }
                column(ArrEarnings_1_1_; ArrEarnings[1, 1])
                {
                }
                column(ArrEarnings_1_2_; ArrEarnings[1, 2])
                {
                }
                column(ArrEarnings_1_3_; ArrEarnings[1, 3])
                {
                }
                column(ArrEarningsAmt_1_1_; ArrEarningsAmt[1, 1])
                {
                    //DecimalPlaces = 2 : 2;
                }
                column(ArrEarningsAmt_1_2_; ArrEarningsAmt[1, 2])
                {
                    //DecimalPlaces = 2 : 2;
                }
                column(ArrEarningsAmt_1_3_; ArrEarningsAmt[1, 3])
                {
                    //DecimalPlaces = 2 : 2;
                }
                column(ArrEarnings_1_4_; ArrEarnings[1, 4])
                {
                }
                column(ArrEarningsAmt_1_4_; ArrEarningsAmt[1, 4])
                {
                    //DecimalPlaces = 2 : 2;
                }
                column(ArrEarnings_1_5_; ArrEarnings[1, 5])
                {
                }
                column(ArrEarningsAmt_1_5_; ArrEarningsAmt[1, 5])
                {
                    //DecimalPlaces = 2 : 2;
                }
                column(ArrEarnings_1_6_; ArrEarnings[1, 6])
                {
                }
                column(ArrEarningsAmt_1_6_; ArrEarningsAmt[1, 6])
                {
                }
                column(ArrEarnings_1_7_; ArrEarnings[1, 7])
                {
                }
                column(ArrEarningsAmt_1_7_; ArrEarningsAmt[1, 7])
                {
                }
                column(ArrEarnings_1_8_; ArrEarnings[1, 8])
                {
                }
                column(ArrEarningsAmt_1_8_; ArrEarningsAmt[1, 8])
                {
                }
                column(UPPERCASE_FORMAT_DateSpecified_0___month_text___year4____; UpperCase(Format(DateSpecified, 0, '<month text> <year4>')))
                {
                }
                column(Age_CaptionLbl; Age_CaptionLbl)
                {
                }
                column(RetirementDate; Format(RetirementDate))
                {
                }
                column(Designation; Retirement_Age_Lbl)
                {
                }
                column(Age_; DAge)
                {
                }
                column(CoName; CoName)
                {
                }
                column(ArrEarningsAmt_1_9_; ArrEarningsAmt[1, 9])
                {
                }
                column(ArrEarningsAmt_1_10_; ArrEarningsAmt[1, 10])
                {
                }
                column(ArrEarningsAmt_1_11_; ArrEarningsAmt[1, 11])
                {
                }
                column(ArrEarningsAmt_1_12_; ArrEarningsAmt[1, 12])
                {
                }
                column(ArrEarningsAmt_1_13_; ArrEarningsAmt[1, 13])
                {
                }
                column(ArrEarningsAmt_1_14_; ArrEarningsAmt[1, 14])
                {
                }
                column(ArrEarningsAmt_1_15_; ArrEarningsAmt[1, 15])
                {
                }
                column(ArrEarningsAmt_1_16_; ArrEarningsAmt[1, 16])
                {
                }
                column(ArrEarnings_1_9_; ArrEarnings[1, 9])
                {
                }
                column(ArrEarnings_1_10_; ArrEarnings[1, 10])
                {
                }
                column(ArrEarnings_1_11_; ArrEarnings[1, 11])
                {
                }
                column(ArrEarnings_1_12_; ArrEarnings[1, 12])
                {
                }
                column(ArrEarnings_1_13_; ArrEarnings[1, 13])
                {
                }
                column(ArrEarnings_1_14_; ArrEarnings[1, 14])
                {
                }
                column(ArrEarnings_1_15_; ArrEarnings[1, 15])
                {
                }
                column(ArrEarnings_1_16_; ArrEarnings[1, 16])
                {
                }
                column(ArrEarningsAmt_1_17_; ArrEarningsAmt[1, 17])
                {
                }
                column(ArrEarnings_1_17_; ArrEarnings[1, 17])
                {
                }
                column(ArrEarnings_1_18_; ArrEarnings[1, 18])
                {
                }
                column(ArrEarnings_1_19_; ArrEarnings[1, 19])
                {
                }
                column(ArrEarnings_1_20_; ArrEarnings[1, 20])
                {
                }
                column(ArrEarnings_1_21_; ArrEarnings[1, 21])
                {
                }
                column(ArrEarnings_1_22_; ArrEarnings[1, 22])
                {
                }
                column(ArrEarnings_1_23_; ArrEarnings[1, 23])
                {
                }
                column(ArrEarnings_1_25_; ArrEarnings[1, 25])
                {
                }
                column(ArrEarnings_1_26_; ArrEarnings[1, 26])
                {
                }
                column(ArrEarnings_1_34_; ArrEarnings[1, 34])
                {
                }
                column(ArrEarnings_1_33_; ArrEarnings[1, 33])
                {
                }
                column(ArrEarnings_1_32_; ArrEarnings[1, 32])
                {
                }
                column(ArrEarnings_1_31_; ArrEarnings[1, 31])
                {
                }
                column(ArrEarnings_1_30_; ArrEarnings[1, 30])
                {
                }
                column(ArrEarnings_1_29_; ArrEarnings[1, 29])
                {
                }
                column(ArrEarnings_1_28_; ArrEarnings[1, 28])
                {
                }
                column(ArrEarnings_1_27_; ArrEarnings[1, 27])
                {
                }
                column(ArrEarnings_1_41_; ArrEarnings[1, 41])
                {
                }
                column(ArrEarnings_1_40_; ArrEarnings[1, 40])
                {
                }
                column(ArrEarnings_1_39_; ArrEarnings[1, 39])
                {
                }
                column(ArrEarnings_1_38_; ArrEarnings[1, 38])
                {
                }
                column(ArrEarnings_1_37_; ArrEarnings[1, 37])
                {
                }
                column(ArrEarnings_1_36_; ArrEarnings[1, 36])
                {
                }
                column(ArrEarnings_1_35_; ArrEarnings[1, 35])
                {
                }
                column(ArrEarningsAmt_1_33_; ArrEarningsAmt[1, 33])
                {
                }
                column(ArrEarningsAmt_1_32_; ArrEarningsAmt[1, 32])
                {
                }
                column(ArrEarningsAmt_1_31_; ArrEarningsAmt[1, 31])
                {
                }
                column(ArrEarningsAmt_1_30_; ArrEarningsAmt[1, 30])
                {
                }
                column(ArrEarningsAmt_1_29_; ArrEarningsAmt[1, 29])
                {
                }
                column(ArrEarningsAmt_1_28_; ArrEarningsAmt[1, 28])
                {
                }
                column(ArrEarningsAmt_1_27_; ArrEarningsAmt[1, 27])
                {
                }
                column(ArrEarningsAmt_1_26_; ArrEarningsAmt[1, 26])
                {
                }
                column(ArrEarningsAmt_1_25_; ArrEarningsAmt[1, 25])
                {
                }
                column(ArrEarningsAmt_1_24_; ArrEarningsAmt[1, 24])
                {
                }
                column(ArrEarningsAmt_1_23_; ArrEarningsAmt[1, 23])
                {
                }
                column(ArrEarningsAmt_1_22_; ArrEarningsAmt[1, 22])
                {
                }
                column(ArrEarningsAmt_1_21_; ArrEarningsAmt[1, 21])
                {
                }
                column(ArrEarningsAmt_1_20_; ArrEarningsAmt[1, 20])
                {
                }
                column(ArrEarningsAmt_1_19_; ArrEarningsAmt[1, 19])
                {
                }
                column(ArrEarningsAmt_1_18_; ArrEarningsAmt[1, 18])
                {
                }
                column(ArrEarnings_1_24_; ArrEarnings[1, 24])
                {
                }
                column(ArrEarningsAmt_1_39_; ArrEarningsAmt[1, 39])
                {
                }
                column(ArrEarningsAmt_1_38_; ArrEarningsAmt[1, 38])
                {
                }
                column(ArrEarningsAmt_1_37_; ArrEarningsAmt[1, 37])
                {
                }
                column(ArrEarningsAmt_1_36_; ArrEarningsAmt[1, 36])
                {
                }
                column(ArrEarningsAmt_1_35_; ArrEarningsAmt[1, 35])
                {
                }
                column(ArrEarningsAmt_1_34_; ArrEarningsAmt[1, 34])
                {
                }
                column(ArrEarningsAmt_1_41_; ArrEarningsAmt[1, 41])
                {
                }
                column(ArrEarningsAmt_1_40_; ArrEarningsAmt[1, 40])
                {
                }
                column(Message1; Message1)
                {
                }
                column(Message2_1_1_; Message2[1, 1])
                {
                }
                column(ArrEarningsAmt_1_43_; ArrEarningsAmt[1, 43])
                {
                }
                column(ArrEarningsAmt_1_42_; ArrEarningsAmt[1, 42])
                {
                }
                column(ArrEarningsAmt_1_45_; ArrEarningsAmt[1, 45])
                {
                }
                column(ArrEarningsAmt_1_44_; ArrEarningsAmt[1, 44])
                {
                }
                column(ArrEarnings_1_45_; ArrEarnings[1, 45])
                {
                }
                column(ArrEarnings_1_44_; ArrEarnings[1, 44])
                {
                }
                column(ArrEarnings_1_43_; ArrEarnings[1, 43])
                {
                }
                column(ArrEarnings_1_42_; ArrEarnings[1, 42])
                {
                }
                column(ArrEarningsAmt_1_48_; ArrEarningsAmt[1, 48])
                {
                }
                column(ArrEarningsAmt_1_46_; ArrEarningsAmt[1, 46])
                {
                }
                column(ArrEarningsAmt_1_47_; ArrEarningsAmt[1, 47])
                {
                }
                column(ArrEarnings_1_48_; ArrEarnings[1, 48])
                {
                }
                column(ArrEarnings_1_47_; ArrEarnings[1, 47])
                {
                }
                column(ArrEarnings_1_46_; ArrEarnings[1, 46])
                {
                }
                column(ArrEarningsAmt_1_49_; ArrEarningsAmt[1, 49])
                {
                }
                column(ArrEarningsAmt_1_50_; ArrEarningsAmt[1, 50])
                {
                }
                column(ArrEarningsAmt_1_51_; ArrEarningsAmt[1, 51])
                {
                }
                column(ArrEarningsAmt_1_52_; ArrEarningsAmt[1, 52])
                {
                }
                column(ArrEarningsAmt_1_53_; ArrEarningsAmt[1, 53])
                {
                }
                column(ArrEarningsAmt_1_54_; ArrEarningsAmt[1, 54])
                {
                }
                column(ArrEarningsAmt_1_55_; ArrEarningsAmt[1, 55])
                {
                }
                column(ArrEarningsAmt_1_56_; ArrEarningsAmt[1, 56])
                {
                }
                column(ArrEarningsAmt_1_57_; ArrEarningsAmt[1, 57])
                {
                }
                column(ArrEarningsAmt_1_58_; ArrEarningsAmt[1, 58])
                {
                }
                column(ArrEarningsAmt_1_59_; ArrEarningsAmt[1, 59])
                {
                }
                column(ArrEarningsAmt_1_60_; ArrEarningsAmt[1, 60])
                {
                }
                column(ArrEarnings_1_49_; ArrEarnings[1, 49])
                {
                }
                column(ArrEarnings_1_50_; ArrEarnings[1, 50])
                {
                }
                column(ArrEarnings_1_51_; ArrEarnings[1, 51])
                {
                }
                column(ArrEarnings_1_52_; ArrEarnings[1, 52])
                {
                }
                column(ArrEarnings_1_53_; ArrEarnings[1, 53])
                {
                }
                column(ArrEarnings_1_54_; ArrEarnings[1, 54])
                {
                }
                column(ArrEarnings_1_55_; ArrEarnings[1, 55])
                {
                }
                column(ArrEarnings_1_56_; ArrEarnings[1, 56])
                {
                }
                column(ArrEarnings_1_57_; ArrEarnings[1, 57])
                {
                }
                column(ArrEarnings_1_58_; ArrEarnings[1, 58])
                {
                }
                column(ArrEarnings_1_59_; ArrEarnings[1, 59])
                {
                }
                column(ArrEarnings_1_60_; ArrEarnings[1, 60])
                {
                }
                column(CoRec_Picture; CoRec.Picture)
                {
                }
                column(BalanceArray_1_1_; BalanceArrs[1, 1])
                {
                }
                column(BalanceArray_1_2_; BalanceArrs[1, 2])
                {
                }
                column(BalanceArray_1_3_; BalanceArrs[1, 3])
                {
                }
                column(BalanceArray_1_4_; BalanceArrs[1, 4])
                {
                }
                column(BalanceArray_1_5_; BalanceArrs[1, 5])
                {
                }
                column(BalanceArray_1_6_; BalanceArrs[1, 6])
                {
                }
                column(BalanceArray_1_7_; BalanceArrs[1, 7])
                {
                }
                column(BalanceArray_1_8_; BalanceArrs[1, 8])
                {
                }
                column(BalanceArray_1_9_; BalanceArrs[1, 9])
                {
                }
                column(BalanceArray_1_10_; BalanceArrs[1, 10])
                {
                }
                column(BalanceArray_1_11_; BalanceArrs[1, 11])
                {
                }
                column(BalanceArray_1_12_; BalanceArrs[1, 12])
                {
                }
                column(BalanceArray_1_13_; BalanceArrs[1, 13])
                {
                }
                column(BalanceArray_1_14_; BalanceArrs[1, 14])
                {
                }
                column(BalanceArray_1_15_; BalanceArrs[1, 15])
                {
                }
                column(BalanceArray_1_16_; BalanceArrs[1, 16])
                {
                }
                column(BalanceArray_1_17_; BalanceArrs[1, 17])
                {
                }
                column(BalanceArray_1_18_; BalanceArrs[1, 18])
                {
                }
                column(BalanceArray_1_19_; BalanceArrs[1, 19])
                {
                }
                column(BalanceArray_1_20_; BalanceArrs[1, 22])
                {
                }
                column(BalanceArray_1_21_; BalanceArrs[1, 21])
                {
                }
                column(BalanceArray_1_23_; BalanceArrs[1, 23])
                {
                }
                column(BalanceArray_1_24_; BalanceArrs[1, 24])
                {
                }
                column(BalanceArray_1_25_; BalanceArrs[1, 25])
                {
                }
                column(BalanceArray_1_26_; BalanceArrs[1, 26])
                {
                }
                column(BalanceArray_1_27_; BalanceArrs[1, 27])
                {
                }
                column(BalanceArray_1_28_; BalanceArrs[1, 28])
                {
                }
                column(BalanceArray_1_29_; BalanceArrs[1, 29])
                {
                }
                column(BalanceArray_1_30_; BalanceArrs[1, 30])
                {
                }
                column(BalanceArray_1_31_; BalanceArrs[1, 31])
                {
                }
                column(BalanceArray_1_32_; BalanceArrs[1, 32])
                {
                }
                column(BalanceArray_1_34_; BalanceArrs[1, 34])
                {
                }
                column(BalanceArray_1_33_; BalanceArrs[1, 33])
                {
                }
                column(BalanceArray_1_36_; BalanceArrs[1, 36])
                {
                }
                column(BalanceArray_1_35_; BalanceArrs[1, 35])
                {
                }
                column(BalanceArray_1_37_; BalanceArrs[1, 37])
                {
                }
                column(BalanceArray_1_38_; BalanceArrs[1, 38])
                {
                }
                column(BalanceArray_1_39_; BalanceArrs[1, 39])
                {
                }
                column(BalanceArray_1_40_; BalanceArrs[1, 40])
                {
                }
                column(BalanceArray_1_41_; BalanceArrs[1, 41])
                {
                }
                column(BalanceArray_1_42_; BalanceArrs[1, 42])
                {
                }
                column(BalanceArray_1_43_; BalanceArrs[1, 43])
                {
                }
                column(BalanceArray_1_44_; BalanceArrs[1, 44])
                {
                }
                column(BalanceArray_1_45_; BalanceArrs[1, 45])
                {
                }
                column(BalanceArray_1_46_; BalanceArrs[1, 46])
                {
                }
                column(BalanceArray_1_47_; BalanceArrs[1, 47])
                {
                }
                column(BalanceArray_1_48_; BalanceArrs[1, 48])
                {
                }
                column(STRSUBSTNO__Date__1__2__TODAY_TIME_; StrSubstNo('Date %1 %2', Today, Time))
                {
                }
                column(USERID; UserId)
                {
                }
                column(CurrReport_PAGENO; CurrReport.PageNo)
                {
                }
                column(EarningsCaption; EarningsCaptionLbl)
                {
                }
                column(Employee_No_Caption; Employee_No_CaptionLbl)
                {
                }
                column(Name_Caption; Name_CaptionLbl)
                {
                }
                column(Dept_Caption; Dept_CaptionLbl)
                {
                }
                column(Camp_Caption; Camp_CaptionLbl)
                {
                }
                column(AmountCaption; AmountCaptionLbl)
                {
                }
                column(Pay_slipCaption; Pay_slipCaptionLbl)
                {
                }
                column(EmptyStringCaption; EmptyStringCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Employee_No_; "No.")
                {
                }
                column(Loan_Balance; LoanBalance)
                {
                }
                column(Water_Mark; CoRec."Water Mark")
                {
                }
                column(copy99; copy99)
                {
                }
                column(Balance_9; BalanceArrs[1, 9])
                {
                }
                column(Balance_10; BalanceArrs[1, 10])
                {
                }
                column(Balance_11; BalanceArrs[1, 11])
                {
                }
                column(Balance_12; BalanceArrs[1, 12])
                {
                }
                column(Balance_13; BalanceArrs[1, 13])
                {
                }
                column(Balance_14; BalanceArrs[1, 14])
                {
                }
                column(Balance_15; BalanceArrs[1, 15])
                {
                }
                column(Balance_16; BalanceArrs[1, 16])
                {
                }
                column(Balance_17; BalanceArrs[1, 17])
                {
                }
                column(Balance_18; BalanceArrs[1, 18])
                {
                }
                column(Balance_19; BalanceArrs[1, 19])
                {
                }
                column(Balance_20; BalanceArrs[1, 20])
                {
                }
                column(Balance_21; BalanceArrs[1, 21])
                {
                }
                column(Balance_22; BalanceArrs[1, 22])
                {
                }
                column(Balance_23; BalanceArrs[1, 23])
                {
                }
                column(Balance_24; BalanceArrs[1, 24])
                {
                }
                column(Balance_25; BalanceArrs[1, 25])
                {
                }
                column(Balance_26; BalanceArrs[1, 26])
                {
                }
                column(Balance_27; BalanceArrs[1, 27])
                {
                }
                column(Balance_28; BalanceArrs[1, 28])
                {
                }
                column(Balance_29; BalanceArrs[1, 29])
                {
                }
                column(Balance_30; BalanceArrs[1, 30])
                {
                }
                column(Balance_31; BalanceArrs[1, 31])
                {
                }
                column(Balance_32; BalanceArrs[1, 32])
                {
                }
                column(Balance_33; BalanceArrs[1, 33])
                {
                }
                column(Balance_34; BalanceArrs[1, 34])
                {
                }
                column(Balance_35; BalanceArrs[1, 35])
                {
                }
                column(Balance_36; BalanceArrs[1, 36])
                {
                }
                column(Balance_37; BalanceArrs[1, 37])
                {
                }
                column(Balance_38; BalanceArrs[1, 38])
                {
                }
                column(Balance_39; BalanceArrs[1, 39])
                {
                }

                trigger OnAfterGetRecord()
                var
                    loanType: Record "Loan Product Type";
                    RepSchedule: Record "Repayment Schedule";
                    TotalBulkRepayments: Decimal;
                    TotalRepayments: Decimal;
                    LineAmt: Decimal;
                    TotalPensionInactive: Decimal;
                    PensionArrs: Decimal;
                    localCurrencyCode: Code[50];
                    GenLedgerSetup: Record "General Ledger Setup";
                    CurrencyExchangeRate: Record "Currency Exchange Rate";
                    CurrExchangeRateDate: Date;
                    Fcy1ToLcyRate: Decimal;
                    LcyToFcy2Rate: Decimal;
                    BankAccountNo: Code[100];
                    PayTrans: Record "Assignment Matrix";
                    Countries: Record "Country/Region";
                    TransactionCountry: Code[200];

                begin
                    Clear(Addr);
                    Clear(DeptArr);
                    Clear(BasicPay);
                    Clear(EmpArray);
                    Clear(ArrEarnings);
                    Clear(ArrEarningsAmt);
                    Clear(BalanceArray);
                    Clear(Balance);
                    GrossPay := 0;
                    TotalDeduction := 0;
                    TransAmount := 0;
                    TotalNonStatutoryDeductions := 0;
                    Totalcoopshares := 0;
                    Totalnssf := 0;
                    NetPay := 0;
                    ExchangeRate := 1;
                    RoundValue := 1;
                    AssnAmt := 0;
                    TransactionCountryCurrency := '';//Employee."Payroll Currency";
                    TransactionCountry := '';
                    localCurrencyCode := '';
                    CurrExchangeRateDate := CalcDate('1M', DateSpecified/*MonthStartDate*/);
                    Fcy1ToLcyRate := 0;
                    LcyToFcy2Rate := 0;
                    //DateSpecified := Employee.GetFilter("Pay Period Filter");
                    //If payroll country is blank - then pick one found in the selected period's payroll trans
                    if SelectedPayrollCountry = '' then begin
                        PayTrans.Reset();
                        PayTrans.SetRange("Payroll Period", DateSpecified);
                        PayTrans.SetRange("Employee No", Employee."No.");
                        PayTrans.SetFilter(Country, '<>%1', '');
                        if PayTrans.FindFirst() then begin
                            SelectedPayrollCountry := PayTrans.Country;
                            TransactionCountry := PayTrans.Country;
                            TransactionCountryCurrency := PayTrans."Country Currency";
                        end;
                    end else begin
                        PayTrans.Reset();
                        PayTrans.SetRange("Payroll Period", DateSpecified);
                        PayTrans.SetRange("Employee No", Employee."No.");
                        //PayTrans.SetFilter(Country, '<>%1', '');
                        PayTrans.SetRange(Country, SelectedPayrollCountry);
                        if PayTrans.FindFirst() then begin
                            TransactionCountry := PayTrans.Country;
                            TransactionCountryCurrency := PayTrans."Country Currency";
                        end;
                    end;
                    if SelectedPayrollCountry = '' then
                        Error('Payroll country not found!');
                    //Message('SelectedPayrollCountry %1, TransactionCountryCurrency %2, SelectedDisplayCurrency %3', SelectedPayrollCountry, TransactionCountryCurrency, SelectedDisplayCurrency);
                    if TransactionCountryCurrency = '' then begin
                        Countries.Reset();
                        Countries.SetRange(Code, /*Employee."Payroll Country"*/TransactionCountry);
                        if Countries.FindFirst() then begin
                            TransactionCountryCurrency := Countries."Country Currency";
                            //Employee."Payroll Currency" := TransactionCountryCurrency;
                        end;
                    end;


                    BankAccountNo := Employee."Bank Account No";
                    BankName := Employee."Bank Name";
                    if BankAccountNo = '' then
                        BankAccountNo := Employee."Bank Account No.";

                    //If for previous periods
                    EmpPeriodBankDetails.Reset();
                    EmpPeriodBankDetails.SetRange("Emp No.", Employee."No.");
                    EmpPeriodBankDetails.SetRange("Payroll Period", DateSpecified);
                    if EmpPeriodBankDetails.FindFirst() then begin
                        BankName := EmpPeriodBankDetails."Bank Name";
                        BankAccountNo := EmpPeriodBankDetails."Bank Account No.";
                    end;
                    if SelectedDisplayCurrency = '' then
                        SelectedDisplayCurrency := TransactionCountryCurrency;

                    if ((SelectedDisplayCurrency <> '') and (SelectedDisplayCurrency <> TransactionCountryCurrency/*Employee."Payroll Currency"*/)) then begin
                        //TransactionCountryCurrency := SelectedDisplayCurrency;
                        GenLedgerSetup.Get();
                        localCurrencyCode := GenLedgerSetup."LCY Code";
                        if localCurrencyCode = '' then
                            Error('The local currency code has not been specified in the General Ledger Setup!');
                        //If the currency is already in local and you want to change to local, just exchange direct from LCY to that currency
                        if (/*Employee."Payroll Currency"*/TransactionCountryCurrency = localCurrencyCode) then begin
                            //ExchangeRate := 1;
                            CurrencyExchangeRate.GetLastestExchangeRateCustom(SelectedDisplayCurrency, CurrExchangeRateDate, ExchangeRate);
                            if (CurrExchangeRateDate = 0D) then
                                Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', SelectedDisplayCurrency, localCurrencyCode);
                            if ExchangeRate <> 0 then
                                ExchangeRate := 1 / ExchangeRate;
                            //Message('ExchangeRate 1 %1', ExchangeRate);
                        end else begin
                            //If they just want to change to the local currency and end there, then change direct
                            if (SelectedDisplayCurrency = localCurrencyCode) then begin
                                CurrencyExchangeRate.GetLastestExchangeRateCustom(TransactionCountryCurrency/*Employee."Payroll Currency"*/, CurrExchangeRateDate, ExchangeRate);
                                if (CurrExchangeRateDate = 0D) then
                                    Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', TransactionCountryCurrency/*Employee."Payroll Currency"*/, localCurrencyCode);
                            end;
                            //If they just want to change from FCY1 to FCY2 but now they need to pass through LCY
                            if (SelectedDisplayCurrency <> localCurrencyCode) then begin
                                //1. Get the FCY1 to LCY rate
                                CurrencyExchangeRate.GetLastestExchangeRateCustom(TransactionCountryCurrency/*Employee."Payroll Currency"*/, CurrExchangeRateDate, Fcy1ToLcyRate);
                                if (CurrExchangeRateDate = 0D) then
                                    Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', TransactionCountryCurrency/*Employee."Payroll Currency"*/, localCurrencyCode);

                                //2. Get the LCY to FCY2 rate
                                CurrencyExchangeRate.GetLastestExchangeRateCustom(SelectedDisplayCurrency, CurrExchangeRateDate, LcyToFcy2Rate);
                                if (CurrExchangeRateDate = 0D) then
                                    Error('Currency exchange rates from %1 to %2 have not been set! Kindly contact the payroll office!', localCurrencyCode, SelectedDisplayCurrency);

                                //3. Let us now try to find 1 figure from the two rates above such that when we multiply with the current currency we get the desired currency
                                ExchangeRate := Fcy1ToLcyRate * (1 / LcyToFcy2Rate);
                                //Message('ExchangeRate 2 %1', ExchangeRate);
                            end;
                        end;

                    end;
                    RoundValue := 1;
                    if SelectedDisplayCurrency = 'USD' then
                        RoundValue := 0.01;

                    /*  CurrExchangeRates.reset;
                      CurrExchangeRates.setrange("Currency Code", SelectedDisplayCurrency);
                      CurrExchangeRates.setrange("Relational Currency Code", Employee."Payroll Currency");
                      CurrExchangeRates.setcurrentkey("Starting Date");
                      CurrExchangeRates.setascending("Starting Date", false);
                      if CurrExchangeRates.findfirst then
                          ExchangeRate := CurrExchangeRates."Relational Exch. Rate Amount"
                      else
                  end;*/
                    //Message('ExchangeRate 3 %1', ExchangeRate);


                    Addr[1] [1] := Employee."No.";
                    Addr[1] [2] := Employee."Last Name" + ' ' + Employee."Middle Name" + ' ' + Employee."First Name";
                    /* get Department Name
                    DimVal.RESET;
                    DimVal.SETRANGE(DimVal.Code,Employee."Global Dimension 2 Code");
                    DimVal.SETRANGE("Global Dimension No.",2);
                    IF DimVal.FIND('-') THEN
                    DeptArr[1,1]:=DimVal.Name;*/

                    j := 2;
                    /***AddrCapt[1, j] := 'P.I.N';
                    Addr[1, j] := Employee."PIN Number";
                    j := j + 1;
                    AddrCapt[1, j] := 'NSSF No';
                    Addr[1, j] := Employee."NSSF No.";
                    j := j + 1;
                    AddrCapt[1, j] := 'NHIF No';
                    Addr[1, j] := Employee."NHIF No.";
                    j := j + 1;***/
                    // AddrCapt[1,j]:='PIN';
                    //Addr[1,j]:=Employee."PIN Number";
                    j := j + 1;//5;
                               // get Department Name
                               /*DimVal.Reset;
                               DimVal.SetRange(DimVal.Code, Employee."Global Dimension 2 Code");
                               DimVal.SetRange("Global Dimension No.", 2);
                               if DimVal.Find('-') then begin
                                   AddrCapt[1, j] := 'Department.';
                                   Addr[1, j] := DimVal.Name;
                                   ;
                               end;*/
                    AddrCapt[1, j] := 'Payroll Country:';
                    Addr[1, j] := SelectedPayrollCountry;
                    j := j + 1;
                    AddrCapt[1, j] := 'Department:';
                    Addr[1, j] := Employee."Responsibility Center Name";
                    j := j + 1;
                    AddrCapt[1, j] := 'Section:';
                    Addr[1, j] := Employee."Sub Responsibility Center";//"Emplymt. Contract Code";
                    j := j + 1;
                    AddrCapt[1, j] := 'Designation:';
                    Addr[1, j] := Employee."Job Title";
                    j := j + 1;
                    AddrCapt[1, j] := 'Currency:';
                    Addr[1, j] := SelectedDisplayCurrency;//"Salary Scale";
                    j := j + 1;
                    AddrCapt[1, j] := 'Pension No:';
                    Addr[1, j] := Employee."NSSF No.";
                    j := j + 1;
                    AddrCapt[1, j] := 'Medical No:';
                    Addr[1, j] := Employee."NHIF No.";
                    j := j + 1;

                    AddrCapt[1, 11] := 'Medical No:';
                    Addr[1, 11] := Employee."NHIF No.";

                    // Get Basic Salary
                    /*Earn.Reset;
                    Earn.SetRange(Earn."Basic Salary Code", true);
                    if Earn.Find('-') then begin
                        AssignMatrix.Reset;
                        AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                        AssignMatrix.SetRange(Type, AssignMatrix.Type::Payment);
                        AssignMatrix.SetRange(AssignMatrix.Code, Earn.Code);
                        AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                        AssignMatrix.setrange(AssignMatrix.Country, Employee."Country/Region Code")
                        //IF AssignMatrix.FIND('-') THEN BEGIN
                         BasicPay[1,1]:=Earn.Description;
                         EmpArray[1,1]:=AssignMatrix.Amount;
                         GrossPay:=GrossPay+AssignMatrix.Amount;
                        END;//
                    end;*/
                    i := 1;
                    Earn.Reset;
                    Earn.SetRange(Earn."Earning Type", Earn."Earning Type"::"Normal Earning");
                    Earn.SetRange(Earn."Non-Cash Benefit", false);
                    Earn.SetRange(Earn.Fringe, false);
                    Earn.SetRange(Earn.Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    Earn.SetRange("Exclude from Payroll", false);
                    if Earn.Find('-') then begin
                        repeat
                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                            AssignMatrix.SetRange(Type, AssignMatrix.Type::Payment);
                            AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                            // AssignMatrix.SETRANGE(AssignMatrix."Basic Salary Code",FALSE);
                            AssignMatrix.SetRange(Code, Earn.Code);
                            AssignMatrix.setrange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                            if AssignMatrix.Find('-') then begin
                                repeat
                                    //Message('Earning %1 | Amount %2 | ExchangeRate %3', AssignMatrix.Description, AssignMatrix.Amount, ExchangeRate);
                                    ArrEarnings[1, i] := AssignMatrix.Description;
                                    Evaluate(ArrEarningsAmt[1, i], Format(Round((AssignMatrix.Amount * ExchangeRate), RoundValue)));
                                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                                    GrossPay := GrossPay + (Round((AssignMatrix.Amount * ExchangeRate), RoundValue));
                                    i := i + 1;
                                until AssignMatrix.Next = 0;
                            end;
                        until Earn.Next = 0;
                    end;


                    //Add here deductions that reduce Gross
                    DeductionsThatReduceGross := 0;
                    AssignMatrix.Reset;
                    AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                    AssignMatrix.SetRange(Type, AssignMatrix.Type::Deduction);
                    AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                    AssignMatrix.SetRange(AssignMatrix."Reduces Gross", true);
                    AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    if AssignMatrix.Find('-') then begin
                        repeat
                            ArrEarnings[1, i] := AssignMatrix.Description;
                            Evaluate(ArrEarningsAmt[1, i], Format(-Abs(Round((AssignMatrix.Amount * ExchangeRate), RoundValue))));
                            ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);
                            i := i + 1;
                            DeductionsThatReduceGross := DeductionsThatReduceGross + Abs(Round((AssignMatrix.Amount * ExchangeRate), RoundValue));
                        until AssignMatrix.Next() = 0;
                    end;

                    Sencondd.Reset;
                    Sencondd.SetRange("Employee No", Employee."No.");
                    Sencondd.SetRange("Payroll Period", DateSpecified);
                    if Sencondd.Find('-') then begin
                        //IF Employee."Secondment Amount"<>0 THEN BEGIN
                        ArrEarnings[1, i] := 'Secondment Amount';
                        Evaluate(ArrEarningsAmt[1, i], Format(Sencondd."Secondment Amount"));
                        ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);
                        GrossPay := GrossPay - (Round((Sencondd."Secondment Amount" * ExchangeRate), RoundValue));
                        i := i + 1;
                        // END;
                    end;
                    GrossPay := GrossPay - DeductionsThatReduceGross;
                    ArrEarnings[1, i] := 'GROSS PAY';
                    Evaluate(ArrEarningsAmt[1, i], Format(GrossPay));
                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                    i := i + 1;

                    ArrEarnings[1, i] := '************************************************';
                    ArrEarningsAmt[1, i] := '************************************************';

                    i := i + 1;

                    // taxation
                    ArrEarnings[1, i] := 'Taxations';

                    i := i + 1;

                    ArrEarnings[1, i] := '************************************************';
                    ArrEarningsAmt[1, i] := '***********************************************';

                    i := i + 1;
                    // Non Cash Benefits
                    Earn.Reset;
                    Earn.SetRange(Earn."Earning Type", Earn."Earning Type"::"Normal Earning");
                    Earn.SetRange(Earn."Non-Cash Benefit", true);
                    Earn.SetRange(Earn.Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    Earn.SetRange("Exclude from Payroll", false);
                    if Earn.Find('-') then begin
                        repeat
                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                            AssignMatrix.SetRange(Type, AssignMatrix.Type::Payment);
                            AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                            AssignMatrix.SetRange(AssignMatrix."Basic Salary Code", false);
                            AssignMatrix.SetRange(Code, Earn.Code);
                            AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                            if AssignMatrix.Find('-') then begin
                                repeat
                                    ArrEarnings[1, i] := AssignMatrix.Description;
                                    Evaluate(ArrEarningsAmt[1, i], Format((Round((AssignMatrix.Amount * ExchangeRate), RoundValue))));
                                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                                    i := i + 1;
                                until AssignMatrix.Next = 0;
                            end;
                        until Earn.Next = 0;
                    end;
                    //Telephone Allowance
                    Earn.Reset;
                    Earn.SetRange(Earn."Earning Type", Earn."Earning Type"::"Telephone Allowance");
                    Earn.SetRange(Earn."Non-Cash Benefit", true);
                    Earn.SetFilter("Taxable Percentage", '<>%1', 0);
                    Earn.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    Earn.SetRange("Exclude from Payroll", false);
                    if Earn.Find('-') then begin
                        repeat
                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                            AssignMatrix.SetRange(Type, AssignMatrix.Type::Payment);
                            AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                            AssignMatrix.SetRange(Code, Earn.Code);
                            AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                            if AssignMatrix.Find('-') then begin
                                repeat
                                    ArrEarnings[1, i] := AssignMatrix.Description;
                                    Evaluate(ArrEarningsAmt[1, i], Format(Round(((AssignMatrix.Amount * (Earn."Taxable Percentage" / 100)) * ExchangeRate), RoundValue)));
                                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);
                                    i := i + 1;
                                until AssignMatrix.Next = 0;
                            end;
                        until Earn.Next = 0;
                    end;
                    // Pension Benefit
                    PensionBen := 0;
                    PensionBenER := 0;
                    Ded.Reset;
                    Ded.SetRange("Pension Scheme", true);
                    Ded.SetRange("Employer Contibution Taxed", true);
                    Ded.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    if Ded.Find('-') then begin
                        repeat
                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                            AssignMatrix.SetRange(Type, AssignMatrix.Type::Deduction);
                            AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                            AssignMatrix.SetRange(Code, Ded.Code);
                            AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                            if AssignMatrix.Find('-') then begin
                                PensionBen := PensionBen + Abs((Round((AssignMatrix.Amount * ExchangeRate), RoundValue)));
                                PensionBenER := PensionBenER + Abs((Round((AssignMatrix."Employer Amount" * ExchangeRate), RoundValue)));
                            end;
                        until Ded.Next = 0;
                    end;

                    PensionAdd := 0;
                    CompRec.Get;
                    if PensionBen > 0 then begin
                        if PensionBen > CompRec."Pension Limit Amount" then
                            PensionAdd := PensionBenER;
                        if PensionBen < CompRec."Pension Limit Amount" then begin
                            if (PensionBen + PensionBenER) < CompRec."Pension Limit Amount" then
                                PensionAdd := PensionBen + PensionBenER else
                                PensionAdd := PensionBen + PensionBenER - CompRec."Pension Limit Amount";
                        end;
                    end;
                    // i:=i+1;
                    /*  ArrEarnings[1,i]:='Gross Amount';
                     EVALUATE(ArrEarningsAmt[1,i],FORMAT(ABS(GrossPay)));*///Kit
                                                                           //ArrEarningsAmt[1,i]:=ChckRound(ArrEarningsAmt[1,i],RoundValue);
                                                                           // i:=i+1;


                    // end of non cash
                    AssignMatrix.Reset;
                    AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                    AssignMatrix.SetRange(Type, AssignMatrix.Type::Deduction);
                    AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                    AssignMatrix.SetRange(AssignMatrix.Paye, true);
                    AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    if AssignMatrix.Find('-') then begin
                        /* ArrEarnings[1,i]:='Less Pension Contribution';
                        EVALUATE(ArrEarningsAmt[1,i],FORMAT(ABS(AssignMatrix."Less Pension Contribution")));//Kit
                       ArrEarningsAmt[1,i]:=ChckRound(ArrEarningsAmt[1,i],RoundValue);*/


                        TaxableAmt := 0;
                        PAYE := 0;

                        TaxableAmt := (Round((AssignMatrix."Taxable amount" * ExchangeRate), RoundValue));
                        PAYE := (Round((AssignMatrix.Amount * ExchangeRate), RoundValue));

                    end;


                    i := i + 1;
                    /*Earn.RESET;
                    Earn.SETRANGE(Earn."Earning Type",Earn."Earning Type"::"Owner Occupier");
                    IF Earn.FIND('-') THEN BEGIN
                     REPEAT
                      AssignMatrix.RESET;
                      AssignMatrix.SETRANGE(AssignMatrix."Payroll Period",DateSpecified);
                      AssignMatrix.SETRANGE(Type,AssignMatrix.Type::Payment);
                      AssignMatrix.SETRANGE(AssignMatrix."Employee No",Employee."No.");
                      AssignMatrix.SETRANGE(AssignMatrix."Basic Salary Code",FALSE);
                      AssignMatrix.SETRANGE(Code,Earn.Code);
                      IF AssignMatrix.FIND('-') THEN BEGIN
                       REPEAT
                        ArrEarnings[1,i]:=AssignMatrix.Description;
                        EVALUATE(ArrEarningsAmt[1,i],FORMAT(AssignMatrix.Amount));
                      ArrEarningsAmt[1,i]:=ChckRound(ArrEarningsAmt[1,i],RoundValue);

                       i:=i+1;
                     UNTIL AssignMatrix.NEXT=0;
                     END;
                   UNTIL Earn.NEXT=0;
                  END;*/

                    // Taxable amount
                    ArrEarnings[1, i] := 'Taxable Amount';
                    Evaluate(ArrEarningsAmt[1, i], Format(Abs((TaxableAmt - (Round((Employee."Secondment Amount" * ExchangeRate), RoundValue))))));
                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                    i := i + 1;
                    FnFindRelief(Employee."No.", DateSpecified);
                    ReliefAmt := -(Round((ReliefAmt * ExchangeRate), RoundValue));
                    // MESSAGE('Relief%1Paye%2',ReliefAmt,PAYE);
                    ArrEarnings[1, i] := 'Tax Charged';
                    Evaluate(ArrEarningsAmt[1, i], Format(Abs(PAYE + ReliefAmt)));
                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                    i := i + 1;

                    // Relief
                    Earn.Reset;
                    Earn.SetFilter(Earn."Earning Type", '%1|%2|%3', Earn."Earning Type"::"Tax Relief",
                    Earn."Earning Type"::"Insurance Relief", Earn."Earning Type"::"Owner Occupier");
                    Earn.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    Earn.SetRange("Exclude from Payroll", false);
                    if Earn.Find('-') then begin
                        repeat
                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                            AssignMatrix.SetRange(Type, AssignMatrix.Type::Payment);
                            AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                            AssignMatrix.SetRange(AssignMatrix."Basic Salary Code", false);
                            AssignMatrix.SetRange(Code, Earn.Code);
                            AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                            if AssignMatrix.Find('-') then begin
                                repeat
                                    ArrEarnings[1, i] := AssignMatrix.Description;
                                    Evaluate(ArrEarningsAmt[1, i], Format(Abs((Round((AssignMatrix.Amount * ExchangeRate), RoundValue)))));
                                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                                    i := i + 1;
                                until AssignMatrix.Next = 0;
                            end;
                        until Earn.Next = 0;
                    end;

                    ArrEarnings[1, i] := '************************************************';
                    ArrEarningsAmt[1, i] := '***********************************************';


                    i := i + 1;

                    // Deductions

                    ArrEarnings[1, i] := 'Deductions';

                    i := i + 1;

                    ArrEarnings[1, i] := '************************************************';
                    ArrEarningsAmt[1, i] := '***********************************************';

                    i := i + 1;

                    AssignMatrix.Reset;
                    AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                    AssignMatrix.SetRange(Type, AssignMatrix.Type::Deduction);
                    AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                    AssignMatrix.SetRange(AssignMatrix.Paye, true);
                    AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    if AssignMatrix.Find('-') then begin

                        AssignMatrix.CalcFields("Show on Payslip");
                        if AssignMatrix."Show on Payslip" then begin
                            ArrEarnings[1, i] := AssignMatrix.Description;
                            Evaluate(ArrEarningsAmt[1, i], Format(Abs(Round((AssignMatrix.Amount * ExchangeRate), RoundValue))));
                            ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);
                            TotalDeduction := TotalDeduction + Abs((Round((AssignMatrix.Amount * ExchangeRate), RoundValue)));
                        end;
                        //END;
                        //END;
                    end;

                    i := i + 1;


                    AssignMatrix.Reset;
                    AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                    AssignMatrix.SetFilter(Type, '%1|%2', AssignMatrix.Type::Deduction, AssignMatrix.Type::Loan);
                    AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                    AssignMatrix.SetRange(AssignMatrix.Paye, false);
                    AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    AssignMatrix.SetRange(AssignMatrix."Reduces Gross", false);
                    // AssignMatrix.SETRANGE(AssignMatrix.Shares,FALSE);
                    // AssignMatrix.SETRANGE(AssignMatrix."Insurance Code",FALSE);

                    if AssignMatrix.Find('-') then begin
                        repeat
                            AssignMatrix.CalcFields("Show on Payslip");
                            if AssignMatrix."Show on Payslip" then begin
                                Ded.reset;
                                Ded.Setrange(Code, AssignMatrix.Code);
                                Ded.setrange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                                if Ded.findfirst/*.Get(AssignMatrix.Code)*/ then begin
                                    if Ded."Do Not Deduct" = false then begin
                                        //MESSAGE('DEDUCTION %1, Amount=%2',AssignMatrix.Code,AssignMatrix.Amount);
                                        TransAmount := Abs((Round((AssignMatrix.Amount * ExchangeRate), RoundValue)));
                                        ArrEarnings[1, i] := AssignMatrix.Description;
                                        Evaluate(ArrEarningsAmt[1, i], Format(TransAmount/*Abs((Round((AssignMatrix.Amount * ExchangeRate), RoundValue)))*/));
                                        ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);
                                        TotalDeduction := TotalDeduction + TransAmount/*Abs((Round((AssignMatrix.Amount * ExchangeRate), RoundValue)))*/;
                                        if not Ded."Is Statutory" then
                                            TotalNonStatutoryDeductions += TransAmount;

                                        if Deduct.Get(AssignMatrix.Code) then begin
                                            if Deduct."Show Balance" then begin
                                                LoanBalances.Reset;
                                                LoanBalances.SetRange(LoanBalances."Loan No", AssignMatrix."Reference No");
                                                LoanBalances.SetRange(LoanBalances."Deduction Code", AssignMatrix.Code);
                                                if LoanBalances.Find('-') then begin
                                                    LoanBalances.SetRange(LoanBalances."Date filter", 0D, DateSpecified);
                                                    LoanBalances.CalcFields(LoanBalances."Total Repayment");
                                                    PrincipalAmt := LoanBalances."Total Repayment";
                                                    InterestCode := LoanBalances."Interest Deduction Code";
                                                    LoanBalances.SetRange("Deduction Code");
                                                    LoanBalances.SetRange("Deduction Code", InterestCode);
                                                    LoanBalances.CalcFields("Total Repayment");
                                                    // MESSAGE('%1 Loan amount=%2',LoanBalances."Total Repayment",LoanBalances."Approved Amount");
                                                    // BalanceArrs[1,i]:=LoanBalances."Approved Amount"+PrincipalAmt;//+LoanBalances."Interest Repayment"
                                                    // MESSAGE(FORMAT(BalanceArray[1,i]));
                                                end
                                                else begin
                                                    Deduct.SetRange(Deduct."Employee Filter", Employee."No.");
                                                    Deduct.SetRange(Deduct."Pay Period Filter", 0D, DateSpecified);
                                                    Deduct.CalcFields(Deduct."Total Amount");
                                                    TotalAmount := Abs((Round((Deduct."Total Amount" * ExchangeRate), RoundValue)));
                                                    // BalanceArrs[1,i]:=PayrollRounding(TotalAmount);
                                                    // MESSAGE(FORMAT(Balance[1,i]));

                                                end;
                                            end;
                                        end;
                                    end;
                                end;


                                i := i + 1;
                            end;
                        until AssignMatrix.Next = 0;
                    end;


                    if Totalcoopshares > 0 then begin
                        ArrEarnings[1, i] := 'SPORTS/SOCIAL WELFARE';
                        Evaluate(ArrEarningsAmt[1, i], Format(Abs((Round((Totalcoopshares * ExchangeRate), RoundValue)))));
                        ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                        Totalcoopshares := 0;
                        i := i + 1;
                    end;


                    ArrEarnings[1, i] := 'TOTAL STATUTORY DEDUCTIONS';
                    Evaluate(ArrEarningsAmt[1, i], Format(TotalDeduction - TotalNonStatutoryDeductions));
                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                    i := i + 1;



                    ArrEarnings[1, i] := 'TOTAL DEDUCTIONS';
                    Evaluate(ArrEarningsAmt[1, i], Format(TotalDeduction));
                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                    i := i + 1;

                    ArrEarnings[1, i] := '************************************************';
                    ArrEarningsAmt[1, i] := '***********************************************';

                    i := i + 1;
                    // Stat Net Pay
                    ArrEarnings[1, i] := 'NET AFTER STATUTORY DEDUCTIONS';
                    NetPay := GrossPay - (TotalDeduction - TotalNonStatutoryDeductions);//-Employee."Secondment Amount";
                    Evaluate(ArrEarningsAmt[1, i], Format(NetPay));
                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                    i := i + 1;
                    // Net Pay
                    ArrEarnings[1, i] := 'NET PAY';
                    NetPay := GrossPay - TotalDeduction;//-Employee."Secondment Amount";
                    Evaluate(ArrEarningsAmt[1, i], Format(NetPay));
                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);

                    i := i + 1;

                    ArrEarnings[1, i] := '************************************************';
                    ArrEarningsAmt[1, i] := '***********************************************';

                    i := i + 1;
                    //Information
                    ArrEarnings[1, i] := 'Information';



                    i := i + 1;

                    ArrEarnings[1, i] := '************************************************';
                    ArrEarningsAmt[1, i] := '***********************************************';

                    /*i := i + 1;
                    Ded.Reset;
                    //Ded.SetRange(Ded."Tax deductible", true);
                    //Ded.SetRange(Ded."Pay Period Filter", DateSpecified);
                    //Ded.SetRange(Ded."Employee Filter", Employee."No.");
                    //Ded.SetRange(Ded."Show on Payslip Information", true);
                    Ded.SetRange(Ded.Country, SelectedPayrollCountry/*Employee."Payroll Country"//);
                    if Ded.Find('-') then
                        repeat

                            /*Ded.CalcFields(Ded."Total Amount", Ded."Total Amount Employer");
                            ArrEarnings[1, i] := Ded.Description + ' (Employer)';
                            Evaluate(ArrEarningsAmt[1, i], Format(Abs((Round((Ded."Total Amount Employer" * ExchangeRate), RoundValue)))));
                            ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);
                            i := i + 1;//

                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                            AssignMatrix.SetRange(Type, AssignMatrix.Type::Deduction);
                            AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                            AssignMatrix.SetRange(Code, Ded.Code);
                            AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"//);
                            AssignMatrix.SetFilter("Employer Amount", '<>%1', 0);
                            if AssignMatrix.Find('-') then begin
                                repeat
                                    // IF AssignMatrix.Amount<>0 THEN BEGIN
                                    ArrEarnings[1, i] := Ded.Description + ' (Employer)';
                                    AssnAmt := Round(AssignMatrix."Employer Amount" * ExchangeRate, RoundValue);
                                    Evaluate(ArrEarningsAmt[1, i], Format(PayrollRounding(AssnAmt)));
                                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);
                                    i := i + 1;
                                // END;

                                until AssignMatrix.Next = 0;
                            end;

                        until Ded.Next = 0;*/


                    //Show balances - only if an active deduction exists                
                    /*LoanApp.Reset();
                    LoanApp.SetRange(Employee, Employee."No.");
                    LoanApp.SetRange(Country, SelectedPayrollCountry);
                    //LoanApp.SetRange(Code,Ded.Code);
                    LoanApp.SetRange("Start Deducting", true);
                    LoanApp.SetRange(Pause, false);
                    LoanApp.SetRange(Suspend, false);
                    LoanApp.SetRange(Cleared, false);
                    if LoanApp.FindSet() then begin
                        i := i + 1;
                        //Information
                        ArrEarnings[1, i] := 'Active Installment Deductions';
                        i := i + 1;

                        ArrEarnings[1, i] := '************************************************';
                        ArrEarningsAmt[1, i] := '***********************************************';
                        i := i + 1;

                        repeat
                            /*Ded.Reset;
                            Ded.SetRange("Show Balance", true);
                            Ded.SetRange(Ded."Show on Payslip Information", true);
                            Ded.SetRange(Ded.Country, SelectedPayrollCountry/Employee."Payroll Country");
                            if Ded.Find('-') then
                                repeat///
                            AssignMatrix.Reset;
                            AssignMatrix.SetRange("Employee No", Employee."No.");
                            AssignMatrix.SetRange("Payroll Period", DateSpecified);
                            AssignMatrix.SetRange(Type, AssignMatrix.Type::Deduction);
                            AssignMatrix.SetRange(Code, LoanApp.Code);
                            AssignMatrix.SetRange(Country, SelectedPayrollCountry);
                            if AssignMatrix.Find('-') then begin
                                InstallmentAmount := 0;
                                OustandingBalance := 0;
                                LoanApp.CalcFields("Amount Paid", "Interest Repaid to Date");
                                OustandingBalance := LoanApp."Loan Amount" - LoanApp."Amount Paid" - Abs(LoanApp."Interest Repaid to Date") - Abs(LoanApp."Initial Paid Amount");
                                InstallmentAmount := LoanApp."Period Repayments";
                                if (InstallmentAmount > OustandingBalance) and (OustandingBalance <> 0) then
                                    InstallmentAmount := OustandingBalance;
                                if OustandingBalance >= InstallmentAmount then
                                    OustandingBalance := OustandingBalance - InstallmentAmount;

                                if LoanApp."Exchange Rate Type" = LoanApp."Exchange Rate Type"::Current then begin
                                    InstallmentAmount := AssignMatrix.GetInDesiredCurrencyHere(LoanApp."Deduction Currency", SelectedDisplayCurrency, InstallmentAmount, CalcDate('1M', DateSpecified));
                                    OustandingBalance := AssignMatrix.GetInDesiredCurrencyHere(LoanApp."Deduction Currency", SelectedDisplayCurrency, OustandingBalance, CalcDate('1M', DateSpecified));
                                end
                                else begin
                                    InstallmentAmount := AssignMatrix.GetInDesiredCurrencyHere(LoanApp."Deduction Currency", SelectedDisplayCurrency, InstallmentAmount, LoanApp."Loan Date");
                                    OustandingBalance := AssignMatrix.GetInDesiredCurrencyHere(LoanApp."Deduction Currency", SelectedDisplayCurrency, OustandingBalance, LoanApp."Loan Date");
                                end;

                                ArrEarnings[1, i] := LoanApp.Name/* + ' (Installment Amount)'///;
                                Evaluate(ArrEarningsAmt[1, i], Format(Abs((Round(((InstallmentAmount)), RoundValue)))));
                                ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue) + ' (Balance: ' + Format(Abs((Round(((OustandingBalance)), RoundValue)))) + ')';
                                i := i + 1;

                                /*i := i + 1;
                                ArrEarnings[1, i] := LoanApp.Name + ' (Balance)';
                                Evaluate(ArrEarningsAmt[1, i], Format(Abs((Round(((OustandingBalance)), RoundValue)))));
                                ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i],RoundValue);///
                            end;
                        /*else begin
                            Deduct.Reset;
                            Deduct.SetRange(Deduct."Employee Filter", Employee."No.");
                            Deduct.SetRange(Deduct."Pay Period Filter", 0D, DateSpecified);
                            Deduct.SetRange(Code, Ded.Code);
                            Deduct.SetRange(Country, SelectedPayrollCountry/Employee."Payroll Country"/);
                            if Deduct.Find('-') then begin
                                Deduct.CalcFields(Deduct."Total Amount");
                                TotalAmount := Abs(Deduct."Total Amount");
                                ArrEarnings[1, i] := Ded.Description + ' (Balance)';
                                Evaluate(ArrEarningsAmt[1, i], Format(Abs(Round((TotalAmount * ExchangeRate), RoundValue)));
                                ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i],);

                                i := i + 1;
                            end;
                        end;///


                        //until Ded.Next = 0;
                        until LoanApp.Next() = 0;
                    end;*/


                    // Non Cash Benefits
                    Earn.Reset;
                    Earn.SetRange(Earn."Earning Type", Earn."Earning Type"::"Normal Earning");
                    Earn.SetRange(Earn."Non-Cash Benefit", true);
                    Earn.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                    if Earn.Find('-') then begin
                        i := i + 1;
                        repeat
                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(AssignMatrix."Payroll Period", DateSpecified);
                            AssignMatrix.SetRange(Type, AssignMatrix.Type::Payment);
                            AssignMatrix.SetRange(AssignMatrix."Employee No", Employee."No.");
                            AssignMatrix.SetRange(AssignMatrix."Basic Salary Code", false);
                            AssignMatrix.SetRange(Code, Earn.Code);
                            AssignMatrix.SetRange(Country, SelectedPayrollCountry/*Employee."Payroll Country"*/);
                            if AssignMatrix.Find('-') then begin
                                repeat
                                    // IF AssignMatrix.Amount<>0 THEN BEGIN
                                    ArrEarnings[1, i] := AssignMatrix.Description;
                                    AssnAmt := Round(AssignMatrix.Amount * ExchangeRate, RoundValue);
                                    Evaluate(ArrEarningsAmt[1, i], Format(PayrollRounding(AssnAmt)));
                                    ArrEarningsAmt[1, i] := ChckRound(ArrEarningsAmt[1, i], RoundValue);
                                    i := i + 1;
                                // END;

                                until AssignMatrix.Next = 0;
                            end;
                        until Earn.Next = 0;
                    end;

                    // end of non cash


                    ArrEarnings[1, i] := '************************************************';
                    ArrEarningsAmt[1, i] := '***********************************************';





                    /*
                         i:=i+1;
                        ArrEarnings[1,i]:='Employee Details';
                        // Employee details
                         i:=i+1;

                        ArrEarnings[1,i]:='************************************************';
                        ArrEarningsAmt[1,i]:='***********************************************';
                         i:=i+1;

                        ArrEarnings[1,i]:='P.I.N';
                        ArrEarningsAmt[1,i]:=Employee."P.I.N";

                        i:=i+1;
                        EmpBank.RESET;
                        EmpBank.SETRANGE("Bank Code",Employee."Bank Code");
                        IF EmpBank.FIND('-') THEN
                         BankName:=EmpBank."Bank Name";

                        ArrEarnings[1,i]:='Employee Bank';
                        ArrEarningsAmt[1,i]:=BankName;

                        i:=i+1;
                        Branch.RESET;
                        Branch.SETRANGE("Bank Code",Employee."Bank Code");
                        Branch.SETRANGE("Branch Code",Employee."Bank Branch Code");
                        IF Branch.FIND('-') THEN BEGIN
                        ArrEarnings[1,i]:='Bank Branch';
                        ArrEarningsAmt[1,i]:=Branch."Branch Name";
                        END;
                        i:=i+1;
                        ArrEarnings[1,i]:='NSSF No';
                        ArrEarningsAmt[1,i]:=Employee."NSSF No.";
                        i:=i+1;
                        ArrEarnings[1,i]:='NHIF No';
                        ArrEarningsAmt[1,i]:=Employee."NHIF No.";
                        i:=i+1;
                        */
                    i := i + 1;
                    ArrEarnings[1, i] := 'BANK INFORMATION.';
                    i := i + 1;
                    ArrEarnings[1, i] := 'Name: ' + BankName;//Format(Employee."Bank Name");
                                                             /*i := i + 1;
                                                             ArrEarnings[1, i] := 'Branch Name: ' + Format(Employee."Bank Brach Name");*/
                    i := i + 1;
                    ArrEarnings[1, i] := 'Account Number: ' + BankAccountNo;//Format(Employee."Bank Account No");//."Bank Account Number"
                                                                            /*i := i + 1;
                                                                            ArrEarnings[1, i] := 'Retirement Date:' + Format(Employee."Retirement Date");*/
                    i := i + 1;
                    ArrEarnings[1, i] := '*******End of Payslip********';

                    //DAge:=HRDates.DetermineAge(Employee."Date Of Birth",TODAY);
                    //DETERMINE THE REYIREMNET DATE
                    if Employee."Date Of Birth" <> 0D then begin
                        RetirementDate := Employee."Retirement Date";
                        //MESSAGE(FORMAT(RetirementDate));
                    end;

                end;

                trigger OnPostDataItem()
                begin
                    /*if check7 = 7 then begin
                        //MESSAGE('Generation & Mailing Complete...');
                    end;*/
                end;

                trigger OnPreDataItem()
                begin
                    if EmployeeNo <> '' then
                        Employee.SETRANGE("No.", EmployeeNo);
                    /*Employee.SETFILTER("Pay Period Filter", FORMAT(PayrollPeriod, 0, '<Day,2>-<Month,2>-<Year4>'));

                    PayPeriodtext := Employee.GETFILTER("Pay Period Filter");

                    //MESSAGE('PayPeriodtext => '+PayPeriodtext);
                    EVALUATE(PayrollMonth, FORMAT(PayPeriodtext));
                    PayrollMonthText := FORMAT(PayrollMonth, 1, 4);

                    CoRec.GET;
                    CoName := CoRec.Name;
                    //EVALUATE(DateSpecified,FORMAT(PayPeriodtext)); - This evaluation distorts date formats
                    IF DateSpecified = 0D THEN
                        DateSpecified := PayrollPeriod;
                    //ERROR('%1',DateSpecified);
                    CompRec.GET;
                    Message2[1, 1] := CompRec."General Payslip Message";

                    CoRec.CALCFIELDS(Picture, "Water Mark");*/

                    CompRec.GET;
                    Message2[1, 1] := CompRec."General Payslip Message";

                    CoRec.CALCFIELDS(Picture, "Water Mark");

                end;
            }

            trigger OnAfterGetRecord()
            begin
                DateSpecified := PayrollPeriodTable."Starting Date";

                if (not CanEditPaymentInfo) and (DateSpecified = CurrentPeriod) then
                    Error('Payroll for this period is still being processed. Kindly try again later!');
            end;

            trigger OnPreDataItem()
            begin
                /*if DateSpecified <> 0D then
                    PayrollPeriodTable.SetRange("Starting Date",DateSpecified);*/

                /*if MonthStartDate = 0D then begin
                    periodrec.Reset;
                    periodrec.SetFilter(periodrec.Closed, '%1', true); //A closed one because it'll come from portal
                    if periodrec.FindLast then
                        MonthStartDate := CalcDate('1M', periodrec."Starting Date");
                end;
                if MonthStartDate <> 0D then
                    PayrollPeriodTable.SetRange("Starting Date", MonthStartDate);*/
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Month Begin Date"; MonthStartDate)
                {
                    Caption = 'Period';
                    TableRelation = "Payroll Period";
                    Visible = false;
                }
                field(SelectedDisplayCurrency; SelectedDisplayCurrency)
                {
                    Caption = 'Select Display Currency';
                    TableRelation = "Currency".Code;
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
            CurrentPeriod := 0D;
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                CurrentPeriod := Periods."Starting Date";
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        /*periodrec.Reset;
        periodrec.SetFilter(periodrec.Closed, '%1', true);
        if periodrec.FindLast then begin
            MonthStartDate := CalcDate('1M', periodrec."Starting Date");
        end;*/
        /***periodrec.RESET;
        //periodrec.SETFILTER(periodrec.Closed,'%1',TRUE);
        periodrec.SETFILTER(periodrec.Closed, '%1', FALSE);
        IF periodrec.FINDLAST THEN BEGIN
            MonthStartDate := periodrec."Starting Date";
            //MonthStartDate := CalcDate('1M', periodrec."Starting Date");
        END;***/

        CanEditPaymentInfo := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
    end;

    trigger OnPreReport()
    begin
        if MonthStartDate <> 0D then begin
            //=>Employee.SetFilter("Pay Period Filter", '%1', MonthStartDate);

            //=>PayPeriodtext := Employee.GetFilter("Pay Period Filter");

            //=>Evaluate(PayrollMonth, Format(PayPeriodtext));
            //=>PayrollMonthText := Format(PayrollMonth, 1, 4);

            CoRec.Get;
            CoName := CoRec.Name;
            //=>Evaluate(DateSpecified, Format(PayPeriodtext));
        end;
        if MonthStartDate = 0D then begin
            periodrec.Reset;
            periodrec.SetFilter(periodrec.Sendslip, '%1', true);
            if periodrec.FindSet then begin
                MonthStartDate := periodrec."Starting Date";
                check7 := 7;
                if periodrec.Closed = true then begin
                    copy99 := 99;
                end;
            end;
            //=>Employee.SetFilter("Pay Period Filter", '%1', MonthStartDate);

            //=>PayPeriodtext := Employee.GetFilter("Pay Period Filter");

            //=>Evaluate(PayrollMonth, Format(PayPeriodtext));
            //=>PayrollMonthText := Format(PayrollMonth, 1, 4);

            CoRec.Get;
            CoName := CoRec.Name;
            //=>Evaluate(DateSpecified, Format(PayPeriodtext));
        end;
    end;

    var
        UserSetup: Record "User Setup";
        EmployeeNo: Code[20];
        PayrollPeriod: Date;
        DAge: Text;
        Dates: Codeunit "HR Dates";
        Addr: array[10, 100] of Text[250];
        AddrCapt: array[10, 100] of Text;
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        AmountRemaining: Decimal;
        IncomeTax: Decimal;
        PayPeriod: Record "Payroll Period";
        PayPeriodtext: Text[70];
        BeginDate: Date;
        DateSpecified: Date;
        EndDate: Date;
        //EmpBank: Record "KBA Bank Names";
        BankName: Text[250];
        EmpPeriodBankDetails: Record "Employee Period Bank Details";
        BasicSalary: Decimal;
        TaxableAmt: Decimal;
        RightBracket: Boolean;
        NetPay: Decimal;
        PayPeriodRec: Record "Payroll Period";
        PayDeduct: Record "Assignment Matrix";
        EmpRec: Record Employee;
        EmpNo: Code[50];
        TaxableAmount: Decimal;
        PAYE: Decimal;
        ArrEarnings: array[3, 100] of Text[250];
        ArrDeductions: array[3, 100] of Text[250];
        Index: Integer;
        Index1: Integer;
        j: Integer;
        ArrEarningsAmt: array[3, 100] of Text[60];
        ArrDeductionsAmt: array[3, 100] of Decimal;
        Year: Integer;
        EmpArray: array[10, 15] of Decimal;
        HoldDate: Date;
        DenomArray: array[3, 12] of Text[50];
        NoOfUnitsArray: array[3, 12] of Integer;
        AmountArray: array[3, 12] of Decimal;
        PayModeArray: array[3] of Text[30];
        HoursArray: array[3, 60] of Decimal;
        CompRec: Record "Human Resources Setup";
        HseLimit: Decimal;
        ExcessRetirement: Decimal;
        CfMpr: Decimal;
        relief: Decimal;
        TaxCode: Code[10];
        HoursBal: Decimal;
        Pay: Record Earnings;
        Ded: Record Deductions;
        HoursArrayD: array[3, 60] of Decimal;
        BankBranch: Text[30];
        CoName: Text[70];
        retirecontribution: Decimal;
        EarngingCount: Integer;
        DeductionCount: Integer;
        EarnAmount: Decimal;
        GrossTaxCharged: Decimal;
        DimVal: Record "Dimension Value";
        Department: Text[60];
        LowInterestBenefits: Decimal;
        SpacePos: Integer;
        NetPayLength: Integer;
        AmountText: Text[30];
        DecimalText: Text[30];
        DecimalAMT: Decimal;
        InsuranceRelief: Decimal;
        InsuranceReliefText: Text[30];
        IncometaxNew: Decimal;
        NewRelief: Decimal;
        TaxablePayNew: Decimal;
        InsuranceReliefNew: Decimal;
        TaxChargedNew: Decimal;
        finalTax: Decimal;
        TotalBenefits: Decimal;
        RetireCont: Decimal;
        TotalQuarters: Decimal;
        "Employee Payroll": Record Employee;
        PayMode: Text[70];
        Intex: Integer;
        NetPay1: Decimal;
        Principal: Decimal;
        Interest: Decimal;
        Desc: Text[50];
        dedrec: Record Deductions;
        RoundedNetPay: Decimal;
        diff: Decimal;
        CFWD: Decimal;
        Nssfcomptext: Text[70];
        Nssfcomp: Decimal;
        LoanDesc: Text[60];
        LoanDesc1: Text[60];
        Deduct: Record Deductions;
        OriginalLoan: Decimal;
        LoanBalance: Decimal;
        Message1: Text[250];
        Message2: array[3, 1] of Text[250];
        DeptArr: array[3, 1] of Text[60];
        CampArr: array[3, 1] of Text[60];
        BasicPay: array[3, 1] of Text[250];
        InsurEARN: Decimal;
        HasInsurance: Boolean;
        RoundedAmt: Decimal;
        TerminalDues: Decimal;
        Earn: Record Earnings;
        AssignMatrix: Record "Assignment Matrix";
        RoundingDesc: Text[60];
        BasicChecker: Decimal;
        CoRec: Record "Company Information";
        GrossPay: Decimal;
        TotalDeduction: Decimal;
        TotalNonStatutoryDeductions: Decimal;
        TransAmount: Decimal;
        PayrollMonth: Date;
        PayrollMonthText: Text[70];
        PayeeTest: Decimal;
        GroupCode: Code[20];
        CUser: Code[20];
        Totalcoopshares: Decimal;
        LoanBal: Decimal;
        LoanBalances: Record "Loan Application";
        LoanApp: Record "Loans transactions";
        TotalRepayment: Decimal;
        Totalnssf: Decimal;
        Totalpension: Decimal;
        Totalprovid: Decimal;
        BalanceArray: array[3, 100] of Decimal;
        EarningsCaptionLbl: Label 'Earnings';
        Employee_No_CaptionLbl: Label 'Employee No:';
        Name_CaptionLbl: Label 'Name:';
        Dept_CaptionLbl: Label 'Dept:';
        Camp_CaptionLbl: Label 'Campus:';
        AmountCaptionLbl: Label 'Amount';
        Pay_slipCaptionLbl: Label 'Pay Slip';
        EmptyStringCaptionLbl: Label '******************************************************************';
        CurrReport_PAGENOCaptionLbl: Label 'Copy';
        TaxCharged: Decimal;
        LeaveApplication: Record "Employee Leave Application";
        FiscalStart: Date;
        MaturityDate: Date;
        PositivePAYEManual: Decimal;
        TotalToDate: Decimal;
        LoanTopUps: Record "Loan Top-up";
        AccPeriod: Record "Accounting Period";
        MonthStartDate: Date;
        Age_CaptionLbl: Label 'Age';
        LoanTrans: Record "Loans transactions";
        periodrec: Record "Payroll Period";
        check7: Integer;
        copy99: Integer;
        PrincipalAmt: Decimal;
        InterestCode: Code[10];
        Balance: array[10, 100] of Decimal;
        TotalAmount: Decimal;
        BalanceArr: array[10, 100] of Decimal;
        BalanceArrs: array[10, 100] of Decimal;
        HRDates: Codeunit "HR Dates";
        RetirementDate: Date;
        Retirement_Age_Lbl: Label 'Retirement Date';
        PensionBen: Decimal;
        PensionBenER: Decimal;
        PensionAdd: Decimal;
        //Branch: Record "Kenya Bankers Association Code";
        f: Integer;
        Sencondd: Record "Secondment Values";
        DimValue: Record "Dimension Value";
        BankNamex: Code[40];
        BankAccountx: Code[40];
        BankBranchx: Code[40];
        ReliefAmt: Decimal;
        SelectedDisplayCurrency: Code[20];
        CurrExchangeRates: Record "Currency Exchange Rate";
        ExchangeRate: Decimal;
        RoundValue: Decimal;
        AssnAmt: Decimal;
        TransactionCountryCurrency: Code[20];
        EmpTable: Record "Employee";
        SelectedPayrollCountry: Code[100];
        DeductionsThatReduceGross: Decimal;
        InstallmentAmount: Decimal;
        OustandingBalance: Decimal;
        CanEditPaymentInfo: Boolean;
        CurrentPeriod: Date;
        Periods: Record "Payroll Period";


    procedure GetTaxBracket(var TaxableAmount: Decimal)
    var
        TaxTable: Record "Bracket Tables";
        TotalTax: Decimal;
        Tax: Decimal;
        EndTax: Boolean;
    begin
    end;


    procedure GetPayPeriod()
    begin
    end;


    procedure GetTaxBracket1(var TaxableAmount: Decimal)
    var
        TaxTable: Record "Bracket Tables";
        TotalTax: Decimal;
        Tax: Decimal;
        EndTax: Boolean;
    begin
    end;


    procedure CoinageAnalysis(var NetPay: Decimal; var ColNo: Integer)
    var
        Index: Integer;
        Intex: Integer;
    begin
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


    procedure ChckRound(AmtText: Text/*[40]*/; RoundVal: Decimal) ChckRound: Text[30]
    var
        LenthOfText: Integer;
        DecimalPos: Integer;
        AmtWithoutDec: Text[60];
        DecimalAmt: Text[60];
        Decimalstrlen: Integer;
    begin
        LenthOfText := StrLen(AmtText);
        DecimalPos := StrPos(AmtText, '.');
        if DecimalPos = 0 then begin
            AmtWithoutDec := AmtText;
            DecimalAmt := '.00';
        end else begin
            AmtWithoutDec := CopyStr(AmtText, 1, DecimalPos - 1);
            DecimalAmt := CopyStr(AmtText, DecimalPos + 1, 2);
            Decimalstrlen := StrLen(DecimalAmt);
            if Decimalstrlen < 2 then begin
                DecimalAmt := '.' + DecimalAmt + '0';
            end else
                DecimalAmt := '.' + DecimalAmt
        end;
        if RoundVal = 1 then //Don't even show the 0's unless it is in USD which will not have 00
            DecimalAmt := '';
        ChckRound := AmtWithoutDec + DecimalAmt;
    end;

    local procedure FnFindRelief(EmpNo: Code[30]; PayrolPeriod: Date)
    var
        Pays: Record Earnings;
        AssignMatrix: Record "Assignment Matrix";
    begin
        /*Pays.SETFILTER(Pays."Earning Type",'%1',Pays."Earning Type"::"Tax Relief");
        IF Pays.FINDFIRST THEN BEGIN
        ReliefAmt:=Pays."Flat Amount";
        END;*/

        //FRED 23//2/23 - Pick relief from right table so that it can reflect situations of NO RELIEF
        AssignMatrix.Reset;
        AssignMatrix.SetRange("Payroll Period", PayrolPeriod);
        AssignMatrix.SetRange("Employee No", EmpNo);
        AssignMatrix.SetRange("Tax Relief", true);
        if AssignMatrix.FindFirst then
            ReliefAmt := AssignMatrix.Amount;


    end;

    procedure GetPortalPayslipFilters(NewEmployeeNo: Code[20]; NewPayrollPeriod: Date)
    begin
        EmployeeNo := NewEmployeeNo;
        PayrollPeriod := NewPayrollPeriod;
        DateSpecified := NewPayrollPeriod;
        //Add currency filter
    end;

    procedure SetReportFilter(NewEmployeeNo: Code[20]; NewPayrollPeriod: Date; DefaultCurrency: Code[50])
    var
        EmpTableRec: Record Employee;
    begin
        EmployeeNo := NewEmployeeNo;
        PayrollPeriod := NewPayrollPeriod;
        MonthStartDate := NewPayrollPeriod;
        DateSpecified := NewPayrollPeriod;
        SelectedDisplayCurrency := DefaultCurrency;
        if SelectedPayrollCountry = '' then begin
            EmpTableRec.Reset();
            EmpTableRec.SetRange("No.", EmployeeNo);
            if EmpTableRec.FindFirst() then begin
                SelectedPayrollCountry := EmpTableRec."Payroll Country";
                if SelectedDisplayCurrency = '' then
                    SelectedDisplayCurrency := EmpTableRec."Payroll Currency";
            end;
        end;
    end;
}
