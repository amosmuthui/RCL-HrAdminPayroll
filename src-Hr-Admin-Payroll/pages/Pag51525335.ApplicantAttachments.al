page 51525335 "Applicant Attachments"
{
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Portal Documents";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("DocumentNo."; Rec."DocumentNo.")
                {
                }
                field("Document Code"; Rec."Document Code")
                {
                }
                field("Document Description"; Rec."Document Description")
                {
                }
                field("Document Attached"; Rec."Document Attached")
                {
                }
                field("File Name"; Rec."File Name")
                {
                }
                field("Issue Date"; Rec."Issue Date")
                {
                }
                field("Expiry Date"; Rec."Expiry Date")
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
                        Error(Rec."Document Description" + ' ' + 'not attached');
                    end;
                end;
            }
        }
    }

    var
        PortalSetup: Record "Portal Setup";
}