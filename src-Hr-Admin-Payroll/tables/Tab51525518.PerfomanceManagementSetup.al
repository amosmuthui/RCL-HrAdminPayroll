table 51525518 "Perfomance Management Setup"
{
    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Performance Numbers"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(3; "Maximun value Core Performance"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Minimum Value Core Performance"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Values Maximum Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Values Minimum Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Peers Maximum Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Peers Minimum Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "External Maximum Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "External Minimum Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Total Rating% Peers"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Total Rating% External"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Surbodinate Maximum Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Surbodinate Minimum Score"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Total Rating%Subordinates"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Workplan Numbers"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(17; "Target Numbers"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(18; "Workplan Department Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(19; "Workplan Application Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(20; "Directorate Workplan Lines Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(21; "Departmental Workplan Line Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(22; "Target Lines Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}