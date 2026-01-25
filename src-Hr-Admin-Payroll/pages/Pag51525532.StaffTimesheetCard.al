page 51525532 "Staff Timesheet Card"
{
    ApplicationArea = All;
    AutoSplitKey = false;
    CardPageID = "Staff Timesheet Card";
    PageType = Card;
    SourceTable = "Employee Timesheet Lines";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("List of Key Tasks Undertaken"; Rec."List of Key Tasks Undertaken")
                {
                }
                field(Category; Rec.Category)
                {
                    Editable = false;
                }
                field("Job Title"; Rec."Job Title")
                {
                    Visible = false;
                }
                field("Directorate Name"; Rec."Directorate Name")
                {
                    Visible = false;
                }
                field(Department; Rec.Department)
                {
                    Visible = false;
                }
                field(Location; Rec.Location)
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Hours Worked"; Rec."Hours Worked")
                {
                }
                field("Total Days Worked"; Rec."Total Days Worked")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Visible = false;
                }
                field("Date Submitted to Supervisor"; Rec."Date Submitted to Supervisor")
                {
                }
                field("Date Approved"; Rec."Date Approved")
                {
                }
            }
            part(Control1; "Employee Timesheet Ledger")
            {
                SubPageLink = "TS  No" = FIELD("TS  No"),
                              "Line No." = FIELD("Line No.");
            }
            part(Control24; "Timesheet Tasks Undertaken")
            {
                SubPageLink = "Timesheet Code" = FIELD("TS  No"),
                              "TS Line No" = FIELD("Line No."),
                              Month = FIELD(Month),
                              Year = FIELD(Year);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action10)
            {
                action("Send To Supervisor")
                {
                    Enabled = EmployeeStatus;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        if Confirm('Send timesheet to supervisor for review and approval?') then begin
                            Rec."Approval Status" := Rec."Approval Status"::Supervisor;
                            Rec."Date Submitted to Supervisor" := Today;
                            Rec.Modify;
                            Message('Sent to supervisor successfully!');
                        end;
                    end;
                }
                action("Return To Staff")
                {
                    Enabled = SupervisorStatus;
                    Image = Return;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        if Confirm('Send timesheet to employee for review and corrections?') then begin
                            Rec."Approval Status" := Rec."Approval Status"::Employee;
                            Rec.Modify;
                            Message('Sent to Employee successfully!');
                        end;
                    end;
                }
                action(Approve)
                {
                    Enabled = SupervisorStatus;
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        if Confirm('Ready to Approve?') then begin
                            Rec."Approval Status" := Rec."Approval Status"::Approved;
                            Rec."Date Approved" := Today;
                            Rec.Modify;
                            Message('Period Timesheet approved!');
                        end;
                    end;
                }
                action("Timesheet Report")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        EmpTsLines.Reset;
                        EmpTsLines.SetRange("Employee No.", Rec."Employee No.");
                        EmpTsLines.SetRange(Month, Rec.Month);
                        EmpTsLines.SetRange(Year, Rec.Year);
                        if EmpTsLines.FindFirst then begin
                            REPORT.Run(51525268, true, false, EmpTsLines);

                        end;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Approval Status" = Rec."Approval Status"::Employee then begin
            EmployeeStatus := true;
            SupervisorStatus := false;
            ApprovedStatus := false;

        end;
        if Rec."Approval Status" = Rec."Approval Status"::Supervisor then begin
            EmployeeStatus := false;
            SupervisorStatus := true;
            ApprovedStatus := false;

        end;
        if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
            EmployeeStatus := false;
            SupervisorStatus := false;
            ApprovedStatus := true;

        end;
    end;

    var
        TSReport: Report "Employee Timesheet Report";
        EmpTsLines: Record "Employee Timesheet Lines";
        SupervisorStatus: Boolean;
        EmployeeStatus: Boolean;
        ApprovedStatus: Boolean;
}