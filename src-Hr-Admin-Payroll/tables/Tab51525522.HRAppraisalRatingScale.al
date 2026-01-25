table 51525522 "HR Appraisal Rating Scale"
{
    DrillDownPageID = "HR Appraisal Rating Scale List";
    LookupPageID = "HR Appraisal Rating Scale List";

    fields
    {
        field(1; "Rating Scale"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Performance Targets","Values and Competencies";
        }
        field(2; Score; Decimal)
        {
            BlankZero = true;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if (Score >= 90) then
                    Description := 'Excellent'
                else
                    if (Score >= 70) and (Score <= 89) then
                        Description := 'Very Good'
                    else
                        if (Score >= 60) and (Score <= 79) then
                            Description := 'Good'
                        else
                            if (Score >= 50) and (Score <= 59) then
                                Description := 'Average'
                            else
                                if (Score < 50) then Description := 'Poor';


                if Score <= 0 then Error('Score cannot be less than zero');

                if Score > 100 then Error('Score cannot exceed 100%');
            end;
        }
        field(3; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Rating Scale", Score)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}