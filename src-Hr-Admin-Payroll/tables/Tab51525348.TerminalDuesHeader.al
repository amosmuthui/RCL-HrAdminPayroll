table 51525348 "Terminal Dues Header"
{
    Caption = 'Terminal Dues Header';
    DataClassification = ToBeClassified;
    LookupPageId = "Open Terminal Dues";
    DrillDownPageId = "Open Terminal Dues";

    fields
    {
        field(1; "No."; Code[100])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "WB No."; Code[100])
        {
            Caption = 'WB No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                //Prevent duplicates
                if "WB No." <> '' then begin
                    TerminalDuesHdr.Reset();
                    TerminalDuesHdr.SetRange("WB No.", "WB No.");
                    TerminalDuesHdr.SetRange(Type, Type);
                    TerminalDuesHdr.SetFilter("No.", '<>%1&<>%2', "No.", '');
                    //TerminalDuesHdr.SetFilter("Approval Status", '<>%1', TerminalDuesHdr."Approval Status"::Released);
                    if TerminalDuesHdr.FindFirst() then
                        Error('Kindly use %1 document no. %2 to process for %3. The system does not allow multiple records for the same WB number!', TerminalDuesHdr.Type, TerminalDuesHdr."No.", "WB No.");
                end;
                "Full Name" := '';
                Position := '';
                "RSSB No." := '';
                Bank := '';
                "Bank Account No." := '';
                "Swift Code" := '';
                Period := '';
                "Join Date" := 0D;
                "Exit Date" := 0D;
                "Separation Reason" := '';
                "Unpaid Worked Days" := 0;
                "Untaken Leave Days" := 0;
                "Contractual Amount Currency" := '';
                "Contractual Amount" := 0;
                "Payroll Country" := '';
                "Payroll Currency" := '';
                "Final Month of Service" := '';
                "Notice Period" := '30 days';
                "Final Month" := 0D;
                "Date Processed" := 0D;
                DeleteChildren();

                if "WB No." <> '' then begin
                    Emp.Reset();
                    Emp.SetRange("No.", "WB No.");
                    if Emp.FindFirst() then begin
                        if Emp.Status <> Emp.Status::Inactive then
                            Error('You can only process %1 for inactive staff!', Type);

                        "Full Name" := Emp.FullName();
                        Emp.Validate(Position);
                        Position := Emp."Job Title";
                        "RSSB No." := Emp."NSSF No.";
                        "Join Date" := Emp."Date Of Join";
                        "Exit Date" := Emp."Date Of Leaving";
                        "Payroll Country" := Emp."Payroll Country";
                        "Payroll Currency" := Emp."Payroll Currency";
                        Bank := Emp."Bank Name";
                        "Swift Code" := Emp."SWIFT Code";
                        "Bank Account No." := Emp."Bank Account No";
                        if "Bank Account No." = '' then
                            "Bank Account No." := Emp."Bank Account No.";
                        if "Payroll Currency" = '' then
                            Validate("Payroll Country");
                        "Separation Reason" := Emp."Cause of Inactivity";
                        "Untaken Leave Days" := Emp.GetEmpLeaveBalance();

                        if Emp.Position <> '' then begin
                            CompanyJobs.Reset();
                            CompanyJobs.SetRange("Job ID", Emp.Position);
                            if CompanyJobs.FindFirst() then
                                "Notice Period" := ConvertDateFormulaToText(Format(CompanyJobs."Notice Period"));
                        end;
                        if "Notice Period" = '' then
                            "Notice Period" := '30 days';

                        EmpMovemment.Reset();
                        EmpMovemment.SetRange("Emp No.", Emp."No.");
                        EmpMovemment.SetRange(Status, EmpMovemment.Status::Current);
                        if EmpMovemment.FindFirst() then begin
                            "Contractual Amount Type" := EmpMovemment."Contractual Amount Type";
                            "Contractual Amount Currency" := EmpMovemment."Contractual Amount Currency";
                            "Contractual Amount" := EmpMovemment."Contractual Amount Value";
                            if "Exit Date" = 0D then
                                "Exit Date" := EmpMovemment."Last Date";
                            if EmpMovemment."Terminal Dues" then
                                "Unpaid Worked Days" := (EmpMovemment."Last Date" - CalcDate('-CM', EmpMovemment."Last Date")) + 1;
                        end;
                        if "Join Date" = 0D then begin
                            EmpMovemment.Reset();
                            EmpMovemment.SetRange("Emp No.", Emp."No.");
                            if EmpMovemment.FindFirst() then begin
                                "Join Date" := EmpMovemment."First Date";
                            end;
                        end;
                        if "Exit Date" <> 0D then begin
                            "Final Month of Service" := Format("Exit Date", 0, '<Month Text> <Year4>');
                            "Final Month" := CalcDate('-CM', "Exit Date");
                        end;
                        ComputeYearsInService();
                        if "Years in Service" < 1 then
                            "Notice Period" := '15 days';

                        Period := getDuration();
                        "Date Processed" := Today;
                        /*if ("Join Date" <> 0D) and ("Exit Date" <> 0D) then
                            Period := Format("Exit Date" - "Join Date");*/
                        //Add accommodation and mileage if found - treat it as a manual entry
                        "Exclude Mileage &Accommodation" := false;
                        AddMileageAndAccommodation(Emp."No.");
                        if "Payroll Country" = 'EXPATRIATE' then
                            "Exclude Mileage &Accommodation" := true;
                    end;
                end;
            end;
        }
        field(3; "Full Name"; Text[240])
        {
            Caption = 'Full Name';
        }
        field(4; Position; Text[100])
        {
            Caption = 'Position';
        }
        field(5; "RSSB No."; Code[100])
        {
            Caption = 'RSSB No.';
        }
        field(6; Bank; Text[100])
        {
            Caption = 'Bank';
        }
        field(7; Period; Text[100])
        {
            Caption = 'Period';
        }
        field(8; "Join Date"; Date)
        {
            Caption = 'Join Date';
            trigger OnValidate()
            begin
                ComputeYearsInService();
                Period := getDuration();
            end;
        }
        field(9; "Exit Date"; Date)
        {
            Caption = 'Exit Date';
            trigger OnValidate()
            begin
                ComputeYearsInService();
                Period := getDuration();
            end;
        }
        field(10; "Separation Reason"; Text[200])
        {
            Caption = 'Separation Reason';
        }
        field(11; "Unpaid Worked Days"; Decimal)
        {
            Caption = 'Unpaid Worked Days';
        }
        field(12; "Untaken Leave Days"; Decimal)
        {
            Caption = 'Untaken Leave Days';
        }
        field(13; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;

        }
        field(14; "Created By"; Code[200])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(15; "Created On"; DateTime)
        {
            Caption = 'Created On';
            Editable = false;
        }
        field(16; "Bank Account No."; Code[100])
        { }
        field(17; "Contractual Amount Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Gross Pay,Basic Pay,Net Pay';
            OptionMembers = "Gross Pay","Basic Pay","Net Pay";
        }
        field(18; "Contractual Amount Currency"; Code[30])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(19; "Contractual Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(20; "Payroll Country"; Code[100])
        {
            TableRelation = "Country/Region";
            trigger OnValidate()
            var
                SelectedCountry: Record "Country/Region";
            begin
                SelectedCountry.reset;
                SelectedCountry.setrange("Code", "Payroll Country");
                if SelectedCountry.findfirst then begin
                    "Payroll Currency" := SelectedCountry."Country Currency";
                end;
            end;
        }
        field(21; "Payroll Currency"; Code[30])
        {
            TableRelation = Currency;
        }
        field(22; "Additional Entitled Days"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Additional Entitled To"."No. of Days" where("Header No." = field("No.")));
        }
        field(23; "Final Month of Service"; Text[50])
        {
            Editable = false;
        }
        field(24; "Gross Salary"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Terminal Dues Salary Structure".Amount where("Header No." = field("No.")));
        }
        field(25; "Total Final Dues"; Decimal)
        {
            CaptionClass = GetCaption('Total');
            FieldClass = FlowField;
            CalcFormula = Sum("Terminal Dues Lines".Amount where("Header No." = field("No."), "Trans Type" = const(Earning)));
        }
        field(26; "Total Basic"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Terminal Dues Lines".Amount where("Header No." = field("No."), "Trans Type" = const(Earning), "Is Basic" = const(true)));
        }
        field(27; "Total House"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Terminal Dues Lines".Amount where("Header No." = field("No."), "Trans Type" = const(Earning), "Is House" = const(true)));
        }
        field(28; "Total Transport"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Terminal Dues Lines".Amount where("Header No." = field("No."), "Trans Type" = const(Earning), "Is Transport" = const(true)));
        }
        field(29; "Period Processed"; Date)
        {
            Caption = 'Month Processed';
            Editable = false;
            TableRelation = "Payroll Period";
        }
        field(30; Balance; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Terminal Dues Lines".Amount where("Header No." = field("No."), "Trans Type" = filter(<> Employer)));
        }
        field(31; "Total Social Security"; Decimal)
        {

        }
        field(32; "Swift Code"; Text[100])
        { }
        field(33; "Notice Period"; Text[100])
        { }
        field(34; "Notice Given"; Option)
        {
            OptionMembers = Yes,No;
        }
        field(35; "Total Deductions"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Terminal Dues Lines".Amount where("Header No." = field("No."), "Trans Type" = const(Deduction), Taxable = const(false)));
        }
        field(36; "Taxable Final Dues"; Decimal)
        {
            CaptionClass = GetCaption('Taxable');
            FieldClass = FlowField;
            CalcFormula = Sum("Terminal Dues Lines".Amount where("Header No." = field("No."), Taxable = const(true)));
        }
        field(37; "Days in Month"; Integer)
        {
            Editable = false;
        }
        field(38; "Final Month"; Date)
        {
            Editable = false;

            trigger OnValidate()
            var
                MonthFirstDate: Date;
                MonthLastDate: Date;
            begin
                if "Exit Date" <> 0D then begin
                    MonthFirstDate := CalcDate('-CM', "Exit Date");
                    MonthLastDate := CalcDate('CM', "Exit Date");
                    "Final Month" := MonthFirstDate;
                    "Days in Month" := (MonthLastDate - MonthFirstDate) + 1;
                    "Final Month of Service" := Format("Exit Date", 0, '<Month Text> <Year4>');
                end;
            end;
        }
        field(39; "Date Processed"; Date)
        {

        }
        field(40; "Fixed Processing Date"; Boolean)
        { }
        field(41; "Exchange Rate"; Decimal)
        {
            //Caption = 'USD Exchange Rate';
            CaptionClass = GetExchangeRateCaption();
            trigger OnValidate()
            begin
                if "Exchange Rate" < 0 then
                    Error('Exchange Rate cannot be less than 0!');
            end;
        }
        field(42; Type; Option)
        {
            OptionMembers = "Final Dues","Retirement Benefits";
        }
        field(43; "Years in Service"; Decimal)
        {
            Editable = false;
        }
        field(44; "Gross Salary Multiplier"; Integer)
        {
            Editable = false;
        }
        field(45; "Exclude Mileage &Accommodation"; Boolean)
        { }
        field(46; "Notice Days Given"; Integer)
        {
            MinValue = 0;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        InsertNo();

        "Created By" := UserId;
        "Created On" := CurrentDateTime;
    end;

    trigger OnDelete()
    begin
        if "Approval Status" <> "Approval Status"::Open then
            Error('You cannot delete the record at this level!');

        DeleteChildren();
    end;

    var
        TerminalDuesHdr: Record "Terminal Dues Header";
        Emp: Record Employee;
        EmpMovemment: Record "Internal Employement History";
        TDLines: Record "Terminal Dues Lines";
        SalaryStructure: Record "Terminal Dues Salary Structure";
        AdditionalEntitledTo: Record "Additional Entitled To";
        CompanyJobs: Record "Company Jobs";
        AssingmentMatrix: Record "Assignment Matrix";
        TerminalDuesLines: Record "Terminal Dues Lines";
        TerminalDuesLinesInit: Record "Terminal Dues Lines";
        LineNo: Integer;

    procedure InsertNo()
    begin
        if "No." = '' then begin
            TerminalDuesHdr.Reset();
            TerminalDuesHdr.SetRange(Type, Type);
            if TerminalDuesHdr.FindLast() then
                "No." := IncStr(TerminalDuesHdr."No.")
            else begin
                if Type = Type::"Final Dues" then
                    "No." := 'TD0001';
                if Type = Type::"Retirement Benefits" then
                    "No." := 'RB0001';
            end;
        end;
    end;

    procedure GetTotalEntitledDays() TotalEntitledDays: Integer
    var
        unPaidWorkedDaysInt: Integer;
        UnTakenLeaveDaysInt: Integer;
    begin
        CalcFields("Additional Entitled Days");
        Evaluate(unPaidWorkedDaysInt, format(Round("Unpaid Worked Days", 1)));
        Evaluate(UnTakenLeaveDaysInt, format(Round("Untaken Leave Days", 1)));
        TotalEntitledDays := /*"Unpaid Worked Days"*/unPaidWorkedDaysInt + /*"Untaken Leave Days"*/UnTakenLeaveDaysInt + "Additional Entitled Days";
        exit(TotalEntitledDays);
    end;

    procedure getDuration() Dur: Text
    var
        StockReport: Codeunit "Custom Helper Functions HR";
    begin
        Dur := '';
        if ("Join Date" <> 0D) and ("Exit Date" <> 0D) then
            Dur := StockReport.FormatDateDifferenceActual("Join Date", "Exit Date", true);
        exit(Dur);
    end;

    procedure DeleteChildren()
    begin
        TDLines.Reset();
        TDLines.SetRange("Header No.", "No.");
        TDLines.DeleteAll();

        SalaryStructure.Reset();
        SalaryStructure.SetRange("Header No.", "No.");
        SalaryStructure.DeleteAll();

        AdditionalEntitledTo.Reset();
        AdditionalEntitledTo.SetRange("Header No.", "No.");
        AdditionalEntitledTo.DeleteAll();
    end;

    procedure AddMileageAndAccommodation(WBNo: Code[100])
    var
        LastProcessedPeriod: Date;
    begin
        SalaryStructure.Reset();
        SalaryStructure.SetRange("Header No.", Rec."No.");
        SalaryStructure.SetFilter(Description, '%1|%2|%3', 'ACCOMMODATION ALLOWANCE', 'ACCOMODATION ALLOWANCES EXPATRIATES', 'MILEAGE ALLOWANCE');
        if SalaryStructure.Find('-') then
            SalaryStructure.DeleteAll();

        LastProcessedPeriod := 0D;
        AssingmentMatrix.Reset();
        AssingmentMatrix.SetRange("Employee No", WBNo);
        if AssingmentMatrix.FindLast() then
            LastProcessedPeriod := AssingmentMatrix."Payroll Period";

        if LastProcessedPeriod <> 0D then begin
            InsertNo(); //Ensure No. is inserted for some staff to be done
            LineNo := 0;
            SalaryStructure.Reset();
            if SalaryStructure.FindLast() then
                LineNo := SalaryStructure."Line No.";
            AssingmentMatrix.Reset();
            AssingmentMatrix.SetRange("Employee No", WBNo);
            AssingmentMatrix.SetRange("Payroll Period", LastProcessedPeriod);
            //AssingmentMatrix.SetRange("Non-Cash Benefit", false);
            //AssingmentMatrix.SetRange("Tax Relief", false);
            AssingmentMatrix.SetRange(Type, AssingmentMatrix.Type::Payment);
            AssingmentMatrix.SetRange("Exclude from Payroll", false);
            AssingmentMatrix.SetFilter("Transaction Title", '%1|%2|%3', 'ACCOMMODATION ALLOWANCE', 'ACCOMODATION ALLOWANCES EXPATRIATES', 'MILEAGE ALLOWANCE');
            if AssingmentMatrix.FindSet() then
                repeat
                    LineNo += 1;
                    SalaryStructure.Reset();
                    SalaryStructure.Init();
                    SalaryStructure."Header No." := Rec."No.";
                    SalaryStructure."Line No." := LineNo;
                    SalaryStructure.Currency := Rec."Payroll Currency";
                    SalaryStructure."Amount (FCY)" := AssingmentMatrix.Amount;
                    SalaryStructure.Amount := AssingmentMatrix.Amount;
                    SalaryStructure.Description := AssingmentMatrix.Description;
                    SalaryStructure."Is Basic" := AssingmentMatrix."Basic Salary Code";
                    SalaryStructure."Is House" := AssingmentMatrix."Housing Allowance";
                    SalaryStructure."Is Transport" := AssingmentMatrix."Transport Allowance";
                    SalaryStructure."Period Processed" := Rec."Period Processed";
                    SalaryStructure."System Entry" := false; //- can be replaced by user
                    SalaryStructure."Payroll Currency" := Rec."Payroll Currency";
                    SalaryStructure.Insert(true)
                until AssingmentMatrix.Next() = 0;
        end;
    end;

    procedure GetExchangeRateCaption(): Text
    var
        CurrencyCode: Code[10];
    begin
        CurrencyCode := Rec."Payroll Currency";
        if CurrencyCode = '' then
            exit('Exchange Rate');

        exit('1 USD = ? ' + CurrencyCode);
    end;

    procedure ConvertDateFormulaToText(NoticePeriod: Code[10]): Text
    var
        NumberPart: Integer;
        UnitPart: Text[1];
    begin
        if NoticePeriod = '' then
            exit('30 Days');

        // Extract the numeric part
        if not Evaluate(NumberPart, CopyStr(NoticePeriod, 1, StrLen(NoticePeriod) - 1)) then
            exit(NoticePeriod); // Return original if conversion fails

        // Extract the last character as the unit
        UnitPart := CopyStr(NoticePeriod, StrLen(NoticePeriod), 1);

        case UnitPart of
            'D':
                exit(Format(NumberPart) + ' Days');
            'W':
                exit(Format(NumberPart) + ' Weeks');
            'M':
                exit(Format(NumberPart) + ' Months');
            'Y':
                exit(Format(NumberPart) + ' Year(s)');
            else
                exit(NoticePeriod); // Return as is if format is unknown
        end;
    end;

    procedure GetCaption(Prefix: Text) FullCaption: Text
    begin
        FullCaption := Prefix + ' ' + Format(Type);
    end;

    procedure ComputeYearsInService() //Specially calculated to fit the RB process
    var
        DaysInYear: Integer;
        YearsDecimal: Decimal;
        CurrStartDate: Date;
        CurrEndDate: Date;
        Done: Boolean;
    begin
        "Years in Service" := 0;
        if ("Join Date" <> 0D) and ("Exit Date" <> 0D) then begin
            //"Years in Service" := Date2DMY("Exit Date", 3) - Date2DMY("Join Date", 3);
            //if ("Years in Service" = 0) and ("Exit Date" > "Join Date") then
            //"Years in Service" := 1;

            //Let's be very accurate, considering leap years
            CurrStartDate := "Join Date";
            CurrEndDate := DMY2Date(31, 12, Date2DMY(CurrStartDate, 3));
            Done := false;
            while (not Done) do begin
                if CurrEndDate > "Exit Date" then
                    CurrEndDate := "Exit Date";

                DaysInYear := DMY2Date(31, 12, Date2DMY(CurrStartDate, 3)) - DMY2Date(1, 1, Date2DMY(CurrStartDate, 3)) + 1;
                YearsDecimal := ((CurrEndDate - CurrStartDate) + 1) / DaysInYear;
                "Years in Service" += YearsDecimal;

                if CurrEndDate >= "Exit Date" then
                    Done := true
                else begin
                    CurrStartDate := CalcDate('1D', CurrEndDate);
                    CurrEndDate := DMY2Date(31, 12, Date2DMY(CurrStartDate, 3));
                end;
            end;
            "Years in Service" := Round("Years in Service", 0.01, '>');
        end;
    end;

}