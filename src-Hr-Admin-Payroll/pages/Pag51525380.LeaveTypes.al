page 51525380 "Leave Types"
{
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Leave Types";
    SourceTableView = WHERE(Status = CONST(Active));

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
                field(Days; Rec.Days)
                {
                }
                field("Unlimited Days"; Rec."Unlimited Days")
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(Balance; Rec.Balance)
                {
                }
                field("Max Carry Forward Days"; Rec."Max Carry Forward Days")
                {
                }
                field("Inclusive of Holidays"; Rec."Inclusive of Holidays")
                {
                }
                field("Inclusive of Saturday"; Rec."Inclusive of Saturday")
                {
                }
                field("Inclusive of Sunday"; Rec."Inclusive of Sunday")
                {
                }
                field("Off/Holidays Days Leave"; Rec."Off/Holidays Days Leave")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}