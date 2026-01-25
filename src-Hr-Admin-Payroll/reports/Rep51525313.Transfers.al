report 51525313 Transfers
{
    ApplicationArea = All;
    Caption = 'Transfers';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/Transfers.rdlc';
    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = SORTING("No.");// WHERE(Status = CONST(Active));
            RequestFilterFields = "No.", "Payroll Country";


            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(CompanyPIN; CompanyInformation."P.I.N")
            {
            }
            column(CompanyPostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyAddress2; CompanyInformation."Address 2")
            {
            }
            column(ComapnyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(No; "No.")
            {
            }
            column(FirstName; "First Name")
            {
            }
            column(MiddleName; "Middle Name")
            {
            }
            column(LastName; "Last Name")
            {
            }
            column(AssignedGrossPay; "Assigned Gross Pay")
            {
            }
            column(ContractualAmountType; "Contractual Amount Type")
            {
            }
            column(ContractualAmountCurrency; "Contractual Amount Currency")
            {
            }
            column(DateOfLeaving; Format(EffectiveDate, 0, '<Day,2>-<Month Text>-<year4>')/*"Date Of Join"*/)
            {
            }
            column(PayPeriod; Uppercase(Format(PayrollPeriod, 0, '<Month Text>-<year4>')))
            {
            }
            column(InactiveStatus; InactiveStatus)
            { }
            column(Job_Title; "Job Title")
            { }
            column(ChangeType; ChangeType)
            { }
            column(PreviousState; PreviousState)
            { }
            column(CurrentState; CurrentState)
            { }
            column(PreviousContractualAmountText; PreviousContractualAmountText)
            { }
            column(CurrentContractualAmountText; CurrentContractualAmountText)
            { }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;
                EffectiveDate := 0D;
                ChangeType := '';
                CurrentContractualAmountText := '';
                PreviousContractualAmountText := '';

                Movement.Reset();
                Movement.SetRange("Emp No.", Employee."No.");
                Movement.SetFilter("First Date", '%1..%2', PayrollPeriod, CalcDate('<CM>', PayrollPeriod));
                //Movement.SetFilter("Type", '<>%1&<>%2', Movement."Type"::"August 2023", Movement."Type"::Initial);
                Movement.SetRange(Type, Movement.Type::Country);
                if Movement.FindLast() then begin
                    EffectiveDate := Movement."First Date";
                    if Movement."Contractual Amount Value" <> 0 then begin
                        TxtAmt := Format(Movement."Contractual Amount Value");
                        CurrentContractualAmountText := TxtAmt + ' ' + Movement."Contractual Amount Currency" + ' (' + Format(Movement."Contractual Amount Type") + ')';
                    end;
                    ChangeType := Format(Movement.Type);

                    PrevMovement.Reset();
                    PrevMovement.SetRange("Emp No.", Employee."No.");
                    PrevMovement.SetFilter("Last Date", '<=%1', Movement."First Date");
                    PrevMovement.SetFilter("No.", '<>%1', Movement."No.");
                    PrevMovement.SetRange(Type, PrevMovement.Type::Country);
                    if PrevMovement.FindLast() then begin
                        if PrevMovement."Contractual Amount Value" <> 0 then begin
                            TxtAmt := Format(PrevMovement."Contractual Amount Value");
                            PreviousContractualAmountText := TxtAmt + ' ' + PrevMovement."Contractual Amount Currency" + ' (' + Format(PrevMovement."Contractual Amount Type") + ')';
                        end;
                        //if Movement.Type = Movement.Type::Country then begin
                        CurrentState := Movement."Payroll Country";
                        PreviousState := PrevMovement."Payroll Country";
                        //end;

                        /*if (Movement.Type = Movement.Type::Promotion) or (Movement.Type = Movement.Type::Demotion) then begin
                            CurrentState := Movement."Job Title";
                            PreviousState := PrevMovement."Job Title";
                        end;*/

                        /*if (Movement.Type = Movement.Type::"Department/Section") then begin
                            CurrentState := Movement."Section Title";
                            PreviousState := PrevMovement."Job Title";
                        end;

                        if (Movement.Type = Movement.Type::Station) then begin
                            CurrentState := Movement."Station Title";
                            PreviousState := PrevMovement."Station Title";
                        end;

                        if Movement.Type = Movement.Type::"Salary Adjustment" then begin
                            CurrentState := CurrentContractualAmountText;
                            PreviousState := PreviousContractualAmountText;
                        end;*/
                    end else
                        CurrReport.Skip();

                end else
                    CurrReport.Skip();

            end;

            trigger OnPreDataItem()
            begin
                if PayrollPeriod = 0D then
                    Error('You must select the payroll period!');
                CompanyInformation.Get;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field("Payroll Period"; PayrollPeriod)
                {
                    TableRelation = "Payroll Period";
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
        trigger OnOpenPage()
        begin
            Periods.Reset();
            Periods.SetRange(Closed, false);
            if Periods.FindFirst() then
                PayrollPeriod := Periods."Starting Date";
        end;
    }
    var
        CompanyInformation: Record "Company Information";
        ComapnyInfoCaptured: Boolean;
        Movement: Record "Internal Employement History";
        PrevMovement: Record "Internal Employement History";
        PayrollPeriod: Date;
        EffectiveDate: Date;
        InactiveStatus: Text[250];
        ChangeType: Text[250];
        PreviousState: Text[250];
        CurrentState: Text[250];
        PreviousContractualAmountText: Text[250];
        CurrentContractualAmountText: Text[250];
        TxtAmt: Text[100];
        Periods: Record "Payroll Period";
}