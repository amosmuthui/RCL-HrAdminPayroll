table 51525452 "TImesheet Tasks Undertaken"
{
    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Timesheet Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Task Undertaken"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "TS Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; Year; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Month; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Percentage; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Shortcut Dimension 2 Code"; Code[100])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //Rec.ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(9; Hours; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Approval Status"; Option)
        {
            CalcFormula = Lookup("Employee Timesheet Lines"."Approval Status" WHERE("Line No." = FIELD("TS Line No"),
                                                                                     "TS  No" = FIELD("Timesheet Code")));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Employee,Supervisor,Approved';
            OptionMembers = Employee,Supervisor,Approved;
        }
    }

    keys
    {
        key(Key1; "Entry No", "Timesheet Code", "TS Line No", Month, Year)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[100])
    begin
        //TESTFIELD("Check Printed",FALSE);
        //DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;
}