table 51525360 "Training Allowance Entries"
{
    Caption = 'Training Allowance Entries';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Training Allowance Entries";
    LookupPageId = "Training Allowance Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = false;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Payroll Period"; Date)
        {
            Editable = false;
            TableRelation = "Training Allowance Batches"."Payroll Period";
            Caption = 'Payroll Period';
        }
        field(3; "Class No."; Code[20])
        {
            TableRelation = "Training Schedules"."No.";
            Caption = 'Class No.';
        }
        field(4; "Instructor No."; Code[20])
        {
            TableRelation = Employee."No.";//But must be a set as the trainer for that class
            Caption = 'Instructor No.';
        }
        field(5; "Instructor Name"; Text[250])
        {
            Editable = false;
            Caption = 'Instructor Name';
        }
        field(6; Allowance; Decimal)
        {
            Editable = false;
            Caption = 'Allowance (RWF)';
        }
        field(7; "Class Title"; Text[250])
        {
            Editable = false;
            Caption = 'Class Title';
            FieldClass = FlowField;
            CalcFormula = lookup("Training Schedules"."Training Title" where("No." = field("Class No.")));
        }
        field(8; "Processed"; Boolean)
        {
            Editable = false;
        }
        field(9; "Processing Comments"; Text[250])
        {
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Entry No.", "Payroll Period")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        limitChanges();
    end;

    trigger OnModify()
    begin
        limitChanges();
    end;

    trigger OnDelete()
    begin
        limitChanges();
    end;

    procedure limitChanges()
    var
        Batch: Record "Training Allowance Batches";
    begin
        if Rec."Payroll Period" <> 0D then begin
            Batch.Reset();
            Batch.SetRange("Payroll Period", Rec."Payroll Period");
            Batch.SetFilter(Status, '%1|%2', Batch.Status::Open, Batch.Status::"Pending Amendment");
            if not Batch.FindFirst() then
                Error('You cannot make changes to these entries at this level!');
        end;
    end;
}