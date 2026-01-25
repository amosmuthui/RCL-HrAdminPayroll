page 51525496 "Job App Work Experience"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "Job App Work Experience";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Applicant No."; Rec."Applicant No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("Experience Period"; Rec."Experience Period")
                {
                    Caption = 'Experience In Years';
                }
                field("Job Title"; Rec."Job Title")
                {
                }
                field(Responsibility; Rec.Responsibility)
                {
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                }
                field("Position Code"; Rec."Position Code")
                {
                    Visible = false;
                }
                field("Experience No"; Rec."Experience No")
                {
                }
                field(Salary; Rec.Salary)
                {
                }
                field("Job App ID"; Rec."Job App ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}