page 52211531 "Hotel Card"
{
    ApplicationArea = All;
    Caption = 'Hotel Card';
    PageType = Card;
    SourceTable = Hotels;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
            }
            group("Contact Person")
            {
                field("Contact Person Name"; Rec."Contact Person Name")
                {
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Contact Person Name field.', Comment = '%';
                }
                field("Contact Person E-Mail"; Rec."Contact Person E-Mail")
                {
                    Caption = 'E-Mail';
                    ToolTip = 'Specifies the value of the Contact Person E-Mail field.', Comment = '%';
                }
                field("Contact Person Phone"; Rec."Contact Person Phone")
                {
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the value of the Contact Person Phone field.', Comment = '%';
                }
            }
        }
    }
}
