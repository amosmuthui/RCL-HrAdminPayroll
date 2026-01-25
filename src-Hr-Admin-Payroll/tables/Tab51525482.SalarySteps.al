table 51525482 "Salary Steps"
{
    fields
    {
        field(1; "Step Code"; Code[20])
        {
        }
        field(2; Level; Option)
        {
            OptionMembers = "Level 1","Level 2";
        }
        field(3; "Category code"; Code[20])
        {
            //TableRelation = Table50036;
        }
        field(4; "Basic amount"; Decimal)
        {
        }
        field(5; Increment; Integer)
        {
        }
        field(6; "House allowance"; Decimal)
        {
        }
        field(7; "Standard overtime"; Decimal)
        {
        }
        field(8; "Duty allowance"; Decimal)
        {
        }
        field(9; "Personal allowance"; Decimal)
        {
        }
        field(10; "Perfomance allowance"; Decimal)
        {
        }
        field(11; "Gross pay"; Decimal)
        {
        }
        field(12; "House All. Code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(13; "Standard Overtime code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(14; "Duty Allowance code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(15; "Personal Allowance code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(16; "Performance Allowance code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(17; "Leave travel allowance code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(18; "Leave travel allowance"; Decimal)
        {
        }
        field(19; "Daily rate"; Decimal)
        {
        }
        field(20; "Daily rate W/O"; Decimal)
        {
        }
        field(21; "Basic daily rate"; Decimal)
        {
        }
        field(22; "Normal OT. rate"; Decimal)
        {
        }
        field(23; "Dog handlers allowance code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(24; "Dog handlers allowance"; Decimal)
        {
        }
        field(25; "Std Allowance code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(26; "Std Allowance"; Decimal)
        {
        }
        field(27; "Public holiday allowance code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
        field(28; "Public holiday allowance"; Decimal)
        {
        }
        field(29; "House allowance leave code"; Code[20])
        {
            //TableRelation = Table50030.Field1;
        }
    }

    keys
    {
        key(Key1; "Step Code", Level, "Category code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Gross pay" := "Basic amount" + "House allowance" + "Standard overtime" + "Duty allowance" + "Personal allowance" +
        "Perfomance allowance" + "Leave travel allowance" + "Dog handlers allowance"
         + "Public holiday allowance"
    end;
}