table 51525319 "Brackets Lines"
{
    fields
    {
        field(1; "Tax Band"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Table Code"; Code[10])
        {
            TableRelation = "Bracket Tables";
        }
        field(4; "Lower Limit"; Decimal)
        {
        }
        field(5; "Upper Limit"; Decimal)
        {
        }
        field(6; Amount; Decimal)
        {
        }
        field(7; Percentage; Decimal)
        {
        }
        field(8; "From Date"; Date)
        {
        }
        field(9; "End Date"; Date)
        {
        }
        field(10; "Pay period"; Date)
        {
        }
        field(11; "Taxable Amount"; Decimal)
        {
        }
        field(12; "Total taxable"; Decimal)
        {
        }
        field(13; "Factor Without Housing"; Decimal)
        {
            DecimalPlaces = 2 :;
        }
        field(14; "Factor With Housing"; Decimal)
        {
            DecimalPlaces = 2 :;
        }
        field(15; Institution; Code[20])
        {
            TableRelation = Institution;
        }
        field(16; "Contribution Rates Inclusive"; Boolean)
        {
        }
        field(17; "Is Nhif"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Tier No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Extra Amount Formula"; Option)
        {
            DataClassification = ToBeClassified;

            OptionCaption = 'Deduct,Add,Multiply';
            OptionMembers = Deduct,"Add",Multiply;
        }
        field(20; "Extra Amount Value"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Tax Band", "Table Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}