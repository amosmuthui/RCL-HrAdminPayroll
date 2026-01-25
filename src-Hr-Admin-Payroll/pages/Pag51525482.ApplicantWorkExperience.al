page 51525482 "Applicant Work Experience"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Applicant Work Experience";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Applicant No."; Rec."Applicant No.")
                {
                    Visible = false;
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field(Responsibility; Rec.Responsibility)
                {
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                }
                field("Gross Salary"; Rec."Gross Salary")
                {
                }
            }
        }
    }

    actions
    {
    }
}