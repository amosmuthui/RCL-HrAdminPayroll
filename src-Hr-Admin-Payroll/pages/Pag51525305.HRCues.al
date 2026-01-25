page 51525305 "HR Cues"
{
    ApplicationArea = All;
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

                //Recruitment and onboarding
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
                field("Completed Job Adverts"; Rec."Completed Job Adverts")
                { }


                //Leave and performance cues

                field("Pending Leave Applications"; Rec."Pending Leave Applications")
                {
                }
                field("Active Leaves"; Rec.ActiveLeaves())
                {
                    trigger OnDrillDown()
                    var
                        LeaveApp: Record "Employee Leave Application";
                    begin
                        LeaveApp.Reset();
                        LeaveApp.Setfilter("Start Date", '<=%1', TODAY);
                        LeaveApp.Setfilter("Resumption Date", '>=%1', TODAY);
                        LeaveApp.SetRange(Status, LeaveApp.Status::Released);
                        if LeaveApp.Find('-') then
                            Page.Run(PAGE::"Leave Applications List", LeaveApp);
                    end;
                }
                field("Approved Leave Applications"; Rec."Released Leave Applications")
                {
                }

                field("Pending Targets"; Rec."Pending Targets")
                {
                }
                field("Approved Targets"; Rec."Approved Targets")
                { }
                field("Mid-Year Reviews"; Rec."Mid-Year Reviews")
                { }
                field(Appraissals; Rec.Appraissals)
                { }

                //Training

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


                /*field("Released Leave Applications"; Rec."Released Leave Applications")
                {
                }
                field("Approved Store Requisitions"; Rec."Approved Store Requisitions")
                {
                }
                field("Fixed Assets"; Rec. "Fixed Assets")
                {
                }
                field("Requests To Approve"; Rec."Requests To Approve")
                {
                    Visible = FALSE;
                }
                field(Items; Rec.Items)
                {
                }*/
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