table 51525436 "Medical Scheme Lines"
{
    //DrillDownPageID = "Employee Transfer Card";
    //LookupPageID = "Employee Transfer Card";

    fields
    {
        field(1; "Medical Scheme No"; Code[10])
        {

            trigger OnValidate()
            begin
                if Schemeheader1.Get("Medical Scheme No") then begin
                    "Fiscal Year" := Schemeheader1."Fiscal Year";
                    // MESSAGE('%1',"Fiscal Year");
                end;
            end;
        }
        field(2; "Employee Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee."No." WHERE(Status = FILTER(Active));
        }
        field(3; Relationship; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR Relative".Code;
        }
        field(4; SurName; Text[50])
        {
            NotBlank = true;
        }
        field(5; "Other Names"; Text[100])
        {
            NotBlank = true;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(6; "ID No/Passport No"; Text[50])
        {
        }
        field(7; "Date Of Birth"; Date)
        {
        }
        field(8; Occupation; Text[100])
        {
        }
        field(9; Address; Text[250])
        {
        }
        field(10; "Office Tel No"; Text[100])
        {
        }
        field(11; "Home Tel No"; Text[50])
        {
        }
        field(12; Remarks; Text[250])
        {
        }
        field(13; "Service Provider"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(14; "Fiscal Year"; Code[10])
        {
        }
        field(15; "Line No."; Integer)
        {
        }
        field(16; Gender; Option)
        {
            OptionMembers = " Male",Female;
        }
        field(17; "In-Patient Entitlement"; Decimal)
        {
        }
        field(18; "Out-Patient Entitlment"; Decimal)
        {
        }
        field(19; "Amount Spend (In-Patient)"; Decimal)
        {
        }
        field(20; "Amout Spend (Out-Patient)"; Decimal)
        {
        }
        field(21; "Policy Start Date"; Date)
        {
        }
        field(22; "Medical Cover Type"; Option)
        {
            OptionMembers = " ","In House",Outsourced;
        }
    }

    keys
    {
        key(Key1; "Medical Scheme No", "Line No.", "Other Names", "Employee Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Schemeheader1: Record "Medical Scheme Header";
}