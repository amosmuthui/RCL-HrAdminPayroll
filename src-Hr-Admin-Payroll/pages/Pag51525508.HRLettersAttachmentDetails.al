page 51525508 "HR Letters Attachment Details"
{
    ApplicationArea = All;
    Caption = 'HR Letters';
    DelayedInsert = true;
    Editable = true;
    PageType = Worksheet;
    SourceTable = "Document Attachment";
    //  SourceTableView = SORTING(ID, "Table ID") where("Doc Category" = const("HR Letters"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                /*   field("Doc Attachment Description"; Rec."Doc Attachment Description")
                  {
                  } */
                field(Name; Rec."File Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the filename of the attachment.';

                    trigger OnDrillDown()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        FileManagement: Codeunit "File Management";
                        FileName: Text;
                    begin
                        if Rec."Document Reference ID".HasValue then
                            Rec.Export(true)
                        else begin
                            if Rec."File Name" <> 'Select File...' then begin
                                //accommodate cases where only the link exists
                                /*    if Rec."Portal Doc URL" <> '' then
                                       HyperLink(Rec."Portal Doc URL"); */
                            end else begin
                                FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
                                if FileName <> '' then
                                    Rec.SaveAttachment(FromRecRef, FileName, TempBlob);
                                CurrPage.Update(false);
                            end;
                        end;
                    end;
                }
                /*  field("Show on Portal"; Rec."Show on Portal")
                 { }
                 field(Viewed; Rec.Viewed)
                 {
                     Editable = false;
                 } */
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the file extension of the attachment.';
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of document that the attachment is.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the user who attached the document.';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the document was attached.';
                }
                field("Document Flow Purchase"; Rec."Document Flow Purchase")
                {
                    ApplicationArea = All;
                    CaptionClass = GetCaptionClass(9);
                    Editable = FlowFieldsEditable;
                    ToolTip = 'Specifies if the attachment must flow to transactions.';
                    Visible = PurchaseDocumentFlow;
                }
                field("Document Flow Sales"; Rec."Document Flow Sales")
                {
                    ApplicationArea = All;
                    CaptionClass = GetCaptionClass(11);
                    Editable = FlowFieldsEditable;
                    ToolTip = 'Specifies if the attachment must flow to transactions.';
                    Visible = SalesDocumentFlow;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Preview)
            {
                ApplicationArea = All;
                Caption = 'Preview';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Get a preview of the attachment.';

                trigger OnAction()
                begin
                    if Rec."File Name" <> '' then
                        Rec.Export(true);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        FlowFieldsEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."File Name" := SelectFileTxt;
        /*  Rec."Doc Category" := Rec."Doc Category"::"HR Letters";
         Rec."Show on Portal" := true; */
    end;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Reset();
        UserSetup.SetRange("Can View HR Letters", true);
        if not UserSetup.FindFirst() then
            Error('You are not authorized to view this page!');

        //CannotModify := FALSE;
        if CannotModify then
            CurrPage.Editable := false;

        if AttachDocNo <> '' then
            Rec.SetRange("No.", AttachDocNo);
    end;

    var
        FromRecRef: RecordRef;
        SalesDocumentFlow: Boolean;
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        ImportTxt: Label 'Attach a document.';
        SelectFileTxt: Label 'Select File...';
        PurchaseDocumentFlow: Boolean;
        FlowToPurchTxt: Label 'Flow to Purch. Trx';
        FlowToSalesTxt: Label 'Flow to Sales Trx';
        FlowFieldsEditable: Boolean;
        CannotModify: Boolean;
        AttachDocNo: Code[30];

    local procedure GetCaptionClass(FieldNo: Integer): Text
    begin
        if SalesDocumentFlow and PurchaseDocumentFlow then
            case FieldNo of
                9:
                    exit(FlowToPurchTxt);
                11:
                    exit(FlowToSalesTxt);
            end;
    end;

    procedure OpenForRecRef(RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        Rec.Reset;

        FromRecRef := RecRef;

        //MESSAGE('%1',RecRef.NUMBER);
        Rec.SetRange("Table ID", RecRef.Number);

        if RecRef.Number = DATABASE::Item then begin
            SalesDocumentFlow := true;
            PurchaseDocumentFlow := true;
        end;

        case RecRef.Number of
            DATABASE::Customer,
          DATABASE::"Sales Header",
          DATABASE::"Sales Line",
          DATABASE::"Sales Invoice Header",
          DATABASE::"Sales Invoice Line",
          DATABASE::"Sales Cr.Memo Header",
          DATABASE::"Sales Cr.Memo Line":
                SalesDocumentFlow := true;
            DATABASE::Vendor,
          DATABASE::"Purchase Header",
          DATABASE::"Purchase Line",
          DATABASE::"Purch. Inv. Header",
          DATABASE::"Purchase Header Archive",
          DATABASE::"Purch. Inv. Line",
          DATABASE::"Purch. Cr. Memo Hdr.",
          DATABASE::"Purch. Cr. Memo Line":
                PurchaseDocumentFlow := true;
        end;

        case RecRef.Number of
            DATABASE::Customer,
            DATABASE::Vendor,
            DATABASE::Item,
            DATABASE::Employee,
            DATABASE::"Fixed Asset",
            DATABASE::Job,
            DATABASE::"Payroll Processing Header",
            DATABASE::"Recruitment Needs",
            DATABASE::"Contract Management Header",
            DATABASE::Resource:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Header",
            DATABASE::"Sales Line",
            DATABASE::"Purchase Header",
            DATABASE::"Purchase Line":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    Rec.SetRange("Document Type", DocType);

                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);

                    FlowFieldsEditable := false;
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Line",
            DATABASE::"Purchase Line":
                begin
                    FieldRef := RecRef.Field(4);
                    LineNo := FieldRef.Value;
                    Rec.SetRange("Line No.", LineNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Invoice Header",
            DATABASE::"Sales Cr.Memo Header",
            DATABASE::"Purch. Inv. Header",
            DATABASE::"Purch. Cr. Memo Hdr.":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);

                    FlowFieldsEditable := false;
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Invoice Line",
            DATABASE::"Sales Cr.Memo Line",
            DATABASE::"Purch. Inv. Line",
            DATABASE::"Purch. Cr. Memo Line":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Rec.SetRange("No.", RecNo);

                    FieldRef := RecRef.Field(4);
                    LineNo := FieldRef.Value;
                    Rec.SetRange("Line No.", LineNo);

                    FlowFieldsEditable := false;
                end;
        end;

        OnAfterOpenForRecRef(Rec, RecRef);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
    end;

    procedure SetFilters(ModificationPermission: Boolean; DocNo: Code[30])
    begin
        CannotModify := ModificationPermission;
        AttachDocNo := DocNo;
    end;
}