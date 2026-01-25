report 51525349 "ExIm Installment Deductions"
{
    Caption = 'Export Import Installment Deductions';
    ProcessingOnly = true;

    dataset
    {
        dataitem(LoanTrans; "Loans transactions")
        {
            RequestFilterHeading = 'Installment Deductions';
            DataItemTableView = WHERE("Start Deducting" = FILTER(false));
            RequestFilterFields = Employee, No, "Code", Country;

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, LoanTrans.No + ' ' + LoanTrans.Code + ' ' + LoanTrans.Name);

                if not HeadingsCaptured then begin
                    ExcelBuffer.AddColumn('WB No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Country', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Deduction Code', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Deduction Title', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Currency', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Loan Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Initial Paid Amount', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Start Date', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Exchange Rate Used', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('No. of Installments', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    HeadingsCaptured := true;
                end;
                //Headings done
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(LoanTrans.Employee, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans."Employee Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans.Country, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans.Code, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans.Name, FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans."Deduction Currency", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans."Loan Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans."Initial Paid Amount", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans."Loan Date", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans."Exchange Rate Type", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(LoanTrans."No. of Repayments Period", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
            end;


            trigger OnPostDataItem()
            var
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                if (Direction = Direction::Export) then begin
                    Window.CLOSE;
                    ExcelBuffer.SetFriendlyFilename('Installment Deductions as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2> <Year4>'));
                    HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, 'Installment Deductions as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2>, <Year4>'), '');
                end;
            end;

            trigger OnPreDataItem()
            begin
                if (Direction = Direction::Export) then begin
                    Window.OPEN('Preparing export data for #######1');
                    ExcelBuffer.DELETEALL;
                    HeadingsCaptured := false;
                end;
                if (Direction = Direction::Import) then begin
                    Window.OPEN('Preparing import data for #######1');
                    ExcelBuffer.DELETEALL;
                    Window.UPDATE(1, 'PayrollPeriod');

                    LoanTrans.SETRANGE(No, 'XYZXYZ');//When importing, don't fetch any employee. We'll follow the excel

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

                    FOR RowNo := 2 TO MaxRowNo DO BEGIN
                        ExchRateUsed := 'Current';
                        StartDate := 0D;
                        ImpEmpNo := GetValueAtCell(ExcelBuffer, RowNo, 1);
                        ImpCountry := GetValueAtCell(ExcelBuffer, RowNo, 3);
                        DeductionCode := GetValueAtCell(ExcelBuffer, RowNo, 4);
                        ImpCurrencyCode := GetValueAtCell(ExcelBuffer, RowNo, 6);
                        if GetValueAtCell(ExcelBuffer, RowNo, 10) <> '' then
                            ExchRateUsed := GetValueAtCell(ExcelBuffer, RowNo, 10);
                        Window.UPDATE(1, ImpEmpNo + ' ' + DeductionCode);
                        Evaluate(StartDate, GetValueAtCell(ExcelBuffer, RowNo, 9));

                        Amount := 0;
                        NoOfInstallments := 1;
                        InitAmount := 0;
                        IF GetValueAtCell(ExcelBuffer, RowNo, 7) <> '' THEN
                            EVALUATE(Amount, GetValueAtCell(ExcelBuffer, RowNo, 7));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 8) <> '' THEN
                            EVALUATE(InitAmount, GetValueAtCell(ExcelBuffer, RowNo, 8));
                        IF GetValueAtCell(ExcelBuffer, RowNo, 11) <> '' THEN
                            EVALUATE(NoOfInstallments, GetValueAtCell(ExcelBuffer, RowNo, 11));

                        if (ImpEmpNo <> '') and (ImpCountry <> '') and (DeductionCode <> '') and (Amount <> 0) then //these must have a value
                            InsertMatrix(ImpEmpNo, ImpCountry, DeductionCode, ImpCurrencyCode, StartDate, abs(Amount), abs(InitAmount), ExchRateUsed, NoOfInstallments);

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
                /*field(PayrollPeriod; PayrollPeriod)
                {
                    Caption = 'Pay Period';
                    TableRelation = "Payroll Period"."Starting Date" WHERE(Closed = FILTER(false));
                }
                field(Deduction; SelectedDeductionTitle)
                {
                    TableRelation = "Payroll Universal Trans Codes".Title Where("Transaction Type" = filter(Deduction));
                }*/
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

    local procedure InsertMatrix(EmployeeNo: Code[30]; EmpCountry: Code[30]; DedCode: Code[100]; "CurrencyCode": Code[100]; LoanDate: Date; LoanAmount: Decimal; InitialAmount: Decimal; ExchangeRateUsed: Text[20]; InstallmentPeriods: Integer)
    var

    begin
        if LoanDate = 0D then
            LoanDate := Today();
        if LoanTrans.CheckIfAnotherTransactionExistsExternal(EmployeeNo, DedCode, EmpCountry) then
            Error('There is already an existing installment transaction for this deduction (%1 | %2 | %3). If you want to add an amount, kindly go to installment deductions and add a new one!', EmployeeNo, DedCode, EmpCountry);
        LoanTransactions.RESET;
        LoanTransactions.SETRANGE(Employee, EmployeeNo);
        LoanTransactions.SETRANGE(Country, EmpCountry);
        LoanTransactions.SETRANGE("Code", DedCode);
        LoanTransactions.SetRange("Start Deducting", false);
        if LoanTransactions.FindFirst() then begin
            LoanTransactions."Loan Amount" := Amount;
            LoanTransactions."Initial Paid Amount" := InitialAmount;
            LoanTransactions."Loan Date" := LoanDate;
            LoanTransactions."No. of Repayments Period" := InstallmentPeriods;
            if UpperCase(ExchangeRateUsed) = /*'Current'*/'CURRENT' then
                LoanTransactions."Exchange Rate Type" := LoanTransactions."Exchange Rate Type"::Current;
            if UpperCase(ExchangeRateUsed) = /*'Initial'*/'INITIAL' then
                LoanTransactions."Exchange Rate Type" := LoanTransactions."Exchange Rate Type"::Initial;
            LoanTransactions."Deduction Currency" := "CurrencyCode";
            LoanTransactions.Validate("Loan Amount");
            LoanTransactions.Modify();
        end else begin
            LoanTransInit.Reset();
            LoanTransInit.Init();

            LoanTransInit.No := '';
            /*LoanTransLast.Reset();
            if LoanTransLast.FindLast then begin
                LoanTransInit.No := IncStr(LoanTransLast.No)
            end else begin
                LoanTransInit.No := 'LN00001';
            end;*/

            LoanTransInit.Employee := EmployeeNo;
            LoanTransInit.Validate(Employee);
            LoanTransInit.Country := EmpCountry;
            LoanTransInit."Code" := DedCode;
            LoanTransInit.Validate("Code");
            LoanTransInit."Loan Amount" := Amount;
            LoanTransInit."Initial Paid Amount" := InitialAmount;
            LoanTransInit."Loan Date" := LoanDate;
            LoanTransInit."No. of Repayments Period" := InstallmentPeriods;
            if UpperCase(ExchangeRateUsed) = /*'Current'*/'CURRENT' then
                LoanTransInit."Exchange Rate Type" := LoanTransInit."Exchange Rate Type"::Current;
            if UpperCase(ExchangeRateUsed) = /*'Initial'*/'INITIAL' then
                LoanTransInit."Exchange Rate Type" := LoanTransInit."Exchange Rate Type"::Initial;
            LoanTransInit."Deduction Currency" := "CurrencyCode";
            LoanTransInit.Validate("Loan Amount");
            LoanTransInit.Insert(true);
        end;
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
        NoOfInstallments: Integer;
        StartDate: Date;
        DeductionCode: Code[20];
        InitAmount: Decimal;
        ExchRateUsed: Text[20];
        LoanTransactions: Record "Loans transactions";
        LoanTransLast: Record "Loans transactions";
        LoanTransInit: Record "Loans transactions";

    procedure SetReportFilter(var selectedPeriod: Date)
    begin
        PayrollPeriod := selectedPeriod;
    end;
}