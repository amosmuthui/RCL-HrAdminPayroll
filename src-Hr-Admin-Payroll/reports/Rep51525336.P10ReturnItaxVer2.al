report 51525336 "P10 Return Itax Ver2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/P10ReturnItaxVer2.rdlc';

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
            column(PIN; Employee."PIN Number")
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
            column(Paye_PayrollTrans; PayrollTransPaye)
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
            column(EmployeeBasicSalary; EmployeeBasicSalary)
            {
            }
            column(TaxReliefVer2; TaxReliefVer2)
            {
            }
            column(InsuranceReliefVer2; InsuranceReliefVer2)
            {
            }
            column(PayeVer2; PayeVer2)
            {
            }
            column(OtherAllowancesVer2; OtherAllowancesVer2)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.CalcFields("Total Earnings Calc");
                if Employee."Total Earnings Calc" > 0 then begin
                    PayrollProcessed := true;
                end else
                    PayrollProcessed := false;

                VoluntaryIns := 0;



                PeriodFilterVer2 := Employee.GetFilter(Employee."Pay Period Filter");

                PensionVer2 := 0;
                NSSFVer2 := 0;
                OtherContributionVer2 := 0;
                GrossAmount := 0;
                Allowances := 0;
                BasicPay := 0;
                Deductions := 0;
                NetPay := 0;
                NonCashAmount := 0;
                IsNSSF := false;
                IsNHIF := false;
                IsHELB := false;
                IsOther := false;
                PayrollTransPaye := false;
                EmployeeBasicSalary := 0;
                TaxReliefVer2 := 0;
                InsuranceReliefVer2 := 0;
                PayeVer2 := 0;
                OtherAllowancesVer2 := 0;


                ObjAssignmentMatrix.Reset;
                ObjAssignmentMatrix.SetRange(ObjAssignmentMatrix."Employee No", "No.");
                ObjAssignmentMatrix.SetFilter(ObjAssignmentMatrix."Payroll Period", PeriodFilterVer2);
                ObjAssignmentMatrix.SetRange(ObjAssignmentMatrix."Do Not Deduct", false);
                if ObjAssignmentMatrix.FindSet then begin

                    repeat
                        PayrollTransPaye := ObjAssignmentMatrix.Paye;

                        Yname := Date2DMY(ObjAssignmentMatrix."Payroll Period", 3);

                        if (ObjAssignmentMatrix.Type = ObjAssignmentMatrix.Type::Payment) and (ObjAssignmentMatrix."Basic Salary Code" = false) and (ObjAssignmentMatrix."Non-Cash Benefit" = false) then begin
                            Allowances += ObjAssignmentMatrix.Amount;
                            AllowancesTotal += Allowances;
                        end;

                        if ObjAssignmentMatrix."Basic Salary Code" = true then begin
                            BasicPay += ObjAssignmentMatrix.Amount;
                            BasicTotal += BasicTotal;
                        end;

                        if ObjAssignmentMatrix."Basic Salary Code" = true then
                            EmployeeBasicSalary := ObjAssignmentMatrix.Amount;

                        if ObjAssignmentMatrix.Code = 'E02' then
                            TaxReliefVer2 := ObjAssignmentMatrix.Amount;

                        if ObjAssignmentMatrix.Code = 'E03' then
                            InsuranceReliefVer2 := ObjAssignmentMatrix.Amount;

                        if ObjAssignmentMatrix.Paye = true then
                            PayeVer2 := Abs(ObjAssignmentMatrix.Amount);

                        if ObjAssignmentMatrix.Type = ObjAssignmentMatrix.Type::Deduction then begin
                            Deductions += ObjAssignmentMatrix.Amount;
                            TotalDeductions += Deductions;
                        end;

                        if (ObjAssignmentMatrix.Type = ObjAssignmentMatrix.Type::Payment) and (ObjAssignmentMatrix."Non-Cash Benefit" = true) then begin
                            NonCashAmount += ObjAssignmentMatrix.Amount;
                            NonCashAmountTotal += NonCashAmount;
                        end;

                        GrossAmount := BasicPay + Allowances;
                        GrossTotal := GrossTotal + GrossAmount;
                        NetPay := GrossAmount + (Deductions);

                        /*IF ObjAssignmentMatrix.Code = 'E04' THEN BEGIN
                            gratuity15:=ObjAssignmentMatrix.Amount;
                            OtherAllowances:=gratuity15;
                            OtherAllowancesVer2:=ObjAssignmentMatrix.Amount;
                          END;*/

                        ObjAssignmentMatrix2.Reset;
                        ObjAssignmentMatrix2.SetRange(ObjAssignmentMatrix2."Employee No", "No.");
                        ObjAssignmentMatrix2.SetFilter(ObjAssignmentMatrix2."Payroll Period", PeriodFilterVer2);
                        ObjAssignmentMatrix2.SetRange(ObjAssignmentMatrix2."Do Not Deduct", false);
                        ObjAssignmentMatrix2.SetRange(ObjAssignmentMatrix2.Type, ObjAssignmentMatrix2.Type::Payment);
                        ObjAssignmentMatrix2.SetRange(ObjAssignmentMatrix2."Non-Cash Benefit", false);
                        ObjAssignmentMatrix2.SetFilter(ObjAssignmentMatrix2.Code, '<>%1', 'E01');
                        if ObjAssignmentMatrix2.FindSet then begin
                            ObjAssignmentMatrix2.CalcSums(ObjAssignmentMatrix2.Amount);
                            OtherAllowancesVer2 := Abs(ObjAssignmentMatrix2.Amount);
                        end;

                        if DedZ.Get(ObjAssignmentMatrix.Code) then begin
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

                        NSSF := 0;
                        if ObjAssignmentMatrix.Code = 'D02' then begin
                            NSSF := Abs(ObjAssignmentMatrix.Amount);
                        end;
                        pension := 0;
                        if ObjAssignmentMatrix.Code = 'D15' then begin
                            pension := Abs(ObjAssignmentMatrix.Amount);
                        end;
                        OtherContribution := NSSF + pension;


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
        gratuity15: Decimal;
        nssf: Decimal;
        pension: Decimal;
        PayrollTransPaye: Boolean;
        EmployeeBasicSalary: Decimal;
        TaxReliefVer2: Decimal;
        InsuranceReliefVer2: Decimal;
        PayeVer2: Decimal;
        OtherAllowancesVer2: Decimal;
        ObjAssignmentMatrix2: Record "Assignment Matrix";
}