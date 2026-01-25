page 51525522 "Employee Beneficiaries Lines"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Employee Beneficiaries";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Relationship; Rec.Relationship)
                {
                }
                field(SurName; Rec.SurName)
                {
                }
                field("Other Names"; Rec."Other Names")
                {
                }
                field(Gender; Rec.Gender)
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
                field("Distribution %"; Rec."Distribution %")
                {
                }
            }
        }
    }

    actions
    {
    }
}