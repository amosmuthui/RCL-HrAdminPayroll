page 51525504 "Employee Disability Info"
{
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = "PAYE Employee Exemption";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Amount Exempted"; Rec."Amount Exempted")
                {
                }
                field("Exemption Reference"; Rec."Exemption Reference")
                {
                }
                field("Disability Type"; Rec."Disability Type")
                {
                }
                field("Disability Description"; Rec."Disability Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}