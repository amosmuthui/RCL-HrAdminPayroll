page 51525526 "Succesion Planning"
{
    ApplicationArea = All;
    PageType = Card;
    SourceTable = Employee;
    SourceTableView = WHERE(Status = CONST(Active));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = true;
                field("No."; Rec."No.")
                {
                    Editable = true;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = false;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Editable = false;
                }
                field("Last Name"; Rec."Last Name")
                {
                    Editable = false;
                }
                field(Initials; Rec.Initials)
                {
                    Editable = false;
                }
                field("ID Number"; Rec."ID Number")
                {
                    Editable = false;
                }
                field(Gender; Rec.Gender)
                {
                    Editable = false;
                }
                field(Position; Rec.Position)
                {
                    Editable = false;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    Editable = false;
                }
                field("Date Of Join"; Rec."Date Of Join")
                {
                    Editable = false;
                }
                field("Position To Succeed"; Rec."Position To Succeed")
                {
                }
                field("Succesion Date"; Rec."Succesion Date")
                {
                }
            }
            label("Position to Succeed Requirements")
            {
                Caption = 'Position to Succeed Requirements';
            }
            part("Position To Succed Educational Needs"; "Job Education Needs")
            {
                Caption = 'Position To Succed Educational Needs';
                SubPageLink = "Job ID" = FIELD("Position To Succeed");
            }
            part("Current Position Educational Needs"; "Job Education Needs")
            {
                Caption = 'Current Position Educational Needs';
                SubPageLink = "Job ID" = FIELD("Job ID");
                Visible = false;
            }
            part("Position To Succed Professional Certifications"; "Professional Bodies Needs")
            {
                Caption = 'Position To Succed Professional Certifications';
                SubPageLink = "Job ID" = FIELD("Position To Succeed");
            }
            part("Current Position Professional Certifications"; "Professional Bodies Needs")
            {
                Caption = 'Current Position Professional Certifications';
                SubPageLink = "Job ID" = FIELD("Job ID");
                Visible = false;
            }
            part("Position To Succed Professional  Membership"; "Job Professional Bodies")
            {
                Caption = 'Position To Succed Professional  Membership';
                SubPageLink = "Job ID" = FIELD("Position To Succeed");
            }
            part("Current Position Professional Membership"; "Job Professional Bodies")
            {
                Caption = 'Current Position Professional Membership';
                SubPageLink = "Job ID" = FIELD("Job ID");
                Visible = false;
            }
            part(Control9; "Employee Qualification")
            {
                SubPageLink = "Employee No." = FIELD("No.");
            }
            label(Control1000000030)
            {
                ShowCaption = false;
            }
            part(KPA; "Succession Requirements")
            {
                SubPageLink = "Employee No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Action8)
            {
            }
        }
    }

    var
        JobReq: Record "Leave Recall";
        Text19062331: Label 'Requirements Gaps';
        Text19065507: Label 'Succesion Training and Development Requirements';
}