table 51525309 "Change Request"
{
    Caption = 'Employee Changes';
    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    DrillDownPageID = "Employee Change Requests";
    LookupPageID = "Employee Change Requests";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Change Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
        }
        field(5; "First Name(Prev)"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Middle Name(Prev)"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "Last Name(Prev)"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Job Title"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Job Title(Prev)"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; Address; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Address(Prev)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Company E-Mail"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Company E-Mail(Prev)"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Bank Account No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Bank Account No.(Prev)"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(17; "Marital Status(Prev)"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(18; "KRA Pin"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "KRA Pin(Prev)"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "NSSF No"; Code[20])
        {
            Caption = 'Pension No.';
            DataClassification = ToBeClassified;
        }
        field(21; "NSSF No(Prev)"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "NHIF No"; Code[20])
        {
            Caption = 'Medical No.';
            DataClassification = ToBeClassified;
        }
        field(23; "NHIF No(Prev)"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Employment Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Employment Type(Prev)"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; "Job Grade"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Job Grade(Prev)"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            end;
        }
        field(29; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Bank Branch Code"; Code[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            end;
        }
        field(31; "Bank Brach Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Bank Code(Prev)"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(33; "Bank Name(Prev)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(34; "Bank Branch Code(Prev)"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(35; "Bank Brach Name(Prev)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(36; "Contract Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Contract Start Date(Prev)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(38; Citizenship; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Citizenship(Prev)"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(40; "Personal Email"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Personal Email(Prev)"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; "Contract End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Contract End Date(Prev)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(44; "Ethnic Group"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ethnic Groups".Code;
        }
        field(45; "Ethnic Group(Prev)"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Ethnic Groups".Code;
        }
        field(46; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(47; "USER ID"; Code[80])
        {
            Caption = 'Requested By';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(48; "Date Modified"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(49; "Time Modified"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; "Job Number"; Code[60])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(51; "Phone Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Phone Number(Prev)"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
        }
        field(53; County; Text[30])
        {
            Caption = 'County';
            TableRelation = County.Code;
        }
        field(54; "County(Prev)"; Text[30])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = County.Code;
        }
        field(55; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
            DataClassification = ToBeClassified;
        }
        field(56; "Birth Date(Prev)"; Date)
        {
            Caption = 'Birth Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(57; Gender; Option)
        {
            Caption = 'Gender';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(58; "Gender(Prev)"; Option)
        {
            Caption = 'Gender';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(59; "Employment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Employment Date(Prev)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(61; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(62; "Status(Prev)"; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(63; "Number Of Years"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Scale Benefits"."Salary Pointer" WHERE("Salary Scale" = FIELD("Salary Scale"),
                                                                     "ED Code" = CONST('01'));
        }
        field(64; "Number Of Years(Prev)"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Scale Benefits"."Salary Pointer" WHERE("Salary Scale" = FIELD("Salary Scale"),
                                                                     "ED Code" = CONST('01'));
        }
        field(65; "Salary Scale"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salary Scales".Scale;
        }
        field(66; "Salary Scale(Prev)"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Salary Scales".Scale;
        }
        field(67; Updated; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(68; "Modified By"; Code[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(69; "Reason For Change"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Promotion,Demotion,Interdiction,Suspension,Annual Increment';
            OptionMembers = Promotion,Demotion,Interdiction,Suspension,"Annual Increment";
        }
        field(70; "Emp No."; Code[20])
        {
            Caption = 'WB No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                if Employees.Get("Emp No.") then begin
                    "First Name" := Employees."First Name";
                    "First Name(Prev)" := Employees."First Name";
                    "Middle Name" := Employees."Middle Name";
                    "Middle Name(Prev)" := Employees."Middle Name";
                    "Last Name" := Employees."Last Name";
                    "Last Name(Prev)" := Employees."Last Name";
                    "Job Title" := Employees."Job Title";
                    "Job Title(Prev)" := Employees."Job Title";
                    Address := Employees.Address;
                    "Address(Prev)" := Employees.Address;
                    "Company E-Mail" := Employees."Company E-Mail";
                    "Company E-Mail(Prev)" := Employees."Company E-Mail";
                    "Bank Account No." := Employees."Bank Account No.";
                    "Bank Account No.(Prev)" := Employees."Bank Account No.";
                    "Marital Status" := Employees."Marital Status";
                    "Marital Status(Prev)" := Employees."Marital Status";
                    "KRA Pin" := Employees."PIN Number";
                    "KRA Pin(Prev)" := Employees."PIN Number";
                    "NHIF No" := Employees."NHIF No.";
                    "NHIF No(Prev)" := Employees."NHIF No.";
                    "NSSF No" := Employees."NSSF No.";
                    "NSSF No(Prev)" := Employees."NSSF No.";
                    "Employment Type" := Employees."Emplymt. Contract Code";
                    "Employment Type(Prev)" := Employees."Emplymt. Contract Code";
                    "Job Grade" := Employees."Job Grade";
                    "Job Grade(Prev)" := Employees."Job Grade";
                    "Bank Code" := Employees."Bank Code";
                    "Bank Code(Prev)" := Employees."Bank Code";
                    "Bank Name" := Employees."Bank Name";
                    "Bank Name(Prev)" := Employees."Bank Name";
                    "Contract Start Date" := Employees."Contract Start Date";
                    "Contract Start Date(Prev)" := Employees."Contract Start Date";
                    Citizenship := Employees.Citizenship;
                    "Citizenship(Prev)" := Employees.Citizenship;
                    "Contract End Date" := Employees."Contract End Date";
                    "Contract End Date(Prev)" := Employees."Contract End Date";
                    "Ethnic Group" := Employees."Ethnic Group";
                    "Ethnic Group(Prev)" := Employees."Ethnic Group";
                    if Employees."Phone No." = '' then
                        Employees."Phone No." := Employees."Mobile Phone No.";
                    "Phone Number" := Employees."Phone No.";
                    "Phone Number(Prev)" := Employees."Phone No.";
                    "Birth Date" := Employees."Birth Date";
                    "Birth Date(Prev)" := Employees."Birth Date";
                    Status := Employees.Status;
                    "Status(Prev)" := Employees.Status;
                    Gender := Employees.Gender;
                    "Gender(Prev)" := Employees.Gender;
                    "Employment Date" := Employees."Employment Date";
                    "Employment Date(Prev)" := Employees."Employment Date";
                    "Number Of Years" := Employees.Present;
                    "Number Of Years(Prev)" := Employees.Present;
                    "Salary Scale" := Employees."Salary Scale";
                    "Salary Scale(Prev)" := Employees."Salary Scale";
                    "Bank Branch Code" := Employees."Bank Branch Code";
                    "Bank Branch Code(Prev)" := Employees."Bank Branch Code";
                    "Personal Email" := Employees."E-mail";
                    "Personal Email(Prev)" := Employees."E-mail";
                    Position := Employees.Position;
                    "Prev Position" := Employees.Position;
                    "ID Number" := Employees."ID Number";
                    "Previous ID Number" := Employees."ID Number";
                    "Passport Number" := Employees."Passport Number";
                    "Prev Passport Number" := Employees."Passport Number";
                    "Country/Region Code" := Employees."Country/Region Code";
                    "Prevailing Country/Region Code" := Employees."Country/Region Code";
                    Religion := Employees.Religion;
                    "Prev Religion" := Employees.Religion;
                    "Annual Leave Entitlement" := Employees."Annual Leave Entitlement";
                    "Prev Annual Leave Entitlement" := Employees."Annual Leave Entitlement";
                    "No. of Children" := Employees."No. of Children";
                    "Prev No. of Children" := Employees."No. of Children";
                    Station := Employees.Station;
                    "Prev Station" := Employees.Station;
                    Province := Employees.Province;
                    "Prev Province" := Employees.Province;
                    District := Employees.District;
                    "Prev District" := Employees.District;
                    Sector := Employees.Sector;
                    "Prev Sector" := Employees.Sector;
                    Cell := Employees.Cell;
                    "Prev Cell" := Employees.Cell;
                    Village := Employees.Village;
                    "Prev Village" := Employees.Village;
                    "Plot No." := Employees."Plot No.";
                    "Prev Plot No." := Employees."Plot No.";
                    "Street No." := Employees."Street No.";
                    "Prev Street No." := Employees."Street No.";
                    "Workstation Country" := Employees."Workstation Country";
                    "Prev Workstation Country" := Employees."Workstation Country";
                    "Responsibility Center" := Employees."Responsibility Center";
                    "Prev Responsibility Center" := Employees."Responsibility Center";
                    "Sub Section" := Employees."Sub Section";
                    "Prev Sub Section" := Employees."Sub Section";
                    "Date Of Birth" := Employees."Date Of Birth";
                    "Prev Date Of Birth" := Employees."Date Of Birth";
                    "Date Of Join" := Employees."Date Of Join";
                    "Prev Date Of Join" := Employees."Date Of Join";
                    "Date of Appointment" := Employees."Date of Appointment";
                    "Prev Date of Appointment" := Employees."Date of Appointment";
                    "Date Of Leaving" := Employees."Date Of Leaving";
                    "Prev Date Of Leaving" := Employees."Date Of Leaving";
                    "Sub Responsibility Center" := Employees."Sub Responsibility Center";
                    "Prev Sub Responsibility Center" := Employees."Sub Responsibility Center";
                    // *** NEW: Auto-populate Supervisor Name from Employee ***
                    "New Supervisor No" := CopyStr(Employees."Supervisor Name", 1, MaxStrLen("New Supervisor No"));
                    "Prev Supervisor No" := CopyStr(Employees."Supervisor Name", 1, MaxStrLen("Prev Supervisor No"));
                    "New Supervisor Full Name" := '';
                    "Prev Supervisor Full Name" := '';
                    if "New Supervisor No" <> '' then begin
                        SupervisorRec.Reset();
                        if SupervisorRec.Get("New Supervisor No") then begin
                            "New Supervisor Full Name" := SupervisorRec."First Name" + ' ' + SupervisorRec."Last Name";
                            "Prev Supervisor Full Name" := SupervisorRec."First Name" + ' ' + SupervisorRec."Last Name";
                        end;
                    end;

                    EmpKinChanges.Reset();
                    EmpKinChanges.SetRange("Employee Change Code", "No.");
                    EmpKinChanges.DeleteAll();

                    EmpKins.Reset();
                    EmpKins.SetRange("Employee Code", "Emp No.");
                    if EmpKins.FindSet() then
                        repeat
                            EmpKinChanges.Init();
                            EmpKinChanges.TransferFields(EmpKins);
                            EmpKinChanges."Employee Change Code" := "No.";
                            EmpKinChanges.Insert();
                        until EmpKins.Next() = 0;

                    EmpBenefChanges.Reset();
                    EmpBenefChanges.SetRange("Employee Change Code", "No.");
                    EmpBenefChanges.DeleteAll();

                    EmpBeneficiaries.Reset();
                    EmpBeneficiaries.SetRange("Employee Code", "Emp No.");
                    if EmpBeneficiaries.FindSet() then
                        repeat
                            EmpBenefChanges.Init();
                            EmpBenefChanges.TransferFields(EmpBeneficiaries);
                            EmpBenefChanges."Employee Change Code" := "No.";
                            EmpBenefChanges.Insert();
                        until EmpBeneficiaries.Next() = 0;

                    EmpRelaChanges.Reset();
                    EmpRelaChanges.SetRange("Employee Change No.", "No.");
                    EmpRelaChanges.DeleteAll();

                    EmpRelatives.Reset();
                    EmpRelatives.SetRange("Employee No.", "Emp No.");
                    if EmpRelatives.FindSet() then
                        repeat
                            EmpRelaChanges.Init();
                            EmpRelaChanges.TransferFields(EmpRelatives);
                            EmpRelaChanges."Employee Change No." := "No.";
                            EmpRelaChanges.Insert();
                        until EmpRelatives.Next() = 0;
                end;
            end;
        }
        field(71; Position; Code[100])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                CompanyJobsRec.Reset;
                CompanyJobsRec.SetRange("Job ID", Position);
                if CompanyJobsRec.FindFirst then begin
                    "Job Title" := CompanyJobsRec."Job Description";
                end;
            end;
        }
        field(72; "Prev Position"; Code[100])
        {
            Editable = false;
        }
        field(73; "ID Number"; Text[30])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(74; "Previous ID Number"; Text[30])
        {
            Editable = false;
        }
        field(75; "Passport Number"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            end;
        }
        field(76; "Prev Passport Number"; Text[30])
        {
            Editable = false;
        }
        field(77; "Country/Region Code"; Code[50])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";
        }
        field(78; "Prevailing Country/Region Code"; Code[50])
        {
            Caption = 'Prev Nationality';
            Editable = false;
        }
        field(79; Religion; Code[20])
        {
        }
        field(80; "Prev Religion"; Code[20])
        {
            Editable = false;
        }
        field(81; "Annual Leave Entitlement"; Decimal)
        {
            trigger OnValidate()
            begin
                if "Annual Leave Entitlement" < 0 then
                    error('The annual leave entitlement cannot be less than 0!');
            end;
        }
        field(82; "Prev Annual Leave Entitlement"; Decimal)
        {
            Editable = false;
        }
        field(83; "No. of Children"; Integer)
        {
            trigger OnValidate()
            begin
                if "No. of Children" < 0 then
                    error('The number of children cannot be less than 0!');
            end;
        }
        field(84; "Prev No. of Children"; Integer)
        {
            Editable = false;
        }
        field(85; Station; Code[100])
        {
            TableRelation = "Stations";
        }
        field(86; "Prev Station"; Code[100])
        {
            Editable = false;
        }
        field(87; Province; Code[50])
        {
            TableRelation = "Provinces";
        }
        field(88; "Prev Province"; Code[50])
        {
            Editable = false;
        }
        field(89; District; Code[50])
        {
            TableRelation = "Districts";
        }
        field(90; "Prev District"; Code[50])
        {
            Editable = false;
        }
        field(91; Sector; Code[50])
        {
            TableRelation = "Sectors";
        }
        field(92; "Prev Sector"; Code[50])
        {
            Editable = false;
        }
        field(93; Cell; Code[50])
        {
            TableRelation = "Cells";
        }
        field(94; "Prev Cell"; Code[50])
        {
            Editable = false;
        }
        field(95; Village; Code[50])
        {
            TableRelation = "Villages";
        }
        field(96; "Prev Village"; Code[50])
        {
            Editable = false;
        }
        field(97; "Plot No."; Code[50])
        {
        }
        field(98; "Prev Plot No."; Code[50])
        {
        }
        field(99; "Street No."; Code[50])
        {
        }
        field(100; "Prev Street No."; Code[50])
        {
        }
        field(101; "Workstation Country"; Code[50])
        {
            TableRelation = "Country/Region";
        }
        field(102; "Prev Workstation Country"; Code[50])
        {
            Editable = false;
        }
        field(103; "Responsibility Center"; Code[240])
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
        }
        field(104; "Prev Responsibility Center"; Code[240])
        {
            Caption = 'Prev Department';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center".Code;
            Editable = false;
        }
        field(105; "Sub Section"; Code[240])
        {
            TableRelation = "Sub Sections";
        }
        field(106; "Prev Sub Section"; Code[240])
        {
            Editable = false;
        }
        field(107; "Date Of Birth"; Date)
        { }
        field(108; "Prev Date Of Birth"; Date)
        { }
        field(109; "Date Of Join"; Date)
        { }
        field(110; "Prev Date Of Join"; Date)
        {
            Editable = false;
        }
        field(111; "Date of Appointment"; Date)
        { }
        field(112; "Prev Date of Appointment"; Date)
        { }
        field(113; "Date Of Leaving"; Date)
        { }
        field(114; "Prev Date Of Leaving"; Date)
        { }
        field(115; "Summarized reasons for change"; Text[1000])
        { }
        field(116; "Change Approval Status"; Option)
        {
            Caption = 'Approval Status';
            OptionMembers = Open,"Pending Approval",Rejected,Approved;
            Editable = false;
        }
        field(117; "Sub Responsibility Center"; Code[70])
        {
            Caption = 'Section';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Responsibility Center".Code where("Responsibility Center" = field("Responsibility Center"));
        }
        field(118; "Prev Sub Responsibility Center"; Code[70])
        {
            Caption = 'Prev Section';
            Editable = false;
        }
        field(119; "Movement Type"; Option)
        {
            Caption = 'Movement Change Type';
            OptionMembers = "August 2023",Initial,Country,Station,"Department/Section",Promotion,Demotion,"Salary Adjustment","Temporary Contract","New Appointment","Additional Duties/Responsibility",Reintegration,"Temporary Contract Extension","Final Call Letter","End of additional duties/responsibility",Seniority,"Employment Contract Amendment","Reinstatement Letter",Other,"Salary Alignment",Trainee,Consultant,"Title Change and Responsibilities","Gross Adjustment due to New Pension Rate","Change due to Transformation";
        }
        field(120; "Movement Start Date"; Date)
        {
        }
        field(121; "Create New Movement"; Boolean)
        { }
        field(122; "Datetime Created"; DateTime)
        {
            Editable = false;
        }
        field(123; "Job Application No."; Code[20])
        {
            TableRelation = "Job Applications";
        }
        field(124; "Cellular Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(125; "Work Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(126; "Search Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(127; "Postal Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(128; "Residential Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(129; "Post Code"; Code[20])
        { }
        field(130; "Change Type"; Option)
        {
            Editable = false;
            OptionMembers = "File Update",Onboarding;
        }
        // *** NEW FIELDS: Supervisor Name tracking ***
        field(131; "New Supervisor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
            Caption = 'Supervisor Name';

            trigger OnValidate()
            begin
                if "New Supervisor No" <> '' then begin
                    if SupervisorRec.Get("New Supervisor No") then
                        "New Supervisor Full Name" := SupervisorRec."First Name" + ' ' + SupervisorRec."Last Name"
                    else
                        Error('Employee No. %1 does not exist.', "New Supervisor No");
                end else
                    "New Supervisor Full Name" := '';
            end;
        }
        field(132; "Prev Supervisor No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Previous Supervisor';
        }
        field(133; "New Supervisor Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Supervisor Full Name';
        }
        field(134; "Prev Supervisor Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Previous Supervisor Full Name';
        }

    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "First Name", "Last Name", "First Name(Prev)", "Middle Name(Prev)")
        {
        }
        fieldgroup(Brick; "Last Name", "First Name", "Middle Name(Prev)")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Change Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Change Nos");
            "USER ID" := UserId;
        end;

        "Datetime Created" := CurrentDateTime;
    end;

    trigger OnDelete()
    begin
        if Rec."Change Approval Status" <> Rec."Change Approval Status"::Open then
            Error('You cannot delete the record at this stage!');
    end;

    procedure CheckDelete(ChangeNo: Code[20])
    begin
        if ChangeNo = '' then
            exit;
        EmpChanges.Reset();
        EmpChanges.SetRange("No.", ChangeNo);
        EmpChanges.SetRange("Change Approval Status", EmpChanges."Change Approval Status"::Open);
        if not EmpChanges.FindFirst() then
            Error('You cannot delete the record at this stage!');
    end;

    procedure FullName(): Text
    begin
        exit("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    var
        EmpChanges: Record "Change Request";
        EmployeeRecCopy: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        Res: Record Resource;
        PostCode: Record "Post Code";
        AlternativeAddr: Record "Alternative Address";
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record "Employee Relative";
        EmployeeAbsence: Record "Employee Absence";
        MiscArticleInformation: Record "Misc. Article Information";
        ConfidentialInformation: Record "Confidential Information";
        HumanResComment: Record "Human Resource Comment Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        NoSeriesMgt: Codeunit "No. Series";
        EmployeeResUpdate: Codeunit "Employee/Resource Update";
        EmployeeSalespersonUpdate: Codeunit "Employee/Salesperson Update";
        DimMgt: Codeunit DimensionManagement;
        Text000: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        BlockedEmplForJnrlErr: Label 'You cannot create this document because employee %1 is blocked due to privacy.', Comment = '%1 = employee no.';
        BlockedEmplForJnrlPostingErr: Label 'You cannot post this document because employee %1 is blocked due to privacy.', Comment = '%1 = employee no.';
        CompanyJobsRec: Record "Company Jobs";
        EmployeeRec: Record Employee;
        SalaryScalesRec: Record "Salary Scales";
        Dates: Codeunit "HR Dates";
        AssMatrix: Record "Assignment Matrix";
        ansmsg: Text;
        ans: Boolean;
        EmployeePostingGroupRec: Record "Staff Posting Group";
        HRDates: Codeunit "HR Dates";
        Employees: Record Employee;
        // *** NEW: SupervisorRec for supervisor lookup ***
        SupervisorRec: Record Employee;
        EmpKins: Record "Employee Kin";
        EmpKinChanges: Record "Employee Kin Changes";
        EmpBeneficiaries: Record "Employee Beneficiaries";
        EmpBenefChanges: Record "Employee Beneficiaries Changes";
        EmpRelatives: Record "Employee Relative";
        EmpRelaChanges: Record "Employee Relative Changes";
        Movement: Record "Internal Employement History";
        MovementInit: Record "Internal Employement History";
        AttachmentsRequest: Record "Document Attachment";
        AttachmentsEmp: Record "Document Attachment";
        AttachmentID: Integer;

    procedure UpdateEmployeeCard()
    var
        JobApplication: Record "Job Applications";
    begin
        if "Change Type" = Rec."Change Type"::Onboarding then begin
            Employees.Reset();
            Employees.Init();
            Employees."No." := '';
            Employees."Job Application No." := "Job Application No.";
            Employees.Insert(true);
            "Emp No." := Employees."No.";

            JobApplication.Reset();
            JobApplication.SetRange("Change Request No.", "No.");
            if JobApplication.FindFirst() then begin
                JobApplication."Employee No" := "Emp No.";
                JobApplication.Modify();
            end;
        end;

        Employees.Reset;
        Employees.SetRange(Employees."No.", "Emp No.");
        if Employees.FindFirst then begin
            Employees."First Name" := "First Name";
            Employees."Middle Name" := "Middle Name";
            Employees."Last Name" := "Last Name";
            Employees."Job Title" := "Job Title";
            Employees.Address := Address;
            Employees."Company E-Mail" := "Company E-Mail";
            Employees."Bank Account No." := "Bank Account No.";
            Employees."Marital Status" := "Marital Status";
            Employees."PIN Number" := "KRA Pin";
            Employees."NHIF No." := "NHIF No";
            Employees."NSSF No." := "NSSF No";
            Employees."Emplymt. Contract Code" := "Employment Type";
            Employees."Job Grade" := "Job Grade";
            Employees."Bank Code" := "Bank Code";
            Employees."Bank Name" := "Bank Name";
            Employees."Contract Start Date" := "Contract Start Date";
            Employees.Citizenship := Citizenship;
            Employees."Contract End Date" := "Contract End Date";
            Employees."Ethnic Group" := "Ethnic Group";
            Employees."Phone No." := "Phone Number";
            Employees."Mobile Phone No." := "Phone Number";
            Employees."Cellular Phone Number" := "Cellular Phone Number";
            Employees."Work Phone Number" := "Work Phone Number";
            Employees."Search Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
            Employees."Postal Address" := "Postal Address";
            Employees."Residential Address" := "Residential Address";
            Employees."Post Code" := "Post Code";
            Employees."Birth Date" := "Birth Date";
            Employees.Status := Status;
            Employees.Gender := Gender;
            Employees."Employment Date" := "Employment Date";
            Employees.Present := "Number Of Years";
            Employees."Salary Scale" := "Salary Scale";
            Employees."Bank Branch Code" := "Bank Branch Code";
            Employees."Bank Brach Name" := "Bank Brach Name";
            Employees."E-mail" := "Personal Email";
            Employees.Validate(Position, Position);
            Employees."ID Number" := "ID Number";
            Employees."Passport Number" := "Passport Number";
            Employees."Country/Region Code" := "Country/Region Code";
            Employees.Religion := Religion;
            Employees."Annual Leave Entitlement" := "Annual Leave Entitlement";
            Employees."No. of Children" := "No. of Children";
            Employees.Station := Station;
            Employees.Province := Province;
            Employees.District := District;
            Employees.Sector := Sector;
            Employees.Cell := Cell;
            Employees.Village := Village;
            Employees."Plot No." := "Plot No.";
            Employees."Street No." := "Street No.";
            Employees."Workstation Country" := "Workstation Country";
            Employees.Validate("Responsibility Center", "Responsibility Center");
            Employees."Sub Section" := "Sub Section";
            Employees."Date Of Birth" := "Date Of Birth";
            Employees."Date Of Join" := "Date Of Join";
            Employees."Date of Appointment" := "Date of Appointment";
            Employees."Date Of Leaving" := "Date Of Leaving";
            Employees."Sub Responsibility Center" := "Sub Responsibility Center";
            // *** NEW: Push approved Supervisor Name back to Employee card ***
            Employees."Supervisor Name" := "New Supervisor No";
            Employees.Modify;
        end;

        //Update movement
        Movement.Reset();
        Movement.SetRange("Emp No.", "Emp No.");
        Movement.SetRange(Status, Movement.Status::Current);
        if Movement.FindFirst() then begin
            if ((Rec."Create New Movement") and ("Movement Start Date" <> 0D)) then begin
                MovementInit.Init();
                MovementInit.TransferFields(Movement);
                MovementInit.Type := "Movement Type";
                MovementInit."First Date" := "Movement Start Date";
                MovementInit.Validate(Status, MovementInit.Status::Current);
                MovementInit.Insert(true);

                Movement.Status := Movement.Status::Past;
                Movement.Modify();
            end else begin
                Movement.Validate("Position Code", Position);
                Movement.Validate("Dept Code", "Responsibility Center");
                Movement.Validate("Section Code", "Sub Responsibility Center");
                Movement.Validate("Station Code", Station);
                Movement."Workstation Country" := "Workstation Country";
                Movement.Modify();
            end;
        end;

        EmpKins.Reset();
        EmpKins.SetRange("Employee Code", "Emp No.");
        EmpKins.DeleteAll();

        EmpKinChanges.Reset();
        EmpKinChanges.SetRange("Employee Change Code", "No.");
        if EmpKinChanges.FindSet() then
            repeat
                EmpKins.Init();
                EmpKins.TransferFields(EmpKinChanges);
                EmpKins."Employee Code" := "Emp No.";
                if not EmpKins.Insert() then
                    EmpKins.Modify();
            until EmpKinChanges.Next() = 0;

        EmpBeneficiaries.Reset();
        EmpBeneficiaries.SetRange("Employee Code", "Emp No.");
        EmpBeneficiaries.DeleteAll();

        EmpBenefChanges.Reset();
        EmpBenefChanges.SetRange("Employee Change Code", "No.");
        if EmpBenefChanges.FindSet() then
            repeat
                EmpBeneficiaries.Init();
                EmpBeneficiaries.TransferFields(EmpBenefChanges);
                EmpBeneficiaries."Employee Code" := "Emp No.";
                if not EmpBeneficiaries.Insert() then
                    EmpBeneficiaries.Modify();
            until EmpBenefChanges.Next() = 0;

        EmpRelatives.Reset();
        EmpRelatives.SetRange("Employee No.", "Emp No.");
        EmpRelatives.DeleteAll();

        EmpRelaChanges.Reset();
        EmpRelaChanges.SetRange("Employee Change No.", "No.");
        if EmpRelaChanges.FindSet() then
            repeat
                EmpRelatives.Init();
                EmpRelatives.TransferFields(EmpRelaChanges);
                EmpRelatives."Employee No." := "Emp No.";
                if not EmpRelatives.Insert() then
                    EmpRelatives.Modify();
            until EmpRelaChanges.Next() = 0;

        //Update attachments
        AttachmentID := 0;
        AttachmentsRequest.Reset();
        AttachmentsRequest.SetCurrentKey(ID);
        AttachmentsRequest.SetAscending(ID, true);
        if AttachmentsRequest.FindLast() then
            AttachmentID := AttachmentsRequest.ID;

        AttachmentsRequest.Reset();
        AttachmentsRequest.SetRange("Table ID", Database::"Change Request");
        AttachmentsRequest.SetRange("No.", Rec."No.");
        if AttachmentsRequest.FindSet() then
            repeat
                AttachmentID += 1;
                AttachmentsEmp.Reset();
                AttachmentsEmp.Init();
                AttachmentsEmp.TransferFields(AttachmentsRequest);
                AttachmentsEmp.ID := AttachmentID;
                AttachmentsEmp."Table ID" := Database::Employee;
                AttachmentsEmp."No." := "Emp No.";
                AttachmentsEmp.Insert();
            until AttachmentsRequest.Next() = 0;

        Updated := true;
        "Modified By" := UserId;
        "Date Modified" := Today;
        "Time Modified" := Time;
    end;

}
