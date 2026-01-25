page 51525310 "Employee Presents"
{
    ApplicationArea = All;

    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Employee presents";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Employee No."; Rec."Employee No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Start date"; Rec."Start date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field(Location; Rec.Location)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OK)
            {
                Caption = 'View Report';
                Promoted = true;
                PromotedCategory = Process;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SearchUnit.Run;
    end;

    var
    //SearchUnit: Codeunit "Receipts-Post";
}