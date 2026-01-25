page 52211526 "HR Admin Cues"
{
    ApplicationArea = All;
    Caption = 'HR Admin Cues';
    PageType = ListPart;
    SourceTable = "HR Cues";

    layout
    {
        area(Content)
        {
            cuegroup(Group)
            {
                field("Airtime Allocation Batches"; Rec."Airtime Allocation Batches")
                {
                    ToolTip = 'Specifies the value of the Airtime Allocation Batches field.', Comment = '%';
                }
                field("Airtime Requests"; Rec."Airtime Requests")
                {
                    ToolTip = 'Specifies the value of the Airtime Requests field.', Comment = '%';
                }

                field(Hotels; Rec.Hotels)
                { }
                field("Pending Hotel Bookings"; Rec."Pending Bookings")
                { }
                field(Reservations; Rec.Reservations)
                { }
                field(Cancellations; Rec.Cancellations)
                { }
                field("Pending Refreshment Requests"; Rec."Pending Refreshment Requests")
                { }
                field("Approved Refreshment Requests"; Rec."Approved Refreshment Requests")
                { }
                field(Rooms; Rec.Rooms)
                { }
                field("Pending Room Requests"; Rec."Pending Room Requests")
                { }
                field("Approved Room Requests"; Rec."Approved Room Requests")
                { }
                field("Letter Templates"; Rec."Letter Templates")
                { }
                field("Pending Req Fees Requests"; Rec."Pending Req Fees Requests")
                { }
                field("Approved Req Fees Requests"; Rec."Approved Req Fees Requests")
                { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}
