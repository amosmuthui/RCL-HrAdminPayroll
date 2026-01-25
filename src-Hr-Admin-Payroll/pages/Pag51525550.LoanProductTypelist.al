page 51525550 "Loan Product Type list"
{
    ApplicationArea = All;
    CardPageID = "Loan Product Type list";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Loan Product Type";

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
                field(Description; Rec.Description)
                {
                }
                field("Interest Rate"; Rec."Interest Rate")
                {
                }
                field("Interest Calculation Method"; Rec."Interest Calculation Method")
                {
                }
                field("No Series"; Rec."No Series")
                {
                }
                field("No of Instalment"; Rec."No of Instalment")
                {
                }
                field("Loan No Series"; Rec."Loan No Series")
                {
                }
                field(Rounding; Rec.Rounding)
                {
                }
                field("Rounding Precision"; Rec."Rounding Precision")
                {
                }
            }
        }
    }

    actions
    {
    }
}