table 51525447 "Separation Lines"
{
    fields
    {
        field(1; "Employee No"; Code[20])
        {
        }
        field(2; "Line No"; Integer)
        {
        }
        field(3; "Item Description"; Text[80])
        {
        }
        field(4; Cleared; Boolean)
        {
        }
        field(5; "Cleared Date"; Date)
        {
        }
        field(6; "Department Code"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; Remarks; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}