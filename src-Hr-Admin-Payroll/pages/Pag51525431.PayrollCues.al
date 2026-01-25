page 51525431 "Payroll Cues"
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
                field(Countries; Rec.Countries)
                {
                    trigger OnDrillDown()
                    var
                        PayrollCountries: Record "Country/Region";
                    begin
                        PayrollCountries.Reset();
                        PayrollCountries.SetRange("Is Payroll Country", true);
                        if PayrollCountries.Find('-') then
                            Page.Run(PAGE::"Countries/Regions", PayrollCountries);
                    end;
                }
                field(Currencies; Rec.Currencies)
                {
                    trigger OnDrillDown()
                    begin
                        Page.Run(PAGE::"Currencies");
                    end;
                }
                field("Pay Periods"; Rec."Pay Periods")
                { }
                field(Earnings; Rec.Earnings)
                { }
                field(Deductions; Rec.Deductions)
                { }
                field("Requests To Approve"; Rec."Requests To Approve")
                {
                    Visible = false;
                }
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