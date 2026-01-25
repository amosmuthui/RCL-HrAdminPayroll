page 51525413 "Recruitment & Onboarding Cues"
{
    ApplicationArea = All;
    Caption = 'Recruitment and Onboarding Cues';
    PageType = ListPart;
    SourceTable = "HR Cues";

    layout
    {
        area(content)
        {
            cuegroup(Group)
            {
                field("Pending Approval Requests"; Rec.PendingApprovalRequestsForThisUser())
                {
                    DrillDownPageId = "Requests To Approve";

                    trigger OnDrillDown()
                    begin
                        Page.Run(654/*"Requests To Approve"*/);
                    end;
                }
                field("Active Employees"; Rec."Active Emplooyees")
                {
                    StyleExpr = True;
                }
                field("Job Positions"; Rec."Job Positions")
                {
                }
                field("Pending Recruitment Needs"; Rec."Pending Recruitment Needs")
                {
                }
                field("Open Job Adverts"; Rec.OpenJobAdverts())
                {
                    trigger OnDrillDown()
                    begin
                        Page.Run(PAGE::"Open Job Adverts");
                    end;
                }
                field("Closed Job Adverts"; Rec.ClosedJobAdverts())
                {
                    trigger OnDrillDown()
                    begin
                        Page.Run(PAGE::"Closed Job Adverts");
                    end;
                }
                field("Completed Job Adverts"; Rec."Completed Job Adverts")
                { }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}