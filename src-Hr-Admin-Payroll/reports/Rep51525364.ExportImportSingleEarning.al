report 51525364 "Export Import Single Earning"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Empl; Employee)
        {
            //Indentation := 1;
            RequestFilterFields = "Payroll Country", "No.", "Responsibility Center", "Sub Responsibility Center";

            trigger OnAfterGetRecord()
            begin
                TransactionCurrency := '';
                //If we are in this area it means we are exporting
                /*if Empl.getfilter("Payroll Country") = '' then
                    error('You must select payroll country because the transactions vary from country to country!');*/
                SelectedCountry := Empl.getfilter("Payroll Country");
                Window.UPDATE(1, Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name"/*PayProcessHeader."Payroll Period"*/);

                Earnings.RESET;
                Earnings.SetRange("Universal Title"/*Code*/, SelectedEarningTitle);
                Earnings.setrange(Country, Empl."Payroll Country");
                IF not Earnings.FindFirst() THEN
                    CurrReport.Skip() //Error('Unfortunately we cannot find any earning with code %1 and country %2! Kindly check again.', SelectedEarningTitle, Empl."Payroll Country")
                else begin
                    if not HeadingsCaptured then begin
                        //Create the first row - just capture the pay period on the first column and the earning code and description on the second column
                        ExcelBuffer.AddColumn(PayrollPeriod, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(Earnings.Description /*+ ' (' + SelectedEarningTitle + ')'*/, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        SelectedEarningDescription := Earnings.Description;

                        //2nd row has the other headings
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn('Emp No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Country', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Earning Title', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Earning Type', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Net Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Gross Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Start Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('End Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Full Month Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Overtime Hours', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Overtime Minutes', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Overtime Period', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                        HeadingsCaptured := true;
                    end;
                    //Headings done

                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(Empl."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Empl."Payroll Country", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(SelectedEarningTitle, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    //Capture the earnings for this employee and period
                    Amount := 0;
                    NetAmount := 0;
                    FullMonthAmount := 0;
                    StartDate := 0D;
                    OvertimePeriod := 0D;
                    EndDate := 0D;
                    OvertimeHours := 0;
                    OvertimeMinutes := 0;
                    EarningType := EarningType::Gross;
                    AssignmentMatrix.RESET;
                    AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                    AssignmentMatrix.SETRANGE("Transaction Title"/*Code*/, SelectedEarningTitle);
                    AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                    AssignmentMatrix.setrange(Country, Empl."Payroll Country");
                    IF AssignmentMatrix.FINDFIRST THEN begin
                        Amount := AssignmentMatrix.Amount;
                        NetAmount := AssignmentMatrix."Net Amount";
                        EarningType := AssignmentMatrix."Amount Type";
                        if AssignmentMatrix."Amount In FCY" <> 0 then
                            Amount := AssignmentMatrix."Amount In FCY";
                        TransactionCurrency := AssignmentMatrix."Earning Currency";
                        StartDate := AssignmentMatrix."Start Date";
                        OvertimePeriod := AssignmentMatrix."Overtime Period";
                        EndDate := AssignmentMatrix."End Date";
                        FullMonthAmount := AssignmentMatrix."Full Month Amount";
                        OvertimeHours := AssignmentMatrix."Overtime Hours";
                        OvertimeMinutes := AssignmentMatrix."Overtime Minutes";

                    end;
                    if (TransactionCurrency = '') then
                        TransactionCurrency := Empl."Payroll Currency";


                    IF (Earnings."Is Contractual Amount") /*and (not Earnings."Goes to Matrix")*/ THEN BEGIN
                        Employee.RESET;
                        Employee.SETRANGE("No.", Empl."No.");
                        IF Employee.FINDFIRST THEN BEGIN
                            Amount := Employee."Assigned Gross Pay";
                            TransactionCurrency := Empl."Contractual Amount Currency";
                        END;
                    END;
                    ExcelBuffer.AddColumn(TransactionCurrency, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(EarningType, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(NetAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Amount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(StartDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(EndDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(FullMonthAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(OvertimeHours, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(OvertimeMinutes, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(OvertimePeriod, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                END;
            end;


            trigger OnPostDataItem()
            var
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                if (Direction = Direction::Export) then begin
                    Window.CLOSE;
                    ExcelBuffer.SetFriendlyFilename('Earning ' + SelectedEarningDescription + ' for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2> <Year4>') + ' - ' + SelectedCountry);
                    HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, 'Earning ' + SelectedEarningDescription + ' as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2>, <Year4>'), '');
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (Direction = Direction::Export) then begin
                    Window.OPEN('Preparing export data for #######1');
                    ExcelBuffer.DELETEALL;
                    HeadingsCaptured := false;
                    if (SelectedEarningTitle = '') then
                        Error('You must select an earning!');
                    Empl.SETRANGE(Status, Empl.Status::Active);
                end;
                if (Direction = Direction::Import) then begin
                    Window.OPEN('Preparing import data for #######1');
                    ExcelBuffer.DELETEALL;

                    //ERROR('MaxColNo =>'+FORMAT(MaxColNo));
                    EVALUATE(PayPeriod, GetValueAtCell(ExcelBuffer, 1, 1));

                    PayPeriods.RESET;
                    PayPeriods.SETRANGE("Starting Date", PayrollPeriod/*PayPeriod*/);
                    PayPeriods.SETRANGE(Closed, TRUE);
                    IF PayPeriods.FINDFIRST THEN
                        ERROR('You can only import data for an open period!');
                    Window.UPDATE(1, PayrollPeriod);

                    Empl.SETRANGE("No.", 'XYZXYZ');//When importing, don't fetch any employee. We'll follow the excel

                    //For importing, let's try to finish everything here
                    UPLOADINTOSTREAM('Please choose excel file', '', '', FromFile, IStream);
                    IF FromFile <> '' THEN BEGIN
                        FileName := FileMgt.GetFileName(FromFile);
                        SheetName := ExcelBuffer.SelectSheetsNameStream(IStream);
                    END ELSE
                        ERROR('Excel file not found!');

                    ExcelBuffer.RESET;
                    ExcelBuffer.DELETEALL;
                    ExcelBuffer.OpenBookStream(IStream, SheetName);
                    ExcelBuffer.ReadSheet;

                    RowNo := 0;
                    ColNo := 0;
                    MaxRowNo := 0;
                    MaxColNo := 0;
                    LineNo := 0;
                    ImpEmpNo := '';
                    ImpCountry := '';
                    ImpTransTitle := '';
                    ImpCurrencyCode := '';

                    ExcelBuffer.RESET;
                    IF ExcelBuffer.FINDLAST THEN BEGIN
                        MaxRowNo := ExcelBuffer."Row No.";
                        MaxColNo := ExcelBuffer."Column No.";
                    END;

                    FOR RowNo := 3 TO MaxRowNo DO BEGIN
                        ImpEmpNo := GetValueAtCell(ExcelBuffer, RowNo, 1);
                        ImpCountry := GetValueAtCell(ExcelBuffer, RowNo, 3);
                        ImpTransTitle := GetValueAtCell(ExcelBuffer, RowNo, 4);
                        ImpCurrencyCode := GetValueAtCell(ExcelBuffer, RowNo, 5);
                        Amount := 0;
                        NetAmount := 0;
                        FullMonthAmount := 0;
                        StartDate := 0D;
                        OvertimePeriod := 0D;
                        EndDate := 0D;
                        OvertimeHours := 0;
                        OvertimeMinutes := 0;
                        EarningType := EarningType::Gross;

                        IF UpperCase(GetValueAtCell(ExcelBuffer, RowNo, 6)) = 'NET'/*'Net'*/ THEN
                            EarningType := EarningType::Net;

                        IF GetValueAtCell(ExcelBuffer, RowNo, 7) <> '' THEN
                            EVALUATE(NetAmount, GetValueAtCell(ExcelBuffer, RowNo, 7));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 8) <> '' THEN
                            EVALUATE(Amount, GetValueAtCell(ExcelBuffer, RowNo, 8));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 9) <> '' THEN
                            EVALUATE(StartDate, GetValueAtCell(ExcelBuffer, RowNo, 9));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 10) <> '' THEN
                            EVALUATE(EndDate, GetValueAtCell(ExcelBuffer, RowNo, 10));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 11) <> '' THEN
                            EVALUATE(FullMonthAmount, GetValueAtCell(ExcelBuffer, RowNo, 11));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 12) <> '' THEN
                            EVALUATE(OvertimeHours, GetValueAtCell(ExcelBuffer, RowNo, 13));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 13) <> '' THEN
                            EVALUATE(OvertimeMinutes, GetValueAtCell(ExcelBuffer, RowNo, 13));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 14) <> '' THEN
                            EVALUATE(OvertimePeriod, GetValueAtCell(ExcelBuffer, RowNo, 14));

                        if ImpEmpNo <> '' then //Emp no must have a value
                            InsertMatrix(ImpEmpNo, ImpCountry, ImpTransTitle, ImpCurrencyCode, PayPeriod, ABS(Amount), EarningType, ABS(NetAmount), StartDate, EndDate, ABS(FullMonthAmount), abs(OvertimeHours), abs(OvertimeMinutes), OvertimePeriod);

                    END;
                    Window.CLOSE;
                    MESSAGE('Import successful!');
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
                field(Direction; Direction)
                {
                    Caption = 'Direction';
                }
                field(PayrollPeriod; PayrollPeriod)
                {
                    Caption = 'Pay Period';
                    TableRelation = "Payroll Period"."Starting Date" WHERE(Closed = FILTER(false));
                }
                field(Earning; SelectedEarningTitle)
                {
                    TableRelation = "Payroll Universal Trans Codes".Title Where("Transaction Type" = filter(Earning));
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

    local procedure GetValueAtCell(var TempExcelBuffer: Record "Excel Buffer" temporary; rowNo: Integer; colNo: Integer): Text
    begin
        TempExcelBuffer.RESET;
        IF TempExcelBuffer.GET(rowNo, colNo) THEN
            EXIT(TempExcelBuffer."Cell Value as Text")
        ELSE
            EXIT('');
    end;

    local procedure InsertMatrix(EmployeeNo: Code[30]; EmpCountry: Code[30]; TransactionTitle: Code[100]; "CurrencyCode": Code[100]; PayrollPeriodFromFile: Date; TransAmount: Decimal; EarnType: Option Gross,Net; NetAmt: Decimal; StartDt: Date; EndDt: Date; FullMonthAmt: Decimal; OvtmHours: Decimal; OvtmMinutes: Decimal; OvtmPeriod: Date)
    var
        MovementTable: Record "Internal Employement History";
    begin
        Earnings.RESET;
        Earnings.SETRANGE("Universal Title"/*Code*/, TransactionTitle);
        Earnings.SetRange(Country, EmpCountry);
        IF Earnings.FINDFIRST THEN BEGIN
            //MESSAGE('2');
            AssignmentMatrix.RESET;
            AssignmentMatrix.SETRANGE("Employee No", EmployeeNo);
            AssignmentMatrix.SETRANGE(Code/*"Transaction Title"*/, Earnings.Code/*TransactionTitle*/);
            AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
            AssignmentMatrix.SetRange(Country, EmpCountry);
            AssignmentMatrix.DELETEALL;

            AssignmentMatrix.RESET;
            AssignmentMatrix.INIT;
            AssignmentMatrix.Code := Earnings.Code;
            AssignmentMatrix."Transaction Title" := TransactionTitle;
            AssignmentMatrix.Country := EmpCountry;
            AssignmentMatrix."Pay Type" := Earnings."Pay Type";
            AssignmentMatrix.Type := AssignmentMatrix.Type::Payment;
            AssignmentMatrix.Description := Earnings.Description;
            AssignmentMatrix."Employee No" := EmployeeNo;
            AssignmentMatrix."Payroll Period" := PayrollPeriod;
            AssignmentMatrix.VALIDATE(Code);
            AssignmentMatrix.VALIDATE("Employee No");
            AssignmentMatrix."Amount Type" := EarnType;
            AssignmentMatrix."Net Amount" := NetAmt;

            if Earnings."Calculation Method" = Earnings."Calculation Method"::"Flat amount" then begin
                AssignmentMatrix."Earning Currency" := CurrencyCode;
                AssignmentMatrix."Amount In FCY" := TransAmount;
                AssignmentMatrix."Start Date" := StartDt;
                AssignmentMatrix."End Date" := EndDt;
                AssignmentMatrix."Full Month Amount" := FullMonthAmt;
                AssignmentMatrix.Validate("Start Date"/*"Full Month Amount"*/);
                AssignmentMatrix.Validate("Amount In FCY");
            end;
            AssignmentMatrix.Taxable := Earnings.Taxable;
            IF (Earnings."Is Contractual Amount") and (TransAmount > 0) THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("No.", EmployeeNo);
                Employee.setrange("Payroll Country", EmpCountry);
                IF Employee.FINDFIRST THEN BEGIN
                    Employee."Contractual Amount Currency" := CurrencyCode;
                    Employee."Assigned Gross Pay" := TransAmount;
                    //Employee.Validate("Assigned Gross Pay"); //To update the staff movement data if it has just one entry
                    //If contractual amount, update staff movement
                    MovementTable.Reset();
                    MovementTable.SetRange("Emp No.", EmployeeNo);
                    MovementTable.SetRange(Status, MovementTable.Status::Current);
                    if MovementTable.FindFirst() then begin
                        MovementTable."Contractual Amount Currency" := CurrencyCode;
                        MovementTable."Contractual Amount Value" := TransAmount;
                        MovementTable.Modify();
                    end;
                    Employee."Skip Processing Housing Levy" := TRUE; //for skipping arrears
                    Employee.Validate("Payroll Country");//So that the payroll currency is updated
                    Employee.MODIFY;
                END;
            END;
            if (TransactionTitle = 'OVERTIME ALLOWANCE') then begin
                TransAmount := 0; //Ensure it'll not be inserted if sectors not provided
                if ((OvtmHours <> 0) or (OvtmMinutes <> 0)) then begin
                    TransAmount := 1;
                    if OvtmPeriod = 0D then
                        OvtmPeriod := PayrollPeriod;
                    AssignmentMatrix."Overtime Period" := OvtmPeriod;
                    AssignmentMatrix."Overtime Hours" := OvtmHours;
                    AssignmentMatrix."Overtime Minutes" := OvtmMinutes;
                    AssignmentMatrix.Validate("Overtime Minutes");
                end;
            end;
            IF (TransAmount <> 0) or (NetAmt <> 0) or (FullMonthAmt <> 0) THEN
                AssignmentMatrix.INSERT(true); //if not AssignmentMatrix.INSERT(true) then AssignmentMatrix.Modify(true);
        END;

    END;

    /*trigger OnPreReport()
    begin
        if (SelectedEarningTitle = '') then
            Error('You must select an earning!');
    end;*/

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Earnings: Record "Earnings";
        Employee: Record "Employee";
        Deductions: Record "Deductions";
        EmployeeRec: Record "Employee";
        AssignmentMatrix: Record "Assignment Matrix";
        Amount: Decimal;
        Window: Dialog;
        AccessibleCompanies: Text;
        LineNo: Integer;
        HeadingsCaptured: Boolean;
        PayrollPeriod: Date;
        SelectedCountry: Code[50];
        Direction: Option Export,Import;
        SelectedEarningTitle: Code[50];
        SelectedEarningDescription: Text[250];
        TransactionCurrency: Code[50];
        PayPeriods: Record "Payroll Period";
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[200];
        FileName: Text[200];
        SheetName: Text[200];
        RowNo: Integer;
        ColNo: Integer;
        MaxRowNo: Integer;
        MaxColNo: Integer;
        PayPeriod: Date;
        ImpEmpNo: Code[50];
        ImpCountry: Code[50];
        ImpTransTitle: Code[50];
        ImpCurrencyCode: Code[50];
        NetAmount: Decimal;
        FullMonthAmount: Decimal;
        StartDate: Date;
        OvertimePeriod: Date;
        EndDate: Date;
        EarningType: Option Gross,Net;
        OvertimeHours: Decimal;
        OvertimeMinutes: Decimal;

    procedure SetReportFilter(var selectedPeriod: Date)
    begin
        PayrollPeriod := selectedPeriod;
    end;
}