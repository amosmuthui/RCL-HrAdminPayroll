table 51525549 "Refreshment Details"
{
    Caption = 'Refreshment Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Request No."; Code[20])
        {
            Caption = 'Request No.';
            Editable = false;
            TableRelation = "Refreshment Requests"."No.";
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(3; "Type Code"; Code[50])
        {
            Caption = 'Type Code';
            TableRelation = "Refreshment Types";

            trigger OnValidate()
            var
                RefreshmentTypes: Record "Refreshment Types";
            begin
                "Type Description" := '';
                if "Type Code" <> '' then begin
                    if RefreshmentTypes.Get("Type Code") then
                        "Type Description" := RefreshmentTypes.Description;
                end;
            end;
        }
        field(4; "Type Description"; Text[250])
        {
            Caption = 'Type Description';
            Editable = false;
        }
        field(5; "Additional Info"; Text[250])
        {
            Caption = 'Additional Info';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            MinValue = 0;
        }
    }
    keys
    {
        key(PK; "Request No.", "Entry No.")
        {
            Clustered = true;
        }
    }
}
