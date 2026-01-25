table 51525558 "Memo Header"
{
    Caption = 'Memo Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[200])
        {
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                Emp.SetRange("User ID", UserId);
                Emp.Get(UserId);
                Rec."Requestor User ID" := Emp."No.";
            end;
        }
        field(2; "Requestor User ID"; Code[50])
        {
            DataClassification = CustomerContent;
            //  TableRelation = Employee."No.";

            Editable = false;
        }
        field(3; "Requestor Name"; Text[100])
        {
            //DataClassification = CustomerContent;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Full Name" where("No." = field("Requestor User ID")));
        }
        field(4; "Department Code"; Code[200])
        {
            DataClassification = CustomerContent;
            Editable = false;
            //  TableRelation = "Dimension Value".Name where("Global Dimension No." = const(1));
        }
        field(5; "Purpose"; Text[250])
        {
            DataClassification = CustomerContent;

        }
        field(6; "Activity Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';
        }
        field(7; "Start Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(8; "End Time"; Time)
        {
            DataClassification = CustomerContent;
        }
        field(9; "Venue"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Employees Involved"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;

        }
        field(12; "Created Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(13; "End Date"; Date)
        {

        }
        field(14; posted; Boolean)
        {

        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        empl: Record Employee;
    begin
        if "No." = '' then
            HumanResSetup.Get;
        HumanResSetup.TestField(HumanResSetup."Memo Nos");
        "No." := NoSeriesManagement.GetNextNo(HumanResSetup."Memo Nos");


        //"Requestor User ID" := UserId;
        //  if "User ID" = '' then
        //   "User ID" := UserId;

        empl.Reset();
        empl.SetRange("User ID", UserId);
        if (empl.FindFirst) then begin
            "Requestor User ID" := empl."No.";
            "Department Code" := empl."Responsibility Center";
            //Validate(Directorate);
            Validate("Department Code");
            "Created Date" := Today;
            "Approval Status" := "Approval Status"::Released;
        end;
    end;

    var
        NoSeriesManagement: Codeunit "No. Series";
        HumanResSetup: Record "Human Resources Setup";
        UserSetup: Record "User Setup";
        Emp: Record Employee;
}