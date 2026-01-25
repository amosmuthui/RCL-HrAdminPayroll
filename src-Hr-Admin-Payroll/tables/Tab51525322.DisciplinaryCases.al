table 51525322 "Disciplinary Cases"
{
    fields
    {
        field(1; "Case No"; Code[20])
        {
        }
        field(2; "Case Description"; Text[250])
        {
        }
        field(3; "Date of the Case"; Date)
        {

            trigger OnValidate()
            begin
                if "Date of the Case" > Today then
                    Error('Date of case cannot be greater than today');
            end;
        }
        field(4; "Offense Type"; Code[20])
        {
            TableRelation = "Disciplinary Offenses";

            trigger OnValidate()
            begin
                if offenserec.Get("Offense Type") then begin
                    "Offense Name" := offenserec.Description;
                end;
            end;
        }
        field(5; "Offense Name"; Text[100])
        {
        }
        field(6; "Employee No"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            var
                RespCenter: Record "Responsibility Center";
            begin
                if emprec.Get("Employee No") then begin
                    "Employee Name" := emprec."First Name" + ' ' + emprec."Middle Name" + ' ' + emprec."Last Name";
                    RespCenter.Reset;
                    RespCenter.SetFilter(RespCenter.Code, emprec."Responsibility Center");
                    if RespCenter.FindFirst() then begin
                        "HOD Name" := RespCenter."HoD Name";
                    end;
                    //get previous case
                    DisciplinaryCasesRec.Reset;
                    DisciplinaryCasesRec.SetRange(DisciplinaryCasesRec."Employee No", "Employee No");
                    if DisciplinaryCasesRec.FindLast then
                        "Previous Disciplinary Case" := DisciplinaryCasesRec."Offense Name";

                end;
                DisciplinaryCasesRec.Reset;
                DisciplinaryCasesRec.SetRange(DisciplinaryCasesRec."Employee No", "Employee No");
                DisciplinaryCasesRec.SetFilter(DisciplinaryCasesRec."Date of the Case", '%1..%2', CalcDate('<-1Y>', "Date of the Case"), "Date of the Case");
                if DisciplinaryCasesRec.FindSet then begin
                    repeat
                        PreviousCases.Init;
                        PreviousCases."Case No" := DisciplinaryCasesRec."Case No";
                        PreviousCases."Employee No" := DisciplinaryCasesRec."Employee No";
                        PreviousCases."Employee Name" := DisciplinaryCasesRec."Employee Name";
                        PreviousCases."Action Taken" := DisciplinaryCasesRec."Action Taken";
                        PreviousCases."Case Description" := DisciplinaryCasesRec."Case Description";
                        PreviousCases."Appeal Descision" := DisciplinaryCasesRec."Appeal Descision";
                        if not PreviousCases.Get(PreviousCases."Case No", PreviousCases."Employee No") then
                            PreviousCases.Insert(true)
                        else
                            PreviousCases.Modify;



                    until
                    DisciplinaryCasesRec.Next = 0;
                end;
            end;
        }
        field(7; "Employee Name"; Text[100])
        {
        }
        field(8; "Case Status"; Option)
        {
            OptionMembers = New,Ongoing,Appealed,Closed,Court,Ceo,Committee,Board;
        }
        field(9; "HOD Recommendation"; Text[200])
        {
        }
        field(10; "HR Recommendation"; Text[250])
        {
        }
        field(11; "Commitee Recommendation"; Text[250])
        {
        }
        field(12; "Action Taken"; Code[20])
        {
            TableRelation = "Disciplinary Actions".Code;
        }
        field(13; Appealed; Boolean)
        {
        }
        field(14; "Committee Recon After Appeal"; Text[250])
        {
        }
        field(15; "HOD File Path"; Text[100])
        {
        }
        field(16; "HR File Path"; Text[100])
        {
        }
        field(17; "Committe File Path"; Text[250])
        {
        }
        field(18; "Committee File-After Appeal"; Text[250])
        {
        }
        field(19; "No. series"; Code[10])
        {
        }
        field(20; "HOD Name"; Text[250])
        {
        }
        field(21; "No. of Appeals"; Integer)
        {
        }
        field(22; "CEO Recommendation"; Text[250])
        {
        }
        field(23; "Court's Decision"; Text[250])
        {
        }
        field(24; "Levels of Discipline"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Levels of Discipline".Description;
        }
        field(25; "Previous Disciplinary Case"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Board Recommendation"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Action Taken File Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Appeal Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Appeal Descision"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Disciplinary Actions".Code;
        }
    }

    keys
    {
        key(Key1; "Case No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Case No" = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Disciplinary Nos");
            "Case No" := NoSeriesMgt.GetNextNo(HumanResSetup."Disciplinary Nos");
        end;
    end;

    var
        emprec: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        offenserec: Record "Disciplinary Offenses";
        userrec: Record "User Setup";
        userrec2: Record "User Setup";
        DisciplinaryCasesRec: Record "Disciplinary Cases";
        PreviousCases: Record "Previous Cases";
}