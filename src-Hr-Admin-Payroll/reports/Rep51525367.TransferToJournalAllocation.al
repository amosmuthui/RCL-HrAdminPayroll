report 51525367 "Transfer To Journal Allocation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/TransferToJournalAllocation.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                PostingGroup.Reset;
                if PostingGroup.Find('-') then
                    PayablesAcc := PostingGroup."Net Salary Payable";
                FringeAcc := PostingGroup."Fringe benefits";
                GLSetup.Get;

                PayrollPeriod.Reset;
                PayrollPeriod.SetRange("Starting Date", Datefilter);
                if PayrollPeriod.Find('-') then begin
                    //PayrollPeriod.TESTFIELD("Pay Date");
                    Payday := PayrollPeriod."Starting Date";//PayrollPeriod."Pay Date"
                end;
                TotalDebits := 0;
                TotalCredits := 0;


                Earn.Reset;
                // Earn.SETRANGE("Reduces Tax",FALSE);
                Earn.SetFilter("G/L Account", '<>%1', '');
                Earn.SetRange("Non-Cash Benefit", false);
                if Earn.Find('-') then begin
                    repeat
                        AssignMatrix.Reset;
                        AssignMatrix.SetRange(Code, Earn.Code);
                        AssignMatrix.SetRange("Payroll Period", Datefilter);
                        AssignMatrix.SetRange("Employee No", Employee."No.");
                        AssignMatrix.CalcSums(Amount);

                        SalaryAllocation.Reset;
                        SalaryAllocation.SetRange("Employee No", Employee."No.");
                        if SalaryAllocation.Find('-') then begin
                            repeat

                                GenJnline.Init;
                                LineNumber := LineNumber + 10;
                                GenJnline."Journal Template Name" := 'GENERAL';
                                GenJnline."Journal Batch Name" := 'SALARIES';
                                GenJnline."Line No." := GenJnline."Line No." + 10;
                                GenJnline."Account No." := Earn."G/L Account";
                                GenJnline.Validate("Account No.");
                                GenJnline."Posting Date" := Payday;
                                GenJnline.Description := Earn.Description + ': ' + Format(Datefilter, 0, '<month text> <year4>');//+' '+"Dimension Value".Code;
                                GenJnline."Document No." := Noseries;
                                GenJnline.Amount := (AssignMatrix.Amount * SalaryAllocation.Percentage / 100);
                                GenJnline.Validate(Amount);
                                //GenJnline."Employee Code" := AssignMatrix."Employee No";
                                GenJnline."Dimension Set ID" := SalaryAllocation."Dimension Set ID";
                                GenJnline.Validate(GenJnline."Dimension Set ID");

                                if GenJnline.Amount <> 0 then
                                    GenJnline.Insert;

                            until SalaryAllocation.Next = 0;
                        end;
                        TotalCredits := TotalCredits + AssignMatrix.Amount;
                    until Earn.Next = 0;
                end;


                //============================================FRINGE BENEFITS
                Earn.Reset;
                Earn.SetRange("Non-Cash Benefit", true);
                Earn.SetRange(Fringe, true);
                if Earn.Find('-') then begin
                    repeat
                        AssignMatrix.Reset;
                        AssignMatrix.SetRange(Code, Earn.Code);
                        AssignMatrix.SetRange("Payroll Period", Datefilter);
                        AssignMatrix.SetRange("Employee No", Employee."No.");
                        AssignMatrix.CalcSums(Amount);

                        SalaryAllocation.Reset;
                        SalaryAllocation.SetRange("Employee No", Employee."No.");
                        if SalaryAllocation.Find('-') then begin
                            repeat
                                GenJnline.Init;
                                LineNumber := LineNumber + 10;
                                GenJnline."Journal Template Name" := 'GENERAL';
                                GenJnline."Journal Batch Name" := 'SALARIES';
                                GenJnline."Line No." := GenJnline."Line No." + 10;
                                GenJnline."Account No." := Earn."G/L Account";
                                GenJnline.Validate("Account No.");
                                GenJnline."Posting Date" := Payday;
                                GenJnline.Description := Earn.Description + ': ' + Format(Datefilter, 0, '<month text> <year4>');//+' '+"Dimension Value".Code;
                                GenJnline."Document No." := Noseries;
                                //GenJnline."Shortcut Dimension 1 Code":="Dimension Value".Code;
                                GenJnline.Amount := (AssignMatrix."Employer Amount" * SalaryAllocation.Percentage / 100);
                                GenJnline.Validate(Amount);
                                GenJnline."Dimension Set ID" := SalaryAllocation."Dimension Set ID";
                                //GenJnline."Employee Code":=AssignMatrix."Employee No";
                                //TotalDebits:=TotalDebits+AssignMatrix.Amount;
                                if GenJnline.Amount <> 0 then
                                    GenJnline.Insert;
                            //TotalCredits:=TotalCredits+AssignMatrix.Amount;
                            until SalaryAllocation.Next = 0;
                        end;

                    until Earn.Next = 0;
                end;
                //================================================END FRINGE BENEFITS


                //====================================================================DEDUCTIONS

                //=========================================================EMPLOYER AMOUNT
                //=========================================================EMPLOYER AMOUNT

                Deductions.Reset;
                Deductions.SetFilter("G/L Account", '<>%1', '');
                if Deductions.Find('-') then begin
                    repeat
                        AssignMatrix.Reset;
                        AssignMatrix.SetRange(Code, Deductions.Code);
                        AssignMatrix.SetRange("Payroll Period", Datefilter);
                        AssignMatrix.SetRange("Employee No", Employee."No.");
                        AssignMatrix.CalcSums(Amount, "Employer Amount");
                        if (AssignMatrix."Employer Amount" <> 0) and (Deductions."G/L Account Employer" <> '') then begin
                            //MESSAGE('Description%1Amount%2',AssignMatrix.Description,AssignMatrix."Employer Amount");
                            SalaryAllocation.Reset;
                            SalaryAllocation.SetRange("Employee No", Employee."No.");
                            if SalaryAllocation.Find('-') then begin
                                repeat
                                    GenJnline.Init;
                                    LineNumber := LineNumber + 10;
                                    GenJnline."Journal Template Name" := 'GENERAL';
                                    GenJnline."Journal Batch Name" := 'SALARIES';
                                    GenJnline."Line No." := GenJnline."Line No." + 10;
                                    GenJnline."Account No." := Deductions."G/L Account Employer";
                                    GenJnline."Posting Date" := Payday;
                                    GenJnline.Description := Deductions.Description + ': ' + Format(Datefilter, 0, '<month text> <year4>');//+' '+"Dimension Value".Code+'-'+Dim2Value.Code+'-'+Dim3Value.Code;
                                    GenJnline."Document No." := Noseries;
                                    // GenJnline."Shortcut Dimension 1 Code":="Dimension Value".Code;
                                    /*
                                   vendrec.RESET;
                                   IF vendrec.GET(Deductions.vendor) THEN BEGIN
                                       GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
                                       GenJnline."Account No.":=Deductions.vendor;
                                   END;
                                   */
                                    GenJnline.Amount := (AssignMatrix."Employer Amount" * SalaryAllocation.Percentage / 100);
                                    GenJnline.Validate(Amount);
                                    GenJnline."Dimension Set ID" := SalaryAllocation."Dimension Set ID";
                                    GenJnline.Validate(GenJnline."Dimension Set ID");
                                    if GenJnline.Amount <> 0 then
                                        GenJnline.Insert;
                                //END;
                                until SalaryAllocation.Next = 0;
                            end;
                        end;
                    until Deductions.Next = 0;
                end;

                //============================================================END EMPLYER AMOUNT

                //============================================================END EMPLYER AMOUNT
                Deductions.Reset;
                Deductions.SetFilter("G/L Account", '<>%1', '');
                if Deductions.Find('-') then begin
                    repeat
                        if Deductions.Individual = true then begin
                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(Code, Deductions.Code);
                            AssignMatrix.SetRange("Payroll Period", Datefilter);
                            AssignMatrix.SetRange("Employee No", Employee."No.");
                            AssignMatrix.CalcSums(Amount, "Employer Amount");
                            /*IF AssignMatrix.FINDFIRST THEN BEGIN
                            REPEAT
                            LoanProductType1.RESET;
                            LoanProductType1.SETRANGE("Deductions Code",AssignMatrix.Code);
                            IF LoanProductType1.FINDFIRST THEN

                            EmpAccMap.RESET;
                            EmpAccMap.SETRANGE("Employee No.",AssignMatrix."Employee No");
                            EmpAccMap.SETRANGE("Loan Type",LoanProductType1.Code);
                            IF EmpAccMap.FINDFIRST THEN  BEGIN*/


                            //Added Code to cater for employer

                            GenJnline.Init;
                            LineNumber := LineNumber + 10;
                            GenJnline."Journal Template Name" := 'GENERAL';
                            GenJnline."Journal Batch Name" := 'SALARIES';
                            GenJnline."Line No." := GenJnline."Line No." + 10;
                            GenJnline."Account Type" := GenJnline."Account Type"::"G/L Account";
                            GenJnline."Account No." := Deductions."G/L Account";//AssignMatrix."Employee No";//EmpAccMap."Customer A/c";
                            GenJnline."Posting Date" := Payday;
                            GenJnline.Description := Deductions.Description + ': ' + Format(Datefilter, 0, '<month text> <year4>');//+' '+"Dimension Value".Code+'-'+Dim2Value.Code+'-'+Dim3Value.Code;
                            GenJnline."Document No." := Noseries;//GenJnlBatch."Posting No. Series";//NoSeriesMgt.InitSeries(GLSetup."GLTemplate Nos.",'',0D,GenJnline."Document No.",GenJnline.'');//FORMAT(Datefilter);
                            if (AssignMatrix."Employer Amount" <> 0) and (Deductions."G/L Account Employer" <> '') then begin
                                //MESSAGE('Description1 %1Amount%2',AssignMatrix.Description,AssignMatrix."Employer Amount");
                                GenJnline.Amount := AssignMatrix.Amount - AssignMatrix."Employer Amount";
                                // MESSAGE('........%1.......%2',GenJnline.Description,AssignMatrix."Employer Amount");
                            end else begin
                                GenJnline.Amount := AssignMatrix.Amount;
                            end;
                            GenJnline.Validate(Amount);
                            //GenJnline."Employee Code":=AssignMatrix."Employee No";
                            if AssignMatrix.Amount <= 0 then
                                TotalDebits := TotalDebits + AssignMatrix.Amount;
                            if GenJnline.Amount <> 0 then
                                GenJnline.Insert;
                            //END;//Mappings
                            //UNTIL AssignMatrix.NEXT=0;
                            // END;


                        end else begin

                            AssignMatrix.Reset;
                            AssignMatrix.SetRange(Code, Deductions.Code);
                            AssignMatrix.SetRange("Payroll Period", Datefilter);
                            AssignMatrix.SetRange("Employee No", Employee."No.");
                            AssignMatrix.CalcSums(Amount, "Employer Amount");

                            GenJnline.Init;
                            LineNumber := LineNumber + 10;
                            GenJnline."Journal Template Name" := 'GENERAL';
                            GenJnline."Journal Batch Name" := 'SALARIES';
                            GenJnline."Line No." := GenJnline."Line No." + 10;
                            GenJnline."Account No." := Deductions."G/L Account";
                            GenJnline."Posting Date" := Payday;
                            GenJnline.Description := Deductions.Description + ': ' + Format(Datefilter, 0, '<month text> <year4>');//+' '+"Dimension Value".Code+'-'+Dim2Value.Code+'-'+Dim3Value.Code;
                            GenJnline."Document No." := Noseries;//GenJnlBatch."Posting No. Series";//NoSeriesMgt.InitSeries(GLSetup."GLTemplate Nos.",'',0D,GenJnline."Document No.",GenJnline.'');//FORMAT(Datefilter);
                            if (AssignMatrix."Employer Amount" <> 0) and (Deductions."G/L Account Employer" <> '') then begin
                                GenJnline.Amount := AssignMatrix.Amount - AssignMatrix."Employer Amount";
                                // MESSAGE('........%1.......%2',GenJnline.Description,AssignMatrix."Employer Amount");
                            end else begin
                                GenJnline.Amount := AssignMatrix.Amount;
                            end;
                            GenJnline.Validate(Amount);
                            //GenJnline."Employee Code":=AssignMatrix."Employee No";
                            if AssignMatrix.Amount <= 0 then
                                TotalDebits := TotalDebits + AssignMatrix.Amount;
                            if GenJnline.Amount <> 0 then
                                GenJnline.Insert;
                        end;
                    //DimMgt.ValidateShortcutDimValues(3,Dim3Value.Code,GenJnline."Dimension Set ID");

                    until Deductions.Next = 0;
                end;
                //=========================================================================END DEDUCTIONS


                //============================================balancing FRINGE BENEFITS
                Earn.Reset;
                Earn.SetRange("Non-Cash Benefit", true);
                Earn.SetRange(Fringe, true);
                if Earn.Find('-') then begin
                    repeat
                        AssignMatrix.Reset;
                        AssignMatrix.SetRange(Code, Earn.Code);
                        AssignMatrix.SetRange("Payroll Period", Datefilter);
                        AssignMatrix.SetRange("Employee No", Employee."No.");
                        AssignMatrix.CalcSums("Employer Amount");

                        SalaryAllocation.Reset;
                        SalaryAllocation.SetRange("Employee No", Employee."No.");
                        if SalaryAllocation.Find('-') then begin
                            repeat

                                GenJnline.Init;
                                LineNumber := LineNumber + 10;
                                GenJnline."Journal Template Name" := 'GENERAL';
                                GenJnline."Journal Batch Name" := 'SALARIES';
                                GenJnline."Line No." := GenJnline."Line No." + 10;
                                GenJnline."Account No." := FringeAcc;
                                GenJnline.Validate("Account No.");
                                GenJnline."Posting Date" := Payday;
                                GenJnline.Description := Earn.Description + ': ' + Format(Datefilter, 0, '<month text> <year4>');//+' '+"Dimension Value".Code;
                                GenJnline."Document No." := Noseries;
                                //GenJnline."Shortcut Dimension 1 Code":="Dimension Value".Code;
                                GenJnline.Amount := -(AssignMatrix."Employer Amount" * SalaryAllocation.Percentage / 100);
                                GenJnline.Validate(Amount);
                                GenJnline."Dimension Set ID" := SalaryAllocation."Dimension Set ID";
                                GenJnline.Validate(GenJnline."Dimension Set ID");
                                //GenJnline."Employee Code":=AssignMatrix."Employee No";
                                //TotalDebits:=TotalDebits+AssignMatrix.Amount;
                                if GenJnline.Amount <> 0 then
                                    GenJnline.Insert;


                            until SalaryAllocation.Next = 0;
                        end;

                    until Earn.Next = 0;
                end;


                //================================================END FRINGE BENEFITS
                Message('NetPay %1 = TotalCredits %2 + TotalDebits %3', (TotalCredits + TotalDebits), TotalCredits, TotalDebits);
                //TotalCredits+TotalDebits
                SalaryAllocation.Reset;
                SalaryAllocation.SetRange("Employee No", Employee."No.");
                if SalaryAllocation.Find('-') then begin
                    repeat

                        //====================NET PAYABLE
                        GenJnline.Init;
                        LineNumber := LineNumber + 10;
                        GenJnline."Journal Template Name" := 'GENERAL';
                        GenJnline."Journal Batch Name" := 'SALARIES';
                        GenJnline."Line No." := GenJnline."Line No." + 10;
                        GenJnline."Account No." := PayablesAcc;
                        GenJnline."Posting Date" := Payday;
                        // GenJnline."Shortcut Dimension 1 Code":="Dimension Value".Code;
                        GenJnline.Description := 'Salaries Payable:' + Format(Datefilter, 0, '<month text> <year4>');//+' '+"Dimension Value".Code+'-'+Dim2Value.Code+'-'+Dim3Value.Code;
                                                                                                                     // GenJnline."Shortcut Dimension 1 Code":="Dimension Value".Code;//EmpRec."Global Dimension 1 Code";
                                                                                                                     //GenJnline."Shortcut Dimension 2 Code":=Dim2Value.Code;//EmpRec."Global Dimension 2 Code";
                                                                                                                     //GenJnline."Shortcut Dimension 3 Code":=Dim3Value.Code;//EmpRec."Shortcut Dimension 3 Code";//"Dimension Value".Code;
                        GenJnline."Document No." := Noseries;//GenJnlBatch."Posting No. Series";//NoSeriesMgt.InitSeries(GLSetup."GLTemplate Nos.",'',0D,GenJnline."Document No.",GenJnline.'');//FORMAT(Datefilter);
                        GenJnline.Amount := -((TotalCredits + TotalDebits) * SalaryAllocation.Percentage / 100);
                        GenJnline."Dimension Set ID" := SalaryAllocation."Dimension Set ID";
                        GenJnline.Validate(GenJnline."Dimension Set ID");
                        GenJnline.Validate(Amount);
                        //nJnline."Employee Code":=EmpRec."No.";
                        if GenJnline.Amount <> 0 then
                            GenJnline.Insert;

                    until SalaryAllocation.Next = 0;
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
                field("Payroll Period"; Datefilter)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PayrollPeriod.Reset;
                        if PAGE.RunModal(51525085, PayrollPeriod) = ACTION::LookupOK then
                            Datefilter := PayrollPeriod."Starting Date";
                    end;
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

    trigger OnPreReport()
    begin
        if Datefilter = 0D then
            Error('Please Enter Payroll Period!');
        GenJnline.Reset;
        GenJnline.SetRange("Journal Template Name", 'GENERAL');
        GenJnline.SetRange("Journal Batch Name", 'SALARIES');
        GenJnline.DeleteAll;


        GenJnlBatch.Reset;
        GenJnlBatch.SetRange(Name, 'SALARIES');
        if GenJnlBatch.Find('-') then
            Noseries := Format(Date2DMY(Datefilter, 2)) + '-' + Format(Date2DMY(Datefilter, 3));
    end;

    var
        Datefilter: Date;
        Earn: Record Earnings;
        GenJnline: Record "Gen. Journal Line";
        LineNumber: Integer;
        SalaryAllocation: Record "Salary Allocation";
        GenJnlBatch: Record "Gen. Journal Batch";
        PayrollPeriod: Record "Payroll Period";
        AssignMatrix: Record "Assignment Matrix";
        PostingGroup: Record "Staff Posting Group";
        PayablesAcc: Code[10];
        FringeAcc: Code[10];
        GLSetup: Record "General Ledger Setup";
        Payday: Date;
        TotalDebits: Decimal;
        TotalCredits: Decimal;
        Noseries: Code[20];
        Deductions: Record Deductions;
}