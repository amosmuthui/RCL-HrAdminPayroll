page 51525475 "Attached Documents"
{
    ApplicationArea = All;
    Caption = 'Attached Documents';
    PageType = CardPart;
    SourceTable = "Document Attachment";
    Editable = false;
    DeleteAllowed = false;

    /* layout
    { */
    /*  area(Content)
     {
         repeater(General)
         {
             field("File Name"; Rec."File Name")
             {
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
                             if Rec."Portal Doc URL" <> '' then
                                 HyperLink(Rec."Portal Doc URL");
                         end else begin
                             FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
                             if FileName <> '' then
                                 Rec.SaveAttachment(FromRecRef, FileName, TempBlob);
                             CurrPage.Update(false);
                         end;
                     end;
                 end;
             }
             field("File Extension"; Rec."File Extension")
             {
                 ToolTip = 'Specifies the file extension of the attachment.';
             }
             field("Attachment Code"; Rec."Attachment Code")
             {
                 Visible = false;
             }
         }
     }
 }

 var
     FromRecRef: RecordRef;
     SalesDocumentFlow: Boolean;
     FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
     FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
     ImportTxt: Label 'Attach a document.';
     SelectFileTxt: Label 'Select File...'; */

}