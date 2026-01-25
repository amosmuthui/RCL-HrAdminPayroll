table 51525491 "Additional Entitled To"
{
    Caption = 'Additional Entitled To';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Header No."; Code[50])
        {
            Caption = 'Header No.';
        }
        field(3; "Action"; Option)
        {
            Caption = 'Action';
            OptionMembers = "Add",Less;

            trigger OnValidate()
            begin
                Validate("No. of Days");
            end;
        }
        field(4; "No. of Days"; Integer)
        {
            Caption = 'No. of Days';

            trigger OnValidate()
            begin
                if "No. of Days" <> 0 then begin
                    if Action = Rec.Action::Add then
                        "No. of Days" := Abs("No. of Days")
                    else
                        "No. of Days" := -Abs("No. of Days");
                end;
            end;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(6; "Divide By"; Option)
        {
            Caption = 'Divide By';
            OptionMembers = "Actual Month Days","30 Days";
        }
    }
    keys
    {
        key(PK; "Entry No.", "Header No.")
        {
            Clustered = true;
        }
    }
}