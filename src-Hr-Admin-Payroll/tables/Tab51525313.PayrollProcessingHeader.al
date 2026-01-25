table 51525313 "Payroll Processing Header"
{
    DrillDownPageID = "Payrol Processing list";
    LookupPageID = "Payrol Processing list";

    fields
    {
        field(1; "Payroll Processing No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Payroll Period"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Payroll Period"."Starting Date";
        }
        field(3; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Posted';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
        }
        field(4; "Date Processed"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Close Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Payroll Processing No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if "Payroll Processing No" = '' then begin
            Hrsetup.Get;
            Hrsetup.TestField(Hrsetup."Payroll Processing No.");
            "Payroll Processing No" := NoSeriesMgt.GetNextNo(Hrsetup."Payroll Processing No.");
        end;
        "User ID" := UserId;

        Periods.SetRange(Closed, false);
        if Periods.FindLast then
            "Payroll Period" := Periods."Starting Date";
    end;

    var
        Hrsetup: Record "Human Resources Setup";
        Periods: Record "Payroll Period";
}