page 51525409 "Training Schedule Lines"
{
    ApplicationArea = All;
    Caption = 'Participants';
    PageType = ListPart;
    SourceTable = "Training Schedule Lines";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Emp No."; Rec."Emp No.")
                {
                    ToolTip = 'Specifies the value of the Emp No. field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field("Certificate Serial No."; Rec."Certificate Serial No.")
                { }
                field("Renew By"; Rec."Renew By")
                { }
                field(Type; Rec.Type)
                { }
                field(Section; Rec.Section)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Section field.';
                }
                field("Training Report"; Rec."Training Report")
                {
                    ToolTip = 'Specifies the value of the Training Report field.';
                }
                field("Line_No"; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Print Cert"; 'Print Cert')
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        ScheduleLine: Record "Training Schedule Lines";
                    begin
                        ScheduleLine.Reset();
                        ScheduleLine.SetRange("Schedule No.", Rec."Schedule No.");
                        ScheduleLine.SetRange("Emp No.", Rec."Emp No.");
                        if ScheduleLine.FindFirst() then begin
                            ScheduleLine.CalcFields("Trainer Category");
                            if ScheduleLine."Trainer Category" = ScheduleLine."Trainer Category"::Internal then
                                Report.Run(Report::"Training Certificate Designed", true, false, ScheduleLine)
                            else
                                Error('You cannot generate certificate for external classes!');
                        end;
                    end;
                }
                field(Attachments; Rec.CountCertificates())
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
                field("Legacy Certificate Link"; Rec."Certificate Link")
                {
                    Caption = 'Legacy Certificate Link';
                    Visible = true;
                    ExtendedDatatype = URL;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Certificates';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                    TrainingScheduleLines: Record "Training Schedule Lines";
                begin
                    CurrPage.SetSelectionFilter(TrainingScheduleLines);
                    if TrainingScheduleLines.FindFirst() then begin
                        RecRef.GetTable(TrainingScheduleLines);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        //DocumentAttachmentDetails.SetFilters(FALSE, TrainingScheduleLines."Schedule No." + '-' + TrainingScheduleLines."Emp No." + '-' + Format(TrainingScheduleLines."Line No."));
                        DocumentAttachmentDetails.RunModal;
                    end;
                end;
            }
        }
    }
}