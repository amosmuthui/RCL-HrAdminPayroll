page 51525544 "Claim Lines"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Claim Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Claim No"; Rec."Claim No")
                {
                    Visible = false;
                }
                field("Employee No"; Rec."Employee No")
                {
                    NotBlank = true;
                    Visible = true;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    NotBlank = true;
                }
                field("Visit Date"; Rec."Visit Date")
                {
                    NotBlank = true;
                }
                field("Policy Start Date"; Rec."Policy Start Date")
                {
                }
                field("Patient No"; Rec."Patient No")
                {
                    Caption = 'Dependant';
                    NotBlank = true;
                }
                field("Patient Name"; Rec."Patient Name")
                {
                    NotBlank = true;
                }
                field(Relationship; Rec.Relationship)
                {
                }
                field("Hospital/Specialist"; Rec."Hospital/Specialist")
                {
                    NotBlank = true;
                }
                field("Line No"; Rec."Line No")
                {
                    Visible = false;
                }
                field("Claim Type"; Rec."Claim Type")
                {
                }
                field("Invoice Number"; Rec."Invoice Number")
                {
                    Caption = 'Invoice Number/Receipt No';
                    NotBlank = true;
                }
                field(Amount; Rec.Amount)
                {
                    NotBlank = true;
                }
                field(Settled; Rec.Settled)
                {
                }
                field("Cheque No"; Rec."Cheque No")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Claim Type" := Rec."Claim Type"::"Out Patient";
    end;
}