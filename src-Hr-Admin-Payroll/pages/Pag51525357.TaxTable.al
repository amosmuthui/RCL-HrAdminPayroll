page 51525357 "Tax Table"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Brackets Lines";
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Table Code"; Rec."Table Code")
                {
                }
                field("Tax Band"; Rec."Tax Band")
                {
                }
                field("Lower Limit"; Rec."Lower Limit")
                {
                    Visible = true;
                }
                field("Upper Limit"; Rec."Upper Limit")
                {
                    Visible = true;
                }
                field("Taxable Amount"; Rec."Taxable Amount")
                {
                }
                field(Percentage; Rec.Percentage)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("From Date"; Rec."From Date")
                {
                    Visible = false;
                }
                field("End Date"; Rec."End Date")
                {
                    Visible = false;
                }
                field(Institution; Rec.Institution)
                {
                }
                field("Contribution Rates Inclusive"; Rec."Contribution Rates Inclusive")
                {
                }
                field("Tier No."; Rec."Tier No.")
                {
                }
                field("Extra Amount Formula"; Rec."Extra Amount Formula")
                {
                }
                field("Extra Amount Value"; Rec."Extra Amount Value")
                {
                }
            }
        }
    }

    actions
    {
    }
}