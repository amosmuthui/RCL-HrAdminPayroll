table 51525378 "Job Responsiblities"
{
    fields
    {
        field(1; "Job ID"; Code[50])
        {
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";
        }
        field(2; Responsibility; Text[250])
        {
            NotBlank = true;
        }
        field(3; Remarks; Text[80])
        {
        }
        field(4; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "Job Responsibility Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Responsibility Category";
        }
        field(6; "Need ID"; Code[20])
        {
            CalcFormula = Lookup("Recruitment Needs"."No." WHERE("Job ID" = FIELD("Job ID")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Job ID", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}