table 51525550 Rooms
{
    Caption = 'Rooms';
    DataClassification = ToBeClassified;
    LookupPageId = Rooms;
    DrillDownPageId = Rooms;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Boardroom","Meeting Room";
        }
        field(3; "Name/Tag"; Text[100])
        {
            Caption = 'Name/Tag';
        }
        field(4; Location; Text[100])
        {
            Caption = 'Location';
        }
        field(5; Capacity; Integer)
        {
            Caption = 'Capacity';
            MinValue = 0;
        }
        field(6; Equipment; Text[250])
        {
            Caption = 'Equipment';
        }
        field(7; Blocked; Boolean)
        { }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Name/Tag")
        { }
    }



    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            if HumanResSetup."Room Nos" = '' then begin
                HumanResSetup."Room Nos" := 'RMN';
                if BaseFactory.CreateNoSeries('', HumanResSetup."Room Nos", 'Room numbers', 'RMN00001') then
                    HumanResSetup.Modify();
            end;
            HumanResSetup.TestField("Room Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Room Nos");
        end;
    end;

    trigger OnDelete()
    begin
        RoomBookings.Reset();
        RoomBookings.SetRange("Room No.", Rec."No.");
        if RoomBookings.Find('-') then
            Error('You cannot delete this room because it has bookings!');
    end;


    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        BaseFactory: Codeunit Factory;
        RoomBookings: Record "Room Booking Requests";

    procedure CurrentRoomStatus(): Text
    begin

    end;
}
