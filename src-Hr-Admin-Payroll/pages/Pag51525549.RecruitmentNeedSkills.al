page 51525549 "Recruitment Need Skills"
{
    ApplicationArea = All;
    Caption = 'Required Skills';
    PageType = ListPart;
    SourceTable = "Recruitment Needs Skills";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Recruitment Need Code"; Rec."Recruitment Need Code")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field(Mandatory; Rec.Mandatory)
                {
                }
            }
        }
    }

    actions
    {
    }
}