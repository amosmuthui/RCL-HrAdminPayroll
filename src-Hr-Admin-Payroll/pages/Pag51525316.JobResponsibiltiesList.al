page 51525316 "Job Responsibilties List"
{
    ApplicationArea = All;
    CardPageID = "J. Responsiblities";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Company Jobs";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Job Description"; Rec."Job Description")
                {
                }
                field("No of Posts"; Rec."No of Posts")
                {
                }
                field("Occupied Establishments"; Rec."Occupied Establishments")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Job)
            {
                Caption = 'Job';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Company Jobs";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                }
            }
        }
    }
}