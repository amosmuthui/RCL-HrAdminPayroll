page 51525579 "Terminal Dues Salary Structure"
{
    ApplicationArea = All;
    Caption = 'Salary Structure';
    PageType = ListPart;
    SourceTable = "Terminal Dues Salary Structure";
    SourceTableView = sorting("System Entry") order(descending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                }
                field(Amount; Rec."Amount (FCY)")
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Header No." <> '' then begin
            TerminalDuesHeader.Reset();
            TerminalDuesHeader.SetRange("No.", Rec."Header No.");
            if TerminalDuesHeader.FindFirst() then begin
                /*if TerminalDuesHeader."Payroll Currency" = '' then
                    Error('You must input the payroll currency in the header!');*/
                Rec.Currency := TerminalDuesHeader."Payroll Currency";
            end;
        end;
    end;

    var
        TerminalDuesHeader: Record "Terminal Dues Header";
}