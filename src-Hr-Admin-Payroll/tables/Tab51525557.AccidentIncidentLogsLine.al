table 51525557 "Accident / Incident Logs Line"
{
    Caption = '"Accident / Incident Logs Line';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "Doc. No."; Code[100])
        {
            Caption = 'Doc. No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Person Involved"; text[200])
        {
            Caption = 'Person Involved';
        }
        field(4; "Department"; Code[50])
        {

        }
    }
    keys
    {
        key(PK; "Doc. No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
