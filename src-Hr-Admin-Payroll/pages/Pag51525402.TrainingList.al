page 51525402 "Training List"
{
    ApplicationArea = All;
    CardPageID = "Training Request";
    DeleteAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Training Request";
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                    Editable = false;
                }
                field("Request Date"; Rec."Request Date")
                {
                    Editable = false;
                }
                field("Employee No"; Rec."Employee No")
                {
                    Editable = false;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                }
                field("Department Code"; Rec."Department Code")
                {
                    Editable = false;
                }
                field(Designation; Rec.Designation)
                {
                    Editable = false;
                }
                field("No. Of Days"; Rec."No. Of Days")
                {
                    Editable = false;
                }
                field("Training Insitution"; Rec."Training Insitution")
                {
                    Editable = false;
                }
                field("Local Travel"; Rec."Local Travel")
                {
                    Caption = 'Local Training';
                    Editable = false;
                }
                field("Local Destination"; Rec."Local Destination")
                {
                    Caption = 'Local Destination';
                    Editable = false;
                }
                field("International Travel"; Rec."International Travel")
                {
                    Caption = 'International Training';
                    Editable = false;
                }
                field("International Destination"; Rec."International Destination")
                {
                    Editable = false;
                }
                field("Tuition Fee"; Rec."Tuition Fee")
                {
                    Editable = false;
                }
                field("Per Diem"; Rec."Per Diem")
                {
                    Editable = false;
                }
                field("Air Ticket"; Rec."Air Ticket")
                {
                    Editable = false;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Editable = false;
                }
                field("Course Title"; Rec."Course Title")
                {
                    Editable = false;
                }
                field("Training Objective"; Rec."Training Objective")
                {
                }
                field("Planned Start Date"; Rec."Planned Start Date")
                {
                    Editable = false;
                }
                field("Planned End Date"; Rec."Planned End Date")
                {
                    Editable = false;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    Editable = false;
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                    Editable = false;
                }
                field(Currency; Rec.Currency)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}