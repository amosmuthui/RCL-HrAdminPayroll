pageextension 51525302 "Employee Card Ext HR" extends "Employee Card"
{
    layout
    {
        addafter("Sub Responsibility Center")
        {
            field("Sub Section"; Rec."Sub Section")
            { }
            field(Position; Rec.Position)
            { }
            field("Job Title1"; Rec."PTH Job Title")
            {
                Caption = 'Job Title';
                Editable = false;
            }
            field(Gender1; Rec.Gender)
            {
                Caption = 'Gender';
            }
            field("Pays tax"; Rec."Pays tax")
            { }
            field("Medical Insurance"; Rec."Medical Insurance")
            { }
            field("Apply Daily Rates"; Rec."Apply Daily Rates")
            {
            }
            field("Daily Rate"; Rec."Daily Rate")
            {
                trigger OnValidate()
                begin
                    if (Rec."Daily Rate" > 0) and (not Rec."Apply Daily Rates") then
                        Error('You must select Apply Daily Rates before providing the daily rate!');
                end;
            }
            field("Exempt from Housing Levy"; Rec."Exempt from Housing Levy")
            {
                Visible = false;
            }
            field("Skip Processing Housing Levy"; Rec."Skip Processing Housing Levy")
            {
                Visible = false;
            }
        }
        addafter(General)
        {
            group(Overtime)
            {
                field("Overtime AC"; Rec."Overtime AC")
                { }
                field("Overtime Amount Type"; Rec."Overtime Amount Type")
                { }
                field("Overtime Amount Currency"; Rec."Overtime Amount Currency")
                { }
                field("Hourly Rate"; Rec."Hourly Rate")
                { }
            }
            part("Staff Movement"; "Internal Emp. History List")
            {
                SubPageLink = "Emp No." = field("No.");
            }
            part("Payroll Variance Comments"; "Payroll Variance Comments")
            {
                SubPageLink = "Emp No." = field("No.");
            }
            part("Extra Payroll Banks"; "Extra Payroll Banks")
            {
                Visible = CanEditPaymentInfo;
                SubPageLink = "Emp No." = field("No.");
            }
            part("Transport Allowance Banks"; "Transport Allowance Banks")
            {
                Visible = CanEditPaymentInfo;
                SubPageLink = "Emp No." = field("No.");
            }

            group("Payment Information")
            {
                Caption = 'Payment Information';
                field("PIN Number"; Rec."PIN Number")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Pension No."; Rec."NSSF No.")
                { }
                field("Medical No."; Rec."NHIF No.")
                { }
                field("HELB No"; Rec."HELB No")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Co-Operative No"; Rec."Co-Operative No")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ShowMandatory = true;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                }
                field("Bank Branch Code"; Rec."Bank Branch Code")
                {
                    Visible = true;
                }
                field("Bank Brach Name"; Rec."Bank Brach Name")
                {
                    Editable = true;
                    Visible = true;
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    Editable = true;
                }
                field("Employee's Bank"; Rec."Employee's Bank")
                {
                    Visible = false;
                }
                field("Bank Branch"; Rec."Bank Branch")
                {
                    Visible = false;
                }
                field(IBAN2; Rec.IBAN)
                {
                    Caption = 'IBAN';
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                    Visible = true;
                }
                field("SWIFT Code1"; Rec."SWIFT Code")
                {
                    Caption = 'SWIFT Code';
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the employee has the account.';
                }
                field("Sort Code"; Rec."Sort Code")
                { }
                field(Indicatif; Rec.Indicatif)
                { }
                field("Code B.I.C."; Rec."Code B.I.C.")
                { }
                field("Contractual Amount Type"; Rec."Contractual Amount Type")
                {
                    Visible = CanEditPaymentInfo;
                }
                field("Assigned Gross Pay"; Rec."Assigned Gross Pay")
                {
                    Editable = false;
                    Visible = CanEditPaymentInfo;
                }
                field("Contractual Amount Currency"; Rec."Contractual Amount Currency")
                {
                    Visible = CanEditPaymentInfo;
                }
                field("Basic Pay"; Rec."Basic Pay")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Payroll Country"; Rec."Payroll Country")
                {
                    ApplicationArea = BasicHR;
                    Visible = true;
                }
                field("Payroll Currency"; Rec."Payroll Currency")
                {
                    Visible = true;
                }
                field("Payment/Bank Country"; Rec."Payment/Bank Country")
                {
                }
                field("Payment/Bank Currency"; Rec."Payment/Bank Currency")
                {
                    Visible = true;
                }
                field("No Transport Allowance"; Rec."No Transport Allowance")
                {
                    Tooltip = 'Does not earn transport allowance';
                }
                field("Applicable House Allowance (%)"; Rec."Applicable House Allowance (%)")
                {
                    Tooltip = 'For those who dont earn transport allowance';
                }
                field("Apply Paye Multiplier"; Rec."Apply Paye Multiplier")
                { }
                field("Paye Multiplier"; Rec."Paye Multiplier")
                { }
                field("Terminal Dues"; Rec."Terminal Dues")
                {
                }
                field(Insurance; Rec.Insurance)
                {
                    Editable = false;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    Caption = 'HR Posting Group/Contract Type';
                    ShowMandatory = true;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        Posting.Reset;
                        Posting.SetRange(Code, Rec."Posting Group");
                        if Posting.FindFirst then begin
                            if Posting."Seconded Employees" = true then
                                SecondVisible := true else
                                SecondVisible := false;
                        end;
                    end;
                }
                field("Home Ownership Status"; Rec."Home Ownership Status")
                {
                    ShowMandatory = true;
                    Visible = false;
                }
                group(Control103)
                {
                    ShowCaption = false;
                    Visible = SecondVisible;
                    field("Secondment Amount"; Rec."Secondment Amount")
                    {
                        Caption = 'Top up Allowance Amount';
                        Visible = false;
                    }
                    field("Seconding Organization"; Rec."Seconding Organization")
                    {
                        Visible = false;
                    }
                    field("Secondment Basic"; Rec."Secondment Basic")
                    {
                        Visible = false;
                    }
                }
                field("Salary Scale"; Rec."Salary Scale")
                {
                    Caption = 'Grade/Scale';
                    Visible = true;
                }
                field("Next Seniority Date"; Rec."Next Seniority Date")
                { }
                field("Number Of Years"; Rec.Present)
                {
                    Caption = 'Current Pointer';
                    Visible = false;
                }
                field(Previous; Rec.Previous)
                {
                    Caption = 'Previous Notch';
                    Editable = false;
                    Visible = true;
                }
                field(Present; Rec.Present)
                {
                    Caption = 'Current Notch';
                    Editable = true;
                    Visible = true;
                }
                field(Halt; Rec.Halt)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Incremental Month"; Rec."Incremental Month")
                {
                    Visible = false;
                }
            }
            group("Important Dates")
            {
                Caption = 'Important Dates';
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                    Caption = 'Date of First Appointment';
                }
                field("Years In Employment"; Rec."Years In Employment")
                {
                }
                field("Date of Appointment"; Rec."Date of Appointment")
                {
                    Caption = 'Date of Current Apointment';
                    Visible = false;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Current Contract Start Date"; Rec."Contract Start Date")
                {
                    Visible = true;
                }
                field("Current Contract End Date>"; Rec."Contract End Date")
                {
                    Visible = true;
                    Caption = 'Current Contract End Date';
                }
                field("Duration In Position"; Rec."Duration In Position")
                {
                    Visible = false;
                }
                field("End Of Probation Date"; Rec."End Of Probation Date")
                {
                }
                field("Pension Scheme Join"; Rec."Pension Scheme Join")
                {
                    Visible = false;
                }
                field("Date OfJoining Payroll"; Rec."Date OfJoining Payroll")
                {
                    Visible = false;
                }
                field("Retirement Date"; Rec."Retirement Date")
                {
                    Editable = false;
                }
                field("Remainig Years Before Retireme"; Rec."Remainig Years Before Retireme")
                {
                    Caption = 'Remaining Years Before Retirement';
                    Editable = false;
                }
                field("Suspend Probation Reminders"; Rec."Suspend Probation Reminders")
                {
                }
                field("Suspend Contract Reminders"; Rec."Suspend Contract Reminders")
                {
                }
                field("1Year Retirement Reminder Sent"; Rec."1Year Retirement Reminder Sent")
                {
                }
                field("Suspend Retirement Reminders"; Rec."Suspend Retirement Reminders")
                {
                }
            }
        }
        addlast(Administration)
        {
            field("Supervisor Name"; Rec."Supervisor Name")
            {
                Editable = IsNewRecord;
                LookupPageId = "Employee List";

                trigger OnLookup(var Text: Text): Boolean
                var
                    EmpList: Page "Employee List";
                    EmpRec: Record Employee;
                begin
                    if IsNewRecord then begin
                        if EmpList.RunModal() = Action::LookupOK then begin
                            EmpList.GetRecord(EmpRec);
                            Rec."Supervisor Name" := EmpRec."No.";
                        end;
                        exit(true);
                    end;
                end;
            }
            field("Contract Start Date"; Rec."Contract Start Date")
            {
                Visible = false;
            }
            field("Cause of Inactivity"; Rec."Cause of Inactivity")
            {
            }
        }

        addafter(Administration)
        {
            group("Airtime Management")
            {
                field("Job Category - Admin"; Rec."Job Category")
                {
                    Caption = 'Job Category';
                    ApplicationArea = All;
                }
                field("Ineligible for Airtime"; Rec."Ineligible for Airtime")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        addbefore("E&mployee")
        {
            group(Payroll)
            {
                action(Payslip)
                {
                    Caption = 'Payslip';
                    Image = DepositSlip;
                    Visible = true;

                    trigger OnAction()
                    var
                        periodrec: Record "Payroll Period";
                        AssMatrix: Record "Assignment Matrix";
                        AssMatrix1: Record "Assignment Matrix";
                        AssMatrix2: Record "Assignment Matrix";
                        LastPeriod: Date;
                    begin
                        periodrec.Reset;
                        periodrec.SetRange(periodrec.Closed, false);
                        if periodrec.FindLast then begin
                            EmpRec.Reset();
                            EmpRec.SETRANGE(EmpRec."No.", Rec."No.");
                            NewPayslipReport.SETTABLEVIEW(EmpRec);
                            CurrentPeriodRec.Reset;
                            CurrentPeriodRec.SetRange(CurrentPeriodRec."Starting Date", periodrec."Starting Date");
                            if CurrentPeriodRec.FindLast then
                                NewPayslipReport.SETTABLEVIEW(CurrentPeriodRec);
                            NewPayslipReport.SetReportFilter(Rec."No.", periodrec."Starting Date", Rec."Payroll Currency");
                            NewPayslipReport.Run();
                        end;
                    end;
                }
                action("Payroll Run")
                {
                    Caption = 'Payroll Run';
                    Image = PaymentPeriod;
                    Visible = CanEditPaymentInfo;

                    trigger OnAction()
                    var
                        periodrec: Record "Payroll Period";
                        PayProcessHeader: Record "Payroll Processing Header";
                        PayrollRunReport: Report "Payroll Run";
                    begin
                        periodrec.Reset;
                        periodrec.SetRange(periodrec.Closed, false);
                        if periodrec.FindLast then begin
                            EmpRec.Reset();
                            EmpRec.SETRANGE(EmpRec."No.", Rec."No.");
                            EmpRec.SetRange("Payroll Country", Rec."Payroll Country");
                            PayrollRunReport.SETTABLEVIEW(EmpRec);
                            PayrollRunReport.SetReportFilter(periodrec."Starting Date", Rec."No.");
                            PayrollRunReport.RUN;

                            PayProcessHeader.RESET;
                            PayProcessHeader.SETRANGE("Payroll Period", periodrec."Starting Date");
                            IF PayProcessHeader.FIND('-') THEN begin
                                PayProcessHeader."Date Processed" := TODAY;
                                PayProcessHeader.Modify();
                            end;
                        end;
                    end;
                }
                group(Earnings)
                {
                    Caption = 'Earnings';
                    Visible = true;
                    action("Additional Transactions")
                    {
                        Caption = 'Additional Earnings and Deductions';
                        Image = Payment;
                        RunObject = Page "Additional Transactions";
                        RunPageLink = "WB No." = FIELD("No.");
                    }
                    action("Assign Earnings")
                    {
                        Caption = 'Assign Earnings';
                        Visible = CanEditPaymentInfo;
                        Image = Payment;
                        RunObject = Page "Payment & Deductions";
                        RunPageLink = "Employee No" = FIELD("No."),
                                  Type = CONST(Payment),
                                  Closed = CONST(false);
                    }
                    action(List)
                    {
                        Caption = 'List';
                        RunObject = Page Earnings;
                    }
                    action("Display Recurring Earnings List")
                    {
                        Caption = 'Display Recurring Earnings List';
                        RunObject = Page "Payment & Deductions";
                        RunPageLink = "Employee No" = FIELD("No."),
                                  Type = CONST(Payment),
                                  Closed = CONST(false),
                                  Frequency = CONST(Recurring);
                    }
                    action("Display Non-recurring Earnings List")
                    {
                        Caption = 'Display Non-recurring Earnings List';
                        RunObject = Page "Payment & Deductions";
                        RunPageLink = "Employee No" = FIELD("No."),
                                  Type = CONST(Payment),
                                  Closed = CONST(false),
                                  Frequency = CONST("Non-recurring");
                    }
                    action("Salary Allocation")
                    {
                        Caption = ' Salary Allocation';
                        Image = Allocations;
                        RunObject = Page "Salary Allocation TT";
                        RunPageLink = "Employee No" = FIELD("No.");
                    }
                }
                group(Deductions)
                {
                    Caption = 'Deductions';
                    Visible = true;
                    action("Assign Deductions")
                    {
                        Caption = 'Assign Deductions';
                        Visible = CanEditPaymentInfo;
                        Image = TaxPayment;
                        RunObject = Page "Payment & Deductions";
                        RunPageLink = "Employee No" = FIELD("No."),
                                  Type = CONST(Deduction),
                                  Closed = CONST(false);
                    }
                    action("Deductions List")
                    {
                        Caption = 'Deductions List';
                        RunObject = Page Deductions;
                    }
                    action("Display Recurring  Deductions  List")
                    {
                        Caption = 'Display Recurring  Deductions  List';
                        RunObject = Page "Payment & Deductions";
                        RunPageLink = "Employee No" = FIELD("No."),
                                  Type = CONST(Deduction),
                                  Closed = CONST(false),
                                  Frequency = CONST(Recurring);
                    }
                    action("Display Non-Recurring Deduction List")
                    {
                        Caption = 'Display Non-Recurring Deduction List';
                        RunObject = Page "Payment & Deductions";
                        RunPageLink = "Employee No" = FIELD("No."),
                                  Type = CONST(Deduction),
                                  Closed = CONST(false),
                                  Frequency = CONST("Non-recurring");
                    }
                }
            }
        }

        addbefore(Category_Process)
        {
            group("Payroll_Promoted")
            {
                Caption = 'Payroll';
                actionref(Payslip_Promoted; Payslip)
                {
                }
                actionref(Payroll_Run_Promoted; "Payroll Run")
                {
                }
                group("Earnings_Promoted")
                {
                    Caption = 'Earnings';
                    actionref(Additional_Transactions_Promoted; "Additional Transactions")
                    {
                    }
                    actionref("Assign Earnings Promoted"; "Assign Earnings") { }
                    actionref(List_Promoted; List) { }
                    actionref("Display Recurring Earnings List Promoted"; "Display Recurring Earnings List") { }
                    actionref("Display Non-recurring Earnings List Promoted"; "Display Non-recurring Earnings List")
                    { }
                    actionref("Salary Allocation Promoted"; "Salary Allocation")
                    { }
                }
                group("Deductions_Promoted")
                {
                    Caption = 'Deductions';
                    actionref("Assign Deductions Promoted"; "Assign Deductions") { }
                    actionref(Deductions_List_Promoted; "Deductions List") { }
                    actionref("Display Recurring  Deductions  List Promoted"; "Display Recurring  Deductions  List") { }
                    actionref("Display Non-Recurring Deduction List Promoted"; "Display Non-Recurring Deduction List")
                    { }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.Validate(Position);

        if Rec."Overtime Amount Currency" = '' then
            Rec."Overtime Amount Currency" := 'USD';
        if Rec."Overtime AC" = '' then
            Rec."Overtime AC" := Rec."Sub Section";

        Posting.Reset;
        Posting.SetRange(Code, Rec."Posting Group");
        if Posting.FindFirst then begin
            if Posting."Seconded Employees" = true then
                SecondVisible := true else
                SecondVisible := false;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IsNewRecord := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.Validate(Position);
        SetNoFieldVisible;
        SecondVisible := false;
        Posting.Reset;
        Posting.SetRange(Code, Rec."Posting Group");
        if Posting.FindFirst then begin
            if Posting."Seconded Employees" = true then
                SecondVisible := true else
                SecondVisible := false;
        end;

        CanEditCard := false;
        CanEditPaymentInfo := false;
        CanEditLeaveInfo := false;
        CanViewPayrollCard := false;
        UserSetup.Reset();
        UserSetup.SetRange("User ID", UserId);
        if UserSetup.FindFirst() then begin
            CanEditCard := UserSetup."Can Edit Emp Card";
            CanEditPaymentInfo := UserSetup."Can Edit Payroll Info";
            CanEditLeaveInfo := UserSetup."Can Edit Leave Entitlement";
            CanViewPayrollCard := UserSetup."Can View Payroll Card";
            if (CanEditPaymentInfo) and (not CanViewPayrollCard) then
                CanViewPayrollCard := true;
        end;

        if not CanViewPayrollCard then
            Error('Apologies, but it seems you don''t have the necessary permissions to view this page!');
    end;

    // *** CHANGED: Added Last Modified By stamp ***
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        FreshRec: Record Employee;
    begin
        if (Rec."Daily Rate" = 0) and (Rec."Apply Daily Rates") then
            Error('You have checked the Apply Daily Rates option but failed to provide the daily rate (amount)! Kindly provide the rate or uncheck the Apply Daily Rates!');
        if Rec."Payment/Bank Country" = '' then
            Message('Consider providing the Payment/Bank Country before you leave this page!');
        if (Rec.Status = Rec.Status::Inactive) and (Rec."Cause of Inactivity Code" = '') then
            Message('Kindly remember to specify the cause of inactivity for this inactive staff!');
        //Rec.Modify(); //Save adjustments like position-title - but fetch as fresh to prevent errors
        FreshRec.Reset();
        FreshRec.SetRange("No.", Rec."No.");
        if FreshRec.FindFirst() then begin
            FreshRec."Job Title" := Rec."Job Title";
            FreshRec."Overtime AC" := Rec."Overtime AC";
            FreshRec."Overtime Amount Currency" := Rec."Overtime Amount Currency";
            FreshRec."Last Modified By" := CopyStr(UserId, 1, MaxStrLen(FreshRec."Last Modified By"));
            FreshRec.Modify();
        end;
    end;

    var
        CanEditPaymentInfo: Boolean;
        UserSetup: Record "User Setup";
        CanEditCard: Boolean;
        IsNewRecord: Boolean;
        CanEditLeaveInfo: Boolean;
        CanViewPayrollCard: Boolean;
        SecondVisible: Boolean;
        Posting: Record "Staff Posting Group";
        NoFieldVisible: Boolean;
        EmpRec: Record Employee;
        NewPayslipReport: Report "New Payslip";
        CurrentPeriodRec: Record "Payroll Period";

    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        NoFieldVisible := DocumentNoVisibility.EmployeeNoIsVisible;
    end;
}





