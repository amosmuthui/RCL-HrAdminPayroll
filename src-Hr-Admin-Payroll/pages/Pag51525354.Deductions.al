page 51525354 Deductions
{
    ApplicationArea = All;
    DataCaptionFields = "Code", Description;
    DeleteAllowed = true;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Deductions;

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
                field("Is Statutory"; Rec."Is Statutory")
                { }
                /*field("Main Deduction Code"; Rec."Main Deduction Code")
                {
                }*/
                field(Description; Rec.Description)
                {
                }
                field("Medical Insurance"; Rec."Medical Insurance")
                {
                }
                field("Medical Insurance Category"; Rec."Medical Insurance Category")
                { }
                /*field(Individual; Rec.Individual)
                {
                    Caption = 'Receivable (Personalised)';
                }*/
                field("Show on Payslip Information"; Rec."Show on Payslip Information")
                {
                }
                field("Display Order"; Rec."Display Order")
                {
                }
                /*field("Institution Code"; Rec."Institution Code")
                {
                }*/
                /*field("Sort Code"; Rec."Sort Code")
                {
                }*/
                field("Insurance Code"; Rec."Insurance Code")
                {
                }
                /*field(vendor; Rec.vendor)
                {
                }*/
                field(Block; Rec.Block)
                {
                }
                field("Pension Limit Percentage"; Rec."Pension Limit Percentage")
                {
                }
                field("Pension Limit Amount"; Rec."Pension Limit Amount")
                {
                }
                field("Applies to All"; Rec."Applies to All")
                {
                }
                field("Show on Master Roll"; Rec."Show on Master Roll")
                {
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    Visible = true;
                }
                /*field("PE Activity Code"; Rec."PE Activity Code")
                {
                }
                field("G/L Account Employer"; Rec."G/L Account Employer")
                {
                    Visible = true;
                }*/
                field("Total Amount Employer"; Rec."Total Amount Employer")
                {
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                }
                field("Deduction Table"; Rec."Deduction Table")
                {
                }
                field(Percentage; Rec.Percentage)
                {
                }
                field("Percentage Employer"; Rec."Percentage Employer")
                {
                }
                field("Flat Amount"; Rec."Flat Amount")
                {
                }
                field("Base Amount"; Rec."Base Amount")
                { }
                /*field("Voluntary Percentage"; Rec."Voluntary Percentage")
                {
                }*/
                field("Constant Amount"; Rec."Constant Amount")
                {
                    Visible = false;
                }
                field("PAYE Code"; Rec."PAYE Code")
                {
                }
                field("Main Loan Code"; Rec."Main Loan Code")
                {
                    Visible = false;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Visible = false;
                }
                field("Flat Amount Employer"; Rec."Flat Amount Employer")
                {
                }
                field("Pension Scheme"; Rec."Pension Scheme")
                {
                }
                /*field("Pension Arrears"; Rec."Pension Arrears")
                {
                }
                field("Gratuity Arrears"; Rec."Gratuity Arrears")
                {
                }*/
                field(Gratuity; Rec.Gratuity)
                {
                }
                field("Tax deductible"; Rec."Tax deductible")
                {
                    Caption = 'Reduces Taxable Amt';
                }
                field("Reduces Gross"; Rec."Reduces Gross")
                { }
                /*field(Shares; Rec.Shares)
                {
                }
                field(Loan; Rec.Loan)
                {
                }
                field("Non-Interest Loan"; Rec."Non-Interest Loan")
                {
                }
                field("Loan Type"; Rec."Loan Type")
                {
                }*/
                field("Show Balance"; Rec."Show Balance")
                {
                }
                field("Exclude when on Leave"; Rec."Exclude when on Leave")
                {
                }
                /*field(CoinageRounding; Rec.CoinageRounding)
                {
                }
                field("Show on report"; Rec."Show on report")
                {
                }
                field("Co-operative"; Rec."Co-operative")
                {
                }
                field("Salary Recovery"; Rec."Salary Recovery")
                {
                }*/
                field(Informational; Rec.Informational)
                {
                }
                field(Board; Rec.Board)
                {
                }
                /*field("Voluntary Code"; Rec."Voluntary Code")
                {
                }
                field(Voluntary; Rec.Voluntary)
                {
                }*/
                field("NHIF Deduction"; Rec."NHIF Deduction")
                {
                }
                field("NSSF Deduction"; Rec."NSSF Deduction")
                {
                }
                field("NSSF Tier"; Rec."NSSF Tier")
                {
                }
                /*field("NITA Deduction"; Rec."NITA Deduction")
                {
                }
                field("HELB Deduction"; Rec."HELB Deduction")
                {
                }*/
                field("Employer Contibution Taxed"; Rec."Employer Contibution Taxed")
                {
                }
                /*field("Normal Deduction"; Rec."Normal Deduction")
                {
                }*/
                field("Housing Levy"; Rec."Housing Levy")
                {
                }
                /*field("Housing Levy Arrears"; Rec."Housing Levy Arrears")
                {
                }
                field("Social Security"; Rec."Social Security")
                {
                }
                field("Community-Based Health"; Rec."Community-Based Health")
                {
                }
                field("Maternity Deduction"; Rec."Maternity Deduction")
                {
                }*/
            }
        }
    }

    actions
    {
    }

    var
        Axion: Option Add,Edit,Delete;
}