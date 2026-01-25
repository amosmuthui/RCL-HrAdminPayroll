table 51525564 "Memo Lines"
{
    Caption = 'Memo Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Doc No"; Code[100])
        {
            Caption = 'Doc No';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(3; "Activity Description"; Text[200])
        {
            Caption = 'Activity Description';
        }
        field(4; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(5; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(6; Venue; text[100])
        {

        }
    }
    keys
    {
        key(PK; "Doc No", "Line No")
        {
            Clustered = true;
        }
    }
}
