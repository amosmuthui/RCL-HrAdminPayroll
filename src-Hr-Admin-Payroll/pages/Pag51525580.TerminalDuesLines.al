page 51525580 "Terminal Dues Lines"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Terminal Dues Lines";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Trans Type"; Rec."Trans Type")
                {
                    ToolTip = 'Specifies the value of the Trans Type field.', Comment = '%';
                }
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
                field(Taxable; Rec.Taxable)
                {
                    Editable = (not Rec."System Entry");
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
                /*if  TerminalDuesHeader."Payroll Currency" = '' then
                    Error('You must input the payroll currency in the header!');*/
                Rec.Currency := TerminalDuesHeader."Payroll Currency";
            end;
        end;
    end;

    var
        TerminalDuesHeader: Record "Terminal Dues Header";
}