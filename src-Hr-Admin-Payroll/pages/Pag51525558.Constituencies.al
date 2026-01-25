page 51525558 Constituencies
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Constituency;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sub County Code"; Rec."Sub County Code")
                {
                }
                field("Constituency Description"; Rec."Constituency Description")
                {
                }
                field("Contituency Code"; Rec."Contituency Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}