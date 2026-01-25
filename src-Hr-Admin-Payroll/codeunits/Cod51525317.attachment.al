codeunit 51525317 DocAttachSubscriber
{
    [EventSubscriber(
       ObjectType::Table,
       Database::"Document Attachment",
       'OnAfterInitFieldsFromRecRef',
       '',
       false,
       false)]
    local procedure OnAfterInitFieldsFromRecRef(
       var DocumentAttachment: Record "Document Attachment";
       var RecRef: RecordRef)
    var
        MemoHeader: Record "Memo Header";
    begin
        if RecRef.Number <> Database::"Memo Header" then
            exit;

        RecRef.SetTable(MemoHeader);

        DocumentAttachment."Table ID" := Database::"Memo Header";
        DocumentAttachment."No." := MemoHeader."No.";
    end;
}
