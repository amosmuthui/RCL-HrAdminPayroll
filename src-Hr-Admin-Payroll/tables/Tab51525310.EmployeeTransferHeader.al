table 51525310 "Employee Transfer Header"
{

    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Effective Transfer Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Released';
            OptionMembers = Open,"Pending Approval",Released;
        }
        field(5; "User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(6; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
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
        "User Id" := UserId;
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Employee Transfer Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Employee Transfer Nos");
        end;
        "Date Created" := Today;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
}