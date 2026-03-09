tableextension 51525300 "Emp Ext" extends Employee
{
    fields
    {
        field(5152530; "Pays SSF"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5152531; "Pays tax"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5152532; "Section/Location"; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //IF SalaryGrade.GET("Salary Grade") THEN
                //"Basic Pay":=SalaryGrade."Minimum salary";
                //MaximumPay:=SalaryGrade."Maximum Salary";
            end;
        }
        field(5152533; "Basic Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5152534; "Salary Type"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5152535; "Paid Overtime"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5152536; "Tax Relief"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5152537; "Overtime taxed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5152538; "Agency Car"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5152539; "Housed by Employer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525310; "Employee's Bank"; Code[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            //TableRelation = "KBA Bank Names";
        }
        field(51525311; "Paying Bank Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(51525312; "Taxable Allowance"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Taxable = CONST(true),
                                                                "Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Type = CONST(Payment),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Normal Earnings" = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525313; "Tax Deductible Amount"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Tax Deductible" = CONST(true),
                                                                "Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Non-Cash Benefit" = CONST(false),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525314; "Employee Type"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51525315; "Total Allowances"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Payment),
                                                                "Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Non-Cash Benefit" = CONST(false),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Normal Earnings" = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525316; "Total Deductions"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = FILTER(Deduction | Loan),
                                                                "Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                Information = CONST(false),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525317; Payment; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bracket Tables";
        }
        field(51525318; Deduction; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Assignment Matrix";
        }
        field(51525319; "Posting Group"; Code[10])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Staff Posting Group";
        }
        field(51525320; "Total Savings"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                Type = CONST("Saving Scheme"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525321; "Bank Account Number"; Code[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(51525322; "Bank Branch"; Code[100])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Kenya Bankers Association Code"."Branch Name";
        }
        field(51525323; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll Period"."Starting Date";
            ValidateTableRelation = true;
        }
        field(51525324; "Opening SSF"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525325; "Opening PAYE"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525326; "Tax Deductible to Date"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Tax Deductible" = CONST(true),
                                                                "Employee No" = FIELD("No."),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Payroll Period" = FIELD(UPPERLIMIT("Pay Period Filter")),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525327; "SSF Employer to Date"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix"."Employer Amount" WHERE("Tax Deductible" = CONST(true),
                                                                           "Employee No" = FIELD("No."),
                                                                           "Payroll Period" = FIELD(UPPERLIMIT("Pay Period Filter"))));
            FieldClass = FlowField;
        }
        field(51525328; "Opening Employer SSF"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525329; "Cumm. Basic Pay"; Decimal)
        {
            CalcFormula = Sum("Staff Ledger Entry"."Basic Pay" WHERE("Payroll Period" = FIELD("Pay Period Filter"),
                                                                      Employee = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525330; "Tax Relief Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525331; "P.I.N"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(51525332; "Passport No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*Employee.RESET;
                Employee.SETRANGE(Employee."Passport No.","Passport No.");
                IF Employee.FIND('-') THEN
                ERROR('You have already created an employee with Passport Number %1 in Employee No %2',Employee."Passport No.",Employee."No.");
                */

            end;
        }
        field(51525333; "Cumm. PAYE"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                Paye = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525334; "Cumm. Net Pay"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51525337; Test; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51525338; "Hourly Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525339; "Daily Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525340; "Pays N.H.I.F"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525341; "Last Modified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51525342; "Gross Cash"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525343; "Customer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(51525345; "Benefits-Non Cash"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Non-Cash Benefit" = CONST(true),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                Type = CONST(Payment),
                                                                Taxable = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525346; "Pay Mode"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Bank,Cash,Cheque,"Bank Transfer";
        }
        field(51525347; Housing; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Agricultural,Directors,Ordinary;
        }
        field(51525348; "Home Savings"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Type = CONST(Deduction),
                                                                "Tax Deductible" = CONST(true),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                Retirement = CONST(false),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525349; "Retirement Contribution"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                Code = CONST('D15'),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525350; "Home Ownership Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "None","Owner Occupier","Home Savings";
        }
        field(51525351; "Owner Occupier"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Type = CONST(Payment),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Tax Deductible" = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525352; "National ID"; Code[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;

            trigger OnValidate()
            begin
                EmployeeRec.Reset;
                EmployeeRec.SetRange(EmployeeRec."National ID", "National ID");
                if EmployeeRec.Find('-') then
                    Error('You have already created an employee with ID Number %1 in Employee No %2', "National ID", EmployeeRec."No.");
                "ID Number" := "National ID";
            end;
        }
        field(51525353; "House Rent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525354; "Employer Rent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525355; "Total Quarters"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525356; "Cumulative Quarters"; Decimal)
        {
            CalcFormula = Sum("Staff Ledger Entry".Quarters WHERE(Employee = FIELD("No."),
                                                                   "Payroll Period" = FIELD("Pay Period Filter")));
            FieldClass = FlowField;
        }
        field(51525357; BfMpr; Decimal)
        {
            CalcFormula = Sum("Staff Ledger Entry".BfMpr WHERE(Employee = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter")));
            FieldClass = FlowField;
        }
        field(51525358; PensionNo; Code[10])
        {
            Caption = 'Pension No';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "NSSF No." := PensionNo;
            end;
        }
        field(51525359; "Salary Scheme Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Category;
        }
        field(51525360; "Salary Steps"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salary Steps"."Step Code" WHERE("Category code" = FIELD("Salary Scheme Category"),
                                                              Level = FIELD(Level));
        }
        field(51525361; Level; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Level 1","Level 2";
        }
        field(51525365; "Share Amount"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                Shares = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            Caption = 'coop skg fund';
            FieldClass = FlowField;
        }
        field(51525366; "House allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525367; Overtime; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51525368; Absence; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525369; "Other allowances"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525370; "Total earnings"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525371; PAYE; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525372; NHIF; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525373; NSSF; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525374; Advance; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Deduction),
                                                                "Employee No" = FIELD("No."),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Code = FIELD("Advance Code Filter"),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525375; Loans; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525376; COOP; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525377; "Other deductions"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                Paye = CONST(false),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525379; "Net pay"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Non-Cash Benefit" = CONST(false),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Employee No" = FIELD("No."),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525380; "Advance Code Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Deductions.Code;
        }
        field(51525381; "Gross pay"; Decimal)
        {
            Caption = 'Cumulative Gross Pay';
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Employee No" = FIELD("No."),
                                                                Type = CONST(Payment),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Gross Pay" = FILTER(false)
                                                                /*Code = CONST('001')*/,
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525382; interest; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix"."Interest Amount" WHERE("Employee No" = FIELD("No."),
                                                                           "Payroll Period" = FIELD("Pay Period Filter"),
                                                                           Type = FILTER(Deduction)));
            FieldClass = FlowField;
        }
        /*field(51525383; "Working Hours"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //"Hourly Rate":="Daily Rate"/"Working Hours";
            end;
        }*/
        field(51525384; "No. Of Days Worked"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51525385; "No. of Hours"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51525386; "No. Of Hours Weekend"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51525387; Basic; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Payment),
                                                                "Employee No" = FIELD("No."),
                                                                "Basic Pay Arrears" = CONST(false),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Basic Salary Code" = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525388; ECode; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51525389; SKey; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525390; Employer; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525391; "Taxable Income"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                Taxable = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525392; "Job ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525394; "Home Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525395; "Cellular Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525396; "Work Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525397; "Ext."; Text[7])
        {
            DataClassification = ToBeClassified;
        }
        field(51525398; "ID Number"; Text[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;

            trigger OnValidate()
            begin
                EmployeeRec.Reset;
                EmployeeRec.SetRange(EmployeeRec."ID Number", "ID Number");
                if EmployeeRec.Find('-') then
                    Error('You have already created an employee with ID Number %1 in Employee No %2', "ID Number", EmployeeRec."No.");

                "National ID" := "ID Number";
            end;
        }
        field(51525399; Gender2; Option)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            OptionMembers = Female,Male;
        }
        field(51525400; "Fax Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525404; "Known As"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*IF (("Known As" <> xRec."Known As") AND  (xRec."Known As" <> ''))  THEN BEGIN
                       CareerEvent.SetMessage('Changing First Name in Career History');
                       CareerEvent.RUNMODAL;
                       OK:= CareerEvent.ReturnResult;
                        IF OK THEN BEGIN
                           HRCareerHistoryRec.INIT;
                           IF NOT HRCareerHistoryRec.FIND('-') THEN
                            HRCareerHistoryRec."Line No.":=1
                          ELSE BEGIN
                            HRCareerHistoryRec.FIND('+');
                            HRCareerHistoryRec."Line No.":=HRCareerHistoryRec."Line No."+1;
                          END;

                           HRCareerHistoryRec.Reason := CareerEvent.ReturnReason;
                           HRCareerHistoryRec."Employee No.":= "No.";
                           HRCareerHistoryRec."Date Of Event":= TODAY;
                           HRCareerHistoryRec."Career Event":= 'Surname Changed';
                           HRCareerHistoryRec."Last Name":= "Last Name";
                           HRCareerHistoryRec."Employee First Name":= "Known As";
                           HRCareerHistoryRec."Employee Last Name":= "Last Name";

                           HRCareerHistoryRec.INSERT;
                        END;
                    END;
                  */

            end;
        }
        field(51525405; Position; Code[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                CompanyJobsRec.Reset;
                CompanyJobsRec.SetRange("Job ID", Position);
                if CompanyJobsRec.FindFirst then begin
                    "Establishment Name" := CompanyJobsRec."Job Description";
                    "Job Title" := CopyStr(CompanyJobsRec."Job Description", 1, MaxStrLen("Job Title"));
                    "PTH Job Title" := CompanyJobsRec."Job Description";
                end;
            end;
        }
        field(51525406; "Full / Part Time"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Full Time"," Part Time";

            trigger OnValidate()
            begin
            end;
        }
        field(51525407; "Contract Type"; Code[60])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employment Contract";

            trigger OnValidate()
            begin
            end;
        }
        field(51525408; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Contract Expiry Notified" := false;
                "Expiry Notification DateTime" := CreateDateTime(0D, 0T);
            end;
        }
        field(51525409; "Notice Period"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51525410; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;

            trigger OnValidate()
            begin
            end;
        }
        field(51525411; "Ethnic Origin"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = African,Indian,White,Coloured;

            trigger OnValidate()
            begin
            end;
        }
        field(51525412; "First Language (R/W/S)"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Company Jobs";
        }
        field(51525414; "Date Of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = ToBeClassified;
            NotBlank = true;

            trigger OnValidate()
            begin
                HumanResSetup.Reset;
                HumanResSetup.Get;
                if Disabled = false then begin
                    "Retirement Date" := CalcDate(HumanResSetup."Retirement Age", "Date Of Birth");
                    "Remainig Years Before Retireme" := Format(HRDates.DetermineAge(Today, CalcDate(HumanResSetup."Retirement Age", "Date Of Birth")));
                end else begin
                    "Retirement Date" := CalcDate(HumanResSetup."Retirement Age PWD", "Date Of Birth");
                    "Remainig Years Before Retireme" := Format(HRDates.DetermineAge(Today, "Retirement Date"));
                end;

                if (("Contract End Date" = 0D) OR ("Contract End Date" <> "Retirement Date")) and (("Contract Type" = 'PERMANENT') OR ("Contract Type" = '')) then
                    "Contract End Date" := "Retirement Date";
                //Update last movement
                EmpHist.Reset();
                EmpHist.SetRange("Emp No.", "No.");
                EmpHist.SetRange(Status, EmpHist.Status::Current);
                if EmpHist.FindFirst() then begin
                    EmpHist."Last Date" := "Contract End Date";
                    EmpHist.Modify();
                end;
            end;
        }
        field(51525415; Age; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(51525416; "Date Of Join"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;

            trigger OnValidate()
            begin
                "Date of Appointment" := "Date Of Join";
                Validate("Date of Appointment");
                "End Of Probation Date" := CALCDATE('+' + format(HumanResSetup."Probation Period(Months)") + 'M', "Date Of Join");
                Validate("Employment Date");
            end;
        }
        field(51525417; "Length Of Service"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525418; "End Of Probation Date"; Date)
        {
            Caption = 'End of Probation Date';
            DataClassification = ToBeClassified;
        }
        field(51525419; "Pension Scheme Join"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            end;
        }
        field(51525420; "Time Pension Scheme"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525421; "Medical Scheme Join"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            end;
        }
        field(51525422; "Time Medical Scheme"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525423; "Date Of Leaving"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("Date Of Leaving" <> 0D) and ("Date Of Leaving" <> xRec."Date Of Leaving") then begin
                end;

                //KKB 13/09/2017
                if "Date Of Leaving" <> 0D then begin
                    AssMatrix.Reset;
                    AssMatrix.SetFilter("Employee No", "No.");
                    AssMatrix.SetFilter("Payroll Period", '%1', CalcDate('-CM', "Date Of Leaving"));
                    AssMatrix.SetFilter(Closed, '%1', false);
                    if AssMatrix.FindSet then begin
                        ansmsg := 'Employee No: ' + "No." + '- ' + "First Name" + ' ' + "Last Name" + ' already has Payroll Data For Period ' +
                        Format(CalcDate('-CM', "Date Of Leaving")) + '\Do you want to Clear his or her Payroll Entries?\If you Select Yes Entries will be Cleared.';
                        ans := Confirm(ansmsg);
                        if Format(ans) = 'Yes' then begin
                            repeat
                                AssMatrix.Delete;
                            until AssMatrix.Next = 0;
                        end;
                    end;
                end;
                //==================================================
            end;
        }
        field(51525424; "Second Language (R/W/S)"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51525425; "Additional Language"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51525426; "Termination Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Mandatory Retirement,Retirement at 50,Retirement on Medical Ground,Retirement on abolition of office,Death,Resignation,Dismissal,Retirement on public interest,Lay Off,Retrenchment,End of Contract';
            OptionMembers = ,"Mandatory Retirement","Retirement at 50","Retirement on Medical Ground","Retirement on abolition of office",Death,Resignation,Dismissal,"Retirement on public interest","Lay Off",Retrenchment,"End of Contract";

            trigger OnValidate()
            var
                "Lrec Resource": Record Resource;
                OK: Boolean;
            begin
                if "Resource No." <> '' then begin
                    OK := "Lrec Resource".Get("Resource No.");
                    "Lrec Resource".Blocked := true;
                    "Lrec Resource".Modify;
                end;
            end;
        }
        field(51525427; "Job Specification"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525429; Citizenship; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(51525430; "Passport Number"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            end;
        }
        field(51525431; "First Language Read"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525432; "First Language Write"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525433; "First Language Speak"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525434; "Second Language Read"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525435; "Second Language Write"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525436; "Second Language Speak"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525437; "PIN Number"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            Caption = 'TIN Number';
        }
        field(51525438; "NSSF No."; Code[20])
        {
            Caption = 'Pension No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(51525439; "NHIF No."; Code[20])
        {
            Caption = 'Medical No.';
            DataClassification = ToBeClassified;
        }
        field(51525442; "HELB No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525443; "Co-Operative No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525444; "Position To Succeed"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
            end;
        }
        field(51525445; "Succesion Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51525446; "Send Alert to"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525447; Religion; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            end;
        }
        field(51525449; "Served Notice Period"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525450; "Exit Interview Date"; Date)
        {
            CalcFormula = Lookup("Job Exit Interview"."Document Date" WHERE(Code = FIELD("Exit Interview")));
            FieldClass = FlowField;
        }
        field(51525451; "Exit Interview Done by"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(51525452; "Allow Re-Employment In Future"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525453; "Postal Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525454; "Residential Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525455; "Postal Address2"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525456; "Postal Address3"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525457; "Residential Address2"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525458; "Residential Address3"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525459; "Post Code2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(51525460; "Incremental Month"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(51525461; "Current Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51525462; Present; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Scale Benefits"."Salary Pointer" WHERE("Salary Scale" = FIELD("Salary Scale"));

            trigger OnValidate()
            begin
            end;
        }
        field(51525463; Previous; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Scale Benefits"."Salary Pointer" WHERE("Salary Scale" = FIELD("Salary Scale"));
        }
        field(51525464; Halt; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525465; "Salary Scale"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salary Scales".Scale;

            trigger OnValidate()
            begin
                if SalaryScalesRec.Get("Salary Scale") then
                    Halt := SalaryScalesRec."Maximum Pointer";
            end;
        }
        field(51525466; Insurance; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Deduction),
                                                                "Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Insurance Code" = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525467; "days worked"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525468; "Pro-Rata on Joining"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525469; "Pro-rata on Leaving"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525470; "Date OfJoining Payroll"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Employment Date");
                if "Date OfJoining Payroll" < "Employment Date" then
                    Error('Date of join payroll cannot be earlier then Employment Date');
            end;
        }
        field(51525471; "PAYE Diff"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525472; "Pro-Rata Calculated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525473; "Half Pay"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525474; "Basic Arrears"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Payment),
                                                                "Employee No" = FIELD("No."),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Basic Pay Arrears" = CONST(true),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525475; "Relief Amount"; Decimal)
        {
            CalcFormula = - Sum("Assignment Matrix".Amount WHERE("Employee No" = FIELD("No."),
                                                                 "Payroll Period" = FIELD("Pay Period Filter"),
                                                                 "Non-Cash Benefit" = CONST(true),
                                                                 Type = CONST(Payment),
                                                                 "Tax Deductible" = CONST(true),
                                                                 Country = FIELD("Payroll Country Filter"),
                                                                 "Tax Relief" = CONST(false),
                                                                 "Manual Entry" = CONST(false),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525476; "Employee Qty"; Integer)
        {
            CalcFormula = Count(Employee);
            FieldClass = FlowField;
        }
        field(51525477; "Employee Act. Qty"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Status = CONST(Active)));
            FieldClass = FlowField;
        }
        field(51525478; "Employee Arc. Qty"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Status = FILTER(<> Active)));
            FieldClass = FlowField;
        }
        field(51525479; "Other Language Read"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525480; "Other Language Write"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525481; "Other Language Speak"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525483; cumul; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51525484; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51525485; "Contract Number"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Contracts"."Contract No" WHERE("Employee No" = FIELD("No."),
                                                                      Status = CONST(Active));

            trigger OnValidate()
            begin
            end;
        }
        field(51525486; "Leave Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525487; "Ethnic Group"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ethnic Groups".Code;
        }
        field(51525488; "Resource Request Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Cancelled';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Cancelled;
        }
        field(51525489; "Exit Interview"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Exit Interview";
        }
        field(51525490; "Is Intern"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525491; "On Contract"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525492; "Is Permanent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525493; Disabled; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525497; "KRA PIN Document Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525498; "NSSF Document Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51525499; "NHIF Document Path"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 's';
        }
        field(51525500; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No." where("Bank Type" = const("Normal Bank"));

            trigger OnValidate()
            begin
                "Bank Name" := '';
                if "Bank Code" <> '' then begin
                    Banks.Reset();
                    Banks.SetRange("No.", "Bank Code");
                    if Banks.FindFirst() then
                        "Bank Name" := Banks.Name;
                end;
            end;
        }
        field(51525501; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525502; "Bank Branch Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."Bank Branch No." WHERE("No." = FIELD("Bank Code"));

            trigger OnValidate()
            begin
            end;
        }
        field(51525503; "Bank Brach Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51525504; "Bank Account No"; Code[30])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Bank Account No." := "Bank Account No";
                CheckDuplicateBankAccountNo("Bank Account No");
            end;
        }
        field(51525505; "Current Appointment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51525506; "Remainig Years Before Retireme"; Text[40])
        {
            DataClassification = ToBeClassified;
        }
        field(51525507; "Sub County"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub County"."Sub County Code" WHERE("County Code" = FIELD(County));
        }
        field(51525508; Constituency; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Constituency."Contituency Code" WHERE("Sub County Code" = FIELD("Sub County"));
        }
        field(51525509; "Retirement Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(51525510; "Date of Appointment"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Date of Appointment" <> 0D then begin
                    "Duration In Position" := Format(HRDates.DetermineAge("Date of Appointment", Today));
                end;
            end;
        }
        field(51525511; "Duration In Position"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(51525512; "Secondment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525513; "Salary Changed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525514; "Seconding Organization"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Seconding Organizations".Code;
        }
        field(51525515; "Secondment Basic"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51525516; "Substitute No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(51525517; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525518; "Job Grade"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525519; PasswordResetToken; Text[250])
        {
            Caption = 'PasswordResetToken';
            DataClassification = ToBeClassified;
        }
        field(51525520; PasswordResetTokenExpiry; DateTime)
        {
            Caption = 'PasswordResetTokenExpiry';
            DataClassification = ToBeClassified;
        }
        field(51525521; "Portal Password"; Text[250])
        {
            Caption = 'Portal Password';
            DataClassification = ToBeClassified;
        }
        field(51525522; "Default Portal Password"; Boolean)
        {
            Caption = 'Default Portal Password';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51525523; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(51525524; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(51525525; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(51525526; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(51525527; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(51525528; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          "Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(false));
        }
        field(51525529; "Leave Calendar"; Code[20])
        {
            Caption = 'Leave Calendar';
            DataClassification = ToBeClassified;
            TableRelation = "Base Calendar".Code;
        }
        field(51525530; "Sender Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51525532; "Years In Employment"; Text[40])
        {
            DataClassification = ToBeClassified;
        }
        field(51525533; "Is Temporary"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525534; "Leave Period"; Code[20])
        {
            CalcFormula = Lookup("HR Leave Periods"."Period Code" WHERE(Closed = FILTER(false)));
            FieldClass = FlowField;
        }
        field(51525535; "Reimbursed Leave Days"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("No."),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             "Leave Entry Type" = CONST(Reimbursement),
                                                                             Closed = CONST(false),
                                                                             "Is For Annual Leave" = CONST(true)));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                Validate("Allocated Leave Days");
            end;
        }
        field(51525536; "Allocated Leave Days"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("No."),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             "Leave Entry Type" = CONST(Positive),
                                                                             Closed = CONST(false),
                                                                             "Is For Annual Leave" = CONST(true),
                                                                             "Leave Type" = FILTER(<> 'CF'),
                                                                             "Leave Period" = FIELD("Leave Period")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CalcFields("Total Leave Taken", LeaveCarryForward);
                CalcFields("Reimbursed Leave Days");
                "Total (Leave Days)" := "Allocated Leave Days" + "Reimbursed Leave Days" + LeaveCarryForward;
                "Leave Balance" := "Total (Leave Days)" + "Total Leave Taken";
                Rec.Modify;
            end;
        }
        field(51525537; "Total Leave Taken"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("No."),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             "Leave Entry Type" = CONST(Negative),
                                                                             Closed = CONST(false),
                                                                             "Is For Annual Leave" = CONST(true),
                                                                             IsMonthlyAccrued = CONST(false),
                                                                             "Leave Period" = FIELD("Leave Period")));
            DecimalPlaces = 2 : 2;
            FieldClass = FlowField;
        }
        field(51525538; LeaveCarryForward; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("No."),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             Closed = CONST(false),
                                                                             "Leave Type" = FILTER('CF|CARRY FORWARD'),
                                                                             "Leave Period" = FIELD("Leave Period")));
            FieldClass = FlowField;
        }
        field(51525539; MonthlyAccrued; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Staff No." = FIELD("No."),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             Closed = CONST(false),
                                                                             "Document No." = CONST('ACCRUE'),
                                                                             "Leave Period" = FIELD("Leave Period")));
            FieldClass = FlowField;
        }
        field(51525540; "Total (Leave Days)"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(51525541; Location; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525542; "Leave Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',On Leave ';
            OptionMembers = ,"On Leave ";
        }
        field(51525543; Board; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525544; "Disciplinary Actions"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'None,Suspension,Interdiction';
            OptionMembers = "None",Suspension,Interdiction;
        }
        field(51525545; "Establishment Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(51525546; "Allowance Collected"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525547; "Can Initiate Staff Requisition"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525548; "Leave Balance New"; Decimal)
        {
            CalcFormula = Sum("HR Leave Ledger Entries"."No. of days" WHERE("Leave Type" = FILTER('CF' | 'ANNUAL' | 'CARRY FORWARD'),
                                                                             "Staff No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(51525549; "Leave Period New"; Code[20])
        {
            CalcFormula = Lookup("Payroll Period"."Period Codes" WHERE(Closed = CONST(false)));
            FieldClass = FlowField;
        }
        field(51525550; "elearrning Portal Password"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(51525551; "Grant/Compliance Officer"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525552; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Shared,Fixed';
            OptionMembers = ,Shared,"Fixed";

            trigger OnValidate()
            begin
                if Category = Category::Shared then
                    "Global Dimension 2 Code" := 'SHARED';
                Rec.Modify;
            end;
        }
        field(51525553; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;

            trigger OnValidate()
            var
                Item: Record Item;
                IsHandled: Boolean;
            begin
            end;
        }
        field(51525554; "Total Earnings Calc"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Payment),
                                                                "Employee No" = FIELD("No."),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Exclude from Payroll" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51525555; "Month Filter"; Text[30])
        {
            FieldClass = FlowFilter;
        }
        field(51525556; "Year Filter"; Text[30])
        {
            FieldClass = FlowFilter;
        }
        field(51525557; "Earns Gratuity"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525558; "Is Seconded"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525559; "Apply Daily Rates"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525560; "Contract Expiry Notified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525561; "Expiry Notification DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(51525562; "Exempt from Housing Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525563; "Skip Processing Housing Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(51525564; "Assigned Gross Pay"; Decimal)
        {
            Caption = 'Contractual Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51525565; "Payroll Category"; Option)
        {
            OptionCaption = 'Local Staff,Expatriate,Seconded Staff';
            OptionMembers = "Local Staff",Expatriate,"Seconded Staff";
        }
        field(51525566; "Month Basic Pay"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Employee No" = FIELD("No."),
                                                                Type = CONST(Payment),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Basic Salary Code" = FILTER(true),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525567; "Month Gross Pay"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Employee No" = FIELD("No."),
                                                                Type = CONST(Payment),
                                                                "Exclude from Calculations" = const(false),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Gross Pay" = FILTER(true),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525568; "Month Transport Allowance"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Employee No" = FIELD("No."),
                                                                Type = CONST(Payment),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Transport Allowance" = FILTER(true),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525569; "Payroll Currency"; Code[20])
        {
            TableRelation = "Currency";
            Editable = false;
        }
        field(51525570; "Payment/Bank Currency"; Code[20])
        {
            TableRelation = "Currency";
        }
        field(51525571; "Contractual Amount Type"; Option)
        {
            OptionCaption = 'Gross Pay,Basic Pay,Net Pay';
            OptionMembers = "Gross Pay","Basic Pay","Net Pay";
            Editable = false;
        }
        field(51525572; "Payroll Country"; Code[50])
        {
            TableRelation = "Country/Region";
            Editable = false;
            trigger OnValidate()
            var
                SelectedCountry: Record "Country/Region";
            begin
                SelectedCountry.reset;
                SelectedCountry.setrange("Code", "Payroll Country");
                if SelectedCountry.findfirst then begin
                    "Payroll Currency" := SelectedCountry."Country Currency";
                end;
                if ("Payroll Country" <> '') and ("Payment/Bank Country" = '') then
                    "Payment/Bank Country" := "Payroll Country";
            end;
        }
        field(51525573; "Month Statutory Deductions"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE("Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Employee No" = FIELD("No."),
                                                                Type = CONST(Deduction),
                                                                Country = FIELD("Payroll Country Filter"),
                                                                "Is Statutory" = FILTER(true),
                                                                "Exclude from Payroll" = const(false)));
            FieldClass = FlowField;
        }
        field(51525574; "Workstation Country"; Code[50])
        {
            TableRelation = "Country/Region";
        }
        field(51525575; "Contractual Amount Currency"; Code[20])
        {
            TableRelation = "Currency";
            Editable = false;
        }
        field(51525576; "Annual Leave Entitlement"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Annual Leave Entitlement" < 0 then
                    error('The annual leave entitlement cannot be less than 0!');
            end;
        }
        field(51525577; "No. of Children"; Integer)
        {
            trigger OnValidate()
            begin
                if "No. of Children" < 0 then
                    error('The number of children cannot be less than 0!');
            end;
        }
        field(51525578; Station; Code[100])
        {
            TableRelation = "Stations";
        }
        field(51525579; Province; Code[50])
        {
            TableRelation = "Provinces";
        }
        field(51525580; District; Code[50])
        {
            TableRelation = "Districts";
        }
        field(51525581; Sector; Code[50])
        {
            TableRelation = "Sectors";
        }
        field(51525582; Cell; Code[50])
        {
            TableRelation = "Cells";
        }
        field(51525583; Village; Code[50])
        {
            TableRelation = "Villages";
        }
        field(51525584; "Plot No."; Code[50])
        {
        }
        field(51525585; "Street No."; Code[50])
        {
        }
        field(51525586; "Medical Insurance"; Option)
        {
            OptionCaption = 'RAMA,MMI';
            OptionMembers = Normal,MMI;
        }
        field(51525587; "Medical No."; Code[50])
        {
            trigger OnValidate()
            begin
                "NHIF No." := "Medical No.";
            end;
        }
        // *** Supervisor Name is read-only on Employee Card - changes go through Change Request ***
        field(51525588; "Supervisor Name"; Code[20])
        {
            Editable = true;
            TableRelation = Employee."No.";
        }
        field(51525589; "Payroll Country Filter"; Code[50])
        {
            FieldClass = FlowFilter;
            TableRelation = "Country/Region".Code;
            ValidateTableRelation = true;
        }
        field(51525590; "No Transport Allowance"; Boolean)
        {
            trigger OnValidate()
            begin
                "Applicable House Allowance (%)" := 0;
                if "No Transport Allowance" then
                    "Applicable House Allowance (%)" := 84;
            end;
        }
        field(51525591; "Applicable House Allowance (%)"; Decimal)
        {
        }
        field(51525592; "Apply Paye Multiplier"; Boolean)
        {
            Editable = false;
        }
        field(51525593; "Paye Multiplier"; Decimal)
        {
            Editable = false;
        }
        field(51525594; "Cause of Inactivity"; Text[250])
        {
            Editable = false;
        }
        field(51525595; "Date Created"; Date)
        {
            Editable = false;
        }
        field(51525596; "Payment/Bank Country"; Code[50])
        {
            TableRelation = "Country/Region";
            trigger OnValidate()
            var
                SelectedCountry: Record "Country/Region";
            begin
                SelectedCountry.reset;
                SelectedCountry.setrange("Code", "Payment/Bank Country");
                if SelectedCountry.findfirst then begin
                    "Payment/Bank Currency" := SelectedCountry."Country Currency";
                end;
            end;
        }
        field(51525597; "MyID Eligibility"; Boolean)
        {
            trigger OnValidate()
            var
                Attachments: Record "Document Attachment";
            begin
                if Status = Status::Inactive then begin
                    if ("Date of Leaving" = 0D) or ("Date Of Join" = 0D) then
                        Error('Update the dates of joining and leaving for this staff!');

                    if (CalcDate('-10Y', "Date of Leaving") >= "Date Of Join") then begin
                        Attachments.Reset();
                        Attachments.SetRange("No.", "No.");
                        if not Attachments.FindFirst() then
                            Error('This staff has served for 10 years but the certificate has not been uploaded.\ Go to attachments, select description "Ten Years Certificate" then upload it before proceeding!');
                    end;
                end;
            end;
        }
        field(51525598; "Sort Code"; Text[250])
        {
        }
        field(51525599; Indicatif; Text[250])
        {
        }
        field(52211422; "Code B.I.C."; Text[250])
        {
        }
        field(52211423; "Suspend Leave Accrual"; Boolean)
        {
            trigger OnValidate()
            begin
                "Leave Accrual Suspended By" := UserId;
                "Leave Accrual Suspended On" := CurrentDateTime;
            end;
        }
        field(52211424; "Leave Accrual Suspended By"; Code[100])
        {
            TableRelation = User."User Name";
            Editable = false;
        }
        field(52211425; "Leave Accrual Suspended On"; DateTime)
        {
            Editable = false;
        }
        field(52211426; "Sub Section"; Code[240])
        {
            TableRelation = "Sub Sections";
        }
        field(52211427; "Terminal Dues"; Boolean)
        {
            trigger OnValidate()
            begin
                if "Terminal Dues" then begin
                    if Status <> Status::Inactive then
                        Error('Status must be inactive for the Terminal Dues option to be checked. Emp %1', "No.");
                end;
            end;
        }
        field(52211428; "First Retirement Reminder Sent"; Boolean)
        {
            Editable = false;
        }
        field(52211429; "Second Retirement Reminder Sent"; Boolean)
        {
            Editable = false;
        }
        field(52211430; "Third Retirement Reminder Sent"; Boolean)
        {
            Editable = false;
        }
        field(52211431; "Final Retirement Reminder Sent"; Boolean)
        {
            Editable = false;
        }
        field(52211432; "Suspend Retirement Reminders"; Boolean)
        { }
        field(52211433; "Is HoD"; Boolean)
        {
            CalcFormula = Exist("Responsibility Center" WHERE(Code = field("Responsibility Center"),
                                                                     "Current Head" = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52211434; "Next Seniority Date"; Date)
        {
        }
        field(52211435; "Under Terminal Dues Processing"; Boolean)
        {
            Editable = false;
        }
        field(52211436; "Overtime Amount Type"; Option)
        {
            Caption = 'Amount Type';
            OptionMembers = Net,Gross;
        }
        field(52211437; "Overtime Amount Currency"; Code[50])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(52211438; "Overtime AC"; Text[50])
        {
            Caption = 'AC';
        }
        field(52211439; "Probation Notification Sent"; Boolean)
        { }
        field(52211440; "TenYear Notification Sent"; Boolean)
        { }
        field(52211441; "1Year Retirement Reminder Sent"; Boolean)
        {
            Editable = false;
            Caption = 'Retirement Reminder Sent';
        }
        field(52211442; "Suspend Contract Reminders"; Boolean)
        { }
        field(52211443; "Suspend Probation Reminders"; Boolean)
        { }
        field(52211444; "Probation Reminder DateTime"; DateTime)
        { }
        field(52211445; "1Year Reminder DateTime"; DateTime)
        { }
        field(52211446; "TenYear Notification DateTime"; DateTime)
        { }
        field(52211447; "Given Transport Allowance"; Boolean)
        {
            CalcFormula = Lookup("Company Jobs"."Given Transport Allowance" WHERE("Job ID" = FIELD(Position)));
            FieldClass = FlowField;
        }
        field(52211448; "Is Supervisor"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist(Employee where("Manager No." = field("No.")));
        }
        field(52211449; "Job Application No."; Code[20])
        {
            TableRelation = "Job Applications";
        }
        field(52211450; "Retirement Benefits Comp."; Boolean)
        {
            Editable = false;
        }
        field(52211451; "Ineligible for Airtime"; Boolean)
        { }
    }
    var
        HumanResSetup: Record "Human Resources Setup";
        HRDates: Codeunit "HR Dates";
        EmployeeRec: Record Employee;

    procedure StaffOnMaternityLeave(PayPeriodStartDate: Date; var MaternityWorkingDays: Integer) OnMatLeave: Boolean
    var
        LeaveApp: Record "Employee Leave Application";
        PayPeriodEndDate: Date;
        LvStartDate: Date;
        LvEndDate: Date;
        LeaveDays: Integer;
    begin
        PayPeriodEndDate := CalcDate('CM', PayPeriodStartDate);
        OnMatLeave := false;

        LeaveApp.Reset;
        LeaveApp.SetRange("Employee No", "No.");
        LeaveApp.SetRange("Leave Type", 'MATERNITY');
        LeaveApp.SetRange(Status, LeaveApp.Status::Released);
        LeaveApp.SetFilter("Start Date", '<=%1', PayPeriodEndDate);
        LeaveApp.SetFilter("End Date", '>=%1', PayPeriodStartDate);
        if LeaveApp.FindFirst then begin
            OnMatLeave := true;

            if LeaveApp."Start Date" > PayPeriodStartDate then
                LvStartDate := LeaveApp."Start Date"
            else
                LvStartDate := PayPeriodStartDate;

            if LeaveApp."End Date" < PayPeriodEndDate then
                LvEndDate := LeaveApp."End Date"
            else
                LvEndDate := PayPeriodEndDate;
            LeaveDays := LvEndDate - LvStartDate + 1;

            MaternityWorkingDays := MaternityWorkingDays - LeaveDays;
        end;
        exit(OnMatLeave);
    end;

    procedure GetBankAccountNo(): Text
    begin
        if IBAN <> '' then
            exit(DelChr(IBAN, '=<>'));

        if "Bank Account No." <> '' then
            exit("Bank Account No.");
    end;

    procedure CheckDuplicateBankAccountNo(BankAccountNo: Code[100]): Boolean
    begin
        EmployeeRec.Reset();
        EmployeeRec.SetRange("Bank Account No", BankAccountNo);
        EmployeeRec.SetFilter("No.", '<>%1', "No.");
        if EmployeeRec.FindFirst() then begin
            if not confirm('An employee ' + EmployeeRec."No." + ' - ' + EmployeeRec."First Name" + ' ' + EmployeeRec."Middle Name" + ' ' + EmployeeRec."Last Name" + ' already has the given Bank account No ' + BankAccountNo + '. This could be the sign of a duplicate employee record. Do you still want to proceed?') then
                Error('Kindly confirm the bank account number then try again!');
        end;
        exit(true);
    end;

    var
        CompanyJobsRec: Record "Company Jobs";
        SalaryScalesRec: Record "Salary Scales";
        EmpHist: Record "Internal Employement History";
        AssMatrix: Record "Assignment Matrix";
        ansmsg: Text;
        ans: Boolean;
        Banks: Record "Bank Account";

    procedure GetEmpLeaveBalance(): Decimal
    var
        Lentries: Record "HR Leave Ledger Entries";
        Balance: Decimal;
        HrLeavePeriods: Record "HR Leave Periods";
        LeavePeriod: Code[60];
    begin
        LeavePeriod := '';
        HrLeavePeriods.Reset();
        HrLeavePeriods.SetRange(Closed, false);
        if HrLeavePeriods.FindFirst() then
            LeavePeriod := HrLeavePeriods."Period Code";
        Balance := 0;
        Lentries.Reset;
        Lentries.SetRange("Staff No.", "No.");
        Lentries.SetFilter(Lentries."Leave Type", 'CF|ANNUAL|SPECIAL|CARRY FORWARD');
        Lentries.SetFilter(Lentries."Leave Period", LeavePeriod);
        if Lentries.FindSet then begin
            Lentries.CalcSums("No. of days");
            Balance := Round((Lentries."No. of days"), 0.5, '=');
        end;
        exit(Balance);
    end;

}



