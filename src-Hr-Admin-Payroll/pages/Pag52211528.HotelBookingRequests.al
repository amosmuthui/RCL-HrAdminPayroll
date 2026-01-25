page 52211528 "Hotel Booking Requests"
{
    ApplicationArea = All;
    Caption = 'Hotel Booking Requests';
    PageType = List;
    SourceTable = "Hotel Booking Requests";
    UsageCategory = Lists;
    CardPageId = "Hotel Booking Request";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Requested By Emp No."; Rec."Requested By Emp No.")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp No. field.', Comment = '%';
                }
                field("Requested By Emp Name"; Rec."Requested By Emp Name")
                {
                    ToolTip = 'Specifies the value of the Requested By Emp Name field.', Comment = '%';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ToolTip = 'Specifies the value of the Country Code field.', Comment = '%';
                }
                field("Country Name"; Rec."Country Name")
                { }
                field("Hotel Code"; Rec."Hotel Code")
                {
                    ToolTip = 'Specifies the value of the Hotel Code field.', Comment = '%';
                }
                field("Hotel Name"; Rec."Hotel Name")
                {
                    ToolTip = 'Specifies the value of the Hotel Name field.', Comment = '%';
                }
                field("Check-in Date"; Rec."Check-in Date")
                {
                    ToolTip = 'Specifies the value of the Check-in Date field.', Comment = '%';
                }
                field("Check-out Date"; Rec."Check-out Date")
                {
                    ToolTip = 'Specifies the value of the Check-out Date field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("Reservation Status"; Rec."Reservation Status")
                {
                    ToolTip = 'Specifies the value of the Reservation Status field.', Comment = '%';
                }
            }
        }
    }
}
