page 52211556 "Shift List"
{

    PageType = List;
    SourceTable = "Shift Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Shifts';
    CardPageId = "Shift Card";
    SourceTableView = where(Posted = const(false));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Shift Date"; Rec."Shift Start Date") { ApplicationArea = All; }
                field("Shift End Date"; Rec."Shift End Date")
                {

                }
                field("Created by"; Rec."Created by")
                {

                }
                field("Shift Type"; Rec."Shift Type") { ApplicationArea = All; }
                field(Status; Rec."Approval Status") { ApplicationArea = All; }
                field(Posted; Rec.Posted) { ApplicationArea = All; }
            }
        }
    }
}
