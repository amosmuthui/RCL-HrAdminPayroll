page 51525473 "Job Interviewers List"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Job Interviewers";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Recruitment Need"; Rec."Recruitment Need")
                {
                }
                field("Interview Type"; Rec."Interview Type")
                {
                }
                field(Interviewer; Rec.Interviewer)
                {
                }
            }
        }
    }

    actions
    {
    }
}