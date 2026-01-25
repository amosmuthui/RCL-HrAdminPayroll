page 52211527 Hotels
{
    ApplicationArea = All;
    Caption = 'Hotels';
    PageType = List;
    SourceTable = Hotels;
    UsageCategory = Lists;
    CardPageId = "Hotel Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.', Comment = '%';
                }
                field("Country Name"; Rec."Country Name")
                { }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.', Comment = '%';
                }
                field(Block; Rec.Block)
                {
                    ToolTip = 'Specifies the value of the Block field.', Comment = '%';
                }
                field("Contact Person Name"; Rec."Contact Person Name")
                {
                    ToolTip = 'Specifies the value of the Contact Person Name field.', Comment = '%';
                }
                field("Contact Person E-Mail"; Rec."Contact Person E-Mail")
                {
                    ToolTip = 'Specifies the value of the Contact Person E-Mail field.', Comment = '%';
                }
                field("Contact Person Phone"; Rec."Contact Person Phone")
                {
                    ToolTip = 'Specifies the value of the Contact Person Phone field.', Comment = '%';
                }
            }
        }
    }
}
