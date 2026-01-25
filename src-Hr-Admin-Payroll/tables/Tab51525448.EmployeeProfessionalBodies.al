table 51525448 "Employee Professional Bodies"
{
    fields
    {
        field(1; Employee; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Proffesional Body"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Professional Body";
        }
        field(3; "Professional Body Name"; Text[150])
        {
            CalcFormula = Lookup("Professional Body".Description WHERE(Code = FIELD("Proffesional Body")));
            FieldClass = FlowField;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Date of Join"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Annual Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Date of Leaving"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
    }

    keys
    {
        key(Key1; Employee, "Proffesional Body", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}