page 51525353 Earnings
{
    ApplicationArea = All;
    DeleteAllowed = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Earnings;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Country; Rec.Country)
                {

                }
                field("Code"; Rec.Code)
                {
                }
                field("Universal Title"; Rec."Universal Title")
                { }
                field(Description; Rec.Description)
                {
                }
                field("Is Statutory"; Rec."Is Statutory")
                { }
                field("Show on Master Roll"; Rec."Show on Master Roll")
                {
                }
                field("Display Order"; Rec."Display Order")
                { }
                /*field("Basic Pay Arrears"; Rec."Basic Pay Arrears")
                {
                }
                field("Responsibility Allowance Code"; Rec."Responsibility Allowance Code")
                {
                }
                field("Commuter Allowance Code"; Rec."Commuter Allowance Code")
                {
                }
                field("House Allowance Code"; Rec."House Allowance Code")
                {
                }*/
                field(Recurs; Rec.Recurs)
                {
                }
                field("Earning Type"; Rec."Earning Type")
                {
                }
                field("Applies to All"; Rec."Applies to All")
                {
                }
                field("G/L Account"; Rec."G/L Account")
                {
                }
                /*field("PE Activity Code"; Rec."PE Activity Code")
                {
                }*/
                field(Block; Rec.Block)
                {
                }
                field("Pay Type"; Rec."Pay Type")
                {
                }
                /*field(Weekend; Rec.Weekend)
                {
                }
                field(Weekday; Rec.Weekday)
                {
                }
                field("ProRata Leave"; Rec."ProRata Leave")
                {
                }*/
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                }
                field("Flat Amount"; Rec."Flat Amount")
                {
                }
                field(Percentage; Rec.Percentage)
                {
                }
                field("Constant Amount"; Rec."Constant Amount")
                { }
                field("Earning Table"; Rec."Earning Table")
                {
                }
                field(Taxable; Rec.Taxable)
                {
                }
                field("Taxable Percentage"; Rec."Taxable Percentage")
                {
                }
                field("Reduces Tax"; Rec."Reduces Tax")
                {
                }
                field("Reduces Taxable Amt"; Rec."Reduces Taxable Amt")
                {
                }
                field("Exclude from Calculations"; Rec."Exclude from Calculations")
                { }
                field("Exclude from Payroll"; Rec."Exclude from Payroll")
                { }
                field("Non-Cash Benefit"; Rec."Non-Cash Benefit")
                {
                }
                /*field(Months; Rec.Months)
                {
                }
                field(Quarters; Rec.Quarters)
                {
                }
                field("Overtime Factor"; Rec."Overtime Factor")
                {
                }*/
                field(OverTime; Rec.OverTime)
                {
                }
                /*field("Low Interest Benefit"; Rec."Low Interest Benefit")
                {
                }*/
                field("Minimum Limit"; Rec."Minimum Limit")
                {
                }
                field("Maximum Limit"; Rec."Maximum Limit")
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                }
                field("Max Taxable Amount"; Rec."Max Taxable Amount")
                {
                }
                /*field(CoinageRounding; Rec.CoinageRounding)
                {
                }*/
                field("Show on Report"; Rec."Show on Report")
                {
                }
                /*field("Show Balance"; Rec."Show Balance")
                {
                }*/
                /*field("Total Days"; Rec."Total Days")
                {
                }
                field(OverDrawn; Rec.OverDrawn)
                {
                }
                field(Fringe; Rec.Fringe)
                {
                }
                field("Market Rate"; Rec."Market Rate")
                {
                }
                field("Company Rate"; Rec."Company Rate")
                {
                }*/
                field("Basic Salary Code"; Rec."Basic Salary Code")
                {
                }
                /*field("Time Sheet"; Rec."Time Sheet")
                {
                }
                field("Salary Recovery"; Rec."Salary Recovery")
                {
                }*/
                field(Board; Rec.Board)
                {
                }
                field("Fringe Benefit"; Rec."Fringe Benefit")
                {
                }
                field("Morgage Relief"; Rec."Morgage Relief")
                {
                }
                field(Bonus; Rec.Bonus)
                {
                }
                /*field("Leave Allowance Code"; Rec."Leave Allowance Code")
                {
                }
                /*field(Month; Rec.Month)
                {
                }
                field("Defined Month"; Rec."Defined Month")
                {
                }*/
                field("Include in Housing Levy"; Rec."Include in Housing Levy")
                {
                }
                field("Housing Allowance"; Rec."Housing Allowance")
                {
                }
                field("Transport Allowance"; Rec."Transport Allowance")
                {
                }
                field("Gross Pay"; Rec."Gross Pay")
                {
                }
                field("Insurance Relief"; Rec."Insurance Relief")
                {

                }
                field(Proratable; Rec.Proratable)
                {

                }
                field("Special Transport Allowance"; Rec."Special Transport Allowance")
                {

                }
                field("Is Insurable Earning"; Rec."Is Insurable Earning")
                {
                }
                field("Is Contractual Amount"; Rec."Is Contractual Amount")
                {

                }
                field("Goes to Matrix"; Rec."Goes to Matrix")
                {

                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Earnings Mass update")
            {
                Caption = 'Earnings Mass update';
                action("Mass Update Earnings")
                {
                    Caption = 'Mass Update Earnings';
                    RunPageOnRec = true;

                    trigger OnAction()
                    begin
                        // EarningsMassUpdate.GetEarnings(Rec);
                        //EarningsMassUpdate.RUN;





                        /*Actions:=Actions::Add;
                        Sources:=Sources::Payment;
                        AssignReport.UsePayment(Rec,Actions,Sources);
                        AssignReport.RUN;
                        */

                    end;
                }
                action("Import Payroll data")
                {
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                }
            }
        }
    }

    var
        Payment: Record Earnings temporary;
        PaymentCode: Code[10];
        "Actions": Option Add,edit,Delete;
        Sources: Option Payment,Deduction,Saving;
}