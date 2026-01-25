report 51525335 "P10 Return Itax"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/P10ReturnItax.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = WHERE(Board = CONST(false), Status = CONST(Active));
            RequestFilterFields = "No.", "Pay Period Filter";
            column(No_Employee; Employee."No.")
            {
            }
            column(Initials_Employee; Employee.Initials)
            {
            }
            column(GlobalDimension2Code_Employee; Employee."Global Dimension 2 Code")
            {
            }
            column(FullName_Employee; Employee."Full Name")
            {
            }
            column(Names; Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name")
            {
            }
            column(JobTitle_Employee; Employee."Job Title")
            {
            }
            column(ContractType_Employee; Employee."Contract Type")
            {
            }
            column(CompName; CompInf.Name)
            {
            }
            column(PIN; Employee."P.I.N")
            {
            }
            column(CompAddress; CompInf.Address)
            {
            }
            column(CompCity; CompInf.City)
            {
            }
            column(CompPicture; CompInf.Picture)
            {
            }
            column(PayrollProcessed; PayrollProcessed)
            {
            }
            column(OtherContributionVer2; OtherContributionVer2)
            {
            }
            dataitem(PayrollTrans; "Assignment Matrix")
            {
                DataItemLink = "Employee No" = FIELD("No."), "Payroll Period" = FIELD("Pay Period Filter");
                DataItemTableView = WHERE("Do Not Deduct" = CONST(false));
                column(Employee_PayrollTrans; PayrollTrans."Employee No")
                {
                }
                column(PayType_PayrollTrans; PayrollTrans.Type)
                {
                }
                column(Code_PayrollTrans; PayrollTrans.Code)
                {
                }
                column(Amount_PayrollTrans; PayrollTrans.Amount)
                {
                }
                column(DateEntered_PayrollTrans; PayrollTrans."Payroll Period")
                {
                }
                column(Period_PayrollTrans; PayrollTrans."Payroll Period")
                {
                }
                column(Description_PayrollTrans; PayrollTrans.Description)
                {
                }
                column(BasicSalaryCode_PayrollTrans; PayrollTrans."Basic Salary Code")
                {
                }
                column(NonCashBenefit_PayrollTrans; PayrollTrans."Non-Cash Benefit")
                {
                }
                column(OtherAllowances; OtherAllowances)
                {
                }
                column(OtherContribution; OtherContribution)
                {
                }
                column(Allowances; Allowances)
                {
                }
                column(GrossAmount; GrossAmount)
                {
                }
                column(BasicPay; BasicPay)
                {
                }
                column(NetPay; NetPay)
                {
                }
                column(Paye_PayrollTrans; PayrollTrans.Paye)
                {
                }
                column(Deductions; Deductions)
                {
                }
                column(IsNHIF; IsNHIF)
                {
                }
                column(IsHELB; IsHELB)
                {
                }
                column(IsNSSF; IsNSSF)
                {
                }
                column(IsOther; IsOther)
                {
                }
                column(Yname; Yname)
                {
                }

                trigger OnAfterGetRecord()
                var
                    gratuity15: Decimal;
                    nssf: Decimal;
                    pension: Decimal;
                begin
                    //PayrollTrans
                    GrossAmount := 0;
                    Allowances := 0;
                    BasicPay := 0;
                    Deductions := 0;
                    NetPay := 0;
                    NonCashAmount := 0;


                    //VoluntaryIns:=0;

                    IsNSSF := false;
                    IsNHIF := false;
                    IsHELB := false;
                    IsOther := false;



                    Yname := Date2DMY(PayrollTrans."Payroll Period", 3);

                    if (PayrollTrans.Type = PayrollTrans.Type::Payment) and
                       (PayrollTrans."Basic Salary Code" = false)
                       and (PayrollTrans."Non-Cash Benefit" = false)
                      then begin
                        Allowances += PayrollTrans.Amount;
                        AllowancesTotal += Allowances;
                    end;

                    if PayrollTrans."Basic Salary Code" = true then begin
                        BasicPay += PayrollTrans.Amount;
                        BasicTotal += BasicTotal;

                    end;

                    if PayrollTrans.Type = PayrollTrans.Type::Deduction then begin
                        Deductions += PayrollTrans.Amount;
                        TotalDeductions += Deductions;
                    end;
                    /*IF PayrollTrans.Code = 'D14' THEN BEGIN
                      VoluntaryIns+=PayrollTrans.Amount;
                     END;*/

                    if (PayrollTrans.Type = PayrollTrans.Type::Payment) and
                     (PayrollTrans."Non-Cash Benefit" = true)
                     then begin
                        NonCashAmount += PayrollTrans.Amount;
                        NonCashAmountTotal += NonCashAmount;
                        //AllowancesTotal+=Allowances;
                    end;

                    //Deductions:=Deductions-VoluntaryIns;

                    GrossAmount := BasicPay + Allowances;
                    GrossTotal := GrossTotal + GrossAmount;
                    NetPay := GrossAmount + (Deductions);

                    //Other Allowances
                    /*IF (PayrollTrans.Type = PayrollTrans.Type::Payment) AND
                       (PayrollTrans."Basic Salary Code" = FALSE)
                       AND (PayrollTrans."Normal Earnings" = TRUE)
                      THEN BEGIN
                    OtherAllowances+=PayrollTrans.Amount;

                    END;*/
                    //  gratuity15:=0;
                    if PayrollTrans.Code = 'E04' then begin
                        gratuity15 := PayrollTrans.Amount;
                        OtherAllowances := gratuity15;
                    end;
                    //MESSAGE(FORMAT(gratuity15));

                    //End Other allowances

                    //NetPay:=NetPay-NonCashAmount;
                    //MESSAGE('GrossAmount %1,Amount %2,Allowances %3,Description %4 BasicPay %5 NonCashAmount %6',GrossAmount,PayrollTrans.Amount,
                    //AllowancesTotal,PayrollTrans.Description,BasicPay,NonCashAmount);

                    if DedZ.Get(PayrollTrans.Code) then begin
                        if DedZ."NHIF Deduction" = true then begin
                            IsNHIF := true;
                        end else
                            if DedZ."NSSF Deduction" = true then begin
                                IsNSSF := true;

                            end else
                                if DedZ."HELB Deduction" = true then begin
                                    IsHELB := true;
                                end else begin
                                    IsOther := true;
                                end;
                    end;
                    nssf := 0;
                    if PayrollTrans.Code = 'D02' then begin
                        nssf := Abs(PayrollTrans.Amount);
                    end;
                    pension := 0;
                    if PayrollTrans.Code = 'D15' then begin
                        pension := Abs(PayrollTrans.Amount);
                    end;
                    OtherContribution := nssf + pension;
                    // IF PayrollTrans.Code='D08'then BEGIN
                    // OtherContribution:=OtherContribution+PayrollTrans.Amount;
                    // END;


                end;

                trigger OnPostDataItem()
                begin
                    //MESSAGE('VOlPension %1 Deductions%2 NetPay%3',VoluntaryIns,Deductions,NetPay);
                    //MESSAGE(' Noncash %1 NoncashTotal%2 Net%3',NonCashAmount,NonCashAmountTotal,NetPay);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Employee.CalcFields(Basic);
                if Employee.Basic > 0 then begin
                    PayrollProcessed := true;
                end else
                    PayrollProcessed := false;

                VoluntaryIns := 0;



                PeriodFilterVer2 := Employee.GetFilter(Employee."Pay Period Filter");

                PensionVer2 := 0;
                NSSFVer2 := 0;
                OtherContributionVer2 := 0;


                ObjAssignmentMatrix.Reset;
                ObjAssignmentMatrix.SetRange(ObjAssignmentMatrix."Employee No", "No.");
                ObjAssignmentMatrix.SetFilter(ObjAssignmentMatrix."Payroll Period", PeriodFilterVer2);
                if ObjAssignmentMatrix.FindSet then begin
                    repeat
                        if ObjAssignmentMatrix.Code = 'D02' then begin
                            PensionVer2 := Abs(ObjAssignmentMatrix.Amount)
                        end else
                            if ObjAssignmentMatrix.Code = 'D15' then begin
                                NSSFVer2 := Abs(ObjAssignmentMatrix.Amount);
                            end;
                    until ObjAssignmentMatrix.Next = 0;

                    OtherContributionVer2 := PensionVer2 + NSSFVer2;
                    //MESSAGE('Employee No %1 Other Contribution Amount %2',"No.",OtherContributionVer2);
                end;
            end;

            trigger OnPreDataItem()
            begin
                AllowancesTotal := 0;
                BasicTotal := 0;
                GrossTotal := 0;
                TotalDeductions := 0;
                NonCashAmountTotal := 0;
                NetAllowance := 0;


                PayrollProcessed := false;
                CompInf.Get();
                CompInf.CalcFields(CompInf.Picture);
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

    var
        CompInf: Record "Company Information";
        Counter: Integer;
        hremployee: Record Employee;
        transactions: Record "Assignment Matrix";
        twotthirds: Decimal;
        totalpay: Decimal;
        totalductions: Decimal;
        transactionsX: Record "Assignment Matrix";
        GrossAmount: Decimal;
        BasicPay: Decimal;
        Allowances: Decimal;
        NetAllowance: Decimal;
        OtherAllowances: Decimal;
        OtherContribution: Decimal;
        Deductions: Decimal;
        NetPay: Decimal;
        transactionsXX: Record "Assignment Matrix";
        transactionsXXX: Record "Assignment Matrix";
        Payes: Decimal;
        ThirdBasic: Decimal;
        Periods: Record "Payroll Period";
        Yname: Integer;
        BankName: Text[250];
        BankAccountNo: Code[60];
        Payroll: Record Employee;
        //Bank: Record "KBA Bank Names";
        Branch: Text[100];
        InsuranceRelief: Decimal;
        TaxRelief: Decimal;
        InsuranceTotal: Decimal;
        PayeTotal: Decimal;
        TaxTotal: Decimal;
        GrossTotal: Decimal;
        BasicPays: Decimal;
        Payrolls: Record Employee;
        transactionsT: Record "Assignment Matrix";
        BasicTotal: Decimal;
        AllowancesTotal: Decimal;
        TotalRelief: Decimal;
        EmpName: Text[120];
        Serial: Integer;
        TotalGross: Decimal;
        transactionsTT: Record "Assignment Matrix";
        TotalDeductions: Decimal;
        transactionsXXXX: Record "Assignment Matrix";
        GrossDeductions: Decimal;
        transactionsXXXXX: Record "Assignment Matrix";
        IsNHIF: Boolean;
        IsNSSF: Boolean;
        IsHELB: Boolean;
        DedZ: Record Deductions;
        Earnings: Record Earnings;
        IsOther: Boolean;
        PayrollProcessed: Boolean;
        VoluntaryIns: Decimal;
        NonCashAmount: Decimal;
        NonCashAmountTotal: Decimal;
        OtherContributionVer2: Decimal;
        PensionVer2: Decimal;
        NSSFVer2: Decimal;
        ObjAssignmentMatrix: Record "Assignment Matrix";
        PeriodFilterVer2: Text;
}