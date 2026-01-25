page 51525484 "HR Lookup Values List"
{
    ApplicationArea = All;
    CardPageID = "HR Lookup Values Card";
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "HR Lookup Values";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = true;
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
            }
        }
        area(factboxes)
        {
            part(Control1102755004; "HR Lookup Values Factbox")
            {
                SubPageLink = Type = FIELD(Type);
            }
        }
    }

    actions
    {
    }
}