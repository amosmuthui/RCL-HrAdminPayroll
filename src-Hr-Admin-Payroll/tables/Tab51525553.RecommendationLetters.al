table 51525553 "Recommendation Letters"
{
    Caption = 'Recommendation Letters';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Recommendation Letters";
    LookupPageId = "Recommendation Letters";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;

        }
        field(2; "Emp No."; Code[20])
        {
            Caption = 'Emp No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Emp Name" := '';
                if "Emp No." <> '' then begin
                    if Emp.Get("Emp No.") then begin
                        "Emp Name" := Emp.FullName();
                        "Position Code" := Emp.Position;
                        "Position Title" := Emp."PTH Job Title";
                        "Country Code" := Emp.Nationality;
                        if "Country Code" = '' then
                            "Country Code" := Emp."Country/Region Code";
                        Validate("Country Code");
                    end;
                end;
            end;
        }
        field(3; "Emp Name"; Text[250])
        {
            Editable = false;
            Caption = 'Emp Name';
        }
        field(4; "Position Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Company Jobs";
            Caption = 'Position Code';
        }
        field(5; "Position Title"; Text[250])
        {
            Editable = false;
            Caption = 'Position Title';
        }
        field(6; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            Caption = 'Country Code';

            trigger OnValidate()
            begin
                Nationality := '';
                if "Country Code" <> '' then begin
                    if Countries.Get("Country Code") then begin
                        Nationality := Countries.Name;
                        "Position Code" := Emp.Position;
                        "Position Title" := Emp."PTH Job Title";
                        if "Position Title" = '' then
                            "Position Title" := Emp."Job Title";
                    end;
                end;
            end;
        }
        field(7; Nationality; Text[50])
        {
            Editable = false;
            Caption = 'Nationality';
        }
        field(8; "Travel Details"; Text[250])
        {
            Caption = 'Travel Details';
        }
        field(9; "Template No"; Integer)
        {
            TableRelation = "Letter Templates";
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    var
        Emp: Record Employee;
        Countries: Record "Country/Region";
}
