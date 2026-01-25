page 51525358 Insitutions
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Institution;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Address; Rec.Address)
                {
                }
                field(City; Rec.City)
                {
                }
                field("Institution's Bank"; Rec."Institution's Bank")
                {
                }
                field("Bank Account Number"; Rec."Bank Account Number")
                {
                }
                field("Bank Branch"; Rec."Bank Branch")
                {
                }
                field("Paying Bank Code"; Rec."Paying Bank Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}