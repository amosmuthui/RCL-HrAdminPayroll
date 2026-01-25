table 51525308 "Airtime Allocation Batches"
{
    Caption = 'Airtime Allocation Batches';
    DataClassification = ToBeClassified;
    LookupPageId = "Airtime Allocation Batches";
    DrillDownPageId = "Airtime Allocation Batches";

    fields
    {
        field(1; "Month Start Date"; Date)
        {
            Caption = 'Date';
            Editable = false;

            trigger OnValidate()
            begin
                if "Month Start Date" <> 0D then
                    Description := Format("Month Start Date", 0, '<Day,2> <Month Text> <Year4>');
                "Doc No" := Format("Month Start Date");
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(4; "Service Provider"; Code[20])
        {
            TableRelation = "Airtime Service Providers";
        }
        field(5; "Sent to Vendor"; Boolean)
        {
            Editable = false;
        }
        field(6; "DateTime Sent to Vendor"; DateTime)
        {
            Editable = false;
        }
        field(7; "Sent to Vendor By"; Code[50])
        {
            TableRelation = "User Setup";
            Editable = false;
        }
        field(8; "New Month"; Boolean)
        {
            Editable = false;
        }

        field(9; "Approval Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;
        }
        field(10; "Doc No"; Code[20])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Month Start Date")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        AirtimeAllocations: Record "Airtime Allocations";
    begin
        if "Approval Status" <> "Approval Status"::Open then
            Error('You cannot delete this record at this stage.');

        AirtimeAllocations.Reset();
        AirtimeAllocations.SetRange(Period, Rec."Month Start Date");
        if AirtimeAllocations.Find('-') then begin
            if not Confirm('Existing allocations will be deleted. Do you still wish to proceed?') then
                Error('Deletion aborted!');

            AirtimeAllocations.DeleteAll();
        end;
    end;
}
