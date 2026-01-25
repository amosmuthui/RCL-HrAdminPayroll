page 51525423 "Closed Job Applications"
{
    ApplicationArea = All;
    Caption = 'Completed Job Applications';
    CardPageID = "Recruitment Request";
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Recruitment Needs";
    SourceTableView = WHERE("Current Stage" = CONST(Completed)/*"Short Listing Done?" = CONST (true),
                            "In Oral Test" = CONST (true),
                            "Past Oral Test" = CONST (true),
                            "Closed Applications" = CONST (true)*/);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Job ID"; Rec."Job ID")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Reason for Recruitment"; Rec."Reason for Recruitment")
                {
                }
                field("Requested By"; Rec."Requested By")
                {
                }
                field("Appointment Type"; Rec."Appointment Type")
                {
                }
                field("Expected Reporting Date"; Rec."Expected Reporting Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            /*action("View Applicants")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Closed Applications Card";
                RunPageLink = "Recruitment Need Code" = FIELD("No."),
                              "Passed Short Listing" = CONST(true),
                              "Passed Aptitude" = CONST(true),
                              "Passed Oral Interview" = CONST(true);
                Visible = false;
            }*/
        }
    }
}