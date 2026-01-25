page 51525308 "HR Calendar List"
{
    ApplicationArea = All;
    CardPageID = "HR Calendar Card";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "HR Calendar";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000000; Outlook)
            {
            }
        }
    }

    actions
    {
    }
}