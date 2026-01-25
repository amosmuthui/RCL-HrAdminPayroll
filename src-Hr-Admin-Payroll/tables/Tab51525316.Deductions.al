table 51525316 Deductions
{
    DataCaptionFields = "Code", Description;
    DrillDownPageID = Deductions;//"Deductions listing";
    LookupPageID = Deductions;//"Deductions listing";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Editable = false;
        }
        field(3; Type; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(6; "Tax deductible"; Boolean)
        {
            trigger OnValidate()
            begin
                if not "Tax deductible" then begin
                    if "Reduces Gross" then
                        Error('A deduction that reduces gross must also reduce taxable amount!');
                end;
            end;
        }
        field(7; Advance; Boolean)
        {
        }
        field(8; "Start date"; Date)
        {
        }
        field(9; "End Date"; Date)
        {
        }
        field(10; Percentage; Decimal)
        {
            trigger OnValidate()
            begin
                if "Base Amount" <> 0 then
                    "Maximum Amount" := (Percentage / 100) * "Base Amount";
            end;
        }
        field(11; "Calculation Method"; Option)
        {
            OptionCaption = 'Flat Amount,% of Basic Pay,Based on Table,Based on Hourly Rate,Based on Daily Rate ,% of Contractual Gross Pay,% of Basic Pay+Hse Allowance,% of Salary Recovery,% of Secondment Basic,% of Gross less Transport Allowance,% of Gross less Statutory Deductions,% of PAYE,% of Insurable Earnings,% of Actual Gross Pay,% of Base Amount,% of Actual Gross plus Constant Amount';
            OptionMembers = "Flat Amount","% of Basic Pay","Based on Table","Based on Hourly Rate","Based on Daily Rate ","% of Contractual Gross Pay","% of Basic Pay+Hse Allowance","% of Salary Recovery","% of Secondment Basic","% of Gross Less Transport","% of Gross Less Stat Deductions","% of PAYE","% of Insurable Earnings","% of Actual Gross Pay","% of Base Amount","% of Actual Gross plus Constant Amount";

            trigger OnValidate()
            begin
                "Less Transport Allowance" := false;
                if "Calculation Method" = "Calculation Method"::"% of Gross Less Transport" then
                    "Less Transport Allowance" := true;
            end;
        }
        field(12; "G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(13; "Flat Amount"; Decimal)
        {
        }
        field(14; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Deduction),
                                                                Code = FIELD(Code),
                                                                "Posting Group Filter" = FIELD("Posting Group Filter"),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Employee No" = FIELD("Employee Filter"),
                                                                Country = FIELD(Country),
                                                                "Reference No" = FIELD("Reference Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Date Filter"; Date)
        {
        }
        field(16; "Posting Group Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Staff Posting Group";
        }
        field(17; Loan; Boolean)
        {
        }
        field(18; "Maximum Amount"; Decimal)
        {
        }
        field(19; "Grace period"; DateFormula)
        {
        }
        field(20; "Repayment Period"; DateFormula)
        {
        }
        field(21; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll Period";
        }
        field(26; "Pension Scheme"; Boolean)
        {
        }
        field(27; "Deduction Table"; Code[10])
        {
            TableRelation = "Bracket Tables";
        }
        field(28; "G/L Account Employer"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(29; "Percentage Employer"; Decimal)
        {
        }
        field(30; "Minimum Amount"; Decimal)
        {
        }
        field(31; "Flat Amount Employer"; Decimal)
        {
        }
        field(32; "Total Amount Employer"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix"."Employer Amount" WHERE(Type = CONST(Deduction),
                                                                           Code = FIELD(Code),
                                                                           "Payroll Period" = FIELD("Pay Period Filter"),
                                                                           "Posting Group Filter" = FIELD("Posting Group Filter"),
                                                                           "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                            Country = FIELD(Country),
                                                                           "Employee No" = FIELD("Employee Filter")));
            FieldClass = FlowField;
        }
        field(33; "Loan Type"; Option)
        {
            OptionMembers = " ","Low Interest Benefit","Fringe Benefit";
        }
        field(34; "Show Balance"; Boolean)
        {
        }
        field(35; CoinageRounding; Boolean)
        {
        }
        field(36; "Employee Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(37; "Opening Balance"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix"."Opening Balance" WHERE(Type = CONST(Deduction),
                                                                           Code = FIELD(Code),
                                                                            Country = FIELD(Country),
                                                                           "Employee No" = FIELD("Employee Filter")));
            FieldClass = FlowField;
        }
        field(38; "Global Dimension 2 Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(39; "Balance Mode"; Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = Increasing," Decreasing";
            //TableRelation = Table0;
        }
        field(40; "Main Loan Code"; Code[20])
        {
        }
        field(41; Shares; Boolean)
        {
        }
        field(42; "Show on report"; Boolean)
        {
        }
        field(43; "Non-Interest Loan"; Boolean)
        {
        }
        field(44; "Exclude when on Leave"; Boolean)
        {
        }
        field(45; "Co-operative"; Boolean)
        {
        }
        field(46; "Total Shares"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Deduction),
                                                                Code = FIELD(Code),
                                                                "Employee No" = FIELD("Employee Filter"),
                                                                Country = FIELD(Country),
                                                                Shares = CONST(true)));
            FieldClass = FlowField;
        }
        field(47; Rate; Decimal)
        {
        }
        field(48; "PAYE Code"; Boolean)
        {
            trigger OnValidate()
            begin
                if ("PAYE Code" = true) and (ABS("Pension Limit Amount") = 0) then
                    "Pension Limit Amount" := 999999999;
            end;
        }
        field(49; "Total Days"; Decimal)
        {
            FieldClass = Normal;
        }
        field(50; "Housing Earned Limit"; Decimal)
        {
        }
        field(51; "Pension Limit Percentage"; Decimal)
        {
        }
        field(52; "Pension Limit Amount"; Decimal)
        {
        }
        field(53; "Applies to All"; Boolean)
        {
        }
        field(54; "Show on Master Roll"; Boolean)
        {
        }
        field(55; "Pension Scheme Code"; Boolean)
        {
        }
        field(56; "Main Deduction Code"; Code[10])
        {
        }
        field(57; "Insurance Code"; Boolean)
        {
        }
        field(58; Block; Boolean)
        {
        }
        field(59; "Institution Code"; Code[20])
        {
            TableRelation = Institution;
        }
        field(60; "Reference Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(61; "Show on Payslip Information"; Boolean)
        {
        }
        field(62; "Voluntary Percentage"; Decimal)
        {
        }
        field(63; "Salary Recovery"; Boolean)
        {
            Description = 'For Paye manual calculation';
        }
        field(64; Gratuity; Boolean)
        {
        }
        field(65; "Gratuity Arrears"; Boolean)
        {
        }
        field(66; Informational; Boolean)
        {
        }
        field(67; Board; Boolean)
        {
        }
        field(68; "Pension Arrears"; Boolean)
        {
        }
        field(69; Voluntary; Boolean)
        {
        }
        field(70; "Voluntary Amount"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Code = FIELD("Voluntary Code"),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Employee No" = FIELD("Employee Filter"),
                                                                Country = FIELD(Country),
                                                                Type = CONST(Deduction)));
            FieldClass = FlowField;
        }
        field(71; "Voluntary Code"; Code[20])
        {
            TableRelation = Deductions WHERE(Voluntary = CONST(true));
        }
        field(72; "Relief Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50000; "PE Activity Code"; Code[20])
        {
            //TableRelation = "Procurement Plan Header"."PE Activity Code";
        }
        field(50001; vendor; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50002; Individual; Boolean)
        {
        }
        field(50003; "NHIF Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "NSSF Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "NITA Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "HELB Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Employer Contibution Taxed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Sort Code"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Normal Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Do Not Deduct"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "NSSF Tier"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Tier 1,Tier 2';
            OptionMembers = " ","Tier 1","Tier 2";
        }
        field(50012; "Housing Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Housing Levy Arrears"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Social Security"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Community-Based Health"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Medical Insurance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Maternity Deduction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; Country; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                Deductions: Record Deductions;
            begin
                if Country <> '' then begin
                    if Code = '' then begin
                        Deductions.Reset();
                        Deductions.SetRange(Country, Country);
                        if Deductions.FindLast then begin
                            Code := IncStr(Deductions.Code)
                        end else begin
                            Code := 'D01';
                        end;
                    end;
                end;
            end;
        }
        field(50019; "Is Statutory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Medical Insurance Category"; Option)
        {
            OptionCaption = 'None,Normal,MMI';
            OptionMembers = "None",Normal,MMI;
        }
        field(50021; "Base Amount"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Base Amount" <> 0 then
                    "Maximum Amount" := (Percentage / 100) * "Base Amount";
            end;
        }
        field(50022; "Universal Title"; Code[100])
        {
            TableRelation = "Payroll Universal Trans Codes".Title where("Transaction Type" = filter(Deduction));

            trigger OnValidate()
            var
                universalCodes: Record "Payroll Universal Trans Codes";
                Deductions: Record Deductions;
            begin
                if "Universal Title" <> '' then begin
                    if (Code = '') or (Country = '') then
                        Error('You must input the deduction country and code before proceeding!');
                    universalCodes.Reset();
                    universalCodes.SetRange(Title, "Universal Title");
                    if universalCodes.FindFirst() then begin
                        if (Description = '') and (universalCodes.Description <> '') then
                            Description := universalCodes.Description;
                    end;

                    //Can't repeat title in one country
                    Deductions.Reset();
                    Deductions.SetRange(Country, Country);
                    Deductions.SetRange("Universal Title", "Universal Title");
                    Deductions.SetFilter(Code, '<>%1', Code);
                    if Deductions.FindFirst() then
                        Error('There is already another deduction with this title!');

                    AssignMatrix.RESET;
                    AssignMatrix.SETRANGE(AssignMatrix.Type, AssignMatrix.Type::Deduction);
                    AssignMatrix.SETRANGE(AssignMatrix.Code, Code);
                    AssignMatrix.SETRANGE(AssignMatrix.Country, Country);
                    IF AssignMatrix.FIND('+') THEN begin
                        AssignMatrix.RESET;
                        AssignMatrix.SETRANGE(AssignMatrix.Type, AssignMatrix.Type::Deduction);
                        AssignMatrix.SETRANGE(AssignMatrix.Code, Code);
                        AssignMatrix.SETRANGE(AssignMatrix.Country, Country);
                        AssignMatrix.ModifyAll("Transaction Title", "Universal Title");
                    end;
                end;
            end;
        }
        field(50023; "Reduces Gross"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Reduces Gross" then begin
                    if "Calculation Method" <> "Calculation Method"::"Flat Amount" then
                        Error('Only flat amount deductions can reduce gross!');
                    "Tax deductible" := true;
                end;
            end;
        }
        field(50024; "Display Order"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Constant Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Less Transport Allowance"; Boolean)
        { }
    }

    keys
    {
        key(PK; "Code", Country)
        {
            Clustered = true;
        }
        key(Key2; "Show on report")
        {
        }
        key(Key3; "Exclude when on Leave")
        {
        }
        key(Key4; "Co-operative")
        {
        }
        key(Key5; Rate)
        {
        }
        key(Key6; Shares)
        {
        }
        key(Key7; Loan)
        {
        }
        key(Key8; "Pension Scheme Code")
        {
        }
        key(Key9; "Institution Code")
        {
        }
        key(Key10; "Main Deduction Code")
        {
        }
        key(Key11; "Display Order")
        {
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    begin
        Individual := true;
        "Show on Master Roll" := true;
        "Show on Payslip Information" := true;
        "Applies to All" := true;
    end;

    trigger OnDelete()
    begin
        AssignMatrix.Reset();
        AssignMatrix.setrange(Code, Code);
        AssignMatrix.setrange(Country, Country);
        AssignMatrix.SETRANGE(AssignMatrix.Type, AssignMatrix.Type::Deduction);
        if AssignMatrix.FindFirst() then
            Error('You cannot delete this record because it contains payroll transactions!');
    end;

    var
        AssignMatrix: Record "Assignment Matrix";
}