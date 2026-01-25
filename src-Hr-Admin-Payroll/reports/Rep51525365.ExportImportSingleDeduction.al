report 51525365 "Export Import Single Deduction"
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

                Deductions.RESET;
                Deductions.SetRange("Universal Title"/*Code*/, SelectedDeductionTitle);
                Deductions.setrange(Country, Empl."Payroll Country"); //fetch for this specific employee but ukikosa don't shout, leave in peace
                IF not Deductions.FindFirst() THEN
                    CurrReport.Skip() //Error('Unfortunately we cannot find any deduction with title %1 and country %2! Kindly check again.', SelectedDeductionTitle, Empl."Payroll Country")
                else begin
                    if not HeadingsCaptured then begin
                        //Create the first row - just capture the pay period on the first column and the deduction code and description on the second column
                        ExcelBuffer.AddColumn(PayrollPeriod, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn(Deductions.Description /*+ ' (' + SelectedDeductionTitle + ')'*/, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        SelectedDeductionDescription := Deductions.Description;

                        //2nd row has the other headings
                        ExcelBuffer.NewRow;
                        ExcelBuffer.AddColumn('Emp No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Country', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Deduction Title', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Start Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('End Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        ExcelBuffer.AddColumn('Full Month Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                        HeadingsCaptured := true;
                    end;
                    //Headings done



                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn(Empl."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Empl."Payroll Country", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(SelectedDeductionTitle, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    //Capture the Deductions for this employee and period
                    Amount := 0;
                    FullMonthAmount := 0;
                    StartDate := 0D;
                    EndDate := 0D;
                    AssignmentMatrix.RESET;
                    AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                    AssignmentMatrix.SETRANGE("Transaction Title"/*Code*/, SelectedDeductionTitle);
                    AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                    AssignmentMatrix.setrange(Country, Empl."Payroll Country");
                    IF AssignmentMatrix.FINDFIRST THEN begin
                        Amount := AssignmentMatrix.Amount;
                        if AssignmentMatrix."Amount In FCY" <> 0 then
                            Amount := AssignmentMatrix."Amount In FCY";
                        TransactionCurrency := AssignmentMatrix."Earning Currency";
                        StartDate := AssignmentMatrix."Start Date";
                        EndDate := AssignmentMatrix."End Date";
                        FullMonthAmount := AssignmentMatrix."Full Month Amount";
                    end;
                    if (TransactionCurrency = '') then
                        TransactionCurrency := Empl."Payroll Currency";

                    ExcelBuffer.AddColumn(TransactionCurrency, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(Amount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(StartDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(EndDate, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn(FullMonthAmount, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                END;
            end;


            trigger OnPostDataItem()
            var
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                if (Direction = Direction::Export) then begin
                    Window.CLOSE;
                    ExcelBuffer.SetFriendlyFilename('Deduction ' + SelectedDeductionDescription + ' for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2> <Year4>') + ' - ' + SelectedCountry);
                    HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, 'Deduction ' + SelectedDeductionDescription + ' as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2>, <Year4>'), '');
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (Direction = Direction::Export) then begin
                    Window.OPEN('Preparing export data for #######1');
                    ExcelBuffer.DELETEALL;
                    HeadingsCaptured := false;
                    if (SelectedDeductionTitle = '') then
                        Error('You must select a deduction!');
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
                        FullMonthAmount := 0;
                        StartDate := 0D;
                        EndDate := 0D;
                        IF GetValueAtCell(ExcelBuffer, RowNo, 6) <> '' THEN
                            EVALUATE(Amount, GetValueAtCell(ExcelBuffer, RowNo, 6));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 7) <> '' THEN
                            EVALUATE(StartDate, GetValueAtCell(ExcelBuffer, RowNo, 7));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 8) <> '' THEN
                            EVALUATE(EndDate, GetValueAtCell(ExcelBuffer, RowNo, 8));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 9) <> '' THEN
                            EVALUATE(FullMonthAmount, GetValueAtCell(ExcelBuffer, RowNo, 9));

                        if ImpEmpNo <> '' then //Emp no must have a value
                            InsertMatrix(ImpEmpNo, ImpCountry, ImpTransTitle, ImpCurrencyCode, PayPeriod, abs(Amount), StartDate, EndDate, ABS(FullMonthAmount));

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
                field(Deduction; SelectedDeductionTitle)
                {
                    TableRelation = "Payroll Universal Trans Codes".Title Where("Transaction Type" = filter(Deduction));
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

    local procedure InsertMatrix(EmployeeNo: Code[30]; EmpCountry: Code[30]; TransactionTitle: Code[100]; "CurrencyCode": Code[100]; PayrollPeriodFromFile: Date; TransAmount: Decimal; StartDt: Date; EndDt: Date; FullMonthAmt: Decimal)
    var

    begin
        Deductions.RESET;
        Deductions.SETRANGE("Universal Title"/*Code*/, TransactionTitle);
        Deductions.SetRange(Country, EmpCountry);
        IF Deductions.FINDFIRST THEN BEGIN
            //MESSAGE('2');
            //Message('Working on deduction Code %1 for emp %2 of country %3 in period %4 ->%5',
            //Deductions.Code, EmployeeNo, EmpCountry, PayrollPeriodFromFile, PayrollPeriod);
            AssignmentMatrix.RESET;
            AssignmentMatrix.SETRANGE("Employee No", EmployeeNo);
            AssignmentMatrix.SETRANGE(Code/*"Transaction Title"*/, Deductions.Code/*TransactionTitle*/);
            AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
            AssignmentMatrix.SetRange(Country, EmpCountry);
            AssignmentMatrix.DELETEALL;
            /*if AssignmentMatrix.FindSet() then
                repeat
                    Message('Deleting Code %1 for emp %2 of country %3 in period %4',
                    AssignmentMatrix.Code, AssignmentMatrix."Employee No", AssignmentMatrix.Country,
                    AssignmentMatrix."Pay Period");
                    AssignmentMatrix.Delete();
                until AssignmentMatrix.Next() = 0;


            AssignmentMatrix.RESET;
            AssignmentMatrix.SETRANGE("Employee No", EmployeeNo);
            AssignmentMatrix.SETRANGE(Code/*"Transaction Title"/, Deductions.Code/TransactionTitle/);
            AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
            AssignmentMatrix.SetRange(Country, EmpCountry);
            AssignmentMatrix.SetRange(Type, AssignmentMatrix.Type::Deduction);
            AssignmentMatrix.SetRange("Reference No", '');
            AssignmentMatrix.SetRange("Effective Start Date", 0D);
            AssignmentMatrix.DELETEALL;*/

            AssignmentMatrix.RESET;
            AssignmentMatrix.INIT;
            AssignmentMatrix.Code := Deductions.Code;
            AssignmentMatrix.Country := EmpCountry;
            AssignmentMatrix."Transaction Title" := TransactionTitle;
            AssignmentMatrix.Type := AssignmentMatrix.Type::Deduction;
            AssignmentMatrix.Description := Deductions.Description;
            AssignmentMatrix."Employee No" := EmployeeNo;
            AssignmentMatrix."Payroll Period" := PayrollPeriod;
            AssignmentMatrix.VALIDATE(Code);
            AssignmentMatrix.VALIDATE("Employee No");
            AssignmentMatrix.Amount := -ABS(TransAmount);
            if Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat amount" then begin
                AssignmentMatrix."Earning Currency" := CurrencyCode;
                AssignmentMatrix."Amount In FCY" := TransAmount;
                AssignmentMatrix."Start Date" := StartDt;
                AssignmentMatrix."End Date" := EndDt;
                AssignmentMatrix."Full Month Amount" := FullMonthAmt;
                AssignmentMatrix.Validate("Start Date"/*"Full Month Amount"*/);
                AssignmentMatrix.Validate("Amount In FCY");
            end;
            IF (ABS(TransAmount) <> 0) or (ABS(FullMonthAmt) <> 0) THEN
                AssignmentMatrix.INSERT(true);//if not AssignmentMatrix.INSERT(true) then AssignmentMatrix.Modify(true);
        END;

    end;

    /*trigger OnPreReport()
    begin
        if (SelectedDeductionTitle = '') then
            Error('You must select a deduction!');
    end;*/

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        Deductions: Record "Deductions";
        Employee: Record "Employee";
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
        SelectedDeductionTitle: Code[50];
        SelectedDeductionDescription: Text[250];
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
        FullMonthAmount: Decimal;
        StartDate: Date;
        EndDate: Date;

    procedure SetReportFilter(var selectedPeriod: Date)
    begin
        PayrollPeriod := selectedPeriod;
    end;
}