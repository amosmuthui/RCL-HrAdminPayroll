page 51525430 "Training Events History"
{
    ApplicationArea = All;
    Caption = 'Events History';
    PageType = List;
    SourceTable = "Training Schedule Lines";
    UsageCategory = Lists;
    SourceTableView = where("Emp No." = filter(<> ''));

    layout
    {
        area(Content)
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
                field("Schedule No."; Rec."Schedule No.")
                {
                    Caption = 'Class No.';
                    ToolTip = 'Specifies the value of the Schedule No. field.', Comment = '%';
                }
                field("Training No."; Rec."Training No.")
                {
                    ToolTip = 'Specifies the value of the Course No. field.', Comment = '%';
                }
                field("Training Title"; Rec."Training Title")
                {
                    ToolTip = 'Specifies the value of the Event Title field.', Comment = '%';
                }
                field("Start Date"; Rec."Start Date")
                {
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the value of the Scheduled Date field.', Comment = '%';
                }
                field("End Date"; Rec."End Date")
                {
                    Caption = 'End Date';
                    ToolTip = 'Specifies the value of the Completion Date field.', Comment = '%';
                }
                field("Trainer Category"; Rec."Trainer Category")
                {
                    ToolTip = 'Specifies the value of the Trainer Category field.', Comment = '%';
                }
                field("Trainer Name"; Rec."Trainer Name")
                {
                    ToolTip = 'Specifies the value of the Trainer Name field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Renew By"; Rec."Renew By")
                {
                    ToolTip = 'Specifies the value of the Renew By field.', Comment = '%';
                }
                field("Certificate Serial No."; Rec."Certificate Serial No.")
                {
                    ToolTip = 'Specifies the value of the Certificate Serial No. field.', Comment = '%';
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
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies the value of the Frequency field.', Comment = '%';
                }
                field("Training Report"; Rec."Training Report")
                {
                    ToolTip = 'Specifies the value of the Training Report field.';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Department Name"; Rec."Department Name")
                {
                    ToolTip = 'Specifies the value of the Department Name field.', Comment = '%';
                }
                field(Section; Rec.Section)
                {
                    ToolTip = 'Specifies the value of the Section field.';
                }
            }
        }
    }
}