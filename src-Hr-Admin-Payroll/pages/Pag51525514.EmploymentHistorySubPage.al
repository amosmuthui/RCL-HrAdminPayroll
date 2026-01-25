page 51525514 "Employment History SubPage"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Employment History";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Job Title"; Rec."Job Title")
                {
                }
                field(FromDate; Rec.FromDate)
                {
                }
                field(ToDate; Rec.ToDate)
                {
                }
                field("Key Experience"; Rec."Key Experience")
                {
                }
                field(Grade; Rec.Grade)
                {
                }
                field("Salary On Leaving"; Rec."Salary On Leaving")
                {
                }
                field("Postal Address"; Rec."Postal Address")
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field("Reason For Leaving"; Rec."Reason For Leaving")
                {
                }
                field(Comment; Rec.Comment)
                {
                }
            }
        }
    }

    actions
    {
    }
}