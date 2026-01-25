table 51525400 "Job Interviewers"
{
    fields
    {
        field(1; "Recruitment Need"; Code[20])
        {
            TableRelation = "Recruitment Needs";
        }
        field(2; "Interview Type"; Option)
        {
            OptionCaption = ',Oral Interview,Technical Interview';
            OptionMembers = ,"Oral Interview","Technical Interview";
        }
        field(3; Interviewer; Code[80])
        {
            TableRelation = "User Setup";
        }
    }

    keys
    {
        key(Key1; "Recruitment Need", Interviewer, "Interview Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}