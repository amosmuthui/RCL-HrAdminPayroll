table 51525530 "Job Chapter6 Requirements"
{
    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; "Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Chapter 6 Requirement";

            trigger OnValidate()
            begin
                Chapter6Requirement.Reset;
                Chapter6Requirement.SetRange(Code, Code);
                if Chapter6Requirement.FindFirst then begin
                    Description := Chapter6Requirement.Description;
                end;
            end;
        }
        field(4; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Mandatory; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Chapter6Requirement: Record "Chapter 6 Requirement";
}