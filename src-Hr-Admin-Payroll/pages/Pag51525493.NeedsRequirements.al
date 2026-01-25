page 51525493 "Needs Requirements"
{
    ApplicationArea = All;
    PageType = CardPart;
    SourceTable = "Needs Requirement";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Qualification Type"; Rec."Qualification Type")
                {
                }
                field("Qualification Code"; Rec."Qualification Code")
                {
                    Visible = false;
                }
                field(Qualification; Rec.Qualification)
                {
                    Visible = false;
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
                field("Grade Id"; Rec."Grade Id")
                {
                }
                field("Grade Name"; Rec."Grade Name")
                {
                }
                field(Mandatory; Rec.Mandatory)
                {
                }
                field("Job Specification"; Rec."Job Specification")
                {
                    Visible = false;
                }
                field(Priority; Rec.Priority)
                {
                    Visible = false;
                }
                field("Score ID"; Rec."Score ID")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}