page 51525592 "Payroll Variance Comments"
{
    ApplicationArea = All;
    Caption = 'Payroll Variance Comments';
    PageType = ListPart;
    SourceTable = "Payroll Variance Comments";
    SourceTableView = SORTING("Payroll Period") ORDER(descending);

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.', Comment = '%';
                    Visible = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    Visible = false;
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                    Visible = false;
                }
            }
        }

    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PayPeriods.Reset();
        PayPeriods.SetRange(Closed, false);
        if PayPeriods.FindFirst() then
            CurrentPeriod := PayPeriods."Starting Date"
        else
            Error('There is no open payroll period!');

        Rec."Payroll Period" := CurrentPeriod;
    end;

    trigger OnOpenPage()
    begin
        CurrPage.Editable(true);
        if Rec.Closed then
            CurrPage.Editable(false);
    end;

    var
        PayPeriods: Record "Payroll Period";
        PayVarComm: Record "Payroll Variance Comments";
        CurrentPeriod: Date;
}