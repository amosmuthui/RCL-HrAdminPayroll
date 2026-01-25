table 51525556 "Accident / Incident Logs Manag"
{
    Caption = 'Accident / Incident Logs Manag';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Number"; Code[100])
        {
            Caption = 'Document Number';
        }
        field(2; "Reporting Party "; Code[100])
        {
            Caption = 'Reporting Party ';
            TableRelation = Employee."No.";
        }
        field(3; "Reporting Party Name"; Text[1000])
        {
            Caption = 'Reporting Party Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Reporting Party ")));
            Editable = false;
        }
        field(4; "Location of Incident"; Text[100])
        {
            Caption = 'Location of Incident';
        }
        field(5; "Date of Incident"; Date)
        {
            Caption = 'Date of Incident';
        }
        field(6; "Time of Incident"; Time)
        {
            Caption = 'Time of Incident';
        }
        field(7; "Incident Description"; Text[2000])
        {
            Caption = 'Incident Description';
        }
        field(8; "Corrective Action Taken"; Text[2000])
        {
            Caption = 'Immediate Corrective Action Taken';
        }
        field(9; "Follow-up or investigations"; Text[2000])
        {
            Caption = 'Follow-up actions or investigations';
        }
    }
    keys
    {
        key(PK; "Document Number")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Document Number" = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Accident / Incident");
            "Document Number" := NoSeriesMgt.GetNextNo(HumanResSetup."Accident / Incident");
        end;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
}
