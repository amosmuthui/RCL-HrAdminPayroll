page 51525343 "HR Employee List-Interns"
{
    ApplicationArea = All;
    CardPageID = "HR Employee-Intern";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Employee;
    SourceTableView = WHERE("Contract Type" = FILTER('INTERNSHIP'));

    layout
    {
        area(content)
        {
            repeater(Control21)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies a number for the employee.';
                }
                field(FullName; Rec.FullName)
                {
                    Caption = 'Full Name';
                    ToolTip = 'Specifies the full name of the employee.';
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the employee''s first name.';
                    Visible = false;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the employee''s middle name.';
                    Visible = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the employee''s last name.';
                    Visible = false;
                }
                field(Initials; Rec.Initials)
                {
                    ToolTip = 'Specifies the employee''s initials.';
                    Visible = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the employee''s job title.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the postal code of the address.';
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region code.';
                    Visible = false;
                }
                field(Extension; Rec.Extension)
                {
                    ToolTip = 'Specifies the employee''s telephone extension.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the employee''s telephone number.';
                    Visible = false;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the employee''s mobile telephone number.';
                    Visible = false;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the employee''s email address.';
                    Visible = false;
                }
                field("Statistics Group Code"; Rec."Statistics Group Code")
                {
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                    Visible = false;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies a resource number for the employee, if the employee is a resource in Resources Planning.';
                    Visible = false;
                }
                field("Search Name"; Rec."Search Name")
                {
                    ToolTip = 'Specifies a search name for the employee.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies if a comment has been entered for this entry.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control2; Links)
            {
                Visible = false;
            }
            systempart(Control1; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Is Intern" := true;
    end;
}