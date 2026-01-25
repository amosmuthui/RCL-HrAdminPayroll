table 51525328 "Leave Recall"
{
    DrillDownPageID = "Leave Recalls List";
    LookupPageID = "Leave Recalls List";

    fields
    {
        field(1; "Employee No"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Emp.Get("Employee No") then begin
                    "Employee Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                    if Emp."Contract Number" <> '' then
                        "Contract No." := Emp."Contract Number";
                end;
            end;
        }
        field(3; Date; Date)
        {
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(4; Approved; Boolean)
        {

            trigger OnValidate()
            begin

                /*LeaveTypes1.Reset;
                LeaveTypes1.SetRange(LeaveTypes1."Off/Holidays Days Leave", true);
                if LeaveTypes1.Find('-') then;
                "Employee Leave".Reset;
                "Employee Leave".SetRange("Employee Leave"."Employee No", "Employee No");
                "Employee Leave".SetRange("Employee Leave"."Leave Code", LeaveTypes1.Code);
                if "Employee Leave".Find('-') then;
                if Approved = true then begin
                    ;
                    "Employee Leave".Balance := "Employee Leave".Balance + 1;
                    "Employee Leave".Modify;
                end
                else begin
                    "Employee Leave".Balance := "Employee Leave".Balance - 1;
                    "Employee Leave".Modify;
                end;*/
            end;
        }
        field(5; "Leave Application"; Code[20])
        {
            TableRelation = "Employee Leave Application" WHERE(Status = CONST(Released), "Leave Period" = field("Leave Period"));//,"Leave Type" = FILTER(<> 'SICK' | <> 'MATERNITY'));

            trigger OnValidate()
            var
                "Resumption Date": Date;
            begin

                GeneralOptions.Get;
                LeaveApplication.Reset;
                if LeaveApplication.Get("Leave Application") then begin
                    if LeaveApplication."Approved Days" < "No. of Off Days" then
                        Error('The days you are trying to recall for %1 are more than the leave days applied they for', "Employee Name");
                    NoOfDaysOff := 0;
                    /*if LeaveApplication."End Date" <> 0D then begin
                        NextDate := "Recall Date";
                        repeat
                            if not CalendarMgmt.CheckDateStatus(GeneralOptions."Base Calendar Code", NextDate, Description) then
                                NoOfDaysOff := NoOfDaysOff + 1;

                            NextDate := CalcDate('1D', NextDate);
                        until NextDate = LeaveApplication."End Date";
                    end;

                    //end;
                    "No. of Off Days" := NoOfDaysOff;*/

                    /*LeaveApplication.Reset;
                    if LeaveApplication.Get("Leave Application") then begin*/
                    //  NoOfDaysOff:=0;
                    "Leave Start Date" := LeaveApplication."Start Date";
                    "Leave Ending Date" := LeaveApplication."End Date";
                    "Leave Type" := LeaveApplication."Leave Type";
                    "Employee No" := LeaveApplication."Employee No";
                    "Employee Name" := LeaveApplication."Employee Name";
                    "Directorate Code" := LeaveApplication."Directorate Code";
                    "Leave Days" := LeaveApplication."Approved Days";

                    DimensionsValue.Reset;
                    DimensionsValue.SetRange(DimensionsValue."Dimension Code", 'DEPARTMENT');
                    DimensionsValue.SetRange(DimensionsValue.Code, LeaveApplication."Department Code");
                    if DimensionsValue.Find('-') then
                        "Department Name" := DimensionsValue.Name;
                    DimensionsValue.Reset;
                    DimensionsValue.SetRange(DimensionsValue."Dimension Code", 'DIRECTORATE');
                    DimensionsValue.SetRange(DimensionsValue.Code, LeaveApplication."Directorate Code");
                    if DimensionsValue.Find('-') then
                        "Directorate Name" := DimensionsValue.Name;

                    //Do the processing here
                    if ("Recalled From" <> 0D) and ("No. of Off Days" <> 0) then begin
                        if not (("Recalled From" >= "Leave Start Date") and ("Recalled From" <= "Leave Ending Date")) then
                            Error('The Recall From date should fall within the leave start and end dates!');
                        //Get recall to based on the leave type's
                        "Resumption Date" := LeaveApplication.DetermineLeaveReturnDate("Recalled From", "No. of Off Days", "Leave Type");
                        "Recalled To" := LeaveApplication.DeterminethisLeaveEndDate("Resumption Date");

                        if "Recalled To" > "Leave Ending Date" then
                            Error('The "Recalled To" date cannot exceed the leave end date. Kindly adjust the "Recall From" date and days accordingly!', "Recalled To", "Leave Ending Date");
                    end;
                end;
            end;
        }
        field(6; "Recall Date"; Date)
        {
            Editable = false;
            trigger OnValidate()
            begin
                //Validate("Leave Application");
            end;
        }
        field(7; "No. of Off Days"; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            begin
                Validate("Leave Application");
                /*LeaveApplication.Reset;
                LeaveApplication.SetRange(LeaveApplication."Application No", "Leave Application");
                if LeaveApplication.Find('-') then
                    if LeaveApplication."Days Applied" < "No. of Off Days" then
                        Error('The days you are trying to recall for %1 are more than the leave days applied they for', "Employee Name");*/
            end;
        }
        field(8; "Leave Ending Date"; Date)
        {
            Editable = false;
        }
        field(9; "Maturity Date"; Date)
        {
        }
        field(10; "No. Series"; Code[10])
        {
        }
        field(11; "Employee Name"; Text[50])
        {
        }
        field(12; "No."; Code[20])
        {
        }
        field(13; Status; Option)
        {
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(14; "Fiscal Start Date"; Date)
        {
        }
        field(15; "Recalled By"; Code[50])
        {
            TableRelation = Employee;
            Editable = false;

            trigger OnValidate()
            begin
                /*if Emp.Get("Recalled By") then begin
                    Name := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                    DimensionsValue.Reset;
                    DimensionsValue.SetRange("Global Dimension No.", 2);
                    DimensionsValue.SetRange(Code, Emp."Global Dimension 2 Code");
                    if DimensionsValue.FindLast then
                        "Head Of Department" := DimensionsValue.Name;
                end;*/
            end;
        }
        field(16; Name; Text[50])
        {
            Editable = false;
        }
        field(17; "Reason for Recall"; Text[130])
        {
        }
        field(18; "Head Of Department"; Text[100])
        {
        }
        field(20; "Recalled From"; Date)
        {
            NotBlank = false;

            trigger OnValidate()
            begin
                Validate("Leave Application");
                /*GeneralOptions.Get;
                if "Recalled From" <> 0D then
                    d := "Recalled From";

                NotworkingDaysRecall := 0;
                FullDays := Round("No. of Off Days", 1, '<');
                HalfDays := "No. of Off Days" - FullDays;

                if ("No. of Off Days" <> 0) and ("No. of Off Days" >= 1) then begin
                    repeat
                        if not CalendarMgmt.CheckDateStatus(GeneralOptions."Base Calendar Code", d, Description) then
                            NotworkingDaysRecall := NotworkingDaysRecall + 1;

                        LeaveApplication.Reset;
                        if LeaveApplication.Get("Leave Application") then
                            LeaveCode := LeaveApplication."Leave Type";

                        if LeaveTypes.Get(LeaveCode) then begin
                            if LeaveTypes."Inclusive of Holidays" then begin
                                BaseCalendar.Reset;
                                BaseCalendar.SetRange(BaseCalendar."Base Calendar Code", GeneralOptions."Base Calendar Code");
                                BaseCalendar.SetRange(BaseCalendar.Date, d);
                                BaseCalendar.SetRange(BaseCalendar.Nonworking, true);
                                BaseCalendar.SetRange(BaseCalendar."Recurring System", BaseCalendar."Recurring System"::"Annual Recurring");
                                if BaseCalendar.Find('-') then begin
                                    NotworkingDaysRecall := NotworkingDaysRecall + 1;
                                end;

                            end;

                            if LeaveTypes."Inclusive of Saturday" then begin
                                BaseCalender.Reset;
                                BaseCalender.SetRange(BaseCalender."Period Type", BaseCalender."Period Type"::Date);
                                BaseCalender.SetRange(BaseCalender."Period Start", d);
                                BaseCalender.SetRange(BaseCalender."Period No.", 6);

                                if BaseCalender.Find('-') then begin
                                    NotworkingDaysRecall := NotworkingDaysRecall + 1;
                                end;
                            end;

                            if LeaveTypes."Inclusive of Sunday" then begin
                                BaseCalender.Reset;
                                BaseCalender.SetRange(BaseCalender."Period Type", BaseCalender."Period Type"::Date);
                                BaseCalender.SetRange(BaseCalender."Period Start", d);
                                BaseCalender.SetRange(BaseCalender."Period No.", 7);
                                if BaseCalender.Find('-') then begin
                                    NotworkingDaysRecall := NotworkingDaysRecall + 1;
                                end;
                            end;


                            if LeaveTypes."Off/Holidays Days Leave" then
                                ;

                        end;

                        d := CalcDate('1D', d);

                    until NotworkingDaysRecall = FullDays;
                    "Recalled To" := d - 1;
                end else
                    if ("No. of Off Days" <> 0) and ("No. of Off Days" < 1) then begin
                        "Recalled To" := "Recalled From";
                    end;

                if "Recalled To" <> 0D then
                    Validate("Recalled To");*/
            end;
        }
        field(21; "Recalled To"; Date)
        {
            NotBlank = false;

            trigger OnValidate()
            begin
                /*if ("Recalled To" = "Recalled From") then
                    "No. of Off Days" := 1

                else begin

                    GeneralOptions.Get;
                    if LeaveApplication.Get("Leave Application") then begin
                        NoOfDaysOff := 1;
                        "Leave Ending Date" := LeaveApplication."End Date";
                        if LeaveApplication."End Date" <> 0D then begin
                            NextDate := "Recalled From";
                            repeat
                                if not CalendarMgmt.CheckDateStatus(GeneralOptions."Base Calendar Code", NextDate, Description) then
                                    NoOfDaysOff := NoOfDaysOff + 1;

                                NextDate := CalcDate('1D', NextDate);
                            until NextDate = "Recalled To";
                        end;

                    end;
                    "No. of Off Days" := NoOfDaysOff;
                end;*/
            end;
        }
        field(22; "Department Name"; Text[80])
        {
        }
        field(23; "Contract No."; Code[50])
        {
        }
        field(24; "Directorate Code"; Code[10])
        {
        }
        field(25; "Directorate Name"; Text[80])
        {
        }
        field(26; "Leave Days"; Integer)
        {
            Editable = false;
        }
        field(27; Posted; Boolean)
        {
            Editable = false;
        }
        field(28; "Posting DateTime"; DateTime)
        {
            Editable = false;
        }
        field(29; "Leave Start Date"; Date)
        {
            Editable = false;
        }
        field(30; "Leave Type"; Code[100])
        {
            Editable = false;
        }
        field(31; "Leave Period"; Code[100])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No", "Maturity Date")
        {
            SumIndexFields = "No. of Off Days";
        }
        key(Key3; "Employee No", "Contract No.")
        {
            SumIndexFields = "No. of Off Days";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        HRLeavePeriods: Record "HR Leave Periods";
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Leave Recall Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Leave Recall Nos");
        end;

        Date := Today;
        "Recall Date" := Today;

        "Recalled By" := UserId();
        /*if UserSetup.Get(UserId) then begin
            "Recalled By" := UserSetup."Employee No.";
            Validate("Recalled By");
        end;*/

        /*FindMaturityDate;
        "Maturity Date" := MaturityDate;
        "Fiscal Start Date" := FiscalStart;*/
        HRLeavePeriods.Reset;
        HRLeavePeriods.SetRange(HRLeavePeriods.Closed, false);
        if HRLeavePeriods.FindLast then
            "Leave Period" := HRLeavePeriods."Period Code"
        else
            Error('There is no open leave period!');
    end;


    trigger OnModify()
    begin
        //Message('You are modifying leave recall data for %1 are you sure you want to do this', "Employee Name");
    end;

    var
        Holidays: Record "Holidays_Off Days";
        "Employee Leave": Record "Employee Leave Entitlement";
        LeaveTypes1: Record "Leave Types";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        UserSetup: Record "User Setup";
        FiscalStart: Date;
        MaturityDate: Date;
        Emp: Record Employee;
        LeaveApplication: Record "Employee Leave Application";
        NextDate: Date;
        NoOfDaysOff: Decimal;
        CalendarMgmt: Codeunit "Calendar Management";
        GeneralOptions: Record "Company Information";
        Description: Text[30];
        BaseCalender: Record Date;
        NonWorkingDay: Boolean;
        NotworkingDaysRecall: Integer;
        LeaveTypes: Record "Leave Types";
        BaseCalendar: Record "Base Calendar Change";
        d: Date;
        DimensionsValue: Record "Dimension Value";
        LeaveCode: Code[30];
        FullDays: Decimal;
        HalfDays: Decimal;
        GLSetup: Record "General Ledger Setup";
        GLBudgets: Record "G/L Budget Name";


    procedure FindMaturityDate()
    var
        AccPeriod: Record "Accounting Period";
    begin
        GLSetup.Reset;
        GLSetup.Get;
        GLSetup.TestField("Current Budget");
        GLBudgets.Reset;
        GLBudgets.Get(GLSetup."Current Budget");
        GLBudgets.TestField("Start Date");
        GLBudgets.TestField("End Date");
        "Fiscal Start Date" := GLBudgets."Start Date";
        "Maturity Date" := GLBudgets."End Date";
    end;
}