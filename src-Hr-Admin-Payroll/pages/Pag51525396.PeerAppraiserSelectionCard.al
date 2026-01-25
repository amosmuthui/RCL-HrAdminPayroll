page 51525396 "Peer Appraiser Selection Card"
{
    ApplicationArea = All;
    SourceTable = "Peer Appraisal Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Period; Rec.Period)
                {
                }
                field("Staff No"; Rec."Staff No")
                {
                }
                field("Peer Appraiser 1"; Rec."Peer Appraiser 1")
                {
                }
                field("Peer Appraiser 2"; Rec."Peer Appraiser 2")
                {
                }
                field("Peer Appraiser 3"; Rec."Peer Appraiser 3")
                {
                }
                field(Supervisor; Rec.Supervisor)
                {
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    Editable = false;
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Created On"; Rec."Created On")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send for Review")
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to send this document to the selected peers for appraisal?', false) = true then begin
                        Rec.Status := Rec.Status::"Pending Peer Appraisal";
                        Rec.Modify;
                        CurrPage.Close;
                    end else
                        Error('Process Aborted');
                end;
            }
        }
    }
}