page 51525471 "Sub County"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Sub County";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("County Code"; Rec."County Code")
                {
                }
                field("Sub County Code"; Rec."Sub County Code")
                {
                }
                field("Sub County Description"; Rec."Sub County Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}