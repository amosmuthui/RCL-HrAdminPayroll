table 51525435 "Medical Cover Types"
{
    DrillDownPageID = "Medical Cover List";
    LookupPageID = "Medical Cover List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Type; Option)
        {
            OptionMembers = "  ","In House",Outsourced;
        }
        field(4; Provider; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if vend.Get(Provider) then begin
                    "Name of Provider" := vend.Name;
                end;
            end;
        }
        field(5; "Name of Provider"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        vend: Record Vendor;
}