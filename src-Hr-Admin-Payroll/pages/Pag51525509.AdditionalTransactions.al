page 51525509 "Additional Transactions"
{
    ApplicationArea = All;
    Caption = 'Additional Transactions';
    PageType = List;
    SourceTable = "Additional Transactions";
    UsageCategory = Lists;

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
                field("Amount Type"; Rec."Amount Type")
                {
                    ToolTip = 'Specifies the value of the Amount Type field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
            }
        }
    }
}