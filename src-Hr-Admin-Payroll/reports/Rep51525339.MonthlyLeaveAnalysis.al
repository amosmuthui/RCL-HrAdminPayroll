report 51525339 "Monthly Leave Analysis"
{
    ApplicationArea = All;
    Caption = 'Monthly Leave Analysis';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/MonthlyLeaveAnalysis.rdlc';
    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Responsibility Center";
            column(CompName; CompInfo.Name)
            {
            }
            column(CompPict; CompInfo.Picture)
            {
            }
            column(No; "No.")
            {
            }
            column(FirstName; "First Name")
            {
            }
            column(MiddleName; "Middle Name")
            {
            }
            column(LastName; "Last Name")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; /*"Global Dimension 2 Code"*/ "Responsibility Center")
            {
            }
            column(SelectedLeavePeriod; SelectedLeavePeriod)
            { }
            column(Filters; Filters)
            { }

            trigger OnAfterGetRecord()
            var
                Done: Boolean;
                CurrStartDate: Date;
                CurrEndDate: Date;
                ColumnNo: Integer;
                HrLeaveLedgerEntries: Record "HR Leave Ledger Entries";
                Val: Decimal;
                Dept: Code[240];
                MonthlyLeaveEntitlement: Decimal;
                EmpName: Text;
                BalanceBf: Decimal;
                OpeningBal: Decimal;
                AccruedDays: Decimal;
                DaysTaken: Decimal;
                Adjustments: Decimal;
                ClosingBalance: Decimal;
                HasSomeValue: Boolean;
            begin
                HasSomeValue := false;
                EmpName := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
                EntryNo := 0;
                ColumnNo := 0;
                BalanceBf := 0;
                TempLeaveAnalysis.Reset();
                if TempLeaveAnalysis.FindLast() then
                    EntryNo := TempLeaveAnalysis."Entry No.";
                Dept := "Responsibility Center";
                MonthlyLeaveEntitlement := 0;
                if "Annual Leave Entitlement" <> 0 then
                    MonthlyLeaveEntitlement := "Annual Leave Entitlement" / 12;


                //Entitlement
                /*ColumnNo += 1;
                EntryNo += 1;
                TempLeaveAnalysisInit.Init();
                TempLeaveAnalysisInit.UniqueRunTimeID := UniqueID;
                TempLeaveAnalysisInit."Entry No." := EntryNo;
                TempLeaveAnalysisInit."Emp No." := "No.";
                TempLeaveAnalysisInit."Emp Name" := EmpName;
                TempLeaveAnalysisInit.Department := Dept;
                TempLeaveAnalysisInit."Column No." := ColumnNo;
                TempLeaveAnalysisInit."Column Title" := 'Monthly Leave Entitlement';
                TempLeaveAnalysisInit."Monthly Entitlement" := MonthlyLeaveEntitlement;
                TempLeaveAnalysisInit."Balance b/f" := BalanceBf;
                TempLeaveAnalysisInit.Value := Format(MonthlyLeaveEntitlement);
                TempLeaveAnalysisInit.Insert();*/

                //Balance B/F
                Val := 0;
                HrLeaveLedgerEntries.Reset();
                HrLeaveLedgerEntries.SetRange("Staff No.", "No.");
                HrLeaveLedgerEntries.SetRange("Leave Period", SelectedLeavePeriod);
                HrLeaveLedgerEntries.SetFilter("Leave Type", '%1|%2', 'CF', 'CARRY FORWARD');
                HrLeaveLedgerEntries.SetFilter("Posting Date", '<=%1', LeavePeriodStartDate);
                if HrLeaveLedgerEntries.Find('-') then begin
                    HrLeaveLedgerEntries.CalcSums("No. of days");
                    BalanceBf := HrLeaveLedgerEntries."No. of days";
                end;
                //Val := BalanceBf;
                ColumnNo += 1;
                EntryNo += 1;
                TempLeaveAnalysisInit.Init();
                TempLeaveAnalysisInit.UniqueRunTimeID := UniqueID;
                TempLeaveAnalysisInit."Entry No." := EntryNo;
                TempLeaveAnalysisInit."Emp No." := "No.";
                TempLeaveAnalysisInit."Emp Name" := EmpName;
                TempLeaveAnalysisInit.Department := Dept;
                TempLeaveAnalysisInit."Column No." := ColumnNo;
                TempLeaveAnalysisInit."Column Title" := '';//'Balance B/F';
                TempLeaveAnalysisInit."Monthly Entitlement" := MonthlyLeaveEntitlement;
                TempLeaveAnalysisInit."Balance b/f" := Round(BalanceBf, 0.01);
                TempLeaveAnalysisInit.Value := Format(Round(BalanceBf, 0.01));
                TempLeaveAnalysisInit.Insert();

                //Now start looping though the months
                Done := false;
                CurrStartDate := LeavePeriodStartDate;
                CurrEndDate := CalcDate('CM', CurrStartDate);
                OpeningBal := BalanceBf;

                while not Done do begin
                    AccruedDays := 0;
                    DaysTaken := 0;
                    Adjustments := 0;
                    ClosingBalance := 0;
                    HrLeaveLedgerEntries.Reset();
                    HrLeaveLedgerEntries.SetRange("Staff No.", "No.");
                    HrLeaveLedgerEntries.SetRange("Leave Period", SelectedLeavePeriod);
                    HrLeaveLedgerEntries.SetFilter("Leave Type", '%1|%2|%3', 'CF', 'CARRY FORWARD', 'ANNUAL');
                    HrLeaveLedgerEntries.SetRange("Posting Date", CurrStartDate, CurrEndDate);
                    if HrLeaveLedgerEntries.Find('-') then
                        repeat
                            if HrLeaveLedgerEntries."Document No." = 'ACCRUE' then
                                AccruedDays += HrLeaveLedgerEntries."No. of days"
                            else begin
                                if (HrLeaveLedgerEntries."Leave Entry Type" = HrLeaveLedgerEntries."Leave Entry Type"::Negative) and (not HrLeaveLedgerEntries.Adjustment) then
                                    DaysTaken += HrLeaveLedgerEntries."No. of days"
                                else
                                    Adjustments += HrLeaveLedgerEntries."No. of days";
                            end;
                        until HrLeaveLedgerEntries.Next() = 0;
                    ClosingBalance := OpeningBal + AccruedDays - Abs(DaysTaken) + Adjustments;

                    //Opening Balance
                    ColumnNo += 1;
                    EntryNo += 1;
                    Val := OpeningBal;
                    TempLeaveAnalysisInit.Init();
                    TempLeaveAnalysisInit.UniqueRunTimeID := UniqueID;
                    TempLeaveAnalysisInit."Entry No." := EntryNo;
                    TempLeaveAnalysisInit."Emp No." := "No.";
                    TempLeaveAnalysisInit."Emp Name" := EmpName;
                    TempLeaveAnalysisInit.Department := Dept;
                    TempLeaveAnalysisInit."Column No." := ColumnNo;
                    TempLeaveAnalysisInit."Column Title" := Format(CurrStartDate, 0, '<Month Text,3> <Year4>') + ' Opening Balance';
                    TempLeaveAnalysisInit."Monthly Entitlement" := MonthlyLeaveEntitlement;
                    TempLeaveAnalysisInit."Balance b/f" := Round(BalanceBf, 0.01);
                    TempLeaveAnalysisInit.Value := Format(Round(OpeningBal, 0.01));
                    TempLeaveAnalysisInit.Insert();


                    //Accrued
                    ColumnNo += 1;
                    EntryNo += 1;
                    Val := 0;
                    TempLeaveAnalysisInit.Init();
                    TempLeaveAnalysisInit.UniqueRunTimeID := UniqueID;
                    TempLeaveAnalysisInit."Entry No." := EntryNo;
                    TempLeaveAnalysisInit."Emp No." := "No.";
                    TempLeaveAnalysisInit."Emp Name" := EmpName;
                    TempLeaveAnalysisInit.Department := Dept;
                    TempLeaveAnalysisInit."Column No." := ColumnNo;
                    TempLeaveAnalysisInit."Column Title" := Format(CurrStartDate, 0, '<Month Text,3> <Year4>') + ' Accrued Days';
                    TempLeaveAnalysisInit."Monthly Entitlement" := MonthlyLeaveEntitlement;
                    TempLeaveAnalysisInit."Balance b/f" := Round(BalanceBf, 0.01);
                    TempLeaveAnalysisInit.Value := Format(Round(AccruedDays, 0.01));
                    TempLeaveAnalysisInit.Insert();

                    //Days Taken
                    ColumnNo += 1;
                    EntryNo += 1;
                    Val := 0;
                    TempLeaveAnalysisInit.Init();
                    TempLeaveAnalysisInit.UniqueRunTimeID := UniqueID;
                    TempLeaveAnalysisInit."Entry No." := EntryNo;
                    TempLeaveAnalysisInit."Emp No." := "No.";
                    TempLeaveAnalysisInit."Emp Name" := EmpName;
                    TempLeaveAnalysisInit.Department := Dept;
                    TempLeaveAnalysisInit."Column No." := ColumnNo;
                    TempLeaveAnalysisInit."Column Title" := Format(CurrStartDate, 0, '<Month Text,3> <Year4>') + ' Days Taken';
                    TempLeaveAnalysisInit."Monthly Entitlement" := MonthlyLeaveEntitlement;
                    TempLeaveAnalysisInit."Balance b/f" := Round(BalanceBf, 0.01);
                    TempLeaveAnalysisInit.Value := Format(Round(Abs(DaysTaken), 0.01));
                    TempLeaveAnalysisInit.Insert();


                    //Adjustments
                    ColumnNo += 1;
                    EntryNo += 1;
                    Val := 0;
                    TempLeaveAnalysisInit.Init();
                    TempLeaveAnalysisInit.UniqueRunTimeID := UniqueID;
                    TempLeaveAnalysisInit."Entry No." := EntryNo;
                    TempLeaveAnalysisInit."Emp No." := "No.";
                    TempLeaveAnalysisInit."Emp Name" := EmpName;
                    TempLeaveAnalysisInit.Department := Dept;
                    TempLeaveAnalysisInit."Column No." := ColumnNo;
                    TempLeaveAnalysisInit."Column Title" := Format(CurrStartDate, 0, '<Month Text,3> <Year4>') + ' Adjustments';
                    TempLeaveAnalysisInit."Monthly Entitlement" := MonthlyLeaveEntitlement;
                    TempLeaveAnalysisInit."Balance b/f" := Round(BalanceBf, 0.01);
                    TempLeaveAnalysisInit.Value := Format(Round(Adjustments, 0.01));
                    TempLeaveAnalysisInit.Insert();

                    //Closing Balance
                    ColumnNo += 1;
                    EntryNo += 1;
                    Val := 0;
                    TempLeaveAnalysisInit.Init();
                    TempLeaveAnalysisInit.UniqueRunTimeID := UniqueID;
                    TempLeaveAnalysisInit."Entry No." := EntryNo;
                    TempLeaveAnalysisInit."Emp No." := "No.";
                    TempLeaveAnalysisInit."Emp Name" := EmpName;
                    TempLeaveAnalysisInit.Department := Dept;
                    TempLeaveAnalysisInit."Column No." := ColumnNo;
                    TempLeaveAnalysisInit."Column Title" := Format(CurrStartDate, 0, '<Month Text,3> <Year4>') + ' Closing Balance';
                    TempLeaveAnalysisInit."Monthly Entitlement" := MonthlyLeaveEntitlement;
                    TempLeaveAnalysisInit."Balance b/f" := Round(BalanceBf, 0.01);
                    TempLeaveAnalysisInit.Value := Format(Round(ClosingBalance, 0.01));
                    TempLeaveAnalysisInit.Insert();

                    OpeningBal := ClosingBalance; //Then closing balance becomes next month's opening balance
                    if (not HasSomeValue) and ((OpeningBal <> 0) or (AccruedDays <> 0) or (DaysTaken <> 0) or (Adjustments <> 0)) then
                        HasSomeValue := true;

                    if CurrEndDate = LeavePeriodEndDate then
                        Done := true
                    else begin
                        CurrStartDate := CalcDate('1D', CurrEndDate); //Next day
                        CurrEndDate := CalcDate('CM', CurrStartDate);
                        if CurrEndDate > LeavePeriodEndDate then
                            CurrEndDate := LeavePeriodEndDate;
                    end;
                end;
                ProcessedEmployeesCount += 1;
                Window.Update(1, Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name");
                Window.UPDATE(2, Format(ROUND(ProcessedEmployeesCount / AllEmployeesCount * 100, 1)) + '%');

                if not HasSomeValue then begin
                    TempLeaveAnalysis.Reset();
                    TempLeaveAnalysis.SetRange(UniqueRunTimeID, UniqueID);
                    TempLeaveAnalysis.SetRange("Emp No.", "No.");
                    if TempLeaveAnalysis.Find('-') then
                        TempLeaveAnalysis.DeleteAll();

                    CurrReport.Skip();
                end;
            end;

            trigger OnPreDataItem()
            begin
                Filters := '';
                if SelectedLeavePeriod = '' then
                    Error('You must select a leave period!');
                if Employee.GetFilters <> '' then
                    Filters := 'Period: ' + SelectedLeavePeriod + ', ' + Employee.GetFilters
                else
                    Filters := 'Period: ' + SelectedLeavePeriod;
                LeavePeriodStartDate := 0D;
                LeavePeriodEndDate := 0D;

                Window.OPEN('Analyzing Leave For ##############################1 \ Progress: #2###', EmployeeName, PercentProcessed);

                AllEmployeesCount := Employee.count;
                ProcessedEmployeesCount := 0;

                LeavePeriods.Reset();
                LeavePeriods.SetRange("Period Code", SelectedLeavePeriod);
                if LeavePeriods.FindFirst() then begin
                    if LeavePeriods."Starting Date" = 0D then
                        Error('You must define the start date for leave period %1', LeavePeriods."Period Code");
                    if LeavePeriods."End Date" = 0D then
                        Error('You must define end date for leave period %1', LeavePeriods."Period Code");
                    LeavePeriodStartDate := LeavePeriods."Starting Date";
                    LeavePeriodEndDate := LeavePeriods."End Date";
                end
            end;
        }

        //Load the lines now
        dataitem("Temp Leave Analysis Tbl"; "Temp Leave Analysis Tbl")
        {
            column(Entry_No_; "Entry No.")
            { }
            column(Emp_No_; "Emp No.") { }
            column(Emp_Name; "Emp Name") { }
            column(Department; Department) { }
            column(Column_No_; "Column No.")
            { }
            column(Column_Title; "Column Title") { }
            column(Value; Value)
            { }
            column(Balance_b_f; "Balance b/f")
            { }
            column(Monthly_Entitlement; "Monthly Entitlement") { }

            trigger OnPreDataItem()
            begin
                "Temp Leave Analysis Tbl".SetRange(UniqueRunTimeID, UniqueID);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                field("Leave Period"; SelectedLeavePeriod)
                {
                    TableRelation = "HR Leave Periods"."Period Code";
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    trigger OnInitReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture);
        UniqueID := UserId() + Format(CurrentDateTime);

        SelectedLeavePeriod := '';
        LeavePeriods.Reset();
        LeavePeriods.SetRange(Closed, false);
        if LeavePeriods.FindFirst() then
            SelectedLeavePeriod := LeavePeriods."Period Code";
    end;

    trigger OnPostReport()
    begin
        TempLeaveAnalysis.Reset();
        TempLeaveAnalysis.SetRange(UniqueRunTimeID, UniqueID);
        if TempLeaveAnalysis.Find('-') then
            TempLeaveAnalysis.DeleteAll();
    end;

    var
        CompInfo: Record "Company Information";
        TempLeaveAnalysis: Record "Temp Leave Analysis Tbl";
        TempLeaveAnalysisInit: Record "Temp Leave Analysis Tbl";
        EntryNo: Integer;
        SelectedLeavePeriod: Code[50];
        LeavePeriods: Record "HR Leave Periods";
        LeavePeriodStartDate: Date;
        LeavePeriodEndDate: Date;
        UniqueID: Code[240];
        Filters: Text;
        AllEmployeesCount: Integer;
        ProcessedEmployeesCount: Integer;
        Window: Dialog;
        EmployeeName: Text;
        PercentProcessed: Decimal;
}