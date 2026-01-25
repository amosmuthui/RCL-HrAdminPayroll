page 52211557 "My Shifts"
{

    PageType = List;
    SourceTable = "Shift Line";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'My Shifts';
    // Editable = false;
    //SourceTableView = where("Employee No." = filter(UserId));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Shift Date"; Rec."Shift Date") { ApplicationArea = All; }
                field("Shift Type"; Rec."Shift Type") { ApplicationArea = All; }
                field("Task Assigned"; Rec."Task Assigned") { ApplicationArea = All; }
                field("Meal Order"; Rec."Meal Order") { ApplicationArea = All; }
                field("Leave Allocated"; Rec."Leave Allocated") { ApplicationArea = All; }
            }
        }
    }


}
