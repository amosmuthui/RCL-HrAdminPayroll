table 51525344 "Training Request"
{
    DrillDownPageID = "Training List";
    LookupPageID = "Training List";

    fields
    {
        field(1; "Request No."; Code[20])
        {
        }
        field(2; "Request Date"; Date)
        {
            Editable = false;
        }
        field(3; "Employee No"; Code[10])
        {
            TableRelation = Employee;
        }
        field(4; "Employee Name"; Text[80])
        {
        }
        field(5; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(6; "Department Code"; Code[10])
        {
            TableRelation = "Responsibility Center".Code;// WHERE("Responsibility Center" = FIELD(Directorate));

            trigger OnValidate()
            var
                RespCenter: Record "Responsibility Center";
            begin
                if RespCenter.Get("Department Code") then begin
                    "Department Name" := RespCenter.Name;
                end;
            end;
        }
        field(7; Status; Option)
        {
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected;
            Editable = false;
        }
        field(8; Designation; Text[100])
        {
        }
        field(9; Period; DateFormula)
        {
        }
        field(10; "No. Of Days"; Integer)
        {
        }
        field(11; "Training Insitution"; Text[250])
        {
        }
        field(12; Venue; Text[250])
        {

            trigger OnValidate()
            begin
                CalcFields(Budget, Actual, Commitment);
                "Available Funds" := Budget - Actual - Commitment;
            end;
        }
        field(13; "Tuition Fee"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Tuition Fee" WHERE("Training Request" = FIELD("Request No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestField("No. Of Days");
                "Total Cost" := "Per Diem" + "Tuition Fee" + "Air Ticket";
                Validate("Exchange Rate");
            end;
        }
        field(14; "Per Diem"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Per Diem" WHERE("Training Request" = FIELD("Request No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestField("No. Of Days");
                "Total Cost" := "Per Diem" + "Tuition Fee" + "Air Ticket";
                Validate("Exchange Rate");
            end;
        }
        field(15; "Air Ticket"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Air Ticket" WHERE("Training Request" = FIELD("Request No.")));
            DecimalPlaces = 0 : 0;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestField("No. Of Days");
                "Total Cost" := "Per Diem" + "Tuition Fee" + "Air Ticket";
                Validate("Exchange Rate");
            end;
        }
        field(16; "Total Cost"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Total Cost" WHERE("Training Request" = FIELD("Request No.")));
            FieldClass = FlowField;
        }
        field(17; "Course Title"; Text[250])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                //IF TrainingNeeds.GET("Course Title") THEN
                //Description:=TrainingNeeds.Description;
            end;
        }
        field(18; Description; Text[250])
        {
        }
        field(19; "Planned Start Date"; Date)
        {

            trigger OnValidate()
            begin
                CalcFields(Budget, Actual, Commitment);
                "Available Funds" := Budget - Actual - Commitment;


                AccPeriod.Reset;
                AccPeriod.SetRange(AccPeriod."Starting Date", 0D, "Planned Start Date");
                AccPeriod.SetRange(AccPeriod."New Fiscal Year", true);
                if AccPeriod.Find('+') then
                    FiscalStart := AccPeriod."Starting Date";
                //MESSAGE('%1',FiscalStart);
                "Period End Date" := CalcDate('1Y', FiscalStart) - 1;

                if ("Planned End Date" <> 0D) and ("Planned Start Date" <> 0D) then begin
                    "No. Of Days" := "Planned End Date" - "Planned Start Date";
                end;
            end;
        }
        field(20; "Planned End Date"; Date)
        {

            trigger OnValidate()
            begin

                CalcFields(Budget, Actual, Commitment);
                "Available Funds" := Budget - Actual - Commitment;

                "No. Of Days" := ("Planned End Date" - "Planned Start Date") + 1;

                if ("Planned End Date" <> 0D) and ("Planned Start Date" <> 0D) then begin
                    "No. Of Days" := "Planned End Date" - "Planned Start Date";
                end;
            end;
        }
        field(21; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                if CountryRec.Get("Country Code") then begin
                    //Currency:=CountryRec."Currency Label";
                end;
            end;
        }
        field(22; "CBK Website Address"; Text[80])
        {
        }
        field(23; "Exchange Rate"; Decimal)
        {
            DecimalPlaces = 4 : 4;

            trigger OnValidate()
            begin
                "Total Cost (LCY)" := "Exchange Rate" * "Total Cost";
                if "Local Travel" = true then begin
                    "Total Cost (LCY)" := "Total Cost";
                end;
                // CALCFIELDS(Budget,Actual,Commitment);
                // "Available Funds":=Budget-Actual-Commitment;
            end;
        }
        field(24; "Total Cost (LCY)"; Decimal)
        {
        }
        field(25; Currency; Code[10])
        {
            TableRelation = Currency;
        }
        field(26; Budget; Decimal)
        {
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE("Budget Name" = FIELD("Budget Name"),
                                                               "G/L Account No." = FIELD("GL Account"),
                                                               "Global Dimension 1 Code" = FIELD("Department Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; Actual; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("GL Account"),
                                                        "Global Dimension 1 Code" = FIELD("Department Code")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CalcFields(Budget, Actual);
                Variance := Actual - Budget;
            end;
        }
        field(28; Commitment; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Document No." = FIELD("Request No."))); //"Commitment Entries"
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "GL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(30; "Budget Name"; Code[10])
        {
            Caption = 'Fiscal Year';
            TableRelation = "G/L Budget Name";
        }
        field(31; "Available Funds"; Decimal)
        {
        }
        field(32; "Need Source"; Option)
        {
            OptionCaption = 'Appraisal,Succesion,Training,Employee,Employee Skill Plan';
            OptionMembers = Appraisal,Succesion,Training,Employee,"Employee Skill Plan";
        }
        field(33; "Training Objective"; Text[250])
        {
        }
        field(34; "User ID"; Code[30])
        {
        }
        field(44; "Commisioner No"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Commisioner No");
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                if DimVal.Find('-') then
                    "Commissioner Name" := DimVal.Name;
            end;
        }
        field(45; "Commissioner Name"; Text[30])
        {
        }
        field(46; Commissioner; Boolean)
        {
        }
        field(47; "Source of Funding"; Option)
        {
            OptionCaption = 'CMA Funded,Partner Funded,Self Funded';
            OptionMembers = "CMA Funded","Partner Funded","Self Funded";
        }
        field(48; Variance; Decimal)
        {
        }
        field(49; "Group or Individual"; Option)
        {
            OptionCaption = 'Individual,Group';
            OptionMembers = Individual,Group;
        }
        field(50; Sessions; Integer)
        {
        }
        field(51; Remarks; Text[250])
        {
        }
        field(52; "Local or Abroad"; Option)
        {
            OptionCaption = 'Local,Abroad';
            OptionMembers = "Local",Abroad;
        }
        field(53; Directorate; Code[20])
        {
            TableRelation = "Responsibility Center".Code;

            trigger OnValidate()
            begin
                if ResponsibilityCenter.Get(Directorate) then begin
                    "Directorate Name" := ResponsibilityCenter.Name;
                end;
            end;
        }
        field(54; "Department Name"; Text[100])
        {
            Editable = false;
        }
        field(55; "Directorate Name"; Text[100])
        {
        }
        field(56; "Period End Date"; Date)
        {
        }
        field(57; "No. of Approvals"; Integer)
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                //Count("Approval Entry" WHERE (Document Type=CONST(Training), Document No.=FIELD(Request No.)))
            end;
        }
        field(58; "Reimbursible Interest"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Tuition Fee" + "Per Diem" + "Air Ticket" + "Travel Documents Fees" + "Reimbursible Interest";
            end;
        }
        field(59; "Date of Travel"; Date)
        {
        }
        field(60; "Return Date"; Date)
        {

            trigger OnValidate()
            begin
                "Per Diem Days" := ("Return Date" - "Date of Travel") + 1;
            end;
        }
        field(61; "Requires Flight"; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(62; "Travel Documents Fees"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Tuition Fee" + "Per Diem" + "Air Ticket" + "Travel Documents Fees" + "Reimbursible Interest";
            end;
        }
        field(63; "Per Diem Days"; Decimal)
        {
        }
        field(64; Destination; Text[250])
        {
        }
        field(65; "Requires LPO"; Option)
        {
            OptionCaption = 'No,Yes';
            OptionMembers = No,Yes;
        }
        field(66; "Tuition Fee Flow"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Tuition Fee" WHERE("Training Request" = FIELD("Request No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //"Total Cost":="Tuition Fee"+"Per Diem"+"Air Ticket"+"Travel Documents Fees"+"Reimbursible Interest";
            end;
        }
        field(67; "Per Diem Flow"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Per Diem" WHERE("Training Request" = FIELD("Request No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //"Total Cost":="Tuition Fee"+"Per Diem"+"Air Ticket"+"Travel Documents Fees"+"Reimbursible Interest";
            end;
        }
        field(68; "Air Ticket Flow"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Air Ticket" WHERE("Training Request" = FIELD("Request No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                "Total Cost" := "Tuition Fee" + "Per Diem" + "Air Ticket" + "Travel Documents Fees" + "Reimbursible Interest";
            end;
        }
        field(69; "Reimbursible Imprest Flow"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Total Cost" WHERE("Training Request" = FIELD("Request No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                "Total Cost" := "Tuition Fee" + "Per Diem" + "Air Ticket" + "Travel Documents Fees" + "Reimbursible Interest";
            end;
        }
        field(70; "Travel Documents Fees Flow"; Decimal)
        {
            CalcFormula = Sum("Training Participants"."Travel Docs Fees" WHERE("Training Request" = FIELD("Request No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                "Total Cost" := "Tuition Fee" + "Per Diem" + "Air Ticket" + "Travel Documents Fees" + "Reimbursible Interest";
            end;
        }
        field(71; "Language Code(Default)"; Code[20])
        {
        }
        field(72; Attachment; Option)
        {
            OptionMembers = No,Yes;
        }
        field(73; "Finance Notified"; Boolean)
        {
        }
        field(74; "Procurement Notified"; Boolean)
        {
        }
        field(75; "Local Travel"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Local Travel" = true then begin
                    "International Travel" := false;
                end;
                if "Local Travel" = false then begin
                    "International Travel" := true;
                end;
                Currency := 'KES';
                "Perdiem Per Day" := 0;
                "Per Diem" := 0;
                "Tuition Fee" := 0;
                "Air Ticket" := 0;
                "Total Cost" := 0;
                "Total Cost (LCY)" := 0;
            end;
        }
        field(76; "International Travel"; Boolean)
        {

            trigger OnValidate()
            begin
                if "International Travel" = true then begin
                    "Local Travel" := false;
                end;
                if "International Travel" = false then begin
                    "Local Travel" := true;
                end;
                Currency := 'USD';
                "Perdiem Per Day" := 0;
                "Per Diem" := 0;
                "Tuition Fee" := 0;
                "Air Ticket" := 0;
                "Total Cost" := 0;
                "Total Cost (LCY)" := 0;
            end;
        }
        field(77; "Local Destination"; Text[250])
        {
            //TableRelation = "SRC Cluster Places"."Cluster Place";

            trigger OnValidate()
            begin
                TestField("No. Of Days");
                /*"Perdiem Per Day" := 0;
                "Per Diem" := 0;
                //  "Tuition Fee":=0;
                //  "Air Ticket":=0;
                "Total Cost" := "Tuition Fee" + "Air Ticket";
                "Total Cost (LCY)" := "Tuition Fee" + "Air Ticket";
                "Total Cost (LCY)" := "Total Cost";
                empl.Reset;
                empl.Get("Employee No");
                Clusterrec.Reset;
                if "Local Travel" = true then begin
                    Clusterrec.SetFilter("Cluster Place", "Local Destination");
                    if Clusterrec.FindSet then begin
                        srcscaleslocal.Reset;
                        if srcscaleslocal.Get(empl."Salary Scale", Clusterrec."Cluster Code") then begin
                            "Perdiem Per Day" := srcscaleslocal.Amount;
                            "Per Diem" := srcscaleslocal.Amount * "No. Of Days";
                            "Total Cost" := "Per Diem" + "Tuition Fee" + "Air Ticket";
                            "Total Cost (LCY)" := "Total Cost";
                        end;
                    end;
                end;
                if "International Travel" = true then begin
                    scrscalesinter.Reset;
                    if scrscalesinter.Get(empl."Salary Scale", "International Destination") then begin
                        "Perdiem Per Day" := scrscalesinter.Amount;
                        "Per Diem" := scrscalesinter.Amount * "No. Of Days";
                        "Total Cost" := "Per Diem" + "Tuition Fee" + "Air Ticket";
                        //"Total Cost (LCY)":="Total Cost";
                    end;
                end;
                Validate("Exchange Rate");

                dimensionvalue.Reset;
                dimensionvalue.Get('EMPLOYEES', "Employee No");
                if dimensionvalue."Employee Region" = "Local Destination" then begin
                    "Per Diem" := 0;
                    "Perdiem Per Day" := 0;
                    //  "Tuition Fee":=0;
                    //  "Air Ticket":=0;
                    "Total Cost" := "Tuition Fee" + "Air Ticket";
                    "Total Cost (LCY)" := "Tuition Fee" + "Air Ticket";
                    "Total Cost (LCY)" := "Total Cost";
                end;*/
            end;
        }
        field(78; "International Destination"; Text[250])
        {
            TableRelation = "Country/Region".Name;

            trigger OnValidate()
            begin
                TestField("No. Of Days");
                /*empl.Reset;
                empl.Get("Employee No");
                Clusterrec.Reset;
                if "Local Travel" = true then begin
                    Clusterrec.SetFilter("Cluster Place", "Local Destination");
                    if Clusterrec.FindSet then begin
                        srcscaleslocal.Reset;
                        if srcscaleslocal.Get(empl."Salary Scale", Clusterrec."Cluster Code") then begin
                            "Perdiem Per Day" := srcscaleslocal.Amount;
                            "Per Diem" := srcscaleslocal.Amount * "No. Of Days";
                            "Total Cost" := "Per Diem" + "Tuition Fee" + "Air Ticket";
                        end;
                    end;
                end;
                if "International Travel" = true then begin
                    scrscalesinter.Reset;
                    if scrscalesinter.Get(empl."Salary Scale", "International Destination") then begin
                        "Perdiem Per Day" := scrscalesinter.Amount;
                        "Per Diem" := scrscalesinter.Amount * "No. Of Days";
                        "Total Cost" := "Per Diem" + "Tuition Fee" + "Air Ticket";
                    end;
                end;
                Validate("Exchange Rate");*/
            end;
        }
        field(79; "HR Approved"; Boolean)
        {
        }
        field(80; "Ready For Imprest"; Boolean)
        {
            Description = '//Ready to be Applied to Imprest';
        }
        field(81; "Ready For Imprest2"; Boolean)
        {
            Description = '//Already Applied to Imprest';
        }
        field(82; "Ready For Imprest22"; Boolean)
        {
            Description = '//Ready to be Applied to Imprest-Control';
        }
        field(83; "Training Institution Code"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                vendorrec.Reset;
                if vendorrec.Get("Training Institution Code") then begin
                    "Training Insitution" := vendorrec.Name;
                end;
            end;
        }
        field(84; "Tuition Invoice Created"; Boolean)
        {
        }
        field(85; Evaluated; Code[20])
        {
            FieldClass = Normal;

            trigger OnValidate()
            begin
                //Lookup("Training Evaluation"."Training Code" WHERE (Employee No=FIELD(Employee No), Training Code=FIELD(Request No.)))
            end;
        }
        field(86; "Perdiem Per Day"; Decimal)
        {
        }
        field(87; Sponsor; Option)
        {
            OptionCaption = 'CDP ERC,World Bank,ERC Workshop';
            OptionMembers = "CDP ERC","World Bank","ERC Workshop";
        }
    }

    keys
    {
        key(Key1; "Request No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Request No.", "Training Insitution", "Course Title", "Employee No", "Employee Name")
        {
        }
    }

    trigger OnDelete()
    begin
        if Status <> Status::Open then
            Error('You cannot delete a document that is already approved or pending approval');
    end;

    trigger OnInsert()
    begin
        if TrainingMasterPlan.IsAReadOnlyUser() then
            Error('You are not authorized to modify these records!');

        if "Request No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Training Request Nos");
            "Request No." := NoSeriesMgt.GetNextNo(HumanResSetup."Training Request Nos");
            "GL Account" := HumanResSetup."Account No (Training)";
        end;
        "Request Date" := Today;

        if "User ID" = '' then
            "User ID" := UserId;

        //if UserSetup.Get(UserId) then begin
        empl.Reset();
        empl.SetRange("User ID", "User ID");
        if (empl.FindFirst()) and ("User ID" <> '') then begin
            "Employee No" := empl."No.";//UserSetup."Employee No.";
                                        //if empl.Get(UserSetup."Employee No.") then
            "Employee Name" := empl."First Name" + ' ' + empl."Middle Name" + ' ' + empl."Last Name";
            Directorate := empl."Responsibility Center";
            "Department Code" := empl."Responsibility Center";//empl."Sub Responsibility Center";
            Validate(Directorate);
            Validate("Department Code");
            //ERROR('%1',empl.ShowDimensions);
            /* DimVal.RESET;
             DimVal.SETRANGE(DimVal."Global Dimension No.",1);
             DimVal.SETRANGE(DimVal.Code,"Department Code");
             IF DimVal.FIND('-') THEN
              "Department Name":=DimVal.Name;

           Directorate:=empl."Global Dimension 1 Code";
           DimVal.RESET;
           DimVal.SETRANGE(DimVal."Global Dimension No.",1);
           DimVal.SETRANGE(DimVal.Code,Directorate);
           IF DimVal.FIND('-') THEN
            "Directorate Name":=DimVal.Name;
            */
            Designation := empl."Job Title";
            //GLSetup.Reset;
            //GLSetup.Get;
            // GLSetup.TESTFIELD("Trainings Account");
            // "GL Account":=GLSetup."Trainings Account";
            //"Budget Name" := GLSetup."Current Budget";
        end;

        //IF CompanyInfo.GET THEN
        //"CBK Website Address":=CompanyInfo."CBK Web Address";

        //IF PurchSetup.GET THEN
        //"Budget Name":=PurchSetup."Effective Procurement Plan";

    end;

    trigger OnModify()
    begin
        if TrainingMasterPlan.IsAReadOnlyUser() then
            Error('You are not authorized to modify these records!');

        if Status = Status::Released then begin
            //ERROR('You cannot modify a document that is already approved or pending approval');
        end;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        UserSetup: Record "User Setup";
        empl: Record Employee;
        //TrainingNeeds: Record "HR Organisation";
        CountryRec: Record "Country/Region";
        CompanyInfo: Record "Company Information";
        PurchSetup: Record "Purchases & Payables Setup";
        DimVal: Record "Dimension Value";
        AccPeriod: Record "Accounting Period";
        FiscalStart: Date;
        //Clusterrec: Record "SRC Cluster Places";
        //srcscaleslocal: Record "SRC Scales Local";
        //scrscalesinter: Record "SRC Scales-International";
        countryrec2: Record "Country/Region";
        //GLSetup: Record "Cash Management Setup";
        dimensionvalue: Record "Dimension Value";
        vendorrec: Record Vendor;
        ResponsibilityCenter: Record "Responsibility Center";
        SubResponsibilityCenter: Record "Sub Responsibility Center";
        TrainingMasterPlan: Record "Training Master Plan Header";


    procedure CommitTraining(TrainingRec: Record "Training Request")
    var
    //commitrec1: Record "Structure Identifier Tables";
    //commitrec2: Record "Structure Identifier Tables";
    begin

        /*GLSetup.RESET;
        GLSetup.GET;
        commitrec1.RESET;
        commitrec1.SETFILTER("Entry No",'<>%1',0);
        IF commitrec1.FINDLAST THEN BEGIN
           IF TrainingRec."Per Diem"<>0 THEN BEGIN
                 IF TrainingRec."Local Travel"=TRUE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+1;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=TrainingRec."Per Diem";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Perdiem For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2.Perdiem:=TRUE;
                       commitrec2.INSERT;
                 END;
                 IF TrainingRec."Local Travel"=FALSE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+1;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=TrainingRec."Per Diem"*TrainingRec."Exchange Rate";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Perdiem For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2.Perdiem:=TRUE;
                       commitrec2.INSERT;
                 END;
           END;
           IF TrainingRec."Tuition Fee"<>0 THEN BEGIN
                 IF TrainingRec."Local Travel"=TRUE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+2;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=TrainingRec."Tuition Fee";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Tuition Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Tuition Fee":=TRUE;
                       commitrec2.INSERT;
                 END;
                 IF TrainingRec."Local Travel"=FALSE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+2;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=TrainingRec."Tuition Fee"*TrainingRec."Exchange Rate";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Tuition Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Tuition Fee":=TRUE;
                       commitrec2.INSERT;
                 END;
           END;
           IF TrainingRec."Air Ticket"<>0 THEN BEGIN
                 IF TrainingRec."Local Travel"=TRUE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+3;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=TrainingRec."Air Ticket";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Air ticket Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Air Fair":=TRUE;
                       commitrec2.INSERT;
                 END;
                 IF TrainingRec."Local Travel"=FALSE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+3;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=TrainingRec."Air Ticket"*TrainingRec."Exchange Rate";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Air ticket Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Air Fair":=TRUE;
                       commitrec2.INSERT;
                 END;
           END;
        END;
        */

    end;


    procedure DeCommitTraining(TrainingRec: Record "Training Request")
    var
    //commitrec1: Record "Structure Identifier Tables";
    //commitrec2: Record "Structure Identifier Tables";
    begin
        /*GLSetup.RESET;
        GLSetup.GET;
        commitrec1.RESET;
        commitrec1.SETFILTER("Entry No",'<>%1',0);
        IF commitrec1.FINDLAST THEN BEGIN
        
           IF TrainingRec."Tuition Fee"<>0 THEN BEGIN
                 IF TrainingRec."Local Travel"=TRUE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+2;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Tuition Fee";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Tuition Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Tuition Fee":=TRUE;
                       commitrec2.INSERT;
                 END;
                 IF TrainingRec."Local Travel"=FALSE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+2;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Tuition Fee"*TrainingRec."Exchange Rate";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Tuition Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Tuition Fee":=TRUE;
                       commitrec2.INSERT;
                 END;
           END;
        
        END;
        */

    end;


    procedure DeCommitTrainingDSA(TrainingRec: Record "Training Request")
    var
    //commitrec1: Record "Structure Identifier Tables";
    //commitrec2: Record "Structure Identifier Tables";
    begin
        /*GLSetup.RESET;
        GLSetup.GET;
        commitrec1.RESET;
        commitrec1.SETFILTER("Entry No",'<>%1',0);
        IF commitrec1.FINDLAST THEN BEGIN
           IF TrainingRec."Per Diem"<>0 THEN BEGIN
                 IF TrainingRec."Local Travel"=TRUE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+1;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Per Diem";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Perdiem For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2.Perdiem:=TRUE;
                       commitrec2.INSERT;
                 END;
                 IF TrainingRec."Local Travel"=FALSE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+1;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Per Diem"*TrainingRec."Exchange Rate";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Perdiem For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2.Perdiem:=TRUE;
                       commitrec2.INSERT;
                 END;
           END;
        
        
        END;
        */

    end;


    procedure CommitTrainingD(TrainingRec: Record "Training Request")
    var
    //commitrec1: Record "Structure Identifier Tables";
    //commitrec2: Record "Structure Identifier Tables";
    begin
        /*GLSetup.RESET;
        GLSetup.GET;
        commitrec1.RESET;
        commitrec1.SETFILTER("Entry No",'<>%1',0);
        IF commitrec1.FINDLAST THEN BEGIN
           IF TrainingRec."Per Diem"<>0 THEN BEGIN
                 IF TrainingRec."Local Travel"=TRUE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+1;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Per Diem";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Perdiem For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2.Perdiem:=TRUE;
                       commitrec2.INSERT;
                 END;
                 IF TrainingRec."Local Travel"=FALSE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+1;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Per Diem"*TrainingRec."Exchange Rate";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Perdiem For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2.Perdiem:=TRUE;
                       commitrec2.INSERT;
                 END;
           END;
           IF TrainingRec."Tuition Fee"<>0 THEN BEGIN
                 IF TrainingRec."Local Travel"=TRUE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+2;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Tuition Fee";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Tuition Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Tuition Fee":=TRUE;
                       commitrec2.INSERT;
                 END;
                 IF TrainingRec."Local Travel"=FALSE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+2;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Tuition Fee"*TrainingRec."Exchange Rate";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Tuition Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Tuition Fee":=TRUE;
                       commitrec2.INSERT;
                 END;
           END;
           IF TrainingRec."Air Ticket"<>0 THEN BEGIN
                 IF TrainingRec."Local Travel"=TRUE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+3;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Air Ticket";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Air ticket Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Air Fair":=TRUE;
                       commitrec2.INSERT;
                 END;
                 IF TrainingRec."Local Travel"=FALSE THEN BEGIN
                       commitrec2.INIT;
                       commitrec2."Entry No":=commitrec1."Entry No"+3;
                       commitrec2."Commitment Date":=TODAY;
                       commitrec2."Commitment No":=TrainingRec."Request No.";
                       commitrec2."Document No.":=TrainingRec."Request No.";
                       commitrec2.Amount:=-TrainingRec."Air Ticket"*TrainingRec."Exchange Rate";
                       commitrec2."Budget Line":=GLSetup."Current Budget";
                       commitrec2."Budget Year":=GLSetup."Current Budget";
                       commitrec2."Global Dimension 1 Code":=TrainingRec."Department Code";
                       commitrec2.Description:='Air ticket Fee For Training: '+TrainingRec."Course Title"+':-'+TrainingRec."Training Objective";
                       commitrec2.GLAccount:=TrainingRec."GL Account";
                       commitrec2."Air Fair":=TRUE;
                       commitrec2.INSERT;
                 END;
           END;
        END;
        */

    end;
}