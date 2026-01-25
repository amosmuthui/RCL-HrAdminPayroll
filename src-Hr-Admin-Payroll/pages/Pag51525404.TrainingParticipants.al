page 51525404 "Training Participants"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Training Participants";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Training Request"; Rec."Training Request")
                {
                    Visible = false;
                }
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Course Code"; Rec."Course Code")
                { }
                field("Training Course"; Rec."Training Course")
                {
                }
                field("Training  Description"; Rec."Training  Description")
                {
                    Visible = true;
                }
                field("Trainer Category"; Rec."Trainer Category")
                { }
                field("Trainer No."; Rec."Trainer No.")
                { }
                field(Trainer; Rec.Trainer)
                {
                }
                field(Venue; Rec.Venue)
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Per Diem"; Rec."Per Diem")
                {
                }
                field("Tuition Fee"; Rec."Tuition Fee")
                {
                }
                field("Air Ticket"; Rec."Air Ticket")
                {
                }
                field("Travel Docs Fees"; Rec."Travel Docs Fees")
                {
                }
                field("Ground Transport"; Rec."Ground Transport")
                {
                }
                field("Total Cost"; Rec."Total Cost")
                {
                }
            }
        }
    }

    actions
    {
    }
}