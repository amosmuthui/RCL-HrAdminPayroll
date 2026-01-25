page 51525433 "Salary Pointers"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Salary Pointers";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Salary Pointer"; Rec."Salary Pointer")
                {
                }
                field("Basic Pay"; Rec."Basic Pay")
                {
                }
                field("Basic Pay int"; Rec."Basic Pay int")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Benefits)
            {
                Caption = 'Benefits';
                action(Earnings)
                {
                    Caption = 'Earnings';
                    RunObject = Page "Scale Benefits";
                    /*RunPageLink = "Salary Scale" = FIELD (Field4),
                                  "Salary Pointer" = FIELD ("Salary Pointer");*/
                }
            }
        }
    }
}