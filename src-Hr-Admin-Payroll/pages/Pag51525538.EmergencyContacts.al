page 51525538 "Emergency Contacts"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "HR Employee Relative";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Relationship; Rec.Relationship)
                {
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Last Name"; Rec."Last Name")
                {
                }
                field("Day Phone Number"; Rec."Day Phone Number")
                {
                }
                field("Evening Phone Number"; Rec."Evening Phone Number")
                {
                }
                field("Postal Address"; Rec."Postal Address")
                {
                }
                field("Residential Address"; Rec."Residential Address")
                {
                }
                field(Comment; Rec.Comment)
                {
                }
                field("Type Of Contact"; Rec."Type Of Contact")
                {
                }
                field("Postal Address2"; Rec."Postal Address2")
                {
                }
                field("Postal Address3"; Rec."Postal Address3")
                {
                }
                field("Residential Address2"; Rec."Residential Address2")
                {
                }
                field("Residential Address3"; Rec."Residential Address3")
                {
                }
            }
        }
    }

    actions
    {
    }
}