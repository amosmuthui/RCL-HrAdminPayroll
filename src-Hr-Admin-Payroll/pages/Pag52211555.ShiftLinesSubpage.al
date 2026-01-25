page 52211555 "Shift Lines Subpage"

{
    PageType = ListPart;
    SourceTable = "Shift Line";
    ApplicationArea = All;
    Caption = 'Shift Employees';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shift Type"; Rec."Shift Type")
                {
                    ApplicationArea = All;
                }
                field("Task Assigned"; Rec."Task Assigned")
                {
                    ApplicationArea = All;
                }
                field("Shift Start Time"; Rec."Shift Start Time")
                {

                }
                field("Shift End Time"; Rec."Shift End Time")
                {

                }
                field("Meal Order"; Rec."Meal Order")
                {
                    ApplicationArea = All;
                }
                field("Meal Order Description"; Rec."Meal Order Description")
                {

                }
                field("Is Public Holiday"; Rec."Is Public Holiday")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Leave Allocated"; Rec."Leave Allocated")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
