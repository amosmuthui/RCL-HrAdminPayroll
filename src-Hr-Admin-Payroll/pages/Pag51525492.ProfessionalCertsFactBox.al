page 51525492 "Professional Certs FactBox"
{
    ApplicationArea = All;
    Caption = 'Professional Certs FactBox';
    PageType = CardPart;
    SourceTable = "Online Professional Membership";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Level Name"; Rec."Level Name")
                {
                    ToolTip = 'Specifies the value of the Level Name field.', Comment = '%';
                    trigger OnDrillDown()
                    begin
                        LoanDocument;
                    end;
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
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
        if Rec."File Name" <> '' then begin
            PortalSetup.Get;
            HyperLink(PortalSetup."Applicant Online File Path" + Rec."File Name");
        end else begin
            Error(Rec."Level Name" + ' certificate not attached');
        end;
    end;
}