table 51525424 "PAYE Employee Exemption"
{
    fields
    {
        field(1; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Amount Exempted"; Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(5; "Exemption Reference"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Create Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Create UserID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Disability Type"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Disability Type"."Disability Code";
        }
        field(9; "Disability Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}