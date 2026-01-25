page 51525312 "Company Job List"
{
    ApplicationArea = All;
    CardPageID = "Company Jobs";
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Company Jobs";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Job Description"; Rec."Job Description")
                {
                    Caption = 'Job Designation';
                }
                field("No of Posts"; Rec."No of Posts")
                {
                    Visible = false;
                }
                field("Occupied Establishments"; Rec."Occupied Establishments")
                {
                    Caption = 'In Position';
                    Visible = false;
                }
                field("""No of Posts""-""Occupied Establishments"""; Rec."No of Posts" - Rec."Occupied Establishments")
                {
                    Caption = 'Vacant Positions';
                    Visible = false;
                }
                field("Dimension 2"; Rec."Dimension 2")
                {
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Date Active"; Rec."Date Active")
                {
                }
                field("Salary Allocation %"; Rec."Salary Allocation %")
                {
                }
                field("Given Transport Allowance"; Rec."Given Transport Allowance")
                { }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Job)
            {
                Caption = 'Job';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Company Jobs";
                    RunPageLink = "Job ID" = FIELD("Job ID");
                }
                action("Update Salary Allocation")
                {
                    Caption = 'Update Employee Salary Allocation';
                    Image = UpdateDescription;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    //RunObject = Report "Update Salary Allocation";
                    Visible = false;
                }
            }
        }
    }
}