page 51525424 "Leave & Performance Cues"
{
    ApplicationArea = All;
    Caption = 'Leave and Performance Cues';
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
                field("Active Employees"; Rec.ActiveEmpsForLeave())
                {
                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Employee Leave Balances");
                    end;
                }
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