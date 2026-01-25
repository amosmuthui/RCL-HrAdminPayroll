page 51525464 "Job Education Needs"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Job Educational Need";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Education Level"; Rec."Education Level")
                {
                }
                field("Education Level Name"; Rec."Education Level Name")
                {
                    Editable = false;
                }
                field(Grade; Rec.Grade)
                {
                }
            }
        }
    }

    actions
    {
    }
}