page 51525425 "Training Cues"
{
    ApplicationArea = All;
    Caption = 'Training Cues';
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
                        Page.Run(654);
                    end;
                }
                field("Active Employees"; Rec."Active Emplooyees")
                {
                    StyleExpr = True;
                }
                field("Training Courses"; Rec."Training Courses")
                {
                }
                field("Pending Training Requests"; Rec."Pending Training Requests")
                {
                }
                field("Ongoing Trainings"; Rec."Ongoing Trainings")
                {
                }
                field("Upcoming Trainings"; Rec."Upcoming Trainings")
                {
                }
                field("Completed Trainings"; Rec."Completed Trainings")
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