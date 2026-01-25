table 51525349 "Additional Instructors"
{
    Caption = 'Additional Instructors';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
            AutoIncrement = true;
        }
        field(2; "Class No."; Code[50])
        {
            Caption = 'Class No.';
            Editable = false;
            TableRelation = "Training Schedules";

            trigger OnValidate()
            var
                Class: Record "Training Schedules";
            begin
                if Class."No." <> '' then begin
                    Class.Reset();
                    Class.SetRange("No.", "Class No.");
                    if Class.FindFirst() then
                        Category := Class."Trainer Category";
                end;
            end;
        }
        field(3; "Category"; Option)
        {
            Caption = 'Category';
            OptionMembers = "Internal",Supplier;
        }
        field(4; "No."; Code[50])
        {
            Caption = 'No.';
            TableRelation = IF ("Category" = CONST("Internal")) "Employee"
            ELSE
            IF ("Category" = CONST(Supplier)) "External Trainers";

            trigger OnValidate()
            var
                ExtTrainer: Record "External Trainers";
                InternalTrainer: Record Employee;
            begin
                if "No." <> '' then begin
                    Name := '';
                    if "Category" = "Category"::"Internal" then begin
                        InternalTrainer.Reset();
                        InternalTrainer.SetRange("No.", "No.");
                        if InternalTrainer.FindFirst() then
                            Name := InternalTrainer."First Name" + ' ' + InternalTrainer."Middle Name" + ' ' + InternalTrainer."Last Name";
                    end;
                    if "Category" = "Category"::Supplier then begin
                        ExtTrainer.Reset();
                        ExtTrainer.SetRange("No.", "No.");
                        if ExtTrainer.FindFirst() then
                            Name := ExtTrainer.Name;
                    end;
                end;
            end;
        }
        field(5; Name; Text[240])
        {
            Caption = 'Name';
        }
        field(6; Allowance; Decimal)
        {
            MinValue = 0;
            Caption = 'Allowance';
        }
    }
    keys
    {
        key(PK; "Entry No.", "Class No.")
        {
            Clustered = true;
        }
    }
}