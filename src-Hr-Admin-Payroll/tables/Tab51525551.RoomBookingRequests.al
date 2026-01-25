table 51525551 "Room Booking Requests"
{
    Caption = 'Room Booking Requests';
    DataClassification = ToBeClassified;
    LookupPageId = "Room Booking Requests";
    DrillDownPageId = "Room Booking Requests";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Requested By Emp No."; Code[20])
        {
            Caption = 'Requested By Emp No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Requested By Emp Name" := '';
                if "Requested By Emp No." <> '' then begin
                    if Emp.Get("Requested By Emp No.") then begin
                        "Requested By Emp Name" := Emp.FullName();
                    end;
                end;
            end;
        }
        field(3; "Requested By Emp Name"; Text[250])
        {
            Editable = false;
            Caption = 'Requested By Emp Name';
        }
        field(4; "Room No."; Code[20])
        {
            Caption = 'Room No.';
            TableRelation = Rooms where(Blocked = const(false));

            trigger OnValidate()
            begin
                CheckRoomAvailability();
                "Name/Tag" := '';
                if "Room No." <> '' then begin
                    if Rooms.Get("Room No.") then
                        "Name/Tag" := Rooms."Name/Tag";
                end;
            end;
        }
        field(5; "Name/Tag"; Text[100])
        {
            Editable = false;
            Caption = 'Name/Tag';
        }
        field(6; "From DateTime"; DateTime)
        {
            Caption = 'From DateTime';

            trigger OnValidate()
            begin
                CheckRoomAvailability();
            end;
        }
        field(7; "To DateTime"; DateTime)
        {
            Caption = 'To DateTime';

            trigger OnValidate()
            begin
                CheckRoomAvailability();
                ;
            end;
        }
        field(8; "Intended Users Description"; Text[100])
        {
            Caption = 'Intended Users Description';
        }
        field(9; "No. of Users"; Integer)
        {
            Caption = 'No. of Users';
            MinValue = 1;
        }
        field(10; Purpose; Text[250])
        {
            Caption = 'Purpose';
        }
        field(11; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;
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
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            if HumanResSetup."Room Booking Nos" = '' then begin
                HumanResSetup."Room Booking Nos" := 'RMREQ';
                if BaseFactory.CreateNoSeries('', HumanResSetup."Room Booking Nos", 'Room booking request numbers', 'RMREQ00001') then
                    HumanResSetup.Modify();
            end;
            HumanResSetup.TestField("Room Booking Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Room Booking Nos");
        end;
    end;

    var
        Emp: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        BaseFactory: Codeunit Factory;
        Rooms: Record Rooms;
        RoomBookings: Record "Room Booking Requests";

    procedure ValidateDateTimes(): Boolean
    begin
        if ("From DateTime" <> CreateDateTime(0D, 0T)) and ("To DateTime" <> CreateDateTime(0D, 0T)) then begin
            if "From DateTime" > "To DateTime" then
                Error('Please ensure the "From DateTime" is earlier than the "To DateTime"!')
            else
                exit(true);
        end else
            exit(false);
    end;

    procedure CheckRoomAvailability()
    begin

        if ValidateDateTimes() then begin
            if "Room No." = '' then
                exit;

            RoomBookings.Reset();
            RoomBookings.SetRange("Room No.", Rec."Room No.");
            RoomBookings.SetFilter("Approval Status", '%1|%2', RoomBookings."Approval Status"::"Pending Approval", RoomBookings."Approval Status"::Released);
            RoomBookings.SetFilter("From DateTime", '<=%1', "To DateTime");
            RoomBookings.SetFilter("To DateTime", '>=%1', "From DateTime");
            RoomBookings.SetFilter("No.", '<>%1', "No.");
            if RoomBookings.Find('-') then
                Error('There is a conflicting booking for this room. Booking No. runs from %1 to %2', RoomBookings."From DateTime", RoomBookings."To DateTime");
        end;
    end;
}
