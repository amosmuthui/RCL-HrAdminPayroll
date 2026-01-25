page 51525379 "Leave Types Setup"
{
    ApplicationArea = All;
    Editable = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Leave Types";

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
                field("Show in Portal"; Rec."Show in Portal")
                {
                }
                field("Visible on Portal Dashboard"; Rec."Visible on Portal Dashboard")
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
                field("Require Supporting Doc.Attache"; Rec."Require Supporting Doc.Attache")
                {
                }
                field("Max Carry Forward Days"; Rec."Max Carry Forward Days")
                {
                }
                field("Annual Leave"; Rec."Annual Leave")
                {
                }
                field("Off/Holidays Days Leave"; Rec."Off/Holidays Days Leave")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Eligible Staff"; Rec."Eligible Staff")
                {
                }
                field(IsMonthly; Rec.IsMonthly)
                {
                }
                field("Acrue Days"; Rec."Acrue Days")
                {
                }
                field("Inclusive of Non Working Days"; Rec."Inclusive of Non Working Days")
                {
                }
                field("Minimum Days Worked"; Rec."Minimum Days Worked")
                { }
                field("Notification Email"; Rec."Notification Email")
                { }
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