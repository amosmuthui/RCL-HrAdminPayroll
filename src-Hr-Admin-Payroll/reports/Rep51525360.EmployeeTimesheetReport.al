report 51525360 "Employee Timesheet Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/EmployeeTimesheetReport.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Employee Timesheet Lines"; "Employee Timesheet Lines")
        {
            RequestFilterFields = "Employee No.";
            column(CompPic; CompInfo.Picture)
            {
            }
            column(TSNo; "Employee Timesheet Lines"."TS  No")
            {
            }
            column(EmployeeNo; "Employee Timesheet Lines"."Employee No.")
            {
            }
            column(LineNo; "Employee Timesheet Lines"."Line No.")
            {
            }
            column(EmployeeName; EmpSearchName)
            {
            }
            column(JobTitle; "Employee Timesheet Lines"."Job Title")
            {
            }
            column(Month; "Employee Timesheet Lines".Month)
            {
            }
            column(Year; "Employee Timesheet Lines".Year)
            {
            }
            column(ListofKeyTasksUndertaken; "Employee Timesheet Lines"."List of Key Tasks Undertaken")
            {
            }
            column(DateSubmittedtoSupervisor_EmployeeTimesheetLines; "Employee Timesheet Lines"."Date Submitted to Supervisor")
            {
            }
            column(DateApproved_EmployeeTimesheetLines; "Employee Timesheet Lines"."Date Approved")
            {
            }
            column(TotalDaysWorked; "Employee Timesheet Lines"."Total Days Worked")
            {
            }
            column(Project; "Employee Timesheet Lines"."Global Dimension 2 Code")
            {
            }
            column(IntCount; IntCount)
            {
            }
            column(HoursWorked; "Employee Timesheet Lines"."Hours Worked")
            {
            }
            column(TotalOffHours; TotalOffHours)
            {
            }
            column(OffdayHours; "Employee Timesheet Lines"."Offday Hours")
            {
            }
            column(TotalHoursWorked; TotalHoursWorked)
            {
            }
            column(ManagerSignature; UserSetup.Signature)
            {
            }
            column(UserSignature; UserSetup2.Signature)
            {
            }
            dataitem("TImesheet Tasks Undertaken"; "TImesheet Tasks Undertaken")
            {
                DataItemLink = "Timesheet Code" = FIELD("TS  No"), "TS Line No" = FIELD("Line No."), Year = FIELD(Year), Month = FIELD(Month);
                column(TaskUndertaken_TImesheetTasksUndertaken; "TImesheet Tasks Undertaken"."Task Undertaken")
                {
                }
                column(ShortcutDimension2Code_TImesheetTasksUndertaken; "TImesheet Tasks Undertaken"."Shortcut Dimension 2 Code")
                {
                }
                column(Hours_TImesheetTasksUndertaken; "TImesheet Tasks Undertaken".Hours)
                {
                }
            }
            dataitem("Employee Timesheet Ledger"; "Employee Timesheet Ledger")
            {
                DataItemLink = "TS  No" = FIELD("TS  No"), "Line No." = FIELD("Line No."), Month = FIELD(Month), Year = FIELD(Year);
                UseTemporary = false;
                column(LCount; LCount)
                {
                }
                column(TSNo_EmployeeTimesheetLedger; "Employee Timesheet Ledger"."TS  No")
                {
                }
                column(LineNo_EmployeeTimesheetLedger; "Employee Timesheet Ledger"."Line No.")
                {
                }
                column(Month_EmployeeTimesheetLedger; "Employee Timesheet Ledger".Month)
                {
                }
                column(Year_EmployeeTimesheetLedger; "Employee Timesheet Ledger".Year)
                {
                }
                column(DescriptionETL; "Employee Timesheet Ledger".Description)
                {
                }
                column(DateETL; "Employee Timesheet Ledger".Date)
                {
                }
                column(HoursETL; "Employee Timesheet Ledger".Hours)
                {
                }
                column(NonWorkingDayETL; "Employee Timesheet Ledger"."Non-Working Day")
                {
                }
                column(DayTypeETL; "Employee Timesheet Ledger"."Day Type")
                {
                }
                column(WWDay; WWDay)
                {
                }
                column(IsWeekend; IsWeekend)
                {
                }
                column(Tasks_EmployeeTimesheetLedger; "Employee Timesheet Ledger".Tasks)
                {
                }
                column(OffDaysPec; OffDaysPec)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    LCount := LCount + 1;
                    /*
                    IF (("Employee Timesheet Ledger"."Day Type"="Employee Timesheet Ledger"."Day Type"::"Working Day")
                      OR ("Employee Timesheet Ledger"."Day Type"="Employee Timesheet Ledger"."Day Type"::Weekend))=TRUE THEN BEGIN
                        WWDay:=TRUE;
                    
                    END;
                    IF ("Employee Timesheet Ledger"."Day Type"<>"Employee Timesheet Ledger"."Day Type"::"Working Day") THEN BEGIN
                        WWDay:=FALSE;
                    
                    END;
                    */
                    /*
                    WWDay:=TRUE;
                    IF "Employee Timesheet Ledger"."Non-Working Day" = TRUE THEN BEGIN
                    WWDay:=FALSE;
                    END;*/
                    WWDay := not ("Employee Timesheet Ledger"."Non-Working Day");

                    if "Employee Timesheet Ledger".Description in ['SHARED', 'CONNECT', 'ENTRENCH', 'PACTIMARA', 'SHARED', 'TRACK', 'STAWISHA PWANI'] then
                        WWDay := true;


                    if "Employee Timesheet Ledger"."Day Type" = "Employee Timesheet Ledger"."Day Type"::Weekend then begin
                        IsWeekend := true;
                    end else
                        IsWeekend := false;

                    if ("Employee Timesheet Ledger"."Day Type" = "Employee Timesheet Ledger"."Day Type"::Leave)
                    or ("Employee Timesheet Ledger"."Day Type" = "Employee Timesheet Ledger"."Day Type"::Other)
                    or ("Employee Timesheet Ledger"."Day Type" = "Employee Timesheet Ledger"."Day Type"::Holiday) then begin
                        if TotalOffHours <> 0 then begin
                            OffDaysPec := Round(("Employee Timesheet Ledger".Hours / TotalOffHours) * 100, 0.01, '=');
                            // MESSAGE('Total hours %1 percentage %2',TotalOffHours,OffDaysPec);
                        end;
                    end;


                    ETLedger.Reset;
                    ETLedger.SetRange("TS  No", "Employee Timesheet Lines"."TS  No");
                    ETLedger.SetRange("Line No.", "Employee Timesheet Lines"."Line No.");
                    ETLedger.SetRange(Year, "Employee Timesheet Lines".Year);
                    ETLedger.SetRange(Month, "Employee Timesheet Lines".Month);
                    if ETLedger.FindSet(false, false) then begin
                        repeat
                            if (ETLedger."Day Type" = ETLedger."Day Type"::Leave)
                            or (ETLedger."Day Type" = ETLedger."Day Type"::Other)
                            or (ETLedger."Day Type" = ETLedger."Day Type"::Holiday) then begin
                                TotalOffHours += ETLedger.Hours;
                                if "Employee Timesheet Ledger".Day = 'Saturday' then begin

                                    ETLedger1.Init;
                                    ETLedger1."Day Type" := ETLedger."Day Type"::Weekend;
                                    ETLedger1."Line No." := "Employee Timesheet Lines"."Line No.";
                                    ETLedger1."Ledger No." += LieNO;
                                    ETLedger1.Hours := 0;
                                    ETLedger1.Description := ETLedger.Description;
                                    ETLedger1."Non-Working Day" := true;
                                    ETLedger1.Date := "Employee Timesheet Ledger".Date;
                                    ;
                                    ETLedger1."Employee No." := "Employee Timesheet Lines".GetFilter("Employee No.");
                                    ETLedger1.Month := "Employee Timesheet Lines".GetFilter(Month);
                                    ETLedger1.Year := "Employee Timesheet Lines".GetFilter(Year);
                                    ETLedger1."TS  No" := "Employee Timesheet Lines"."TS  No";
                                    ETLedger1.Balance := true;
                                    ETLedger1.Insert;
                                end;

                                if "Employee Timesheet Ledger".Day = 'Sunday' then begin

                                    ETLedger1.Init;
                                    ETLedger1."Day Type" := ETLedger."Day Type"::Weekend;
                                    ETLedger1."Line No." := "Employee Timesheet Lines"."Line No.";
                                    ETLedger1."Ledger No." += LieNO;
                                    ETLedger1.Hours := 0;
                                    ETLedger1.Description := ETLedger.Description;
                                    ETLedger1."Non-Working Day" := true;
                                    ETLedger1.Date := "Employee Timesheet Ledger".Date;
                                    ;
                                    ETLedger1."Employee No." := "Employee Timesheet Lines".GetFilter("Employee No.");
                                    ETLedger1.Month := "Employee Timesheet Lines".GetFilter(Month);
                                    ETLedger1.Year := "Employee Timesheet Lines".GetFilter(Year);
                                    ETLedger1."TS  No" := "Employee Timesheet Lines"."TS  No";
                                    ETLedger1.Balance := true;
                                    ETLedger1.Insert;
                                end;
                            end;
                        until ETLedger.Next = 0;
                    end;

                end;

                trigger OnPostDataItem()
                begin
                    //MESSAGE('Total hours %1',TotalOffHours);
                end;

                trigger OnPreDataItem()
                begin
                    IsWeekend := false;
                    //TotalOffHours:=0;
                    OffDaysPec := 0;
                    WWDay := true;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IntCount := IntCount + 1;


                ETLedger.Reset;
                ETLedger.SetRange("TS  No", "Employee Timesheet Lines"."TS  No");
                ETLedger.SetRange("Line No.", "Employee Timesheet Lines"."Line No.");
                ETLedger.SetRange(Year, "Employee Timesheet Lines".Year);
                ETLedger.SetRange(Month, "Employee Timesheet Lines".Month);
                if ETLedger.FindSet(false, false) then begin
                    repeat
                        if (ETLedger."Day Type" = ETLedger."Day Type"::Leave)
                        or (ETLedger."Day Type" = ETLedger."Day Type"::Other)
                        or (ETLedger."Day Type" = ETLedger."Day Type"::Holiday) then begin
                            TotalOffHours += ETLedger.Hours;
                        end;
                    until ETLedger.Next = 0;
                end;

                LieNO := 10000;
                ETLedger.Reset;
                ETLedger.SetRange("TS  No", "Employee Timesheet Lines"."TS  No");
                ETLedger.SetRange("Line No.", "Employee Timesheet Lines"."Line No.");
                ETLedger.SetRange(Year, "Employee Timesheet Lines".Year);
                ETLedger.SetRange(Month, "Employee Timesheet Lines".Month);
                if ETLedger.FindSet(false, false) then begin
                    repeat

                        if (ETLedger."Day Type" = ETLedger."Day Type"::"Working Day") then begin
                            TotalHoursWorked += ETLedger.Hours;


                        end

                    until ETLedger.Next = 0;
                end;

                if Employee.Get("Employee Timesheet Lines"."Employee No.") then begin
                    EmpSearchName := Employee."Search Name";
                    if "Employee Timesheet Lines"."Approval Status" = "Employee Timesheet Lines"."Approval Status"::Approved then begin
                        Employee2.Reset;
                        Employee2.SetRange(Employee2."No.", Employee."Manager No.");
                        if Employee2.FindSet then begin
                            UserSetup.Reset;
                            UserSetup.SetRange("User ID", Employee2."User ID");
                            if UserSetup.FindSet then begin
                                UserSetup.CalcFields(Signature);
                            end;
                        end;
                    end;

                    UserSetup2.Reset;
                    UserSetup2.SetRange("User ID", Employee."User ID");
                    if UserSetup2.FindSet then begin
                        UserSetup2.CalcFields(Signature);
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ETLedger.Reset;
                ETLedger.SetRange("Employee No.", "Employee Timesheet Lines".GetFilter("Employee No."));
                ETLedger.SetRange(Balance, true);
                if ETLedger.Find('-') then begin
                    repeat
                        ETLedger.Delete;
                    until ETLedger.Next = 0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                "Employee Timesheet Lines".SetRange(Month, Format(SelectedMonth));
                if SelectedYear <> '' then
                    "Employee Timesheet Lines".SetRange(Year, SelectedYear);

                ETLedger.Reset;
                ETLedger.SetRange("Employee No.", "Employee Timesheet Lines".GetFilter("Employee No."));
                ETLedger.SetRange(Balance, true);
                if ETLedger.Find('-') then begin
                    repeat
                        ETLedger.Delete;
                    until ETLedger.Next = 0;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SelectedMonth; SelectedMonth)
                {
                    Caption = 'Select Month';
                }
                field(SelectedYear; SelectedYear)
                {
                    Caption = 'Input Year';
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

    trigger OnInitReport()
    begin
        CompInfo.Get();
        CompInfo.CalcFields(Picture);
        IntCount := 0;
        LCount := 0;
        TotalOffHours := 0;
        TotalHoursWorked := 0;
    end;

    var
        CompInfo: Record "Company Information";
        IntCount: Integer;
        Dhours: Decimal;
        LCount: Integer;
        Employees: Record Employee;
        WWDay: Boolean;
        IsWeekend: Boolean;
        TotalOffHours: Decimal;
        ETLedger: Record "Employee Timesheet Ledger";
        OffDaysPec: Decimal;
        TotalHoursWorked: Decimal;
        LieNO: Integer;
        ETLedger1: Record "Employee Timesheet Ledger";
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        Employee2: Record Employee;
        Employee3: Record Employee;
        EmpSearchName: Text;
        SelectedMonth: Option January,February,March,April,May,June,July,August,September,October,November,December;
        SelectedYear: Text[10];

    procedure SetFilters(m: Text; y: Text[10])
    begin
        case m of
            'January':
                SelectedMonth := SelectedMonth::January;
            'February':
                SelectedMonth := SelectedMonth::February;
            'March':
                SelectedMonth := SelectedMonth::March;
            'April':
                SelectedMonth := SelectedMonth::April;
            'May':
                SelectedMonth := SelectedMonth::May;
            'June':
                SelectedMonth := SelectedMonth::June;
            'July':
                SelectedMonth := SelectedMonth::July;
            'August':
                SelectedMonth := SelectedMonth::August;
            'September':
                SelectedMonth := SelectedMonth::September;
            'October':
                SelectedMonth := SelectedMonth::October;
            'November':
                SelectedMonth := SelectedMonth::November;
            'December':
                SelectedMonth := SelectedMonth::December;
            else
                SelectedMonth := SelectedMonth::January;
        end;

        SelectedYear := y;
    end;
}