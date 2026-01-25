page 51525512 "Employee Qualification"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Employee Qualification";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                /*field("Qualification Type"; Rec."Qualification Type")
                {
                }
                field(Level; Rec.Level)
                {
                }*/
                field("Qualification Code"; Rec."Qualification Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                /*field(CourseType; Rec.CourseType)
                {
                }*/
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                /*field("Grad. Date"; Rec."Grad. Date")
                {
                }*/
                field(Type; Rec.Type)
                {
                }
                field("Institution/Company"; Rec."Institution/Company")
                {
                }
                /*field("Score ID"; Rec."Score ID")
                {
                }*/
            }
        }
    }

    actions
    {
    }
}