page 51525419 "Pending Recruitment Needs"
{
    ApplicationArea = All;
    CardPageID = "Recruitment Request";
    Editable = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Recruitment Needs";
    SourceTableView = WHERE(Closed = CONST(false), Status = filter("Pending Approval" | "Pending Prepayment")/*"Short Listing Done?" = CONST (true),
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
                /*field("Global Dimension 1 Code"; Rec. "Global Dimension 1 Code")
                {
                }*/
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Sub Responsibility Center"; Rec."Sub Responsibility Center")
                {
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
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field(Positions; Rec.Positions)
                { }
                // field(isInternship; Rec. isInternship)
                // {
                // }
                field(FnCheckIfJobIsClosed1; FnCheckIfJobIsClosed)
                {
                    Caption = 'Closed';
                }
            }
        }
    }

    actions
    {
    }

    procedure FnCheckIfJobIsClosed(): Boolean
    begin
        if Rec."End Date" < Today then
            exit(true)
        else
            exit(false);
    end;
}