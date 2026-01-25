table 51525347 "Training Schedule Lines"
{
    Caption = 'Training Schedule Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Editable = false;
            Caption = 'Line No.';
        }
        field(2; "Schedule No."; Code[50])
        {
            Editable = false;
            Caption = 'Schedule No.';
            TableRelation = "Training Schedules"."No.";

            trigger OnValidate()
            var
                SchedHeader: Record "Training Schedules";
            begin
                SchedHeader.Reset();
                SchedHeader.SetRange("No.", "Schedule No.");
                SchedHeader.SetFilter(Frequency, '<>%1', '');
                if SchedHeader.FindFirst() then begin
                    "Renew By" := CalcDate(SchedHeader.Frequency, SchedHeader."Start Date");//SchedHeader."End Date";
                    "Start Date" := SchedHeader."Start Date";
                    "End Date" := SchedHeader."End Date";
                end;
            end;
        }
        field(3; "Emp No."; Code[50])
        {
            Caption = 'Emp No.';
            TableRelation = Employee."No.";

            trigger OnValidate()
            var
                empRec: Record Employee;
            begin
                Section := '';
                "Employee Name" := '';
                "Department Code" := '';
                "Department Name" := '';
                "Job Title" := '';
                if "Emp No." <> '' then begin
                    empRec.Reset();
                    empRec.SetRange("No.", "Emp No.");
                    if empRec.FindFirst() then begin
                        "Employee Name" := empRec."First Name" + ' ' + empRec."Middle Name" + ' ' + empRec."Last Name";
                        if empRec."Responsibility Center" = '' then
                            Error('You must specify the department of the selected employee in the employee card!');
                        "Department Code" := empRec."Responsibility Center";
                        Validate("Department Code");
                        "Job Title" := empRec."Job Title";
                        Section := empRec."Sub Responsibility Center";
                    end;
                end;
            end;
        }
        field(4; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
        }
        field(5; Section; Text[250])
        {
            Editable = false;
            Caption = 'Section';
        }
        field(6; "Job Title"; Text[250])
        {
            Editable = false;
            Caption = 'Job Title';
        }
        field(7; "Training Report"; Text[250])
        {
            Caption = 'Training Report';
        }
        field(24; "Certificate Serial No."; Text[100])
        { }
        field(25; "Renew By"; Date)
        {
            Editable = false;
        }
        field(26; "Legacy Data"; Boolean)
        {
            Editable = false;
        }
        field(27; "Certificate Link"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(28; "Training No."; Code[50])
        {
            TableRelation = "Training Master Plan Header"."No.";
            Caption = 'Course No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Training Schedules"."Training No." where("No." = field("Schedule No.")));
        }
        field(29; "Training Title"; Text[250])
        {
            Caption = 'Event Title';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Training Schedules"."Training Title" where("No." = field("Schedule No.")));
        }
        field(30; "Start Date"; Date)
        {
            Caption = 'Scheduled Date';
            Editable = false;
            //FieldClass = FlowField;
            //CalcFormula = lookup("Training Schedules"."Start Date" where("No." = field("Schedule No.")));
        }
        field(31; "End Date"; Date)
        {
            Caption = 'Completion Date';
            Editable = false;
            //FieldClass = FlowField;
            //CalcFormula = lookup("Training Schedules"."End Date" where("No." = field("Schedule No.")));
        }
        field(32; "Trainer Name"; Text[250])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Training Schedules"."Trainer Name" where("No." = field("Schedule No.")));
        }
        field(33; Frequency; Code[10])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Training Schedules".Frequency where("No." = field("Schedule No.")));
        }
        field(34; "Department Code"; Code[240])
        {
            Editable = false;
            TableRelation = "Responsibility Center".Code;
        }
        field(35; "Department Name"; Text[240])
        {
            Editable = false;

            trigger OnValidate()
            var
                Depts: Record "Responsibility Center";
            begin
                "Department Name" := '';
                if "Department Code" <> '' then begin
                    Depts.Reset();
                    Depts.SetRange(Code, "Department Code");
                    if Depts.FindFirst() then
                        "Department Name" := Depts.Name;
                end;
            end;
        }
        field(36; Status; Option)
        {
            OptionMembers = Pending,Postponed,Ongoing,Done;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Training Schedules".Status where("No." = field("Schedule No.")));
        }
        field(37; "E-Mail"; Text[240])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Company E-Mail" where("No." = field("Emp No.")));
        }
        field(38; "Trainer Category"; Option)
        {
            OptionMembers = "Internal",Supplier;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Training Schedules"."Trainer Category" where("No." = field("Schedule No.")));
        }
        field(39; Type; Option)
        {
            OptionMembers = Initial,Refresher;
        }

    }
    keys
    {
        key(PK; /*"Line No."*/"Emp No.", "Schedule No.")
        {
            Clustered = true;
        }
        key(Key1; "Line No.")
        { }
        key(Key2; "End Date")
        { }
    }

    trigger OnInsert()
    var
        Participants: Record "Training Schedule Lines";
    begin
        "Line No." := 0;
        Participants.Reset();
        Participants.SetRange("Schedule No.", "Schedule No.");
        Participants.SetFilter("Emp No.", '<>%1', '');
        Participants.SetCurrentKey("Line No.");
        Participants.SetAscending("Line No.", true);
        if Participants.FindLast() then
            "Line No." := Participants."Line No." + 1;

        ScheduleHeader.Reset();
        ScheduleHeader.SetRange("No.", "Schedule No.");
        ScheduleHeader.SetRange(Status, ScheduleHeader.Status::Done);
        if ScheduleHeader.FindFirst() then
            Error('You cannot add participants to a completed (Done) class!');
    end;

    trigger OnModify()
    begin
        updateParticipantType();
    end;

    trigger OnDelete()
    begin
        ScheduleHeader.Reset();
        ScheduleHeader.SetRange("No.", "Schedule No.");
        ScheduleHeader.SetRange(Status, ScheduleHeader.Status::Done);
        if ScheduleHeader.FindFirst() then
            Error('You cannot remove participants from a completed (Done) class!');
    end;

    var
        ScheduleHeader: Record "Training Schedules";

    procedure CountCertificates() Attachments: Text
    var
        AttachmentsTable: Record "Document Attachment";
        AttachmentsCount: Integer;
        RecRef: RecordRef;
        "Record": Variant;
    begin
        Attachments := 'Attached Certificates (0)';
        "Record" := Rec;
        RecRef.GetTable(Record);
        AttachmentsTable.Reset();
        AttachmentsTable.SetRange("Table ID", RecRef.Number);
        AttachmentsTable.SetRange("No.", CopyStr(Rec."Schedule No." + '-' + Rec."Emp No."/* + '-' + Format(Rec."Line No.")*/, 1, 20));
        if AttachmentsTable.Find('-') then
            Attachments := 'Attached Certificates (' + format(AttachmentsTable.Count) + ')';
    end;

    procedure updateParticipantType()
    var
        PrevScheduleLine: Record "Training Schedule Lines";
    begin
        //Type := Type::Initial;
        CalcFields("Training No.");
        PrevScheduleLine.Reset();
        PrevScheduleLine.SetFilter("Schedule No.", '<>%1', "Schedule No.");
        PrevScheduleLine.SetRange("Emp No.", "Emp No.");
        PrevScheduleLine.SetRange("Training No.", "Training No.");
        PrevScheduleLine.SetFilter("Start Date", '<=%1', "Start Date");
        if PrevScheduleLine.FindFirst() then
            Type := Type::Refresher;
    end;
}