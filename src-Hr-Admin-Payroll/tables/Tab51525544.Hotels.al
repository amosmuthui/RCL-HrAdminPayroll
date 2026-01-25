table 51525544 Hotels
{
    Caption = 'Hotels';
    DataClassification = ToBeClassified;
    LookupPageId = Hotels;
    DrillDownPageId = Hotels;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; "Country Code"; Code[10])
        {
            Caption = 'Country';
            TableRelation = "Country/Region".Code;

            trigger OnValidate()
            begin
                "Country Name" := '';
                if "Country Code" <> '' then begin
                    if CountryRegions.Get("Country Code") then
                        "Country Name" := CountryRegions.Name;
                end;
            end;
        }
        field(4; City; Text[30])
        {
            Caption = 'City';
            TableRelation = "Post Code".City where("Country/Region Code" = field("Country Code"));
        }
        field(5; Address; Text[250])
        {
            Caption = 'Address';
        }
        field(6; "E-Mail"; Text[250])
        {
            Caption = 'E-Mail';
        }
        field(7; "Contact Person Name"; Text[250])
        {
            Caption = 'Contact Person Name';
        }
        field(8; "Contact Person E-Mail"; Text[250])
        {
            Caption = 'Contact Person E-Mail';
        }
        field(9; "Contact Person Phone"; Text[30])
        {
            Caption = 'Contact Person Phone';
        }
        field(10; Block; Boolean)
        {
            Caption = 'Block';
        }
        field(11; "Country Name"; Text[50])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    var
        Requests: Record "Hotel Booking Requests";
        CountryRegions: Record "Country/Region";

    trigger OnDelete()
    begin
        Requests.Reset();
        Requests.SetRange("Hotel Code", Code);
        if Requests.FindLast() then
            Error('You cannot delete this hotel since it has booking requests!');
    end;
}
