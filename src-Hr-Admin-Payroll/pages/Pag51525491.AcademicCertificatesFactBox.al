page 51525491 "Academic Certificates FactBox"
{
    ApplicationArea = All;
    Caption = 'Academic Certificates FactBox';
    PageType = CardPart;
    SourceTable = "Applicant Online Qualification";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Attachement Name"; Rec."Attachement Name")
                {
                    ToolTip = 'Specifies the value of the Attachement Name field.', Comment = '%';
                    trigger OnDrillDown()
                    begin
                        LoanDocument;
                    end;
                }
            }
        }
    }

    procedure LoanDocument()
    var
        PortalSetup: Record "Portal Setup";
    begin
        if Rec."Attachement Name" <> '' then begin
            PortalSetup.Get;
            HyperLink(PortalSetup."Applicant Online File Path" + Rec."Attachement Name");
        end else begin
            Error(Rec."Qualification Code" + ' certificate not attached');
        end;
    end;
}