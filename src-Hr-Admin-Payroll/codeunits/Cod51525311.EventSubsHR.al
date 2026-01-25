codeunit 51525311 "Event Subs HR"
{
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        EmpNo: Code[20];

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnBeforeSaveAttachment, '', false, false)]
    local procedure t1173_OnBeforeSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
        case RecRef.Number of
            DATABASE::"Payroll Processing Header",
            DATABASE::"Recruitment Needs",
            DATABASE::"Change Request",
            Database::"Training Schedules",
            Database::"Training Request",
             Database::"Memo Header",
              Database::"Shift Header",
            Database::"Travelling Request",
            Database::"Medical Claim Header",
            Database::"Terminal Dues Header":

                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;

            DATABASE::"Training Schedule Lines":
                begin
                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value; //Schedule no
                    FieldRef := RecRef.Field(3);
                    EmpNo := FieldRef.Value; //EmpNo
                    RecNo := RecNo + '-' + EmpNo;// + '-' + Format(LineNo);
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", OnAfterOpenForRecRef, '', false, false)]
    local procedure p1173_OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
        case RecRef.Number of
            DATABASE::"Payroll Processing Header",
            DATABASE::"Recruitment Needs",
            DATABASE::"Change Request",
            Database::"Training Schedules",
            Database::"Training Request",
            Database::"Memo Header",
            Database::"Shift Header",
            Database::"Travelling Request",
            Database::"Medical Claim Header",
            Database::"Terminal Dues Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Training Schedule Lines":
                begin
                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value; //Schedule no
                    FieldRef := RecRef.Field(3);
                    EmpNo := FieldRef.Value; //EmpNo
                    RecNo := RecNo + '-' + EmpNo;// + '-' + Format(LineNo);
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;
}
