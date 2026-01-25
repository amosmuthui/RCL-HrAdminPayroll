table 51525545 "Hotel Booking Requests"
{
    Caption = 'Hotel Booking Requests';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Hotel Booking Requests";
    LookupPageId = "Hotel Booking Requests";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Requested By Emp No."; Code[20])
        {
            Caption = 'Requested By Emp No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                "Requested By Emp Name" := '';
                if "Requested By Emp No." <> '' then begin
                    if Emp.Get("Requested By Emp No.") then begin
                        "Requested By Emp Name" := Emp.FullName();
                    end;
                end;
            end;
        }
        field(3; "Requested By Emp Name"; Text[250])
        {
            Editable = false;
            Caption = 'Requested By Emp Name';
        }
        field(4; "Country Code"; Code[10])
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
        field(5; "Hotel Code"; Code[50])
        {
            Caption = 'Hotel Code';
            TableRelation = Hotels.Code where("Country Code" = field("Country Code"), Block = const(false));

            trigger OnValidate()
            begin
                "Hotel Name" := '';
                if "Hotel Code" <> '' then begin
                    if hotels.Get("Hotel Code") then
                        "Hotel Name" := hotels.Name;
                end;
            end;
        }
        field(6; "Hotel Name"; Text[250])
        {
            Editable = false;
            Caption = 'Hotel Name';
        }
        field(7; "Check-in Date"; Date)
        {
            Caption = 'Check-in Date';

            trigger OnValidate()
            begin
                if "Check-in Date" <> 0D then
                    if "Check-out Date" <> 0D then
                        if "Check-in Date" > "Check-out Date" then
                            Error('Check-in Date should be earlier or equal to Check-out Date!');
            end;
        }
        field(8; "Check-out Date"; Date)
        {
            Caption = 'Check-out Date';

            trigger OnValidate()
            begin
                if "Check-out Date" <> 0D then
                    if "Check-in Date" <> 0D then
                        if "Check-in Date" > "Check-out Date" then
                            Error('Check-out Date should be later or equal to Check-in Date!');
            end;
        }
        field(9; Purpose; Text[250])
        {
            Caption = 'Purpose';
        }
        field(10; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;
        }
        field(11; "Reservation Status"; Option)
        {
            Caption = 'Reservation Status';
            Editable = false;
            OptionCaption = 'Pending,Reserved,Cancelled';
            OptionMembers = Pending,Reserved,Cancelled;
        }
        field(12; "No. of Travelers"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Hotel Booking Lines" where("Request No." = field("No.")));
        }
        field(13; "Reservation Email Sent"; Boolean)
        {
            Editable = false;
        }
        field(14; "Cancellation Email Sent"; Boolean)
        {
            Editable = false;
        }
        field(15; "Country Name"; Text[50])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        Emp: Record Employee;
        hotels: Record Hotels;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit "No. Series";
        BaseFactory: Codeunit Factory;
        CountryRegions: Record "Country/Region";


    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            if HumanResSetup."Hotel Request Nos" = '' then begin
                HumanResSetup."Hotel Request Nos" := 'HOTREQ';
                if BaseFactory.CreateNoSeries('', HumanResSetup."Hotel Request Nos", 'Hotel request numbers', 'HOTREQ00001') then
                    HumanResSetup.Modify();
            end;
            HumanResSetup.TestField("Hotel Request Nos");
            "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Hotel Request Nos");
        end;
    end;
}
