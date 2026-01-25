table 51525377 "Position Supervised"
{
    fields
    {
        field(1; "Job ID"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                //IF Jobs.GET("Job ID") THEN
                //Description:=Jobs."Job Description";
            end;
        }
        field(2; "Position Supervised"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Company Jobs"."Job ID";

            trigger OnValidate()
            begin
                Jobs.Reset;
                Jobs.SetRange("Job ID", "Position Supervised");
                if Jobs.FindFirst then
                    Description := Jobs."Job Description";
            end;
        }
        field(3; Description; Text[250])
        {
        }
        field(4; Remarks; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Job ID", "Position Supervised")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Jobs: Record "Company Jobs";
}