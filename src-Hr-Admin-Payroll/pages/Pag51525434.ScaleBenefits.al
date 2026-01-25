page 51525434 "Scale Benefits"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Scale Benefits";
    Caption = 'Salary Notches';

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Salary Scale"; Rec."Salary Scale")
                {
                }
                field(Currency; Rec.Currency)
                { }
                field("Salary Pointer"; Rec."Salary Pointer")
                {
                }
                field("ED Code"; Rec."ED Code")
                {
                    Visible = false;
                }
                field("ED Description"; Rec."ED Description")
                {
                    Visible = false;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}