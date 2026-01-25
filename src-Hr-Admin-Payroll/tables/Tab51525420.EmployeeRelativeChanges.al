table 51525420 "Employee Relative Changes"
{
    Caption = 'Employee Relative Changes';
    DataCaptionFields = "Employee No.";
    //DrillDownPageID = "Employee Relatives";
    //LookupPageID = "Employee Relatives";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
            Caption = 'Line No.';
        }
        field(3; "Relative Code"; Code[10])
        {
            Caption = 'Relative Code';
            TableRelation = Relative;
        }
        field(4; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(5; "Middle Name"; Text[30])
        {
            Caption = 'Other Names';
        }
        field(6; "Last Name"; Text[30])
        {
            Caption = 'Surname';
        }
        field(7; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(8; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Relative's Employee No."; Code[20])
        {
            Caption = 'Relative''s Employee No.';
            TableRelation = Employee;
        }
        field(10; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST("Employee Relative"),
                                                                     "No." = FIELD("Employee No."),
                                                                     "Table Line No." = FIELD("Line No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; Gender; Option)
        {
            OptionMembers = " ",Female,Male;
        }
        field(12; Relationship; Option)
        {
            OptionMembers = " ",Father,Mother,Spouse,Sister,Brother,Son,Daughter;
        }
        field(13; "Email Address"; Text[150])
        { }
        field(14; "Date Created"; Date)
        {
            Editable = false;
        }
        field(15; "Created By"; Code[100])
        {
            Editable = false;
            TableRelation = User;
        }
        field(16; "Employee Change No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "Change Request"."No.";
        }
    }

    keys
    {
        key(Key1; "Employee Change No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        HRCommentLine: Record "Human Resource Comment Line";
        EmpChanges: Record "Change Request";
    begin
        EmpChanges.CheckDelete("Employee Change No.");
    end;

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Date Created" := Today;
    end;
}