page 51525551 "Staff Posting Group"
{
    ApplicationArea = All;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Staff Posting Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Salary Account"; Rec."Salary Account")
                {
                    Caption = 'Basic Salary Account';
                }
                field("Income Tax Account"; Rec."Income Tax Account")
                {
                }
                field("SSF Employer Account"; Rec."SSF Employer Account")
                {
                    Caption = 'NSSF Employer Account';
                }
                field("SSF Employee Account"; Rec."SSF Employee Account")
                {
                    Caption = 'NSSF Total Account';
                }
                field("Pension Employer Acc"; Rec."Pension Employer Acc")
                {
                }
                field("Pension Employee Acc"; Rec."Pension Employee Acc")
                {
                }
                field("Net Salary Payable"; Rec."Net Salary Payable")
                {
                }
                field("Fringe benefits"; Rec."Fringe benefits")
                {
                    Caption = 'Fringe Benefits';
                }
                field("Employee Provident Fund Acc."; Rec."Employee Provident Fund Acc.")
                {
                    Visible = false;
                }
                field("Is Temporary"; Rec."Is Temporary")
                {
                }
                field("Is Permanent"; Rec."Is Permanent")
                {
                }
                field("Is Intern"; Rec."Is Intern")
                {
                }
                field("Is Contract"; Rec."Is Contract")
                {
                }
                field("Seconded Employees"; Rec."Seconded Employees")
                {
                }
                field("Tax Percentage"; Rec."Tax Percentage")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Posting Group")
            {
                Caption = 'Posting Group';
                action("Accounts Mapping")
                {
                    Caption = 'Accounts Mapping';
                    RunObject = Page "Staff PG Setup";
                    RunPageLink = "Posting Group" = FIELD(Code);
                }
            }
        }
    }
}