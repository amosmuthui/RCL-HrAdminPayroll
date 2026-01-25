page 51525481 "Applicant Qualification"
{
    ApplicationArea = All;
    PageType = ListPart;
    //SourceTable = "Applicant Qualification";
    SourceTable = "Applicant Online Qualification";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                /*field("Applicant No."; Rec."Applicant No.")
                {
                    Visible = false;
                }*/
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
                field("Grade Id"; Rec."Grade Id")
                {
                }
                field("Grade Name"; Rec."Grade Name")
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                }
            }
        }
    }

    actions
    {
    }
}