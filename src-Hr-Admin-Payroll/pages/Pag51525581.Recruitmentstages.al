page 51525581 "Recruitment stages"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = "Recruitment Stages1";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Recruitement Stage"; Rec."Recruitement Stage")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Failed Response Templates"; Rec."Failed Response Templates")
                {
                }
                field("Passed Response Templates"; Rec."Passed Response Templates")
                {
                }
            }
        }
    }

    actions
    {
    }
}