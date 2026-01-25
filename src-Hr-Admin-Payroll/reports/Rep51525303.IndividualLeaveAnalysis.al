report 51525303 "Individual Leave Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/IndividualLeaveAnalysis.rdlc';

    dataset
    {
        dataitem("HR Employee"; Employee)
        {
            RequestFilterFields = "No.";//, Field2038;
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; "HR Employee"."User ID")
            {
            }
            column(CI_Picture; CI.Picture)
            {
            }
            column(CI_City; CI.City)
            {
            }
            column(CI__Address_2______CI__Post_Code_; CI."Address 2" + ' ' + CI."Post Code")
            {
            }
            column(CI_Address; CI.Address)
            {
            }
            column(HR_Employees__No__; "No.")
            {
            }
            column(HR_Employees__FullName; "HR Employee"."First Name" + ' ' + "HR Employee"."Middle Name")
            {
            }
            column(HR_Employees__HR_Employees___Leave_Balance_; "HR Employee"."Leave Balance")
            {
            }
            column(EmployeeCaption; EmployeeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Leave_StatementCaption; Employee_Leave_StatementCaptionLbl)
            {
            }
            column(P_O__BoxCaption; P_O__BoxCaptionLbl)
            {
            }
            column(HR_Employees__No__Caption; FieldCaption("No."))
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Leave_BalanceCaption; Leave_BalanceCaptionLbl)
            {
            }
            column(Day_s_Caption; Day_s_CaptionLbl)
            {
            }
            column(No; No)
            {
            }
            column(Employee_No; "HR Employee"."No.")
            {
            }
            column(Name; Name)
            {
            }
            dataitem("HR Leave Ledger Entries"; "HR Leave Ledger Entries")
            {
                DataItemLink = "Staff No." = FIELD("No.");
                DataItemTableView = SORTING("Entry No.") WHERE(Closed = CONST(false));
                RequestFilterFields = "Leave Type";
                column(HR_Leave_Ledger_Entries__Leave_Period_; "Leave Period")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Entry_Type_; "Leave Entry Type")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Type_; "Leave Type")
                {
                }
                column(HR_Leave_Ledger_Entries__No__of_days_; "No. of days")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Posting_Description_; "Leave Posting Description")
                {
                }
                column(HR_Leave_Ledger_Entries__Posting_Date_; "Posting Date")
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Entry_Type_Caption; FieldCaption("Leave Entry Type"))
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Type_Caption; FieldCaption("Leave Type"))
                {
                }
                column(HR_Leave_Ledger_Entries__No__of_days_Caption; FieldCaption("No. of days"))
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Posting_Description_Caption; FieldCaption("Leave Posting Description"))
                {
                }
                column(HR_Leave_Ledger_Entries__Posting_Date_Caption; FieldCaption("Posting Date"))
                {
                }
                column(HR_Leave_Ledger_Entries__Leave_Period_Caption; FieldCaption("Leave Period"))
                {
                }
                column(HR_Leave_Ledger_Entries_Entry_No_; "Entry No.")
                {
                }
                column(HR_Leave_Ledger_Entries_Staff_No_; "Staff No.")
                {
                }
                column(IsMonthlyAccrued_HRLeaveLedgerEntries; "HR Leave Ledger Entries".IsMonthlyAccrued)
                {
                }
                column(LPeriod; LPeriod)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    No := No + 1;

                    LPeriod := '';
                    LeaveRec.Reset;
                    LeaveRec.SetRange(LeaveRec."Application No", "HR Leave Ledger Entries"."Document No.");
                    if LeaveRec.FindFirst then begin
                        LPeriod := Format(LeaveRec."Start Date") + '-' + Format(LeaveRec."Resumption Date");
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Name);

                Name := "HR Employee"."First Name" + ' ' + "HR Employee"."Middle Name" + ' ' + "HR Employee"."Last Name";
            end;

            trigger OnPreDataItem()
            var
                FilteredBy: Code[50];
                NewFilter: Code[50];
            begin

                FilteredBy := "HR Employee".GetFilter("No.");

                NewFilter := "HR Employee".GetFilter("No.");

                //IF FilteredBy <> NewFilter THEN
                // MESSAGE('You are currently not set to View Payroll and can only view your Payslip!');
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

    trigger OnPreReport()
    begin
        CI.Get();
        CI.CalcFields(CI.Picture);
        if UserId <> 'ADMINISTRATOR' then begin
            FnGetUserID(UserId);
            if HrUser = false then begin
                //IF "HR Employee".GETFILTER("No.")='' THEN ERROR('Please select your Employee no');
                hremp.Reset;
                hremp.SetRange("No.", "HR Employee".GetFilter("No."));
                hremp.SetRange("User ID", UserId);
                //IF NOT hremp.FIND('-') THEN ERROR('You are not allowed to view other Employees information');
            end;
        end;
    end;

    var
        CI: Record "Company Information";
        LeaveBalance: Decimal;
        EmployeeCaptionLbl: Label 'Employee';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Employee_Leave_StatementCaptionLbl: Label 'Employee Leave Statement';
        P_O__BoxCaptionLbl: Label 'P.O. Box';
        NameCaptionLbl: Label 'Name';
        Leave_BalanceCaptionLbl: Label 'Leave Balance';
        Day_s_CaptionLbl: Label 'Day(s)';
        No: Decimal;
        Name: Text[100];
        hremp: Record Employee;
        Hemp: Record Employee;
        HrUser: Boolean;
        LeaveRec: Record "Employee Leave Application";
        LPeriod: Text[220];
        UserSetup: Record "User Setup";

    local procedure FnGetUserID(UserID: Code[40])
    begin
        HrUser := false;
        Hemp.Reset;
        Hemp.SetRange(Hemp."User ID", UserID);
        Hemp.SetFilter(Hemp."Global Dimension 2 Code", 'HR');
        if Hemp.FindFirst then begin
            HrUser := true
        end else begin
            HrUser := false;
        end;
    end;
}