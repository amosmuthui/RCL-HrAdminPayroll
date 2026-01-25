tableextension 51525303 "Document Attachment Ext" extends "Document Attachment"
{
    /*  trigger OnInsert()
     begin
         if (StrPos("No.", 'PPN') <> 0) then begin
             PayProcessHeader.Reset();
             PayProcessHeader.SetRange("Payroll Processing No", "No.");
             if PayProcessHeader.FindFirst() then
                 if PayProcessHeader.Status <> PayProcessHeader.Status::Open then
                     Error('The payroll card is not open. You cannot add attachments!');
         end;
     end;

     trigger OnDelete()
     begin
         if (StrPos("No.", 'PPN') <> 0) then begin
             PayProcessHeader.Reset();
             PayProcessHeader.SetRange("Payroll Processing No", "No.");
             if PayProcessHeader.FindFirst() then
                 if PayProcessHeader.Status <> PayProcessHeader.Status::Open then
                     Error('The payroll card is not open. You cannot modify attachments!');
         end;
     end;

     var
         PayProcessHeader: Record "Payroll Processing Header"; */
}
