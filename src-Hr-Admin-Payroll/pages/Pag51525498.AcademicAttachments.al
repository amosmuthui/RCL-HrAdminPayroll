page 51525498 "Academic Attachments"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Applicant Online Qualification";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Course Name"; Rec."Course Name")
                {
                    Caption = 'Qualification Name';
                }
                field("Attachement Name"; Rec."Attachement Name")
                {
                }
                field(Attached; Rec.Attached)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("View Document")
            {
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Attachement Name" <> '' then begin
                        PortalSetup.Get;
                        HyperLink(PortalSetup."Applicant Online File Path" + Rec."Attachement Name");
                    end else begin
                        Error(Rec."Qualification Code" + ' ' + 'not attached');
                    end;
                end;
            }
        }
    }

    var
        PortalSetup: Record "Portal Setup";
}