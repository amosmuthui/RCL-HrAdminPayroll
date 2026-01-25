table 51525562 "Attendance Ledger"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Employee No."; Code[20]) { TableRelation = Employee; }
        field(3; "Attendance Date"; Date) { }
        field(4; "First In Time"; Time) { }
        field(5; "Last Out Time"; Time) { }
        field(6; "Worked Hours"; Decimal) { }
        field(7; Status; Enum "Attendance Status") { }
        field(8; "Overtime Hours"; Decimal) { }
        field(9; Source; Enum "Attendance Source") { }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(EmployeeDate; "Employee No.", "Attendance Date") { }
    }
}
