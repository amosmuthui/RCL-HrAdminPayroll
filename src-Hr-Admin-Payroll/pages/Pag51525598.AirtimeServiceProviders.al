page 51525598 "Airtime Service Providers"
{
    ApplicationArea = All;
    Caption = 'Airtime Service Providers';
    PageType = List;
    SourceTable = "Airtime Service Providers";
    UsageCategory = Lists;

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
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.', Comment = '%';
                }
                field(Default; Rec.Default)
                {
                    ToolTip = 'Specifies the value of the Default field.', Comment = '%';
                }
            }
        }
    }
}
