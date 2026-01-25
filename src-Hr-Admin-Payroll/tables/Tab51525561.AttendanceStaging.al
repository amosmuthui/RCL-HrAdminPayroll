table 51525561 "Attendance Staging"
{

    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Employee No."; Code[20]) { }
        field(3; "Employee Name"; Text[100]) { }
        field(4; "Log Date"; Date) { }
        field(5; "Log In Time"; Time) { }
        field(6; "Log Out Time"; Time) { }
        field(7; "Device ID"; Code[20]) { }
        field(8; Processed; Boolean) { }
        field(9; "Created DateTime"; DateTime) { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}

