page 51525356 "Bracket Tables"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Bracket Tables";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Bracket Code"; Rec."Bracket Code")
                {
                }
                field(Country; Rec.Country)
                { }
                field("Bracket Description"; Rec."Bracket Description")
                {
                }
                field(Annual; Rec.Annual)
                {
                }
                field("Effective Starting Date"; Rec."Effective Starting Date")
                {
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(NHIF; Rec.NHIF)
                {
                }
                field(NSSF; Rec.NSSF)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Brackets)
            {
                Caption = 'Brackets';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Tax Table";
                RunPageLink = "Table Code" = FIELD("Bracket Code");
                RunPageOnRec = false;
            }
        }
    }
}