report 51525363 "Export Earnings and Deductions"
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
                if Empl.getfilter("Payroll Country") = '' then
                    error('You must select payroll country because the transactions vary from country to country!');
                SelectedCountry := Empl.getfilter("Payroll Country");
                //Create the first row - just capture the pay period on the first column
                Window.UPDATE(1, Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name"/*PayProcessHeader."Payroll Period"*/);

                if not HeadingsCaptured then begin
                    ExcelBuffer.AddColumn(PayrollPeriod, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    //2nd row has earnings and deductions. Use a loop to create them
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //For empno
                    ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //For name
                    ExcelBuffer.AddColumn('', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text); //For country

                    Earnings.RESET;
                    Earnings.SETCURRENTKEY(Code);
                    Earnings.SETASCENDING(Code, TRUE);
                    Earnings.setrange(Country, Empl."Payroll Country");
                    IF Earnings.FINDSET THEN BEGIN
                        REPEAT
                            ExcelBuffer.AddColumn(Earnings.Description + '(  Earning)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        UNTIL Earnings.NEXT = 0;
                    END;

                    Deductions.RESET;
                    Deductions.SETCURRENTKEY(Code);
                    Deductions.SETASCENDING(Code, TRUE);
                    Deductions.setrange(Country, Empl."Payroll Country");
                    IF Deductions.FINDSET THEN BEGIN
                        REPEAT
                            ExcelBuffer.AddColumn(Deductions.Description + '(Deduction)', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        UNTIL Deductions.NEXT = 0;
                    END;

                    //The emp no, name, trans codes
                    ExcelBuffer.NewRow;
                    ExcelBuffer.AddColumn('Emp No', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Name', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    ExcelBuffer.AddColumn('Country', FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                    Earnings.RESET;
                    Earnings.SETCURRENTKEY(Code);
                    Earnings.SETASCENDING(Code, TRUE);
                    Earnings.setrange(Country, Empl."Payroll Country");
                    IF Earnings.FINDSET THEN BEGIN
                        REPEAT
                            ExcelBuffer.AddColumn(Earnings.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        UNTIL Earnings.NEXT = 0;
                    END;

                    Deductions.RESET;
                    Deductions.SETCURRENTKEY(Code);
                    Deductions.SETASCENDING(Code, TRUE);
                    Deductions.setrange(Country, Empl."Payroll Country");
                    IF Deductions.FINDSET THEN BEGIN
                        REPEAT
                            ExcelBuffer.AddColumn(Deductions.Code, FALSE, '', TRUE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                        UNTIL Deductions.NEXT = 0;
                    END;

                    HeadingsCaptured := true;
                end;
                //Headings done


                //The data now
                /*Employee.RESET;
                Employee.SETCURRENTKEY("Payroll Country");
                Employee.SETRANGE(Status, Employee.Status::Active);
                Employee.SETASCENDING("Payroll Country", TRUE);
                IF Employee.FINDSET THEN BEGIN
                    REPEAT*/
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(Empl."No.", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(Empl."Payroll Country", FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);

                //Capture the earnings for this employee and period
                Earnings.RESET;
                Earnings.SETCURRENTKEY(Code);
                Earnings.SETASCENDING(Code, TRUE);
                Earnings.setrange(Country, Empl."Payroll Country");
                IF Earnings.FINDSET THEN BEGIN
                    REPEAT
                        //The matrices now
                        Amount := 0;
                        AssignmentMatrix.RESET;
                        AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                        AssignmentMatrix.SETRANGE(Code, Earnings.Code);
                        AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                        AssignmentMatrix.setrange(Country, Empl."Payroll Country");
                        IF AssignmentMatrix.FINDFIRST THEN
                            Amount := AssignmentMatrix.Amount;

                        IF (Earnings."Is Contractual Amount") and (not Earnings."Goes to Matrix") THEN BEGIN
                            Employee.RESET;
                            Employee.SETRANGE("No.", Empl."No.");
                            IF Employee.FINDFIRST THEN BEGIN
                                Amount := Employee."Assigned Gross Pay";
                            END;
                        END;


                        ExcelBuffer.AddColumn(ABS(Amount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    UNTIL Earnings.NEXT = 0;
                END;


                //Capture the deductions for this employee and period
                Deductions.RESET;
                Deductions.SETCURRENTKEY(Code);
                Deductions.SETASCENDING(Code, TRUE);
                Deductions.setrange(Country, Empl."Payroll Country");
                IF Deductions.FINDSET THEN BEGIN
                    REPEAT
                        //The matrices now
                        Amount := 0;
                        AssignmentMatrix.RESET;
                        AssignmentMatrix.SETRANGE("Employee No", Empl."No.");
                        AssignmentMatrix.SETRANGE(Code, Deductions.Code);
                        AssignmentMatrix.SETRANGE("Payroll Period", PayrollPeriod);
                        AssignmentMatrix.setrange(Country, Empl."Payroll Country");
                        IF AssignmentMatrix.FINDFIRST THEN
                            Amount := AssignmentMatrix.Amount;
                        ExcelBuffer.AddColumn(ABS(Amount), FALSE, '', FALSE, FALSE, FALSE, '', ExcelBuffer."Cell Type"::Text);
                    UNTIL Deductions.NEXT = 0;
                    //END;
                    //UNTIL Employee.NEXT = 0;
                END;
                //ExcelBuffer.SetFriendlyFilename('Earnings and Deductions for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2> <Year4>'));
            end;


            trigger OnPostDataItem()
            var
                HelperFunctions: Codeunit "Custom Helper Functions Base";
            begin
                Window.CLOSE;
                ExcelBuffer.SetFriendlyFilename('Earnings and Deductions for ' + FORMAT(PayrollPeriod, 0, '<Month Text> <Year4>') + ' as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2> <Year4>') + ' - ' + SelectedCountry);
                HelperFunctions.CreateBookAndOpenExcel(ExcelBuffer, 'Earnings and Deductions as at ' + FORMAT(TODAY, 0, '<Month Text> <Day,2>, <Year4>'), '');
            end;

            trigger OnPreDataItem()
            begin
                Window.OPEN('Preparing export data for #######1');
                ExcelBuffer.DELETEALL;
                HeadingsCaptured := false;
                Empl.SETRANGE(Status, Empl.Status::Active);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PayrollPeriod; PayrollPeriod)
                {
                    Caption = 'Pay Period';
                    TableRelation = "Payroll Period"."Starting Date" WHERE(Closed = FILTER(false));
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

    procedure SetReportFilter(var selectedPeriod: Date)
    begin
        PayrollPeriod := selectedPeriod;
    end;
}