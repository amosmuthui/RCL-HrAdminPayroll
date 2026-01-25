page 51525497 "Job Application Referees"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Job Application Referees";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                }
                field(Names; Rec.Names)
                {
                }
                field(Designation; Rec.Designation)
                {
                }
                field(Company; Rec.Company)
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Telephone No"; Rec."Telephone No")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Line No"; Rec."Line No")
                {
                    Visible = false;
                }
                field(Notes; Rec.Notes)
                {
                    Visible = false;
                }
                field("Job App ID"; Rec."Job App ID")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}