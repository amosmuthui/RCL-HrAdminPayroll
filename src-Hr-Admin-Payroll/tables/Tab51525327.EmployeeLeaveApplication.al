table 51525327 "Employee Leave Application"
{
    DrillDownPageID = "Emplo Leave Application List";
    LookupPageID = "Emplo Leave Application List";

    fields
    {
        field(1; "Employee No"; Code[20])
        {
            NotBlank = false;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin


                if emp.Get("Employee No") then begin
                    "Employee Name" := Format(emp.Title) + ' ' + emp."First Name" + ' ' + emp."Middle Name" + ' ' + emp."Last Name";
                    "Date of Joining Company" := emp."Date Of Join";
                    "Balance brought forward" := EmpLeave."Balance Brought Forward";
                    "Department Code" := emp."Responsibility Center";//."Global Dimension 2 Code";
                    "Department Name" := emp."Responsibility Center Name";
                    "User ID" := emp."User ID";
                    //"Directorate Code" := emp."Global Dimension 1 Code";
                    if UserSertup.Get(emp."User ID") then
                        Designation := UserSertup.Designation;
                    /*Dims.Reset;
                    Dims.SetRange(Code, emp."Global Dimension 2 Code");
                    Dims.SetRange("Global Dimension No.", 2);
                    if Dims.Find('-') then
                        "Department Name" := Dims.Name;*/
                    "Leave Entitlment" := emp."Annual Leave Entitlement";
                    if emp."Contract Number" <> '' then
                        "Contract No." := emp."Contract Number";

                    //TO GET ENTITLEMENT AND BALANCES-B/F FOR EMPLOYEES ON CONTRACT -
                    ContractPostingGroupCode := '';
                    StaffPostingGroupRec.Reset;
                    StaffPostingGroupRec.SetRange("Is Contract", true);
                    if StaffPostingGroupRec.FindLast then
                        ContractPostingGroupCode := StaffPostingGroupRec.Code;

                    InternPostingGroup := '';
                    StaffPostingGroupRec.Reset;
                    StaffPostingGroupRec.SetRange("Is Intern", true);
                    if StaffPostingGroupRec.FindLast then
                        InternPostingGroup := StaffPostingGroupRec.Code;

                    if (emp."Posting Group" = ContractPostingGroupCode) or (emp."Posting Group" = InternPostingGroup) then begin
                        EmpContracts.Reset;
                        EmpContracts.SetRange(EmpContracts."Employee No", emp."No.");
                        EmpContracts.SetRange(EmpContracts."Contract No", Format(emp."Contract Number"));
                        EmpContracts.SetRange(EmpContracts.Expired, false);
                        if EmpContracts.FindLast then begin
                            "Leave Entitlment" := EmpContracts."Contract Leave Entitlement";
                            "Balance brought forward" := EmpContracts."Balance Brought Forward";
                        end;
                    end;
                    CheckLeaveBalance();
                    // End of the employee on contract
                end;


            end;
        }
        field(2; "Application No"; Code[20])
        {
            NotBlank = false;

            trigger OnValidate()
            begin
                "Application Date" := Today;
                if "Application No" <> xRec."Application No" then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Leave Application Nos.");
                    "No. series" := '';
                end;
            end;
        }
        field(3; "Leave Type"; Code[60])
        {
            TableRelation = "Leave Types".Code;

            trigger OnValidate()
            var
                //Balancerec: Record "HR Type Of Intervention";
                noofmonths: Integer;
                FirstDate: Date;
            begin
                if "Leave Type" = 'CARRY FORWARD' then
                    Error('You cannot select Carry Forward as a leave type. Kindly select ANNUAL then the carry forward days will be factored there!');
                /*if (Status = Status::Released) or (Status = Status::"Pending Approval") then
                    Error('You cannot change an already approved document or a Document Pending Approval');*/

                if emp.Get("Employee No") then begin
                    if LeaveTypes.Get("Leave Type") then begin
                        FirstDate := emp."Date Of Join";
                        if FirstDate = 0D then
                            FirstDate := emp."Date of Appointment";
                        if FirstDate = 0D then
                            Error('Ask the HR to update your date of joining the organization!');
                        if (Today() - FirstDate) < (LeaveTypes."Minimum Days Worked") then
                            Error('You must work for at least %1 days before you qualify for this leave!', LeaveTypes."Minimum Days Worked");
                        if LeaveTypes."Annual Leave" = false then begin
                            if LeaveTypes.Gender = LeaveTypes.Gender::Female then
                                if emp.Gender = emp.Gender::Male then
                                    Error('%1 can only be assigned to %2 employees', LeaveTypes.Description, LeaveTypes.Gender);

                            if LeaveTypes.Gender = LeaveTypes.Gender::Male then
                                if emp.Gender = emp.Gender::Female then
                                    Error('%1 can only be assigned to %2 employees', LeaveTypes.Description, LeaveTypes.Gender);
                            "Leave Entitlment" := LeaveTypes.Days;

                            /*if LeaveTypes.Days <> 0 then
                                "Days Applied" := LeaveTypes.Days;*/

                        end else
                            if LeaveTypes."Annual Leave" = true then begin
                                emp.Reset;
                                if emp.Get("Employee No") then begin
                                    "Leave Entitlment" := emp."Annual Leave Entitlement";
                                    if LeaveTypes."Eligible Staff" = LeaveTypes."Eligible Staff"::Permanent then
                                        if (emp."Posting Group" <> 'PERMANENT') and (emp."Posting Group" <> 'CMFIU/2NDM') then
                                            Error('%1 can only be assigned to Permanent members of staff', LeaveTypes.Description);
                                    //Commented By Edwin--- This code genearates an error in the portal
                                    NoofMonthsWorked := 0;
                                    "Fiscal Start Date" := 20210101D;
                                    Nextmonth := "Fiscal Start Date";
                                    if Date2DMY("Application Date", 3) = Date2DMY("Fiscal Start Date", 3) then begin
                                        NoofMonthsWorked := Date2DMY("Application Date", 2) - Date2DMY("Fiscal Start Date", 2);
                                    end;
                                    if Date2DMY("Application Date", 3) <> Date2DMY("Fiscal Start Date", 3) then begin
                                        NoofMonthsWorked := (Date2DMY("Application Date", 2) + 12) - Date2DMY("Fiscal Start Date", 2);
                                    end;

                                    NoofMonthsWorked := NoofMonthsWorked + 1;
                                    "No. of Months Worked" := NoofMonthsWorked;
                                    //  ERROR(FORMAT("Start Date"));


                                    if LeaveTypes.Get("Leave Type") then
                                        "Leave Earned to Date" := Round((LeaveTypes.Days / 12 * NoofMonthsWorked), 0.5);
                                    //"Leave Entitlment" := LeaveTypes.Days;//("Maturity Date"-"Date of Joining Company")/30*2.5;
                                    EmpLeave.Init;
                                    EmpLeave."Leave Code" := "Leave Type";
                                    EmpLeave."Maturity Date" := "Maturity Date";
                                    EmpLeave."Employee No" := "Employee No";
                                    EmpLeave.Entitlement := "Leave Entitlment";
                                    if not EmpLeave.Get("Employee No", "Leave Type", "Maturity Date") then
                                        EmpLeave.Insert;

                                end;

                            end;

                    end;

                    "Date of Joining Company" := emp."Date Of Join";
                    if EmpLeave.Get("Employee No", "Leave Type", "Maturity Date") then begin
                        "Leave Entitlment" := EmpLeave.Entitlement;
                        "Balance brought forward" := EmpLeave."Balance Brought Forward";
                        CalcFields("Total Leave Days Taken", "Recalled Days", "Off Days");
                        // "Leave balance":=("Leave Entitlment"+"Balance brought forward"+"Recalled Days"+"Off Days")-("Total Leave Days Taken"+"Days Absent");
                    end;
                end;
                CheckLeaveBalance();
                //IF Types.GET("Leave Type") THEN
                //BEGIN
                //IF Types."Is Annual Leave" THEN


                //END;
            end;
        }
        field(4; "Days Applied"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF xRec.Status<>Status::Open THEN
                //ERROR('You cannot change an already approved document');

                //VALIDATE("Start Date");
                //VALIDATE("Leave Code");

                /*
                "Approved Days":="Days Applied";
                
                IF "Start Date" <> 0D THEN BEGIN;
                "Approved Start Date":="Start Date";
                
                IF "Days Applied" > 0 THEN BEGIN
                LeaveTypes.RESET;
                LeaveTypes.SETFILTER(LeaveTypes.Code,"Leave Code");
                CurDate:="Start Date";
                DayApp:="Days Applied";
                REPEAT
                DayApp := DayApp - 1;
                {
                IF LeaveTypes."Inclusive of Holidays" = FALSE THEN BEGIN
                GeneralOptions.FIND('-');
                BaseCalender.RESET;
                BaseCalender.SETFILTER(BaseCalender."Base Calendar Code",GeneralOptions."Base Calender");
                BaseCalender.SETRANGE(BaseCalender.Date,CurDate);
                IF BaseCalender.FIND('-') THEN BEGIN
                  IF BaseCalender.Nonworking = FALSE THEN BEGIN
                     CurDate := CALCDATE('1D',CurDate);
                  END
                  ELSE BEGIN
                     CurDate := CurDate;
                  END;
                
                
                END
                ELSE BEGIN
                  CurDate := CALCDATE('1D',CurDate);
                END;
                
                END;
                }
                 CurDate := CALCDATE('1D',CurDate);
                UNTIL DayApp = 0;
                
                END;
                
                "End Date":=CurDate;
                
                END;
                         */

                // IF "Days Applied">"Leave balance" THEN
                // ERROR('The days applied for are more than your leave balance');
                CalcFields("Leave balance");
                if HRLeaveTypes.Get("Leave Type") then begin
                    if HRLeaveTypes."Annual Leave" = true then
                        "Annual Leave Entitlement Bal" := "Leave balance" - "Days Applied";
                end;
                if ("Days Applied" <> 0) and ("Start Date" <> 0D) then begin
                    "Resumption Date" := DetermineLeaveReturnDate("Start Date", "Days Applied", "Leave Type");
                    "End Date" := DeterminethisLeaveEndDate("Resumption Date");
                    ReturnDate := CalcDate('<1D>', "End Date");
                    ReturnDate := DeterminethisLeaveResumptionDate(ReturnDate);
                    "Resumption Date" := ReturnDate;
                    Rec.Modify;
                end;
                BDate := "Start Date";
                CheckLeaveBalance();

            end;
        }
        field(5; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                //IF xRec.Status<>Status::Open THEN
                //ERROR('You cannot change an already approved document');

                /*FullDays := ROUND("Days Applied",1,'<');
                HalfDays := "Days Applied"-FullDays;
                
                "Resumption Date":="Start Date";
                GeneralOptions.GET;
                NoOfWorkingDays:=0;
                
                 IF ("Days Applied"<>0) AND ("Days Applied">=1) THEN
                 BEGIN
                 IF "Start Date"<>0D THEN
                  BEGIN
                    NextWorkingDate:="Start Date";
                     REPEAT
                       IF NOT CalendarMgmt.CheckDateStatus(GeneralOptions."Base Calendar Code",NextWorkingDate,Description) THEN
                       NoOfWorkingDays:=NoOfWorkingDays+1;
                
                       IF LeaveTypes.GET("Leave Type") THEN
                       BEGIN
                       IF LeaveTypes."Inclusive of Holidays" THEN
                       BEGIN
                         BaseCalendar.RESET;
                         BaseCalendar.SETRANGE(BaseCalendar."Base Calendar Code",GeneralOptions."Base Calendar Code");
                         BaseCalendar.SETRANGE(BaseCalendar.Date,NextWorkingDate);
                         BaseCalendar.SETRANGE(BaseCalendar.Nonworking,TRUE);
                         BaseCalendar.SETRANGE(BaseCalendar."Recurring System",BaseCalendar."Recurring System"::"Annual Recurring");
                        IF BaseCalendar.FIND('-') THEN
                          BEGIN
                          NoOfWorkingDays:=NoOfWorkingDays+1;
                        END;
                
                      END;
                
                     IF LeaveTypes."Inclusive of Saturday" THEN
                     BEGIN
                       BaseCalender.RESET;
                       BaseCalender.SETRANGE(BaseCalender."Period Type",BaseCalender."Period Type"::Date);
                       BaseCalender.SETRANGE(BaseCalender."Period Start",NextWorkingDate);
                       BaseCalender.SETRANGE(BaseCalender."Period No.",6);
                
                       IF BaseCalender.FIND('-') THEN
                         BEGIN
                         NoOfWorkingDays:=NoOfWorkingDays+1;
                         END;
                      END;
                
                
                     IF LeaveTypes."Inclusive of Sunday" THEN
                     BEGIN
                       BaseCalender.RESET;
                       BaseCalender.SETRANGE(BaseCalender."Period Type",BaseCalender."Period Type"::Date);
                       BaseCalender.SETRANGE(BaseCalender."Period Start",NextWorkingDate);
                       BaseCalender.SETRANGE(BaseCalender."Period No.",7);
                       IF  BaseCalender.FIND('-') THEN
                         BEGIN
                         NoOfWorkingDays:=NoOfWorkingDays+1;
                        END;
                      END;
                     IF LeaveTypes."Off/Holidays Days Leave" THEN
                     ;
                
                     END;
                     NextWorkingDate:=CALCDATE('1D',NextWorkingDate);
                 UNTIL  NoOfWorkingDays=FullDays;
                
                 "End Date":=NextWorkingDate-1;
                 "Resumption Date":=NextWorkingDate;
                 END;
                 END ELSE
                 IF ("Days Applied"<>0) AND ("Days Applied"<1) THEN
                 BEGIN
                 "End Date":="Start Date";
                 "Resumption Date":="Start Date";
                
                 END;
                HumanResSetup.RESET();
                HumanResSetup.GET();
                HumanResSetup.TESTFIELD(HumanResSetup."Base Calender Code");
                NonWorkingDay:=FALSE;
                IF "Start Date"<>0D THEN
                  BEGIN
                    WHILE NonWorkingDay=FALSE
                      DO
                        BEGIN
                          NonWorkingDay:= CalendarMgmt.CheckDateStatus(HumanResSetup."Base Calender Code","Resumption Date",Dsptn);
                          IF NonWorkingDay THEN
                            BEGIN
                              NonWorkingDay:=FALSE;
                             "Resumption Date":=CALCDATE('1D',"Resumption Date");
                            END
                          ELSE
                            BEGIN
                              NonWorkingDay:=TRUE;
                            END;
                        END;
                  END;
                
                
                 LeaveTypes.GET("Leave Type");
                
                IF LeaveTypes."Annual Leave" = TRUE THEN BEGIN
                //New Joining Employees
                IF emp.GET("Employee No") THEN
                BEGIN
                IF ("Date of Joining Company">"Fiscal Start Date") THEN
                BEGIN
                
                  IF "Date of Joining Company"<>0D THEN
                    BEGIN
                    NoofMonthsWorked:=0;
                    Nextmonth:="Date of Joining Company";
                    REPEAT
                      Nextmonth:=CALCDATE('1M',Nextmonth);
                      NoofMonthsWorked:=NoofMonthsWorked+1;
                     UNTIL Nextmonth>="Start Date";
                    NoofMonthsWorked:=NoofMonthsWorked-1;
                    "No. of Months Worked":=NoofMonthsWorked;
                
                    IF LeaveTypes.GET("Leave Type") THEN
                    "Leave Earned to Date":=ROUND(((LeaveTypes.Days/12)*NoofMonthsWorked),1);
                    VALIDATE("Leave Type");
                    END;
                  END;
                  END;
                END;*/
                PayrollPeriod.Reset;
                PayrollPeriod.SetFilter(Closed, '%1', true);
                if PayrollPeriod.FindLast then begin
                    "Current Payroll Period" := CalcDate('1M', PayrollPeriod."Starting Date");
                end;

                if "Start Date" < Today then
                    Error('You can only apply leave on a future date.');
                if "Start Date" = 0D then begin
                    "Resumption Date" := 0D;
                    "End Date" := 0D;
                end else begin
                    if DetermineIfIsNonWorking("Start Date") = true then begin
                        Error('Start date must be a working day');
                    end;
                    Validate("Days Applied");
                end;

            end;
        }
        field(6; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                //"Approved To Date":="To Date";
                /*if (Status = Status::Released) or (Status = Status::"Pending Approval") then
                    Error('You cannot change an already approved document or a Document Pending Approval');*/
                if "Start Date" <> 0D then
                    Validate("Start Date");
                Validate("Leave Type");
            end;
        }
        field(7; "Application Date"; Date)
        {
        }
        field(8; "Approved Days"; Decimal)
        {

            trigger OnValidate()
            begin
                days := "Approved Days";
            end;
        }
        field(9; "Approved Start Date"; Date)
        {
        }
        field(10; "Verified By Manager"; Boolean)
        {

            trigger OnValidate()
            begin
                "Verification Date" := Today;
            end;
        }
        field(11; "Verification Date"; Date)
        {
        }
        field(12; "Leave Status"; Option)
        {
            OptionCaption = 'Being Processed,Approved,Rejected,Canceled';
            OptionMembers = "Being Processed",Approved,Rejected,Canceled;

            trigger OnValidate()
            begin

                if ("Leave Status" = "Leave Status"::Approved) and (xRec."Leave Status" <> "Leave Status"::Approved) then begin
                    ;
                    "Approval Date" := Today;
                    "Approved Days" := xRec."Days Applied";
                    //MODIFY;

                    LeaveTypes.Get("Leave Type");

                    if LeaveTypes."Annual Leave" = true then begin


                        /*
                        emp.RESET;
                        IF emp.GET("Employee No") THEN BEGIN

                          //For employees on contract by Jacob
                          IF (emp."Posting Group"='TEMP') OR (emp."Posting Group"='INTERN') THEN BEGIN
                             EmployeeContracts.RESET;
                             EmployeeContracts.SETRANGE(EmployeeContracts."Employee No","Employee No");
                             EmployeeContracts.SETRANGE(EmployeeContracts.Expired,FALSE);
                             IF EmployeeContracts.FIND('-') THEN BEGIN
                              IF (EmployeeContracts."Contract Start Date"<"Start Date") AND (EmployeeContracts."Contract End Date">"Start Date") THEN
                                EmployeeContracts."Contract Leave Balance":=EmployeeContracts."Contract Leave Balance"-"Approved Days";
                                // "Leave balance":=EmployeeContracts."Contract Leave Balance";
                                EmployeeContracts.VALIDATE(EmployeeContracts."Contract Leave Balance");
                                EmployeeContracts.MODIFY;

                               "Employee Leaves".RESET;
                               "Employee Leaves".SETRANGE("Employee Leaves"."Employee No","Employee No");
                               "Employee Leaves".SETRANGE("Employee Leaves"."Leave Code","Leave Code");
                               "Employee Leaves".SETRANGE("Employee Leaves"."Temp. Emp. Contract",EmployeeContracts."Contract No");
                               IF "Employee Leaves".FIND('-') THEN;
                                "Employee Leaves".Balance:="Employee Leaves".Balance - "Approved Days";
                                "Employee Leaves".VALIDATE("Employee Leaves".Balance);
                                 "Employee Leaves".MODIFY;
                             END;
                           END
                           ELSE
                           */

                        "Employee Leaves".Reset;
                        "Employee Leaves".SetRange("Employee Leaves"."Employee No", "Employee No");
                        "Employee Leaves".SetRange("Employee Leaves"."Leave Code", "Leave Type");
                        if "Employee Leaves".Find('-') then begin

                            "Employee Leaves".Balance := "Employee Leaves".Balance - "Approved Days";
                            // "Employee Leaves".VALIDATE("Employee Leaves".Balance);

                            // "Leave balance":="Employee Leaves".Balance;
                            //"Balance brought forward":=EmpLeave."Balance Brought Forward";
                            "Employee Leaves".Modify;

                        end;
                    end
                    else
                        if ("Leave Status" <> "Leave Status"::Approved) and (xRec."Leave Status" = "Leave Status"::Approved) then begin
                            "Approval Date" := Today;
                            //"Approved Days" := 0;
                            "Employee Leaves".Reset;
                            "Employee Leaves".SetRange("Employee Leaves"."Employee No", "Employee No");
                            "Employee Leaves".SetRange("Employee Leaves"."Leave Code", "Leave Type");
                            if "Employee Leaves".Find('-') then;
                            "Employee Leaves".Balance := "Employee Leaves".Balance + "Approved Days";
                            "Employee Leaves".Validate("Employee Leaves".Balance);

                            "Employee Leaves".Modify;
                        end;

                end;

            end;
        }
        field(13; "Approved End Date"; Date)
        {
        }
        field(14; "Approval Date"; Date)
        {
        }
        field(15; Comments; Text[250])
        {
        }
        field(16; Taken; Boolean)
        {
        }
        field(17; "Acrued Days"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Leave Period" = FIELD("Leave Period"),
                                                                             "Staff No." = FIELD("Employee No"),
                                                                             IsMonthlyAccrued = FILTER(true)));
            FieldClass = FlowField;
        }
        field(18; "Over used Days"; Decimal)
        {
        }
        field(19; "Leave Allowance Payable"; Boolean)
        {

            trigger OnValidate()
            begin
                HumanResSetup.Get;
                if "Leave Allowance Payable" = true then begin

                    if emp.Get("Employee No") then
                        // BEGIN
                        if (emp."Posting Group" = 'TEMP') or (emp."Posting Group" = 'INTERN') then
                            Error('Temporary Employees are not paid leave allowance');


                    leaveapp.Reset;
                    leaveapp.SetRange(leaveapp."Employee No", "Employee No");
                    leaveapp.SetRange(leaveapp."Maturity Date", "Maturity Date");
                    leaveapp.SetRange(leaveapp.Status, leaveapp.Status::Released);
                    leaveapp.SetRange(leaveapp."Leave Allowance Payable", true);
                    if leaveapp.Find('-') then
                        Error('Leave allowance has already been paid in leave application %1', leaveapp."Application No");
                    /*
                    AccPeriod.RESET;
                    AccPeriod.SETRANGE(AccPeriod."Starting Date",0D,TODAY);
                    AccPeriod.SETRANGE(AccPeriod."New Fiscal Year",TRUE);
                    IF AccPeriod.FIND('+') THEN
                      FiscalStart:=AccPeriod."Starting Date";
                     // MESSAGE('YEAR START %1',FiscalStart);

                      FiscalEnd:=CALCDATE('1Y',FiscalStart)-1;
                    //  MESSAGE('YEAR END%1',FiscalEnd);
                    */
                    assmatrix.Reset;
                    assmatrix.SetRange(assmatrix."Payroll Period", "Fiscal Start Date", "Maturity Date");
                    assmatrix.SetRange(assmatrix."Employee No", leaveapp."Employee No");
                    assmatrix.SetRange(assmatrix.Type, assmatrix.Type::Payment);
                    assmatrix.SetRange(assmatrix.Code, HumanResSetup."Leave Allowance Code");
                    if assmatrix.Find('-') then begin
                        LeaveAllowancePaid := true;
                        Error('Leave allowance has already been paid in %1', assmatrix."Payroll Period");
                    end;

                    if "Days Applied" < HumanResSetup."Qualification Days (Leave)" then
                        Error('You can only be paid leave allowance if you take %1 or more Days', HumanResSetup."Qualification Days (Leave)");

                end;

            end;
        }
        field(20; Post; Boolean)
        {
        }
        field(21; days; Decimal)
        {
        }
        field(23; "No. series"; Code[10])
        {
        }
        field(24; "Leave balance"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Leave Period" = FIELD("Leave Period"),
                                                                             "Staff No." = FIELD("Employee No"),
                                                                             "Leave Type" = field("Leave Type")/*FILTER('ANNUAL' | 'CF' | 'CARRY FORWARD')*/));
            FieldClass = FlowField;
        }
        field(25; "Resumption Date"; Date)
        {
        }
        field(26; "Employee Name"; Text[50])
        {
        }
        field(27; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected,Posted';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected,Posted;

            trigger OnValidate()
            begin
                //Send Approval mails \*Disable when using workflow notifications*/
                //Send mail to all staff
                HumanResSetup.Get;
                if Status = Status::Released then begin
                    FnPostLeave("Application No");//post leave aytomatically on approval
                    Posted := true;
                    "Posted By" := UserId;
                    "Date Posted" := Today;
                    "Time Posted" := Time;
                    UserSertup.Reset;
                    UserSertup.SetRange("Employee No.", Rec."Employee No");
                    if UserSertup.Find('-') then begin
                        /*ReciepM := HumanResSetup."All Staff Mail";
                        if UsrSet.Get(UserSertup."Approver ID") then begin
                            SenderM := UsrSet."E-Mail";
                            if EmpRec.Get(UsrSet."Employee No.") then
                                SenderN := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
                        end;
                        if emp.Get("Duties Taken Over By") then
                            DutiesBy := emp."First Name" + ' ' + emp."Middle Name" + ' ' + emp."Last Name";
                        Subject := 'Leave Approved-' + "Application No" + '-' + "Employee Name";
                        Body := 'Dear All,<p>This is to notify you that ' + "Employee Name" + ' Will be on leave from ' + Format("Start Date") + ' to ' + Format("Resumption Date") + '. <br> His/her duties will be taken over by ';
                        Body := Body + DutiesBy + '. <p> Kind Regards <br>' + SenderN;*/
                        //=>Factry.FnSendEmail(SenderM, SenderN, ReciepM, Subject, Body);
                        Factry.FnUpdateUserSetupRelieverDetails(GetEmpUserID("Employee No"), "Start Date", "Resumption Date", GetEmpUserID("Duties Taken Over By"));
                    end;
                end;
                //Send mail to Leave approver
                /*
                IF Status=Status::"Pending Approval" THEN BEGIN
                  UserSertup.RESET;
                  UserSertup.SETRANGE("Employee No.",Rec."Employee No");
                  IF UserSertup.FIND('-') THEN BEGIN
                    SenderM:=UserSertup."E-Mail";
                  IF UsrSet.GET(UserSertup."Approver ID") THEN
                    ReciepM:=UsrSet."E-Mail";
                  IF emp.GET("Duties Taken Over By") THEN
                    DutiesBy:=emp."First Name"+' '+emp."Middle Name"+' '+emp."Last Name";
                  Subject:='Leave Approved-'+"Application No"+'-'+"Employee Name";
                  Body:='This is to notify you that '+"Employee Name"+' Will be on leave from '+FORMAT("Start Date")+' to '+FORMAT("Resumption Date")+'. <br> His/Her duties will be taken by';
                  Body:=Body+DutiesBy+'. <p> Leave Application Mail Services';
                Factry.FnSendEmail('SenderMail','Sender Name','Recipient Mail','Subject','Body');
                END;
                END;
                */

            end;
        }
        field(28; "Leave Entitlment"; Decimal)
        {
        }
        field(29; "Total Leave Days Taken"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Leave Period" = FIELD("Leave Period"),
                                                                             "Staff No." = FIELD("Employee No"),
                                                                             "Leave Type" = field("Leave Type"), //FILTER('ANNUAL|CF|CARRY FORWARD')
                                                                             "Leave Entry Type" = FILTER(Negative)));
            FieldClass = FlowField;
        }
        field(30; "Duties Taken Over By"; Code[30])
        {
            TableRelation = Employee."No." WHERE(Status = CONST(Active));

            trigger OnValidate()
            begin
                /*if (Status = Status::Released) or (Status = Status::"Pending Approval") then
                    Error('You cannot change an already approved document or a Document Pending Approval');*/


                if "Duties Taken Over By" = "Employee No" then
                    Error('You cannot select your own ID in this field');

                emp.Reset;
                if emp.Get("Duties Taken Over By") then
                    Name := emp."First Name" + ' ' + emp."Middle Name" + ' ' + emp."Last Name";
                // leaveapp.RESET;
                // leaveapp.SETRANGE("Employee No","Duties Taken Over By");
                // leaveapp.SETRANGE("Maturity Date","Maturity Date");
                // leaveapp.SETFILTER(Status,'%1|%2',leaveapp.Status::"Pending Approval",leaveapp.Status::Released);
                // IF leaveapp.FIND('-') THEN BEGIN
                //  REPEAT
                //    IF ((leaveapp."Start Date">="Start Date") AND (leaveapp."Start Date"<="End Date")) THEN
                //      ERROR('Staff selected has an approved leave application within your application timelines');
                //    UNTIL leaveapp.NEXT=0;
                //  END;
            end;
        }
        field(31; Name; Text[50])
        {
        }
        field(32; "Mobile No"; Code[20])
        {
        }
        field(33; "Balance brought forward"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Leave Period" = FIELD("Leave Period"),
                                                                             "Staff No." = FIELD("Employee No"),
                                                                             "Leave Type" = FILTER('CF|CARRY FORWARD')));
            FieldClass = FlowField;
        }
        field(34; "Leave Earned to Date"; Decimal)
        {
        }
        field(35; "Maturity Date"; Date)
        {
        }
        field(36; "Date of Joining Company"; Date)
        {
        }
        field(37; "Fiscal Start Date"; Date)
        {
        }
        field(38; "No. of Months Worked"; Decimal)
        {
        }
        field(39; "Annual Leave Entitlement Bal"; Decimal)
        {
        }
        field(40; "Recalled Days"; Decimal)
        {
            CalcFormula = Sum("Leave Recall"."No. of Off Days" WHERE("Leave Application" = FIELD("Application No"),
                                                                             Posted = const(true)));
            FieldClass = FlowField;
        }
        field(41; "Off Days"; Decimal)
        {
            CalcFormula = Sum("Holidays_Off Days"."No. of Days" WHERE("Employee No." = FIELD("Employee No"),
                                                                       "Leave Type" = FIELD("Leave Type"),
                                                                       "Maturity Date" = FIELD("Maturity Date")));
            FieldClass = FlowField;
        }
        field(42; "Department Code"; Code[240])
        {
            //TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
            TableRelation = "Responsibility Center".Code;
        }
        field(43; "User ID"; Code[30])
        {
        }
        field(45; "Days Absent"; Decimal)
        {
            CalcFormula = Sum("Employee Absentism"."No. of  Days Absent" WHERE("Employee No" = FIELD("Employee No"),
                                                                                Status = CONST(Released),
                                                                                "Maturity Date" = FIELD("Maturity Date")));
            FieldClass = FlowField;
        }
        field(46; "Contract No."; Code[20])
        {
        }
        field(47; "Pending Approver"; Code[30])
        {
            CalcFormula = Lookup("Approval Entry"."Approver ID" WHERE("Document No." = FIELD("Application No"),
                                                                       Status = CONST(Open)));
            FieldClass = FlowField;
        }
        field(48; "Directorate Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(49; "Department Name"; Text[50])
        {
        }
        field(50; "Directorate name"; Text[50])
        {
        }
        field(51; "No. of Approvals"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(51525209),
                                                        "Document No." = FIELD("Application No")));
            FieldClass = FlowField;
        }
        field(52; "Current Payroll Period"; Date)
        {
            TableRelation = "Payroll Period"."Starting Date";
        }
        field(53; "Rejection Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(54; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Leave Period"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(56; Posted; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Email: Codeunit "Email";
                EmailMessage: Codeunit "Email message";
                PdfDocPath: Text;
                Path: Text;
            //hrleaveapplication: Record Locations;
            begin
            end;
        }
        field(57; "Posted By"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(58; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(60; Designation; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Officer,Asst Manager,Manager,Director,CEO';
            OptionMembers = " ",Officer,"Asst Manager",Manager,Director,CEO;
        }
        field(61; "Include Leave Allowance"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Employeesx: Record Employee;
            begin
                HumanResSetup.Get();
                if "Days Applied" < HumanResSetup."Leave Allowance Days" then
                    Error('You are not eligible to apply leave allowance.');
                if Employeesx.Get("Employee No") then begin
                    if Employeesx."Allowance Collected" = true then
                        Error('You Already Collected Your Leave Allowance For This Period.');
                end;
            end;
        }
        field(62; Approver; Code[40])
        {
            CalcFormula = Lookup("Approval Entry"."Approver ID" WHERE("Document No." = FIELD("Application No"),
                                                                       Status = FILTER(Open)));
            FieldClass = FlowField;
        }
        field(63; "Approved ID"; Code[50])
        {
            CalcFormula = Lookup("User Setup"."Approver ID" WHERE("User ID" = FIELD("User ID")));
            FieldClass = FlowField;
        }
        field(64; "Leave Return Notification Sent"; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Application No")
        {
            Clustered = true;
            SumIndexFields = days;
        }
        key(Key2; "Employee No", Status, "Leave Type", "Maturity Date")
        {
            SumIndexFields = "Days Applied", "Approved Days";
        }
        key(Key3; "Employee No", Status, "Leave Type", "Contract No.")
        {
            SumIndexFields = "Days Applied", "Approved Days";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Application No", "Leave Type", "Employee No", "Employee Name", "Start Date", "End Date", "Days Applied")
        {
        }
    }

    trigger OnDelete()
    begin

        if Post = true then
            Error('You cannot Delete the Record');

        if (Status = Status::Released) or (Status = Status::"Pending Approval") then
            Error('You cannot change an already approved document or a Document Pending Approval');
    end;

    trigger OnInsert()
    var
        OpenLeaves: Integer;
    begin
        if "Application No" = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Leave Application Nos.");
            "Application No" := NoSeriesMgt.GetNextNo(HumanResSetup."Leave Application Nos.");
        end;

        "Application Date" := Today;
        "User ID" := UserId;
        if "Employee No" <> '' then begin
            if UserSertup.Get(UserId) then begin
                //=>"Employee No" := UserSertup."Employee No.";
                Designation := UserSertup.Designation;
                //=>Validate("Employee No");
                //MESSAGE("Employee No");
                if EmpRec.Get("Employee No") then begin
                    "Department Code" := EmpRec."Global Dimension 2 Code";
                    //Department Name
                    DimVal.Reset;
                    DimVal.SetRange("Global Dimension No.", 2);
                    DimVal.SetRange(Code, "Department Code");
                    if DimVal.FindLast then
                        "Department Name" := DimVal.Name;

                    "Directorate Code" := EmpRec."Global Dimension 1 Code";
                    //get directorate Name
                    DimVal.Reset;
                    DimVal.SetRange("Global Dimension No.", 1);
                    DimVal.SetRange(Code, "Directorate Code");
                    if DimVal.FindLast then
                        "Directorate name" := DimVal.Name;

                    "Mobile No" := EmpRec."Cellular Phone Number";
                    "Date of Joining Company" := EmpRec."Date Of Join";
                    "Contract No." := emp."Contract Number";

                end;
            end;
            CheckLeaveBalance();
        end;
        //Find Maturity date
        FindMaturityDate;

        Periods.Reset;
        Periods.SetRange(Periods.Closed, false);
        if Periods.FindLast then begin
            "Leave Period" := Periods."Period Code";
        end;

        PayrollPeriod.Reset;
        PayrollPeriod.SetFilter(Closed, '%1', true);
        if PayrollPeriod.FindLast then begin
            "Current Payroll Period" := CalcDate('1M', PayrollPeriod."Starting Date");
        end;


        if "Employee No" <> '' then begin
            leaveapp.Reset;
            leaveapp.SetRange(leaveapp."Employee No", "Employee No");
            leaveapp.SetFilter(leaveapp.Status, '=%1', leaveapp.Status::Open);
            if leaveapp.FindFirst then begin
                OpenLeaves := leaveapp.Count;
                if OpenLeaves > 0 then
                    Error('There are existing open leaves. Please reuse the existing card before making a fresh application.', leaveapp."Application No");
            end;
            EmployeeAbsentism.Reset;
            EmployeeAbsentism.SetFilter("Employee No", "Employee No");
            EmployeeAbsentism.SetFilter(Approved, '%1', true);
            EmployeeAbsentism.SetFilter(Status, '%1', EmployeeAbsentism.Status::Released);
            EmployeeAbsentism.SetFilter("Maturity Date", '%1', "Maturity Date");
            if EmployeeAbsentism.FindSet then
                repeat
                    "Days Absent" := "Days Absent" + EmployeeAbsentism."No. of  Days Absent";
                until EmployeeAbsentism.Next = 0;

            //Prevent Creation of leave application pending an earlier approval request
            if "Employee No" <> '' then begin
                leaveapp.Reset;
                leaveapp.SetRange(leaveapp."Employee No", "Employee No");
                leaveapp.SetFilter(leaveapp.Status, '=%1', leaveapp.Status::"Pending Approval");
                leaveapp.SetFilter("Application No", '<>%1', "Application No");
                if leaveapp.FindFirst() then
                    Error('Please ensure the pending leave application %1 is approved before submitting another one!', leaveapp."Application No");
            end;
        end;

        if "Leave Type" <> '' then
            Validate("Leave Type");
    end;

    trigger OnModify()
    begin
        if Post = true then
            Error('You cannot Modify the Record');
        if "Leave Type" <> '' then
            Validate("Leave Type");
    end;

    trigger OnRename()
    begin
        if Post = true then
            Error('You cannot Rename the Record');
    end;

    var
        "Employee Leaves": Record "Employee Leave Entitlement";
        BaseCalender: Record Date;
        CurDate: Date;
        LeaveTypes: Record "Leave Types";
        DayApp: Decimal;
        Dayofweek: Integer;
        i: Integer;
        textholder: Text[30];
        emp: Record Employee;
        leaveapp: Record "Employee Leave Application";
        GeneralOptions: Record "Company Information";
        NoOfDays: Integer;
        BaseCalendar: Record "Base Calendar Change";
        yearend: Date;
        d: Date;
        d2: Integer;
        d3: Integer;
        d4: Integer;
        d1: Integer;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        earn: Record Earnings;
        assmatrix: Record "Assignment Matrix";
        ecode: Code[20];
        ldated: Date;
        UserSertup: Record "User Setup";
        CalendarMgmt: Codeunit "Calendar Management";
        NextWorkingDate: Date;
        Description: Text[30];
        NoOfWorkingDays: Integer;
        LeaveAllowancePaid: Boolean;
        PayrollPeriod: Record "Payroll Period";
        PayPeriodStart: Date;
        EmpRec: Record Employee;
        MaturityDate: Date;
        EmpLeave: Record "Employee Leave Entitlement";
        NoofMonthsWorked: Integer;
        FiscalStart: Date;
        Nextmonth: Date;
        DimVal: Record "Dimension Value";
        NonWorkingDay: Boolean;
        Dsptn: Text[30];
        AccPeriod: Record "Payroll Period";
        FiscalEnd: Date;
        EmpContracts: Record "Employee Contracts";
        EmployeeContracts: Record "Employee Contracts";
        //LeavePlan: Record "Employee Leave Plan";
        FullDays: Decimal;
        HalfDays: Decimal;
        GLSetup: Record "General Ledger Setup";
        GLBudgets: Record "G/L Budget Name";
        empabsences: Record "Employee Absence";
        EmployeeAbsentism: Record "Employee Absentism";
        StaffPostingGroupRec: Record "Staff Posting Group";
        ContractPostingGroupCode: Code[10];
        InternPostingGroup: Code[10];
        Dims: Record "Dimension Value";
        Factry: Codeunit "Custom Helper Functions HR";
        Body: Text;
        Subject: Text;
        SenderM: Text;
        ReciepM: Text;
        UsrSet: Record "User Setup";
        DutiesBy: Text;
        SenderN: Text;
        Periods: Record "HR Leave Periods";
        Types: Record "Leave Types";
        varDaysApplied: Decimal;
        HRLeaveTypes: Record "Leave Types";
        BaseCalendarChange: Record "Base Calendar Change";
        Customized: Record "HR Calendar List";
        ReturnDateLoop: Boolean;
        BDate: Date;
        ReturnDate: Date;
        HRSetup: Record "Human Resources Setup";
        BasicSalary: Decimal;
        Text1: Label 'LEAVE APPLICATION';

    procedure CreateLeaveAllowance(var LeaveApp: Record "Employee Contracts")
    var
        HRSetup: Record "Human Resources Setup";
        AccPeriod: Record "Accounting Period";
        FiscalStart: Date;
        FiscalEnd: Date;
        ScaleBenefits: Record "Scale Benefits";
        RefDate: Date;
    begin
        /*
        IF LeaveApp."Leave Allowance Payable"=LeaveApp."Leave Allowance Payable"::"1" THEN
        BEGIN
        AccPeriod.RESET;
        AccPeriod.SETRANGE(AccPeriod."Starting Date",0D,TODAY);
        AccPeriod.SETRANGE(AccPeriod."New Fiscal Year",TRUE);
        IF AccPeriod.FIND('+') THEN
        FiscalStart:=AccPeriod."Starting Date";
        //MESSAGE('%1',FiscalStart);
        
        
        FiscalEnd:=CALCDATE('1Y',FiscalStart)-1;
        //MESSAGE('%1',FiscalEnd);
        
        LeaveApp.RESET;
        LeaveApp.SETRANGE(LeaveApp."Employee No","Employee No");
        LeaveApp.SETRANGE(LeaveApp."Maturity Date","Maturity Date");
        LeaveApp.SETRANGE(LeaveApp.Status,LeaveApp.Status::Released);
        LeaveApp.SETRANGE(LeaveApp."Leave Allowance Payable",LeaveApp."Leave Allowance Payable"::"1");
        IF LeaveApp.FIND('-') THEN
          ERROR('Leave allowance has already been paid in leave application %1',LeaveApp."Application No");
        
        {
        assmatrix.RESET;
        assmatrix.SETRANGE(assmatrix."Payroll Period",FiscalStart,FiscalEnd);
        assmatrix.SETRANGE(assmatrix."Employee No",LeaveApp."Employee No");
        assmatrix.SETRANGE(assmatrix.Type,assmatrix.Type::Payment);
        assmatrix.SETRANGE(assmatrix.Code,HRSetup."Leave Allowance Code");
        IF assmatrix.FIND('-') THEN
        BEGIN
        LeaveAllowancePaid:=TRUE;
        ERROR('Leave allowance has already been paid in %1',assmatrix."Payroll Period");
        END;
        
        
        IF NOT LeaveAllowancePaid THEN
        BEGIN
        
        
        
        IF HRSetup.GET THEN
        BEGIN
        IF "Days Applied">=HRSetup."Qualification Days (Leave)" THEN
        BEGIN
          IF emp.GET("Employee No") THEN
          BEGIN
          {
            ScaleBenefits.RESET;
            ScaleBenefits.SETRANGE(ScaleBenefits."Salary Scale",emp."Salary Scale");
            ScaleBenefits.SETRANGE(ScaleBenefits."Salary Pointer",emp.Present);
            ScaleBenefits.SETRANGE(ScaleBenefits."ED Code",HRSetup."Leave Allowance Code");
            IF ScaleBenefits.FIND('-') THEN
            BEGIN
          }
               PayrollPeriod.RESET;
               PayrollPeriod.SETRANGE(PayrollPeriod."Close Pay",FALSE);
               IF PayrollPeriod.FIND('-') THEN
               PayPeriodStart:=PayrollPeriod."Starting Date";
        
              HRSetup.GET;
              RefDate:=CALCDATE(HRSetup."Monthly PayDate",PayPeriodStart);
              IF LeaveApp."Application Date">RefDate THEN
               PayPeriodStart:=CALCDATE('1M',PayPeriodStart);
        
        
              assmatrix.INIT;
              assmatrix."Employee No":="Employee No";
              assmatrix.Type:=assmatrix.Type::Payment;
              assmatrix.Code:=HRSetup."Leave Allowance Code";
              assmatrix.VALIDATE(assmatrix.Code);
              assmatrix."Payroll Period":=PayPeriodStart;
              assmatrix.VALIDATE("Payroll Period");
              assmatrix.Amount:=ScaleBenefits.Amount;
              IF NOT assmatrix.GET(assmatrix."Employee No",assmatrix.Type,assmatrix.Code,assmatrix."Payroll Period") THEN
              assmatrix.INSERT;
         // END;
          END;
        
        END;
        
        
        
        
        END;
        //MESSAGE('Your leave allowance for this year has already been paid');
        END;
        }
        END;
        */

    end;


    procedure FindMaturityDate()
    var
        AccPeriod: Record "Payroll Period";
    begin
        GLSetup.Reset;
        GLSetup.Get;
        GLSetup.TestField("Current Budget");
        GLBudgets.Reset;
        GLBudgets.Get(GLSetup."Current Budget");
        GLBudgets.TestField("Start Date");
        GLBudgets.TestField("End Date");
        HumanResSetup.Get;
        if HumanResSetup."Use Fiscal Year" = true then begin
            "Fiscal Start Date" := GLBudgets."Start Date";
            "Maturity Date" := GLBudgets."End Date";
        end else begin
            "Fiscal Start Date" := CalcDate('<-CY>', Today);
            "Maturity Date" := CalcDate('<CY>', Today);
        end;
        /*
        AccPeriod.RESET;
        AccPeriod.SETRANGE(AccPeriod."Starting Date",0D,TODAY);
        AccPeriod.SETRANGE(AccPeriod."New Fiscal Year",TRUE);
        IF AccPeriod.FIND('+') THEN
        BEGIN
        FiscalStart:=AccPeriod."Starting Date";
        MaturityDate:=CALCDATE('1Y',AccPeriod."Starting Date")-1;
        END;
        */

    end;


    procedure CreateLeaveAllowancePayroll(leaverec: Record "Employee Contracts")
    var
        assignMatrix1: Record "Assignment Matrix";
        scalebenefits: Record "Scale Benefits";
        emprec: Record Employee;
        Mailheader: Text;
        MailBody: Text;
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        usersetup: Record "User Setup";
    begin
        /*HumanResSetup.RESET;
        HumanResSetup.GET;
        HumanResSetup.TESTFIELD("Leave Allowance Code");
        GLSetup.RESET;
        GLSetup.GET;
        GLSetup.TESTFIELD("Leave Allowance Payment Day");
        IF leaverec."Leave Allowance Payable"=TRUE THEN BEGIN
                      IF DATE2DMY(leaverec."Application Date",1)<=GLSetup."Leave Allowance Payment Day" THEN BEGIN
                           assignMatrix1.RESET;
                           assignMatrix1.INIT;
                           assignMatrix1."Employee No":=leaverec."Employee No";
                           assignMatrix1.Type:=assignMatrix1.Type::Payment;
                           assignMatrix1.Code:=HumanResSetup."Leave Allowance Code";
                           assignMatrix1."Payroll Period":=leaverec."Current Payroll Period";
                           assignMatrix1.VALIDATE("Employee No");
                           assignMatrix1.VALIDATE(Code);
                           emprec.RESET;
                           emprec.GET(leaverec."Employee No");
                           scalebenefits.RESET;
                           scalebenefits.SETRANGE("Salary Scale",emprec."Salary Scale");
                           scalebenefits.SETRANGE("Salary Pointer",emprec.Present);
                           scalebenefits.SETRANGE("ED Code",HumanResSetup."Leave Allowance Code");
                           IF scalebenefits.FINDSET THEN BEGIN
                               assignMatrix1.Amount:=ABS(scalebenefits.Amount); //ERROR('%1',ABS(scalebenefits.Amount));
                           END;
                           //assignMatrix1.VALIDATE(Amount);
                           assignMatrix1.INSERT;
                           //assignMatrix1
                      END;
                      IF DATE2DMY(leaverec."Application Date",1)>GLSetup."Leave Allowance Payment Day" THEN BEGIN
                           assignMatrix1.RESET;
                           assignMatrix1.INIT;
                           assignMatrix1."Employee No":=leaverec."Employee No";
                           assignMatrix1.Type:=assignMatrix1.Type::Payment;
                           assignMatrix1.Code:=HumanResSetup."Leave Allowance Code";
                           assignMatrix1."Payroll Period":=CALCDATE('1M',leaverec."Current Payroll Period");
                           assignMatrix1.VALIDATE("Employee No");
                           assignMatrix1.VALIDATE(Code);
                           emprec.RESET;
                           emprec.GET(leaverec."Employee No");
                           scalebenefits.RESET;
                           scalebenefits.SETRANGE("Salary Scale",emprec."Salary Scale");
                           scalebenefits.SETRANGE("Salary Pointer",emprec.Present);
                           scalebenefits.SETRANGE("ED Code",HumanResSetup."Leave Allowance Code");
                           IF scalebenefits.FINDSET THEN BEGIN
                               assignMatrix1.Amount:=ABS(scalebenefits.Amount);
                           END;
                           //assignMatrix1.VALIDATE(Amount);
                           assignMatrix1.INSERT;
                           //assignMatrix1
                      END;
        END;
        //Send E-mail to the Leave Creator
        SMTPRec.RESET;
        SMTPRec.GET;
        usersetup.RESET;
        usersetup.GET(leaverec."User ID");
        usersetup.TESTFIELD("E-Mail");
        Mailheader:='Leave Application :'+leaverec."Application No"+' Approved';
        MailBody:='Dear '+usersetup."User ID"+',<br><br>';
        MailBody:=MailBody+'Leave Application No: <b>'+leaverec."Application No"+'</b> has been Approved.<br><br>';
        MailBody:=MailBody+'Kind Regards<br><br>';
        SMTPCu.CreateMessage('Leave Info',SMTPRec."User ID",usersetup."E-Mail",Mailheader,MailBody,TRUE);
        SMTPCu.AddBCC('kibetbriann@gmail.com');
        SMTPCu.Send;
        */

    end;


    procedure DetermineLeaveReturnDate(var fBeginDate: Date; var fDays: Decimal; var LvType: Code[100]) fReturnDate: Date
    begin
        varDaysApplied := Round(fDays, 1, '=');
        fReturnDate := CalcDate('<-1D>', fBeginDate);
        repeat
            if DetermineIfIncludesNonWorking(LvType/*"Leave Type"*/) = false then begin
                fReturnDate := CalcDate('1D', fReturnDate);
                if DetermineIfIsNonWorking(fReturnDate) then
                    varDaysApplied := varDaysApplied + 1
                else
                    varDaysApplied := varDaysApplied;
                varDaysApplied := varDaysApplied - 1
            end

            else begin
                fReturnDate := CalcDate('1D', fReturnDate);
                varDaysApplied := varDaysApplied - 1;
            end;
        //MESSAGE('date%1Day%2',fReturnDate,varDaysApplied);
        until varDaysApplied = 0;
        exit(fReturnDate);
    end;


    procedure DetermineIfIncludesNonWorking(var fLeaveCode: Code[20]): Boolean
    begin
        if HRLeaveTypes.Get(fLeaveCode) then begin
            if HRLeaveTypes."Inclusive of Non Working Days" = true then
                exit(true);
        end;
    end;


    procedure DetermineIfIsNonWorking(var bcDate: Date) Isnonworking: Boolean
    begin

        Customized.Reset;
        Customized.SetRange(Customized.Date, bcDate);
        if Customized.Find('-') then begin
            if Customized."Non Working" = true then
                exit(true)
            else
                exit(false);
        end;
    end;


    procedure DeterminethisLeaveEndDate(var fDate: Date) fEndDate: Date
    begin
        ReturnDateLoop := true;
        fEndDate := fDate;
        if fEndDate <> 0D then begin
            fEndDate := fEndDate;//CALCDATE('1D', fEndDate);
            while (ReturnDateLoop) do begin
                if DetermineIfIsNonWorking(fEndDate) then
                    fEndDate := CalcDate('1D', fEndDate)
                else
                    ReturnDateLoop := false;
                //MESSAGE('returnDate%1',fEndDate);
            end
        end;
        exit(fEndDate);
    end;


    procedure DeterminethisLeaveResumptionDate(var fDate: Date) fEndDate: Date
    begin
        ReturnDateLoop := true;
        fEndDate := fDate;
        if fEndDate <> 0D then begin
            fEndDate := fEndDate;//CALCDATE('1D', fEndDate);
            while (ReturnDateLoop) do begin
                if DetermineIfIsNonWorking(fEndDate) then
                    fEndDate := CalcDate('1D', fEndDate)
                else
                    ReturnDateLoop := false;
                //MESSAGE('returnDate%1',fEndDate);
            end
        end;
        exit(fEndDate);
    end;

    local procedure GetEmpUserID(EmpppNo: Code[100]): Code[100]
    var
        HRREmployees: Record Employee;
    begin
        HRREmployees.Reset;
        HRREmployees.SetRange("No.", EmpppNo);
        if HRREmployees.FindFirst then
            exit(HRREmployees."User ID");
    end;


    procedure FnPostLeave(LeaveNo: Code[10])
    var
        LRegister: Record "Employee Leave Application";
        HRLeaveApplication: Record "Employee Leave Application";
        HRLeavePeriods: Record "HR Leave Periods";
        journal: Record "HR Leave Journal Line";
    begin
        HRSetup.Get;
        LRegister.Reset;
        LRegister.SetRange(LRegister."Application No", LeaveNo);
        LRegister.SetRange(Posted, false);
        if LRegister.FindFirst then begin
            if LRegister.Status = LRegister.Status::Released then
                //IF CONFIRM('Are you sure you want to post this leave?.',TRUE,FALSE)=TRUE THEN
                //BEGIN
                HRSetup.Get();
            journal.Reset;
            journal.SetRange("Journal Template Name"/*"Journal Batch Name"*/, HRSetup."Default Leave Posting Template");
            journal.SetRange("Journal Batch Name"/*"Journal Template Name"*/, HRSetup."Positive Leave Posting Batch");
            if journal.Find('-') then
                journal.DeleteAll;

            HRLeavePeriods.Reset;
            HRLeavePeriods.SetRange(HRLeavePeriods.Closed, false);
            if HRLeavePeriods.FindLast then begin

                journal.Init;
                journal."Line No." := journal."Line No." + 1000;
                journal."Journal Batch Name" := HRSetup."Positive Leave Posting Batch";//HRSetup."Default Leave Posting Template";
                journal."Document No." := LRegister."Application No";
                journal."Journal Template Name" := HRSetup."Default Leave Posting Template";//HRSetup."Positive Leave Posting Batch";
                journal."Staff No." := LRegister."Employee No";
                journal.Validate("Staff No.");
                LRegister.TestField(LRegister."Approved Days");
                journal."No. of Days" := LRegister."Approved Days";
                journal."Leave Period" := HRLeavePeriods."Period Code";
                journal."Leave Entry Type" := journal."Leave Entry Type"::Negative;
                journal.Validate("Leave Entry Type");
                journal.Description := Format("Leave Type") + ' ' + LRegister."Employee No" + ' ' + LRegister."Application No";
                journal."Leave Type" := LRegister."Leave Type";
                journal."Posting Date" := LRegister."Application Date";
                journal."Leave Period Start Date" := LRegister."Start Date";
                journal."Leave Period End Date" := LRegister."End Date";
                journal.Validate("Leave Type");
                journal.IsMonthlyAccrued := false;
                journal.Insert;

                journal.Reset;
                journal.SetRange("Journal Template Name"/*"Journal Batch Name"*/, HRSetup."Default Leave Posting Template");
                journal.SetRange("Journal Batch Name"/*"Journal Template Name"*/, HRSetup."Positive Leave Posting Batch");
                if journal.Find('-') then begin
                    CODEUNIT.Run(CODEUNIT::"HR Leave Jnl.-Post", journal);
                end;
                if "Leave Type" = HRSetup."Annual Leave Code" then begin
                    if LRegister."Include Leave Allowance" = true then begin
                        FnPostLeaveAllowance(LRegister."Employee No", LRegister."Days Applied");
                    end;
                end;
                LRegister.Posted := true;
                LRegister."Posted By" := UserId;
                LRegister."Date Posted" := Today;
                LRegister."Time Posted" := Time;
                //LRegister.MODIFY;
            end;
        end;
        //END;
    end;

    local procedure FnPostLeaveAllowance(var EmployeeNo: Code[10]; var DaysApplieds: Decimal)
    var
        EmployeeX: Record Employee;
        AssignmentMatrix: Record "Assignment Matrix";
        HRSetup: Record "Human Resources Setup";
    begin
        HRSetup.Get();
        if EmployeeX.Get(EmployeeNo) then begin
            if DaysApplieds >= HRSetup."Leave Allowance Days" then begin
                FnGetBasicPay(EmployeeX."Salary Scale", EmployeeX.Present);
                if AssignmentMatrix.FindLast then begin
                    AssignmentMatrix.Init;
                    AssignmentMatrix."Employee No" := EmployeeNo;
                    AssignmentMatrix.Type := AssignmentMatrix.Type::Payment;
                    AssignmentMatrix.Code := HRSetup."Leave Allowance Code";
                    AssignmentMatrix.Validate(Code);
                    AssignmentMatrix.Amount := BasicSalary;
                    if AssignmentMatrix.Amount > 0 then
                        AssignmentMatrix.Insert;
                end;
                EmployeeX."Allowance Collected" := true;
                EmployeeX.Modify;
            end;
        end;
    end;

    local procedure FnSendEmails(StaffNo: Code[40]; DocumentNo: Code[40]; NumberOfDaysApplied: Integer; RelieversName: Text[100]; ApplicantsName: Text[100]; FromDate: Date; ToDate: Date)
    var
        Email: Codeunit "Email";
        EmailMessage: Codeunit "Email message";
        UserSetup: Record "User Setup";
    begin

        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."Employee No.", StaffNo);
        if UserSetup.FindFirst then begin
            EmailMessage.Create(UserSetup."E-Mail", Text1,
            'Dear ' + RelieversName + '. You have been selected as a reliever for ' + ApplicantsName + 'on leave application:' +
            Format(DocumentNo) + ', from ' + Format(FromDate) + ' to ' + Format(FromDate) + '.', false);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
            //MESSAGE('Mail Sent');
        end;
    end;

    local procedure FnGetBasicPay(var Grade: Code[10]; var Present: Code[10])
    var
        Benefits: Record "Scale Benefits";
        HRSetups: Record "Human Resources Setup";
    begin
        BasicSalary := 0;
        HRSetups.Get();
        Benefits.Reset;
        Benefits.SetRange(Benefits."Salary Scale", Grade);
        Benefits.SetRange(Benefits."Salary Pointer", Present);
        Benefits.SetRange(Benefits."ED Code", '01');
        if Benefits.Find('-') then begin
            BasicSalary := Round((1 / 3 * Benefits.Amount), 0.01, '>');
            if BasicSalary > HRSetups."Leave Allowance Limit" then
                BasicSalary := HRSetups."Leave Allowance Limit"
            else
                BasicSalary := BasicSalary;
        end;
    end;

    procedure CheckLeaveBalance()
    var
        MaxDays: Decimal;
        PrevBalance: Decimal;
        TakenDays: Decimal;
        Lentries: Record "HR Leave Ledger Entries";
        HRLeavePeriods: Record "HR Leave Periods";
    begin
        MaxDays := 0;
        TakenDays := 0;
        PrevBalance := 0;
        if ("Leave Period" <> '') and ("Leave Type" <> '') and ("Days Applied" <> 0) and ("Employee No" <> '') then begin
            //For leaves created in the last period but want to be posted this period - update period
            HRLeavePeriods.Reset;
            HRLeavePeriods.SetRange(HRLeavePeriods.Closed, false);
            if HRLeavePeriods.FindLast then begin
                if "Leave Period" <> HRLeavePeriods."Period Code" then begin
                    "Leave Period" := HRLeavePeriods."Period Code";
                    Modify;
                end;
            end;

            if "Leave Type" in ['CF', 'ANNUAL', 'CARRY FORWARD', 'SPECIAL'] then //SPECIAL
            begin
                Lentries.Reset;
                Lentries.SetRange("Staff No.", "Employee No");
                Lentries.SetFilter(Lentries."Leave Type", 'CF|ANNUAL|SPECIAL|CARRY FORWARD');
                Lentries.SetFilter(Lentries."Leave Period", "Leave Period");
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    MaxDays := Round((Lentries."No. of days"), 0.5, '=');
                end
            end else begin
                HRLeaveTypes.Reset();
                HRLeaveTypes.SetRange(Code, "Leave Type");
                HRLeaveTypes.SetFilter(Days, '>%1', 0);
                if HRLeaveTypes.FindFirst() then begin
                    MaxDays := HRLeaveTypes.Days;

                    Lentries.Reset;
                    Lentries.SetRange("Staff No.", "Employee No");
                    Lentries.SetFilter(Lentries."Leave Type", "Leave Type");
                    Lentries.SetFilter(Lentries."Leave Period", "Leave Period");
                    if Lentries.FindSet then begin
                        Lentries.CalcSums("No. of days");
                        TakenDays := Round((Lentries."No. of days"), 0.5, '=');
                    end;
                    MaxDays += TakenDays;
                end;
            end;
            if MaxDays <= 0 then
                Error('You have exhausted all your %1 leave days!', "Leave Type");
            if /*(MaxDays > 0) and*/ ("Days Applied" > MaxDays) then
                Error('Balance exceeded! You can only take a maximum of %1 %2 leave days!', MaxDays, "Leave Type");
        end;
    end;

    procedure GetLeaveTypeBalance() LeaveTypeBalance: Decimal
    var
        MaxDays: Decimal;
        PrevBalance: Decimal;
        TakenDays: Decimal;
        Lentries: Record "HR Leave Ledger Entries";
    begin
        LeaveTypeBalance := 0;
        MaxDays := 0;
        TakenDays := 0;
        PrevBalance := 0;
        if ("Leave Period" <> '') and ("Leave Type" <> '') and ("Days Applied" <> 0) and ("Employee No" <> '') then begin
            if "Leave Type" in ['CF', 'ANNUAL', 'CARRY FORWARD', 'SPECIAL'] then //SPECIAL
            begin
                Lentries.Reset;
                Lentries.SetRange("Staff No.", "Employee No");
                Lentries.SetFilter(Lentries."Leave Type", 'CF|ANNUAL|SPECIAL|CARRY FORWARD');
                Lentries.SetFilter(Lentries."Leave Period", "Leave Period");
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    LeaveTypeBalance := Round((Lentries."No. of days"), 0.5, '=');
                end
            end else begin
                HRLeaveTypes.Reset();
                HRLeaveTypes.SetRange(Code, "Leave Type");
                HRLeaveTypes.SetFilter(Days, '>%1', 0);
                if HRLeaveTypes.FindFirst() then begin
                    MaxDays := HRLeaveTypes.Days;

                    Lentries.Reset;
                    Lentries.SetRange("Staff No.", "Employee No");
                    Lentries.SetFilter(Lentries."Leave Type", "Leave Type");
                    Lentries.SetFilter(Lentries."Leave Period", "Leave Period");
                    if Lentries.FindSet then begin
                        Lentries.CalcSums("No. of days");
                        TakenDays := Round((Lentries."No. of days"), 0.5, '=');
                    end;
                    LeaveTypeBalance := MaxDays - abs(TakenDays);
                end;
            end;
        end;
        exit(LeaveTypeBalance);
    end;



    procedure CheckLeaveBalanceToDate() LeaveBalance: Decimal
    var
        MaxDays: Decimal;
        PrevBalance: Decimal;
        TakenDays: Decimal;
        Lentries: Record "HR Leave Ledger Entries";
    begin
        MaxDays := 0;
        TakenDays := 0;
        LeaveBalance := 0;
        if ("Leave Period" <> '') and ("Leave Type" <> '') and ("Employee No" <> '') then begin
            if "Leave Type" in ['CF', 'ANNUAL', 'CARRY FORWARD', 'SPECIAL'] then //SPECIAL
            begin
                Lentries.Reset;
                Lentries.SetRange("Staff No.", "Employee No");
                Lentries.SetFilter(Lentries."Leave Type", 'CF|ANNUAL|SPECIAL|CARRY FORWARD');
                Lentries.SetFilter(Lentries."Leave Period", "Leave Period");
                Lentries.SetFilter("Posting Date", '<=%1', "Application Date");
                Lentries.SetFilter("Document No.", '<>%1', "Application No");
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    LeaveBalance := Round((Lentries."No. of days"), 0.5, '=');
                end
            end else begin
                HRLeaveTypes.Reset();
                HRLeaveTypes.SetRange(Code, "Leave Type");
                HRLeaveTypes.SetFilter(Days, '>%1', 0);
                if HRLeaveTypes.FindFirst() then begin
                    MaxDays := HRLeaveTypes.Days;

                    Lentries.Reset;
                    Lentries.SetRange("Staff No.", "Employee No");
                    Lentries.SetFilter(Lentries."Leave Type", "Leave Type");
                    Lentries.SetFilter(Lentries."Leave Period", "Leave Period");
                    Lentries.SetFilter("Posting Date", '<=%1', "Application Date");
                    Lentries.SetFilter("Document No.", '<>%1', "Application No");
                    if Lentries.FindSet then begin
                        Lentries.CalcSums("No. of days");
                        TakenDays := Round((Lentries."No. of days"), 0.5, '=');
                    end;
                    LeaveBalance := MaxDays + TakenDays;
                end;
            end;
        end;
        exit(LeaveBalance);
    end;



    procedure CheckDaysAppliedToDate() TakenDays: Decimal
    var
        PrevBalance: Decimal;
        Lentries: Record "HR Leave Ledger Entries";
    begin
        TakenDays := 0;
        if ("Leave Period" <> '') and ("Leave Type" <> '') and ("Employee No" <> '') then begin
            if "Leave Type" in ['CF', 'ANNUAL', 'CARRY FORWARD', 'SPECIAL'] then //SPECIAL
            begin
                Lentries.Reset;
                Lentries.SetRange("Staff No.", "Employee No");
                Lentries.SetFilter(Lentries."Leave Type", 'CF|ANNUAL|SPECIAL|CARRY FORWARD');
                Lentries.SetFilter(Lentries."Leave Period", "Leave Period");
                Lentries.SetRange("Leave Entry Type", Lentries."Leave Entry Type"::Negative);
                Lentries.SetFilter("Posting Date", '<=%1', "Application Date");
                Lentries.SetFilter("Document No.", '<>%1', "Application No");
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    TakenDays := Round((Lentries."No. of days"), 0.5, '=');
                end
            end else begin
                /*HRLeaveTypes.Reset();
                HRLeaveTypes.SetRange(Code, "Leave Type");
                HRLeaveTypes.SetFilter(Days, '>%1', 0);
                if HRLeaveTypes.FindFirst() then begin
                    MaxDays := HRLeaveTypes.Days;*/

                Lentries.Reset;
                Lentries.SetRange("Staff No.", "Employee No");
                Lentries.SetFilter(Lentries."Leave Type", "Leave Type");
                Lentries.SetFilter(Lentries."Leave Period", "Leave Period");
                Lentries.SetRange("Leave Entry Type", Lentries."Leave Entry Type"::Negative);
                Lentries.SetFilter("Posting Date", '<=%1', "Application Date");
                Lentries.SetFilter("Document No.", '<>%1', "Application No");
                if Lentries.FindSet then begin
                    Lentries.CalcSums("No. of days");
                    TakenDays := Round((Lentries."No. of days"), 0.5, '=');
                end;
                //MaxDays += TakenDays;
                //end;
            end;
        end;
        TakenDays := Abs(TakenDays);
        exit(TakenDays);
    end;
}