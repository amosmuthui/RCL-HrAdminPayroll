page 52211559 "Attendance Ledger List"
{
    PageType = List;
    SourceTable = "Attendance Ledger";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Employee No."; Rec."Employee No.") { }
                field("Attendance Date"; Rec."Attendance Date") { }
                field("First In Time"; Rec."First In Time") { }
                field("Last Out Time"; Rec."Last Out Time") { }
                field("Worked Hours"; Rec."Worked Hours") { }
                field(Status; Rec.Status) { }
                field("Overtime Hours"; Rec."Overtime Hours") { }
            }
        }
    }
}
