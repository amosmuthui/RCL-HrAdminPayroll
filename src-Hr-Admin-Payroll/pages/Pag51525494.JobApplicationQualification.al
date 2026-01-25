page 51525494 "Job Application Qualification"
{
    ApplicationArea = All;
    Caption = 'Applicant Qualifications';
    PageType = ListPart;
    SourceTable = "Job Application Qualification";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Applicant No."; Rec."Applicant No.")
                {
                }
                field("Education Level Id"; Rec."Education Level Id")
                {
                }
                field("Education Level Name"; Rec."Education Level Name")
                {
                }
                field("Course Id"; Rec."Course Id")
                {
                }
                field("Course Name"; Rec."Course Name")
                {
                }
                field(Description; Rec.Description)
                {
                    Visible = false;
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                }
                field("To Date"; Rec."To Date")
                {
                    Caption = 'Award Date';
                }
                field("Job App ID"; Rec."Job App ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}