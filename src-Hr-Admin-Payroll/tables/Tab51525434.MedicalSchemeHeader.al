table 51525434 "Medical Scheme Header"
{
    DrillDownPageID = "Job Responsibilties List";
    LookupPageID = "Job Responsibilties List";

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Selection Date"; Date)
        {
        }
        field(3; "Cover Type"; Option)
        {
            OptionMembers = " ","In House",Outsourced;
        }
        field(4; "Service Provider"; Code[10])
        {
            TableRelation = "Medical Cover Types"."Name of Provider" WHERE(Type = FIELD("Cover Type"));
        }
        field(5; "Name of Broker"; Text[30])
        {
        }
        field(6; "Policy No"; Code[20])
        {
        }
        field(7; "Policy Start Date"; Date)
        {

            trigger OnValidate()
            begin
                "Policy Expiry Date" := CalcDate('1Y', "Policy Start Date") - 1;
            end;
        }
        field(8; "Policy Expiry Date"; Date)
        {
        }
        field(9; "Employee No"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                MedScheme.Reset;
                MedScheme.SetFilter("Employee No", "Employee No");
                MedScheme.SetFilter("Fiscal Year", "Fiscal Year");
                /*IF MedScheme.FINDSET THEN BEGIN
                   ERROR('This Employee Already has Cover for this Fiscal Year!!');
                END*/

                if EmpRec.Get("Employee No") then begin
                    "Employee Name" := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
                    //"Blood Type":=EmpRec."Blood Type";
                    Gender := Gender::" ";
                    if EmpRec.Gender = EmpRec.Gender::Female then
                        Gender := Gender::Female;
                    if EmpRec.Gender = EmpRec.Gender::Male then
                        Gender := Gender::Male;

                    //Gender := EmpRec.Gender;
                    "Salary Scale" := EmpRec."Salary Scale";
                    if SalaryScales.Get(EmpRec."Salary Scale") then
                        "Entitlement -Inpatient" := SalaryScales."In Patient Limit";
                    "Entitlement -OutPatient" := SalaryScales."Out Patient Limit";
                end;


                MedLines.Init;
                MedLines."Medical Scheme No" := "No.";
                MedLines.Validate("Medical Scheme No");
                MedLines."Line No." := MedLines."Line No." + 10000;
                MedLines."Employee Code" := "Employee No";
                MedLines.Relationship := 'EMPLOYEE';

                if EmpRec.Get("Employee No") then
                    MedLines."Date Of Birth" := EmpRec."Date Of Birth";
                MedLines.SurName := EmpRec."Last Name";
                MedLines."Other Names" := EmpRec."First Name";
                MedLines."Service Provider" := "Service Provider";
                //HANDLE THE ERROR INCURED FROM EXISITIN RECORDS BY ISAAC
                if MedLines.Insert then begin
                    ;
                end else
                    MedLines.Modify;
                //END
                if not MedLines.Get(MedLines."Medical Scheme No", MedLines."Line No.") then begin

                    Dependants.Reset;
                    Dependants.SetRange(Dependants."Employee Code", "Employee No");
                    if Dependants.Find('-') then
                        repeat
                            MedLines.Init;
                            MedLines."Medical Scheme No" := "No.";
                            MedLines.Validate("Medical Scheme No");
                            MedLines."Line No." := MedLines."Line No." + 10000;
                            MedLines."Employee Code" := "Employee No";
                            MedLines.Relationship := Dependants.Relationship;
                            MedLines.SurName := Dependants.SurName;
                            MedLines."Other Names" := Dependants."Other Names";

                            if EmpRec.Get("Employee No") then
                                // MedLines."Date Of Birth":=EmpRec."Date Of Birth";

                                MedLines."Date Of Birth" := Dependants."Date Of Birth";
                            MedLines."Service Provider" := "Service Provider";

                            if not MedLines.Get(MedLines."Medical Scheme No", MedLines."Line No.") then
                                //HANDLE THE ERROR INCURED FROM EXISITIN RECORDS BY ISAAC

                                if MedLines.Insert then begin
                                    ;
                                end else
                                    MedLines.Modify;
                        //END
                        until Dependants.Next = 0;
                end;

            end;
        }
        field(10; "Employee Name"; Text[50])
        {
        }
        field(11; "Entitlement -Inpatient"; Decimal)
        {
        }
        field(12; "Entitlement -OutPatient"; Decimal)
        {
        }
        field(13; "Fiscal Year"; Code[10])
        {
            TableRelation = "G/L Budget Name";
        }
        field(14; "No. Of Lives"; Integer)
        {
            CalcFormula = Count("Medical Scheme Lines" WHERE("Medical Scheme No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(15; "No. Series"; Code[10])
        {
        }
        field(16; "Cover Selected"; Code[20])
        {
            TableRelation = "Medical Cover Types" WHERE(Type = FIELD("Cover Type"));

            trigger OnValidate()
            begin
                Validate("Employee No");
            end;
        }
        field(17; "In-Patient Claims"; Decimal)
        {
            CalcFormula = Sum("Claim Line"."Approved Amount" WHERE("Employee No" = FIELD("Employee No"),
                                                                    "Claim Type" = CONST("In Patient")));
            FieldClass = FlowField;
        }
        field(18; "Out-Patient Claims"; Decimal)
        {
            CalcFormula = Sum("Claim Line"."Approved Amount" WHERE("Employee No" = FIELD("Employee No"),
                                                                    "Claim Type" = CONST("Out Patient"),
                                                                    "Policy Start Date" = FIELD("Policy Start Date")));
            FieldClass = FlowField;
        }
        field(19; "User ID"; Code[80])
        {
        }
        field(20; "Blood Type"; Code[10])
        {
        }
        field(21; "Date of Birth"; Date)
        {
        }
        field(22; "Salary Scale"; Code[20])
        {
            TableRelation = "Salary Scales".Scale;
        }
        field(23; Gender; Option)
        {
            OptionMembers = " ",Female,Male;
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
            HumanResSetup.TestField(HumanResSetup."Cover Selection Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Cover Selection Nos");
        end;

        "User ID" := UserId;

        "Selection Date" := Today;
        AcctPeriod.Reset;
        AcctPeriod.SetRange(AcctPeriod."Starting Date", 0D, Today);
        AcctPeriod.SetRange(AcctPeriod."New Fiscal Year", true);
        if AcctPeriod.Find('+') then begin
            "Policy Start Date" := AcctPeriod."Starting Date";
            "Policy Expiry Date" := CalcDate('1Y', AcctPeriod."Starting Date") - 1;
        end;
        "Cover Type" := "Cover Type"::Outsourced;


        GLSetup.Reset;
        GLSetup.Get;
        "Fiscal Year" := GLSetup."Current Budget";


        /*
        MedScheme.RESET;
        MedScheme.SETRANGE(MedScheme."Employee No","Employee No");
        MedScheme.SETRANGE(MedScheme."Policy Start Date","Policy Start Date");
        IF MedScheme.FIND('-') THEN
        ERROR('You have already selected your cover for the current year');
        */

    end;

    var
        MedLines: Record "Medical Scheme Lines";
        Dependants: Record "Employee Beneficiaries";
        EmpRec: Record Employee;
        UserRec: Record "User Setup";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        SalaryScales: Record "Salary Scales";
        MedScheme: Record "Medical Scheme Header";
        AcctPeriod: Record "Accounting Period";
        GLSetup: Record "General Ledger Setup";
}