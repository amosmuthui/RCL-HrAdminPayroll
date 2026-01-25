page 51525552 "Staff PG Setup"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Staff PGroups";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                }
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("G/L Account"; Rec."G/L Account")
                {
                }
                field("GL Account Employer"; Rec."GL Account Employer")
                {
                }
            }
        }
    }

    actions
    {
    }
}