page 51525562 "Previous Cases"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Previous Cases";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Case No"; Rec."Case No")
                {
                }
                field("Employee No"; Rec."Employee No")
                {
                }
                field("Employee Name"; Rec."Employee Name")
                {
                }
                field("Case Description"; Rec."Case Description")
                {
                }
                field("Action Taken"; Rec."Action Taken")
                {
                }
                field("Appeal Descision"; Rec."Appeal Descision")
                {
                }
            }
        }
    }

    actions
    {
    }
}