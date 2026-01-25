page 51525455 "Vacant Establishments"
{
    ApplicationArea = All;
    Editable = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Company Jobs";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Job ID"; Rec."Job ID")
                {
                }
                field("Job Description"; Rec."Job Description")
                {
                    Caption = 'Job Designation';
                }
                field("No of Posts"; Rec."No of Posts")
                {
                    Caption = 'Approved Positions';
                }
                field("Occupied Establishments"; Rec."Occupied Establishments")
                {
                    Caption = 'In Position';
                }
                field(Variance; Rec.Variance)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        Rec.Reset;
        if Rec.Find('-') then begin
            repeat
                Rec.CalcFields("Occupied Establishments");
                // MESSAGE('%1',"Occupied Position");
                Rec."Vacant Establishments" := Rec."No of Posts" - Rec."Occupied Establishments";
                Rec.Variance := Rec."No of Posts" - Rec."Occupied Establishments";
                Rec.Modify;
            until Rec.Next = 0;
        end;
        Rec.Reset;
        Rec.SetCurrentKey("Vacant Establishments");
        Rec.SetFilter("Vacant Establishments", '>%1', 0);
    end;
}