table 51525374 "HR Calendar List"
{
    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Day; Text[40])
        {
            Editable = false;
        }
        field(3; Date; Date)
        {
            Editable = true;
        }
        field(4; "Non Working"; Boolean)
        {
            Editable = true;
        }
        field(5; Reason; Text[40])
        {
        }
        field(6; "Recurring System"; Option)
        {
            Caption = 'Recurring System';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Annual Recurring,Weekly Recurring';
            OptionMembers = " ","Annual Recurring","Weekly Recurring";

            trigger OnValidate()
            begin
                /*IF "Recurring System" <> xRec."Recurring System" THEN
                  CASE "Recurring System" OF
                    "Recurring System"::"Annual Recurring":
                      Day := Day::" ";
                    "Recurring System"::"Weekly Recurring":
                      Date := 0D;
                  END;*/

            end;
        }
    }

    keys
    {
        key(Key1; Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}