report 51525311 Joiners
{
    ApplicationArea = All;
    Caption = 'Joiners';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/layouts/Joiners.rdlc';
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
            column(DateOfJoin; Format(FirstDate, 0, '<Day,2>-<Month Text>-<year4>')/*"Date Of Join"*/)
            {
            }
            column(PayPeriod; uppercase(Format(PayrollPeriod, 0, '<Month Text>-<year4>')))
            {
            }
            column(Position; Position)
            { }
            column(Department; Department)
            { }
            column(ChangeType; ChangeType)
            { }

            trigger OnAfterGetRecord()
            begin
                if not ComapnyInfoCaptured then
                    CompanyInformation.CalcFields(Picture)
                else
                    ComapnyInfoCaptured := true;
                FirstDate := 0D;
                Position := '';
                Department := '';
                ChangeType := '';

                PrevPeriod := CalcDate('-1M', PayrollPeriod);
                Movement.Reset();
                Movement.SetRange("Emp No.", Employee."No.");
                Movement.SetFilter("First Date", '%1..%2', PrevPeriod/*PayrollPeriod*/, CalcDate('<CM>', PayrollPeriod));
                //Movement.SetRange("Type", Movement."Type"::Initial);
                Movement.SetFilter(Type, '%1|%2|%3|%4|%5', Movement.Type::Initial, Movement.Type::"Reinstatement Letter", Movement.Type::Reintegration, Movement.Type::"Temporary Contract", Movement.Type::Other);
                if Movement.FindFirst() then begin //first, fetch the movement change for this period
                    ChangeType := Format(Movement.Type);
                    //proceed if it is of type initial - now we may have multiple initials
                    if (Movement.Type = Movement.Type::Initial) or (Movement.Type = Movement.Type::"Reinstatement Letter") or (Movement.Type = Movement.Type::Reintegration) or (Movement.Type = Movement.Type::"Temporary Contract") or ((Movement.Type = Movement.Type::Other) and (Movement.Remarks = 'Reactivated')) then begin
                        FirstDate := Movement."First Date";
                        Position := Movement."Job Title";
                        Department := Movement."Department Name";
                        if Department = '' then
                            Department := Movement."Dept Code";

                        //If the person was paid last month, skip them
                        AssignmentMatrix.Reset();
                        AssignmentMatrix.SetRange("Employee No", Employee."No.");
                        AssignmentMatrix.SetRange("Payroll Period", PrevPeriod);
                        AssignmentMatrix.SetRange("Exclude from Payroll", false);
                        if AssignmentMatrix.FindFirst() then
                            CurrReport.Skip()
                        else begin
                            //If they were not paid last month but still this month they have NOT been paid, skip (this way, if you join in Nov 27th you'll only appear in Dec, not in both Nov and Dec)
                            if (Movement."Payroll Country" <> 'RISHWORTH') then begin
                                AssignmentMatrix2.Reset();
                                AssignmentMatrix2.SetRange("Employee No", Employee."No.");
                                AssignmentMatrix2.SetRange("Payroll Period", PayrollPeriod);
                                AssignmentMatrix2.SetRange("Exclude from Payroll", false);
                                if not AssignmentMatrix2.FindFirst() then
                                    CurrReport.Skip();
                            end;

                            if (Movement."Payroll Country" = 'RISHWORTH') then begin
                                //Only show if they joined this month - they get no salaries in system
                                if Movement."First Date" < PayrollPeriod then
                                    CurrReport.Skip();
                            end;
                        end;
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
        PayrollPeriod: Date;
        FirstDate: Date;
        Periods: Record "Payroll Period";
        PrevPeriod: Date;
        AssignmentMatrix: Record "Assignment Matrix";
        AssignmentMatrix2: Record "Assignment Matrix";
        Position: Text;
        Department: Text;
        ChangeType: Text;
}