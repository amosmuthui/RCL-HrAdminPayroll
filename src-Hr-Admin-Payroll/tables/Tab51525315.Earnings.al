table 51525315 Earnings
{
    DataCaptionFields = "Code", Description;
    DrillDownPageID = Earnings;//"Earnings Listing";
    LookupPageID = Earnings;//"Earnings Listing";

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
        field(3; "Pay Type"; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(4; "Start Date"; Date)
        {
        }
        field(5; "End Date"; Date)
        {
        }
        field(6; Taxable; Boolean)
        {
            trigger OnValidate()
            begin
                FnTaxableContractualAmount();
            end;
        }
        field(7; "Calculation Method"; Option)
        {
            OptionCaption = 'Flat amount,% of Basic pay,% of Contractual Gross pay,% of Insurance Amount,% of Taxable income,% of Basic after tax,Based on Hourly Rate,Based on Daily Rate,% of Salary Recovery,% of Loan Amount,% of Cost,% of Actual Gross plus Constant Amount,Based on Table';
            OptionMembers = "Flat amount","% of Basic pay","% of Gross pay","% of Insurance Amount","% of Taxable income","% of Basic after tax","Based on Hourly Rate","Based on Daily Rate","% of Salary Recovery","% of Loan Amount","% of Cost","% of Actual Gross plus Constant Amount","Based on Table";
        }
        field(8; "Flat Amount"; Decimal)
        {
        }
        field(9; Percentage; Decimal)
        {
            DecimalPlaces = 2 : 4;
        }
        field(10; "G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(11; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix".Amount WHERE(Type = CONST(Payment),
                                                                Code = FIELD(Code),
                                                                "Posting Group Filter" = FIELD("Posting Group Filter"),
                                                                "Payroll Period" = FIELD("Pay Period Filter"),
                                                                "Employee No" = FIELD("Employee Filter"),
                                                                "Global Dimension 1 code" = FIELD("Global Dimension 1 Filter"),
                                                                "Global Dimension 1 code" = FIELD("Global Dimension 2 Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Date Filter"; Date)
        {
        }
        field(13; "Posting Group Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Staff Posting Group";
        }
        field(14; "Pay Period Filter"; Date)
        {
            ClosingDates = false;
            FieldClass = FlowFilter;
            TableRelation = "Payroll Period";
        }
        field(15; Quarters; Boolean)
        {
        }
        field(16; "Non-Cash Benefit"; Boolean)
        {
        }
        field(17; "Minimum Limit"; Decimal)
        {
        }
        field(18; "Maximum Limit"; Decimal)
        {
        }
        field(19; "Reduces Tax"; Boolean)
        {
        }
        field(20; "Overtime Factor"; Decimal)
        {
        }
        field(21; "Employee Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll Period";
        }
        field(22; Counter; Integer)
        {
            CalcFormula = Count("Assignment Matrix" WHERE("Payroll Period" = FIELD("Pay Period Filter"),
                                                           "Employee No" = FIELD("Employee Filter"),
                                                           Code = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(23; NoOfUnits; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix"."No. of Units" WHERE(Code = FIELD(Code),
                                                                        "Payroll Period" = FIELD("Pay Period Filter"),
                                                                        "Employee No" = FIELD("Employee Filter")));
            FieldClass = FlowField;
        }
        field(24; "Low Interest Benefit"; Boolean)
        {
        }
        field(25; "Show Balance"; Boolean)
        {
        }
        field(26; CoinageRounding; Boolean)
        {
        }
        field(27; OverDrawn; Boolean)
        {
        }
        field(28; "Opening Balance"; Decimal)
        {
            CalcFormula = Sum("Assignment Matrix"."Opening Balance" WHERE(Type = CONST(Payment),
                                                                           Code = FIELD(Code),
                                                                           "Employee No" = FIELD("Employee Filter")));
            FieldClass = FlowField;
        }
        field(29; OverTime; Boolean)
        {
            FieldClass = Normal;
        }
        field(30; "Global Dimension 1 Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; Months; Decimal)
        {
            Description = 'Used to cater for taxation based on annual bracket eg 1,12 months (the default is 1month) FOR NEPAL';
        }
        field(32; "Show on Report"; Boolean)
        {
        }
        field(33; "Time Sheet"; Boolean)
        {
        }
        field(34; "Total Days"; Decimal)
        {
            FieldClass = Normal;
        }
        field(35; "Total Hrs"; Decimal)
        {
            FieldClass = Normal;
        }
        field(36; Weekend; Boolean)
        {
        }
        field(37; Weekday; Boolean)
        {
        }
        field(38; "Basic Salary Code"; Boolean)
        {
        }
        field(39; "Default Enterprise"; Code[10])
        {
        }
        field(40; "Default Activity"; Code[10])
        {
        }
        field(41; "ProRata Leave"; Boolean)
        {
        }
        field(42; "Earning Type"; Option)
        {
            OptionCaption = 'Normal Earning,Owner Occupier,Home Savings,Low Interest,Tax Relief,Insurance Relief,Disability Relief,Telephone Allowance,Gratuity';
            OptionMembers = "Normal Earning","Owner Occupier","Home Savings","Low Interest","Tax Relief","Insurance Relief","Disability Relief","Telephone Allowance",Gratuity;
        }
        field(43; "Applies to All"; Boolean)
        {
        }
        field(44; "Show on Master Roll"; Boolean)
        {
        }
        field(45; "House Allowance Code"; Boolean)
        {
        }
        field(46; "Responsibility Allowance Code"; Boolean)
        {
        }
        field(47; "Commuter Allowance Code"; Boolean)
        {
        }
        field(48; Block; Boolean)
        {
        }
        field(49; "Basic Pay Arrears"; Boolean)
        {
        }
        field(50; "Market Rate"; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(51; "Company Rate"; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(52; Fringe; Boolean)
        {
        }
        field(53; "Salary Recovery"; Boolean)
        {
            Description = 'For PAYE Manual calculation';
        }
        field(54; "Loan Code"; Code[20])
        {
        }
        field(55; "Global Dimension 2 Filter"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(56; Board; Boolean)
        {
        }
        field(50000; "PE Activity Code"; Code[20])
        {
            //TableRelation = "Procurement Plan Header"."PE Activity Code";
        }
        field(50001; Recurs; Boolean)
        {
        }
        field(50002; "Fringe Benefit"; Boolean)
        {
        }
        field(50003; "Morgage Relief"; Boolean)
        {
        }
        field(50004; Bonus; Boolean)
        {
        }
        field(50005; "Leave Allowance Code"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Taxable Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; Month; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = ,January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(50008; "Defined Month"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; Relief; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Max Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'For Gratuity Limit.';
        }
        field(50011; Gratuity; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Include in Housing Levy"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Housing Allowance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Transport Allowance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Gross Pay"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; Country; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
            trigger OnValidate()
            var
                Earning: Record Earnings;
            begin
                if Country <> '' then begin
                    if Code = '' then begin
                        Earning.Reset();
                        Earning.SetRange(Country, Country);
                        if Earning.FindLast then begin
                            Code := IncStr(Earning.Code)
                        end else begin
                            Code := 'E01';
                        end;
                    end;
                end;
            end;
        }
        field(50017; "Insurance Relief"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Proratable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Is Contractual Amount"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                FnTaxableContractualAmount();
            end;
        }
        field(50020; "Goes to Matrix"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                FnTaxableContractualAmount();
            end;
        }
        field(50021; "Is Insurable Earning"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Display Order"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Universal Title"; Code[100])
        {
            TableRelation = "Payroll Universal Trans Codes".Title where("Transaction Type" = filter(Earning));
            trigger OnValidate()
            var
                universalCodes: Record "Payroll Universal Trans Codes";
                Earnings: Record Earnings;
            begin
                OverTime := false;
                if "Universal Title" <> '' then begin
                    if (Code = '') or (Country = '') then
                        Error('You must input the earning country and code before proceeding!');
                    //Can't repeat title in one country
                    Earnings.Reset();
                    Earnings.SetRange(Country, Country);
                    Earnings.SetRange("Universal Title", "Universal Title");
                    Earnings.SetFilter(Code, '<>%1', Code);
                    if Earnings.FindFirst() then
                        Error('There is already another earning with this title!');

                    universalCodes.Reset();
                    universalCodes.SetRange(Title, "Universal Title");
                    if universalCodes.FindFirst() then begin
                        if (Description = '') and (universalCodes.Description <> '') then
                            Description := universalCodes.Description;
                    end;
                    "Exclude from Payroll" := false;
                    "Exclude from Calculations" := false;
                    "Special Transport Allowance" := false;

                    if "Universal Title" = 'OVERTIME ALLOWANCE' then begin
                        OverTime := true;
                        "Exclude from Payroll" := true;
                        "Exclude from Calculations" := true;
                    end;
                    if "Universal Title" = 'LUMPSUM ALLOWANCE' then begin
                        "Exclude from Payroll" := true;
                        "Exclude from Calculations" := true;
                    end;
                    if "Universal Title" = 'SPECIAL TRANSPORT ALLOWANCE' then begin
                        "Exclude from Payroll" := true;
                        "Exclude from Calculations" := true;
                        "Special Transport Allowance" := true;
                        "Calculation Method" := "Calculation Method"::"Based on Table";
                        Taxable := false;
                    end;

                    AssignmentMat.RESET;
                    AssignmentMat.SETRANGE(AssignmentMat.Type, AssignmentMat.Type::Payment);
                    AssignmentMat.SETRANGE(AssignmentMat.Code, Code);
                    AssignmentMat.SETRANGE(AssignmentMat.Country, Country);
                    IF AssignmentMat.FIND('+') THEN begin
                        AssignmentMat.RESET;
                        AssignmentMat.SETRANGE(AssignmentMat.Type, AssignmentMat.Type::Payment);
                        AssignmentMat.SETRANGE(AssignmentMat.Code, Code);
                        AssignmentMat.SETRANGE(AssignmentMat.Country, Country);
                        AssignmentMat.ModifyAll("Transaction Title", "Universal Title");
                    end;
                end;
            end;
        }
        field(50024; "Constant Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Reduces Taxable Amt"; Boolean)
        {
        }
        field(50026; "Exclude from Calculations"; Boolean)
        {
        }
        field(50027; "Exclude from Payroll"; Boolean)
        {
            trigger OnValidate()
            begin
                "Exclude from Calculations" := "Exclude from Payroll";
            end;
        }
        field(50028; "Earning Table"; Code[10])
        {
            TableRelation = "Bracket Tables";
        }
        field(50029; "Special Transport Allowance"; Boolean)
        {
        }
        field(50030; "Is Statutory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Code", Country)
        {
            Clustered = true;
        }
        key(Key2; "Show on Report")
        {
        }
        key(Key3; OverTime)
        {
        }
        key(Key4; "Time Sheet")
        {
        }
        key(Key5; "Earning Type")
        {
        }
        key(Key6; "House Allowance Code")
        {
        }
        key(Key7; "Responsibility Allowance Code")
        {
        }
        key(Key8; "Commuter Allowance Code")
        {
        }
        key(Key9; "Display Order")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Show on Master Roll" := true;
        "Show on Report" := true;
        "Applies to All" := true;
        Taxable := true;
        Recurs := true;
    end;

    trigger OnDelete()
    begin
        AssignmentMat.RESET;
        AssignmentMat.SETRANGE(AssignmentMat.Type, AssignmentMat.Type::Payment);
        AssignmentMat.SETRANGE(AssignmentMat.Code, Code);
        AssignmentMat.SETRANGE(AssignmentMat.Country, Country);
        IF AssignmentMat.FIND('+') THEN
            ERROR('You cannot delete this earning because it has entries');

    end;

    procedure FnTaxableContractualAmount()
    begin
        if ("Is Contractual Amount") and (not "Goes to Matrix") then
            Taxable := false;
    end;

    var
        AssignmentMat: Record "Assignment Matrix";
}