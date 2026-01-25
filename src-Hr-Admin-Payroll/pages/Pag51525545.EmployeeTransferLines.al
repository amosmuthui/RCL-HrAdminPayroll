page 51525545 "Employee Transfer Lines"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Employee Transfer Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transfer Type"; Rec."Transfer Type")
                {
                    Visible = true;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    Editable = true;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    Editable = false;
                }
                field("Current Category"; Rec."Current Category")
                {
                    Editable = false;
                }
                field("Current Job Title Code"; Rec."Current Job Title Code")
                {
                    Visible = false;
                }
                field("Current Job Title"; Rec."Current Job Title")
                {
                    Visible = false;
                }
                field("Current Directorate"; Rec."Current Directorate")
                {
                    Visible = false;
                }
                field("Current Directorate Name"; Rec."Current Directorate Name")
                {
                    Visible = false;
                }
                field("Current Department"; Rec."Current Department")
                {
                    Visible = false;
                }
                field("Current Location Code"; Rec."Current Location Code")
                {
                    Visible = false;
                }
                field("Current Location"; Rec."Current Location")
                {
                    Visible = false;
                }
                field("New Category"; Rec."New Category")
                {
                }
                field("New Job Title Code"; Rec."New Job Title Code")
                {
                }
                field("New Job Title"; Rec."New Job Title")
                {
                }
                field("New Directorate"; Rec."New Directorate")
                {
                }
                field("New Directorate Name"; Rec."New Directorate Name")
                {
                }
                field("New Department"; Rec."New Department")
                {
                    Caption = 'New Department';
                }
                field("New Location Code"; Rec."New Location Code")
                {
                }
                field("New Location"; Rec."New Location")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Date Of Current Appointment"; Rec."Date Of Current Appointment")
                {
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                    Visible = false;
                }
                field(Remark; Rec.Remark)
                {
                }
            }
        }
    }

    actions
    {
    }
}