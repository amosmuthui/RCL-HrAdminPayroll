page 51525503 "Employee Kin Lines - ch"
{
    ApplicationArea = All;
    Caption = 'Next of Kin';
    PageType = List;
    SourceTable = "Employee Kin Changes";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(SurName; Rec.SurName)
                {
                }
                field("Other Names"; Rec."Other Names")
                {
                }
                field(Relationship; Rec.Relationship)
                {
                }
                field("ID No/Passport No"; Rec."ID No/Passport No")
                {
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                }
                field(Occupation; Rec.Occupation)
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Office Tel No"; Rec."Office Tel No")
                {
                }
                field("Home Tel No"; Rec."Home Tel No")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }
}