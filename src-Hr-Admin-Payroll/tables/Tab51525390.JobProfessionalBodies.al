table 51525390 "Job Professional Bodies"
{
    fields
    {
        field(1; "Job ID"; Code[20])
        {
        }
        field(2; "Professional Body"; Code[10])
        {
            TableRelation = "Professional Body";

            trigger OnValidate()
            begin
                //"Membership Bodies" WHERE (MembershipBodyID=FIELD(MembershipBodyID))
            end;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Job ID", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}