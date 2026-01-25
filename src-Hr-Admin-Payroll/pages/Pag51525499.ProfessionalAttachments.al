page 51525499 "Professional Attachments"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Online Professional Membership";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Level Name"; Rec."Level Name")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("File Name"; Rec."File Name")
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
                    if Rec."File Name" <> '' then begin
                        PortalSetup.Get;
                        HyperLink(PortalSetup."Applicant Online File Path" + Rec."File Name");
                    end else begin
                        Error(Rec.Description + ' ' + 'not attached');
                    end;
                end;
            }
        }
    }

    var
        PortalSetup: Record "Portal Setup";
}