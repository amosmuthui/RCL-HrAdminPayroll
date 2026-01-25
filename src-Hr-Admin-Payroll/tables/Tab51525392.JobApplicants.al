table 51525392 "Job Applicants"
{
    Caption = 'Job Appliicant Profile';//'Employee';
    DrillDownPageID = "Applicants List";
    LookupPageID = "Applicants List";

    fields
    {
        field(1; "No."; Code[20])
        {
            NotBlank = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Applicants Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "First Name"; Text[80])
        {
        }
        field(3; "Middle Name"; Text[50])
        {
        }
        field(4; "Last Name"; Text[50])
        {

            trigger OnValidate()
            var
                Reason: Text[30];
            begin
            end;
        }
        field(5; Initials; Text[15])
        {
        }
        field(7; "Search Name"; Code[50])
        {
        }
        field(8; "Postal Address"; Text[80])
        {
        }
        field(9; "Residential Address"; Text[80])
        {
        }
        field(10; City; Text[30])
        {
        }
        field(11; "Post Code"; Code[20])
        {
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(12; County; Text[30])
        {
            TableRelation = County.Name;
        }
        field(13; "Home Phone Number"; Text[30])
        {
        }
        field(14; "Cellular Phone Number"; Text[30])
        {
        }
        field(15; "Work Phone Number"; Text[30])
        {
        }
        field(16; "Ext."; Text[7])
        {
        }
        field(17; "E-Mail"; Text[120])
        {
        }
        field(19; Picture; BLOB)
        {
            SubType = Bitmap;
        }
        field(20; "ID Number"; Text[30])
        {

            trigger OnValidate()
            begin
                Applicant.Reset;
                Applicant.SetRange(Applicant."ID Number", "ID Number");
                if Applicant.Find('-') then
                    Error('There is already a profile with a similar ID Number %1', "ID Number");

                Emp.Reset;
                Emp.SetRange("ID Number", "ID Number");
                if Emp.Find('-') then begin
                    Message('The Applicant has worked for the company before');
                    "Previous Employee" := true;
                end;
            end;
        }
        field(21; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(22; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(23; Status; Option)
        {
            OptionMembers = Normal,Resigned,Discharged,Retrenched,Pension,Disabled;
        }
        field(24; Comment; Boolean)
        {
            CalcFormula = Exist("HR Human Resource Comments" WHERE("Table Name" = CONST(Employee),
                                                                    "No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Fax Number"; Text[30])
        {
        }
        field(26; "Marital Status"; Option)
        {
            OptionMembers = " ",Single,Married,Separated,Divorced,"Widow(er)",Other;
        }
        field(27; "Ethnic Origin"; Code[30])
        {
            TableRelation = "Ethnic Groups";
        }
        field(29; "Driving Licence"; Code[10])
        {
        }
        field(30; Disabled; Option)
        {
            OptionCaption = ' ,No,Yes';
            OptionMembers = " ",No,Yes;
        }
        field(31; "Health Assesment"; Boolean)
        {
        }
        field(32; "Health Assesment Date"; Date)
        {
        }
        field(33; "Date Of Birth"; Date)
        {

            trigger OnValidate()
            begin
                Age := Dates.DetermineAge("Date Of Birth", Today);
                Rec.Modify;
            end;
        }
        field(34; Age; Text[80])
        {
            Editable = false;
        }
        field(37; "Primary Skills Category"; Option)
        {
            OptionMembers = Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(40; "Postal Address2"; Text[30])
        {
        }
        field(41; "Postal Address3"; Text[20])
        {
        }
        field(42; "Residential Address2"; Text[30])
        {
        }
        field(43; "Residential Address3"; Text[20])
        {
        }
        field(44; "Post Code2"; Code[20])
        {
            TableRelation = "Post Code";
        }
        field(45; Citizenship; Code[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(46; "Disability Details"; Text[250])
        {
        }
        field(47; "Disability Grade"; Text[30])
        {
        }
        field(48; "Passport Number"; Text[30])
        {
        }
        field(49; "2nd Skills Category"; Option)
        {
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(50; "3rd Skills Category"; Option)
        {
            OptionMembers = " ",Auditors,Consultants,Training,Certification,Administration,Marketing,Management,"Business Development",Other;
        }
        field(51; Region; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(58; "PIN Number"; Code[20])
        {
        }
        field(63; Employ; Boolean)
        {
        }
        field(65; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(66; "Employee No"; Code[20])
        {
            TableRelation = Employee;

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
                AppQualifications."Qualification Type":=EmpQualifications."Qualification Type";
                AppQualifications."Qualification Code":=EmpQualifications."Qualification Code";
                AppQualifications."From Date":=EmpQualifications."From Date";
                AppQualifications."To Date":=EmpQualifications."To Date";
                AppQualifications.Type:=EmpQualifications.Type;
                AppQualifications.Description:=EmpQualifications.Description;
                AppQualifications."Institution/Company":=EmpQualifications."Institution/Company";
                //AppQualifications.CourseType:=EmpQualifications.CourseType;
                AppQualifications."Score ID":=EmpQualifications."Score ID";
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
            Editable = false;
            OptionCaption = 'External,Internal';
            OptionMembers = External,Internal;
        }
        field(68; DateEmployed; Date)
        {
        }
        field(69; "Previous Employee"; Boolean)
        {
        }
        field(50001; "Highest Level Education"; Option)
        {
            OptionCaption = ',PhD,Masters Degree,Bachelors Degree,Higher/Advance Diploma,Cerificate,High School';
            OptionMembers = ,PhD,"Masters Degree","Bachelors Degree","Higher/Advance Diploma",Cerificate,"High School";
        }
        field(50002; IsStaff; Boolean)
        {
            CalcFormula = Exist(Employee WHERE("ID Number" = FIELD("ID Number")));
            FieldClass = FlowField;
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

    var
        Needs: Record "Recruitment Needs";
        Employee: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        EmpQualifications: Record "Employee Qualification";
        AppQualifications: Record "Applicants Qualification";
        Applicant: Record "Job Applicants";
        Emp: Record Employee;
        Dates: Codeunit "HR Dates";


    procedure EmployApplicant(var Applicants: Record "HR Online Applicant" /*"Job Applications"*/; var JobApplied: Code[30]; var Description: Text[100]; var JOBID: Code[60]; ApplicationNo: Code[20]) EmpNo: Code[100]
    var
        Employee: Record Employee;
        ChangeRequest: Record "Change Request";
    begin
        EmpNo := '';
        /*Employee.Reset();
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
        Employee."E-Mail" := Applicants."Email Address";//."Applicant Email";
        Employee."ID Number" := Applicants."ID Number";//."ID No./Passport No.";
        Employee.Gender := Applicants.Gender;
        Employee."Country/Region Code" := Applicants.Country;
        //Employee."Fax Number":=Applicants."Fax Number";
        Employee."Marital Status" := Applicants."Marital Status";
        //Employee."Driving Licence":=Applicants."Driving Licence";
        Employee."Date Of Birth" := Applicants."Date Of Birth";//."Birth Date";
        //Employee.Age:=Applicants.Age;
        //Employee."Postal Address2":=Applicants."Postal Address2";
        //Employee."Postal Address3":=Applicants."Postal Address3";
        Employee."Residential Address2" := Applicants."Postal Address";
        //Employee."Residential Address3":=Applicants."Residential Address3";
        Employee."Post Code2" := Applicants."Post Code";
        //Employee.Citizenship:=Applicants.Citizenship;
        Employee."Passport Number" := Applicants.IdOrPassportName;//."ID No./Passport No.";
        //Employee."PIN Number":=Applicants."PIN Number";
        Employee.Position := JobApplied;//Applicants."Job Applied For";
        Employee.Validate(Position);
        //Employee."Global Dimension 1 Code" := JobApplied;
        Employee."Job Title" := Description;//Applicants.JobDescription;//JOBID;
        //Employee.Position:=Description;
        Employee."Country/Region Code" := Applicants.Country;
        Employee.Insert(true);
        //IF Employee.INSERT=TRUE THEN BEGIN

        //Copy Attachments

        EmpNo := Employee."No.";
        Message('Employee Number %1 Successfully Created', Employee."No.");*/
        // END;

        ChangeRequest.Reset();
        ChangeRequest.Init();
        ChangeRequest."No." := '';
        ChangeRequest."First Name" := Applicants."First Name";
        ChangeRequest."Middle Name" := Applicants."Middle Name";
        ChangeRequest."Last Name" := Applicants."Last Name";
        ChangeRequest."Search Name" := Applicants."First Name" + ' ' + Applicants."Middle Name" + ' ' + Applicants."Last Name";
        ChangeRequest."Postal Address" := Applicants."Postal Address";
        ChangeRequest."Residential Address" := Applicants."Residential Address";
        ChangeRequest."Post Code" := Applicants."Post Code";
        ChangeRequest.County := Applicants."County Name";
        ChangeRequest."Phone Number" := Applicants."Home Phone Number";
        ChangeRequest."Cellular Phone Number" := Applicants."Cellular Phone Number";
        ChangeRequest."Work Phone Number" := Applicants."Work Phone Number";
        ChangeRequest."Personal Email" := Applicants."Email Address";//."Applicant Email";
        ChangeRequest."ID Number" := Applicants."ID Number";//."ID No./Passport No.";
        ChangeRequest.Gender := Applicants.Gender;
        ChangeRequest."Country/Region Code" := Applicants.Country;
        ChangeRequest."Marital Status" := Applicants."Marital Status";
        ChangeRequest."Date Of Birth" := Applicants."Date Of Birth";//."Birth Date";
        //ChangeRequest."Residential Address2" := Applicants."Postal Address";
        //ChangeRequest."Post Code2" := Applicants."Post Code";
        ChangeRequest."Passport Number" := Applicants.IdOrPassportName;//."ID No./Passport No.";
        ChangeRequest.Position := JobApplied;//Applicants."Job Applied For";
        ChangeRequest.Validate(Position);
        ChangeRequest."Job Title" := Description;//Applicants.JobDescription;//JOBID;
        ChangeRequest."Country/Region Code" := Applicants.Country;
        ChangeRequest."Change Type" := ChangeRequest."Change Type"::Onboarding;
        ChangeRequest."Job Application No." := ApplicationNo;
        ChangeRequest."Summarized reasons for change" := 'New Staff';
        ChangeRequest.Insert(true);
        EmpNo := ChangeRequest."No.";
        Message('Employee Change Request Number %1 Successfully Created', EmpNo);
        exit(EmpNo);
    end;
}