table 51525366 "Employee Period Bank Details"
{
    Caption = 'Employee Period Bank Details';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Employee Period Bank Details";
    LookupPageId = "Employee Period Bank Details";

    fields
    {
        field(1; "Emp No."; Code[100])
        {
            Caption = 'Emp No.';
            TableRelation = Employee."No.";
            trigger OnValidate()
            begin
                EmpRec.Reset();
                EmpRec.SetRange("No.", "Emp No.");
                if EmpRec.FindFirst() then begin
                    "First Name" := EmpRec."First Name";
                    "Middle Name" := EmpRec."Middle Name";
                    "Last Name" := EmpRec."Last Name";
                end;
            end;
        }
        field(2; "Payroll Period"; Date)
        {
            Caption = 'Payroll Period';
            TableRelation = "Payroll Period";
        }
        field(3; "Bank Code"; Code[100])
        {
            Caption = 'Bank Code';
            TableRelation = "Bank Account";
        }
        field(4; "Bank Name"; Text[250])
        {
            Caption = 'Bank Name';
        }
        field(5; "Bank Account No."; Code[100])
        {
            Caption = 'Bank Account No.';
        }
        field(6; "Branch Code"; Code[100])
        {
            Caption = 'Branch Code';
        }
        field(7; "Branch Name"; Text[250])
        {
            Caption = 'Branch Name';
        }
        field(8; IBAN; Code[100])
        {
            Caption = 'IBAN';
        }
        field(9; "SWIFT Code"; Code[100])
        {
            Caption = 'SWIFT Code';
        }
        field(10; "Bank Country"; Code[100])
        {
            Caption = 'Bank Country';
            TableRelation = "Country/Region";
        }
        field(11; "Bank Currency"; Code[100])
        {
            Caption = 'Bank Currency';
            TableRelation = Currency;
        }
        field(12; "First Name"; Text[200])
        {
            Caption = 'First Name';
        }
        field(13; "Middle Name"; Text[200])
        {
            Caption = 'Middle Name';
        }
        field(14; "Last Name"; Text[200])
        {
            Caption = 'Last Name';
        }
        field(15; "Sort Code"; Text[250])
        {

        }
        field(16; Indicatif; Text[250])
        {

        }
        field(17; "Code B.I.C."; Text[250])
        {

        }
        field(18; Amount; Decimal)
        {

        }
        field(20; "Payroll Country"; Code[200])
        {
            TableRelation = "Country/Region";
        }
        field(21; "Pay Period Filter"; Date)
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll Period"."Starting Date";
            ValidateTableRelation = true;
        }
        field(22; "Period Movement Last Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Period Prevailing Movement"."Last Date" where("Emp No." = field("Emp No."), "Payroll Period" = field("Payroll Period")));
        }
        field(23; "Current Movement Last Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Internal Employement History"."Last Date" where("Emp No." = field("Emp No."), Status = filter(Current)));
        }
        field(24; "Period Movement Terminal Dues"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Period Prevailing Movement"."Terminal Dues" where("Emp No." = field("Emp No."), "Payroll Period" = field("Payroll Period")));
        }
    }
    keys
    {
        key(PK; "Emp No.", "Payroll Period", "Bank Code")
        {
            Clustered = true;
        }
    }
    var
        EmpRec: Record Employee;
}