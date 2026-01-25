table 51525495 "Temp Leave Analysis Tbl"
{
    Caption = 'Leave Analysis';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Emp No."; Code[50])
        {
            Caption = 'Emp No.';
        }
        field(3; "Emp Name"; Text[240])
        {
            Caption = 'Emp Name';
        }
        field(4; Department; Text[240])
        {
            Caption = 'Department';
        }
        field(5; "Column Title"; Text[240])
        {
            Caption = 'Column Title';
        }
        field(6; "Column No."; Integer)
        {
            Caption = 'Column No.';
        }
        field(7; "Value"; Text[240])
        {
            Caption = 'Value';
        }
        field(8; UniqueRunTimeID; Code[240])
        {
            Caption = 'UniqueRunTimeID';
        }
        field(9; "Balance b/f"; Decimal)
        { }
        field(10; "Monthly Entitlement"; Decimal)
        { }
    }
    keys
    {
        key(PK; "Entry No.", "Emp No.")
        {
            Clustered = true;
        }
    }
}