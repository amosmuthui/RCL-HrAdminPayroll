table 51525376 "Salary Allocation"
{
    DrillDownPageID = "Salary Allocation TT";
    LookupPageID = "Salary Allocation TT";

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Earning Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Earnings.Code WHERE("Non-Cash Benefit" = CONST(false));

            trigger OnValidate()
            begin
                if Earnings.Get("Earning Code") then begin
                    Description := Earnings.Description;
                end;
            end;
        }
        field(3; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Shortcut Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(5; "Shortcut Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(6; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Job ID/Employee ID" = CONST(perEmployee)) Employee."No."
            ELSE
            IF ("Job ID/Employee ID" = CONST(perJobID)) "Company Jobs"."Job ID";
        }
        field(7; "Payroll Period"; Date)
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
            TableRelation = "Payroll Period"."Starting Date";
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin

                if PayPeriod.Get("Payroll Period") then
                    "Pay Period" := PayPeriod.Name;
            end;
        }
        field(8; "Pay Period"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Percentage; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 1;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(481; "Job ID/Employee ID"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',perEmployee,perJobID';
            OptionMembers = ,perEmployee,perJobID;
        }
        field(482; Buffer; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No", "Employee No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        GetPayPeriod;
        "Payroll Period" := PayStartDate;
        "Pay Period" := PayPeriodText;
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        Earnings: Record Earnings;
        PayStartDate: Date;
        PayPeriodText: Text[30];
        PayPeriod: Record "Payroll Period";
        ShortcutDimCode: array[8] of Code[100];


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[100])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[100])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure ShowDimensions()
    begin

        /*"Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", StrSubstNo('%1 %2', '', "Entry No"),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");*/
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[100])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure GetPayPeriod()
    begin
        PayPeriod.SetRange(PayPeriod."Close Pay", false);
        if PayPeriod.FindFirst then
            PayStartDate := PayPeriod."Starting Date";
        PayPeriodText := PayPeriod.Name;
    end;


    procedure UpdateShortcutDimensions()
    var
        DimSet: Record "Dimension Set Entry";
    begin
        /*DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
        "Shortcut Dimension 1 Code":=ShortcutDimCode[1];
        "Shortcut Dimension 2 Code":=ShortcutDimCode[2];
        "Shortcut Dimension 3 Code":=ShortcutDimCode[3];
        "Shortcut Dimension 4 Code":=ShortcutDimCode[4];
        "Shortcut Dimension 5 Code":=ShortcutDimCode[5];
        "Shortcut Dimension 6 Code":=ShortcutDimCode[6];
        "Shortcut Dimension 7 Code":=ShortcutDimCode[7];
        "Shortcut Dimension 8 Code":=ShortcutDimCode[8];*/
        //MODIFY;

    end;

    local procedure Test()
    begin
    end;
}