table 51525555 "Transport Requisition"
{
    Caption = 'Transport Requisition';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Document No."; Code[100])
        {
            Caption = 'Document No.';
        }
        field(2; "Employee Requesting"; Code[100])
        {
            Caption = 'Employee Requesting';
        }
        field(3; "Employee Name"; Text[200])
        {
            Caption = 'Employee Name';
        }
        field(4; "Purpose of Travel"; Text[1000])
        {
            Caption = 'Purpose of Travel';
        }
        field(5; "Departure Date"; Date)
        {
            Caption = 'Departure Date';
        }
        field(6; "Return Date"; Date)
        {
            Caption = 'Return Date';
        }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
}
