page 51525523 "Medical Cover List"
{
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    SourceTable = "Medical Cover Types";

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
                field(Type; Rec.Type)
                {
                }
                field(Provider; Rec.Provider)
                {
                }
                field("Name of Provider"; Rec."Name of Provider")
                {
                }
            }
        }
    }

    actions
    {
    }
}