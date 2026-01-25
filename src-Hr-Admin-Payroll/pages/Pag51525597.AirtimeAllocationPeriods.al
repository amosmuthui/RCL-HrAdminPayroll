page 51525597 "Airtime Allocation Batches"
{
    ApplicationArea = All;
    Caption = 'Airtime Allocation Batches';
    PageType = List;
    SourceTable = "Airtime Allocation Batches";
    UsageCategory = Lists;
    CardPageId = "Airtime Allocation Batch";
    InsertAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Month Start Date"; Rec."Month Start Date")
                {
                    ToolTip = 'Specifies the value of the Month Start Date field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Service Provider"; Rec."Service Provider")
                {
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create New")
            {
                Image = Create;
                ApplicationArea = All;
                ToolTip = 'Create New Batch';
                Caption = 'Create New';

                trigger OnAction()
                var
                    SelectedDate: Date;
                begin
                    if Confirm('Are you sure you want to create a new batch?') then begin
                        SelectedDate := AirtimeManagementFunctions.CreateDateSelection();
                        AirtimeManagementFunctions.CreateNewBatch(SelectedDate, false, false, false);
                    end;
                end;
            }

            action(AllocationReport)
            {
                Caption = 'Allocation Report';
                Image = DepositSlip;

                trigger OnAction()
                var
                    AllocationPeriod: Record "Airtime Allocation Batches";
                begin
                    AllocationPeriod.Reset;
                    AllocationPeriod.SetRange("Month Start Date", Rec."Month Start Date");
                    if AllocationPeriod.Find('-') then begin
                        REPORT.Run(Report::"Airtime Allocations", true, true, AllocationPeriod);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            //group(HOME)
            //{
            actionref("Create New Promoted"; "Create New") { }
            actionref("AllocationReport Promoted"; AllocationReport) { }
            //}
        }
    }

    var
        AirtimeManagementFunctions: Codeunit "Airtime Management Functions";
}
