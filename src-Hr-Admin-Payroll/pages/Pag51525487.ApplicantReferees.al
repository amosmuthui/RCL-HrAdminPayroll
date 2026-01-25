page 51525487 "Applicant Referees"
{
    ApplicationArea = All;
    AutoSplitKey = false;
    PageType = ListPart;
    SourceTable = "Applicant Referees";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    Visible = false;
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
                field("Postal Address"; Rec."Postal Address")
                {
                }
                field("Mobile No"; Rec."Mobile No")
                {
                }
                field("Applicant Email"; Rec."Applicant Email")
                {
                }
                field(Notes; Rec.Notes)
                {
                }
            }
        }
    }

    actions
    {
    }
}