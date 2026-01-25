table 51525559 "Shift Header"
{

    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20]) { Editable = false; }
        field(2; "Shift Start Date"; Date) { }
        field(10; "Shift End Date"; Date) { }
        field(3; "Shift Type"; Enum "Shift Type") { }
        field(4; "Supervisor User ID"; Code[50]) { }
        field(5; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;


        }
        field(6; Posted; Boolean) { }
        field(7; "Document Date"; Date)
        {

        }
        field(8; "Created by"; Text[100])
        {
            Editable = false;

        }
        field(9; Department; code[200])
        {
            Editable = false;

        }
        field(11; "Shift Department"; Code[100])
        {
            TableRelation = "Responsibility Center".Code;
        }


    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }

    trigger OnInsert()
    var
        empl: Record Employee;
    begin
        if "No." = '' then
            HumanResSetup.Get;
        HumanResSetup.TestField("Shift Nos");
        "No." := NoSeriesMgmt.GetNextNo(HumanResSetup."Shift Nos");


        "Supervisor User ID" := UserId;
        "Approval Status" := "Approval Status"::Open;

        empl.Reset();
        empl.SetRange("User ID", UserId);
        if (empl.FindFirst) then begin
            //"Requestor User ID" := empl."No.";
            "Department" := empl."Responsibility Center";
            "Created by" := empl."First Name" + empl."Middle Name" + empl."Last Name";
        end;
    end;


    var
        NoSeriesMgmt: Codeunit "No. Series";
        HumanResSetup: Record "Human Resources Setup";
}
