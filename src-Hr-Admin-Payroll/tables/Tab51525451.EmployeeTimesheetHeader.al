table 51525451 "Employee Timesheet Header"
{
    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Timesheet Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                checkifcurrentmonthandyearexists("Timesheet Start Date");
                Dates.Reset;
                Dates.SetRange("Period Type", Dates."Period Type"::Month);
                Dates.SetRange("Period Start", "Timesheet Start Date");
                if Dates.FindFirst then begin
                    "Timesheet End Date" := Dates."Period End";
                    Month := Dates."Period Name";
                    Year := Format(Date2DMY("Timesheet Start Date", 3));
                end;
                //ERROR('Timesheet start date must be at the begining of the month!');
            end;
        }
        field(3; Month; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
        field(7; Year; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Timesheet End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
            HumanResSetup.TestField("Employee Timesheet No's");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Employee Timesheet No's");
        end;
        "Date Created" := Today;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Dates: Record Date;

    local procedure checkifcurrentmonthandyearexists(TSSStartDate: Date)
    var
        ETSHeader: Record "Employee Timesheet Header";
    begin
        ETSHeader.Reset;
        ETSHeader.SetRange("Timesheet Start Date", TSSStartDate);
        if ETSHeader.FindFirst then Error('Timesheet for the current month has been created. You can view or edit the existing one or select another period to proceed!');
    end;
}