page 51525352 "Pay Periods"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTable = "Payroll Period";
    SourceTableView = sorting("Starting Date") order(descending);

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Starting Date"; Rec."Starting Date")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("New Fiscal Year"; Rec."New Fiscal Year")
                {
                    Editable = false;
                }
                field("Pay Date"; Rec."Pay Date")
                {
                    Visible = false;
                }
                field("Closed By"; Rec."Closed By")
                {
                    Editable = false;
                }
                field("Closed on Date"; Rec."Closed on Date")
                {
                    Editable = false;
                }
                field(Closed; Rec.Closed)
                {
                    Editable = false;
                }
                field("CMS Starting Date"; Rec."CMS Starting Date")
                {
                    Visible = false;
                }
                field("CMS End Date"; Rec."CMS End Date")
                {
                    Visible = false;
                }
                field("Close Pay"; Rec."Close Pay")
                {
                    Editable = false;
                }
                field("Market Interest Rate %"; Rec."Market Interest Rate %")
                {
                    Visible = false;
                }
                field("Display On Portal"; Rec."Display On Portal")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Close Period")
            {
                Caption = 'Close Period';
                action("Close Pay Period")
                {
                    Caption = 'Close Pay Period';

                    trigger OnAction()
                    begin
                        //Error('%1',PayrollPeriodX1.GETFILTER(PayrollPeriodX1."Pay Date"));

                        //CurrPage.SETSELECTIONFILTER(PayrollPeriod);
                        //Message('1. %1\2. %2',PayrollPeriodX1.GETFILTER("Starting Date"),PayrollPeriodX1.GETFILTER("Closed on Date"));
                        /*
                        IF PayrollPeriodX1.GETFILTER(PayrollPeriodX1."Pay Date")='' THEN BEGIN
                           Error('Pay Date is Not Filled. Please Fill it!!');
                        END;
                        PayrollPeriodX1.RESET;
                        PayrollPeriodX1.SETRANGE(Closed,FALSE);
                        IF PayrollPeriodX1.FINDFIRST THEN BEGIN
                          IF PayrollPeriodX1."Pay Date"=0D THEN BEGIN
                             ERROR('Pay Date is Not Filled. Please Fill it!!');
                            END;
                          END;
                        
                        //ERROR('STOP');
                        IF NOT CONFIRM('You are about to close the current Pay period are you sure you want to do this?'+ //
                        ' Make sure all reports are correct before closing the current pay period, Go ahead?',FALSE) THEN
                        EXIT;
                        
                        
                        
                        ClosingFunction.GetCurrentPeriod(Rec);
                        ClosingFunction.RUN;
                        
                        */

                    end;
                }
            }
        }
        area(processing)
        {
            action("&Create Period")
            {
                Caption = '&Create Period';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Create Payroll Period";
            }
        }
    }
}