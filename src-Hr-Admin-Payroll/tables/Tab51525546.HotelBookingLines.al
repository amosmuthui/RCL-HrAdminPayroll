table 51525546 "Hotel Booking Lines"
{
    Caption = 'Hotel Booking Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Request No."; Code[20])
        {
            Caption = 'Request No.';
            Editable = false;
            TableRelation = "Hotel Booking Requests"."No.";
        }
        field(2; "Traveler No."; Code[20])
        {
            Caption = 'Traveler No.';
            TableRelation = if ("Traveler Category" = const(Employee)) Employee."No.";

            trigger OnValidate()
            begin
                if "Traveler Category" = "Traveler Category"::Employee then begin
                    if "Traveler No." <> '' then begin
                        if Emp.Get("Traveler No.") then begin
                            Name := Emp.FullName();
                            "Phone No." := Emp."Phone No.";
                        end;
                    end;
                end
            end;
        }
        field(3; "Traveler Category"; Option)
        {
            Caption = 'Traveler Category';
            OptionMembers = Employee,Other;
        }
        field(4; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(5; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(6; "Special Requirements"; Text[250])
        {
            Caption = 'Special Requirements';
        }
    }
    keys
    {
        key(PK; "Request No.", "Traveler No.")
        {
            Clustered = true;
        }
    }
    var
        Emp: Record Employee;
}
