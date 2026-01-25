report 51525301 "HR Leave Balances All"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/HRLeaveBalancesAll.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("HR Employee"; Employee)
        {
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';
            RequestFilterFields = "No.";
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(Report_Name; Report_Name)
            {
            }
            column(No_HREmployee; "HR Employee"."No.")
            {
            }
            column(Name; Name)
            {
            }
            column(ReimbursedLeaveDays_HREmployee; "HR Employee"."Reimbursed Leave Days")
            {
            }
            column(AllocatedLeaveDays_HREmployee; "HR Employee"."Allocated Leave Days")
            {
            }
            column(TotalLeaveDays_HREmployee; "HR Employee"."Total (Leave Days)")
            {
            }
            column(TotalLeaveTaken_HREmployee; "HR Employee"."Total Leave Taken")
            {
            }
            column(LeaveBalance_HREmployee; "HR Employee"."Leave Balance")
            {
            }
            column(LeaveCarryForward_HREmployee; "HR Employee".LeaveCarryForward)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfoPostCode; CompanyInfo.Address)
            {
            }
            column(PhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoAddress; CompanyInfo.Address)
            {
            }
            column(MonthlyAccrued_HREmployee; "HR Employee".MonthlyAccrued)
            {
            }
            column(TotalLeavesTaken; TotalLeavesTaken)
            {
            }
            column(CarryForward; CarryForward)
            {
            }
            column(AllocatedLeaveDays; AllocatedLeaveDays)
            {
            }
            column(MonthlyAccrued; MonthlyAccrueds)
            {
            }
            column(Balance; Balance)
            {
            }
            column(TotalLeaves; TotalLeaves)
            {
            }
            column(ReinbursedLeaves; ReinbursedLeaves)
            {
            }
            column(LeavePeriod; LeavePeriod)
            {
            }
            column(LeaveType; LeaveType)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Name);
                Name := "HR Employee"."First Name" + ' ' + "HR Employee"."Middle Name" + ' ' + "HR Employee"."Last Name";

                //"HR Employee".CALCFIELDS(LeaveCarryForward);
                //"HR Employee".VALIDATE("Allocated Leave Days");

                //Monthly accrued days
                if LeaveType = 'ANNUAL' then begin
                    MonthlyAccrueds := 0;
                    Lentriess.Reset;
                    Lentriess.SetRange("Staff No.", "HR Employee"."No.");
                    Lentriess.SetFilter(Lentriess.IsMonthlyAccrued, '%1', true);
                    Lentriess.SetFilter(Lentriess."Leave Period", LeavePeriod);
                    Lentriess.SetFilter(Lentriess."Document No.", 'ACCRUE');
                    if Lentriess.FindSet then begin
                        Lentriess.CalcSums("No. of days");
                        MonthlyAccrueds := Round((Lentriess."No. of days"), 0.1, '=');
                    end;
                end;



                //Carry Forward days
                CarryForward := 0;

                if (LeaveType = 'ANNUAL') or (LeaveType = 'CF') or (LeaveType = '') then begin
                    Lentries.Reset;
                    Lentries.SetRange("Staff No.", "HR Employee"."No.");
                    Lentries.SetFilter(Lentries."Leave Type", 'CF');
                    Lentries.SetFilter(Lentries."Leave Period", LeavePeriod);
                    if Lentries.FindSet then begin
                        Lentries.CalcSums("No. of days");
                        CarryForward := Round((Lentries."No. of days"), 0.5, '=');
                    end;
                end;
                "HR Employee".LeaveCarryForward := CarryForward;


                //Total leave days Taken
                TotalLeavesTaken := 0;
                Lentries.Reset;
                Lentries.SetRange("Staff No.", "HR Employee"."No.");
                Lentries.SetFilter(Lentries."Leave Entry Type", '%1', Lentries."Leave Entry Type"::Negative);
                Lentries.SetFilter(Lentries."Leave Period", LeavePeriod);
                if LeaveType <> '' then begin
                    Lentries.SetFilter(Lentries."Leave Type", LeaveType);
                end;
                Lentries.SetFilter(Lentries.Adjustment, '%1', false);
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    TotalLeavesTaken := -Round((Lentries."No. of days"), 0.05, '=');
                end;

                //Allocated Days
                AllocatedLeaveDays := 0;
                Lentries.Reset;
                Lentries.SetRange("Staff No.", "HR Employee"."No.");
                Lentries.SetFilter(Lentries."Leave Entry Type", '%1', Lentries."Leave Entry Type"::Positive);
                if LeaveType <> '' then begin
                    Lentries.SetFilter(Lentries."Leave Type", LeaveType);
                end;
                Lentries.SetFilter(Lentries."Leave Period", LeavePeriod);
                Lentries.SetFilter(Lentries.Adjustment, '%1', false);
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    AllocatedLeaveDays := Round((Lentries."No. of days"), 0.5, '=');
                end;


                //Reinbursement
                ReinbursedLeaves := 0;
                Lentries.Reset;
                Lentries.SetRange("Staff No.", "HR Employee"."No.");
                Lentries.SetFilter(Lentries."Leave Entry Type", '%1', Lentries."Leave Entry Type"::Reimbursement);
                Lentries.SetFilter(Lentries."Is For Annual Leave", '%1', true);
                Lentries.SetFilter(Lentries."Leave Period", LeavePeriod);
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    ReinbursedLeaves := Round((Lentries."No. of days"), 0.1, '=');
                end;

                //Adjustment
                Adjustments := 0;
                Lentries.Reset;
                Lentries.SetRange("Staff No.", "HR Employee"."No.");
                Lentries.SetFilter(Lentries."Leave Period", LeavePeriod);
                if LeaveType <> '' then begin
                    Lentries.SetFilter(Lentries."Leave Type", LeaveType);
                end;
                Lentries.SetFilter(Lentries.Adjustment, '%1', true);
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    Adjustments := -Round((Lentries."No. of days"), 0.05, '=');
                end;

                TotalLeavesTaken := TotalLeavesTaken + Adjustments;

                TotalLeaves := 0;
                TotalLeaves := AllocatedLeaveDays + CarryForward + ReinbursedLeaves;
                Balance := 0;
                Balance := TotalLeaves - TotalLeavesTaken;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(LeavePeriod)
                {
                    Caption = 'LeavePeriod';
                    field("Leave Period"; LeavePeriod)
                    {
                        ApplicationArea = Suite;
                        ShowMandatory = true;
                        TableRelation = "HR Leave Periods"."Period Code";
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field("Leave Type"; LeaveType)
                    {
                        ApplicationArea = Suite;
                        ShowMandatory = true;
                        TableRelation = "Leave Types".Code WHERE(Code = FILTER(<> 'ANNUAL'));
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
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

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        Report_Name: Label 'Leave Balance';
        CompanyInfo: Record "Company Information";
        Name: Text[80];
        TotalLeavesTaken: Decimal;
        CarryForward: Decimal;
        AllocatedLeaveDays: Decimal;
        MonthlyAccrued: Decimal;
        Balance: Decimal;
        Lentries: Record "HR Leave Ledger Entries";
        TotalLeaves: Decimal;
        ReinbursedLeaves: Decimal;
        LeavePeriod: Code[60];
        Adjustment: Decimal;
        LeaveRec: Record "Employee Leave Application";
        Lentriess: Record "HR Leave Ledger Entries";
        Period: Text[220];
        LeaveType: Code[60];
        MonthlyAccrueds: Decimal;
        Adjustments: Decimal;
}