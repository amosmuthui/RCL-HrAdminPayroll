page 51525593 "Extra Payroll Banks"
{
    ApplicationArea = All;
    Caption = 'Extra Payroll Banks';
    PageType = ListPart;
    SourceTable = "Extra Payroll Banks";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payroll Period"; Rec."Payroll Period")
                {
                    Editable = false;
                }
                field("Bank Country"; Rec."Bank Country")
                {
                    ToolTip = 'Specifies the value of the Bank Country field.', Comment = '%';
                }
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.', Comment = '%';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.', Comment = '%';
                }
                field("Bank Account No"; Rec."Bank Account No")
                {
                    ToolTip = 'Specifies the value of the Bank Account No field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                { }
                field("Branch Code"; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field(Branch; Rec."Branch Code")
                {
                    ToolTip = 'Specifies the value of the Branch Code field.', Comment = '%';
                }
                field("Branch Name"; Rec."Branch Name")
                { }
                field("Code B.I.C."; Rec."Code B.I.C.")
                {
                    ToolTip = 'Specifies the value of the Code B.I.C. field.', Comment = '%';
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                }
                field(IBAN; Rec.IBAN)
                {
                    ToolTip = 'Specifies the value of the IBAN field.', Comment = '%';
                }
                field(Indicatif; Rec.Indicatif)
                {
                    ToolTip = 'Specifies the value of the Indicatif field.', Comment = '%';
                }
                field("Sort Code"; Rec."Sort Code")
                {
                    ToolTip = 'Specifies the value of the Sort Code field.', Comment = '%';
                }
                field("Swift Code"; Rec."SWIFT Code")
                {
                    ToolTip = 'Specifies the value of the Swift Code field.', Comment = '%';
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
        PayPeriods.Reset();
        PayPeriods.SetRange(Closed, false);
        if PayPeriods.FindFirst() then
            CurrentPeriod := PayPeriods."Starting Date";

        CurrPage.Editable(true);
        if (Rec."Payroll Period" <> 0D) and (Rec."Payroll Period" <> CurrentPeriod) then
            CurrPage.Editable(false);
    end;

    var
        PayPeriods: Record "Payroll Period";
        CurrentPeriod: Date;
}