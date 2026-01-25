codeunit 51525300 "HR Dates"
{
    trigger OnRun()
    begin
        Message('%1', Format(20190701D, 0, '<Month Text>'));//
    end;

    var
        dayOfWeek: Integer;
        weekNumber: Integer;
        year: Integer;
        weekends: Integer;
        NextDay: Date;

    procedure DetermineAge(DateOfBirth: Date; DateOfJoin: Date) AgeString: Text[45]
    var
        dayB: Integer;
        monthB: Integer;
        yearB: Integer;
        dayJ: Integer;
        monthJ: Integer;
        yearJ: Integer;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        monthsToBirth: Integer;
        D: Date;
        DateCat: Integer;
    begin
        if ((DateOfBirth <> 0D) and (DateOfJoin <> 0D)) then begin
            dayB := Date2DMY(DateOfBirth, 1);
            monthB := Date2DMY(DateOfBirth, 2);
            yearB := Date2DMY(DateOfBirth, 3);
            dayJ := Date2DMY(DateOfJoin, 1);
            monthJ := Date2DMY(DateOfJoin, 2);
            yearJ := Date2DMY(DateOfJoin, 3);
            Day := 0;
            Month := 0;
            Year := 0;
            DateCat := DateCategory(dayB, dayJ, monthB, monthJ, yearB, yearJ);
            case (DateCat) of
                1:
                    begin
                        Year := yearJ - yearB;
                        if monthJ >= monthB then
                            Month := monthJ - monthB
                        else begin
                            Month := (monthJ + 12) - monthB;
                            Year := Year - 1;
                        end;

                        if (dayJ >= dayB) then
                            Day := dayJ - dayB
                        else
                            if (dayJ < dayB) then begin
                                Day := (DetermineDaysInMonth(monthJ, yearJ) + dayJ) - dayB;
                                Month := Month - 1;
                            end;

                        AgeString := '%1  Years, %2  Months and #3## Days';
                        AgeString := StrSubstNo(AgeString, Year, Month, Day);

                    end;

                2, 3, 7:
                    begin
                        if (monthJ <> monthB) then begin
                            if monthJ >= monthB then
                                Month := monthJ - monthB
                            else
                                Month := 0;
                            // ERROR('The wrong date category!');
                        end;

                        if (dayJ <> dayB) then begin
                            if (dayJ >= dayB) then
                                Day := dayJ - dayB
                            else
                                if (dayJ < dayB) then begin
                                    Day := (DetermineDaysInMonth(monthJ, yearJ) + dayJ) - dayB;
                                    Month := Month - 1;
                                end;
                        end;

                        AgeString := '%1  Months %2 Days';
                        AgeString := StrSubstNo(AgeString, Month, Day);
                    end;
                4:
                    begin
                        Year := yearJ - yearB;
                        AgeString := '#1## Years';
                        AgeString := StrSubstNo(AgeString, Year);
                    end;
                5:
                    begin
                        if (dayJ >= dayB) then
                            Day := dayJ - dayB
                        else
                            if (dayJ < dayB) then begin
                                Day := (DetermineDaysInMonth(monthJ, yearJ) + dayJ) - dayB;
                                monthJ := monthJ - 1;
                                Month := (monthJ + 12) - monthB;
                                yearJ := yearJ - 1;
                            end;

                        Year := yearJ - yearB;
                        AgeString := '%1  Years, %2 Months and #3## Days';
                        AgeString := StrSubstNo(AgeString, Year, Month, Day);
                    end;
                6:
                    begin
                        if monthJ >= monthB then
                            Month := monthJ - monthB
                        else begin
                            Month := (monthJ + 12) - monthB;
                            yearJ := yearJ - 1;
                        end;
                        Year := yearJ - yearB;
                        AgeString := '%1  Years and #2## Months';
                        AgeString := StrSubstNo(AgeString, Year, Month);
                    end;
                else
                    AgeString := '';
            end;
        end else
            Message('For Date Calculation Enter All Applicable Dates!');
        exit;
    end;

    procedure DifferenceStartEnd(StartDate: Date; EndDate: Date) DaysValue: Integer
    var
        dayStart: Integer;
        monthS: Integer;
        yearS: Integer;
        dayEnd: Integer;
        monthE: Integer;
        yearE: Integer;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        monthsBetween: Integer;
        i: Integer;
        j: Integer;
        monthValue: Integer;
        monthEnd: Integer;
        p: Integer;
        q: Integer;
        l: Integer;
        DateCat: Integer;
        daysInYears: Integer;
        m: Integer;
        yearStart: Integer;
        t: Integer;
        s: Integer;
        WeekendDays: Integer;
        Holidays: Integer;
    begin
        if ((StartDate <> 0D) and (EndDate <> 0D)) then begin
            Day := 0;
            monthValue := 0;
            p := 0;
            q := 0;
            l := 0;
            Year := 0;
            daysInYears := 0;
            DaysValue := 0;
            dayStart := Date2DMY(StartDate, 1);
            monthS := Date2DMY(StartDate, 2);
            yearS := Date2DMY(StartDate, 3);
            dayEnd := Date2DMY(EndDate, 1);
            monthE := Date2DMY(EndDate, 2);
            yearE := Date2DMY(EndDate, 3);

            WeekendDays := 0;
            /*
            AbsencePreferences.FIND('-');
             IF (AbsencePreferences."Include Weekends" = TRUE) THEN
               WeekendDays:= DetermineWeekends(StartDate,EndDate);

            Holidays:= 0;
            AbsencePreferences.FIND('-');
             IF (AbsencePreferences."Include Holidays" = TRUE) THEN
                Holidays:= DetermineHolidays(StartDate,EndDate);
            */
            DateCat := DateCategory(dayStart, dayEnd, monthS, monthE, yearS, yearE);
            case (DateCat) of
                1:
                    begin
                        p := 0;
                        q := 0;
                        Year := yearE - yearS;
                        yearStart := yearS;
                        t := 1;
                        s := 1;
                        if (monthE <> monthS) then begin

                            for j := 1 to (monthS - 1) do begin
                                q := q + DetermineDaysInMonth(t, yearS);
                                t := t + 1;
                            end;
                            q := q + dayStart;

                            for i := 1 to (monthE - 1) do begin
                                p := p + DetermineDaysInMonth(s, yearE);
                                s := s + 1;
                            end;
                            p := p + dayEnd;

                            for m := 1 to Year do begin
                                if LeapYear(yearStart) then
                                    daysInYears := daysInYears + 366
                                else
                                    daysInYears := daysInYears + 365;
                                yearStart := yearStart + 1;
                            end;
                            DaysValue := (((daysInYears - q) + p) - WeekendDays) - Holidays;
                        end;
                    end;

                2, 7:
                    begin
                        for l := (monthS + 1) to (monthE - 1) do
                            DaysValue := DaysValue + DetermineDaysInMonth(l, yearS);
                        DaysValue := ((DaysValue + (DetermineDaysInMonth(monthS, yearS) - dayStart) + dayEnd) - WeekendDays) - Holidays;
                    end;

                3:
                    begin
                        if (dayEnd >= dayStart) then
                            DaysValue := dayEnd - dayStart - WeekendDays - Holidays
                        else
                            if (dayEnd = dayStart) then
                                DaysValue := 0
                            else
                                DaysValue := ((dayStart - dayEnd) - WeekendDays) - Holidays;

                    end;

                4:
                    begin
                        DaysValue := 0;
                        Year := yearE - yearS;
                        yearStart := yearS;
                        for m := 1 to Year do begin
                            if (LeapYear(yearStart)) then
                                daysInYears := 366
                            else
                                daysInYears := 365;
                            DaysValue := DaysValue + daysInYears;
                            yearStart := yearStart + 1;
                        end;
                        DaysValue := (DaysValue - WeekendDays) - Holidays;
                    end;

                5:
                    begin
                        Year := yearE - yearS;
                        yearStart := yearS;
                        for m := 1 to Year do begin
                            if LeapYear(yearStart) then
                                daysInYears := daysInYears + 366
                            else
                                daysInYears := daysInYears + 365;
                            yearStart := yearStart + 1;
                        end;
                        DaysValue := daysInYears;
                        if dayEnd > dayStart then
                            DaysValue := (DaysValue + (dayEnd - dayStart) - WeekendDays) - Holidays
                        else
                            if dayStart > dayEnd then
                                DaysValue := (DaysValue - (dayStart - dayEnd) - WeekendDays) - Holidays;
                    end;

                6:
                    begin
                        q := 0;
                        p := 0;
                        Year := yearE - yearS;
                        yearStart := yearS;
                        t := 1;
                        s := 1;

                        for j := 1 to monthS do begin
                            q := q + DetermineDaysInMonth(t, yearS);
                            t := t + 1;
                        end;

                        for i := 1 to monthE do begin
                            p := p + DetermineDaysInMonth(s, yearE);
                            s := s + 1;
                        end;

                        for m := 1 to Year do begin
                            if LeapYear(yearStart) then
                                daysInYears := daysInYears + 366
                            else
                                daysInYears := daysInYears + 365;
                            yearStart := yearStart + 1;
                        end;

                        DaysValue := ((daysInYears - q) + p) - WeekendDays - Holidays;
                    end;
                else
                    DaysValue := 0;

            end;
        end else
            Message('Enter all applicable dates for calculation!');
        DaysValue += 1;
        exit;

    end;

    procedure DetermineDaysInMonth(Month: Integer; Year: Integer) DaysInMonth: Integer
    begin
        case (Month) of
            1:
                DaysInMonth := 31;
            2:
                begin
                    if (LeapYear(Year)) then
                        DaysInMonth := 29
                    else
                        DaysInMonth := 28;
                end;
            3:
                DaysInMonth := 31;
            4:
                DaysInMonth := 30;
            5:
                DaysInMonth := 31;
            6:
                DaysInMonth := 30;
            7:
                DaysInMonth := 31;
            8:
                DaysInMonth := 31;
            9:
                DaysInMonth := 30;
            10:
                DaysInMonth := 31;
            11:
                DaysInMonth := 30;
            12:
                DaysInMonth := 31;
            else
                Message('Not valid date. The month must be between 1 and 12');
        end;

        exit;
    end;

    procedure DateCategory(BDay: Integer; EDay: Integer; BMonth: Integer; EMonth: Integer; BYear: Integer; EYear: Integer) Category: Integer
    begin
        if ((EYear > BYear) and (EMonth <> BMonth) and (EDay <> BDay)) then
            Category := 1
        else
            if ((EYear = BYear) and (EMonth <> BMonth) and (EDay = BDay)) then
                Category := 2
            else
                if ((EYear = BYear) and (EMonth = BMonth) and (EDay <> BDay)) then
                    Category := 3
                else
                    if ((EYear > BYear) and (EMonth = BMonth) and (EDay = BDay)) then
                        Category := 4
                    else
                        if ((EYear > BYear) and (EMonth = BMonth) and (EDay <> BDay)) then
                            Category := 5
                        else
                            if ((EYear > BYear) and (EMonth <> BMonth) and (EDay = BDay)) then
                                Category := 6
                            else
                                if ((EYear = BYear) and (EMonth <> BMonth) and (EDay <> BDay)) then
                                    Category := 7
                                else
                                    if ((EYear = BYear) and (EMonth = BMonth) and (EDay = BDay)) then
                                        Category := 3
                                    else begin
                                        Category := 0;
                                        //ERROR('The start date cannot be after the end date.');
                                    end;
        exit;
    end;

    procedure LeapYear(Year: Integer) LY: Boolean
    var
        CenturyYear: Boolean;
        DivByFour: Boolean;
    begin
        CenturyYear := Year mod 100 = 0;
        DivByFour := Year mod 4 = 0;
        if ((not CenturyYear and DivByFour) or (Year mod 400 = 0)) then
            LY := true
        else
            LY := false;
    end;

    procedure ReservedDates(NewStartDate: Date; NewEndDate: Date; EmployeeNumber: Code[20]) Reserved: Boolean
    var
        OK: Boolean;
    begin
        /*
        AbsenceHoliday.SETFILTER("Employee No.",EmployeeNumber);
        OK:= AbsenceHoliday.FIND('-');
        REPEAT
            IF (NewStartDate > AbsenceHoliday."Start Date") AND (NewStartDate < AbsenceHoliday."End Date") THEN
               Reserved := TRUE
            ELSE
            IF (NewEndDate < AbsenceHoliday."End Date") AND (NewEndDate > AbsenceHoliday."Start Date") THEN
               Reserved := TRUE
            ELSE
            IF (NewStartDate > AbsenceHoliday."Start Date") AND (NewEndDate < AbsenceHoliday."End Date") THEN
               Reserved := TRUE
            ELSE Reserved := FALSE;

        UNTIL AbsenceHoliday.NEXT = 0;
        */

    end;

    procedure DetermineWeekends(DateStart: Date; DateEnd: Date) Weekends: Integer
    begin
        Weekends := 0;
        while (DateStart <= DateEnd) do begin
            dayOfWeek := Date2DWY(DateStart, 1);
            if (dayOfWeek = 6) or (dayOfWeek = 7) then
                Weekends := Weekends + 1;
            NextDay := CalculateNextDay(DateStart);
            DateStart := NextDay;
        end;
    end;

    procedure CalculateNextDay(Date: Date) NextDate: Date
    var
        today: Integer;
        month: Integer;
        year: Integer;
        nextDay: Integer;
        daysInMonth: Integer;
    begin
        today := Date2DMY(Date, 1);
        month := Date2DMY(Date, 2);
        year := Date2DMY(Date, 3);
        daysInMonth := DetermineDaysInMonth(month, year);
        nextDay := today + 1;
        if (nextDay > daysInMonth) then begin
            nextDay := 1;
            month := month + 1;
            if (month > 12) then begin
                month := 1;
                year := year + 1;
            end;
        end;
        NextDate := DMY2Date(nextDay, month, year);
    end;

    procedure DetermineHolidays(DateStart: Date; DateEnd: Date) Holiday: Integer
    var
        NextDay: Date;
    begin
        Holiday := 0;
        while (DateStart <= DateEnd) do begin
            dayOfWeek := Date2DWY(DateStart, 1);
            /*
            StatutoryHoliday.FIND('-');
            REPEAT
             IF (DateStart = StatutoryHoliday."Holiday Date") THEN
                Holiday:= Holiday + StatutoryHoliday."Duration Of Holiday";

            UNTIL StatutoryHoliday.NEXT = 0;
            */
            NextDay := CalculateNextDay(DateStart);
            DateStart := NextDay;
        end;

    end;

    procedure CheckDateStatus(CalendarCode: Code[10]; TargetDate: Date; var Description: Text[50]): Boolean
    var
        BaseCalChangeCopy: Record "HR Calendar List";
    begin
        BaseCalChangeCopy.Reset;
        BaseCalChangeCopy.SetRange(Code, CalendarCode);
        if BaseCalChangeCopy.FindSet then
            repeat
                case BaseCalChangeCopy."Recurring System" of
                    BaseCalChangeCopy."Recurring System"::" ":
                        if TargetDate = BaseCalChangeCopy.Date then begin
                            Description := BaseCalChangeCopy.Reason;
                            exit(BaseCalChangeCopy."Non Working");
                        end;
                    BaseCalChangeCopy."Recurring System"::"Weekly Recurring":
                        if Format(Date2DWY(TargetDate, 1)) = BaseCalChangeCopy.Day then begin
                            Description := BaseCalChangeCopy.Reason;
                            exit(BaseCalChangeCopy."Non Working");
                        end;
                    BaseCalChangeCopy."Recurring System"::"Annual Recurring":
                        if (Date2DMY(TargetDate, 2) = Date2DMY(BaseCalChangeCopy.Date, 2)) and
                           (Date2DMY(TargetDate, 1) = Date2DMY(BaseCalChangeCopy.Date, 1))
                        then begin
                            Description := BaseCalChangeCopy.Reason;
                            exit(BaseCalChangeCopy."Non Working");
                        end;
                end;
            until BaseCalChangeCopy.Next = 0;
        Description := '';
    end;
}
