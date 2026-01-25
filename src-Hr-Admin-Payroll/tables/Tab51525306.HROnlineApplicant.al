table 51525306 "HR Online Applicant"
{

    fields
    {
        field(1; "Email Address"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "First Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Middle Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Last Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Mobile No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Initials; Text[15])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Search Name"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Postal Address"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Residential Address"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(10; City; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(13; "Home Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Cellular Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Work Phone Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Ext."; Text[7])
        {
            DataClassification = ToBeClassified;
        }
        field(19; Picture; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(20; "ID Number"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                /*Applicant.RESET;
                Applicant.SETRANGE(Applicant."ID Number","ID Number");
                IF Applicant.FIND('-') THEN
                ERROR('There is already a profile with a similar ID Number %1',"ID Number");
                
                Emp.RESET;
                Emp.SETRANGE("ID Number","ID Number");
                IF Emp.FIND('-') THEN BEGIN
                  MESSAGE('The Applicant has worked for the company before');
                  "Previous Employee":=TRUE;
                END;
                */

            end;
        }
        field(21; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(22; Country; Text[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(23; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Normal,Resigned,Discharged,Retrenched,Pension,Disabled;
        }
        field(24; Comment; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(25; "Fax Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(27; "Ethnic Origin"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Ethnic Groups";
        }
        field(29; "Driving Licence"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Disabled; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(31; "Health Assesment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Health Assesment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Date Of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(34; Age; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Primary Skills Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(40; "Postal Address2"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Postal Address3"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Residential Address2"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Residential Address3"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Post Code2"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(45; Citizenship; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region".Code;
        }
        field(46; "Disability Details"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Disability Grade"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Passport Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "2nd Skills Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(50; "3rd Skills Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(51; Region; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(58; "PIN Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(63; Employ; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(65; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(66; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                /*Employee.RESET;
                Employee.SETRANGE(Employee."No.","Employee No");
                IF Employee.FIND('-') THEN BEGIN
                "First Name":=Employee."First Name";
                "Middle Name":=Employee."Middle Name";
                "Last Name":=Employee."Last Name";
                Initials:=Employee.Initials;
                "Search Name":=Employee."Search Name";
                "Postal Address":=Employee."Postal Address";
                "Residential Address":=Employee."Residential Address";
                City:=Employee.City;
                "Post Code":=Employee."Post Code";
                County:=Employee.County;
                "Home Phone Number":=Employee."Home Phone Number";
                "Cellular Phone Number":=Employee."Cellular Phone Number";
                "Work Phone Number":=Employee."Work Phone Number";
                "Ext.":=Employee."Ext.";
                "E-Mail":=Employee."E-Mail";
                "ID Number":=Employee."ID Number";
                Gender:=Employee.Gender;
                "Country Code":=Employee."Country Code";
                "Fax Number":=Employee."Fax Number";
                "Marital Status":=Employee."Marital Status";
                "Ethnic Origin":=Employee.Tribe;
                //"First Language (R/W/S)":=Employee."First Language (R/W/S)";
                "Driving Licence":=Employee."Driving Licence";
                Disabled:=Employee.Disabled;
                "Health Assesment":=Employee."Health Assesment?";
                "Health Assesment Date":=Employee."Health Assesment Date";
                "Date Of Birth":=Employee."Date Of Birth";
                Age:=Employee.Age;
                ///"Second Language (R/W/S)":=Employee."Second Language (R/W/S)";
                //"Additional Language":=Employee."Additional Language";
                "Postal Address2":=Employee."Postal Address2";
                "Postal Address3":=Employee."Postal Address3";
                "Residential Address2":=Employee."Residential Address2";
                "Residential Address3":=Employee."Residential Address3";
                "Post Code2":=Employee."Post Code2";
                Citizenship:=Employee.Citizenship;
                "Passport Number":=Employee."Passport Number";
                {
                "First Language Read":=Employee."First Language Read";
                "First Language Write":=Employee."First Language Write";
                "First Language Speak":=Employee."First Language Speak";
                "Second Language Read":=Employee."Second Language Read";
                "Second Language Write":=Employee."Second Language Write";
                "Second Language Speak":=Employee."Second Language Speak";
                }
                "PIN Number":=Employee."PIN Number";
                "Country Code":=Employee."Country Code";
                "Applicant Type":="Applicant Type"::Internal;
                
                EmpQualifications.RESET;
                EmpQualifications.SETRANGE(EmpQualifications."Employee No.",Employee."No.");
                IF EmpQualifications.FIND('-') THEN BEGIN
                REPEAT
                AppQualifications."Applicant No.":="No.";
                //AppQualifications."Qualification Type":=EmpQualifications."Qualification Type";
                AppQualifications."Qualification Code":=EmpQualifications."Qualification Code";
                AppQualifications."From Date":=EmpQualifications."From Date";
                AppQualifications."To Date":=EmpQualifications."To Date";
                AppQualifications.Type:=EmpQualifications.Type;
                AppQualifications.Description:=EmpQualifications.Description;
                AppQualifications."Institution/Company":=EmpQualifications."Institution/Company";
                //AppQualifications.CourseType:=EmpQualifications.CourseType;
                //AppQualifications."Score ID":=EmpQualifications."Score ID";
                AppQualifications.Comment:=EmpQualifications.Comment;
                AppQualifications.INSERT(TRUE);
                
                UNTIL EmpQualifications.NEXT = 0
                END
                END
                */

            end;
        }
        field(67; "Applicant Type"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'External,Internal';
            OptionMembers = External,Internal;
        }
        field(68; DateEmployed; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(69; "Previous Employee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(71; "Person With Disability"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',No,Yes';
            OptionMembers = ,No,Yes;
        }
        field(72; "Know Any current Employee"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',No,Yes';
            OptionMembers = ,No,Yes;
        }
        field(73; "Have Any Relative in Org."; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',No,Yes';
            OptionMembers = ,No,Yes;
        }
        field(74; "Name of Employee"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(75; "Name of Relative"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(76; "Portal Password"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(77; "Default Portal Password"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(78; PasswordResetToken; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(79; PasswordResetTokenExpiry; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Applicant Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(81; County; Code[50])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
            TableRelation = County.Code;

            trigger OnValidate()
            begin
                Counties.Reset;
                if Counties.Get(County) then
                    "County Name" := Counties.Name;
            end;
        }
        field(82; "County Name"; Text[100])
        {
            Caption = 'County Name';
            DataClassification = ToBeClassified;
        }
        field(83; "Sub County Code"; Code[50])
        {
            Caption = 'Sub-County';
            DataClassification = ToBeClassified;
            TableRelation = "Sub County"."Sub County Code" WHERE("County Code" = FIELD(County));

            trigger OnValidate()
            begin
                SubCounties.Reset;
                SubCounties.SetRange("County Code", County);
                SubCounties.SetRange("Sub County Code", "Sub County Code");
                if SubCounties.FindFirst then
                    "Sub County Name" := SubCounties."Sub County Description";
            end;
        }
        field(84; "Sub County Name"; Text[100])
        {
            Caption = 'Sub-County Name';
            DataClassification = ToBeClassified;
        }
        field(85; "Selected Job"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Recruitment Needs"."No.";
        }
        field(86; IdOrPassport; BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(87; IdOrPassportName; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Id Or Passport Name';
        }
        field(88; "No."; Code[20])
        {
            NotBlank = false;

            trigger OnValidate()
            begin
                /*if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Applicants Nos.");
                    "No. Series" := '';
                end;*/

                if "No." = '' then begin
                    HumanResSetup.Get;
                    HumanResSetup.TestField(HumanResSetup."Applicants Nos.");
                    "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Applicants Nos.");
                end;
            end;
        }
        field(89; "Is Active Staff"; Boolean)
        {
            CalcFormula = exist("Employee" WHERE("ID Number" = FIELD("ID Number"), "ID Number" = FILTER(<> ''), Status = CONST(Active)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Email Address")
        {
            Clustered = true;
        }
        key(Key2; "No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "First Name", "Middle Name", "Last Name")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Applicants Nos.");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Applicants Nos.");
        end;
        // "Application Date":=TODAY;
    end;

    trigger OnModify()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Applicants Nos.");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Applicants Nos.");
        end;
        // "Application Date":=TODAY;
    end;

    var
        Counties: Record County;
        SubCounties: Record "Sub County";
        Needs: Record "Recruitment Needs";
        Employee: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        EmpQualifications: Record "Employee Qualification";
        AppQualifications: Record "Applicants Qualification";
        Applicant: Record "HR Online Applicant";//"Job Applicants";
        Emp: Record Employee;
        Dates: Codeunit "HR Dates";

    procedure EmployApplicant(var Applicants: Record "Job Applications"; var JobApplied: Code[30]; var Description: Text[100]; var JOBID: Code[60]) EmpNo: Code[100]
    var
        Employee: Record Employee;
    begin
        EmpNo := '';
        Employee.Reset();
        Employee.Init();
        Employee."No." := '';
        Employee."First Name" := Applicants."First Name";
        Employee."Middle Name" := Applicants."Middle Name";
        Employee."Last Name" := Applicants."Last Name";
        Employee."Search Name" := Applicants."First Name" + ' ' + Applicants."Middle Name" + ' ' + Applicants."Last Name";
        Employee."Postal Address" := Applicants."Postal Address";
        Employee."Residential Address" := Applicants."Residential Address";
        Employee."Post Code" := Applicants."Post Code";
        Employee.County := Applicants."County Name";
        Employee."Home Phone Number" := Applicants."Home Phone Number";
        Employee."Cellular Phone Number" := Applicants."Cellular Phone Number";
        Employee."Work Phone Number" := Applicants."Work Phone Number";
        Employee."E-Mail" := Applicants."Applicant Email";
        Employee."ID Number" := Applicants."ID No./Passport No.";
        Employee.Gender := Applicants.Gender;
        Employee."Country/Region Code" := Applicants.Country;
        //Employee."Fax Number":=Applicants."Fax Number";
        Employee."Marital Status" := Applicants."Marital Status";
        //Employee."Driving Licence":=Applicants."Driving Licence";
        Employee."Date Of Birth" := Applicants."Birth Date";
        //Employee.Age:=Applicants.Age;
        //Employee."Postal Address2":=Applicants."Postal Address2";
        //Employee."Postal Address3":=Applicants."Postal Address3";
        Employee."Residential Address2" := Applicants."Postal Address";
        //Employee."Residential Address3":=Applicants."Residential Address3";
        Employee."Post Code2" := Applicants."Post Code";
        //Employee.Citizenship:=Applicants.Citizenship;
        Employee."Passport Number" := Applicants."ID No./Passport No.";
        //Employee."PIN Number":=Applicants."PIN Number";
        Employee.Position := Applicants."Job Applied For";
        //Employee."Global Dimension 1 Code" := JobApplied;
        Employee."Job Title" := Applicants.JobDescription;//JOBID;
        //Employee.Position:=Description;
        Employee."Country/Region Code" := Applicants.Country;
        Employee.Insert(true);
        //IF Employee.INSERT=TRUE THEN BEGIN

        EmpNo := Employee."No.";
        Message('Employee Number %1 Successfully Created', Employee."No.");
        // END;
        exit(EmpNo);
    end;
}